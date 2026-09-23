"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { Check, Pause } from "lucide-react";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { DataTable, type Features } from "@/components/data-table";
import { Field } from "@/components/form-bits";
import { PageHeader } from "@/components/sidebar";
import { StatCard } from "@/components/stat-card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { api, type AdminPayout, type PayoutList, type PayoutStatus } from "@/lib/api";
import { dateTime, rupees } from "@/lib/format";

const FLAG_LABEL: Record<string, string> = {
  upi_changed_recently: "New UPI < 24 h",
  many_short_calls: "Many 1-min calls",
  earnings_spike: "Earnings 4× usual",
};
const col = createColumnHelper<Features, AdminPayout>();

export default function PayoutsPage() {
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
      if (p.status === "requested") return (
        <div className="flex justify-end gap-2">
          <Button size="sm" variant="outline" onClick={() => setRejecting(p)}><Pause /> Reject</Button>
          <Button size="sm" onClick={() => approve.mutate(p)} disabled={approve.isPending}><Check /> Approve</Button>
        </div>
      );
      if (p.status === "failed" || p.status === "rejected") return <span className="text-xs text-destructive">{p.failureReason}</span>;
      return <span className="font-mono text-xs text-muted-foreground">{p.providerRef}</span>;
    } }),
  ], [approve]);

  const t = data?.totals;
  return (
    <>
      <PageHeader title="Payouts" description="Approve companion withdrawals to UPI. Flagged requests need a manual check.">
        <Badge variant="outline">Provider: simulator (no real money)</Badge>
      </PageHeader>
      <div className="mb-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard index={0} label="Pending" value={t?.requestedPaise} format={rupees} hint={t && `${t.requestedCount} requests`} />
        <StatCard index={1} label="Flagged for review" value={t?.flaggedCount} tone={t && t.flaggedCount ? "warning" : "default"} hint="Check before approving" />
        <StatCard index={2} label="Paid this week" value={t?.paidThisWeekPaise} format={rupees} tone="success" />
        <StatCard index={3} label="TDS held this month" value={t?.tdsThisMonthPaise} format={rupees} hint="File quarterly" />
      </div>

      <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <Tabs value={status} onValueChange={(v) => setStatus(v as PayoutStatus)}>
          <TabsList>
            <TabsTrigger value="requested">Pending</TabsTrigger>
            <TabsTrigger value="processing">Processing</TabsTrigger>
            <TabsTrigger value="paid">Paid</TabsTrigger>
            <TabsTrigger value="failed">Failed</TabsTrigger>
            <TabsTrigger value="rejected">Rejected</TabsTrigger>
          </TabsList>
        </Tabs>
        {status === "requested" && clean.length > 0 && (
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
