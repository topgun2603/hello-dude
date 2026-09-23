"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import {
  BadgeIndianRupee, Check, Clock, Coins, Flame, Gift, History, IdCard, Pencil, Percent, Plus, RotateCcw, SlidersHorizontal, Star,
  UserPlus, UsersRound, Wallet,
} from "lucide-react";
import { useMemo, useRef, useState } from "react";
import { toast } from "sonner";
import { Coin, CoinStack } from "@/components/coin";
import { DataTable, type Features } from "@/components/data-table";
import { Dropdown } from "@/components/dropdown";
import { Field } from "@/components/form-bits";
import { PageHeader } from "@/components/sidebar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { api, type AdminGift, type AdminSetting, type CallRate, type CallType, type CoinPackage } from "@/lib/api";
import { date, LANGUAGES, languageName, rupees } from "@/lib/format";
import { cn } from "@/lib/utils";

const rateCol = createColumnHelper<Features, CallRate>();
const packCol = createColumnHelper<Features, CoinPackage>();

export default function PricingPage() {
  const rates = useQuery({ queryKey: ["rates"], queryFn: () => api<CallRate[]>("admin/rates") });
  const packs = useQuery({ queryKey: ["packages"], queryFn: () => api<CoinPackage[]>("admin/coin-packages") });
  const [rateDraft, setRateDraft] = useState<Partial<CallRate> | null>(null);
  const [packDraft, setPackDraft] = useState<CoinPackage | "new" | null>(null);
  const [showHistory, setShowHistory] = useState(false);

  const rateColumns = useMemo(() => [
    rateCol.accessor("language", { header: "Language", cell: (c) => <span className="font-medium">{languageName(c.getValue())}</span> }),
    rateCol.accessor("callType", { header: "Type", cell: (c) => (c.getValue() === "audio" ? "Voice" : "Video") }),
    rateCol.accessor("coinsPerMin", { header: "Coins / min", cell: (c) => <b>{c.getValue()}</b> }),
    rateCol.accessor("companionPaisePerMin", { header: "Companion earns / min", cell: (c) => rupees(c.getValue()) }),
    rateCol.display({
      id: "share", header: "Share",
      cell: ({ row }) => {
        // What the companion gets per coin the caller spends (1 coin ≈ ₹0.80 at the popular pack).
        const perCoin = row.original.companionPaisePerMin / row.original.coinsPerMin / 100;
        return <span className="text-muted-foreground">{rupees(Math.round(perCoin * 100))} / coin</span>;
      },
    }),
    rateCol.accessor("effectiveFrom", { header: "Effective from", sortFn: "datetime", cell: (c) => date(c.getValue()) }),
    rateCol.accessor("status", {
      header: "Status",
      cell: (c) => (
        <Badge variant={c.getValue() === "current" ? "default" : "outline"}
          className={c.getValue() === "scheduled" ? "border-warning text-warning" : c.getValue() === "past" ? "text-muted-foreground" : ""}>
          {c.getValue()}
        </Badge>
      ),
    }),
    rateCol.display({
      id: "edit", header: "",
      cell: ({ row }) => row.original.status !== "past" && (
        <Button size="sm" variant="ghost" onClick={() => setRateDraft(row.original)}><Pencil /> Change</Button>
      ),
    }),
  ], []);

  const packColumns = useMemo(() => [
    packCol.accessor("sku", { header: "Play SKU", cell: (c) => <code className="text-xs">{c.getValue()}</code> }),
    packCol.accessor("coins", { header: "Coins", cell: ({ row }) => (
      <span className="inline-flex items-center gap-1.5"><Coin size={16} /><b>{row.original.coins}</b>{row.original.bonusCoins > 0 && <span className="text-success"> +{row.original.bonusCoins}</span>}</span>
    ) }),
    packCol.accessor("pricePaise", { header: "Price", cell: (c) => <b>{rupees(c.getValue())}</b> }),
    packCol.display({
      id: "perCoin", header: "₹ / coin",
      cell: ({ row }) => rupees(Math.round(row.original.pricePaise / (row.original.coins + row.original.bonusCoins))),
    }),
    packCol.accessor("label", { header: "Badge", cell: (c) => c.getValue() ? <Badge variant="secondary">{c.getValue()}</Badge> : null }),
    packCol.accessor("isActive", { header: "In app", cell: (c) => c.getValue()
      ? <span className="text-success">Shown</span> : <span className="text-muted-foreground">Hidden</span> }),
    packCol.display({
      id: "edit", header: "",
      cell: ({ row }) => <Button size="sm" variant="ghost" onClick={() => setPackDraft(row.original)}><Pencil /> Edit</Button>,
    }),
  ], []);

  const visibleRates = (rates.data ?? []).filter((r) => showHistory || r.status !== "past");
  const gifts = useQuery({ queryKey: ["gifts"], queryFn: () => api<AdminGift[]>("admin/gifts") });
  const tabs = [
    { value: "rates", label: "Call rates", icon: BadgeIndianRupee, count: rates.data?.filter((r) => r.status === "current").length },
    { value: "packs", label: "Coin packs", icon: Coins, count: packs.data?.length },
    { value: "gifts", label: "Gifts", icon: Gift, count: gifts.data?.length },
    { value: "money", label: "Money settings", icon: SlidersHorizontal, count: undefined },
  ];

  return (
    <>
      <PageHeader title="Pricing" description="Call rates, coin packs, gifts and money settings. Changes reach the app without an update." />

      <Tabs defaultValue="rates" className="gap-5">
        <TabsList className="h-auto w-full max-w-full justify-start gap-1 overflow-x-auto overflow-y-hidden [scrollbar-width:none] [&::-webkit-scrollbar]:hidden rounded-2xl border border-[#EFEAF6] bg-white/90 p-1.5 shadow-[0_12px_32px_-22px_rgba(109,40,217,0.25)] sm:w-fit">
          {tabs.map(({ value, label, icon: Icon, count }) => (
            <TabsTrigger key={value} value={value}
              className="h-10 flex-none gap-2 rounded-xl px-4 text-sm font-semibold text-foreground/70 data-active:bg-[linear-gradient(90deg,#EC4899,#DB2777)] data-active:text-white data-active:shadow-[0_8px_18px_-10px_rgba(219,39,119,0.9)] hover:text-foreground data-active:hover:text-white">
              <Icon className="size-4" /> {label}
              {count != null && (
                <span className="rounded-full bg-black/5 px-1.5 text-xs font-bold group-data-active:bg-white/25 [[data-active]_&]:bg-white/25">{count}</span>
              )}
            </TabsTrigger>
          ))}
        </TabsList>

      <TabsContent value="rates">
      <Card>
        <CardHeader className="flex flex-row flex-wrap items-start justify-between gap-3">
          <div>
            <CardTitle>Call rates</CardTitle>
            <CardDescription>New rates apply to calls that start after the effective time. Calls in progress keep their old rate.</CardDescription>
          </div>
          <div className="flex gap-2">
            <Button variant="outline" size="sm" onClick={() => setShowHistory((v) => !v)}>
              <History /> {showHistory ? "Hide history" : "Show history"}
            </Button>
            <Button size="sm" onClick={() => setRateDraft({})}><Plus /> Add rate</Button>
          </div>
        </CardHeader>
        <CardContent>
          <DataTable columns={rateColumns} data={visibleRates} exportName="call-rates" search={false}
            filters={[
              { type: "select", column: "language", label: "Languages", format: languageName },
              { type: "select", column: "callType", label: "Types", format: (v) => (v === "audio" ? "Voice" : "Video") },
              { type: "select", column: "status", label: "Statuses" },
              { type: "date", column: "effectiveFrom", label: "Effective" },
            ]} empty={rates.isLoading ? "Loading…" : "No rates yet"} />
        </CardContent>
      </Card>
      </TabsContent>

      <TabsContent value="packs">
      <Card>
        <CardHeader className="flex flex-row flex-wrap items-start justify-between gap-3">
          <div className="flex items-center gap-4">
            <CoinStack width={96} className="hidden sm:block" />
            <div>
              <CardTitle>Coin packs</CardTitle>
              <CardDescription>Shown in the app&apos;s Wallet. The price must also be set on the matching product in Google Play Console.</CardDescription>
            </div>
          </div>
          <Button size="sm" onClick={() => setPackDraft("new")}><Plus /> Add pack</Button>
        </CardHeader>
        <CardContent>
          <DataTable columns={packColumns} data={packs.data ?? []} exportName="coin-packs" search={false}
            filters={[{ type: "select", column: "isActive", label: "Visibility", format: (v) => (v === "true" ? "In app" : "Hidden") }]} empty={packs.isLoading ? "Loading…" : "No packs"} />
        </CardContent>
      </Card>
      </TabsContent>

      <TabsContent value="gifts"><GiftsCard /></TabsContent>
      <TabsContent value="money"><SettingsCard /></TabsContent>
      </Tabs>

      <RateDialog draft={rateDraft} onClose={() => setRateDraft(null)} />
      <PackDialog draft={packDraft} onClose={() => setPackDraft(null)} />
    </>
  );
}

// ---------------------------------------------------------------------------
function RateDialog({ draft, onClose }: { draft: Partial<CallRate> | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [form, setForm] = useState({ language: "ta", callType: "audio" as CallType, coins: "", rupees: "", when: "" });
  const [openedFor, setOpenedFor] = useState<Partial<CallRate> | null>(null);
  if (draft && draft !== openedFor) {
    // Pre-fill from the row being changed (or blank for "Add rate").
    setOpenedFor(draft);
    setForm({
      language: draft.language ?? "ta", callType: draft.callType ?? "audio",
      coins: draft.coinsPerMin?.toString() ?? "", rupees: draft.companionPaisePerMin ? (draft.companionPaisePerMin / 100).toString() : "", when: "",
    });
  }

  const save = useMutation({
    mutationFn: () => api<CallRate>("admin/rates", {
      method: "POST",
      body: {
        language: form.language, callType: form.callType, coinsPerMin: Number(form.coins),
        companionPaisePerMin: Math.round(Number(form.rupees) * 100),
        effectiveFrom: form.when ? new Date(form.when).toISOString() : null,
      },
    }),
    onSuccess: (r) => {
      toast.success(r.status === "scheduled" ? `Rate scheduled for ${date(r.effectiveFrom)}` : "New rate is live for new calls");
      qc.invalidateQueries({ queryKey: ["rates"] });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });

  const valid = Number(form.coins) >= 1 && form.rupees !== "" && Number(form.rupees) >= 0;
  return (
    <Dialog open={!!draft} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{draft?.id ? "Change rate" : "Add rate"}</DialogTitle>
          <DialogDescription>Creates a new version. The old rate stays in history and running calls are not affected.</DialogDescription>
        </DialogHeader>
        <form id="rate-form" className="grid gap-4 sm:grid-cols-2" onSubmit={(e) => { e.preventDefault(); save.mutate(); }}>
          <Field label="Language" htmlFor="lang">
            <Dropdown id="lang" value={form.language} disabled={!!draft?.id} onValueChange={(v) => setForm({ ...form, language: v })}
              options={Object.entries(LANGUAGES).map(([code, name]) => ({ value: code, label: name }))} />
          </Field>
          <Field label="Call type" htmlFor="type">
            <Dropdown id="type" value={form.callType} disabled={!!draft?.id} onValueChange={(v) => setForm({ ...form, callType: v as CallType })}
              options={[{ value: "audio", label: "Voice" }, { value: "video", label: "Video" }]} />
          </Field>
          <Field label="Coins per minute" htmlFor="coins" hint="What the caller pays">
            <Input id="coins" type="number" min={1} max={1000} value={form.coins} onChange={(e) => setForm({ ...form, coins: e.target.value })} />
          </Field>
          <Field label="Companion earns per minute (₹)" htmlFor="rupees" hint="Max ₹1 per coin charged">
            <Input id="rupees" type="number" min={0} step="0.01" value={form.rupees} onChange={(e) => setForm({ ...form, rupees: e.target.value })} />
          </Field>
          <div className="sm:col-span-2">
            <Field label="Start" htmlFor="when" hint="Leave empty to start now">
              <Input id="when" type="datetime-local" value={form.when} onChange={(e) => setForm({ ...form, when: e.target.value })} />
            </Field>
          </div>
        </form>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button type="submit" form="rate-form" disabled={!valid || save.isPending}>{save.isPending ? "Saving…" : form.when ? "Schedule" : "Apply now"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ---------------------------------------------------------------------------
function PackDialog({ draft, onClose }: { draft: CoinPackage | "new" | null; onClose: () => void }) {
  const qc = useQueryClient();
  const blank = { sku: "", coins: "", bonusCoins: "0", rupees: "", label: "", isActive: true, sortOrder: "10" };
  const [form, setForm] = useState(blank);
  const [openedFor, setOpenedFor] = useState<CoinPackage | "new" | null>(null);
  if (draft && draft !== openedFor) {
    setOpenedFor(draft);
    setForm(draft === "new" ? blank : {
      sku: draft.sku, coins: String(draft.coins), bonusCoins: String(draft.bonusCoins), rupees: String(draft.pricePaise / 100),
      label: draft.label ?? "", isActive: draft.isActive, sortOrder: String(draft.sortOrder),
    });
  }
  const isNew = draft === "new";

  const save = useMutation({
    mutationFn: () => {
      const body = {
        coins: Number(form.coins), bonusCoins: Number(form.bonusCoins), pricePaise: Math.round(Number(form.rupees) * 100),
        label: form.label.trim() || null, isActive: form.isActive, sortOrder: Number(form.sortOrder),
      };
      return isNew
        ? api<CoinPackage>("admin/coin-packages", { method: "POST", body: { ...body, sku: form.sku } })
        : api<CoinPackage>(`admin/coin-packages/${(draft as CoinPackage).id}`, { method: "PUT", body });
    },
    onSuccess: () => {
      toast.success(isNew ? "Pack added" : "Pack updated");
      qc.invalidateQueries({ queryKey: ["packages"] });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });

  return (
    <Dialog open={!!draft} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{isNew ? "Add coin pack" : `Edit ${form.sku}`}</DialogTitle>
          <DialogDescription>Remember to set the same price on this product in Google Play Console.</DialogDescription>
        </DialogHeader>
        <form id="pack-form" className="grid gap-4 sm:grid-cols-2" onSubmit={(e) => { e.preventDefault(); save.mutate(); }}>
          {isNew && (
            <div className="sm:col-span-2">
              <Field label="Play SKU" htmlFor="sku" hint="Must match the product ID in Play Console, e.g. coins_500">
                <Input id="sku" value={form.sku} onChange={(e) => setForm({ ...form, sku: e.target.value.toLowerCase() })} />
              </Field>
            </div>
          )}
          <Field label="Coins" htmlFor="coins"><Input id="coins" type="number" min={1} value={form.coins} onChange={(e) => setForm({ ...form, coins: e.target.value })} /></Field>
          <Field label="Bonus coins" htmlFor="bonus"><Input id="bonus" type="number" min={0} value={form.bonusCoins} onChange={(e) => setForm({ ...form, bonusCoins: e.target.value })} /></Field>
          <Field label="Price (₹)" htmlFor="price"><Input id="price" type="number" min={1} step="0.01" value={form.rupees} onChange={(e) => setForm({ ...form, rupees: e.target.value })} /></Field>
          <Field label="Badge" htmlFor="label" hint="e.g. Popular, Best value"><Input id="label" maxLength={24} value={form.label} onChange={(e) => setForm({ ...form, label: e.target.value })} /></Field>
          <Field label="Order" htmlFor="order"><Input id="order" type="number" min={0} value={form.sortOrder} onChange={(e) => setForm({ ...form, sortOrder: e.target.value })} /></Field>
          <label className="flex items-center gap-2 self-end pb-2 text-sm">
            <input type="checkbox" className="size-4 accent-primary" checked={form.isActive} onChange={(e) => setForm({ ...form, isActive: e.target.checked })} />
            Show in app
          </label>
        </form>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button type="submit" form="pack-form" disabled={save.isPending || !form.coins || !form.rupees || (isNew && !form.sku)}>
            {save.isPending ? "Saving…" : "Save"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ---------------------------------------------------------------------------
const panel = "rounded-3xl border border-[#EFEAF6] bg-white/90 p-5 shadow-[0_12px_32px_-22px_rgba(109,40,217,0.25)] sm:p-6";
const gradientButton = "inline-flex h-10 items-center gap-2 rounded-xl bg-[linear-gradient(90deg,#A855F7,#7C3AED)] px-4 text-sm font-semibold text-white shadow-[0_10px_22px_-12px_rgba(124,58,237,0.9)] transition hover:brightness-110 disabled:opacity-50";

function SectionHeader({ icon: Icon, tint, title, description, action }: {
  icon: React.ElementType; tint: string; title: string; description: string; action?: React.ReactNode;
}) {
  return (
    <header className="flex flex-wrap items-start justify-between gap-3">
      <div className="flex items-center gap-3">
        <span className={cn("grid size-10 shrink-0 place-items-center rounded-xl", tint)}><Icon className="size-5" /></span>
        <div>
          <h2 className="font-heading text-lg font-bold">{title}</h2>
          <p className="text-sm text-muted-foreground">{description}</p>
        </div>
      </div>
      {action}
    </header>
  );
}

function GiftsCard() {
  const qc = useQueryClient();
  const [adding, setAdding] = useState(false);
  const { data, isLoading } = useQuery({ queryKey: ["gifts"], queryFn: () => api<AdminGift[]>("admin/gifts") });
  const save = useMutation({
    mutationFn: (g: AdminGift) => api<AdminGift>(`admin/gifts/${g.id}`, {
      method: "PUT", body: { name: g.name, emoji: g.emoji, coins: g.coins, isActive: g.isActive, sortOrder: g.sortOrder },
    }),
    onSuccess: (g) => { toast.success(`${g.emoji} ${g.name} saved`); qc.invalidateQueries({ queryKey: ["gifts"] }); },
    onError: (e) => toast.error(e.message),
  });
  return (
    <section className={panel}>
      <SectionHeader icon={Gift} tint="bg-pink-50 text-pink-500" title="Gifts"
        description="Callers send these during a call. The companion's share is set in Money settings."
        action={<button type="button" className={gradientButton} onClick={() => setAdding(true)}><Plus className="size-4" /> Add gift</button>} />
      <div className="mt-5 grid gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        {isLoading && Array.from({ length: 8 }, (_, i) => <div key={i} className="h-36 animate-pulse rounded-2xl bg-muted/60" />)}
        {data?.map((g) => <GiftTile key={`${g.id}-${g.coins}`} gift={g} onSave={(x) => save.mutate(x)} saving={save.isPending} />)}
      </div>
      <AddGiftDialog open={adding} onClose={() => setAdding(false)} />
    </section>
  );
}

/** Accessible on/off switch in the brand purple. */
function Switch({ checked, onChange, label, disabled }: { checked: boolean; onChange: (v: boolean) => void; label: string; disabled?: boolean }) {
  return (
    <button type="button" role="switch" aria-checked={checked} aria-label={label} disabled={disabled}
      onClick={() => onChange(!checked)}
      className={cn("relative h-6 w-11 shrink-0 rounded-full transition-colors outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:opacity-60",
        checked ? "bg-[linear-gradient(90deg,#A855F7,#7C3AED)]" : "bg-slate-300")}>
      <span className={cn("absolute left-0 top-0.5 size-5 rounded-full bg-white shadow transition-transform", checked ? "translate-x-[22px]" : "translate-x-0.5")} />
    </button>
  );
}

function GiftTile({ gift, onSave, saving }: { gift: AdminGift; onSave: (g: AdminGift) => void; saving: boolean }) {
  const [coins, setCoins] = useState(String(gift.coins));
  const input = useRef<HTMLInputElement>(null);
  const changed = Number(coins) !== gift.coins;
  const valid = Number.isInteger(Number(coins)) && Number(coins) >= 1;
  return (
    <div className={cn("rounded-2xl border border-[#EFEAF6] bg-white p-4 shadow-[0_1px_2px_rgba(20,18,43,0.04)] transition hover:shadow-md", !gift.isActive && "bg-muted/30")}>
      <div className="flex items-start justify-between">
        <span className={cn("text-4xl leading-none", !gift.isActive && "grayscale")} aria-hidden>{gift.emoji}</span>
        <Switch checked={gift.isActive} disabled={saving} label={`Show ${gift.name} in the app`}
          onChange={(v) => onSave({ ...gift, isActive: v })} />
      </div>
      <p className="mt-3 font-semibold">{gift.name}{!gift.isActive && <span className="ml-2 text-xs font-normal text-muted-foreground">Hidden</span>}</p>
      <div className="mt-2 flex items-center gap-2">
        <div className="relative flex-1">
          <Input ref={input} aria-label={`${gift.name} price in coins`} type="number" min={1} value={coins}
            onChange={(e) => setCoins(e.target.value)} onKeyDown={(e) => e.key === "Enter" && changed && valid && onSave({ ...gift, coins: Number(coins) })}
            className="h-10 rounded-xl pr-14 font-semibold tabular-nums" />
          <span className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-xs text-muted-foreground">coins</span>
        </div>
        <Button size="icon" variant={changed ? "default" : "outline"} className="size-10 rounded-xl"
          aria-label={changed ? `Save ${gift.name} price` : `Edit ${gift.name} price`} disabled={saving || (changed && !valid)}
          onClick={() => (changed ? onSave({ ...gift, coins: Number(coins) }) : input.current?.select())}>
          {changed ? <Check /> : <Pencil />}
        </Button>
      </div>
    </div>
  );
}

function AddGiftDialog({ open, onClose }: { open: boolean; onClose: () => void }) {
  const qc = useQueryClient();
  const [form, setForm] = useState({ name: "", emoji: "", coins: "" });
  const create = useMutation({
    mutationFn: () => api<AdminGift>("admin/gifts", { method: "POST", body: { name: form.name.trim(), emoji: form.emoji.trim(), coins: Number(form.coins) } }),
    onSuccess: (g) => {
      toast.success(`${g.emoji} ${g.name} added`);
      qc.invalidateQueries({ queryKey: ["gifts"] });
      setForm({ name: "", emoji: "", coins: "" });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });
  const valid = form.name.trim().length > 0 && form.emoji.trim().length > 0 && Number.isInteger(Number(form.coins)) && Number(form.coins) >= 1;
  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Add gift</DialogTitle>
          <DialogDescription>It appears in the app&apos;s gift sheet straight away. You can hide it later.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 sm:grid-cols-[1fr_7rem]">
          <Field label="Name" htmlFor="gift-name">
            <Input id="gift-name" maxLength={20} placeholder="e.g. Teddy" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
          </Field>
          <Field label="Emoji" htmlFor="gift-emoji">
            <Input id="gift-emoji" maxLength={8} placeholder="🧸" className="text-center text-xl" value={form.emoji} onChange={(e) => setForm({ ...form, emoji: e.target.value })} />
          </Field>
        </div>
        <Field label="Price in coins" htmlFor="gift-coins">
          <Input id="gift-coins" type="number" min={1} value={form.coins} onChange={(e) => setForm({ ...form, coins: e.target.value })} />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={!valid || create.isPending} onClick={() => create.mutate()}>{create.isPending ? "Adding…" : "Add gift"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

/** How each setting is shown: stored in paise / basis points, edited in ₹ / %. */
const SETTING_ICON: Record<string, { icon: React.ElementType; tint: string }> = {
  "gift.companion_share_bps": { icon: Gift, tint: "bg-pink-50 text-pink-500" },
  "coin.value_paise": { icon: Coins, tint: "bg-amber-50 text-amber-600" },
  "offer.first_recharge_hours": { icon: Clock, tint: "bg-violet-50 text-violet-600" },
  "refund.window_days": { icon: RotateCcw, tint: "bg-rose-50 text-rose-500" },
  "payout.min_paise": { icon: Wallet, tint: "bg-orange-50 text-orange-500" },
  "payout.tds_bps": { icon: Percent, tint: "bg-sky-50 text-sky-600" },
  "kyc.aadhaar_max_age_hours": { icon: IdCard, tint: "bg-emerald-50 text-emerald-600" },
  ...Object.fromEntries([1, 2, 3, 4, 5, 6].map((d) => [`checkin.day${d}`, { icon: Flame, tint: "bg-orange-50 text-orange-500" }])),
  "checkin.day7": { icon: Star, tint: "bg-amber-50 text-amber-500" },
  "referral.referrer_coins": { icon: Gift, tint: "bg-fuchsia-50 text-fuchsia-600" },
  "referral.referee_coins": { icon: UserPlus, tint: "bg-violet-50 text-violet-600" },
  "referral.max_rewarded": { icon: UsersRound, tint: "bg-sky-50 text-sky-600" },
};

/** Settings stored and edited as whole numbers (coins, counts). */
const whole = (unit: string) => ({ unit, toView: (v: number) => v, fromView: (v: number) => Math.round(v), step: 1 });

const SETTING_VIEW: Record<string, { unit: string; toView: (v: number) => number; fromView: (v: number) => number; step: number }> = {
  "gift.companion_share_bps": { unit: "%", toView: (v) => v / 100, fromView: (v) => Math.round(v * 100), step: 1 },
  "payout.tds_bps": { unit: "%", toView: (v) => v / 100, fromView: (v) => Math.round(v * 100), step: 0.1 },
  "coin.value_paise": { unit: "₹", toView: (v) => v / 100, fromView: (v) => Math.round(v * 100), step: 0.01 },
  "payout.min_paise": { unit: "₹", toView: (v) => v / 100, fromView: (v) => Math.round(v * 100), step: 1 },
  "offer.first_recharge_hours": { unit: "hours", toView: (v) => v, fromView: (v) => Math.round(v), step: 1 },
  "refund.window_days": { unit: "days", toView: (v) => v, fromView: (v) => Math.round(v), step: 1 },
  "kyc.aadhaar_max_age_hours": { unit: "hours", toView: (v) => v, fromView: (v) => Math.round(v), step: 1 },
  ...Object.fromEntries([1, 2, 3, 4, 5, 6, 7].map((d) => [`checkin.day${d}`, whole("coins")])),
  "referral.referrer_coins": whole("coins"),
  "referral.referee_coins": whole("coins"),
  "referral.max_rewarded": whole("friends"),
};

function SettingsCard() {
  const { data, isLoading } = useQuery({ queryKey: ["settings"], queryFn: () => api<AdminSetting[]>("admin/settings") });
  return (
    <section className={panel}>
      <SectionHeader icon={SlidersHorizontal} tint="bg-violet-50 text-violet-600" title="Money settings"
        description="Changes apply immediately and are recorded in the audit log." />
      <div className="mt-4 divide-y divide-[#F1EEF7]">
        {isLoading && Array.from({ length: 7 }, (_, i) => <div key={i} className="my-2 h-14 animate-pulse rounded-xl bg-muted/60" />)}
        {data?.map((s) => <SettingRow key={`${s.key}-${s.value}`} s={s} />)}
      </div>
    </section>
  );
}

function SettingRow({ s }: { s: AdminSetting }) {
  const qc = useQueryClient();
  const view = SETTING_VIEW[s.key] ?? { unit: "", toView: (v: number) => v, fromView: (v: number) => v, step: 1 };
  const look = SETTING_ICON[s.key] ?? { icon: SlidersHorizontal, tint: "bg-muted text-muted-foreground" };
  const Icon = look.icon;
  const [value, setValue] = useState(String(view.toView(s.value)));
  const stored = view.fromView(Number(value));
  const changed = stored !== s.value;
  const inRange = value !== "" && stored >= s.min && stored <= s.max;
  const save = useMutation({
    mutationFn: () => api(`admin/settings/${s.key}`, { method: "PUT", body: { value: stored } }),
    onSuccess: () => { toast.success("Saved"); qc.invalidateQueries({ queryKey: ["settings"] }); },
    onError: (e) => toast.error(e.message),
  });
  return (
    <div className="flex flex-wrap items-center gap-x-4 gap-y-2 py-3.5">
      <span className={cn("grid size-10 shrink-0 place-items-center rounded-xl", look.tint)}><Icon className="size-5" /></span>
      <label htmlFor={`set-${s.key}`} className="min-w-0 flex-1 text-[15px] font-medium">
        {s.label.replace(/ \((paise|basis points|coins)\)$/, "")}
        <span className={cn("block text-xs font-normal", inRange || !changed ? "text-muted-foreground" : "text-destructive")}>
          Allowed: {view.toView(s.min)}–{view.toView(s.max)} {view.unit}
        </span>
      </label>
      <div className="flex items-center gap-2">
        <Input id={`set-${s.key}`} type="number" step={view.step} className="h-10 w-28 rounded-xl font-semibold tabular-nums" value={value}
          aria-invalid={!inRange} onChange={(e) => setValue(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && changed && inRange && save.mutate()} />
        <span className="w-12 text-sm text-muted-foreground">{view.unit}</span>
        <Button size="sm" variant={changed ? "default" : "outline"} className="h-10 rounded-xl px-4"
          disabled={!changed || !inRange || save.isPending} onClick={() => save.mutate()}>
          {save.isPending ? "Saving…" : "Save"}
        </Button>
      </div>
    </div>
  );
}
