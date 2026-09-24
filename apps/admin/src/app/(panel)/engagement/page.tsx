"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { Crown, Gift, Pencil, Plus, Radio, Trophy, Users, Video } from "lucide-react";
import Link from "next/link";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { DataTable, type Features } from "@/components/data-table";
import { Field } from "@/components/form-bits";
import { PageHeader } from "@/components/sidebar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { api, type AdminGroup, type AdminLive, type BonusCampaign, type CompanionLevel, type LiveRoom, type VipPlan } from "@/lib/api";
import { dateTime, languageName, rupees } from "@/lib/format";
import { useCan } from "@/lib/access";

const levelCol = createColumnHelper<Features, CompanionLevel>();
const bonusCol = createColumnHelper<Features, BonusCampaign>();
const planCol = createColumnHelper<Features, VipPlan>();
const roomCol = createColumnHelper<Features, LiveRoom>();
const liveCol = createColumnHelper<Features, AdminLive>();
const groupCol = createColumnHelper<Features, AdminGroup>();

const DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
const clock = (m: number) => {
  const h = Math.floor(m / 60) % 24, mm = m % 60;
  return `${h % 12 === 0 ? 12 : h % 12}${mm ? `:${String(mm).padStart(2, "0")}` : ""} ${h < 12 ? "AM" : "PM"}`;
};
const toTime = (m: number) => `${String(Math.floor(m / 60) % 24).padStart(2, "0")}:${String(m % 60).padStart(2, "0")}`;
const fromTime = (t: string) => { const [h, m] = t.split(":").map(Number); return (h ?? 0) * 60 + (m ?? 0); };

export default function EngagementPage() {
  const can = useCan();
  const growth = can("engagement.manage"), rooms = can("rooms.manage");
  return (
    <>
      <PageHeader title="Engagement" description="Companion levels and bonuses, VIP plans, lives, group video and voice rooms. Changes apply to new calls straight away." />
      <Tabs key={growth ? "all" : "rooms"} defaultValue={growth ? "levels" : "rooms"}>
        <TabsList className="mb-4">
          {growth && <TabsTrigger value="levels"><Trophy /> Companion levels</TabsTrigger>}
          {growth && <TabsTrigger value="bonuses"><Gift /> Bonuses</TabsTrigger>}
          {growth && <TabsTrigger value="vip"><Crown /> VIP plans</TabsTrigger>}
          {rooms && <TabsTrigger value="lives"><Video /> Lives</TabsTrigger>}
          {rooms && <TabsTrigger value="groups"><Users /> Group video</TabsTrigger>}
          {rooms && <TabsTrigger value="rooms"><Radio /> Voice rooms</TabsTrigger>}
        </TabsList>
        {growth && <TabsContent value="levels"><Levels /></TabsContent>}
        {growth && <TabsContent value="bonuses"><Bonuses /></TabsContent>}
        {growth && <TabsContent value="vip"><VipPlans /></TabsContent>}
        {rooms && <TabsContent value="lives"><Lives /></TabsContent>}
        {rooms && <TabsContent value="groups"><Groups /></TabsContent>}
        {rooms && <TabsContent value="rooms"><Rooms /></TabsContent>}
      </Tabs>
    </>
  );
}

// --- Levels ----------------------------------------------------------------------
function Levels() {
  const { data, isLoading } = useQuery({ queryKey: ["levels"], queryFn: () => api<CompanionLevel[]>("admin/companion-levels") });
  const [edit, setEdit] = useState<CompanionLevel | null>(null);
  const columns = useMemo(() => [
    levelCol.accessor("level", { header: "Level", cell: (c) => <b>Level {c.getValue()}</b> }),
    levelCol.accessor("name", { header: "Name" }),
    levelCol.accessor("minHours", { header: "Talk hours / month", cell: (c) => `${c.getValue()} h` }),
    levelCol.accessor("minRating", { header: "Min rating", cell: (c) => (c.getValue() ? `${c.getValue().toFixed(1)} ★` : "—") }),
    levelCol.accessor("boostPct", { header: "Extra per minute", cell: (c) => (c.getValue() ? <Badge>+{c.getValue()}%</Badge> : "—") }),
    levelCol.display({ id: "edit", header: "", cell: ({ row }) => <Button size="sm" variant="outline" onClick={() => setEdit(row.original)}><Pencil /> Edit</Button> }),
  ], []);
  return (
    <>
      <p className="mb-3 text-sm text-muted-foreground">A companion&apos;s level uses their talk hours this month or last month (whichever is higher) and their rating. The extra % is added to their per-minute earnings when a call starts.</p>
      <DataTable columns={columns} data={data ?? []} search={false} empty={isLoading ? "Loading…" : "No levels"} />
      <LevelDialog level={edit} onClose={() => setEdit(null)} />
    </>
  );
}

function LevelDialog({ level, onClose }: { level: CompanionLevel | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [f, setF] = useState({ name: "", minHours: "", minRating: "", boostPct: "" });
  const [openedFor, setOpenedFor] = useState<CompanionLevel | null>(null);
  if (level && level !== openedFor) {
    setOpenedFor(level);
    setF({ name: level.name, minHours: String(level.minHours), minRating: String(level.minRating), boostPct: String(level.boostPct) });
  }
  const save = useMutation({
    mutationFn: () => api(`admin/companion-levels/${level!.level}`, { method: "PUT",
      body: { name: f.name, minHours: Number(f.minHours), minRating: Number(f.minRating), boostPct: Number(f.boostPct) } }),
    onSuccess: () => { toast.success("Level saved"); qc.invalidateQueries({ queryKey: ["levels"] }); onClose(); },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={!!level} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Level {level?.level}</DialogTitle>
          <DialogDescription>Applies to calls that start after you save. Calls in progress keep their rate.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Name" htmlFor="lv-name"><Input id="lv-name" value={f.name} onChange={(e) => setF({ ...f, name: e.target.value })} /></Field>
          <Field label="Talk hours per month" htmlFor="lv-h"><Input id="lv-h" type="number" min={0} value={f.minHours} onChange={(e) => setF({ ...f, minHours: e.target.value })} /></Field>
          <Field label="Minimum rating (0–5)" htmlFor="lv-r"><Input id="lv-r" type="number" step="0.1" min={0} max={5} value={f.minRating} onChange={(e) => setF({ ...f, minRating: e.target.value })} /></Field>
          <Field label="Extra earnings per minute (%)" htmlFor="lv-b" hint="0–50"><Input id="lv-b" type="number" min={0} max={50} value={f.boostPct} onChange={(e) => setF({ ...f, boostPct: e.target.value })} /></Field>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={save.isPending || f.name.trim().length < 2} onClick={() => save.mutate()}>{save.isPending ? "Saving…" : "Save"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// --- Bonuses ---------------------------------------------------------------------
function Bonuses() {
  const { data, isLoading } = useQuery({ queryKey: ["bonus-campaigns"], queryFn: () => api<BonusCampaign[]>("admin/bonus-campaigns") });
  const [edit, setEdit] = useState<BonusCampaign | "new" | null>(null);
  const columns = useMemo(() => [
    bonusCol.accessor("title", { header: "Bonus", cell: (c) => <b>{c.getValue()}</b> }),
    bonusCol.accessor("rewardPaise", { header: "Reward", cell: (c) => <Badge className="bg-amber-500">+{rupees(c.getValue())}</Badge> }),
    bonusCol.accessor((b) => `${clock(b.windowStart)} – ${clock(b.windowEnd)}`, { id: "window", header: "Window (IST)", enableSorting: false }),
    bonusCol.accessor("requiredMinutes", { header: "Online needed", cell: (c) => `${Math.floor(c.getValue() / 60) ? `${Math.floor(c.getValue() / 60)} h ` : ""}${c.getValue() % 60 ? `${c.getValue() % 60} m` : ""}` }),
    bonusCol.accessor((b) => (b.weekdays.length === 7 ? "Every day" : b.weekdays.map((d) => DAYS[d - 1]).join(", ")), { id: "days", header: "Days", enableSorting: false }),
    bonusCol.accessor((b) => (b.isActive ? "Active" : "Off"), { id: "active", header: "Status", cell: (c) => <Badge variant={c.getValue() === "Active" ? "default" : "outline"}>{c.getValue()}</Badge> }),
    bonusCol.display({ id: "edit", header: "", cell: ({ row }) => <Button size="sm" variant="outline" onClick={() => setEdit(row.original)}><Pencil /> Edit</Button> }),
  ], []);
  return (
    <>
      <p className="mb-3 text-sm text-muted-foreground">Companions who stay online long enough inside the window earn the reward. The worker pays it to their earnings within a minute.</p>
      <DataTable columns={columns} data={data ?? []} search={false} empty={isLoading ? "Loading…" : "No bonuses yet"}
        toolbar={<Button size="sm" onClick={() => setEdit("new")}><Plus /> New bonus</Button>}
        filters={[{ type: "select", column: "active", label: "Statuses" }]} />
      <BonusDialog value={edit} onClose={() => setEdit(null)} />
    </>
  );
}

function BonusDialog({ value, onClose }: { value: BonusCampaign | "new" | null; onClose: () => void }) {
  const qc = useQueryClient();
  const blank = { title: "", reward: "50", required: "180", start: "20:00", end: "23:00", weekdays: [1, 2, 3, 4, 5, 6, 7], startsOn: new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Kolkata" }).format(new Date()), endsOn: "", isActive: true };
  const [f, setF] = useState(blank);
  const [openedFor, setOpenedFor] = useState<typeof value>(null);
  if (value && value !== openedFor) {
    setOpenedFor(value);
    setF(value === "new" ? blank : {
      title: value.title, reward: String(value.rewardPaise / 100), required: String(value.requiredMinutes),
      start: toTime(value.windowStart), end: toTime(value.windowEnd), weekdays: value.weekdays, startsOn: value.startsOn,
      endsOn: value.endsOn ?? "", isActive: value.isActive,
    });
  }
  const save = useMutation({
    mutationFn: () => {
      const body = {
        title: f.title, rewardPaise: Math.round(Number(f.reward) * 100), requiredMinutes: Number(f.required),
        windowStart: fromTime(f.start), windowEnd: f.end === "00:00" ? 1440 : fromTime(f.end), weekdays: f.weekdays,
        startsOn: f.startsOn, endsOn: f.endsOn || null, isActive: f.isActive,
      };
      return value === "new"
        ? api("admin/bonus-campaigns", { method: "POST", body })
        : api(`admin/bonus-campaigns/${(value as BonusCampaign).id}`, { method: "PUT", body });
    },
    onSuccess: () => { toast.success("Bonus saved"); qc.invalidateQueries({ queryKey: ["bonus-campaigns"] }); onClose(); },
    onError: (e) => toast.error(e.message),
  });
  const toggleDay = (d: number) => setF({ ...f, weekdays: f.weekdays.includes(d) ? f.weekdays.filter((x) => x !== d) : [...f.weekdays, d].sort() });
  return (
    <Dialog open={!!value} onOpenChange={(o) => !o && onClose()}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>{value === "new" ? "New bonus" : "Edit bonus"}</DialogTitle>
          <DialogDescription>Example: +₹50 for staying online 3 hours between 8 and 11 PM.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Title" htmlFor="bn-t"><Input id="bn-t" value={f.title} maxLength={60} onChange={(e) => setF({ ...f, title: e.target.value })} placeholder="Evening bonus" /></Field>
          <Field label="Reward (₹)" htmlFor="bn-r"><Input id="bn-r" type="number" min={1} value={f.reward} onChange={(e) => setF({ ...f, reward: e.target.value })} /></Field>
          <Field label="Window starts (IST)" htmlFor="bn-s"><Input id="bn-s" type="time" step={900} value={f.start} onChange={(e) => setF({ ...f, start: e.target.value })} /></Field>
          <Field label="Window ends (IST)" htmlFor="bn-e"><Input id="bn-e" type="time" step={900} value={f.end} onChange={(e) => setF({ ...f, end: e.target.value })} /></Field>
          <Field label="Minutes online needed" htmlFor="bn-m"><Input id="bn-m" type="number" min={10} value={f.required} onChange={(e) => setF({ ...f, required: e.target.value })} /></Field>
          <Field label="Status" htmlFor="bn-a">
            <Button id="bn-a" type="button" variant={f.isActive ? "default" : "outline"} onClick={() => setF({ ...f, isActive: !f.isActive })}>
              {f.isActive ? "Active" : "Off"}
            </Button>
          </Field>
          <Field label="From" htmlFor="bn-from"><Input id="bn-from" type="date" value={f.startsOn} onChange={(e) => setF({ ...f, startsOn: e.target.value })} /></Field>
          <Field label="Until (optional)" htmlFor="bn-to"><Input id="bn-to" type="date" value={f.endsOn} onChange={(e) => setF({ ...f, endsOn: e.target.value })} /></Field>
        </div>
        <div className="flex flex-wrap gap-2">
          {DAYS.map((d, i) => (
            <Button key={d} type="button" size="sm" variant={f.weekdays.includes(i + 1) ? "default" : "outline"} onClick={() => toggleDay(i + 1)}>{d}</Button>
          ))}
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={save.isPending || f.title.trim().length < 3 || !f.weekdays.length} onClick={() => save.mutate()}>{save.isPending ? "Saving…" : "Save"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// --- VIP plans -------------------------------------------------------------------
function VipPlans() {
  const { data, isLoading } = useQuery({ queryKey: ["vip-plans"], queryFn: () => api<VipPlan[]>("admin/vip-plans") });
  const [edit, setEdit] = useState<VipPlan | null>(null);
  const columns = useMemo(() => [
    planCol.accessor("sku", { header: "Play product", cell: (c) => <code className="text-xs">{c.getValue()}</code> }),
    planCol.accessor("months", { header: "Length", cell: (c) => (c.getValue() === 1 ? "1 month" : `${c.getValue()} months`) }),
    planCol.accessor("pricePaise", { header: "Price", cell: (c) => <b>{rupees(c.getValue())}</b> }),
    planCol.accessor((p) => p.label ?? "", { id: "label", header: "Badge", cell: (c) => (c.getValue() ? <Badge variant="secondary">{c.getValue()}</Badge> : "—") }),
    planCol.accessor((p) => (p.isActive ? "In app" : "Hidden"), { id: "shown", header: "Shown", cell: (c) => <Badge variant={c.getValue() === "In app" ? "default" : "outline"}>{c.getValue()}</Badge> }),
    planCol.display({ id: "edit", header: "", cell: ({ row }) => <Button size="sm" variant="outline" onClick={() => setEdit(row.original)}><Pencil /> Edit</Button> }),
  ], []);
  return (
    <>
      <p className="mb-3 text-sm text-muted-foreground">Prices must match the subscription products in Google Play Console. Buying opens once Play Billing is set up; until then, give VIP from a caller&apos;s page.</p>
      <DataTable columns={columns} data={data ?? []} search={false} empty={isLoading ? "Loading…" : "No plans"} />
      <PlanDialog plan={edit} onClose={() => setEdit(null)} />
    </>
  );
}

function PlanDialog({ plan, onClose }: { plan: VipPlan | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [f, setF] = useState({ rupees: "", label: "", isActive: true });
  const [openedFor, setOpenedFor] = useState<VipPlan | null>(null);
  if (plan && plan !== openedFor) {
    setOpenedFor(plan);
    setF({ rupees: String(plan.pricePaise / 100), label: plan.label ?? "", isActive: plan.isActive });
  }
  const save = useMutation({
    mutationFn: () => api(`admin/vip-plans/${plan!.id}`, { method: "PUT", body: { pricePaise: Math.round(Number(f.rupees) * 100), label: f.label || null, isActive: f.isActive } }),
    onSuccess: () => { toast.success("Plan saved"); qc.invalidateQueries({ queryKey: ["vip-plans"] }); onClose(); },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={!!plan} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{plan?.months === 1 ? "Monthly" : `${plan?.months} months`} VIP</DialogTitle>
          <DialogDescription>Change the price in Play Console too, or buyers will see a different price.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Price (₹)" htmlFor="vp-p"><Input id="vp-p" type="number" min={1} value={f.rupees} onChange={(e) => setF({ ...f, rupees: e.target.value })} /></Field>
          <Field label="Badge" htmlFor="vp-l" hint="e.g. Best value"><Input id="vp-l" maxLength={24} value={f.label} onChange={(e) => setF({ ...f, label: e.target.value })} /></Field>
        </div>
        <Button type="button" variant={f.isActive ? "default" : "outline"} className="w-fit" onClick={() => setF({ ...f, isActive: !f.isActive })}>
          {f.isActive ? "Shown in the app" : "Hidden"}
        </Button>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={save.isPending || !(Number(f.rupees) >= 1)} onClick={() => save.mutate()}>{save.isPending ? "Saving…" : "Save"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// --- Live rooms --------------------------------------------------------------------
function Rooms() {
  const qc = useQueryClient();
  const { data, isLoading } = useQuery({ queryKey: ["admin-rooms"], queryFn: () => api<LiveRoom[]>("admin/rooms"), refetchInterval: 15_000 });
  const [ending, setEnding] = useState<LiveRoom | null>(null);
  const [reason, setReason] = useState("");
  const end = useMutation({
    mutationFn: () => api(`admin/rooms/${ending!.id}/end`, { method: "POST", body: { reason } }),
    onSuccess: () => { toast.success("Room ended"); qc.invalidateQueries({ queryKey: ["admin-rooms"] }); setEnding(null); setReason(""); },
    onError: (e) => toast.error(e.message),
  });
  const columns = useMemo(() => [
    roomCol.accessor("title", { header: "Room", cell: (c) => <b>{c.getValue()}</b> }),
    roomCol.accessor((r) => r.host.displayName, { id: "host", header: "Host",
      cell: ({ row }) => <Link href={`/companions/${row.original.host.id}`} className="font-medium hover:text-primary hover:underline">{row.original.host.displayName}</Link> }),
    roomCol.accessor("categoryName", { header: "Category" }),
    roomCol.accessor("language", { header: "Language", cell: (c) => languageName(c.getValue()) }),
    roomCol.accessor("listeners", { header: "In room", cell: (c) => <b>{c.getValue()}</b> }),
    roomCol.accessor("createdAt", { header: "Started", sortFn: "datetime", cell: (c) => dateTime(c.getValue()) }),
    roomCol.display({ id: "end", header: "", cell: ({ row }) => <Button size="sm" variant="destructive" onClick={() => setEnding(row.original)}>End room</Button> }),
  ], []);
  return (
    <>
      <DataTable columns={columns} data={data ?? []} exportName="live-rooms" empty={isLoading ? "Loading…" : "No live rooms right now"}
        filters={[{ type: "select", column: "categoryName", label: "Categories" }, { type: "select", column: "language", label: "Languages", format: languageName }]} />
      <Dialog open={!!ending} onOpenChange={(o) => !o && setEnding(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>End “{ending?.title}”?</DialogTitle>
            <DialogDescription>Everyone in the room is disconnected. The reason is saved in the audit log.</DialogDescription>
          </DialogHeader>
          <Field label="Reason" htmlFor="rm-reason"><Textarea id="rm-reason" value={reason} onChange={(e) => setReason(e.target.value)} /></Field>
          <DialogFooter>
            <Button variant="outline" onClick={() => setEnding(null)}>Cancel</Button>
            <Button variant="destructive" disabled={reason.trim().length < 3 || end.isPending} onClick={() => end.mutate()}>End room</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}

// --- Lives -------------------------------------------------------------------------
const END_REASONS: Record<string, string> = { host_ended: "Host ended", host_lost: "Host app closed", admin: "Ended by admin" };

function Lives() {
  const qc = useQueryClient();
  const { data, isLoading } = useQuery({ queryKey: ["admin-lives"], queryFn: () => api<AdminLive[]>("admin/lives"), refetchInterval: 10_000 });
  const [ending, setEnding] = useState<AdminLive | null>(null);
  const [reason, setReason] = useState("");
  const end = useMutation({
    mutationFn: () => api(`admin/lives/${ending!.id}/end`, { method: "POST", body: { reason } }),
    onSuccess: () => { toast.success("Live ended"); qc.invalidateQueries({ queryKey: ["admin-lives"] }); setEnding(null); setReason(""); },
    onError: (e) => toast.error(e.message),
  });
  const columns = useMemo(() => [
    liveCol.accessor("title", { header: "Live", cell: ({ row: { original: l } }) => (
      <span className="block">
        <b>{l.title}</b>
        <span className="block text-xs text-muted-foreground">
          <Link href={`/companions/${l.host.id}`} className="hover:text-primary hover:underline">{l.host.displayName}</Link> · {languageName(l.language)}
        </span>
      </span>
    ) }),
    liveCol.accessor((l) => (l.status === "live" ? "Live now" : END_REASONS[l.endReason ?? ""] ?? "Ended"), { id: "status", header: "Status",
      cell: (c) => <Badge className={c.getValue() === "Live now" ? "bg-rose-600 text-white" : "bg-zinc-100 text-zinc-600"}>{c.getValue()}</Badge> }),
    liveCol.accessor("viewers", { header: "Watching", cell: ({ row: { original: l } }) => <span><b>{l.viewers}</b> <span className="text-xs text-muted-foreground">(peak {l.peakViewers})</span></span> }),
    liveCol.accessor("minuteCoins", { header: "Paid minutes", cell: ({ row: { original: l } }) => `${l.paidMinutes} min · ${l.minuteCoins} coins` }),
    liveCol.accessor("giftCoins", { header: "Gifts", cell: (c) => `${c.getValue()} coins` }),
    liveCol.accessor("openFlags", { header: "Safety flags", cell: (c) => (c.getValue()
      ? <Link href="/moderation"><Badge className="bg-rose-100 text-rose-700">{c.getValue()} to review</Badge></Link>
      : <span className="text-muted-foreground">None</span>) }),
    liveCol.accessor("startedAt", { header: "Started", sortFn: "datetime", cell: (c) => dateTime(c.getValue()) }),
    liveCol.display({ id: "end", header: "", cell: ({ row }) => row.original.status === "live"
      ? <Button size="sm" variant="destructive" onClick={() => setEnding(row.original)}>End live</Button> : null }),
  ], []);
  return (
    <>
      <p className="mb-3 text-sm text-muted-foreground">Companions streaming to many viewers. Viewers get a short free preview, then pay per minute (price in Pricing → Settings). Empty lives end on their own. Refreshes every 10 s.</p>
      <DataTable columns={columns} data={data ?? []} exportName="lives" empty={isLoading ? "Loading…" : "Nobody has gone live yet"}
        filters={[{ type: "select", column: "status", label: "Statuses" }]} />
      <Dialog open={!!ending} onOpenChange={(o) => !o && setEnding(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>End “{ending?.title}”?</DialogTitle>
            <DialogDescription>Everyone watching is disconnected at once. The reason is saved in the audit log.</DialogDescription>
          </DialogHeader>
          <Field label="Reason" htmlFor="lv-reason"><Textarea id="lv-reason" value={reason} onChange={(e) => setReason(e.target.value)} /></Field>
          <DialogFooter>
            <Button variant="outline" onClick={() => setEnding(null)}>Cancel</Button>
            <Button variant="destructive" disabled={reason.trim().length < 3 || end.isPending} onClick={() => end.mutate()}>End live</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}

// --- Group video -------------------------------------------------------------------
const GROUP_STATUS: Record<AdminGroup["status"], string> = { live: "Live now", lobby: "Filling up", scheduled: "Scheduled", ended: "Ended" };
const GROUP_ENDS: Record<string, string> = {
  host_ended: "Host ended", host_cancelled: "Host cancelled", host_lost: "Host app closed", host_no_show: "Host didn't open it",
  not_enough_members: "Not enough people", too_few: "Too few left", time_limit: "Time limit", admin: "Ended by admin",
};
const GROUP_BADGE: Record<string, string> = {
  "Live now": "bg-rose-600 text-white", "Filling up": "bg-amber-100 text-amber-800", Scheduled: "bg-violet-100 text-violet-700",
};

function Groups() {
  const qc = useQueryClient();
  const { data, isLoading } = useQuery({ queryKey: ["admin-groups"], queryFn: () => api<AdminGroup[]>("admin/groups"), refetchInterval: 10_000 });
  const [ending, setEnding] = useState<AdminGroup | null>(null);
  const [reason, setReason] = useState("");
  const end = useMutation({
    mutationFn: () => api(`admin/groups/${ending!.id}/end`, { method: "POST", body: { reason } }),
    onSuccess: () => { toast.success("Group ended"); qc.invalidateQueries({ queryKey: ["admin-groups"] }); setEnding(null); setReason(""); },
    onError: (e) => toast.error(e.message),
  });
  const columns = useMemo(() => [
    groupCol.accessor("title", { header: "Group", cell: ({ row: { original: g } }) => (
      <span className="block">
        <b>{g.title}</b>
        <span className="block text-xs text-muted-foreground">
          <Link href={`/companions/${g.host.id}`} className="hover:text-primary hover:underline">{g.host.displayName}</Link> · {languageName(g.language)}
        </span>
      </span>
    ) }),
    groupCol.accessor((g) => (g.status === "ended" ? GROUP_ENDS[g.endReason ?? ""] ?? "Ended" : GROUP_STATUS[g.status]), { id: "status", header: "Status",
      cell: (c) => <Badge className={GROUP_BADGE[c.getValue()] ?? "bg-zinc-100 text-zinc-600"}>{c.getValue()}</Badge> }),
    groupCol.accessor("members", { header: "Members", cell: ({ row: { original: g } }) => (g.status === "ended" ? "—" : <b>{g.members}</b>) }),
    groupCol.accessor("minuteCoins", { header: "Paid minutes", cell: ({ row: { original: g } }) => `${g.paidMinutes} min · ${g.minuteCoins} coins` }),
    groupCol.accessor("giftCoins", { header: "Gifts", cell: (c) => `${c.getValue()} coins` }),
    groupCol.accessor("openFlags", { header: "Safety flags", cell: (c) => (c.getValue()
      ? <Link href="/moderation"><Badge className="bg-rose-100 text-rose-700">{c.getValue()} to review</Badge></Link>
      : <span className="text-muted-foreground">None</span>) }),
    groupCol.accessor((g) => g.startedAt ?? g.scheduledAt ?? "", { id: "when", header: "Started / scheduled", sortFn: "datetime",
      cell: ({ row: { original: g } }) => (g.startedAt ? dateTime(g.startedAt) : g.scheduledAt ? <span>{dateTime(g.scheduledAt)} <span className="text-xs text-muted-foreground">(planned)</span></span> : "—") }),
    groupCol.display({ id: "end", header: "", cell: ({ row }) => row.original.status !== "ended"
      ? <Button size="sm" variant="destructive" onClick={() => setEnding(row.original)}>{row.original.status === "live" ? "End" : "Cancel"}</Button> : null }),
  ], []);
  return (
    <>
      <p className="mb-3 text-sm text-muted-foreground">A companion with up to 10 callers, everyone on camera. It starts when enough people are in; each member pays per minute (price and rules in Pricing → Settings). Refreshes every 10 s.</p>
      <DataTable columns={columns} data={data ?? []} exportName="group-video" empty={isLoading ? "Loading…" : "No group video yet"}
        filters={[{ type: "select", column: "status", label: "Statuses" }]} />
      <Dialog open={!!ending} onOpenChange={(o) => !o && setEnding(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{ending?.status === "live" ? "End" : "Cancel"} “{ending?.title}”?</DialogTitle>
            <DialogDescription>Everyone is disconnected at once; booked members are told. The reason is saved in the audit log.</DialogDescription>
          </DialogHeader>
          <Field label="Reason" htmlFor="gr-reason"><Textarea id="gr-reason" value={reason} onChange={(e) => setReason(e.target.value)} /></Field>
          <DialogFooter>
            <Button variant="outline" onClick={() => setEnding(null)}>Keep it</Button>
            <Button variant="destructive" disabled={reason.trim().length < 3 || end.isPending} onClick={() => end.mutate()}>{ending?.status === "live" ? "End group" : "Cancel group"}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
