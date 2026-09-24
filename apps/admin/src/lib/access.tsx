"use client";

import { useQuery } from "@tanstack/react-query";
import { api, type AdminMe, type Permission } from "@/lib/api";

/** The signed-in staff member, their role and permissions. */
export function useMe() {
  return useQuery({ queryKey: ["me"], queryFn: () => api<AdminMe>("admin/me"), staleTime: 60_000, refetchOnWindowFocus: true });
}

/** `can("payouts.decide")` — false until /admin/me has loaded. */
export function useCan() {
  const { data } = useMe();
  return (p: Permission) => !!data?.permissions.includes(p);
}

/** Which permission opens each page (any one of them). The API checks again on every request. */
export const PAGE_ACCESS: { prefix: string; any: Permission[] }[] = [
  { prefix: "/companions", any: ["users.view"] },
  { prefix: "/callers", any: ["users.view"] },
  { prefix: "/kyc", any: ["kyc.review"] },
  { prefix: "/reports", any: ["reports.review"] },
  { prefix: "/moderation", any: ["moderation.review"] },
  { prefix: "/payouts", any: ["payouts.view"] },
  { prefix: "/refunds", any: ["refunds.review"] },
  { prefix: "/pricing", any: ["pricing.manage"] },
  { prefix: "/engagement", any: ["engagement.manage", "rooms.manage"] },
  { prefix: "/promotions", any: ["promotions.manage"] },
  { prefix: "/analytics", any: ["analytics.view"] },
  { prefix: "/audit", any: ["audit.view"] },
  { prefix: "/staff", any: ["staff.manage"] },
  { prefix: "/", any: ["dashboard.view"] },
];

export function pageAllowed(path: string, can: (p: Permission) => boolean): boolean {
  const rule = PAGE_ACCESS.find((r) => (r.prefix === "/" ? path === "/" : path === r.prefix || path.startsWith(`${r.prefix}/`)));
  return !rule || rule.any.some(can);
}
