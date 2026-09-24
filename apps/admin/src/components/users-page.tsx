"use client";

import { Menu } from "@base-ui/react/menu";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { Ban, ChevronRight, Copy, Eye, Globe, MoreVertical, RotateCcw, UserRound } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { Coin } from "@/components/coin";
import { UserAvatar } from "@/components/user-avatar";
import { DataTable, type Features, type TableFilter } from "@/components/data-table";
import { Dropdown } from "@/components/dropdown";
import { Field } from "@/components/form-bits";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Textarea } from "@/components/ui/textarea";
import { api, type AdminUser } from "@/lib/api";
import { languageName, rupees } from "@/lib/format";
import { cn } from "@/lib/utils";

const col = createColumnHelper<Features, AdminUser>();
/** Lists load this many rows; search and filters run in the browser. */
const MAX_ROWS = 1000;
export type StatusTarget = { user: Pick<AdminUser, "id" | "displayName">; status: "active" | "suspended" | "banned" };
type Target = StatusTarget;

// ---------------------------------------------------------------------------
// Small cells

/** Short, copyable reference for support conversations (first 6 of the id). */
const shortId = (id: string) => id.replace(/-/g, "").slice(0, 6).toUpperCase();

const LANGUAGE_CHIP: Record<string, string> = {
  ta: "bg-violet-100 text-violet-700", te: "bg-orange-100 text-orange-700", kn: "bg-sky-100 text-sky-700",
  ml: "bg-emerald-100 text-emerald-700", hi: "bg-rose-100 text-rose-700", bn: "bg-lime-100 text-lime-700",
  mr: "bg-amber-100 text-amber-700", en: "bg-slate-100 text-slate-700",
};

const STATUS_PILL: Record<AdminUser["status"], string> = {
  active: "bg-emerald-50 text-emerald-600", suspended: "bg-amber-50 text-amber-700",
  banned: "bg-rose-50 text-rose-600", deleted: "bg-slate-100 text-slate-500",
};
const KYC_PILL: Record<string, string> = {
  approved: "bg-emerald-50 text-emerald-600", pending: "bg-amber-50 text-amber-700", rejected: "bg-rose-50 text-rose-600",
};
const cap = (s: string) => s.charAt(0).toUpperCase() + s.slice(1);

function ago(iso: string) {
  const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000);
  if (s < 60) return "just now";
  if (s < 3600) return `${Math.floor(s / 60)}m ago`;
  if (s < 86_400) return `${Math.floor(s / 3600)}h ago`;
  if (s < 30 * 86_400) return `${Math.floor(s / 86_400)}d ago`;
  return new Date(iso).toLocaleDateString("en-IN", { day: "numeric", month: "short", timeZone: "Asia/Kolkata" });
}

const joinedDate = (iso: string) =>
  new Date(iso).toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric", timeZone: "Asia/Kolkata" });
const joinedTime = (iso: string) =>
  new Date(iso).toLocaleTimeString("en-IN", { hour: "2-digit", minute: "2-digit", hour12: true, timeZone: "Asia/Kolkata" }).toUpperCase();

const menuPopup = "min-w-48 rounded-2xl border bg-popover p-1.5 text-sm shadow-xl outline-none origin-(--transform-origin) transition-[transform,opacity] data-[ending-style]:scale-95 data-[ending-style]:opacity-0 data-[starting-style]:scale-95 data-[starting-style]:opacity-0";
const menuItem = "flex cursor-default items-center gap-2 rounded-xl px-3 py-2 outline-none data-[highlighted]:bg-muted";

// ---------------------------------------------------------------------------

export function UsersPage({ role }: { role: "caller" | "companion" }) {
  const router = useRouter();
  const [target, setTarget] = useState<Target | null>(null);
  const { data, isLoading } = useQuery({
    queryKey: ["users", role],
    queryFn: () => api<{ users: AdminUser[]; total: number }>(`admin/users?role=${role}&limit=${MAX_ROWS}`),
    refetchInterval: 30_000,
  });
  const base = role === "caller" ? "/callers" : "/companions";
  const title = role === "caller" ? "Callers" : "Companions";

  const columns = useMemo(() => [
    col.accessor("displayName", { header: "User", cell: ({ row }) => {
      const u = row.original;
      return (
        <Link href={`${base}/${u.id}`} className="group flex items-center gap-3">
<UserAvatar id={u.id} name={u.displayName} avatarId={u.avatarId} />
          <span className="min-w-0">
            <span className="block truncate font-semibold group-hover:text-primary">{u.displayName}</span>
            <span className="block text-xs text-muted-foreground">ID: {shortId(u.id)}</span>
          </span>
        </Link>
      );
    } }),
    col.accessor((u) => (u.takingCalls ? "Taking calls" : u.online ? "In the app" : "Offline"), { id: "online", header: "Presence", cell: ({ row, getValue }) => (
      <span className="block">
        <span className="flex items-center gap-2 text-sm">
          <span className={cn("size-2 rounded-full",
            getValue() === "Taking calls" ? "bg-emerald-500 shadow-[0_0_0_3px_rgba(16,185,129,0.18)]"
              : getValue() === "In the app" ? "bg-sky-500 shadow-[0_0_0_3px_rgba(14,165,233,0.18)]" : "bg-slate-400")} />
          {getValue()}
        </span>
        <span className="block pl-4 text-xs text-muted-foreground">
          {row.original.takingCalls ? "Can get calls now" : row.original.online ? "App open now" : row.original.lastSeenAt ? `Last seen ${ago(row.original.lastSeenAt)}` : "Not seen yet"}
        </span>
      </span>
    ) }),
    col.accessor("phone", { header: "Phone", enableSorting: false, cell: (c) => <span className="whitespace-nowrap text-sm tabular-nums">{c.getValue()}</span> }),
    col.accessor("primaryLanguage", { header: "Language", cell: (c) => (
      <span className={cn("rounded-full px-3 py-1 text-xs font-semibold", LANGUAGE_CHIP[c.getValue()] ?? "bg-muted text-foreground")}>
        {languageName(c.getValue())}
      </span>
    ) }),
    ...(role === "companion"
      ? [
          col.accessor("kycStatus", { header: "KYC", cell: (c) => (
            <span className={cn("rounded-full px-3 py-1 text-xs font-semibold", KYC_PILL[c.getValue() ?? ""] ?? "bg-muted text-muted-foreground")}>
              {c.getValue() ? cap(c.getValue()!) : "Not started"}
            </span>
          ) }),
          col.accessor("earningsPaise", { header: "Earnings", cell: (c) => <b className="tabular-nums">{rupees(c.getValue())}</b> }),
        ]
      : [col.accessor("coins", { header: "Coins", cell: (c) => (
          <span className="inline-flex items-center gap-2 font-semibold tabular-nums"><Coin size={20} />{c.getValue().toLocaleString("en-IN")}</span>
        ) })]),
    col.accessor("calls", { header: "Calls", cell: (c) => <span className="tabular-nums">{c.getValue()}</span> }),
    col.accessor("reportsAgainst", { header: "Reports", cell: (c) => c.getValue() > 0
      ? <span className="font-semibold text-destructive">{c.getValue()}</span> : <span className="text-muted-foreground">0</span> }),
    col.accessor("createdAt", { header: "Joined", sortFn: "datetime", cell: (c) => (
      <span className="block whitespace-nowrap">
        <span className="block text-sm">{joinedDate(c.getValue())}</span>
        <span className="block text-xs text-muted-foreground">{joinedTime(c.getValue())}</span>
      </span>
    ) }),
    col.accessor("status", { header: "Status", cell: (c) => (
      <span className={cn("rounded-full px-3 py-1 text-xs font-semibold", STATUS_PILL[c.getValue()])}>{cap(c.getValue())}</span>
    ) }),
    col.display({ id: "action", header: "Action", cell: ({ row }) => {
      const u = row.original;
      return (
        <span className="flex items-center gap-2">
          <Button size="sm" variant="outline" className="h-9 rounded-xl px-3" nativeButton={false} render={<Link href={`${base}/${u.id}`} />}>
            <Eye /> View
          </Button>
          {u.status === "active" ? (
            <Button size="sm" variant="ghost" onClick={() => setTarget({ user: u, status: "suspended" })}
              className="h-9 rounded-xl bg-rose-50 px-3 text-rose-600 hover:bg-rose-100 hover:text-rose-700">
              <Ban /> Suspend
            </Button>
          ) : (
            <Button size="sm" variant="ghost" onClick={() => setTarget({ user: u, status: "active" })}
              className="h-9 rounded-xl bg-emerald-50 px-3 text-emerald-700 hover:bg-emerald-100">
              <RotateCcw /> Reactivate
            </Button>
          )}
          <Menu.Root>
            <Menu.Trigger aria-label={`More actions for ${u.displayName}`}
              className="grid size-9 place-items-center rounded-xl text-muted-foreground outline-none hover:bg-muted focus-visible:ring-2 focus-visible:ring-ring">
              <MoreVertical className="size-4" />
            </Menu.Trigger>
            <Menu.Portal>
              <Menu.Positioner sideOffset={6} align="end" className="z-50">
                <Menu.Popup className={menuPopup}>
                  <Menu.Item className={menuItem} onClick={() => {
                    navigator.clipboard.writeText(u.id).then(() => toast.success(`Copied ${u.displayName}'s user ID`), () => toast.error("Couldn't copy"));
                  }}>
                    <Copy className="size-4" /> Copy user ID
                  </Menu.Item>
                  {u.status !== "banned" && (
                    <Menu.Item className={cn(menuItem, "text-rose-600")} onClick={() => setTarget({ user: u, status: "banned" })}>
                      <Ban className="size-4" /> Ban…
                    </Menu.Item>
                  )}
                </Menu.Popup>
              </Menu.Positioner>
            </Menu.Portal>
          </Menu.Root>
        </span>
      );
    } }),
  ], [role, base]);

  const filters: TableFilter[] = [
    { type: "select", column: "status", label: "Statuses", format: cap,
      icon: <span className="size-2.5 rounded-full bg-emerald-500" /> },
    { type: "select", column: "online", label: "Presence", icon: <UserRound /> },
    { type: "select", column: "primaryLanguage", label: "Languages", format: languageName, icon: <Globe /> },
    ...(role === "companion" ? [{ type: "select", column: "kycStatus", label: "KYC", format: cap } as const] : []),
    { type: "date", column: "createdAt", label: "Joined" },
  ];

  return (
    <>
      <header className="relative mb-6 lg:-mt-12">
        <nav aria-label="Breadcrumb" className="flex items-center gap-2 text-sm text-muted-foreground">
          <Link href="/" className="hover:text-foreground">Home</Link>
          <ChevronRight className="size-3.5" />
          <span className="font-medium text-foreground">{title}</span>
        </nav>
        <h1 className="mt-4 font-heading text-4xl font-extrabold tracking-tight">{title}</h1>
        <p className="mt-1.5 text-muted-foreground md:text-[17px]">
          {role === "caller" ? "People who buy coins and make calls. Click anyone to see their full history."
            : "Verified people who take calls and earn. Click anyone to see their full history."}
        </p>
        <p aria-hidden className="pointer-events-none absolute right-6 top-14 hidden -rotate-6 text-right font-hand text-2xl leading-[0.95] text-[#3B1D5C] xl:block">
          Good People<br />&nbsp;&nbsp;Brighter Conversations <span className="text-pink-500">♥</span>
        </p>
      </header>
      {data && data.total > data.users.length && (
        <p className="mb-3 text-sm text-warning">Showing the newest {data.users.length} of {data.total}. Filters apply to these.</p>
      )}
      <DataTable columns={columns} data={data?.users ?? []} filters={filters} exportName={`${role}s`} rowNumbers
        searchPlaceholder="Search by name or last 4 digits…" onRowClick={(u) => router.push(`${base}/${u.id}`)}
        empty={isLoading ? "Loading…" : `No ${role}s yet`} />
      <StatusDialog target={target} onClose={() => setTarget(null)} />
    </>
  );
}

/** Suspend / ban / reactivate with a reason; used by the lists and the detail pages. */
export function StatusDialog({ target, onClose }: { target: Target | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [reason, setReason] = useState("");
  const [status, setStatus] = useState<Target["status"]>("suspended");
  const [openedFor, setOpenedFor] = useState<Target | null>(null);
  if (target && target !== openedFor) {
    setOpenedFor(target);
    setStatus(target.status);
    setReason("");
  }
  const save = useMutation({
    mutationFn: () => api(`admin/users/${target!.user.id}/status`, { method: "POST", body: { status, reason } }),
    onSuccess: () => {
      toast.success(`${target!.user.displayName} is now ${status}`);
      qc.invalidateQueries({ queryKey: ["users"] });
      qc.invalidateQueries({ queryKey: ["user", target!.user.id] });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });
  const reactivating = target?.status === "active";
  return (
    <Dialog open={!!target} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{reactivating ? `Reactivate ${target?.user.displayName}?` : `Suspend ${target?.user.displayName}?`}</DialogTitle>
          <DialogDescription>
            {reactivating ? "They can sign in and use the app again." : "They are signed out everywhere, taken offline, and any call they are on ends now."}
          </DialogDescription>
        </DialogHeader>
        {!reactivating && (
          <Field label="Action" htmlFor="st">
            <Dropdown id="st" value={status} onValueChange={(v) => setStatus(v as Target["status"])}
              options={[{ value: "suspended", label: "Suspend (can be reversed)" }, { value: "banned", label: "Ban permanently" }]} />
          </Field>
        )}
        <Field label="Reason (saved in the audit log)" htmlFor="reason">
          <Textarea id="reason" value={reason} onChange={(e) => setReason(e.target.value)} />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button variant={reactivating ? "default" : "destructive"} disabled={reason.trim().length < 3 || save.isPending} onClick={() => save.mutate()}>
            {save.isPending ? "Saving…" : reactivating ? "Reactivate" : status === "banned" ? "Ban" : "Suspend"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
