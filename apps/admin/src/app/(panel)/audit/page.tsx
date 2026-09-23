"use client";

import { useQuery } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { useMemo } from "react";
import { DataTable, type Features } from "@/components/data-table";
import { PageHeader } from "@/components/sidebar";
import { Badge } from "@/components/ui/badge";
import { api, type AuditEntry } from "@/lib/api";
import { dateTime } from "@/lib/format";

const col = createColumnHelper<Features, AuditEntry>();

/** One readable line per action; falls back to the raw details. */
function describe(a: AuditEntry): string {
  const d = a.details as Record<string, unknown>;
  switch (a.action) {
    case "rate.create": return `${d.language} ${d.callType === "audio" ? "voice" : "video"}: ${d.coinsPerMin} coins/min, companion ₹${Number(d.companionPaisePerMin) / 100}/min`;
    case "user.status": return `${d.from} → ${d.to}: ${d.reason}`;
    case "report.resolve": return `${d.decision}: ${d.note}`;
    default: return JSON.stringify(d);
  }
}

export default function AuditPage() {
  const { data, isLoading } = useQuery({ queryKey: ["audit"], queryFn: () => api<AuditEntry[]>("admin/audit?limit=1000") });
  const columns = useMemo(() => [
    col.accessor("createdAt", { header: "When", sortFn: "datetime", cell: (c) => <span className="whitespace-nowrap">{dateTime(c.getValue())}</span> }),
    col.accessor("actor", { header: "Admin" }),
    col.accessor("action", { header: "Action", cell: (c) => <Badge variant="secondary">{c.getValue()}</Badge> }),
    col.display({ id: "what", header: "Details", cell: ({ row }) => <span className="text-sm">{describe(row.original)}</span> }),
  ], []);
  return (
    <>
      <PageHeader title="Audit log" description="Every admin change, newest first. Entries can't be edited or deleted." />
      <DataTable columns={columns} data={data ?? []} pageSize={20} exportName="audit-log" searchPlaceholder="Search admin or action…"
        filters={[
          { type: "select", column: "actor", label: "Admins" },
          { type: "select", column: "action", label: "Actions" },
          { type: "date", column: "createdAt", label: "Date" },
        ]} empty={isLoading ? "Loading…" : "No admin actions yet"} />
    </>
  );
}
