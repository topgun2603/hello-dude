"use client";

import { useQuery } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { motion } from "framer-motion";
import {
  ArrowDown, ArrowUp, Clock, Coins, Crown, Flag, Flame, IndianRupee, Minus, PhoneCall, PhoneMissed, Star, TrendingUp, UserPlus,
  Users, Wallet,
} from "lucide-react";
import Link from "next/link";
import { useMemo, useState } from "react";
import { Area, AreaChart, Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { DataTable, type Features } from "@/components/data-table";
import { PageHeader } from "@/components/sidebar";
import { UserAvatar } from "@/components/user-avatar";
import { Input } from "@/components/ui/input";
import { api, type AdminAnalytics, type AnalyticsTotals } from "@/lib/api";
import { count, rupees } from "@/lib/format";
import { cn } from "@/lib/utils";

// Brand pair, validated for colour-blind separation and contrast (dataviz validator: all pass).
const VIOLET = "#7C3AED";
const PINK = "#DB2777";
const GRID = "#EFECF5";
const axis = { tickLine: false, axisLine: false, tick: { fill: "#8A86A0", fontSize: 12 } } as const;

const istToday = () => new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Kolkata" }).format(new Date());
const shift = (d: string, days: number) => new Date(Date.parse(`${d}T00:00:00Z`) + days * 86_400_000).toISOString().slice(0, 10);
const shortDay = (d: string) => new Date(`${d}T00:00:00Z`).toLocaleDateString("en-IN", { day: "numeric", month: "short", timeZone: "UTC" });
const longDay = (d: string) => new Date(`${d}T00:00:00Z`).toLocaleDateString("en-IN", { weekday: "short", day: "numeric", month: "short", year: "numeric", timeZone: "UTC" });
const compact = (n: number) => (Math.abs(n) >= 100_000 ? `${(n / 100_000).toFixed(1)}L` : Math.abs(n) >= 1000 ? `${(n / 1000).toFixed(1)}K` : String(n));
const duration = (secs: number) => (secs < 60 ? `${secs}s` : `${Math.floor(secs / 60)}m ${String(secs % 60).padStart(2, "0")}s`);
const hours = (mins: number) => (mins < 60 ? `${mins}m` : `${Math.floor(mins / 60)}h ${mins % 60}m`);
const hourLabel = (h: number) => (h === 0 ? "12a" : h < 12 ? `${h}a` : h === 12 ? "12p" : `${h - 12}p`);

type Preset = "7" | "30" | "90" | "month" | "custom";
const PRESETS: { id: Preset; label: string }[] = [
  { id: "7", label: "7 days" }, { id: "30", label: "30 days" }, { id: "90", label: "90 days" }, { id: "month", label: "This month" }, { id: "custom", label: "Custom" },
];

function rangeFor(p: Preset, custom: { from: string; to: string }) {
  const to = istToday();
  if (p === "custom") return custom;
  if (p === "month") return { from: `${to.slice(0, 8)}01`, to };
  return { from: shift(to, -(Number(p) - 1)), to };
}

export default function AnalyticsPage() {
  const [preset, setPreset] = useState<Preset>("30");
  const [custom, setCustom] = useState({ from: shift(istToday(), -13), to: istToday() });
  const range = rangeFor(preset, custom);
  const valid = range.from <= range.to;
  const { data, isLoading, error } = useQuery({
    queryKey: ["analytics", range.from, range.to],
    queryFn: () => api<AdminAnalytics>(`admin/analytics?from=${range.from}&to=${range.to}`),
    enabled: valid,
    placeholderData: (prev) => prev,
  });

  return (
    <>
      <PageHeader title="Analytics" description="Everything for the dates you pick (India time), compared with the same number of days just before." />

      {/* One filter row above everything it controls. */}
      <div className="mb-6 flex flex-wrap items-center gap-3">
        <div role="radiogroup" aria-label="Date range" className="flex flex-wrap gap-1 rounded-2xl border border-[#EFEAF6] bg-white/90 p-1.5 shadow-sm">
          {PRESETS.map((p) => (
            <button key={p.id} type="button" role="radio" aria-checked={preset === p.id} onClick={() => setPreset(p.id)}
              className={cn("h-9 rounded-xl px-4 text-sm font-semibold transition",
                preset === p.id ? "bg-[linear-gradient(90deg,#8B5CF6,#7C3AED)] text-white shadow-[0_8px_18px_-10px_rgba(124,58,237,0.9)]" : "text-foreground/60 hover:text-foreground")}>
              {p.label}
            </button>
          ))}
        </div>
        {preset === "custom" && (
          <div className="flex items-center gap-2">
            <Input type="date" aria-label="From" className="w-44" value={custom.from} max={custom.to} onChange={(e) => setCustom({ ...custom, from: e.target.value })} />
            <span className="text-muted-foreground">to</span>
            <Input type="date" aria-label="To" className="w-44" value={custom.to} min={custom.from} max={istToday()} onChange={(e) => setCustom({ ...custom, to: e.target.value })} />
          </div>
        )}
        {data && (
          <span className="text-sm text-muted-foreground">
            {longDay(data.range.from)} – {longDay(data.range.to)} · vs {shortDay(data.previous.from)} – {shortDay(data.previous.to)}
          </span>
        )}
      </div>

      {error && <p className="mb-4 rounded-2xl bg-destructive/10 p-4 text-sm text-destructive">{error.message}</p>}
      {!data ? (
        <div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
          {Array.from({ length: 8 }, (_, i) => <div key={i} className="h-32 animate-pulse rounded-3xl bg-white/70" />)}
        </div>
      ) : (
        <div className={cn("space-y-6 transition-opacity", isLoading && "opacity-60")}>
          <Tiles t={data.totals} p={data.previousTotals} />
          <div className="grid gap-6 xl:grid-cols-[1fr_380px]">
            <Trend data={data} />
            <Margin m={data.margin} t={data.totals} />
          </div>
          <div className="grid gap-6 lg:grid-cols-2 2xl:grid-cols-3">
            <Languages rows={data.byLanguage} />
            <VoiceVideo rows={data.byType} />
            <Hours rows={data.byHour} />
          </div>
          <Leaderboards data={data} />
          <DailyTable rows={data.daily} />
        </div>
      )}
    </>
  );
}

// --- Tiles ------------------------------------------------------------------------------

function Delta({ now, before, invert = false }: { now: number; before: number; invert?: boolean }) {
  if (!before && !now) return <span className="text-xs text-muted-foreground">No activity either period</span>;
  if (!before) return <span className="inline-flex items-center gap-1 text-xs font-semibold text-emerald-700"><ArrowUp className="size-3.5" /> New this period</span>;
  const pct = Math.round(((now - before) / before) * 100);
  const good = invert ? pct < 0 : pct > 0;
  const Icon = pct === 0 ? Minus : pct > 0 ? ArrowUp : ArrowDown;
  return (
    <span className={cn("inline-flex items-center gap-1 text-xs font-semibold", pct === 0 ? "text-muted-foreground" : good ? "text-emerald-700" : "text-rose-600")}>
      <Icon className="size-3.5" /> {pct > 0 ? "+" : ""}{pct}% vs before
    </span>
  );
}

function Tiles({ t, p }: { t: AnalyticsTotals; p: AnalyticsTotals }) {
  const tiles: { label: string; icon: React.ElementType; value: string; now: number; before: number; hint?: string; invert?: boolean }[] = [
    { label: "Coin sales", icon: IndianRupee, value: rupees(t.salesPaise), now: t.salesPaise, before: p.salesPaise, hint: `${count(t.purchases)} purchases · ${count(t.payingCallers)} buyers` },
    { label: "Coins spent", icon: Coins, value: count(t.coinsSpent), now: t.coinsSpent, before: p.coinsSpent, hint: `${count(t.coinsOnCalls)} calls · ${count(t.coinsOnLives)} lives · ${count(t.coinsOnGifts)} gifts · ${count(t.coinsRefunded)} refunded` },
    { label: "Companion earnings", icon: Wallet, value: rupees(t.companionEarningsPaise), now: t.companionEarningsPaise, before: p.companionEarningsPaise, hint: "Calls, gifts and bonuses" },
    { label: "Connected calls", icon: PhoneCall, value: count(t.connectedCalls), now: t.connectedCalls, before: p.connectedCalls, hint: `${count(t.minutes)} minutes · avg ${duration(t.avgCallSeconds)}` },
    { label: "Active callers", icon: Users, value: count(t.activeCallers), now: t.activeCallers, before: p.activeCallers, hint: "Had at least one call" },
    { label: "New sign-ups", icon: UserPlus, value: count(t.newCallers + t.newCompanions), now: t.newCallers + t.newCompanions, before: p.newCallers + p.newCompanions, hint: `${count(t.newCallers)} callers · ${count(t.newCompanions)} companions` },
    { label: "Average rating", icon: Star, value: t.avgRating === null ? "—" : `${t.avgRating.toFixed(2)} ★`, now: Math.round((t.avgRating ?? 0) * 100), before: Math.round((p.avgRating ?? 0) * 100), hint: `${count(t.ratings)} ratings` },
    { label: "Missed calls", icon: PhoneMissed, value: count(t.missedCalls), now: t.missedCalls, before: p.missedCalls, hint: `Companions online ${hours(t.companionOnlineMinutes)} in total`, invert: true },
  ];
  return (
    <div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
      {tiles.map((x, i) => (
        <motion.div key={x.label} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.03 }}
          className="rounded-3xl border border-[#E7E4F0] bg-white p-5 shadow-[0_12px_32px_-24px_rgba(109,40,217,0.35)]">
          <div className="flex items-center justify-between gap-2">
            <p className="text-sm font-medium text-muted-foreground">{x.label}</p>
            <span className="grid size-9 place-items-center rounded-xl bg-violet-50 text-violet-600"><x.icon className="size-4.5" /></span>
          </div>
          <p className="mt-1 font-heading text-[28px] font-extrabold tracking-tight">{x.value}</p>
          <Delta now={x.now} before={x.before} invert={x.invert} />
          {x.hint && <p className="mt-1.5 text-xs text-muted-foreground">{x.hint}</p>}
        </motion.div>
      ))}
    </div>
  );
}

// --- Trend: one measure at a time (never two y-scales) ------------------------------------

const METRICS = [
  { key: "coinsSpent", label: "Coins spent", fmt: (n: number) => count(n) },
  { key: "salesPaise", label: "Coin sales", fmt: (n: number) => rupees(n) },
  { key: "earningsPaise", label: "Companion earnings", fmt: (n: number) => rupees(n) },
  { key: "calls", label: "Calls", fmt: (n: number) => count(n) },
  { key: "minutes", label: "Minutes", fmt: (n: number) => count(n) },
  { key: "activeCallers", label: "Active callers", fmt: (n: number) => count(n) },
  { key: "newCallers", label: "New callers", fmt: (n: number) => count(n) },
] as const;
type MetricKey = (typeof METRICS)[number]["key"];

function Card({ title, subtitle, children, className, right }: { title: string; subtitle?: string; children: React.ReactNode; className?: string; right?: React.ReactNode }) {
  return (
    <section className={cn("rounded-3xl border border-[#E7E4F0] bg-white p-6 shadow-[0_12px_32px_-24px_rgba(109,40,217,0.35)]", className)}>
      <div className="mb-4 flex flex-wrap items-start justify-between gap-3">
        <div>
          <h2 className="font-heading text-lg font-bold">{title}</h2>
          {subtitle && <p className="mt-0.5 text-sm text-muted-foreground">{subtitle}</p>}
        </div>
        {right}
      </div>
      {children}
    </section>
  );
}

function Trend({ data }: { data: AdminAnalytics }) {
  const [metric, setMetric] = useState<MetricKey>("coinsSpent");
  const m = METRICS.find((x) => x.key === metric)!;
  const money = metric === "salesPaise" || metric === "earningsPaise";
  const series = data.daily.map((d) => ({ date: d.date, value: money ? d[metric] / 100 : d[metric] }));
  const total = data.daily.reduce((n, d) => n + d[metric], 0);
  return (
    <Card title={`${m.label} by day`} subtitle={`${m.fmt(total)} in total`}
      right={
        <div role="radiogroup" aria-label="Measure" className="flex flex-wrap gap-1">
          {METRICS.map((x) => (
            <button key={x.key} type="button" role="radio" aria-checked={metric === x.key} onClick={() => setMetric(x.key)}
              className={cn("h-8 rounded-full px-3.5 text-xs font-semibold transition",
                metric === x.key ? "bg-violet-600 text-white" : "bg-[#F4F1FA] text-foreground/70 hover:text-foreground")}>
              {x.label}
            </button>
          ))}
        </div>
      }>
      <div className="h-72">
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={series} margin={{ top: 8, right: 8, left: 0, bottom: 0 }}>
            <defs>
              <linearGradient id="trend-fill" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor={VIOLET} stopOpacity={0.22} />
                <stop offset="100%" stopColor={VIOLET} stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid vertical={false} stroke={GRID} />
            <XAxis dataKey="date" {...axis} tickFormatter={shortDay} minTickGap={24} />
            <YAxis {...axis} width={56} allowDecimals={money} tickFormatter={(v: number) => (money ? `₹${compact(v)}` : compact(v))} />
            <Tooltip cursor={{ stroke: "#C4B5FD", strokeDasharray: "4 4" }}
              content={({ active, payload, label }) => active && payload?.length ? (
                <div className="rounded-xl border bg-white px-3 py-2 text-sm shadow-lg">
                  <p className="font-semibold">{longDay(String(label))}</p>
                  <p className="text-muted-foreground">{m.label}: <b className="text-foreground">{m.fmt(money ? Number(payload[0]!.value) * 100 : Number(payload[0]!.value))}</b></p>
                </div>
              ) : null} />
            <Area type="monotone" dataKey="value" name={m.label} stroke={VIOLET} strokeWidth={2} fill="url(#trend-fill)"
              activeDot={{ r: 5, stroke: "#fff", strokeWidth: 2 }} dot={series.length <= 14 ? { r: 3, fill: VIOLET, strokeWidth: 0 } : false} />
          </AreaChart>
        </ResponsiveContainer>
      </div>
    </Card>
  );
}

// --- Margin (estimate) ---------------------------------------------------------------------

function Margin({ m, t }: { m: AdminAnalytics["margin"]; t: AnalyticsTotals }) {
  const gst = Math.round(t.salesPaise - t.salesPaise / (1 + m.gstPct / 100));
  const fee = Math.round(t.salesPaise / (1 + m.gstPct / 100) - m.netRevenuePaise);
  const rows = [
    { label: "Coin sales (incl. GST)", paise: t.salesPaise },
    { label: `GST (${m.gstPct}%)`, paise: -gst },
    { label: `Store / payment fees (~${m.storeFeePct}%)`, paise: -fee },
    { label: "Net revenue", paise: m.netRevenuePaise, strong: true },
    { label: "Paid to companions", paise: -m.companionCostPaise },
    { label: "LiveKit (estimate)", paise: -m.infraPaise },
  ];
  const pct = m.marginPct;
  const onTarget = pct !== null && pct >= m.targetPct;
  return (
    <Card title="Margin" subtitle="Estimate · fees vary by payment method (change the % in Pricing → Settings)">
      <dl className="space-y-2.5 text-sm">
        {rows.map((r) => (
          <div key={r.label} className={cn("flex items-center justify-between gap-3", r.strong && "border-t pt-2.5 font-semibold")}>
            <dt className={r.strong ? "" : "text-muted-foreground"}>{r.label}</dt>
            <dd className={cn("tabular-nums", r.paise < 0 && "text-rose-600")}>{r.paise < 0 ? `−${rupees(-r.paise)}` : rupees(r.paise)}</dd>
          </div>
        ))}
        <div className="flex items-center justify-between gap-3 border-t pt-3 text-base font-bold">
          <dt>Margin</dt>
          <dd className={cn("tabular-nums", m.marginPaise < 0 && "text-rose-600")}>{m.marginPaise < 0 ? `−${rupees(-m.marginPaise)}` : rupees(m.marginPaise)}</dd>
        </div>
      </dl>
      <div className="mt-5">
        <div className="flex items-baseline justify-between">
          <span className="font-heading text-3xl font-extrabold">{pct === null ? "—" : `${pct}%`}</span>
          <span className="text-sm text-muted-foreground">Target {m.targetPct}%</span>
        </div>
        <div className="relative mt-2 h-2.5 rounded-full bg-[#F1EEF7]" role="img" aria-label={pct === null ? "No sales yet" : `Margin ${pct}% of net revenue, target ${m.targetPct}%`}>
          <div className={cn("h-full rounded-full", onTarget ? "bg-emerald-500" : "bg-amber-500")} style={{ width: `${Math.max(0, Math.min(100, pct ?? 0))}%` }} />
          <div className="absolute -top-1 h-4.5 w-0.5 rounded bg-foreground/60" style={{ left: `${m.targetPct}%` }} />
        </div>
        <p className="mt-2 text-xs text-muted-foreground">
          {pct === null ? "No coin sales in this period yet." : onTarget ? "At or above target." : "Below target."} Share of net revenue kept after paying companions.
        </p>
      </div>
    </Card>
  );
}

// --- Breakdowns ---------------------------------------------------------------------------

function Languages({ rows }: { rows: AdminAnalytics["byLanguage"] }) {
  const max = Math.max(1, ...rows.map((r) => r.minutes));
  return (
    <Card title="By language" subtitle="Minutes talked">
      <ul className="space-y-3">
        {rows.map((r) => (
          <li key={r.code} className="grid grid-cols-[84px_1fr_auto] items-center gap-3 text-sm" title={`${r.calls} calls · ${r.coins} coins`}>
            <span className="font-medium">{r.name}</span>
            <span className="h-3 rounded-r-[4px] bg-[#F4F1FA]">
              <span className="block h-full rounded-r-[4px]" style={{ width: `${(r.minutes / max) * 100}%`, background: VIOLET }} />
            </span>
            <span className="w-20 text-right tabular-nums text-muted-foreground">{count(r.minutes)} min</span>
          </li>
        ))}
      </ul>
    </Card>
  );
}

function VoiceVideo({ rows }: { rows: AdminAnalytics["byType"] }) {
  const get = (t: "audio" | "video") => rows.find((r) => r.type === t) ?? { calls: 0, minutes: 0, coins: 0 };
  const v = get("audio"), vid = get("video");
  const total = v.coins + vid.coins;
  const share = (n: number) => (total ? Math.round((n / total) * 100) : 0);
  return (
    <Card title="Voice vs video" subtitle="Share of coins spent on calls">
      {/* 100% bar, 2px surface gap between the two parts; labelled directly. */}
      <div className="flex h-4 gap-0.5 overflow-hidden rounded-full bg-[#F4F1FA]">
        {total > 0 && <span style={{ width: `${share(v.coins)}%`, background: VIOLET }} />}
        {total > 0 && <span style={{ width: `${share(vid.coins)}%`, background: PINK }} />}
      </div>
      <div className="mt-5 grid grid-cols-2 gap-4">
        {[{ label: "Voice", c: VIOLET, r: v }, { label: "Video", c: PINK, r: vid }].map((x) => (
          <div key={x.label} className="rounded-2xl bg-[#FAF7FD] p-4">
            <p className="flex items-center gap-2 text-sm font-semibold"><span className="size-2.5 rounded-full" style={{ background: x.c }} />{x.label} · {share(x.r.coins)}%</p>
            <p className="mt-2 font-heading text-2xl font-extrabold">{count(x.r.coins)} <span className="text-sm font-medium text-muted-foreground">coins</span></p>
            <p className="text-xs text-muted-foreground">{count(x.r.calls)} calls · {count(x.r.minutes)} min</p>
          </div>
        ))}
      </div>
    </Card>
  );
}

function Hours({ rows }: { rows: AdminAnalytics["byHour"] }) {
  const busiest = rows.reduce((a, b) => (b.calls > a.calls ? b : a), rows[0] ?? { hour: 0, calls: 0, minutes: 0 });
  return (
    <Card title="Busiest hours" subtitle={busiest.calls ? `Peak at ${hourLabel(busiest.hour)} (${busiest.calls} calls)` : "Calls started per hour (IST)"}>
      <div className="h-52">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={rows} barCategoryGap="22%" margin={{ top: 8, right: 4, left: -16, bottom: 0 }}>
            <CartesianGrid vertical={false} stroke={GRID} />
            <XAxis dataKey="hour" {...axis} tickFormatter={hourLabel} interval={3} />
            <YAxis {...axis} allowDecimals={false} width={40} />
            <Tooltip cursor={{ fill: "rgba(124,58,237,0.06)" }}
              content={({ active, payload }) => active && payload?.length ? (
                <div className="rounded-xl border bg-white px-3 py-2 text-sm shadow-lg">
                  <p className="font-semibold">{hourLabel(Number(payload[0]!.payload.hour))}–{hourLabel((Number(payload[0]!.payload.hour) + 1) % 24)}</p>
                  <p className="text-muted-foreground">{payload[0]!.payload.calls} calls · {payload[0]!.payload.minutes} min</p>
                </div>
              ) : null} />
            <Bar dataKey="calls" fill={VIOLET} radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </Card>
  );
}

// --- Leaderboards --------------------------------------------------------------------------

function Board<T extends { id: string; displayName: string; avatarId: number }>({ title, icon: Icon, rows, href, value, detail, empty }: {
  title: string; icon: React.ElementType; rows: T[]; href: (r: T) => string; value: (r: T) => string; detail: (r: T) => string; empty: string;
}) {
  return (
    <section className="rounded-3xl border border-[#E7E4F0] bg-white p-5 shadow-[0_12px_32px_-24px_rgba(109,40,217,0.35)]">
      <h2 className="mb-3 flex items-center gap-2 font-heading text-base font-bold"><Icon className="size-4.5 text-violet-600" /> {title}</h2>
      {rows.length === 0 ? <p className="py-6 text-center text-sm text-muted-foreground">{empty}</p> : (
        <ol className="space-y-1">
          {rows.map((r, i) => (
            <li key={r.id}>
              <Link href={href(r)} className="flex items-center gap-3 rounded-2xl px-2 py-2 transition hover:bg-[#FAF7FD]">
                <span className={cn("w-5 text-center text-sm font-bold", i < 3 ? "text-violet-600" : "text-muted-foreground")}>{i + 1}</span>
                <UserAvatar id={r.id} name={r.displayName} avatarId={r.avatarId} size={36} />
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-sm font-semibold">{r.displayName}</span>
                  <span className="block truncate text-xs text-muted-foreground">{detail(r)}</span>
                </span>
                <span className="text-sm font-bold tabular-nums">{value(r)}</span>
              </Link>
            </li>
          ))}
        </ol>
      )}
    </section>
  );
}

function Leaderboards({ data }: { data: AdminAnalytics }) {
  const companion = (r: { id: string }) => `/companions/${r.id}`;
  return (
    <div className="grid gap-6 md:grid-cols-2 2xl:grid-cols-3">
      <Board title="Top rated" icon={Star} rows={data.topRated} href={companion} empty="Needs at least 3 ratings in this period"
        value={(r) => `${r.rating.toFixed(2)} ★`} detail={(r) => `${r.ratings} ratings`} />
      <Board title="Works the most" icon={Flame} rows={data.mostActive} href={companion} empty="No calls or online time yet"
        value={(r) => hours(r.talkMinutes)} detail={(r) => `${r.calls} calls · online ${hours(r.onlineMinutes)}`} />
      <Board title="Top earners" icon={Crown} rows={data.topEarners} href={companion} empty="No earnings yet"
        value={(r) => rupees(r.earnedPaise)} detail={(r) => `${r.calls} calls`} />
      <Board title="Top spenders" icon={TrendingUp} rows={data.topSpenders} href={(r) => `/callers/${r.id}`} empty="No spending yet"
        value={(r) => `${count(r.coinsSpent)} coins`} detail={(r) => `${r.calls} calls${r.purchasesPaise ? ` · bought ${rupees(r.purchasesPaise)}` : ""}`} />
      <Board title="Most reported" icon={Flag} rows={data.mostReported} empty="No reports in this period 🎉"
        href={(r) => `/${r.role === "companion" ? "companions" : "callers"}/${r.id}`}
        value={(r) => `${r.reports}`} detail={(r) => (r.role === "companion" ? "Companion" : "Caller")} />
      <section className="flex flex-col justify-center rounded-3xl border border-dashed border-[#DCD3EC] p-5 text-sm text-muted-foreground">
        <p className="flex items-center gap-2 font-semibold text-foreground"><Clock className="size-4 text-violet-600" /> How these are counted</p>
        <p className="mt-2">Works the most = minutes on connected calls; online time counts days in the period. Spenders = coins on calls and gifts, minus refunds. Earnings include call minutes, gifts and bonuses.</p>
      </section>
    </div>
  );
}

// --- Table view (also the accessible version of the trend chart) ------------------------------

type Day = AdminAnalytics["daily"][number];
const col = createColumnHelper<Features, Day>();

function DailyTable({ rows }: { rows: Day[] }) {
  const columns = useMemo(() => [
    col.accessor("date", { header: "Date", cell: (c) => longDay(c.getValue()) }),
    col.accessor("calls", { header: "Calls" }),
    col.accessor("minutes", { header: "Minutes" }),
    col.accessor("activeCallers", { header: "Active callers" }),
    col.accessor("coinsSpent", { header: "Coins spent", cell: (c) => count(c.getValue()) }),
    col.accessor("salesPaise", { header: "Sales", cell: (c) => rupees(c.getValue()) }),
    col.accessor("earningsPaise", { header: "Companion earnings", cell: (c) => rupees(c.getValue()) }),
    col.accessor("newCallers", { header: "New callers" }),
    col.accessor("newCompanions", { header: "New companions" }),
  ], []);
  return (
    <Card title="Day by day" subtitle="Every number above, per day. Export to CSV for spreadsheets.">
      <DataTable columns={columns} data={[...rows].reverse()} search={false} exportName="analytics-daily" pageSize={10} empty="No days in range" />
    </Card>
  );
}
