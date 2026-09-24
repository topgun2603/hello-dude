/**
 * Admin panel staff and roles (RBAC): who works in the panel, and what each role
 * may do. Guard rails: nobody changes their own role or access, the last active
 * Admin can't be removed, the built-in Admin role can't be edited, and a role
 * still given to someone can't be deleted. Every change is audited.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type DbClient } from "../db/pool.js";
import { bearer, me } from "../auth/guard.js";
import { anyStaff, can, ALL_PERMISSIONS, PERMISSIONS, type Permission } from "../auth/permissions.js";
import { maskPhone, normalizeIndianMobile } from "../auth/phone.js";
import { ensureWallets } from "../billing/ledger.js";
import { ApiError, conflict, notFound } from "../errors.js";

const PermissionZ = z.enum(ALL_PERMISSIONS as [Permission, ...Permission[]]);

const Role = z.object({
  code: z.string(),
  name: z.string(),
  description: z.string(),
  permissions: z.array(PermissionZ),
  isSystem: z.boolean(),
  isAdmin: z.boolean().describe("The built-in Admin role: every permission, can't be edited"),
  members: z.number().int(),
}).meta({ id: "AdminRole" });

const Staff = z.object({
  id: z.uuid(),
  displayName: z.string(),
  phone: z.string().describe("Masked"),
  roleCode: z.string(),
  roleName: z.string(),
  active: z.boolean(),
  isMe: z.boolean(),
  createdAt: z.date(),
  lastSignInAt: z.date().nullable(),
}).meta({ id: "AdminStaff" });

const Me = z.object({
  id: z.uuid(),
  displayName: z.string(),
  roleCode: z.string(),
  roleName: z.string(),
  permissions: z.array(PermissionZ),
}).meta({ id: "AdminMe" });

async function audit(c: DbClient, actorId: string, action: string, targetType: string, targetId: string, details: Record<string, unknown>) {
  await c.query(
    `INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, $2, $3, $4, $5)`,
    [actorId, action, targetType, targetId, JSON.stringify(details)],
  );
}

/** Active staff with the full Admin role. */
const activeAdmins = (c: DbClient) =>
  c.query<{ id: string }>(`SELECT id FROM users WHERE role = 'admin' AND admin_role = 'admin' AND status = 'active' FOR UPDATE`);

export const staffRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;
  const base = { tags: ["admin"], security: bearer };
  const manage = can("staff.manage");

  app.get("/admin/me", {
    preHandler: anyStaff(),
    schema: { ...base, summary: "The signed-in staff member, their role and permissions (the panel hides what they can't do)", response: { 200: Me } },
  }, async (req) => {
    const u = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [me(req).userId])).rows[0]!;
    return { id: me(req).userId, displayName: u.display_name, roleCode: req.staff!.roleCode, roleName: req.staff!.roleName, permissions: req.staff!.permissions };
  });

  // --- roles -----------------------------------------------------------------------
  const listRoles = async () => (await db.query<{
    code: string; name: string; description: string; permissions: string[]; is_system: boolean; members: number;
  }>(
    `SELECT r.*, (SELECT count(*) FROM users u WHERE u.admin_role = r.code AND u.role = 'admin')::int AS members
       FROM admin_roles r ORDER BY r.is_system DESC, r.created_at, r.name`)).rows.map((r) => ({
    code: r.code, name: r.name, description: r.description,
    permissions: (r.code === "admin" ? ALL_PERMISSIONS : r.permissions.filter((p): p is Permission => p in PERMISSIONS)),
    isSystem: r.is_system, isAdmin: r.code === "admin", members: r.members,
  }));

  app.get("/admin/roles", {
    preHandler: manage,
    schema: {
      ...base,
      summary: "Roles and the permission catalogue (for the permission grid)",
      response: {
        200: z.object({
          roles: z.array(Role),
          permissions: z.array(z.object({ code: PermissionZ, group: z.string(), label: z.string() })),
        }),
      },
    },
  }, async () => ({
    roles: await listRoles(),
    permissions: ALL_PERMISSIONS.map((code) => ({ code, ...PERMISSIONS[code] })),
  }));

  const RoleInput = z.object({
    name: z.string().trim().min(2).max(40),
    description: z.string().trim().max(200).default(""),
    permissions: z.array(PermissionZ).max(ALL_PERMISSIONS.length),
  });

  app.post("/admin/roles", {
    preHandler: manage,
    schema: { ...base, summary: "Add a custom role", body: RoleInput, response: { 201: Role } },
  }, async (req, reply) => {
    const b = req.body;
    const code = b.name.toLowerCase().normalize("NFKD").replace(/[^a-z0-9]+/g, "_").replace(/^_+|_+$/g, "").slice(0, 32) || "role";
    await tx(db, async (c) => {
      if (!/^[a-z]/.test(code) || (await c.query(`SELECT 1 FROM admin_roles WHERE code = $1`, [code])).rowCount) {
        throw conflict("ROLE_EXISTS", `A role called "${b.name}" already exists`);
      }
      await c.query(`INSERT INTO admin_roles (code, name, description, permissions) VALUES ($1, $2, $3, $4)`,
        [code, b.name, b.description, [...new Set(b.permissions)]]);
      await audit(c, me(req).userId, "role.create", "admin_role", code, { ...b });
    });
    return reply.status(201).send((await listRoles()).find((r) => r.code === code)!);
  });

  app.put("/admin/roles/:code", {
    preHandler: manage,
    schema: { ...base, summary: "Edit a role's name, description and permissions (not the built-in Admin)", params: z.object({ code: z.string() }), body: RoleInput, response: { 200: Role } },
  }, async (req) => {
    const b = req.body;
    await tx(db, async (c) => {
      const before = (await c.query<{ permissions: string[]; is_system: boolean }>(
        `SELECT permissions, is_system FROM admin_roles WHERE code = $1 FOR UPDATE`, [req.params.code])).rows[0];
      if (!before) throw notFound("ROLE_NOT_FOUND");
      if (req.params.code === "admin") throw conflict("ROLE_LOCKED", "The Admin role always has every permission");
      // Built-in roles keep their name; only their permissions and description change.
      await c.query(
        `UPDATE admin_roles SET name = CASE WHEN is_system THEN name ELSE $2 END, description = $3, permissions = $4, updated_at = now()
          WHERE code = $1`, [req.params.code, b.name, b.description, [...new Set(b.permissions)]]);
      await audit(c, me(req).userId, "role.update", "admin_role", req.params.code,
        { before: before.permissions, after: b.permissions });
    });
    return (await listRoles()).find((r) => r.code === req.params.code)!;
  });

  app.delete("/admin/roles/:code", {
    preHandler: manage,
    schema: { ...base, summary: "Delete a custom role nobody has", params: z.object({ code: z.string() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    await tx(db, async (c) => {
      const r = (await c.query<{ is_system: boolean }>(`SELECT is_system FROM admin_roles WHERE code = $1 FOR UPDATE`, [req.params.code])).rows[0];
      if (!r) throw notFound("ROLE_NOT_FOUND");
      if (r.is_system) throw conflict("ROLE_LOCKED", "Built-in roles can't be deleted");
      const used = (await c.query(`SELECT 1 FROM users WHERE admin_role = $1 LIMIT 1`, [req.params.code])).rowCount;
      if (used) throw conflict("ROLE_IN_USE", "Move everyone to another role first");
      await c.query(`DELETE FROM admin_roles WHERE code = $1`, [req.params.code]);
      await audit(c, me(req).userId, "role.delete", "admin_role", req.params.code, {});
    });
    return reply.status(204).send(null);
  });

  // --- staff -----------------------------------------------------------------------
  const listStaff = async (viewer: string) => (await db.query<{
    id: string; display_name: string; phone: string; admin_role: string; role_name: string; status: string; created_at: Date; last_sign_in: Date | null;
  }>(
    `SELECT u.id, u.display_name, u.phone, u.admin_role, r.name AS role_name, u.status, u.created_at,
            (SELECT max(created_at) FROM sessions s WHERE s.user_id = u.id) AS last_sign_in
       FROM users u JOIN admin_roles r ON r.code = u.admin_role
      WHERE u.role = 'admin' ORDER BY u.status = 'active' DESC, u.created_at`)).rows.map((r) => ({
    id: r.id, displayName: r.display_name, phone: maskPhone(r.phone), roleCode: r.admin_role, roleName: r.role_name,
    active: r.status === "active", isMe: r.id === viewer, createdAt: r.created_at, lastSignInAt: r.last_sign_in,
  }));

  app.get("/admin/staff", {
    preHandler: manage,
    schema: { ...base, summary: "Everyone who can sign in to the admin panel", response: { 200: z.array(Staff) } },
  }, async (req) => listStaff(me(req).userId));

  app.post("/admin/staff", {
    preHandler: manage,
    schema: {
      ...base,
      summary: "Add a staff member: they sign in to the panel with this phone number (OTP)",
      body: z.object({ phone: z.string(), name: z.string().trim().min(2).max(40), roleCode: z.string() }),
      response: { 201: Staff },
    },
  }, async (req, reply) => {
    const phone = normalizeIndianMobile(req.body.phone);
    if (!phone) throw new ApiError(400, "PHONE_INVALID", "Enter a 10-digit Indian mobile number");
    const id = await tx(db, async (c) => {
      if (!(await c.query(`SELECT 1 FROM admin_roles WHERE code = $1`, [req.body.roleCode])).rowCount) throw notFound("ROLE_NOT_FOUND");
      const existing = (await c.query<{ role: string }>(`SELECT role FROM users WHERE phone = $1`, [phone])).rows[0];
      if (existing?.role === "admin") throw conflict("ALREADY_STAFF", "This number is already staff");
      // Staff accounts are separate from app accounts, so app data never mixes with admin access.
      if (existing) throw conflict("PHONE_IN_APP", "This number has an app account. Use a different number for staff.");
      const userId = (await c.query<{ id: string }>(
        `INSERT INTO users (phone, gender, role, admin_role, display_name, primary_language, terms_accepted_at)
         VALUES ($1, 'other', 'admin', $2, $3, 'en', now()) RETURNING id`,
        [phone, req.body.roleCode, req.body.name])).rows[0]!.id;
      await ensureWallets(c, userId);
      await audit(c, me(req).userId, "staff.add", "user", userId, { name: req.body.name, role: req.body.roleCode, phone: maskPhone(phone) });
      return userId;
    });
    return reply.status(201).send((await listStaff(me(req).userId)).find((s) => s.id === id)!);
  });

  app.put("/admin/staff/:id", {
    preHandler: manage,
    schema: {
      ...base,
      summary: "Change a staff member's role, or switch their access off/on",
      params: z.object({ id: z.uuid() }),
      body: z.object({ roleCode: z.string().optional(), active: z.boolean().optional() }),
      response: { 200: Staff },
    },
  }, async (req) => {
    const { roleCode, active } = req.body;
    const actor = me(req).userId;
    if (req.params.id === actor) throw conflict("NOT_YOURSELF", "You can't change your own role or access. Ask another admin.");
    await tx(db, async (c) => {
      const s = (await c.query<{ admin_role: string; status: string }>(
        `SELECT admin_role, status FROM users WHERE id = $1 AND role = 'admin' FOR UPDATE`, [req.params.id])).rows[0];
      if (!s) throw notFound("STAFF_NOT_FOUND");
      if (roleCode && !(await c.query(`SELECT 1 FROM admin_roles WHERE code = $1`, [roleCode])).rowCount) throw notFound("ROLE_NOT_FOUND");
      const losesAdmin = s.admin_role === "admin" && s.status === "active" && ((roleCode && roleCode !== "admin") || active === false);
      if (losesAdmin && (await activeAdmins(c)).rows.length <= 1) {
        throw conflict("LAST_ADMIN", "There must always be at least one active Admin");
      }
      await c.query(
        `UPDATE users SET admin_role = COALESCE($2, admin_role),
                          status = CASE WHEN $3::boolean IS NULL THEN status WHEN $3 THEN 'active' ELSE 'suspended' END
          WHERE id = $1`, [req.params.id, roleCode ?? null, active ?? null]);
      // Switched off: sign them out everywhere now.
      if (active === false) {
        await c.query(`UPDATE sessions SET revoked_at = now() WHERE user_id = $1 AND revoked_at IS NULL`, [req.params.id]);
      }
      await audit(c, actor, active === false ? "staff.deactivate" : active === true ? "staff.activate" : "staff.role", "user", req.params.id,
        { before: s.admin_role, role: roleCode, active });
    });
    return (await listStaff(actor)).find((s) => s.id === req.params.id)!;
  });
};
