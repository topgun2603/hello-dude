"use client";

import { Menu } from "@base-ui/react/menu";
import { useQuery } from "@tanstack/react-query";
import { Bell, CalendarDays, ChevronDown, LogOut } from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import { LoveLoader } from "@/components/love-loader";
import { api, type Dashboard } from "@/lib/api";

const popup = "min-w-56 rounded-2xl border bg-popover p-1.5 text-sm shadow-xl outline-none origin-(--transform-origin) transition-[transform,opacity] data-[ending-style]:scale-95 data-[ending-style]:opacity-0 data-[starting-style]:scale-95 data-[starting-style]:opacity-0";
const item = "flex cursor-default items-center justify-between gap-3 rounded-xl px-3 py-2 outline-none data-[highlighted]:bg-muted";

/** Date, notifications and account menu, shown at the top of every panel page. */
export function TopBar() {
  const { data: d } = useQuery({ queryKey: ["dashboard"], queryFn: () => api<Dashboard>("admin/dashboard"), refetchInterval: 30_000 });
  const today = new Date().toLocaleDateString("en-IN", { weekday: "short", day: "numeric", month: "short", year: "numeric", timeZone: "Asia/Kolkata" });
  const alerts = d ? [
    { label: "KYC waiting for review", n: d.pendingKyc, href: "/kyc" },
    { label: "Open reports", n: d.openReports, href: "/reports" },
    { label: "Video frames to review", n: d.openModeration, href: "/moderation" },
    { label: "Payouts requested", n: d.pendingPayouts.count, href: "/payouts" },
    { label: "Billing exceptions", n: d.billingExceptions, href: "/" },
  ] : [];
  const pending = alerts.reduce((n, a) => n + a.n, 0);

  const [leaving, setLeaving] = useState(false);
  async function logout() {
    setLeaving(true);
    // Minimum time so the loader is seen rather than flashing; it stays up until /login replaces the panel.
    await Promise.all([fetch("/api/auth/logout", { method: "POST" }), new Promise((r) => setTimeout(r, 1200))]);
    // Full load so no signed-in data stays cached in memory.
    window.location.replace("/login");
  }

  return (
    <div className="relative z-10 flex items-center justify-end gap-2 sm:gap-4">
      <LoveLoader show={leaving} title="Signing you out…" subtitle="See you soon, dude ♥" />
      <span className="hidden items-center gap-2 rounded-xl border border-white/80 bg-white/80 px-4 py-2.5 text-sm font-medium shadow-sm backdrop-blur sm:flex">
        <CalendarDays className="size-4 text-muted-foreground" /> {today}
      </span>

      <Menu.Root>
        <Menu.Trigger aria-label={`Notifications${pending ? `, ${pending} need attention` : ""}`}
          className="relative grid size-10 place-items-center rounded-full outline-none hover:bg-white/70 focus-visible:ring-2 focus-visible:ring-ring">
          <Bell className="size-5" />
          {pending > 0 && <span className="absolute right-2 top-1.5 size-2.5 rounded-full bg-pink-500 ring-2 ring-background" />}
        </Menu.Trigger>
        <Menu.Portal>
          <Menu.Positioner sideOffset={8} align="end" className="z-50">
            <Menu.Popup className={popup}>
              <p className="px-3 py-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">Needs attention</p>
              {alerts.map((a) => (
                <Menu.LinkItem key={a.label} className={item} render={<Link href={a.href} />}>
                  {a.label}
                  <span className={a.n ? "rounded-full bg-pink-100 px-2 text-xs font-bold text-pink-700" : "text-muted-foreground"}>{a.n}</span>
                </Menu.LinkItem>
              ))}
            </Menu.Popup>
          </Menu.Positioner>
        </Menu.Portal>
      </Menu.Root>

      <Menu.Root>
        <Menu.Trigger className="flex items-center gap-2.5 rounded-full py-1 pl-1 pr-3 outline-none hover:bg-white/70 focus-visible:ring-2 focus-visible:ring-ring">
          <span className="grid size-10 place-items-center rounded-full bg-[linear-gradient(135deg,#8B5CF6,#DB2777)] font-heading text-lg font-bold text-white">A</span>
          <span className="hidden text-sm font-semibold sm:inline">Admin</span>
          <ChevronDown className="size-4 text-muted-foreground" />
        </Menu.Trigger>
        <Menu.Portal>
          <Menu.Positioner sideOffset={8} align="end" className="z-50">
            <Menu.Popup className={popup}>
              <Menu.Item className={item} onClick={logout}>
                <span className="flex items-center gap-2"><LogOut className="size-4" /> Sign out</span>
              </Menu.Item>
            </Menu.Popup>
          </Menu.Positioner>
        </Menu.Portal>
      </Menu.Root>
    </div>
  );
}
