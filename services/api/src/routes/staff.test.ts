import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, resetState } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
let owner: string;
let ownerId: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.db.query(`DELETE FROM admin_roles WHERE NOT is_system`);
  // No role given → the trigger makes them a full Admin (as the make-admin script does).
  ownerId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Owner', 'en') RETURNING id`,
  )).rows[0]!.id;
  owner = await tokenFor(h, ownerId, "admin");
});

type Staff = { id: string; roleCode: string; active: boolean; isMe: boolean };

async function addStaff(phone: string, roleCode: string) {
  const r = await call(h, "POST", "/v1/admin/staff", { token: owner, body: { phone, name: `Staff ${phone.slice(-2)}`, roleCode } });
  expect(r.statusCode).toBe(201);
  const s = json<Staff>(r);
  return { ...s, token: await tokenFor(h, s.id, "admin") };
}
const status = async (token: string, method: "GET" | "POST", url: string, body?: unknown) =>
  (await call(h, method, url, { token, body })).statusCode;

describe("admin roles and permissions", () => {
  it("the owner is a full Admin; /admin/me lists every permission", async () => {
    const me = json<{ roleCode: string; permissions: string[] }>(await call(h, "GET", "/v1/admin/me", { token: owner }));
    expect(me.roleCode).toBe("admin");
    expect(me.permissions).toContain("staff.manage");
    expect(me.permissions.length).toBeGreaterThanOrEqual(18);
  });

  it("a moderator reviews reports and KYC but can't touch payouts, prices or staff", async () => {
    const mod = await addStaff("9811100001", "moderator");
    expect(await status(mod.token, "GET", "/v1/admin/reports")).toBe(200);
    expect(await status(mod.token, "GET", "/v1/admin/kyc")).toBe(200);
    expect(await status(mod.token, "GET", "/v1/admin/dashboard")).toBe(200);
    const payouts = await call(h, "GET", "/v1/admin/payouts", { token: mod.token });
    expect(errorCode(payouts)).toBe("NO_PERMISSION");
    expect(json<{ error: { message: string } }>(payouts).error.message).toContain("See payouts");
    expect(errorCode(await call(h, "GET", "/v1/admin/rates", { token: mod.token }))).toBe("NO_PERMISSION");
    expect(errorCode(await call(h, "GET", "/v1/admin/staff", { token: mod.token }))).toBe("NO_PERMISSION");
  });

  it("finance sees and decides payouts and sends coins, but not KYC or users' status", async () => {
    const fin = await addStaff("9811100002", "finance");
    const caller = await createCaller(h, 0);
    expect(await status(fin.token, "GET", "/v1/admin/payouts")).toBe(200);
    expect(await status(fin.token, "GET", "/v1/admin/rates")).toBe(200);
    expect(await status(fin.token, "POST", `/v1/admin/users/${caller}/coins`,
      { coins: 10, reason: "Goodwill credit", requestId: "0b8a6f0e-7a7c-4c5e-9a55-1f7d7a0c0a01" })).not.toBe(403);
    expect(errorCode(await call(h, "GET", "/v1/admin/kyc", { token: fin.token }))).toBe("NO_PERMISSION");
    expect(errorCode(await call(h, "POST", `/v1/admin/users/${caller}/status`,
      { token: fin.token, body: { status: "suspended", reason: "Testing access" } }))).toBe("NO_PERMISSION");
  });

  it("custom roles: create, assign, change permissions (applies at once), delete only when unused", async () => {
    const created = await call(h, "POST", "/v1/admin/roles",
      { token: owner, body: { name: "Support desk", description: "Answers users", permissions: ["users.view"] } });
    expect(created.statusCode).toBe(201);
    const role = json<{ code: string; permissions: string[]; isSystem: boolean }>(created);
    expect(role).toMatchObject({ code: "support_desk", permissions: ["users.view"], isSystem: false });

    const sup = await addStaff("9811100003", "support_desk");
    expect(await status(sup.token, "GET", "/v1/admin/users")).toBe(200);
    expect(errorCode(await call(h, "GET", "/v1/admin/audit", { token: sup.token }))).toBe("NO_PERMISSION");

    // Same token, new permission: works straight away.
    await call(h, "PUT", "/v1/admin/roles/support_desk",
      { token: owner, body: { name: "Support desk", description: "", permissions: ["users.view", "audit.view"] } });
    expect(await status(sup.token, "GET", "/v1/admin/audit")).toBe(200);

    expect(errorCode(await call(h, "DELETE", "/v1/admin/roles/support_desk", { token: owner }))).toBe("ROLE_IN_USE");
    await call(h, "PUT", `/v1/admin/staff/${sup.id}`, { token: owner, body: { roleCode: "moderator" } });
    expect((await call(h, "DELETE", "/v1/admin/roles/support_desk", { token: owner })).statusCode).toBe(204);
    expect(errorCode(await call(h, "DELETE", "/v1/admin/roles/moderator", { token: owner }))).toBe("ROLE_LOCKED");
    expect(errorCode(await call(h, "PUT", "/v1/admin/roles/admin",
      { token: owner, body: { name: "Admin", permissions: [] } }))).toBe("ROLE_LOCKED");
  });

  it("switching someone off locks them out immediately and signs them out", async () => {
    const mod = await addStaff("9811100004", "moderator");
    expect(await status(mod.token, "GET", "/v1/admin/reports")).toBe(200);
    await call(h, "PUT", `/v1/admin/staff/${mod.id}`, { token: owner, body: { active: false } });
    expect(errorCode(await call(h, "GET", "/v1/admin/reports", { token: mod.token }))).toBe("STAFF_INACTIVE");
    const open = (await h.db.query(`SELECT 1 FROM sessions WHERE user_id = $1 AND revoked_at IS NULL`, [mod.id])).rowCount;
    expect(open).toBe(0);
  });

  it("guard rails: not yourself, never zero Admins, staff numbers stay separate from app accounts", async () => {
    expect(errorCode(await call(h, "PUT", `/v1/admin/staff/${ownerId}`, { token: owner, body: { roleCode: "finance" } }))).toBe("NOT_YOURSELF");

    const second = await addStaff("9811100005", "admin");
    // With two Admins, one can move the other to another role…
    await call(h, "POST", "/v1/admin/roles", { token: second.token, body: { name: "Staff lead", permissions: ["staff.manage"] } });
    expect((await call(h, "PUT", `/v1/admin/staff/${ownerId}`, { token: second.token, body: { roleCode: "staff_lead" } })).statusCode).toBe(200);
    // …but the last Admin can't be switched off, even by staff who may manage staff.
    const lead = await tokenFor(h, ownerId, "admin");
    expect(errorCode(await call(h, "PUT", `/v1/admin/staff/${second.id}`, { token: lead, body: { active: false } }))).toBe("LAST_ADMIN");
    expect(errorCode(await call(h, "PUT", `/v1/admin/staff/${second.id}`, { token: lead, body: { roleCode: "finance" } }))).toBe("LAST_ADMIN");

    const appUser = await createCaller(h, 0);
    const phone = (await h.db.query<{ phone: string }>(`SELECT phone FROM users WHERE id = $1`, [appUser])).rows[0]!.phone.slice(3);
    expect(errorCode(await call(h, "POST", "/v1/admin/staff", { token: second.token, body: { phone, name: "Mixed", roleCode: "moderator" } })))
      .toBe("PHONE_IN_APP");
  });

  it("every change is in the audit log", async () => {
    const mod = await addStaff("9811100006", "moderator");
    await call(h, "PUT", `/v1/admin/staff/${mod.id}`, { token: owner, body: { roleCode: "finance" } });
    await call(h, "POST", "/v1/admin/roles", { token: owner, body: { name: "Viewer", permissions: ["dashboard.view"] } });
    const actions = (await h.db.query<{ action: string }>(`SELECT action FROM audit_log ORDER BY id`)).rows.map((r) => r.action);
    expect(actions).toEqual(["staff.add", "staff.role", "role.create"]);
  });
});
