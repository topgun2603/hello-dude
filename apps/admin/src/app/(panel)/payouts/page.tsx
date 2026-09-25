"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { motion } from "framer-motion";
import { BarChart3, Check, ChevronRight, Clock, Database, FileText, IndianRupee, Pause, ShieldAlert, Wallet } from "lucide-react";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { DataTable, type Features } from "@/components/data-table";
import { Field } from "@/components/form-bits";
import { AnimatedNumber } from "@/components/stat-card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { api, type AdminPayout, type PayoutList, type PayoutStatus } from "@/lib/api";
import { dateTime, rupees } from "@/lib/format";
import { cn } from "@/lib/utils";
import { useCan } from "@/lib/access";

const FLAG_LABEL: Record<string, string> = {
  upi_changed_recently: "New UPI < 24 h",
  many_short_calls: "Many 1-min calls",
  earnings_spike: "Earnings 4× usual",
  contact_sharing: "Shared contact in chat",
  shared_device: "Phone used by many accounts",
};
const col = createColumnHelper<Features, AdminPayout>();

export default function PayoutsPage() {
  const canDecide = useCan()("payouts.decide");
  const qc = useQueryClient();
  const [status, setStatus] = useState<PayoutStatus>("requested");
  const [rejecting, setRejecting] = useState<AdminPayout | null>(null);
  const [bulk, setBulk] = useState(false);
  const { data, isLoading } = useQuery({ queryKey: ["payouts", status], queryFn: () => api<PayoutList>(`admin/payouts?status=${status}`) });

  const approve = useMutation({
    mutationFn: (p: AdminPayout) => api<AdminPayout>(`admin/payouts/${p.id}/approve`, { method: "POST" }),
    onSuccess: (r) => {
      if (r.status === "failed") toast.error(`${r.companion.displayName}: ${r.failureReason} — returned to their balance`);
      else toast.success(`${rupees(r.netPaise)} sent to ${r.companion.displayName}`);
      qc.invalidateQueries({ queryKey: ["payouts"] });
      qc.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (e) => toast.error(e.message),
  });

  const clean = (data?.payouts ?? []).filter((p) => p.status === "requested" && p.flags.length === 0);
  async function approveClean() {
    setBulk(false);
    for (const p of clean) await approve.mutateAsync(p).catch(() => {});
  }

  const columns = useMemo(() => [
    col.accessor((p) => p.companion.displayName, { id: "companion", header: "Companion", cell: ({ row }) => <b>{row.original.companion.displayName}</b> }),
    col.accessor("createdAt", { header: "Requested", sortFn: "datetime", cell: (c) => <span className="whitespace-nowrap">{dateTime(c.getValue())}</span> }),
    col.accessor("grossPaise", { header: "Gross", cell: (c) => rupees(c.getValue()) }),
    col.accessor("tdsPaise", { header: "TDS", cell: (c) => <span className="text-muted-foreground">{rupees(c.getValue())}</span> }),
    col.accessor("netPaise", { header: "Net", cell: (c) => <b>{rupees(c.getValue())}</b> }),
    col.accessor("upi", { header: "UPI", enableSorting: false, cell: (c) => <span className="font-mono text-xs">{c.getValue()}</span> }),
    col.accessor((p) => p.flags.length, { id: "risk", header: "Risk", cell: ({ row }) => row.original.flags.length === 0
      ? <span className="text-success">Clear</span>
      : <span className="flex flex-wrap gap-1">{row.original.flags.map((f) => (
          <Badge key={f} variant="outline" className="border-warning text-warning">{FLAG_LABEL[f] ?? f}</Badge>))}</span> }),
    col.display({ id: "action", header: "", cell: ({ row }) => {
      const p = row.original;
      if (p.status === "requested" && !canDecide) return <span className="text-xs text-muted-foreground">Waiting for approval</span>;
      if (p.status === "requested") return (
        <div className="flex justify-end gap-2">
          <Button size="sm" variant="outline" onClick={() => setRejecting(p)}><Pause /> Reject</Button>
          <Button size="sm" onClick={() => approve.mutate(p)} disabled={approve.isPending}><Check /> Approve</Button>
        </div>
      );
      if (p.status === "failed" || p.status === "rejected") return <span className="text-xs text-destructive">{p.failureReason}</span>;
      return <span className="font-mono text-xs text-muted-foreground">{p.providerRef}</span>;
    } }),
  ], [approve, canDecide]);

  const t = data?.totals;
  return (
    <>
      <header className="relative mb-6 flex flex-wrap items-start justify-between gap-4 lg:-mt-12">
        <div className="flex items-center gap-4">
          <span className="grid size-16 shrink-0 place-items-center rounded-2xl bg-[linear-gradient(135deg,#FFFFFF,#FCE7F3)] shadow-[0_12px_28px_-14px_rgba(219,39,119,0.6)] ring-1 ring-pink-100">
            <IndianRupee className="size-8 text-pink-500" strokeWidth={2.5} />
          </span>
          <div>
            <h1 className="font-heading text-4xl font-extrabold tracking-tight">Payouts</h1>
            <p className="mt-1 text-muted-foreground md:text-[17px]">Approve companion withdrawals to UPI. Flagged requests need a manual check.</p>
          </div>
        </div>
        <span className="inline-flex items-center gap-2 self-end rounded-full border border-orange-200 bg-orange-50 px-3.5 py-1.5 text-sm font-medium text-orange-800 lg:mt-14">
          <Database className="size-4 text-orange-500" /> Provider: simulator (no real money)
        </span>
      </header>

      <div className="mb-6 grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
        <PayoutKpi index={0} tone="amber" icon={Clock} label="Pending" value={t?.requestedPaise} money
          hint={t && `${t.requestedCount} request${t.requestedCount === 1 ? "" : "s"}`} onOpen={() => setStatus("requested")} />
        <PayoutKpi index={1} tone="rose" icon={ShieldAlert} label="Flagged for review" value={t?.flaggedCount}
          hint="Check before approving" onOpen={() => setStatus("requested")} />
        <PayoutKpi index={2} tone="emerald" icon={Wallet} watermark={BarChart3} label="Paid this week" value={t?.paidThisWeekPaise} money
          valueClass="text-emerald-500" onOpen={() => setStatus("paid")} />
        <PayoutKpi index={3} tone="violet" icon={FileText} label="TDS held this month" value={t?.tdsThisMonthPaise} money
          hint="File quarterly" onOpen={() => setStatus("paid")} />
      </div>

      <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <Tabs value={status} onValueChange={(v) => setStatus(v as PayoutStatus)}>
          <TabsList className="h-auto gap-1 rounded-2xl border border-[#EFEAF6] bg-white/90 p-1.5 shadow-[0_12px_32px_-22px_rgba(109,40,217,0.25)]">
            <TabsTrigger value="requested" className={tabPill}>Pending</TabsTrigger>
            <TabsTrigger value="processing" className={tabPill}>Processing</TabsTrigger>
            <TabsTrigger value="paid" className={tabPill}>Paid</TabsTrigger>
            <TabsTrigger value="failed" className={tabPill}>Failed</TabsTrigger>
            <TabsTrigger value="rejected" className={tabPill}>Rejected</TabsTrigger>
          </TabsList>
        </Tabs>
        {canDecide && status === "requested" && clean.length > 0 && (
          <Button onClick={() => setBulk(true)} disabled={approve.isPending}>
            <Check /> Approve {clean.length} clean · {rupees(clean.reduce((n, p) => n + p.netPaise, 0))}
          </Button>
        )}
      </div>
      <DataTable columns={columns} data={data?.payouts ?? []} exportName={`payouts-${status}`} searchPlaceholder="Search companion or UPI…"
        filters={[
          { type: "select", column: "risk", label: "Risk", format: (v) => (v === "0" ? "No flags" : `${v} flag${v === "1" ? "" : "s"}`) },
          { type: "date", column: "createdAt", label: "Requested" },
        ]} empty={isLoading ? "Loading…" : "Nothing here"} />

      <RejectDialog payout={rejecting} onClose={() => setRejecting(null)} />
      <Dialog open={bulk} onOpenChange={setBulk}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Approve {clean.length} clean withdrawals?</DialogTitle>
            <DialogDescription>Sends {rupees(clean.reduce((n, p) => n + p.netPaise, 0))} in total. Flagged requests are skipped.</DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setBulk(false)}>Cancel</Button>
            <Button onClick={approveClean}>Approve all</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}

const tabPill = "h-10 flex-none rounded-xl px-5 text-[15px] font-semibold text-foreground/60 hover:text-foreground data-active:bg-[linear-gradient(90deg,#8B5CF6,#7C3AED)] data-active:text-white data-active:shadow-[0_8px_18px_-10px_rgba(124,58,237,0.9)] data-active:hover:text-white";

const KPI_TONES = {
  amber: { card: "from-[#FFFBF2] to-white", tile: "bg-[linear-gradient(135deg,#FCD34D,#F59E0B)]", chevron: "bg-amber-50 text-amber-500", wave: "#F59E0B", watermark: "text-amber-400/25" },
  rose: { card: "from-[#FFF5F7] to-white", tile: "bg-[linear-gradient(135deg,#FB7185,#E11D48)]", chevron: "bg-rose-50 text-rose-500", wave: "#F43F5E", watermark: "text-rose-400/25" },
  emerald: { card: "from-[#F0FDF7] to-white", tile: "bg-[linear-gradient(135deg,#6EE7B7,#10B981)]", chevron: "bg-emerald-50 text-emerald-500", wave: "#10B981", watermark: "text-emerald-400/30" },
  violet: { card: "from-[#F7F4FF] to-white", tile: "bg-[linear-gradient(135deg,#A78BFA,#7C3AED)]", chevron: "bg-violet-50 text-violet-500", wave: "#8B5CF6", watermark: "text-violet-400/25" },
};

/** KPI card from the Payouts design: icon tile, big value, faded watermark icon and a soft decorative wave. */
function PayoutKpi({ index, tone, icon: Icon, watermark, label, value, money, hint, valueClass, onOpen }: {
  index: number; tone: keyof typeof KPI_TONES; icon: React.ElementType; watermark?: React.ElementType; label: string;
  value: number | undefined; money?: boolean; hint?: React.ReactNode; valueClass?: string; onOpen: () => void;
}) {
  const t = KPI_TONES[tone];
  const Mark = watermark ?? Icon;
  return (
    <motion.button type="button" onClick={onOpen} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.06 }}
      className={cn("group relative flex flex-col overflow-hidden rounded-3xl border border-[#EFEAF6] bg-gradient-to-b p-5 pb-9 text-left",
        "shadow-[0_14px_34px_-24px_rgba(109,40,217,0.45)] transition hover:-translate-y-0.5 hover:shadow-[0_18px_40px_-22px_rgba(109,40,217,0.5)]", t.card)}>
      <div className="relative flex items-start gap-4">
        <span className={cn("grid size-14 shrink-0 place-items-center rounded-2xl text-white shadow-md", t.tile)}>
          <Icon className="size-7" />
        </span>
        <div className="min-w-0 flex-1">
          <p className="truncate text-base font-semibold">{label}</p>
          <p className={cn("mt-1 font-heading text-4xl font-extrabold leading-none tracking-tight", valueClass)}>
            {value === undefined ? <span className="text-muted-foreground/40">—</span>
              : <AnimatedNumber value={value} format={money ? rupees : undefined} />}
          </p>
          {hint && <p className="mt-3 pr-10 text-sm text-muted-foreground">{hint}</p>}
        </div>
        <span className={cn("grid size-8 shrink-0 place-items-center rounded-full transition group-hover:translate-x-0.5", t.chevron)} aria-hidden>
          <ChevronRight className="size-4" />
        </span>
      </div>
      <Mark aria-hidden className={cn("pointer-events-none absolute bottom-8 right-5 size-14", t.watermark)} strokeWidth={1.5} />
      {/* Decorative only: a soft filled wave, not a chart. */}
      <svg aria-hidden viewBox="0 0 400 40" preserveAspectRatio="none" className="pointer-events-none absolute inset-x-0 bottom-0 h-8 w-full">
        <path d="M0 30 C 60 30, 90 14, 150 18 S 250 34, 300 22 S 370 12, 400 20 L 400 40 L 0 40 Z" fill={t.wave} opacity="0.12" />
        <path d="M0 30 C 60 30, 90 14, 150 18 S 250 34, 300 22 S 370 12, 400 20" fill="none" stroke={t.wave} strokeOpacity="0.35" strokeWidth="2" />
      </svg>
    </motion.button>
  );
}

function RejectDialog({ payout, onClose }: { payout: AdminPayout | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [reason, setReason] = useState("");
  const reject = useMutation({
    mutationFn: () => api(`admin/payouts/${payout!.id}/reject`, { method: "POST", body: { reason } }),
    onSuccess: () => { toast.success("Rejected — the amount is back in their balance"); qc.invalidateQueries({ queryKey: ["payouts"] }); onClose(); setReason(""); },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={!!payout} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Reject {payout && rupees(payout.grossPaise)} for {payout?.companion.displayName}?</DialogTitle>
          <DialogDescription>The full amount goes back to their earnings balance. They see your reason in the app.</DialogDescription>
        </DialogHeader>
        <Field label="Reason" htmlFor="payout-reason">
          <Textarea id="payout-reason" value={reason} onChange={(e) => setReason(e.target.value)} placeholder="e.g. UPI name doesn't match KYC name" />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button variant="destructive" disabled={reason.trim().length < 3 || reject.isPending} onClick={() => reject.mutate()}>Reject</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
