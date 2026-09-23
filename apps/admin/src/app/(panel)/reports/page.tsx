"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { DataTable, type Features } from "@/components/data-table";
import { Field } from "@/components/form-bits";
import { PageHeader } from "@/components/sidebar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { api, type Report } from "@/lib/api";
import { dateTime, REPORT_REASONS } from "@/lib/format";

type Status = "open" | "actioned" | "dismissed";
const col = createColumnHelper<Features, Report>();

export default function ReportsPage() {
  const [status, setStatus] = useState<Status>("open");
  const [acting, setActing] = useState<{ report: Report; decision: "dismiss" | "suspend" } | null>(null);
  const { data, isLoading } = useQuery({ queryKey: ["reports", status], queryFn: () => api<Report[]>(`admin/reports?status=${status}&limit=1000`) });

  const columns = useMemo(() => [
    col.accessor("createdAt", { header: "When", sortFn: "datetime", cell: (c) => <span className="whitespace-nowrap">{dateTime(c.getValue())}</span> }),
    col.accessor((r) => r.reporter.displayName, { id: "reporter", header: "Reported by", cell: ({ row }) => (
      <span>{row.original.reporter.displayName} <span className="text-xs text-muted-foreground">({row.original.reporter.role})</span></span>
    ) }),
    col.accessor((r) => r.reported.displayName, { id: "reported", header: "Reported", cell: ({ row }) => {
      const t = row.original.reported;
      return (
        <span className="space-x-1.5">
          <b>{t.displayName}</b>
          <span className="text-xs text-muted-foreground">({t.role})</span>
          {t.reportsAgainst > 1 && <Badge variant="outline" className="border-destructive text-destructive">{t.reportsAgainst} reports</Badge>}
          {t.status !== "active" && <Badge variant="secondary">{t.status}</Badge>}
        </span>
      );
    } }),
    col.accessor("reason", { header: "Reason", cell: ({ row }) => (
      <div className="max-w-xs">
        <div>{REPORT_REASONS[row.original.reason] ?? row.original.reason}</div>
        {row.original.details && <div className="truncate text-xs text-muted-foreground">“{row.original.details}”</div>}
        {row.original.recording && (
          <Badge variant="outline" className="mt-1 text-[11px]">
            {{ recording: "🔴 Recording call audio", ready: "Audio saved", failed: "Recording failed",
               deleted: "Audio deleted", disabled: "Recording not set up" }[row.original.recording]}
          </Badge>
        )}
      </div>
    ) }),
    col.display({ id: "action", header: "", cell: ({ row }) => row.original.status === "open" ? (
      <div className="flex justify-end gap-2">
        <Button size="sm" variant="outline" onClick={() => setActing({ report: row.original, decision: "dismiss" })}>Dismiss</Button>
        <Button size="sm" variant="destructive" onClick={() => setActing({ report: row.original, decision: "suspend" })}>Suspend</Button>
      </div>
    ) : <span className="text-xs text-muted-foreground">{row.original.resolutionNote}</span> }),
  ], []);

  return (
    <>
      <PageHeader title="Reports" description="Reports from users during and after calls. Reporting also blocks the pair from matching again." />
      <Tabs value={status} onValueChange={(v) => setStatus(v as Status)} className="mb-4">
        <TabsList>
          <TabsTrigger value="open">Open</TabsTrigger>
          <TabsTrigger value="actioned">Actioned</TabsTrigger>
          <TabsTrigger value="dismissed">Dismissed</TabsTrigger>
        </TabsList>
      </Tabs>
      <DataTable columns={columns} data={data ?? []} exportName={`reports-${status}`} searchPlaceholder="Search names…"
        filters={[
          { type: "select", column: "reason", label: "Reasons", format: (v) => REPORT_REASONS[v] ?? v },
          { type: "date", column: "createdAt", label: "Reported" },
        ]}
        empty={isLoading ? "Loading…" : status === "open" ? "No open reports 🎉" : "Nothing here"} />
      <ResolveDialog acting={acting} onClose={() => setActing(null)} />
    </>
  );
}

function ResolveDialog({ acting, onClose }: { acting: { report: Report; decision: "dismiss" | "suspend" } | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [note, setNote] = useState("");
  const resolve = useMutation({
    mutationFn: () => api(`admin/reports/${acting!.report.id}/resolve`, { method: "POST", body: { decision: acting!.decision, note } }),
    onSuccess: () => {
      toast.success(acting!.decision === "suspend" ? `${acting!.report.reported.displayName} suspended` : "Report dismissed");
      qc.invalidateQueries({ queryKey: ["reports"] });
      qc.invalidateQueries({ queryKey: ["dashboard"] });
      setNote("");
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });
  const suspend = acting?.decision === "suspend";
  return (
    <Dialog open={!!acting} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{suspend ? `Suspend ${acting?.report.reported.displayName}?` : "Dismiss this report?"}</DialogTitle>
          <DialogDescription>
            {suspend
              ? "They are signed out everywhere, taken offline, and any call they are on ends now. You can reactivate them later from their user page."
              : "The report is closed with no action. The two users stay blocked from each other."}
          </DialogDescription>
        </DialogHeader>
        <Field label="Note for the audit log" htmlFor="note" hint="At least 3 characters">
          <Textarea id="note" value={note} onChange={(e) => setNote(e.target.value)} placeholder={suspend ? "e.g. Confirmed abusive language on call" : "e.g. No evidence"} />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button variant={suspend ? "destructive" : "default"} disabled={note.trim().length < 3 || resolve.isPending} onClick={() => resolve.mutate()}>
            {resolve.isPending ? "Saving…" : suspend ? "Suspend" : "Dismiss"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
