"use client";

import { useQuery } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { motion } from "framer-motion";
import {
  ArrowDown, ArrowUp, BarChart3, ChevronRight, Clock, Coins, Crown, Download, Flag, Flame, Gift, IndianRupee, Minus, PhoneCall,
  PhoneMissed, PieChart, Star, TrendingUp, UserPlus, Users,
} from "lucide-react";
import Link from "next/link";
import { useMemo, useRef, useState } from "react";
import { Area, AreaChart, Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { DataTable, type Features } from "@/components/data-table";
import { UserAvatar } from "@/components/user-avatar";
import { Input } from "@/components/ui/input";
import { useMe } from "@/lib/access";
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

type Day = AdminAnalytics["daily"][number];

/** Everything on the page, one row per day, as CSV (opens in Excel / Sheets). */
function exportReport(data: AdminAnalytics) {
  const head = ["Date", "Calls", "Minutes", "Missed calls", "Coins spent", "Coin sales (₹)", "Companion earnings (₹)", "New callers", "New companions", "Active callers", "Avg rating"];
  const rows = data.daily.map((d) => [d.date, d.calls, d.minutes, d.missedCalls, d.coinsSpent, (d.salesPaise / 100).toFixed(2),
    (d.earningsPaise / 100).toFixed(2), d.newCallers, d.newCompanions, d.activeCallers, d.avgRating ?? ""]);
  const csv = [head, ...rows].map((r) => r.map((c) => `"${String(c).replace(/"/g, '""')}"`).join(",")).join("\n");
  const url = URL.createObjectURL(new Blob([String.fromCharCode(0xfeff), csv], { type: "text/csv;charset=utf-8" }));
  const a = Object.assign(document.createElement("a"), { href: url, download: `analytics-${data.range.from}-to-${data.range.to}.csv` });
  a.click();
  URL.revokeObjectURL(url);
}

export default function AnalyticsPage() {
  const me = useMe().data;
  const [preset, setPreset] = useState<Preset>("30");
  const [custom, setCustom] = useState({ from: shift(istToday(), -13), to: istToday() });
  const [metric, setMetric] = useState<MetricKey>("coinsSpent");
  const trendRef = useRef<HTMLDivElement>(null);
  const range = rangeFor(preset, custom);
  const valid = range.from <= range.to;
  const { data, isLoading, error } = useQuery({
    queryKey: ["analytics", range.from, range.to],
    queryFn: () => api<AdminAnalytics>(`admin/analytics?from=${range.from}&to=${range.to}`),
    enabled: valid,
    placeholderData: (prev) => prev,
  });
  const showTrend = (m: MetricKey) => {
    setMetric(m);
    trendRef.current?.scrollIntoView({ behavior: "smooth", block: "center" });
  };

  return (
    <>
      {/* Header: greeting, title, and a soft brand wave behind it. */}
      <div className="relative mb-6 overflow-hidden">
        <svg aria-hidden viewBox="0 0 600 160" className="pointer-events-none absolute -right-10 -top-8 hidden h-44 w-[560px] opacity-70 lg:block">
          <defs>
            <linearGradient id="wave" x1="0" x2="1" y1="0" y2="0">
              <stop offset="0%" stopColor="#C4B5FD" stopOpacity="0" />
              <stop offset="40%" stopColor="#A78BFA" stopOpacity="0.55" />
              <stop offset="75%" stopColor="#F472B6" stopOpacity="0.55" />
              <stop offset="100%" stopColor="#FDA4AF" stopOpacity="0.2" />
            </linearGradient>
          </defs>
          {Array.from({ length: 14 }, (_, i) => (
            <path key={i} fill="none" stroke="url(#wave)" strokeWidth="1.2"
              d={`M0 ${110 - i * 2} C 120 ${40 + i * 4}, 220 ${150 - i * 3}, 340 ${80 + i * 2} S 520 ${30 + i * 5}, 600 ${70 + i * 2}`} />
          ))}
        </svg>
        <p className="relative text-base text-foreground/70">
          Hello again, <b className="text-foreground">{me?.displayName ?? "there"}</b>! 👋
        </p>
        <h1 className="relative font-heading text-4xl font-extrabold tracking-tight">Analytics</h1>
        <p className="relative mt-1 text-sm text-muted-foreground">
          Everything for the dates you pick (India time), compared with the same number of days just before.
        </p>
      </div>

      {/* One filter row above everything it controls. */}
      <div className="mb-6 flex flex-wrap items-center gap-3">
        <div role="radiogroup" aria-label="Date range" className="flex flex-wrap gap-1 rounded-full border border-[#EFEAF6] bg-white p-1.5 shadow-sm">
          {PRESETS.map((p) => (
            <button key={p.id} type="button" role="radio" aria-checked={preset === p.id} onClick={() => setPreset(p.id)}
              className={cn("h-9 rounded-full px-5 text-sm font-semibold transition",
                preset === p.id ? "bg-[linear-gradient(90deg,#DB2777,#E11D74)] text-white shadow-[0_8px_18px_-10px_rgba(219,39,119,0.9)]" : "text-foreground/60 hover:text-foreground")}>
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
        <button type="button" disabled={!data} onClick={() => data && exportReport(data)}
          className="ml-auto inline-flex h-11 items-center gap-2 rounded-full border border-[#EFEAF6] bg-white px-5 text-sm font-semibold shadow-sm transition hover:border-primary hover:text-primary disabled:opacity-50">
          <Download className="size-4" /> Export report
        </button>
      </div>

      {error && <p className="mb-4 rounded-2xl bg-destructive/10 p-4 text-sm text-destructive">{error.message}</p>}
      {!data ? (
        <div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
          {Array.from({ length: 8 }, (_, i) => <div key={i} className="h-40 animate-pulse rounded-3xl bg-white/70" />)}
        </div>
      ) : (
        <div className={cn("space-y-6 transition-opacity", isLoading && "opacity-60")}>
          <Tiles t={data.totals} p={data.previousTotals} daily={data.daily} onOpen={showTrend} />
          <div className="grid gap-6 xl:grid-cols-[1fr_380px]">
            <div ref={trendRef}><Trend data={data} metric={metric} setMetric={setMetric} /></div>
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
  if (!before && !now) return <span className="inline-flex items-center gap-1 text-xs text-muted-foreground"><Minus className="size-3.5" /> No activity either period</span>;
  if (!before) return <span className="inline-flex items-center gap-1 text-xs font-semibold text-emerald-700"><ArrowUp className="size-3.5" /> New this period</span>;
  const pct = Math.round(((now - before) / before) * 100);
  const good = invert ? pct < 0 : pct > 0;
  const Icon = pct === 0 ? Minus : pct > 0 ? ArrowUp : ArrowDown;
  return (
    <span className={cn("inline-flex items-center gap-1 text-xs font-semibold", pct === 0 ? "text-muted-foreground" : good ? "text-emerald-700" : "text-rose-600")}>
      <Icon className="size-3.5" /> {pct > 0 ? "+" : ""}{pct}% <span className="font-medium text-muted-foreground">vs previous</span>
    </span>
  );
}

/** Tiny bar chart of the tile's daily values (grouped into ≤ 16 bars); decorative detail — the number is the headline. */
function Spark({ values, color, label }: { values: number[]; color: string; label: string }) {
  const bars = useMemo(() => {
    if (values.length <= 16) return values;
    const size = Math.ceil(values.length / 16);
    return Array.from({ length: Math.ceil(values.length / size) }, (_, i) => values.slice(i * size, (i + 1) * size).reduce((a, b) => a + b, 0));
  }, [values]);
  const max = Math.max(1, ...bars);
  const w = 5, gap = 2, h = 38;
  return (
    // Scales down to the space left beside the number.
    <svg role="img" aria-label={label} viewBox={`0 0 ${bars.length * (w + gap)} ${h}`} preserveAspectRatio="xMaxYMax meet"
      className="h-9 w-full min-w-10 max-w-[112px]">
      {bars.map((v, i) => {
        const bh = Math.max(2, (v / max) * h);
        return <rect key={i} x={i * (w + gap)} y={h - bh} width={w} height={bh} rx={2} fill={color} opacity={v ? 0.85 : 0.25} />;
      })}
    </svg>
  );
}

type Tile = {
  label: string; icon: React.ElementType; value: string; now: number; before: number; hint: string; invert?: boolean;
  metric: MetricKey; tint: string; iconBg: string; color: string;
};

function Tiles({ t, p, daily, onOpen }: { t: AnalyticsTotals; p: AnalyticsTotals; daily: Day[]; onOpen: (m: MetricKey) => void }) {
  const tiles: Tile[] = [
    { label: "Coin sales", icon: IndianRupee, value: rupees(t.salesPaise), now: t.salesPaise, before: p.salesPaise, metric: "salesPaise",
      hint: `${count(t.purchases)} purchases · ${count(t.payingCallers)} buyers`, tint: "from-pink-50", iconBg: "bg-pink-100 text-pink-600", color: "#EC4899" },
    { label: "Coins spent", icon: Coins, value: count(t.coinsSpent), now: t.coinsSpent, before: p.coinsSpent, metric: "coinsSpent",
      hint: `${count(t.coinsOnCalls)} calls · ${count(t.coinsOnLives)} lives · ${count(t.coinsOnGroups)} groups · ${count(t.coinsOnGifts)} gifts`,
      tint: "from-violet-50", iconBg: "bg-violet-100 text-violet-600", color: "#8B5CF6" },
    { label: "Companion earnings", icon: Gift, value: rupees(t.companionEarningsPaise), now: t.companionEarningsPaise, before: p.companionEarningsPaise,
      metric: "earningsPaise", hint: "Calls, gifts and bonuses", tint: "from-orange-50", iconBg: "bg-orange-100 text-orange-500", color: "#F59E0B" },
    { label: "Connected calls", icon: PhoneCall, value: count(t.connectedCalls), now: t.connectedCalls, before: p.connectedCalls, metric: "calls",
      hint: `${count(t.minutes)} minutes · avg ${duration(t.avgCallSeconds)}`, tint: "from-sky-50", iconBg: "bg-sky-100 text-sky-600", color: "#3B82F6" },
    { label: "Active callers", icon: Users, value: count(t.activeCallers), now: t.activeCallers, before: p.activeCallers, metric: "activeCallers",
      hint: "Had at least one call", tint: "from-emerald-50", iconBg: "bg-emerald-100 text-emerald-600", color: "#10B981" },
    { label: "New sign-ups", icon: UserPlus, value: count(t.newCallers + t.newCompanions), now: t.newCallers + t.newCompanions,
      before: p.newCallers + p.newCompanions, metric: "signups", hint: `${count(t.newCallers)} callers · ${count(t.newCompanions)} companions`,
      tint: "from-purple-50", iconBg: "bg-purple-100 text-purple-600", color: "#A855F7" },
    { label: "Average rating", icon: Star, value: t.avgRating === null ? "—" : `${t.avgRating.toFixed(2)} ★`, now: Math.round((t.avgRating ?? 0) * 100),
      before: Math.round((p.avgRating ?? 0) * 100), metric: "avgRating", hint: `${count(t.ratings)} ratings`,
      tint: "from-amber-50", iconBg: "bg-amber-100 text-amber-500", color: "#F59E0B" },
    { label: "Missed calls", icon: PhoneMissed, value: count(t.missedCalls), now: t.missedCalls, before: p.missedCalls, metric: "missedCalls",
      hint: `Companions online ${hours(t.companionOnlineMinutes)} in total`, invert: true, tint: "from-rose-50", iconBg: "bg-rose-100 text-rose-600", color: "#F43F5E" },
  ];
  return (
    <div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
      {tiles.map((x, i) => {
        const m = METRICS.find((mm) => mm.key === x.metric)!;
        const values = daily.map((d) => m.get(d) ?? 0);
        return (
          <motion.button key={x.label} type="button" onClick={() => onOpen(x.metric)}
            initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.03 }}
            aria-label={`${x.label}: ${x.value}. Show ${m.label.toLowerCase()} by day`}
            className={cn("group rounded-3xl border border-[#EFEAF6] bg-gradient-to-br to-white p-5 text-left shadow-[0_12px_32px_-24px_rgba(109,40,217,0.35)] transition hover:-translate-y-0.5 hover:shadow-[0_18px_36px_-22px_rgba(109,40,217,0.45)]", x.tint)}>
            <div className="flex items-start gap-3">
              <span className={cn("grid size-12 shrink-0 place-items-center rounded-2xl", x.iconBg)}><x.icon className="size-6" /></span>
              <div className="min-w-0 flex-1">
                <div className="flex items-center justify-between gap-2">
                  <p className="text-sm font-semibold text-foreground/80">{x.label}</p>
                  <ChevronRight className="size-4 text-foreground/40 transition group-hover:translate-x-0.5 group-hover:text-foreground" />
                </div>
                <div className="mt-1 flex items-end justify-between gap-3">
                  <p className="shrink-0 whitespace-nowrap font-heading text-[28px] font-extrabold leading-tight tracking-tight">{x.value}</p>
                  <div className="flex min-w-0 flex-1 justify-end"><Spark values={values} color={x.color} label={`${x.label} per day`} /></div>
                </div>
                <div className="mt-1 whitespace-nowrap"><Delta now={x.now} before={x.before} invert={x.invert} /></div>
              </div>
            </div>
            <p className="mt-3 truncate text-xs text-muted-foreground">{x.hint}</p>
          </motion.button>
        );
      })}
    </div>
  );
}

// --- Trend: one measure at a time (never two y-scales) ------------------------------------

const METRICS: { key: string; label: string; fmt: (n: number) => string; get: (d: Day) => number | null; money?: boolean }[] = [
  { key: "coinsSpent", label: "Coins spent", fmt: count, get: (d) => d.coinsSpent },
  { key: "salesPaise", label: "Coin sales", fmt: rupees, get: (d) => d.salesPaise, money: true },
  { key: "earningsPaise", label: "Companion earnings", fmt: rupees, get: (d) => d.earningsPaise, money: true },
  { key: "calls", label: "Calls", fmt: count, get: (d) => d.calls },
  { key: "minutes", label: "Minutes", fmt: count, get: (d) => d.minutes },
  { key: "activeCallers", label: "Active callers", fmt: count, get: (d) => d.activeCallers },
  { key: "signups", label: "New sign-ups", fmt: count, get: (d) => d.newCallers + d.newCompanions },
  { key: "missedCalls", label: "Missed calls", fmt: count, get: (d) => d.missedCalls },
  { key: "avgRating", label: "Rating", fmt: (n) => n.toFixed(2), get: (d) => d.avgRating },
];
type MetricKey = string;

function Card({ title, subtitle, children, className, right, icon: Icon }: {
  title: string; subtitle?: string; children: React.ReactNode; className?: string; right?: React.ReactNode; icon?: React.ElementType;
}) {
  return (
    <section className={cn("rounded-3xl border border-[#EFEAF6] bg-white p-6 shadow-[0_12px_32px_-24px_rgba(109,40,217,0.35)]", className)}>
      <div className="mb-4 flex flex-wrap items-start justify-between gap-3">
        <div className="flex items-start gap-3">
          {Icon && <span className="grid size-11 shrink-0 place-items-center rounded-2xl bg-violet-50 text-violet-600"><Icon className="size-5" /></span>}
          <div>
            <h2 className="font-heading text-lg font-bold">{title}</h2>
            {subtitle && <p className="mt-0.5 text-sm text-muted-foreground">{subtitle}</p>}
          </div>
        </div>
        {right}
      </div>
      {children}
    </section>
  );
}

function Trend({ data, metric, setMetric }: { data: AdminAnalytics; metric: MetricKey; setMetric: (m: MetricKey) => void }) {
  const m = METRICS.find((x) => x.key === metric) ?? METRICS[0]!;
  const series = data.daily.map((d) => {
    const v = m.get(d);
    return { date: d.date, value: v === null ? null : m.money ? v / 100 : v };
  });
  const values = data.daily.map((d) => m.get(d)).filter((v): v is number => v !== null);
  const summary = m.key === "avgRating"
    ? (values.length ? `${(values.reduce((a, b) => a + b, 0) / values.length).toFixed(2)} ★ average of rated days` : "No ratings yet")
    : `${m.fmt(values.reduce((a, b) => a + b, 0))} in total`;
  return (
    <Card title={`${m.label} by day`} subtitle={summary} icon={BarChart3}
      right={
        <div role="radiogroup" aria-label="Measure" className="flex flex-wrap gap-1.5">
          {METRICS.map((x) => (
            <button key={x.key} type="button" role="radio" aria-checked={metric === x.key} onClick={() => setMetric(x.key)}
              className={cn("h-8 rounded-full px-3.5 text-xs font-semibold transition",
                metric === x.key ? "bg-[linear-gradient(90deg,#7C3AED,#DB2777)] text-white shadow-[0_8px_16px_-10px_rgba(124,58,237,0.9)]" : "bg-[#F6F3FB] text-foreground/70 hover:text-foreground")}>
              {x.label}
            </button>
          ))}
        </div>
      }>
      <div className="h-80">
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={series} margin={{ top: 8, right: 12, left: 0, bottom: 0 }}>
            <defs>
              <linearGradient id="trend-fill" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor={PINK} stopOpacity={0.28} />
                <stop offset="100%" stopColor={PINK} stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid vertical={false} stroke={GRID} />
            <XAxis dataKey="date" {...axis} tickFormatter={shortDay} minTickGap={24} />
            <YAxis {...axis} width={56} allowDecimals={m.money || m.key === "avgRating"}
              domain={m.key === "avgRating" ? [0, 5] : undefined}
              tickFormatter={(v: number) => (m.money ? `₹${compact(v)}` : compact(v))} />
            <Tooltip cursor={{ stroke: "#F9A8D4", strokeDasharray: "4 4" }}
              content={({ active, payload, label }) => active && payload?.length && payload[0]!.value !== null ? (
                <div className="rounded-2xl border border-[#EFEAF6] bg-white px-4 py-2.5 text-sm shadow-lg">
                  <p className="font-heading text-lg font-extrabold">{m.fmt(m.money ? Number(payload[0]!.value) * 100 : Number(payload[0]!.value))}</p>
                  <p className="text-xs text-muted-foreground">{longDay(String(label))}</p>
                </div>
              ) : null} />
            <Area type="monotone" dataKey="value" name={m.label} stroke={PINK} strokeWidth={2.5} fill="url(#trend-fill)" connectNulls
              activeDot={{ r: 6, fill: PINK, stroke: "#fff", strokeWidth: 3 }}
              dot={series.length <= 45 ? { r: 3, fill: "#fff", stroke: PINK, strokeWidth: 2 } : false} />
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
  const money = (p: number) => (p < 0 ? `−${rupees(-p)}` : rupees(p));
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
    <Card title="Margin" icon={PieChart} subtitle="Estimate · fees vary by payment method (change the % in Pricing → Settings)">
      <dl className="text-sm">
        {rows.map((r) => (
          <div key={r.label} className={cn("flex items-center justify-between gap-3 border-b border-[#F3F0F8] px-3 py-2.5",
            r.strong && "my-1 rounded-xl border-0 bg-pink-50 font-semibold")}>
            <dt className={r.strong ? "" : "text-muted-foreground"}>{r.label}</dt>
            <dd className={cn("tabular-nums", r.paise < 0 && "font-medium text-rose-600")}>{money(r.paise)}</dd>
          </div>
        ))}
        <div className={cn("mt-3 flex items-center justify-between gap-3 rounded-2xl px-4 py-3.5 text-base font-bold",
          m.marginPaise < 0 ? "bg-rose-50" : "bg-emerald-50")}>
          <dt>Margin</dt>
          <dd className={cn("tabular-nums", m.marginPaise < 0 ? "text-rose-600" : "text-emerald-700")}>{money(m.marginPaise)}</dd>
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
