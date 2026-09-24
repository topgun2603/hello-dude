/**
 * Admin panel permissions (RBAC). Staff are users with role 'admin'; each has one
 * admin role (table admin_roles) listing the permissions below. Checked on every
 * admin request against the database, so a role change or deactivation applies
 * at once — not when the access token expires.
 */
import type { FastifyRequest } from "fastify";
import type { Db } from "../db/pool.js";
import { ApiError, forbidden } from "../errors.js";
import { requireAuth } from "./guard.js";

export const PERMISSIONS = {
  "dashboard.view": { group: "Overview", label: "See the dashboard" },
  "audit.view": { group: "Overview", label: "See the audit log" },
  "analytics.view": { group: "Overview", label: "See analytics (revenue, spending, leaderboards)" },
  "users.view": { group: "People", label: "See callers and companions" },
  "users.manage": { group: "People", label: "Suspend or ban, add notes, send messages" },
  "users.coins": { group: "People", label: "Send coins to someone" },
  "users.vip": { group: "People", label: "Give or take away VIP" },
  "kyc.review": { group: "Safety", label: "Review KYC (sees Aadhaar and PAN files)" },
  "companions.video": { group: "Safety", label: "Unlock or lock video calls" },
  "reports.review": { group: "Safety", label: "Resolve reports and hear recordings" },
  "moderation.review": { group: "Safety", label: "Review flagged video frames" },
  "rooms.manage": { group: "Safety", label: "See and end voice rooms and lives" },
  "payouts.view": { group: "Money", label: "See payouts" },
  "payouts.decide": { group: "Money", label: "Approve or reject payouts" },
  "refunds.review": { group: "Money", label: "Decide refund requests" },
  "pricing.manage": { group: "Money", label: "Rates, coin packs, gifts and settings" },
  "engagement.manage": { group: "Growth", label: "Companion levels, bonuses and VIP plans" },
  "promotions.manage": { group: "Growth", label: "Offers popup" },
  "staff.manage": { group: "Staff", label: "Add staff and edit roles" },
} as const;

export type Permission = keyof typeof PERMISSIONS;
export const ALL_PERMISSIONS = Object.keys(PERMISSIONS) as Permission[];
export const isPermission = (p: string): p is Permission => p in PERMISSIONS;

export interface StaffAccess {
  roleCode: string;
  roleName: string;
  permissions: Permission[];
}

/** The staff member's role and permissions, or null if they aren't active staff. */
export async function staffAccess(db: Db, userId: string): Promise<StaffAccess | null> {
  const r = (await db.query<{ code: string; name: string; permissions: string[]; status: string; role: string }>(
    `SELECT a.code, a.name, a.permissions, u.status, u.role
       FROM users u JOIN admin_roles a ON a.code = u.admin_role WHERE u.id = $1`, [userId])).rows[0];
  if (!r || r.role !== "admin" || r.status !== "active") return null;
  // The built-in admin role always has everything, including permissions added later.
  const permissions = r.code === "admin" ? ALL_PERMISSIONS : r.permissions.filter(isPermission);
  return { roleCode: r.code, roleName: r.name, permissions };
}

declare module "fastify" {
  interface FastifyRequest { staff?: StaffAccess }
}

/** preHandler: signed-in, active staff whose role has `permission`. */
export function can(permission: Permission) {
  const admin = requireAuth("admin");
  return async (req: FastifyRequest) => {
    await admin(req);
    const access = await staffAccess(req.server.deps.db, req.auth!.userId);
    if (!access) throw forbidden("STAFF_INACTIVE");
    if (!access.permissions.includes(permission)) {
      throw new ApiError(403, "NO_PERMISSION", `Your role can't do this (needs "${PERMISSIONS[permission].label}")`);
    }
    req.staff = access;
  };
}

/** preHandler: any active staff member (e.g. "who am I" for the panel). */
export function anyStaff() {
  const admin = requireAuth("admin");
  return async (req: FastifyRequest) => {
    await admin(req);
    const access = await staffAccess(req.server.deps.db, req.auth!.userId);
    if (!access) throw forbidden("STAFF_INACTIVE");
    req.staff = access;
  };
}
