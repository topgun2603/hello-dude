"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import confetti from "canvas-confetti";
import { AnimatePresence, motion } from "framer-motion";
import { PartyPopper, Pencil, Plus, Power, Trash2, Wand2 } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { toast } from "sonner";
import { DataTable, type Features } from "@/components/data-table";
import { Dropdown } from "@/components/dropdown";
import { Field } from "@/components/form-bits";
import { PageHeader } from "@/components/sidebar";
import { StatCard } from "@/components/stat-card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import {
  api, type Promotion, type PromotionAudience, type PromotionCta, type PromotionFrequency, type PromotionTheme,
} from "@/lib/api";
import { dateTime } from "@/lib/format";
import { cn } from "@/lib/utils";

const col = createColumnHelper<Features, Promotion>();

const CTA: Record<PromotionCta, string> = {
  wallet: "Wallet (buy coins)", vip: "VIP", checkin: "Daily check-in", referral: "Invite friends",
  online: "Online now", rooms: "Voice rooms", rewards: "Companion rewards", none: "Just close",
};
const AUDIENCE: Record<PromotionAudience, string> = {
  all: "Everyone", callers: "All callers", never_paid: "Callers who never bought coins",
  paid: "Callers who have bought coins", companions: "Companions",
};
const FREQUENCY: Record<PromotionFrequency, string> = {
  every_open: "Every time the app opens", daily: "Once a day", once: "Only once per person",
};
const THEMES: Record<PromotionTheme, { label: string; gradient: string; colors: string[] }> = {
  brand: { label: "Brand (purple → pink)", gradient: "linear-gradient(90deg,#7C3AED,#DB2777 55%,#EA580C)", colors: ["#7C3AED", "#DB2777", "#EA580C", "#F472B6", "#FDE68A"] },
  gold: { label: "Gold (VIP)", gradient: "linear-gradient(90deg,#FDE68A,#D97706)", colors: ["#FDE68A", "#F59E0B", "#D97706", "#FFFFFF"] },
  green: { label: "Green (companions)", gradient: "linear-gradient(90deg,#10B981,#0E7490)", colors: ["#10B981", "#34D399", "#0E7490", "#FFFFFF"] },
};
const STATUS: Record<Promotion["status"], { label: string; className: string }> = {
  live: { label: "Live", className: "bg-emerald-500 text-white" },
  scheduled: { label: "Scheduled", className: "bg-sky-100 text-sky-800" },
  ended: { label: "Ended", className: "bg-zinc-100 text-zinc-600" },
  off: { label: "Off", className: "bg-zinc-100 text-zinc-600" },
};
const options = <K extends string>(m: Record<K, string>) => Object.entries(m).map(([value, label]) => ({ value, label: label as string }));

/** Confetti in the brand colours of a theme (respects reduced motion). */
function burst(theme: PromotionTheme) {
  const colors = THEMES[theme].colors;
  const base = { disableForReducedMotion: true, colors, ticks: 220, zIndex: 9999 };
  confetti({ ...base, particleCount: 90, spread: 75, startVelocity: 45, origin: { x: 0.5, y: 0.55 } });
  confetti({ ...base, particleCount: 45, angle: 60, spread: 60, origin: { x: 0, y: 0.7 } });
  confetti({ ...base, particleCount: 45, angle: 120, spread: 60, origin: { x: 1, y: 0.7 } });
}

const pct = (a: number, b: number) => (b ? `${Math.round((a / b) * 1000) / 10}%` : "—");

/** ISO → value for <input type="datetime-local"> in the browser's time zone. */
const toLocalInput = (iso: string | null) => {
  if (!iso) return "";
  const d = new Date(iso);
  return new Date(d.getTime() - d.getTimezoneOffset() * 60_000).toISOString().slice(0, 16);
};

/** Which offer a group would get right now (ignores per-person frequency). */
function winner(list: Promotion[], audiences: PromotionAudience[]) {
  return list.filter((p) => p.status === "live" && audiences.includes(p.audience))
    .sort((a, b) => b.priority - a.priority || b.id - a.id)[0];
}

export default function PromotionsPage() {
  const qc = useQueryClient();
  const { data, isLoading } = useQuery({ queryKey: ["promotions"], queryFn: () => api<Promotion[]>("admin/promotions"), refetchInterval: 30_000 });
  const [edit, setEdit] = useState<Promotion | "new" | null>(null);
  const [deleting, setDeleting] = useState<Promotion | null>(null);
  const list = useMemo(() => data ?? [], [data]);

  const toggle = useMutation({
    mutationFn: (p: Promotion) => api<Promotion>(`admin/promotions/${p.id}/active`, { method: "POST", body: { isActive: !p.isActive } }),
    onSuccess: (p) => { toast.success(p.isActive ? `“${p.title}” is on` : `“${p.title}” is off`); qc.invalidateQueries({ queryKey: ["promotions"] }); },
    onError: (e) => toast.error(e.message),
  });
  const remove = useMutation({
    mutationFn: (p: Promotion) => api(`admin/promotions/${p.id}`, { method: "DELETE" }),
    onSuccess: () => { toast.success("Offer deleted"); qc.invalidateQueries({ queryKey: ["promotions"] }); setDeleting(null); },
    onError: (e) => toast.error(e.message),
  });

  const totals = useMemo(() => ({
    live: list.filter((p) => p.status === "live").length,
    shownToday: list.reduce((n, p) => n + p.shownToday, 0),
    clickedToday: list.reduce((n, p) => n + p.clickedToday, 0),
    shown: list.reduce((n, p) => n + p.shown, 0),
    clicked: list.reduce((n, p) => n + p.clicked, 0),
  }), [list]);
  const now = {
    newCallers: winner(list, ["all", "callers", "never_paid"]),
    payingCallers: winner(list, ["all", "callers", "paid"]),
    companions: winner(list, ["all", "companions"]),
  };

  const columns = useMemo(() => [
    col.accessor("title", {
      header: "Offer",
      cell: ({ row: { original: p } }) => (
        <div className="flex items-center gap-3">
          <span className="grid size-10 shrink-0 place-items-center rounded-xl text-xl" style={{ background: THEMES[p.theme].gradient }}>{p.emoji || "🎁"}</span>
          <div className="min-w-0">
            <p className="truncate font-semibold">{p.title}</p>
            <p className="truncate text-xs text-muted-foreground">{[p.highlight, p.badge].filter(Boolean).join(" · ") || p.body || "—"}</p>
          </div>
        </div>
      ),
    }),
    col.accessor((p) => AUDIENCE[p.audience], { id: "audience", header: "Who sees it" }),
    col.accessor((p) => FREQUENCY[p.frequency], { id: "frequency", header: "How often" }),
    col.accessor("startsAt", {
      header: "Schedule", sortFn: "datetime",
      cell: ({ row: { original: p } }) => (
        <span className="text-xs leading-5">{dateTime(p.startsAt)}<br /><span className="text-muted-foreground">{p.endsAt ? `until ${dateTime(p.endsAt)}` : "no end date"}</span></span>
      ),
    }),
    col.accessor("priority", { header: "Priority", cell: (c) => <b>{c.getValue()}</b> }),
    col.accessor("shown", {
      header: "Shown",
      cell: ({ row: { original: p } }) => <span>{p.shown.toLocaleString("en-IN")}<br /><span className="text-xs text-muted-foreground">{p.reach.toLocaleString("en-IN")} people</span></span>,
    }),
    col.accessor("clicked", {
      header: "Taps",
      cell: ({ row: { original: p } }) => <span>{p.clicked.toLocaleString("en-IN")}<br /><span className="text-xs text-muted-foreground">{pct(p.clicked, p.shown)} tap rate</span></span>,
    }),
    col.accessor((p) => STATUS[p.status].label, {
      id: "status", header: "Status",
      cell: ({ row: { original: p } }) => <Badge className={STATUS[p.status].className}>{STATUS[p.status].label}</Badge>,
    }),
    col.display({
      id: "actions", header: "",
      cell: ({ row: { original: p } }) => (
        <div className="flex justify-end gap-2" onClick={(e) => e.stopPropagation()}>
          <Button size="sm" variant={p.isActive ? "outline" : "default"} disabled={toggle.isPending} onClick={() => toggle.mutate(p)}
            aria-label={p.isActive ? `Turn off ${p.title}` : `Turn on ${p.title}`}>
            <Power /> {p.isActive ? "Turn off" : "Turn on"}
          </Button>
          <Button size="sm" variant="outline" onClick={() => setEdit(p)}><Pencil /> Edit</Button>
          <Button size="icon-sm" variant="ghost" aria-label={`Delete ${p.title}`} onClick={() => setDeleting(p)}><Trash2 className="text-destructive" /></Button>
        </div>
      ),
    }),
  ], [toggle]);

  return (
    <>
      <PageHeader title="Offers popup"
        description="A bottom sheet with confetti that opens when someone opens the app. Each person sees the live offer meant for them with the highest priority.">
        <Button onClick={() => setEdit("new")}><Plus /> New offer</Button>
      </PageHeader>

      <div className="mb-4 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard index={0} label="Live now" value={data ? totals.live : undefined} tone="success" hint="Offers that can show right now" />
        <StatCard index={1} label="Shown today" value={data ? totals.shownToday : undefined} hint="Sheets opened since midnight IST" />
        <StatCard index={2} label="Taps today" value={data ? totals.clickedToday : undefined} hint={`${pct(totals.clickedToday, totals.shownToday)} of today's views`} />
        <StatCard index={3} label="Tap rate (all time)" value={data ? (totals.shown ? Math.round((totals.clicked / totals.shown) * 1000) : 0) : undefined}
          format={(n) => `${(n / 10).toFixed(1)}%`} hint={`${totals.clicked.toLocaleString("en-IN")} taps from ${totals.shown.toLocaleString("en-IN")} views`} />
      </div>

      <div className="mb-5 grid gap-3 md:grid-cols-3">
        {([["New callers see", now.newCallers], ["Paying callers see", now.payingCallers], ["Companions see", now.companions]] as const).map(([label, p]) => (
          <div key={label} className="flex items-center gap-3 rounded-2xl border border-[#E7E4F0] bg-white p-3.5">
            <span className="grid size-9 shrink-0 place-items-center rounded-xl text-lg" style={{ background: p ? THEMES[p.theme].gradient : "#F1EEF7" }}>{p ? p.emoji || "🎁" : "—"}</span>
            <div className="min-w-0">
              <p className="text-xs font-medium text-muted-foreground">{label}</p>
              <p className="truncate text-sm font-semibold">{p ? p.title : "Nothing (no live offer)"}</p>
            </div>
          </div>
        ))}
      </div>

      <DataTable columns={columns} data={list} exportName="offers-popup" searchPlaceholder="Search offers…"
        empty={isLoading ? "Loading…" : "No offers yet. Create one to greet people when they open the app."}
        onRowClick={(p) => setEdit(p)}
        filters={[{ type: "select", column: "status", label: "Statuses" }, { type: "select", column: "audience", label: "Audiences" }]} />

      <PromotionDialog value={edit} onClose={() => setEdit(null)} />

      <Dialog open={!!deleting} onOpenChange={(o) => !o && setDeleting(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete “{deleting?.title}”?</DialogTitle>
            <DialogDescription>Its view and tap counts are deleted too. To keep the numbers, turn it off instead.</DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleting(null)}>Cancel</Button>
            <Button variant="destructive" disabled={remove.isPending} onClick={() => deleting && remove.mutate(deleting)}>Delete</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}

// --- Editor --------------------------------------------------------------------------
type Form = {
  title: string; body: string; highlight: string; badge: string; emoji: string; ctaLabel: string;
  ctaAction: PromotionCta; theme: PromotionTheme; audience: PromotionAudience; frequency: PromotionFrequency;
  confetti: boolean; priority: string; isActive: boolean; startsAt: string; endsAt: string;
};

const blank = (): Form => ({
  title: "", body: "", highlight: "", badge: "", emoji: "🎉", ctaLabel: "Grab the offer", ctaAction: "wallet",
  theme: "brand", audience: "callers", frequency: "every_open", confetti: true, priority: "10", isActive: true,
  startsAt: toLocalInput(new Date().toISOString()), endsAt: "",
});

function PromotionDialog({ value, onClose }: { value: Promotion | "new" | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [f, setF] = useState<Form>(blank);
  const [openedFor, setOpenedFor] = useState<typeof value>(null);
  if (value && value !== openedFor) {
    setOpenedFor(value);
    setF(value === "new" ? blank() : {
      title: value.title, body: value.body, highlight: value.highlight ?? "", badge: value.badge ?? "", emoji: value.emoji ?? "",
      ctaLabel: value.ctaLabel, ctaAction: value.ctaAction, theme: value.theme, audience: value.audience, frequency: value.frequency,
      confetti: value.confetti, priority: String(value.priority), isActive: value.isActive,
      startsAt: toLocalInput(value.startsAt), endsAt: toLocalInput(value.endsAt),
    });
  }
  const set = <K extends keyof Form>(k: K, v: Form[K]) => setF((x) => ({ ...x, [k]: v }));

  const endsBeforeStart = !!f.endsAt && !!f.startsAt && new Date(f.endsAt) <= new Date(f.startsAt);
  const invalid = f.title.trim().length < 3 || f.ctaLabel.trim().length < 2 || !f.startsAt || endsBeforeStart
    || !(Number(f.priority) >= 0 && Number(f.priority) <= 1000);

  const save = useMutation({
    mutationFn: () => {
      const body = {
        title: f.title, body: f.body, highlight: f.highlight || null, badge: f.badge || null, emoji: f.emoji || null,
        ctaLabel: f.ctaLabel, ctaAction: f.ctaAction, theme: f.theme, audience: f.audience, frequency: f.frequency,
        confetti: f.confetti, priority: Math.round(Number(f.priority)), isActive: f.isActive,
        startsAt: new Date(f.startsAt).toISOString(), endsAt: f.endsAt ? new Date(f.endsAt).toISOString() : null,
      };
      return value === "new"
        ? api<Promotion>("admin/promotions", { method: "POST", body })
        : api<Promotion>(`admin/promotions/${(value as Promotion).id}`, { method: "PUT", body });
    },
    onSuccess: (p) => {
      toast.success(value === "new" ? "Offer created" : "Offer saved");
      if (p.status === "live" && p.confetti) burst(p.theme);
      qc.invalidateQueries({ queryKey: ["promotions"] });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });

  return (
    <Dialog open={!!value} onOpenChange={(o) => !o && onClose()}>
      <DialogContent className="max-h-[92vh] overflow-y-auto sm:max-w-5xl">
        <DialogHeader>
          <DialogTitle>{value === "new" ? "New offer" : "Edit offer"}</DialogTitle>
          <DialogDescription>Shown as a bottom sheet when the app opens. The preview updates as you type.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-6 lg:grid-cols-[1fr_320px]">
          <div className="space-y-5">
            <section className="grid gap-4 sm:grid-cols-[88px_1fr]">
              <Field label="Emoji" htmlFor="pr-emoji"><Input id="pr-emoji" className="text-center text-xl" maxLength={8} value={f.emoji} onChange={(e) => set("emoji", e.target.value)} /></Field>
              <Field label="Title" htmlFor="pr-title"><Input id="pr-title" maxLength={60} value={f.title} placeholder="Double coins weekend" onChange={(e) => set("title", e.target.value)} /></Field>
            </section>
            <section className="grid gap-4 sm:grid-cols-2">
              <Field label="Big highlight" htmlFor="pr-hl" hint="Short and bold, e.g. 2× coins or 50% extra"><Input id="pr-hl" maxLength={24} value={f.highlight} onChange={(e) => set("highlight", e.target.value)} /></Field>
              <Field label="Badge" htmlFor="pr-badge" hint="Small pill, e.g. Today only"><Input id="pr-badge" maxLength={24} value={f.badge} onChange={(e) => set("badge", e.target.value)} /></Field>
            </section>
            <Field label="Message" htmlFor="pr-body" hint={`${f.body.length}/200`}>
              <Textarea id="pr-body" maxLength={200} rows={3} value={f.body} placeholder="Every coin pack gives double coins until Sunday midnight." onChange={(e) => set("body", e.target.value)} />
            </Field>
            <section className="grid gap-4 sm:grid-cols-2">
              <Field label="Button text" htmlFor="pr-cta"><Input id="pr-cta" maxLength={24} value={f.ctaLabel} onChange={(e) => set("ctaLabel", e.target.value)} /></Field>
              <Field label="Button opens" htmlFor="pr-action">
                <Dropdown id="pr-action" value={f.ctaAction} options={options(CTA)} onValueChange={(v) => set("ctaAction", v as PromotionCta)} />
              </Field>
              <Field label="Who sees it" htmlFor="pr-aud">
                <Dropdown id="pr-aud" value={f.audience} options={options(AUDIENCE)} onValueChange={(v) => set("audience", v as PromotionAudience)} />
              </Field>
              <Field label="How often" htmlFor="pr-freq">
                <Dropdown id="pr-freq" value={f.frequency} options={options(FREQUENCY)} onValueChange={(v) => set("frequency", v as PromotionFrequency)} />
              </Field>
              <Field label="Colours" htmlFor="pr-theme">
                <Dropdown id="pr-theme" value={f.theme} onValueChange={(v) => set("theme", v as PromotionTheme)}
                  options={(Object.keys(THEMES) as PromotionTheme[]).map((t) => ({
                    value: t, label: THEMES[t].label, icon: <span className="size-3 rounded-full" style={{ background: THEMES[t].gradient }} />,
                  }))} />
              </Field>
              <Field label="Priority" htmlFor="pr-prio" hint="0–1000. Higher wins when several offers are live.">
                <Input id="pr-prio" type="number" min={0} max={1000} value={f.priority} onChange={(e) => set("priority", e.target.value)} />
              </Field>
              <Field label="Starts" htmlFor="pr-start"><Input id="pr-start" type="datetime-local" value={f.startsAt} onChange={(e) => set("startsAt", e.target.value)} /></Field>
              <Field label="Ends (optional)" htmlFor="pr-end" hint={endsBeforeStart ? "Must be after the start" : "Shows a countdown in the app"}>
                <Input id="pr-end" type="datetime-local" aria-invalid={endsBeforeStart} value={f.endsAt} onChange={(e) => set("endsAt", e.target.value)} />
              </Field>
            </section>
            <section className="flex flex-wrap gap-2">
              <Button type="button" variant={f.isActive ? "default" : "outline"} onClick={() => set("isActive", !f.isActive)}>
                <Power /> {f.isActive ? "On" : "Off"}
              </Button>
              <Button type="button" variant={f.confetti ? "default" : "outline"} onClick={() => set("confetti", !f.confetti)}>
                <PartyPopper /> {f.confetti ? "Confetti on" : "Confetti off"}
              </Button>
            </section>
          </div>
          <div className="space-y-3">
            <PhonePreview f={f} />
            <Button type="button" variant="outline" className="w-full" disabled={!f.confetti} onClick={() => burst(f.theme)}>
              <Wand2 /> Play confetti
            </Button>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={save.isPending || invalid} onClick={() => save.mutate()}>{save.isPending ? "Saving…" : "Save"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

/** How the bottom sheet looks on a phone (mirrors apps/mobile promo_sheet.dart). */
function PhonePreview({ f }: { f: Form }) {
  const theme = THEMES[f.theme];
  const [nowMs, setNowMs] = useState(() => Date.now());
  useEffect(() => { const t = setInterval(() => setNowMs(Date.now()), 1000); return () => clearInterval(t); }, []);
  const left = f.endsAt ? new Date(f.endsAt).getTime() - nowMs : 0;
  const two = (n: number) => String(n).padStart(2, "0");
  const countdown = left > 0
    ? left > 86_400_000 ? `${Math.floor(left / 86_400_000)}d ${Math.floor((left % 86_400_000) / 3_600_000)}h left`
      : `${two(Math.floor(left / 3_600_000))}:${two(Math.floor((left % 3_600_000) / 60_000))}:${two(Math.floor((left % 60_000) / 1000))} left`
    : null;

  return (
    <div className="mx-auto w-[300px] rounded-[40px] bg-[#14122B] p-2.5 shadow-xl" aria-label="Phone preview">
      <div className="relative h-[580px] overflow-hidden rounded-[32px] bg-[#0A0A18]"
        style={{ backgroundImage: "radial-gradient(circle at 20% 10%, rgba(124,58,237,0.35), transparent 45%), radial-gradient(circle at 90% 30%, rgba(219,39,119,0.25), transparent 40%)" }}>
        {/* The app behind the sheet, dimmed */}
        <div className="space-y-3 p-5 opacity-40">
          <div className="h-5 w-28 rounded-full bg-white/20" />
          <div className="h-24 rounded-2xl bg-white/10" />
          <div className="h-14 rounded-2xl bg-white/10" />
          <div className="h-14 rounded-2xl bg-white/10" />
        </div>
        <div className="absolute inset-0 bg-black/45" />
        <AnimatePresence mode="popLayout">
          <motion.div key={f.theme} initial={{ y: 40, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ type: "spring", damping: 22 }}
            className="absolute inset-x-0 bottom-0 rounded-t-[28px] border-t border-white/10 bg-[#16142C] px-5 pb-6 pt-3 text-center text-white">
            <div className="mx-auto mb-4 h-1 w-10 rounded-full bg-white/25" />
            <div className="mx-auto -mt-12 mb-3 grid size-20 place-items-center rounded-full text-4xl shadow-lg ring-4 ring-[#16142C]" style={{ background: theme.gradient }}>
              {f.emoji || "🎁"}
            </div>
            {f.badge && <span className="mb-2 inline-block rounded-full bg-white/10 px-3 py-1 text-[11px] font-bold uppercase tracking-wider text-pink-300">{f.badge}</span>}
            {f.highlight && (
              <p className="font-heading text-[34px] font-extrabold leading-tight" style={{ backgroundImage: theme.gradient, WebkitBackgroundClip: "text", color: "transparent" }}>
                {f.highlight}
              </p>
            )}
            <p className="font-heading text-lg font-bold">{f.title || "Your offer title"}</p>
            {f.body && <p className="mt-1.5 text-[13px] leading-5 text-[#C9C5DD]">{f.body}</p>}
            {countdown && <p className="mt-3 text-xs font-semibold text-amber-300">⏱ {countdown}</p>}
            <div className={cn("mt-4 rounded-full py-3 text-sm font-bold", f.theme === "gold" ? "text-[#3B2503]" : "text-white")} style={{ background: theme.gradient }}>
              {f.ctaLabel || "Button"}
            </div>
            <p className="mt-3 text-xs font-medium text-[#A8A4C4]">Not now</p>
          </motion.div>
        </AnimatePresence>
      </div>
    </div>
  );
}
