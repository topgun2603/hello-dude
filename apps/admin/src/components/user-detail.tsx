"use client";

import { Menu } from "@base-ui/react/menu";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { motion } from "framer-motion";
import {
  ArrowLeft, ArrowRight, Ban, BadgeIndianRupee, CalendarDays, ChevronDown, ChevronRight, CircleCheck, CircleOff, Clock,
  Coins, Copy, Eye, FileText, Flag, Heart, History, IndianRupee, MessageSquareText, Phone, PhoneCall, Receipt, Send,
  ShieldAlert, ShieldCheck, Smartphone, Star, StickyNote, Undo2, UserRound, UserX, Video, Wallet, WalletCards, Crown,
} from "lucide-react";
import Link from "next/link";
import { useMemo, useRef, useState } from "react";
import { toast } from "sonner";
import { DataTable, type Features, type TableFilter } from "@/components/data-table";
import { Field } from "@/components/form-bits";
import { AnimatedNumber } from "@/components/stat-card";
import { StatusDialog, type StatusTarget } from "@/components/users-page";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import {
  api, ApiError, type AdminNote, type AdminUserDetail, type UserAudit, type UserCall, type UserLedgerEntry, type UserPayout,
  type UserPurchase, type UserRefund, type UserReport,
} from "@/lib/api";
import { count, date, dateTime, languageName, REPORT_REASONS, rupees } from "@/lib/format";
import { cn } from "@/lib/utils";
import { useCan } from "@/lib/access";

const when = (iso: string) => <span className="whitespace-nowrap">{dateTime(iso)}</span>;
const duration = (s: number | null) => (s == null ? "—" : s < 60 ? `${s}s` : `${Math.floor(s / 60)}m ${s % 60}s`);
const titleCase = (s: string) => s.replace(/_/g, " ").replace(/^\w/, (c) => c.toUpperCase());
const hoursMinutes = (seconds: number) => {
  const m = Math.round(seconds / 60);
  return m < 60 ? `${m} min total` : `${Math.floor(m / 60)}h ${m % 60}m total`;
};

type Tab = "calls" | "money" | "purchases" | "payouts" | "reports" | "refunds" | "audit";

/** Full profile of one caller or companion: hero, numbers, account facts, quick actions, notes and full history. */
export function UserDetail({ id, role }: { id: string; role: "caller" | "companion" }) {
  const can = useCan();
  const list = role === "caller" ? { href: "/callers", label: "Callers" } : { href: "/companions", label: "Companions" };
  const { data: u, error, isLoading } = useQuery({
    queryKey: ["user", id],
    queryFn: () => api<AdminUserDetail>(`admin/users/${id}`),
    refetchInterval: 30_000,
  });
  const [target, setTarget] = useState<StatusTarget | null>(null);
  const [dialog, setDialog] = useState<"coins" | "message" | "vip" | null>(null);
  const [tab, setTab] = useState<Tab>("calls");
  const historyRef = useRef<HTMLDivElement>(null);
  const notesRef = useRef<HTMLTextAreaElement>(null);

  const crumbs = (
    <nav className="mb-4 flex items-center gap-2 text-sm" aria-label="Breadcrumb">
      <Link href={list.href} className="inline-flex items-center gap-1.5 font-medium text-muted-foreground hover:text-foreground">
        <ArrowLeft className="size-4" /> {list.label}
      </Link>
      {u && <><ChevronRight className="size-3.5 text-muted-foreground/60" /><span className="font-semibold">{u.displayName}</span></>}
    </nav>
  );
  if (error) {
    return <>{crumbs}<div className="rounded-3xl border bg-white py-16 text-center text-muted-foreground">
      {error instanceof ApiError && error.status === 404 ? "This account doesn't exist." : error.message}
    </div></>;
  }
  if (isLoading || !u) return <>{crumbs}<DetailSkeleton /></>;

  const isCompanion = u.role === "companion";
  const k = u.companion;
  const active = u.status === "active";
  const openTab = (t: Tab) => {
    setTab(t);
    historyRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
  };
  const copyId = () => navigator.clipboard.writeText(u.id).then(() => toast.success("User ID copied"));
  const talkedSeconds = u.calls.reduce((n, c) => n + (c.seconds ?? 0), 0);

  return (
    <>
      {crumbs}
      <Hero u={u} onCopyId={copyId} onStatus={(status) => setTarget({ user: u, status })}
        onCoins={() => setDialog("coins")} onMessage={() => setDialog("message")} onNote={() => notesRef.current?.focus()}
        onVip={() => setDialog("vip")} />

      {/* Numbers */}
      <div className="mb-5 grid grid-cols-2 gap-4 md:grid-cols-3 2xl:grid-cols-6">
        {isCompanion ? (
          <>
            <Stat i={0} tone="orange" icon={<IndianRupee />} label="Earnings balance" value={u.earningsPaise} format={rupees}
              action={{ label: "View payouts", onClick: () => openTab("payouts") }} />
            <Stat i={1} tone="blue" icon={<WalletCards />} label="Earned all time" value={u.stats.paiseEarned + u.stats.giftsReceivedPaise}
              format={rupees} hint={`${rupees(u.stats.giftsReceivedPaise)} from ${count(u.stats.giftsReceived)} gifts`} />
            <Stat i={2} tone="purple" icon={<Star />} label="Rating" value={k?.rating ?? null} format={(n) => `${n.toFixed(1)} ★`}
              hint={k?.ratingCount ? `${k.ratingCount} ratings` : "No ratings yet"} />
            <Stat i={3} tone="green" icon={<PhoneCall />} label="Calls taken" value={u.stats.calls} hint={`${u.stats.missedCalls} missed`} />
          </>
        ) : (
          <>
            <Stat i={0} tone="orange" icon={<Coins />} label="Coin balance" value={u.coins}
              action={{ label: "View wallet", onClick: () => openTab("money") }} />
            <Stat i={1} tone="blue" icon={<Phone />} label="Coins spent on calls" value={u.stats.coinsSpent}
              hint={`${count(u.stats.calls)} calls • ${count(u.stats.giftsSentCoins)} coins on gifts`} />
            <Stat i={2} tone="purple" icon={<Wallet />} label="Total recharges"
              value={u.purchases.filter((p) => p.status === "credited").reduce((n, p) => n + p.pricePaise, 0)} format={rupees}
              hint={`${u.purchases.length} purchase${u.purchases.length === 1 ? "" : "s"}`} />
            <Stat i={3} tone="green" icon={<PhoneCall />} label="Calls made" value={u.stats.calls} hint={`${u.stats.missedCalls} missed`} />
          </>
        )}
        <Stat i={4} tone="pink" icon={<Clock />} label="Minutes talked" value={u.stats.minutes} hint={talkedSeconds ? hoursMinutes(talkedSeconds) : "Total duration"} />
        <Stat i={5} tone="amber" icon={<ShieldAlert />} label="Reports against" value={u.stats.reportsAgainst}
          hint={`${u.stats.reportsMade} made by them`} />
      </div>

      {/* Account + actions + notes */}
      <div className="mb-6 grid gap-5 lg:grid-cols-[minmax(0,1.25fr)_minmax(0,1fr)]">
        <Panel title="Account Information">
          <Facts rows={[
            [<Clock key="i" className="text-violet-500" />, "Last sign-in", u.lastSignInAt ? dateTime(u.lastSignInAt) : "—"],
            [<History key="i" className="text-sky-500" />, "Last active in app", u.online ? "Now" : u.lastActiveAt ? dateTime(u.lastActiveAt) : "—"],
            [<Smartphone key="i" className="text-pink-500" />, "Devices / sessions",
              `${u.devices} device${u.devices === 1 ? "" : "s"}, ${u.activeSessions} active session${u.activeSessions === 1 ? "" : "s"}`],
            [<ShieldCheck key="i" className="text-pink-600" />, "18+ and terms accepted", u.termsAcceptedAt ? dateTime(u.termsAcceptedAt) : "—"],
            isCompanion
              ? [<Heart key="i" className="fill-pink-500 text-pink-500" />, "Favourited by", `${count(u.stats.followers)} callers`]
              : [<Heart key="i" className="fill-pink-500 text-pink-500" />, "Favourites", `${count(u.stats.favourites)} companions`],
            [<UserX key="i" className="text-pink-500" />, "Blocks", <span key="v">Blocked by {u.stats.blockedBy} <span className="mx-1.5 text-muted-foreground">·</span> Blocking {u.stats.blocking}</span>],
            [<Star key="i" className="fill-pink-500 text-pink-500" />, "Ratings given", count(u.stats.ratingsGiven)],
            ...(isCompanion && k ? [
              [<ShieldCheck key="i" className="text-emerald-500" />, "KYC", <span key="v" className="flex items-center gap-2">
                <Pill tone={k.kycStatus === "approved" ? "green" : k.kycStatus === "rejected" ? "red" : "amber"}>{k.kycStatus ?? "not started"}</Pill>
                {k.kycVerifiedAt && <span className="text-muted-foreground">on {date(k.kycVerifiedAt)}</span>}
              </span>],
              [<Video key="i" className="text-violet-500" />, "Video calls", k.videoEnabled ? "Unlocked" : "Locked"],
              [<Star key="i" className="text-amber-500" />, "Academy", <span key="v" className="flex items-center gap-2.5">
                <span className="h-2 w-28 overflow-hidden rounded-full bg-[#F1EEF7]">
                  <span className="block h-full rounded-full bg-[linear-gradient(90deg,#10B981,#0E7490)]"
                    style={{ width: `${k.academyTotal ? (k.academyPassed / k.academyTotal) * 100 : 0}%` }} />
                </span>
                {k.academyPassed}/{k.academyTotal} lessons
              </span>],
              [<History key="i" className="text-sky-500" />, "Last online", k.lastOnlineAt ? dateTime(k.lastOnlineAt) : "Never"],
              [<BadgeIndianRupee key="i" className="text-emerald-600" />, "UPI", k.upiId ?? "Not added"],
            ] as const : []),
          ]} />
          {isCompanion && k?.bio && <p className="mt-3 rounded-2xl bg-[#FAF7FD] p-3 text-sm text-muted-foreground">“{k.bio}”</p>}
        </Panel>

        <div className="flex flex-col gap-5">
          <Panel title="Quick Actions">
            <div className="grid grid-cols-2 gap-3 2xl:grid-cols-4">
              {isCompanion
                ? <QuickAction icon={<Receipt />} label="View payouts" onClick={() => openTab("payouts")} />
                : <QuickAction icon={<Send />} label="Send coins" onClick={() => setDialog("coins")} disabled={u.status === "deleted" || !can("users.coins")} />}
              <QuickAction icon={<MessageSquareText />} label="Send message" onClick={() => setDialog("message")} disabled={u.status === "deleted" || !can("users.manage")} />
              {!can("users.manage") ? null : active
                ? <QuickAction icon={<CircleOff />} label="Suspend user" tone="danger" onClick={() => setTarget({ user: u, status: "suspended" })} />
                : <QuickAction icon={<CircleCheck />} label="Reactivate" tone="success" onClick={() => setTarget({ user: u, status: "active" })}
                    disabled={u.status === "deleted"} />}
              {isCompanion
                ? <QuickAction icon={<FileText />} label="View KYC" tone="violet" href="/kyc" />
                : <QuickAction icon={<Wallet />} label="View wallet" tone="violet" onClick={() => openTab("money")} />}
            </div>
          </Panel>
          <Notes userId={u.id} notes={u.notes} textareaRef={notesRef} />
        </div>
      </div>

      <div ref={historyRef} className="scroll-mt-4">
        <HistoryTabs u={u} tab={tab} onTab={setTab} />
      </div>

      <StatusDialog target={target} onClose={() => setTarget(null)} />
      <SendCoinsDialog open={dialog === "coins"} user={u} onClose={() => setDialog(null)} />
      <SendMessageDialog open={dialog === "message"} user={u} onClose={() => setDialog(null)} />
      <VipDialog open={dialog === "vip"} user={u} onClose={() => setDialog(null)} />
    </>
  );
}

// ---------------------------------------------------------------------------
// Hero

const menuPopup = "min-w-56 rounded-2xl border border-[#EFEAF6] bg-white p-1.5 text-sm shadow-[0_18px_40px_-16px_rgba(76,29,149,0.35)] outline-none origin-(--transform-origin) transition-[transform,opacity] data-[ending-style]:scale-95 data-[ending-style]:opacity-0 data-[starting-style]:scale-95 data-[starting-style]:opacity-0";
const menuItem = "flex cursor-pointer items-center gap-2.5 rounded-xl px-3 py-2 outline-none data-[highlighted]:bg-[#FBF5FD] [&_svg]:size-4 [&_svg]:text-muted-foreground";

function Hero({ u, onCopyId, onStatus, onCoins, onMessage, onNote, onVip }: {
  u: AdminUserDetail; onCopyId: () => void; onStatus: (s: StatusTarget["status"]) => void;
  onCoins: () => void; onMessage: () => void; onNote: () => void; onVip: () => void;
}) {
  const can = useCan();
  const isCompanion = u.role === "companion";
  const active = u.status === "active";
  return (
    <motion.section initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}
      className="relative mb-5 overflow-hidden rounded-3xl border border-[#EFEAF6] bg-white shadow-[0_16px_40px_-26px_rgba(109,40,217,0.45)]">
      {/* Gradient wave */}
      <svg aria-hidden className="absolute inset-x-0 top-0 h-[150px] w-full" viewBox="0 0 1200 150" preserveAspectRatio="none">
        <defs>
          <linearGradient id="hero-wave" x1="0" x2="1" y1="0" y2="0">
            <stop offset="0" stopColor="#7C3AED" />
            <stop offset="0.55" stopColor="#B42BCB" />
            <stop offset="1" stopColor="#DB2777" />
          </linearGradient>
        </defs>
        <path d="M0 0H1200V112C1080 150 960 142 860 118C740 90 650 34 520 40C400 46 330 78 240 70C140 62 60 36 0 44Z" fill="url(#hero-wave)" />
        <path d="M0 44C60 36 140 62 240 70C330 78 400 46 520 40C650 34 740 90 860 118C960 142 1080 150 1200 112" fill="none" stroke="white" strokeOpacity=".25" strokeWidth="2" />
      </svg>
      <p aria-hidden className="absolute right-44 top-6 hidden -rotate-6 text-center font-hand text-[26px] leading-[1.05] text-white/95 lg:block">
        “Real people.<br />&nbsp;&nbsp;Real conversations.”
        <svg viewBox="0 0 200 12" className="ml-auto mt-1 h-3 w-40"><path d="M2 10C60 2 140 2 198 6" stroke="white" strokeWidth="2.5" fill="none" strokeLinecap="round" /></svg>
      </p>

      <div className="absolute right-5 top-5 z-10">
        <Menu.Root>
          <Menu.Trigger className="inline-flex h-11 items-center gap-2 rounded-xl bg-[linear-gradient(90deg,#EC4899,#DB2777)] px-5 text-sm font-semibold text-white shadow-[0_10px_24px_-10px_rgba(219,39,119,0.9)] outline-none transition hover:brightness-110 focus-visible:ring-3 focus-visible:ring-pink-200 data-popup-open:brightness-110">
            Actions <ChevronDown className="size-4" />
          </Menu.Trigger>
          <Menu.Portal>
            <Menu.Positioner sideOffset={8} align="end" className="z-50">
              <Menu.Popup className={menuPopup}>
                {!isCompanion && can("users.coins") && <Menu.Item className={menuItem} onClick={onCoins} disabled={u.status === "deleted"}><Send /> Send coins</Menu.Item>}
                {!isCompanion && can("users.vip") && <Menu.Item className={menuItem} onClick={onVip} disabled={u.status === "deleted"}><Crown /> {u.vip ? "VIP…" : "Give VIP"}</Menu.Item>}
                {can("users.manage") && <Menu.Item className={menuItem} onClick={onMessage} disabled={u.status === "deleted"}><MessageSquareText /> Send message</Menu.Item>}
                {can("users.manage") && <Menu.Item className={menuItem} onClick={onNote}><StickyNote /> Add note</Menu.Item>}
                <Menu.Item className={menuItem} onClick={onCopyId}><Copy /> Copy user ID</Menu.Item>
                {can("users.manage") && <div className="-mx-1.5 my-1.5 h-px bg-[#F1EEF7]" />}
                {!can("users.manage") ? null : active ? (
                  <>
                    <Menu.Item className={cn(menuItem, "text-destructive [&_svg]:text-destructive")} onClick={() => onStatus("suspended")}><CircleOff /> Suspend</Menu.Item>
                    <Menu.Item className={cn(menuItem, "text-destructive [&_svg]:text-destructive")} onClick={() => onStatus("banned")}><Ban /> Ban</Menu.Item>
                  </>
                ) : u.status !== "deleted" && (
                  <Menu.Item className={cn(menuItem, "text-emerald-700 [&_svg]:text-emerald-600")} onClick={() => onStatus("active")}><CircleCheck /> Reactivate</Menu.Item>
                )}
              </Menu.Popup>
            </Menu.Positioner>
          </Menu.Portal>
        </Menu.Root>
      </div>

      <div className="relative flex flex-wrap items-end gap-5 px-6 pb-6 pt-14 sm:px-8">
        <div className="relative shrink-0">
          <div className="grid size-28 place-items-center rounded-full border-[5px] border-white bg-[linear-gradient(135deg,#EC4899,#A21CAF_60%,#7C3AED)] font-heading text-5xl font-extrabold text-white shadow-[0_14px_30px_-12px_rgba(162,28,175,0.7)]">
            {u.displayName.slice(0, 1).toUpperCase()}
          </div>
          <span title={u.takingCalls ? "Taking calls" : u.online ? "App open" : "Offline"}
            className={cn("absolute bottom-2 right-1.5 size-5 rounded-full border-[3px] border-white", u.takingCalls ? "bg-emerald-500" : u.online ? "bg-sky-500" : "bg-slate-300")} />
        </div>
        <div className="min-w-0 flex-1 pb-1">
          <div className="flex flex-wrap items-center gap-3">
            <h1 className="font-heading text-3xl font-extrabold tracking-tight">{u.displayName}</h1>
            <Pill tone={isCompanion ? "green" : "violet"} className="capitalize">{u.role}</Pill>
            {u.vip && (
              <span className="inline-flex items-center gap-1 rounded-full bg-[linear-gradient(90deg,#FDE68A,#F59E0B)] px-3 py-1 text-sm font-bold text-amber-950">
                <Crown className="size-4" /> VIP until {date(u.vip.expiresAt)}
              </span>
            )}
          </div>
          <div className="mt-2.5 flex flex-wrap items-center gap-x-5 gap-y-2 text-[15px] text-foreground/80">
            <span className="flex items-center gap-2 font-mono text-sm">
              {u.phone}
              <button type="button" onClick={onCopyId} title="Copy user ID" aria-label="Copy user ID"
                className="rounded-md p-1 text-muted-foreground hover:bg-muted hover:text-foreground"><Copy className="size-4" /></button>
            </span>
            <span className="capitalize">{u.gender}</span>
            <span>{[u.primaryLanguage, ...u.languages.filter((l) => l !== u.primaryLanguage)].map(languageName).join(", ")}</span>
            <span className="flex items-center gap-2"><CalendarDays className="size-4 text-muted-foreground" /> Joined {date(u.createdAt)}</span>
            <span className="flex flex-wrap items-center gap-2">
              <Pill tone={active ? "green" : "red"} icon={active ? <CircleCheck /> : <CircleOff />} className="capitalize">{u.status}</Pill>
              <Pill tone={u.takingCalls ? "green" : u.online ? "sky" : "slate"}
                icon={<span className={cn("size-2 rounded-full", u.takingCalls ? "bg-emerald-500" : u.online ? "bg-sky-500" : "bg-slate-400")} />}>
                {u.takingCalls ? "Taking calls" : u.online ? (isCompanion ? "In the app" : "Online") : "Offline"}
              </Pill>
              {!can("users.manage") ? null : active ? (
                <button type="button" onClick={() => onStatus("suspended")}
                  className="inline-flex items-center gap-1.5 rounded-full bg-rose-50 px-3.5 py-1.5 text-sm font-medium text-rose-600 transition hover:bg-rose-100">
                  <CircleOff className="size-4" /> Suspend
                </button>
              ) : u.status !== "deleted" && (
                <button type="button" onClick={() => onStatus("active")}
                  className="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-3.5 py-1.5 text-sm font-medium text-emerald-700 transition hover:bg-emerald-100">
                  <CircleCheck className="size-4" /> Reactivate
                </button>
              )}
            </span>
          </div>
        </div>
      </div>
    </motion.section>
  );
}

// ---------------------------------------------------------------------------
// Building blocks

const PILL = {
  green: "bg-emerald-50 text-emerald-700", red: "bg-rose-50 text-rose-600", amber: "bg-amber-50 text-amber-700",
  violet: "bg-violet-100 text-violet-700", slate: "bg-slate-100 text-slate-600", sky: "bg-sky-50 text-sky-700",
} as const;

function Pill({ tone, icon, className, children }: { tone: keyof typeof PILL; icon?: React.ReactNode; className?: string; children: React.ReactNode }) {
  return (
    <span className={cn("inline-flex items-center gap-1.5 rounded-full px-3.5 py-1.5 text-sm font-medium [&_svg]:size-4", PILL[tone], className)}>
      {icon}{children}
    </span>
  );
}

const TONES = {
  orange: { card: "bg-[#FFF6EC] border-[#FDE7CF]", icon: "bg-[#FFE4C4] text-orange-500", action: "bg-[#FFE9D2] text-orange-700 hover:bg-[#FFDDBA]" },
  blue: { card: "bg-[#EEF4FF] border-[#DCE7FD]", icon: "bg-[#DCE8FF] text-blue-600", action: "" },
  purple: { card: "bg-[#F6EFFF] border-[#E9DDFC]", icon: "bg-[#EADCFF] text-violet-600", action: "" },
  green: { card: "bg-[#ECFBF3] border-[#D3F2E2]", icon: "bg-[#D2F5E3] text-emerald-600", action: "" },
  pink: { card: "bg-[#FFF0F4] border-[#FCDDE6]", icon: "bg-[#FFDCE6] text-rose-500", action: "" },
  amber: { card: "bg-[#FFF6EA] border-[#FBE6CB]", icon: "bg-[#FFE7C7] text-amber-600", action: "" },
} as const;

function Stat({ i, tone, icon, label, value, format = (n) => n.toLocaleString("en-IN"), hint, action }: {
  i: number; tone: keyof typeof TONES; icon: React.ReactNode; label: string; value: number | null;
  format?: (n: number) => string; hint?: string; action?: { label: string; onClick: () => void };
}) {
  const t = TONES[tone];
  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.05 + i * 0.05 }}
      whileHover={{ y: -3 }} className={cn("flex flex-col rounded-3xl border p-4 shadow-[0_10px_26px_-22px_rgba(76,29,149,0.5)]", t.card)}>
      <div className="flex items-start gap-3">
        <span className={cn("grid size-11 shrink-0 place-items-center rounded-full [&_svg]:size-5", t.icon)}>{icon}</span>
        <div className="min-w-0">
          <p className="text-sm font-medium text-foreground/75">{label}</p>
          <p className="mt-1 font-heading text-3xl font-extrabold tracking-tight">
            {value === null ? <span className="text-muted-foreground/50">—</span> : <AnimatedNumber value={value} format={format} />}
          </p>
        </div>
      </div>
      <div className="mt-auto pt-3 text-center text-sm text-muted-foreground">
        {action ? (
          <button type="button" onClick={action.onClick}
            className={cn("inline-flex w-full items-center justify-center gap-1.5 rounded-xl py-2 text-sm font-semibold transition", t.action)}>
            {action.label} <ArrowRight className="size-4" />
          </button>
        ) : hint}
      </div>
    </motion.div>
  );
}

function Panel({ title, children, className }: { title: string; children: React.ReactNode; className?: string }) {
  return (
    <section className={cn("rounded-3xl border border-[#EFEAF6] bg-white p-5 shadow-[0_12px_32px_-24px_rgba(109,40,217,0.4)]", className)}>
      <h2 className="mb-3 font-heading text-lg font-bold">{title}</h2>
      {children}
    </section>
  );
}

function Facts({ rows }: { rows: readonly (readonly [React.ReactNode, string, React.ReactNode])[] }) {
  return (
    <dl className="divide-y divide-[#F1EEF7] text-sm">
      {rows.map(([icon, label, value]) => (
        <div key={label} className="flex items-center gap-3 py-2.5">
          <span className="flex [&>svg]:size-[18px]">{icon}</span>
          <dt className="w-48 shrink-0 text-foreground/70">{label}</dt>
          <dd className="min-w-0 flex-1 font-medium">{value}</dd>
        </div>
      ))}
    </dl>
  );
}

const QA_TONES = {
  default: "bg-[#F7F4FC] text-foreground hover:bg-[#EFE9F9] [&_svg]:text-violet-600",
  danger: "bg-rose-50 text-rose-600 hover:bg-rose-100 [&_svg]:text-rose-500",
  success: "bg-emerald-50 text-emerald-700 hover:bg-emerald-100 [&_svg]:text-emerald-600",
  violet: "bg-violet-50 text-violet-700 hover:bg-violet-100 [&_svg]:text-violet-600",
} as const;

function QuickAction({ icon, label, onClick, href, tone = "default", disabled }: {
  icon: React.ReactNode; label: string; onClick?: () => void; href?: string; tone?: keyof typeof QA_TONES; disabled?: boolean;
}) {
  const cls = cn("flex h-12 items-center justify-center gap-2 whitespace-nowrap rounded-2xl px-3 text-sm font-semibold transition hover:-translate-y-0.5 disabled:pointer-events-none disabled:opacity-50 [&_svg]:size-[18px]", QA_TONES[tone]);
  return href
    ? <Link href={href} className={cls}>{icon}{label}</Link>
    : <button type="button" onClick={onClick} disabled={disabled} className={cls}>{icon}{label}</button>;
}

function Notes({ userId, notes, textareaRef }: { userId: string; notes: AdminNote[]; textareaRef: React.RefObject<HTMLTextAreaElement | null> }) {
  const can = useCan();
  const qc = useQueryClient();
  const [body, setBody] = useState("");
  const save = useMutation({
    mutationFn: () => api<AdminNote>(`admin/users/${userId}/notes`, { method: "POST", body: { body } }),
    onSuccess: () => {
      toast.success("Note saved");
      setBody("");
      qc.invalidateQueries({ queryKey: ["user", userId] });
    },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Panel title="Notes" className="flex-1">
      <div className="relative">
        <Textarea ref={textareaRef} value={body} onChange={(e) => setBody(e.target.value)} maxLength={2000}
          placeholder="Add admin notes about this user…" aria-label="New note"
          className="min-h-24 resize-none rounded-2xl border-[#ECE7F4] pb-14 focus-visible:border-pink-300 focus-visible:ring-pink-200/60" />
        <button type="button" disabled={!body.trim() || save.isPending || !can("users.manage")} onClick={() => save.mutate()}
          className="absolute bottom-2.5 right-2.5 h-9 rounded-xl bg-[linear-gradient(90deg,#7C3AED,#9333EA)] px-4 text-sm font-semibold text-white shadow-[0_8px_18px_-8px_rgba(124,58,237,0.9)] transition hover:brightness-110 disabled:opacity-50">
          {save.isPending ? "Saving…" : "Save Note"}
        </button>
      </div>
      {notes.length > 0 && (
        <ul className="mt-3 max-h-52 space-y-2 overflow-y-auto pr-1">
          {notes.map((n) => (
            <li key={n.id} className="rounded-2xl bg-[#FAF7FD] px-3.5 py-2.5 text-sm">
              <p className="whitespace-pre-wrap">{n.body}</p>
              <p className="mt-1 text-xs text-muted-foreground">{n.author} · {dateTime(n.createdAt)}</p>
            </li>
          ))}
        </ul>
      )}
    </Panel>
  );
}

function DetailSkeleton() {
  return (
    <div className="space-y-5">
      <div className="h-48 animate-pulse rounded-3xl bg-muted" />
      <div className="grid grid-cols-2 gap-4 md:grid-cols-3 2xl:grid-cols-6">
        {Array.from({ length: 6 }, (_, i) => <div key={i} className="h-32 animate-pulse rounded-3xl bg-muted" />)}
      </div>
      <div className="grid gap-5 lg:grid-cols-2"><div className="h-72 animate-pulse rounded-3xl bg-muted" /><div className="h-72 animate-pulse rounded-3xl bg-muted" /></div>
    </div>
  );
}

// ---------------------------------------------------------------------------
// Dialogs

function SendCoinsDialog({ open, user, onClose }: { open: boolean; user: AdminUserDetail; onClose: () => void }) {
  const qc = useQueryClient();
  const [coins, setCoins] = useState("50");
  const [reason, setReason] = useState("");
  // One id per opened dialog: a double click or retry can't credit twice.
  const [requestId, setRequestId] = useState("");
  const [wasOpen, setWasOpen] = useState(false);
  if (open !== wasOpen) {
    setWasOpen(open);
    if (open) { setRequestId(crypto.randomUUID()); setCoins("50"); setReason(""); }
  }
  const n = Number(coins);
  const valid = Number.isInteger(n) && n >= 1 && n <= 10_000 && reason.trim().length >= 3;
  const send = useMutation({
    mutationFn: () => api<{ coins: number }>(`admin/users/${user.id}/coins`, { method: "POST", body: { coins: n, reason, requestId } }),
    onSuccess: (r) => {
      toast.success(`Sent ${n} coins to ${user.displayName}. New balance ${r.coins}.`);
      qc.invalidateQueries({ queryKey: ["user", user.id] });
      qc.invalidateQueries({ queryKey: ["users"] });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Send coins to {user.displayName}</DialogTitle>
          <DialogDescription>Free coins go straight into their wallet, show as “From support” in their history, and are saved in the audit log.</DialogDescription>
        </DialogHeader>
        <Field label="Coins" htmlFor="gc-coins" hint="1 to 10,000">
          <div className="flex flex-wrap gap-2">
            <Input id="gc-coins" type="number" min={1} max={10000} value={coins} onChange={(e) => setCoins(e.target.value)} className="w-32" />
            {[10, 50, 100, 500].map((v) => (
              <Button key={v} type="button" size="sm" variant={n === v ? "default" : "outline"} onClick={() => setCoins(String(v))}>{v}</Button>
            ))}
          </div>
        </Field>
        <Field label="Reason (saved in the audit log)" htmlFor="gc-reason">
          <Textarea id="gc-reason" value={reason} onChange={(e) => setReason(e.target.value)} placeholder="e.g. Call dropped twice, goodwill credit" />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={!valid || send.isPending} onClick={() => send.mutate()}>{send.isPending ? "Sending…" : `Send ${valid ? n : ""} coins`}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function VipDialog({ open, user, onClose }: { open: boolean; user: AdminUserDetail; onClose: () => void }) {
  const qc = useQueryClient();
  const [days, setDays] = useState("30");
  const [reason, setReason] = useState("");
  const [wasOpen, setWasOpen] = useState(false);
  if (open !== wasOpen) {
    setWasOpen(open);
    if (open) { setDays("30"); setReason(""); }
  }
  const n = Number(days);
  const done = (msg: string) => {
    toast.success(msg);
    qc.invalidateQueries({ queryKey: ["user", user.id] });
    onClose();
  };
  const grant = useMutation({
    mutationFn: () => api<{ expiresAt: string }>(`admin/users/${user.id}/vip`, { method: "POST", body: { days: n, reason } }),
    onSuccess: (r) => done(`${user.displayName} is VIP until ${date(r.expiresAt)}`),
    onError: (e) => toast.error(e.message),
  });
  const revoke = useMutation({
    mutationFn: () => api(`admin/users/${user.id}/vip/revoke`, { method: "POST", body: { reason } }),
    onSuccess: () => done(`VIP ended for ${user.displayName}`),
    onError: (e) => toast.error(e.message),
  });
  const valid = Number.isInteger(n) && n >= 1 && n <= 366 && reason.trim().length >= 3;
  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{user.vip ? `VIP for ${user.displayName}` : `Give ${user.displayName} VIP`}</DialogTitle>
          <DialogDescription>
            {user.vip
              ? `VIP until ${date(user.vip.expiresAt)} (${user.vip.source === "play" ? "bought on Google Play" : "given by an admin"}). Add days, or end it.`
              : "Cheaper calls (the discount in Money settings), first pick in instant match, a gold badge and a free Rose each week."}
          </DialogDescription>
        </DialogHeader>
        <Field label="Days" htmlFor="vip-days" hint="1 to 366 — added after any VIP they already have">
          <div className="flex flex-wrap gap-2">
            <Input id="vip-days" type="number" min={1} max={366} value={days} onChange={(e) => setDays(e.target.value)} className="w-28" />
            {[7, 30, 90].map((v) => (
              <Button key={v} type="button" size="sm" variant={n === v ? "default" : "outline"} onClick={() => setDays(String(v))}>{v} days</Button>
            ))}
          </div>
        </Field>
        <Field label="Reason (saved in the audit log)" htmlFor="vip-reason">
          <Textarea id="vip-reason" value={reason} onChange={(e) => setReason(e.target.value)} placeholder="e.g. Compensation for a bad call experience" />
        </Field>
        <DialogFooter>
          {user.vip && (
            <Button variant="destructive" className="mr-auto" disabled={reason.trim().length < 3 || revoke.isPending} onClick={() => revoke.mutate()}>
              End VIP now
            </Button>
          )}
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={!valid || grant.isPending} onClick={() => grant.mutate()}>{grant.isPending ? "Saving…" : `Give ${valid ? n : ""} days`}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function SendMessageDialog({ open, user, onClose }: { open: boolean; user: AdminUserDetail; onClose: () => void }) {
  const qc = useQueryClient();
  const [title, setTitle] = useState("");
  const [body, setBody] = useState("");
  const [wasOpen, setWasOpen] = useState(false);
  if (open !== wasOpen) {
    setWasOpen(open);
    if (open) { setTitle("Message from Hello Dude!"); setBody(""); }
  }
  const send = useMutation({
    mutationFn: () => api<{ devices: number }>(`admin/users/${user.id}/message`, { method: "POST", body: { title, body } }),
    onSuccess: (r) => {
      if (r.devices) toast.success(`Sent to ${user.displayName}'s phone`);
      else toast.warning(`${user.displayName} has no device with notifications on — the message was logged but not delivered`);
      qc.invalidateQueries({ queryKey: ["user", user.id] });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Message {user.displayName}</DialogTitle>
          <DialogDescription>
            Sent as a push notification to their phone{user.devices ? ` (${user.devices} device${user.devices === 1 ? "" : "s"})` : " — they have no registered device right now"}.
          </DialogDescription>
        </DialogHeader>
        <Field label="Title" htmlFor="pm-title" hint={`${title.length}/60`}>
          <Input id="pm-title" maxLength={60} value={title} onChange={(e) => setTitle(e.target.value)} />
        </Field>
        <Field label="Message" htmlFor="pm-body" hint={`${body.length}/300`}>
          <Textarea id="pm-body" maxLength={300} value={body} onChange={(e) => setBody(e.target.value)} placeholder="Keep it short and kind." />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={!title.trim() || !body.trim() || send.isPending} onClick={() => send.mutate()}>
            <Send /> {send.isPending ? "Sending…" : "Send"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ---------------------------------------------------------------------------
// History tables

const callCol = createColumnHelper<Features, UserCall>();
const ledgerCol = createColumnHelper<Features, UserLedgerEntry>();
const buyCol = createColumnHelper<Features, UserPurchase>();
const payCol = createColumnHelper<Features, UserPayout>();
const reportCol = createColumnHelper<Features, UserReport>();
const refundCol = createColumnHelper<Features, UserRefund>();
const auditCol = createColumnHelper<Features, UserAudit>();

const STATUS_TONE: Record<string, keyof typeof PILL> = {
  ended: "green", active: "green", credited: "green", paid: "green", approved: "green", actioned: "green",
  missed: "amber", ringing: "amber", pending: "amber", requested: "amber", processing: "amber", open: "amber",
  rejected: "red", failed: "red", refunded: "red", dismissed: "slate",
};
const status = (s: string) => <Pill tone={STATUS_TONE[s] ?? "slate"} className="px-2.5 py-0.5 text-xs capitalize">{s}</Pill>;

function HistoryTabs({ u, tab, onTab }: { u: AdminUserDetail; tab: Tab; onTab: (t: Tab) => void }) {
  const isCompanion = u.role === "companion";
  const other = isCompanion ? "/callers" : "/companions";
  // id null = the automatic safety check (no person to open).
  const partyLink = (p: { id: string | null; displayName: string }, href: string) => p.id === null
    ? <span className="font-medium text-muted-foreground">{p.displayName}</span>
    : <Link href={`${href}/${p.id}`} className="font-medium hover:text-primary hover:underline">{p.displayName}</Link>;
  const viewParty = (p: { id: string | null; displayName: string }, href: string) => p.id === null ? null : (
    <Link href={`${href}/${p.id}`} title={`Open ${p.displayName}`} aria-label={`Open ${p.displayName}`}
      className="inline-grid size-8 place-items-center rounded-lg text-muted-foreground hover:bg-[#F4EEFB] hover:text-violet-600"><Eye className="size-4" /></Link>
  );

  const callColumns = useMemo(() => [
    callCol.accessor("createdAt", { header: "When", sortFn: "datetime", cell: (c) => when(c.getValue()) }),
    callCol.accessor((c) => c.other.displayName, { id: "with", header: isCompanion ? "Caller" : "Companion",
      cell: ({ row }) => partyLink(row.original.other, other) }),
    callCol.accessor("type", { header: "Type", cell: (c) => (
      <span className="inline-flex items-center gap-1.5">{c.getValue() === "audio" ? <Phone className="size-3.5 text-violet-500" /> : <Video className="size-3.5 text-pink-500" />}
        {c.getValue() === "audio" ? "Voice" : "Video"}</span>
    ) }),
    callCol.accessor("language", { header: "Language", cell: (c) => languageName(c.getValue()) }),
    callCol.accessor("seconds", { header: "Duration", cell: (c) => duration(c.getValue()) }),
    callCol.accessor("minutes", { header: "Billed (min)" }),
    ...(isCompanion
      ? [callCol.accessor("paise", { header: "Earned", cell: (c) => <b>{rupees(c.getValue())}</b> })]
      : [callCol.accessor("coins", { header: "Coins", cell: (c) => <b>{c.getValue()}</b> })]),
    callCol.accessor("giftCoins", { header: "Gifts", cell: (c) => (c.getValue() ? `${c.getValue()} coins` : "—") }),
    callCol.accessor("status", { header: "Status", cell: (c) => status(c.getValue()) }),
    callCol.accessor("stars", { header: "Rating", cell: (c) => (c.getValue() ? <span className="text-amber-500">{"★".repeat(c.getValue()!)}</span> : "—") }),
    callCol.display({ id: "actions", header: "Actions", cell: ({ row }) => viewParty(row.original.other, other) }),
  ], [isCompanion, other]);

  const ledgerColumns = useMemo(() => [
    ledgerCol.accessor("createdAt", { header: "When", sortFn: "datetime", cell: (c) => when(c.getValue()) }),
    ledgerCol.accessor("wallet", { header: "Wallet", cell: (c) => <Pill tone={c.getValue() === "coins" ? "amber" : "green"} className="px-2.5 py-0.5 text-xs capitalize">{c.getValue()}</Pill> }),
    ledgerCol.accessor("type", { header: "Type", cell: (c) => titleCase(c.getValue()) }),
    ledgerCol.accessor("amount", { header: "Amount", cell: ({ row }) => {
      const { amount, wallet } = row.original;
      return <b className={amount < 0 ? "text-destructive" : "text-success"}>
        {amount > 0 ? "+" : "−"}{wallet === "earnings" ? rupees(Math.abs(amount)) : `${Math.abs(amount)} coins`}
      </b>;
    } }),
    ledgerCol.accessor("balanceAfter", { header: "Balance after", cell: ({ row }) =>
      row.original.wallet === "earnings" ? rupees(row.original.balanceAfter) : `${row.original.balanceAfter} coins` }),
    ledgerCol.accessor((l) => l.note ?? "", { id: "note", header: "Note", enableSorting: false,
      cell: (c) => <span className="text-muted-foreground">{c.getValue() || "—"}</span> }),
  ], []);

  const purchaseColumns = useMemo(() => [
    buyCol.accessor("createdAt", { header: "When", sortFn: "datetime", cell: (c) => when(c.getValue()) }),
    buyCol.accessor((p) => p.label ?? p.sku, { id: "pack", header: "Pack" }),
    buyCol.accessor("coins", { header: "Coins credited", cell: (c) => <b>{c.getValue()}</b> }),
    buyCol.accessor("pricePaise", { header: "Price", cell: (c) => rupees(c.getValue()) }),
    buyCol.accessor("status", { header: "Status", cell: (c) => status(c.getValue()) }),
  ], []);

  const payoutColumns = useMemo(() => [
    payCol.accessor("createdAt", { header: "Requested", sortFn: "datetime", cell: (c) => when(c.getValue()) }),
    payCol.accessor("grossPaise", { header: "Gross", cell: (c) => rupees(c.getValue()) }),
    payCol.accessor("tdsPaise", { header: "TDS", cell: (c) => rupees(c.getValue()) }),
    payCol.accessor("netPaise", { header: "Net paid", cell: (c) => <b>{rupees(c.getValue())}</b> }),
    payCol.accessor("upiId", { header: "UPI", enableSorting: false, cell: (c) => <span className="font-mono text-xs">{c.getValue()}</span> }),
    payCol.accessor("status", { header: "Status", cell: ({ row }) => <span title={row.original.failureReason ?? undefined}>{status(row.original.status)}</span> }),
    payCol.accessor((p) => p.processedAt ?? "", { id: "processedAt", header: "Processed", cell: (c) => (c.getValue() ? when(c.getValue()) : "—") }),
  ], []);

  const reportColumns = useMemo(() => [
    reportCol.accessor("createdAt", { header: "When", sortFn: "datetime", cell: (c) => when(c.getValue()) }),
    reportCol.accessor((r) => (r.direction === "against" ? "Against them" : "Made by them"), { id: "direction", header: "Direction",
      cell: (c) => <Pill tone={c.getValue() === "Against them" ? "red" : "slate"} className="px-2.5 py-0.5 text-xs">{c.getValue()}</Pill> }),
    reportCol.accessor((r) => r.other.displayName, { id: "other", header: "Other person", cell: ({ row }) => partyLink(row.original.other, other) }),
    reportCol.accessor("reason", { header: "Reason", cell: (c) => REPORT_REASONS[c.getValue()] ?? c.getValue() }),
    reportCol.accessor((r) => r.details ?? "", { id: "details", header: "Details", enableSorting: false,
      cell: (c) => <span className="line-clamp-2 max-w-72 text-muted-foreground">{c.getValue() || "—"}</span> }),
    reportCol.accessor("status", { header: "Status", cell: (c) => status(c.getValue()) }),
    reportCol.display({ id: "actions", header: "Actions", cell: ({ row }) => viewParty(row.original.other, other) }),
  ], [other]);

  const refundColumns = useMemo(() => [
    refundCol.accessor("createdAt", { header: "Asked", sortFn: "datetime", cell: (c) => when(c.getValue()) }),
    refundCol.accessor((f) => (f.byUser ? "Asked by them" : "On their call"), { id: "who", header: "Who" }),
    refundCol.accessor("reason", { header: "Reason", cell: (c) => titleCase(c.getValue()) }),
    refundCol.accessor("coinsEligible", { header: "Eligible" }),
    refundCol.accessor("coinsRefunded", { header: "Refunded", cell: (c) => <b>{c.getValue()}</b> }),
    refundCol.accessor("status", { header: "Status", cell: (c) => status(c.getValue()) }),
  ], []);

  const auditColumns = useMemo(() => [
    auditCol.accessor("createdAt", { header: "When", sortFn: "datetime", cell: (c) => when(c.getValue()) }),
    auditCol.accessor("actor", { header: "Admin" }),
    auditCol.accessor("action", { header: "Action", cell: (c) => <span className="rounded-md bg-[#F4EEFB] px-2 py-0.5 font-mono text-xs text-violet-700">{c.getValue()}</span> }),
    auditCol.accessor((a) => JSON.stringify(a.details), { id: "details", header: "Details", enableSorting: false,
      cell: (c) => <span className="line-clamp-2 max-w-md font-mono text-xs text-muted-foreground">{c.getValue()}</span> }),
  ], []);

  const dateFilter = (label: string, column = "createdAt"): TableFilter => ({ type: "date", column, label });
  const name = `${u.role}-${u.displayName.toLowerCase().replace(/\W+/g, "-")}`;
  const tabs: { id: Tab; label: string; body: React.ReactNode }[] = [
    { id: "calls", label: "Call History", body: (
      <DataTable columns={callColumns} data={u.calls} exportName={`${name}-calls`} rowNumbers
        searchPlaceholder={`Search by ${isCompanion ? "caller" : "companion"} name…`}
        emptyState={{ icon: <PhoneCall />, title: "No call history found", hint: `This user hasn't ${isCompanion ? "taken" : "made"} any calls yet.` }}
        filters={[
          { type: "select", column: "status", label: "Statuses" },
          { type: "select", column: "type", label: "Types", format: (v) => (v === "audio" ? "Voice" : "Video") },
          { type: "select", column: "language", label: "Languages", format: languageName },
          dateFilter("Date"),
        ]} />
    ) },
    { id: "money", label: "Transactions", body: (
      <DataTable columns={ledgerColumns} data={u.ledger} exportName={`${name}-transactions`} rowNumbers
        searchPlaceholder="Search type or note…"
        emptyState={{ icon: <Wallet />, title: "No transactions yet", hint: "Coin and earnings movements appear here." }}
        filters={[
          { type: "select", column: "wallet", label: "Wallets" },
          { type: "select", column: "type", label: "Types", format: titleCase },
          dateFilter("Date"),
        ]} />
    ) },
    isCompanion
      ? { id: "payouts", label: "Payouts", body: (
          <DataTable columns={payoutColumns} data={u.payouts} exportName={`${name}-payouts`} search={false} rowNumbers
            emptyState={{ icon: <Receipt />, title: "No withdrawals yet", hint: "UPI payout requests appear here." }}
            filters={[{ type: "select", column: "status", label: "Statuses" }, dateFilter("Requested")]} />
        ) }
      : { id: "purchases", label: "Purchases", body: (
          <DataTable columns={purchaseColumns} data={u.purchases} exportName={`${name}-purchases`} rowNumbers
            emptyState={{ icon: <Coins />, title: "No purchases yet", hint: "Coin packs bought on Google Play appear here." }}
            filters={[{ type: "select", column: "status", label: "Statuses" }, dateFilter("Date")]} />
        ) },
    { id: "reports", label: "Reports", body: (
      <DataTable columns={reportColumns} data={u.reports} exportName={`${name}-reports`} rowNumbers
        emptyState={{ icon: <Flag />, title: "No reports", hint: "Reports made by or against this user appear here." }}
        filters={[
          { type: "select", column: "direction", label: "Directions" },
          { type: "select", column: "reason", label: "Reasons", format: (v) => REPORT_REASONS[v] ?? v },
          { type: "select", column: "status", label: "Statuses" },
          dateFilter("Date"),
        ]} />
    ) },
    { id: "refunds", label: "Refunds", body: (
      <DataTable columns={refundColumns} data={u.refunds} exportName={`${name}-refunds`} search={false} rowNumbers
        emptyState={{ icon: <Undo2 />, title: "No refund requests", hint: "Refunds asked for on this user's calls appear here." }}
        filters={[{ type: "select", column: "status", label: "Statuses" }, { type: "select", column: "reason", label: "Reasons", format: titleCase }, dateFilter("Asked")]} />
    ) },
    { id: "audit", label: "Admin Actions", body: (
      <DataTable columns={auditColumns} data={u.audit} exportName={`${name}-admin-actions`} rowNumbers
        emptyState={{ icon: <UserRound />, title: "No admin actions", hint: "Suspensions, coins, messages and notes by admins appear here." }}
        filters={[{ type: "select", column: "action", label: "Actions" }, dateFilter("Date")]} />
    ) },
  ];

  return (
    <Tabs value={tab} onValueChange={(v) => onTab(v as Tab)}>
      <TabsList variant="line" className="mb-4 h-auto w-full justify-start gap-1 overflow-x-auto border-b border-[#EFEAF6] p-0">
        {tabs.map((t) => (
          <TabsTrigger key={t.id} value={t.id}
            className="h-11 flex-none rounded-none px-4 text-[15px] text-foreground/70 after:bottom-[-1px]! after:h-[3px]! after:rounded-full after:bg-pink-500! data-active:text-pink-600">
            {t.label}
          </TabsTrigger>
        ))}
      </TabsList>
      {tabs.map((t) => <TabsContent key={t.id} value={t.id}>{t.body}</TabsContent>)}
    </Tabs>
  );
}
