"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { Check, X } from "lucide-react";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { DataTable, type Features } from "@/components/data-table";
import { Field } from "@/components/form-bits";
import { PageHeader } from "@/components/sidebar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { api, type AdminRefund, type RefundStatus } from "@/lib/api";
import { dateTime } from "@/lib/format";

const REASON: Record<AdminRefund["reason"], string> = {
  call_dropped: "Call dropped", couldnt_hear: "Couldn't hear", wrong_language: "Wrong language", other: "Other",
};
const col = createColumnHelper<Features, AdminRefund>();
const mmss = (s: number | null) => (s == null ? "—" : `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`);

export default function RefundsPage() {
  const [status, setStatus] = useState<RefundStatus>("requested");
  const [deciding, setDeciding] = useState<{ r: AdminRefund; decision: "approve" | "reject" } | null>(null);
  const { data, isLoading } = useQuery({ queryKey: ["refunds", status], queryFn: () => api<AdminRefund[]>(`admin/refunds?status=${status}`) });

  const columns = useMemo(() => [
    col.accessor("createdAt", { header: "Asked", sortFn: "datetime", cell: (c) => <span className="whitespace-nowrap">{dateTime(c.getValue())}</span> }),
    col.accessor((r) => r.caller.displayName, { id: "caller", header: "Caller", cell: ({ row }) => (
      <span><b>{row.original.caller.displayName}</b>
        {row.original.caller.refundsBefore > 0 && (
          <Badge variant="outline" className="ml-2 border-warning text-warning">{row.original.caller.refundsBefore} before</Badge>)}
      </span>
    ) }),
    col.accessor((r) => r.companion.displayName, { id: "companion", header: "Companion" }),
    col.accessor((r) => r.call.durationSeconds ?? 0, { id: "call", header: "Call", cell: ({ row }) => (
      <span className="whitespace-nowrap text-sm">
        {row.original.call.type === "video" ? "Video" : "Voice"} · {mmss(row.original.call.durationSeconds)} · {row.original.call.minutesCharged} min
        <span className="block text-xs text-muted-foreground">ended: {row.original.call.endReason ?? "—"}</span>
      </span>
    ) }),
    col.accessor("reason", { header: "Reason", cell: ({ row }) => (
      <div className="max-w-xs">
        <div>{REASON[row.original.reason]}</div>
        {row.original.details && <div className="truncate text-xs text-muted-foreground">“{row.original.details}”</div>}
      </div>
    ) }),
    col.accessor("coinsEligible", { header: "Coins", cell: ({ row }) => row.original.status === "approved"
      ? <b>{row.original.coinsRefunded} of {row.original.coinsEligible}</b> : <b>{row.original.coinsEligible}</b> }),
    col.display({ id: "action", header: "", cell: ({ row }) => row.original.status === "requested" ? (
      <div className="flex justify-end gap-2">
        <Button size="sm" variant="outline" onClick={() => setDeciding({ r: row.original, decision: "reject" })}><X /> Reject</Button>
        <Button size="sm" onClick={() => setDeciding({ r: row.original, decision: "approve" })}><Check /> Refund</Button>
      </div>
    ) : <span className="text-xs text-muted-foreground">{row.original.note}</span> }),
  ], []);

  return (
    <>
      <PageHeader title="Refunds" description="Callers ask from Call details within 7 days. Approved coins go straight back to their wallet." />
      <Tabs value={status} onValueChange={(v) => setStatus(v as RefundStatus)} className="mb-4">
        <TabsList>
          <TabsTrigger value="requested">Waiting</TabsTrigger>
          <TabsTrigger value="approved">Approved</TabsTrigger>
          <TabsTrigger value="rejected">Rejected</TabsTrigger>
        </TabsList>
      </Tabs>
      <DataTable columns={columns} data={data ?? []} exportName={`refunds-${status}`} searchPlaceholder="Search caller or companion…"
        filters={[
          { type: "select", column: "reason", label: "Reasons", format: (v) => v.replace(/_/g, " ").replace(/^\w/, (c) => c.toUpperCase()) },
          { type: "date", column: "createdAt", label: "Asked" },
        ]}
        empty={isLoading ? "Loading…" : status === "requested" ? "No refund requests waiting 🎉" : "Nothing here"} />
      <DecideDialog deciding={deciding} onClose={() => setDeciding(null)} />
    </>
  );
}

function DecideDialog({ deciding, onClose }: { deciding: { r: AdminRefund; decision: "approve" | "reject" } | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [coins, setCoins] = useState("");
  const [reverse, setReverse] = useState(false);
  const [note, setNote] = useState("");
  const [openedFor, setOpenedFor] = useState<typeof deciding>(null);
  if (deciding && deciding !== openedFor) {
    setOpenedFor(deciding);
    setCoins(String(deciding.r.coinsEligible));
    setReverse(deciding.r.reason === "wrong_language");
    setNote("");
  }
  const approve = deciding?.decision === "approve";
  const save = useMutation({
    mutationFn: () => api(`admin/refunds/${deciding!.r.id}/decide`, {
      method: "POST",
      body: approve ? { decision: "approve", coins: Number(coins), reverseCompanion: reverse, note } : { decision: "reject", note },
    }),
    onSuccess: () => {
      toast.success(approve ? `${coins} coins refunded to ${deciding!.r.caller.displayName}` : "Request rejected");
      qc.invalidateQueries({ queryKey: ["refunds"] });
      qc.invalidateQueries({ queryKey: ["dashboard"] });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });
  const max = deciding?.r.coinsEligible ?? 0;
  const validCoins = Number(coins) >= 1 && Number(coins) <= max;
  return (
    <Dialog open={!!deciding} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{approve ? `Refund ${deciding?.r.caller.displayName}` : "Reject this refund request?"}</DialogTitle>
          <DialogDescription>
            {approve ? `Up to ${max} coins can be returned for this call.` : "The caller keeps their current balance and sees your note."}
          </DialogDescription>
        </DialogHeader>
        {approve && (
          <>
            <Field label="Coins to refund" htmlFor="rf-coins" hint={`1 – ${max}`}>
              <Input id="rf-coins" type="number" min={1} max={max} value={coins} onChange={(e) => setCoins(e.target.value)} />
            </Field>
            <label className="flex items-start gap-2 text-sm">
              <input type="checkbox" className="mt-0.5 size-4 accent-primary" checked={reverse} onChange={(e) => setReverse(e.target.checked)} />
              <span>Also take {deciding?.r.companion.displayName}&apos;s share back
                <span className="block text-xs text-muted-foreground">Only when the call was their fault (e.g. wrong language, silence).</span>
              </span>
            </label>
          </>
        )}
        <Field label="Note (shown to the caller and saved in the audit log)" htmlFor="rf-note">
          <Textarea id="rf-note" value={note} onChange={(e) => setNote(e.target.value)} />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button variant={approve ? "default" : "destructive"} disabled={note.trim().length < 3 || (approve && !validCoins) || save.isPending}
            onClick={() => save.mutate()}>{approve ? "Refund" : "Reject"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
