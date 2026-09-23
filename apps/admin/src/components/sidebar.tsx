"use client";

import { useQuery } from "@tanstack/react-query";
import { motion, useReducedMotion } from "framer-motion";
import { BadgeIndianRupee, EyeOff, Flag, HandCoins, Heart, History, House, ShieldCheck, Undo2, Users } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { api, type Dashboard } from "@/lib/api";
import { cn } from "@/lib/utils";
import { Brand, BrandMark } from "./brand";

const NAV = [
  { href: "/", label: "Dashboard", icon: House },
  { href: "/companions", label: "Companions", icon: Heart },
  { href: "/callers", label: "Callers", icon: Users },
  { href: "/kyc", label: "KYC review", icon: ShieldCheck, badge: "kyc" as const },
  { href: "/reports", label: "Reports", icon: Flag, badge: "reports" as const },
  { href: "/moderation", label: "Moderation", icon: EyeOff, badge: "moderation" as const },
  { href: "/payouts", label: "Payouts", icon: HandCoins, badge: "payouts" as const },
  { href: "/refunds", label: "Refunds", icon: Undo2, badge: "refunds" as const },
  { href: "/pricing", label: "Pricing", icon: BadgeIndianRupee },
  { href: "/audit", label: "Audit log", icon: History },
];

export function Sidebar() {
  const path = usePathname();
  const still = useReducedMotion();
  const { data } = useQuery({ queryKey: ["dashboard"], queryFn: () => api<Dashboard>("admin/dashboard"), refetchInterval: 30_000 });

  return (
    <aside className="sticky top-0 hidden h-screen w-60 shrink-0 flex-col overflow-hidden bg-[linear-gradient(180deg,#2A0F3F_0%,#1E0B30_55%,#2B0B35_100%)] text-white md:flex">
      {/* Pink wave glow at the bottom, as in the design */}
      <div aria-hidden className="pointer-events-none absolute inset-x-0 bottom-0 h-72 bg-[radial-gradient(120%_70%_at_20%_100%,rgba(219,39,119,0.45),transparent_60%),radial-gradient(90%_60%_at_100%_80%,rgba(124,58,237,0.35),transparent_65%)]" />
      <div className="relative flex flex-col items-center px-4 pb-8 pt-6 text-center">
        <BrandMark size={60} />
        <p className="mt-3 font-heading text-xl font-extrabold tracking-tight">Hello Dude! <span className="text-white/60">Admin</span></p>
        <p className="mt-0.5 text-[11px] text-white/60">Talk. Vibe. Connect.</p>
      </div>
      <nav className="relative flex flex-1 flex-col gap-1 px-3" aria-label="Sections">
        {NAV.map((item, i) => {
          const active = item.href === "/" ? path === "/" : path.startsWith(item.href);
          const Icon = item.icon;
          const badge = item.badge === "reports" ? data?.openReports : item.badge === "kyc" ? data?.pendingKyc
            : item.badge === "payouts" ? data?.pendingPayouts.count : item.badge === "refunds" ? data?.openRefunds : item.badge === "moderation" ? data?.openModeration : undefined;
          return (
            <Link key={item.href} href={item.href} aria-current={active ? "page" : undefined}
              className={cn("group relative flex items-center gap-3 rounded-xl px-4 py-2.5 text-[15px] font-medium transition-colors",
                active ? "text-white" : "text-white/75 hover:bg-white/5 hover:text-white")}>
              {active && (
                <motion.span layoutId="nav-active"
                  className="absolute inset-0 rounded-xl bg-[linear-gradient(90deg,#EC4899,#DB2777)] shadow-[0_8px_24px_-8px_rgba(236,72,153,0.7)]"
                  transition={{ type: "spring", stiffness: 500, damping: 40 }} />
              )}
              {/* Icons swing gently one after another; the active one also pulses. */}
              <motion.span className="relative grid place-items-center"
                animate={still ? undefined : active
                  ? { rotate: [0, -14, 12, -8, 6, 0], scale: [1, 1.15, 1, 1.1, 1] }
                  : { rotate: [0, -12, 10, -6, 4, 0] }}
                transition={{ duration: 1.4, ease: "easeInOut", repeat: Infinity, repeatDelay: NAV.length * 0.35, delay: i * 0.35 }}>
                <Icon className={cn("size-5 transition-transform duration-200 group-hover:scale-125", !active && "text-pink-300")} />
              </motion.span>
              <span className="relative flex-1">{item.label}</span>
              {!!badge && <span className="relative rounded-full bg-white px-2 py-0.5 text-xs font-bold text-pink-600">{badge}</span>}
            </Link>
          );
        })}
      </nav>
      <div className="relative px-6 pb-8 pt-6">
        <p className="-rotate-6 font-hand text-[26px] leading-[1.05] text-white/90">
          Good<br />Conversations<br />Build a Kinder World
        </p>
        <Heart className="ml-auto mt-1 size-5 fill-pink-500 text-pink-500" aria-hidden />
      </div>
    </aside>
  );
}

/** Small screens: brand + a horizontally scrolling tab row instead of the sidebar. */
export function MobileNav() {
  const path = usePathname();
  return (
    <header className="sticky top-0 z-20 bg-[#1E0B30] text-white md:hidden">
      <div className="px-4 pt-3"><Brand inverted /></div>
      <nav className="flex gap-1 overflow-x-auto px-3 py-2" aria-label="Sections">
        {NAV.map((item) => {
          const active = item.href === "/" ? path === "/" : path.startsWith(item.href);
          return (
            <Link key={item.href} href={item.href} aria-current={active ? "page" : undefined}
              className={cn("shrink-0 rounded-full px-3 py-1.5 text-sm font-medium",
                active ? "bg-pink-600 text-white" : "text-white/70")}>
              {item.label}
            </Link>
          );
        })}
      </nav>
    </header>
  );
}

/** Page title row used by every panel page. */
export function PageHeader({ title, description, children }: { title: string; description?: string; children?: React.ReactNode }) {
  return (
    <div className="mb-6 flex flex-wrap items-end justify-between gap-4">
      <div>
        <h1 className="font-heading text-2xl font-extrabold tracking-tight">{title}</h1>
        {description && <p className="mt-1 text-sm text-muted-foreground">{description}</p>}
      </div>
      {children}
    </div>
  );
}
