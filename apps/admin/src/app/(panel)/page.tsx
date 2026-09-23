"use client";

import { useQuery } from "@tanstack/react-query";
import { motion } from "framer-motion";
import {
  ArrowDown, ArrowRight, ArrowUp, BadgeCheck, CircleAlert, Flag, Grip, Heart, IdCard, Phone, ShieldCheck, UserRound,
  UsersRound, Video, Wallet,
} from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import { Area, AreaChart, Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { Coin } from "@/components/coin";
import { AnimatedNumber } from "@/components/stat-card";
import { api, type Dashboard, type DashboardEvent, type Report } from "@/lib/api";
import { count, dateTime, REPORT_REASONS, rupees } from "@/lib/format";
import { cn } from "@/lib/utils";

const card = "min-w-0 rounded-3xl border border-[#EFEAF6] bg-white/90 shadow-[0_1px_2px_rgba(20,18,43,0.04),0_12px_32px_-18px_rgba(109,40,217,0.18)] backdrop-blur";
const COINS = "#7C3AED";
const CALLS = "#DB2777";

export default function DashboardPage() {
  const { data: d, error } = useQuery({ queryKey: ["dashboard"], queryFn: () => api<Dashboard>("admin/dashboard"), refetchInterval: 15_000 });

  return (
    <>
      <Hero />
      {error && <p className="mb-4 text-sm text-destructive">{(error as Error).message}</p>}
      <Kpis d={d} />
      <div className="mt-5 grid gap-5 xl:grid-cols-[minmax(0,1.6fr)_minmax(0,1fr)]">
        <HourlyChart d={d} />
        <Supply d={d} />
      </div>
      <div className="mt-5 grid gap-5 lg:grid-cols-2 xl:grid-cols-[minmax(0,1fr)_minmax(0,1.1fr)_minmax(0,0.95fr)]">
        <Activity events={d?.activity} />
        <OpenReports d={d} />
        <div className="flex flex-col gap-5 lg:col-span-2 xl:col-span-1">
          <Attention d={d} />
          <Banner />
        </div>
      </div>
    </>
  );
}

// ---------------------------------------------------------------------------

function Hero() {
  return (
    <section className="relative mb-6 lg:-mt-12">
      <p className="text-[15px] font-medium text-foreground/80">Welcome back 👋</p>
      <h1 className="mt-1 font-heading text-3xl font-extrabold tracking-tight md:text-4xl">Here&apos;s what&apos;s happening</h1>
      <p className="mt-1.5 text-muted-foreground md:text-[17px]">Real people. Real conversations. A kinder, more connected world.</p>
      <GlossyHeart className="pointer-events-none absolute left-[58%] top-2 hidden w-24 -rotate-12 lg:block" />
      <p aria-hidden className="pointer-events-none absolute right-4 top-[4.25rem] hidden -rotate-6 text-right font-hand text-xl leading-[0.95] text-[#3B1D5C] xl:block">
        Different languages.<br />&nbsp;&nbsp;Same vibe. <span className="text-pink-500">♥</span>
      </p>
    </section>
  );
}

function GlossyHeart({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 100 92" className={className} aria-hidden>
      <defs>
        <radialGradient id="heart-fill" cx="35%" cy="30%" r="75%">
          <stop offset="0%" stopColor="#FBCFE8" />
          <stop offset="45%" stopColor="#F472B6" />
          <stop offset="100%" stopColor="#DB2777" />
        </radialGradient>
        <filter id="heart-blur" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="6" /></filter>
      </defs>
      <path d="M50 88C20 66 4 50 4 30 4 15 15 4 29 4c9 0 16 5 21 12C55 9 62 4 71 4c14 0 25 11 25 26 0 20-16 36-46 58Z"
        fill="#F472B6" opacity="0.35" filter="url(#heart-blur)" transform="translate(0 6)" />
      <path d="M50 88C20 66 4 50 4 30 4 15 15 4 29 4c9 0 16 5 21 12C55 9 62 4 71 4c14 0 25 11 25 26 0 20-16 36-46 58Z" fill="url(#heart-fill)" />
      <ellipse cx="30" cy="24" rx="12" ry="7" fill="#fff" opacity="0.45" transform="rotate(-30 30 24)" />
    </svg>
  );
}

// ---------------------------------------------------------------------------

function Delta({ now, before }: { now: number; before: number }) {
  if (before === 0) return null; // no baseline, no percentage
  const pct = Math.round(((now - before) / before) * 100);
  const up = pct >= 0;
  return (
    <span className={cn("inline-flex items-center gap-0.5 rounded-full px-2 py-0.5 text-sm font-bold",
      up ? "bg-emerald-50 text-emerald-600" : "bg-rose-50 text-rose-600")} title="vs yesterday at this time">
      {up ? <ArrowUp className="size-3.5" strokeWidth={3} /> : <ArrowDown className="size-3.5" strokeWidth={3} />}
      {Math.abs(pct)}%
    </span>
  );
}

const TONES = {
  peach: { bg: "bg-[linear-gradient(135deg,#FFF3EE,#FFE9EF)]", border: "border-[#FBE0DA]", icon: "bg-[linear-gradient(135deg,#FDBA74,#FB7185)]" },
  lavender: { bg: "bg-[linear-gradient(135deg,#F5F0FF,#EEE8FF)]", border: "border-[#E6DCFB]", icon: "bg-[linear-gradient(135deg,#A78BFA,#7C3AED)]" },
  mint: { bg: "bg-[linear-gradient(135deg,#ECFBF4,#E3F8F1)]", border: "border-[#CFF0E1]", icon: "bg-[linear-gradient(135deg,#6EE7B7,#10B981)]" },
  cream: { bg: "bg-[linear-gradient(135deg,#FFF9EC,#FFF3DC)]", border: "border-[#F8E9C4]", icon: "bg-[linear-gradient(135deg,#FCD34D,#F59E0B)]" },
};

function Kpi({ index, tone, icon: Icon, art, label, value, badge, hint }: {
  index: number; tone: keyof typeof TONES; icon?: React.ElementType; art?: React.ReactNode; label: string; value: number | undefined;
  badge?: React.ReactNode; hint?: React.ReactNode;
}) {
  const t = TONES[tone];
  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: index * 0.06 }}
      className={cn("flex gap-4 rounded-3xl border p-5 shadow-[0_12px_32px_-22px_rgba(109,40,217,0.35)]", t.bg, t.border)}>
      {art ?? (
        <span className={cn("grid size-14 shrink-0 place-items-center rounded-full text-white shadow-md", t.icon)}>
          {Icon && <Icon className="size-7" />}
        </span>
      )}
      <div className="min-w-0">
        <p className="text-[15px] font-medium">{label}</p>
        <p className="mt-1 flex flex-wrap items-center gap-3">
          <span className="font-heading text-[34px] font-extrabold leading-none tracking-tight">
            {value === undefined ? <span className="text-muted-foreground/40">—</span> : <AnimatedNumber value={value} />}
          </span>
          {badge}
        </p>
        {hint && <p className="mt-3 text-[13px] text-muted-foreground">{hint}</p>}
      </div>
    </motion.div>
  );
}

function Kpis({ d }: { d?: Dashboard }) {
  const liveCalls = d && d.live.voiceCalls + d.live.videoCalls;
  const languagesLive = d?.languages.filter((l) => l.online > 0).length;
  return (
    <div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
      <Kpi index={0} tone="peach" art={<Coin size={60} className="-mt-0.5 self-start drop-shadow-[0_6px_12px_rgba(217,119,6,0.35)]" />} label="Coins spent today" value={d?.today.coinsSpent}
        badge={d && <Delta now={d.today.coinsSpent} before={d.yesterday.coinsSpent} />}
        hint={d && `${count(d.today.minutesBilled)} minutes billed • Companions earned ${rupees(d.today.companionEarningsPaise)}`} />
      <Kpi index={1} tone="lavender" icon={Phone} label="Calls live now" value={liveCalls}
        badge={!!liveCalls && (
          <span className="inline-flex items-center gap-1.5 rounded-full bg-emerald-100 px-2.5 py-0.5 text-sm font-semibold text-emerald-700">
            <span className="relative flex size-2"><span className="absolute inline-flex size-full animate-ping rounded-full bg-emerald-400 opacity-75" /><span className="relative size-2 rounded-full bg-emerald-500" /></span>
            Live
          </span>
        )}
        hint={d && `${d.live.voiceCalls} voice • ${d.live.videoCalls} video${d.live.ringing ? ` • ${d.live.ringing} ringing` : ""}`} />
      <Kpi index={2} tone="mint" icon={UsersRound} label="Companions online" value={d?.live.companionsOnline}
        hint={d && (languagesLive ? `Across ${languagesLive} language${languagesLive === 1 ? "" : "s"}` : "Nobody online right now")} />
      <Kpi index={3} tone="cream" icon={UserRound} label="New sign-ups today" value={d?.today.newUsers}
        badge={d && <Delta now={d.today.newUsers} before={d.yesterday.newUsers} />}
        hint={d && `${count(d.today.newCallers)} callers • ${count(d.today.newCompanions)} companions`} />
    </div>
  );
}

// ---------------------------------------------------------------------------

const hourTick = (h: number) => (h === 0 ? "12a" : h < 12 ? `${h}a` : h === 12 ? "12p" : `${h - 12}p`);
const hourLong = (h: number) => `${h % 12 === 0 ? 12 : h % 12}:00 ${h < 12 ? "AM" : "PM"}`;
const compact = (n: number) => (n >= 1000 ? `${(n / 1000).toFixed(n % 1000 === 0 ? 0 : 1)}K` : String(n));

/**
 * Two small panels on one time axis instead of a dual-axis chart: coins and
 * calls have different scales, and a shared hover shows both for the hour.
 */
function HourlyChart({ d }: { d?: Dashboard }) {
  const data = d?.byHour ?? [];
  const HourTip = ({ active, label }: { active?: boolean; label?: number | string }) => {
    const row = active && label !== undefined ? data.find((r) => r.hour === Number(label)) : undefined;
    if (!row) return null;
    return (
      <div className="rounded-xl bg-[#1E1136] px-3.5 py-2.5 text-[13px] text-white shadow-xl">
        <p className="mb-1.5 font-semibold">{hourLong(row.hour)}</p>
        <p className="flex items-center gap-2"><span className="size-2.5 rounded-full" style={{ background: CALLS }} />{count(row.calls)} calls</p>
        <p className="flex items-center gap-2"><span className="size-2.5 rounded-full" style={{ background: COINS }} />{count(row.coins)} coins</p>
      </div>
    );
  };
  const axis = { tickLine: false, axisLine: false, fontSize: 12, stroke: "#8B87A3" } as const;

  return (
    <section className={cn(card, "p-6")}>
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <h2 className="font-heading text-lg font-bold">Calls and coins by hour</h2>
          <div className="mt-2 flex gap-5 text-[13px] text-muted-foreground">
            <span className="flex items-center gap-2"><span className="size-2.5 rounded-full" style={{ background: CALLS }} />Calls</span>
            <span className="flex items-center gap-2"><span className="size-2.5 rounded-full" style={{ background: COINS }} />Coins spent</span>
          </div>
        </div>
        <span className="rounded-xl border px-3.5 py-1.5 text-sm font-medium">Today · IST</span>
      </div>

      <p className="mt-4 text-xs font-medium text-muted-foreground">Coins</p>
      <div className="h-44">
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={data} syncId="hourly" margin={{ top: 8, right: 8, left: -12, bottom: 0 }}>
            <defs>
              <linearGradient id="coins-fill" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor={COINS} stopOpacity={0.28} />
                <stop offset="100%" stopColor={COINS} stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid vertical={false} stroke="#EFECF5" />
            <XAxis dataKey="hour" hide />
            <YAxis {...axis} allowDecimals={false} tickFormatter={compact} width={48} />
            <Tooltip content={HourTip} cursor={{ stroke: "#C4B5FD", strokeDasharray: "4 4" }} />
            <Area type="monotone" dataKey="coins" name="Coins" stroke={COINS} strokeWidth={2} fill="url(#coins-fill)"
              activeDot={{ r: 5, stroke: "#fff", strokeWidth: 2 }} />
          </AreaChart>
        </ResponsiveContainer>
      </div>

      <p className="mt-2 text-xs font-medium text-muted-foreground">Calls</p>
      <div className="h-32">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data} syncId="hourly" barCategoryGap="28%" margin={{ top: 8, right: 8, left: -12, bottom: 0 }}>
            <defs>
              <linearGradient id="calls-fill" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#EC4899" />
                <stop offset="100%" stopColor="#F9A8D4" />
              </linearGradient>
            </defs>
            <CartesianGrid vertical={false} stroke="#EFECF5" />
            <XAxis dataKey="hour" {...axis} tickFormatter={hourTick} interval={2} />
            <YAxis {...axis} allowDecimals={false} width={48} />
            <Tooltip content={() => null} cursor={{ fill: "rgba(219,39,119,0.06)" }} />
            <Bar dataKey="calls" name="Calls" fill="url(#calls-fill)" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>

      <table className="sr-only">
        <caption>Calls and coins by hour today (IST)</caption>
        <thead><tr><th>Hour</th><th>Calls</th><th>Coins</th></tr></thead>
        <tbody>{data.map((r) => <tr key={r.hour}><td>{hourLong(r.hour)}</td><td>{r.calls}</td><td>{r.coins}</td></tr>)}</tbody>
      </table>
    </section>
  );
}

// ---------------------------------------------------------------------------

const SCRIPT: Record<string, { glyph: string; bg: string }> = {
  ta: { glyph: "த", bg: "bg-orange-100 text-orange-700" },
  te: { glyph: "తె", bg: "bg-amber-100 text-amber-700" },
  kn: { glyph: "ಕ", bg: "bg-yellow-100 text-yellow-700" },
  ml: { glyph: "മ", bg: "bg-emerald-100 text-emerald-700" },
  hi: { glyph: "हि", bg: "bg-rose-100 text-rose-700" },
  bn: { glyph: "বা", bg: "bg-green-100 text-green-700" },
  mr: { glyph: "म", bg: "bg-pink-100 text-pink-700" },
  en: { glyph: "En", bg: "bg-sky-100 text-sky-700" },
};

/** Free companions vs callers waiting decides whether a language needs recruiting. */
function supplyStatus(l: Dashboard["languages"][number]) {
  const free = Math.max(0, l.online - l.inCall);
  if (l.online === 0) return { label: "None", cls: "bg-slate-100 text-slate-500" };
  if (l.ringing > free) return { label: "Short", cls: "bg-rose-50 text-rose-600" };
  if (free < 3) return { label: "Low", cls: "bg-amber-50 text-amber-600" };
  return { label: "Healthy", cls: "bg-emerald-50 text-emerald-600" };
}

function Supply({ d }: { d?: Dashboard }) {
  return (
    <section className={cn(card, "p-6")}>
      <div className="mb-4 flex items-center justify-between">
        <h2 className="font-heading text-lg font-bold">Supply by language</h2>
        <Link href="/companions" className="flex items-center gap-1 text-sm font-medium text-primary hover:underline">
          See all <ArrowRight className="size-4" />
        </Link>
      </div>
      <ul className="space-y-1">
        {d?.languages.map((l) => {
          const s = supplyStatus(l);
          const script = SCRIPT[l.code];
          return (
            <li key={l.code} className="grid grid-cols-[auto_1fr_auto_auto] items-center gap-2 rounded-xl px-1 sm:grid-cols-[auto_1fr_auto_auto_auto] sm:gap-3 sm:px-2 py-1.5 text-sm hover:bg-muted/60">
              <span className={cn("grid size-7 place-items-center rounded-full text-xs font-bold", script?.bg ?? "bg-muted")}>
                {script?.glyph ?? l.code.toUpperCase()}
              </span>
              <span className="font-medium">{l.name}</span>
              <span className="flex w-20 items-center gap-1.5 text-muted-foreground">
                <span className="size-2 rounded-full bg-emerald-500" />{l.online} online
              </span>
              <span className="hidden w-20 items-center gap-1.5 text-muted-foreground sm:flex">
                <span className="size-2 rounded-full bg-slate-300" />{l.inCall} in call
              </span>
              <span className={cn("w-16 rounded-full py-0.5 text-center text-xs font-semibold", s.cls)}>{s.label}</span>
            </li>
          );
        }) ?? Array.from({ length: 8 }, (_, i) => <li key={i} className="h-9 animate-pulse rounded-xl bg-muted/60" />)}
      </ul>
    </section>
  );
}

// ---------------------------------------------------------------------------

const AVATARS = [
  "from-pink-400 to-rose-500", "from-violet-400 to-purple-600", "from-amber-300 to-orange-500",
  "from-emerald-300 to-teal-500", "from-sky-300 to-indigo-500", "from-fuchsia-400 to-pink-600",
];
function Avatar({ id, name }: { id: string; name: string }) {
  const hue = AVATARS[[...id].reduce((n, ch) => n + ch.charCodeAt(0), 0) % AVATARS.length];
  return (
    <span className={cn("grid size-11 shrink-0 place-items-center rounded-full bg-gradient-to-br font-heading font-bold text-white", hue)}>
      {name.trim().charAt(0).toUpperCase() || "?"}
    </span>
  );
}

function ago(iso: string) {
  const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000);
  if (s < 60) return "just now";
  if (s < 3600) return `${Math.floor(s / 60)} min ago`;
  if (s < 86_400) return `${Math.floor(s / 3600)} h ago`;
  return dateTime(iso);
}

function describe(e: DashboardEvent): { icon: React.ElementType; tint: string; text: string; amount?: string } {
  switch (e.kind) {
    case "call": return {
      icon: e.callType === "video" ? Video : Phone, tint: e.callType === "video" ? "bg-pink-50 text-pink-600" : "bg-emerald-50 text-emerald-600",
      text: `${e.callType === "video" ? "Video" : "Voice"} call with ${e.otherName ?? "a caller"} · ${e.minutes ?? 0} min`,
      amount: e.coins ? `+ ${count(e.coins)} coins` : undefined,
    };
    case "signup": return { icon: UserRound, tint: "bg-violet-50 text-violet-600", text: `New ${e.user.role} sign-up` };
    case "kyc_submitted": return { icon: IdCard, tint: "bg-amber-50 text-amber-600", text: "Submitted KYC for review" };
    case "kyc_approved": return { icon: BadgeCheck, tint: "bg-emerald-50 text-emerald-600", text: "Completed KYC verification" };
    case "payout": return { icon: Wallet, tint: "bg-violet-50 text-violet-600", text: `Payout request created${e.paise ? ` · ${rupees(e.paise)}` : ""}` };
    case "report": return { icon: Flag, tint: "bg-rose-50 text-rose-600", text: `Reported ${e.otherName ?? "a user"}` };
  }
}

function Activity({ events }: { events?: DashboardEvent[] }) {
  return (
    <section className={cn(card, "p-6")}>
      <h2 className="mb-3 font-heading text-lg font-bold">Recent activity</h2>
      {events && events.length === 0 && <p className="py-10 text-center text-sm text-muted-foreground">Nothing yet today.</p>}
      <ul className="divide-y divide-[#F1EEF7]">
        {events?.map((e, i) => {
          const x = describe(e);
          const Icon = x.icon;
          return (
            <motion.li key={`${e.kind}-${e.user.id}-${e.at}`} initial={{ opacity: 0, x: -6 }} animate={{ opacity: 1, x: 0 }}
              transition={{ delay: i * 0.03 }} className="flex items-center gap-3 py-2.5">
              <span className={cn("grid size-9 shrink-0 place-items-center rounded-full", x.tint)}><Icon className="size-4" /></span>
              <Avatar id={e.user.id} name={e.user.displayName} />
              <div className="min-w-0 flex-1">
                <p className="truncate text-[15px] font-semibold">{e.user.displayName}</p>
                <p className="truncate text-[13px] text-muted-foreground">{x.text}</p>
              </div>
              <div className="shrink-0 text-right">
                <p className="text-[13px] text-muted-foreground">{ago(e.at)}</p>
                {x.amount && <p className="flex items-center justify-end gap-1 text-[13px] font-bold text-emerald-600"><Coin size={14} />{x.amount}</p>}
              </div>
            </motion.li>
          );
        }) ?? Array.from({ length: 5 }, (_, i) => <li key={i} className="my-2 h-12 animate-pulse rounded-xl bg-muted/60" />)}
      </ul>
    </section>
  );
}

// ---------------------------------------------------------------------------

const REPORT_TABS = [
  { key: "all", label: "All", reasons: null },
  { key: "harassment", label: "Harassment", reasons: ["abuse", "sexual_content"] },
  { key: "spam", label: "Spam", reasons: ["spam"] },
  { key: "fraud", label: "Fraud", reasons: ["fraud"] },
] as const;

function OpenReports({ d }: { d?: Dashboard }) {
  const [tab, setTab] = useState<(typeof REPORT_TABS)[number]["key"]>("all");
  const { data: reports } = useQuery({ queryKey: ["reports", "open", "dashboard"], queryFn: () => api<Report[]>("admin/reports?status=open&limit=50") });
  const active = REPORT_TABS.find((t) => t.key === tab)!;
  const shown = (reports ?? []).filter((r) => !active.reasons || (active.reasons as readonly string[]).includes(r.reason)).slice(0, 5);
  const tabCount = (t: (typeof REPORT_TABS)[number]) =>
    t.reasons ? t.reasons.reduce((n, r) => n + (d?.openReportsByReason[r] ?? 0), 0) : d?.openReports ?? 0;

  return (
    <section className={cn(card, "flex flex-col p-6")}>
      <div className="mb-4 flex items-center justify-between">
        <h2 className="font-heading text-lg font-bold">Open reports</h2>
        <Link href="/reports" className="flex items-center gap-1 text-sm font-medium text-primary hover:underline">
          View all <ArrowRight className="size-4" />
        </Link>
      </div>
      <div className="flex flex-wrap gap-2" role="tablist" aria-label="Report type">
        {REPORT_TABS.map((t) => (
          <button key={t.key} type="button" role="tab" aria-selected={tab === t.key} onClick={() => setTab(t.key)}
            className={cn("rounded-full px-4 py-1.5 text-[13px] font-medium transition-colors",
              tab === t.key ? "bg-[linear-gradient(90deg,#EC4899,#DB2777)] text-white shadow-sm" : "bg-muted text-foreground/75 hover:bg-[#ECE8F4]")}>
            {t.label} <span className="ml-1 opacity-80">{tabCount(t)}</span>
          </button>
        ))}
      </div>
      {shown.length ? (
        <ul className="mt-4 divide-y divide-[#F1EEF7]">
          {shown.map((r) => (
            <li key={r.id}>
              <Link href="/reports" className="flex items-center gap-3 rounded-xl py-2.5 text-sm hover:bg-muted/40">
                <span className="grid size-9 shrink-0 place-items-center rounded-full bg-rose-50 text-rose-600"><Flag className="size-4" /></span>
                <div className="min-w-0 flex-1">
                  <p className="truncate"><b>{r.reporter.displayName}</b> reported <b>{r.reported.displayName}</b></p>
                  <p className="truncate text-[13px] text-muted-foreground">
                    {REPORT_REASONS[r.reason] ?? r.reason}{r.reported.reportsAgainst > 1 && ` · ${r.reported.reportsAgainst} reports against them`}
                  </p>
                </div>
                <span className="shrink-0 text-[13px] text-muted-foreground">{ago(r.createdAt)}</span>
              </Link>
            </li>
          ))}
        </ul>
      ) : (
        <div className="flex flex-1 flex-col items-center justify-center py-8 text-center">
          <span className="grid size-20 place-items-center rounded-full bg-[radial-gradient(circle_at_30%_30%,#fff,#ECEAF2)] shadow-inner">
            <ShieldCheck className="size-10 fill-slate-400 text-white" />
          </span>
          <p className="mt-4 font-heading text-lg font-bold">No open reports</p>
          <p className="mt-2 text-sm text-muted-foreground">That&apos;s great! 🎉</p>
          <p className="mt-1 text-sm text-muted-foreground">We&apos;ll show reports here as soon as someone files one.</p>
        </div>
      )}
    </section>
  );
}

// ---------------------------------------------------------------------------

function Attention({ d }: { d?: Dashboard }) {
  const rows = [
    { label: "KYC waiting for review", n: d?.pendingKyc, icon: IdCard, href: "/kyc" },
    { label: "Payouts requested", n: d?.pendingPayouts.count, icon: Wallet, href: "/payouts",
      extra: d?.pendingPayouts.count ? rupees(d.pendingPayouts.paise) : undefined },
    { label: "Billing exceptions", n: d?.billingExceptions, icon: Grip },
    { label: "Flagged payouts", n: d?.flaggedPayouts, icon: CircleAlert, href: "/payouts" },
  ];
  const total = rows.reduce((n, r) => n + (r.n ?? 0), 0);
  return (
    <section className={cn(card, "p-6")}>
      <h2 className="mb-3 flex items-center gap-2 font-heading text-lg font-bold">
        Needs attention
        <span className={cn("rounded-full px-2 text-xs font-bold text-white", total ? "bg-rose-500" : "bg-slate-300")}>{total}</span>
      </h2>
      <ul className="divide-y divide-[#F1EEF7]">
        {rows.map((r) => {
          const Icon = r.icon;
          const body = (
            <>
              <span className="grid size-8 place-items-center rounded-full bg-pink-50 text-pink-500"><Icon className="size-4" /></span>
              <span className="flex-1">{r.label}</span>
              {r.extra && <span className="text-muted-foreground">{r.extra}</span>}
              <span className={cn("min-w-6 text-right font-semibold", r.n ? "text-rose-600" : "text-foreground/70")}>{r.n ?? "—"}</span>
            </>
          );
          return (
            <li key={r.label}>
              {r.href
                ? <Link href={r.href} className="flex items-center gap-3 rounded-lg py-2.5 text-sm hover:text-primary">{body}</Link>
                : <div className="flex items-center gap-3 py-2.5 text-sm">{body}</div>}
            </li>
          );
        })}
      </ul>
    </section>
  );
}

function Banner() {
  return (
    <div className="relative flex min-h-32 flex-1 items-center overflow-hidden rounded-3xl bg-[linear-gradient(110deg,#FCE7F3_0%,#F9A8D4_55%,#EC4899_100%)] p-6">
      <GlossyHeart className="absolute -left-3 top-2 w-16 opacity-90" />
      <Heart className="absolute bottom-4 left-10 size-4 fill-pink-500 text-pink-500" aria-hidden />
      <svg viewBox="0 0 120 60" className="absolute -right-2 bottom-0 w-44 opacity-40" aria-hidden>
        {[10, 22, 34, 46, 58, 70, 82, 94, 106].map((x, i) => {
          const h = [14, 26, 40, 52, 34, 46, 28, 18, 10][i]!;
          return <rect key={x} x={x} y={60 - h} width="6" height={h} rx="3" fill="#fff" />;
        })}
      </svg>
      <p className="relative ml-14 font-heading text-lg font-bold leading-snug text-[#3B0A2E]">
        More meaningful conversations,<br />a brighter tomorrow.
      </p>
    </div>
  );
}
