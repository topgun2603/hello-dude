"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { Check, KeyRound, Lock, Pencil, Plus, Power, ShieldCheck, Trash2, UserPlus, Users } from "lucide-react";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { DataTable, type Features } from "@/components/data-table";
import { Dropdown } from "@/components/dropdown";
import { Field } from "@/components/form-bits";
import { PageHeader } from "@/components/sidebar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { api, type AdminRole, type AdminStaff, type Permission, type PermissionInfo } from "@/lib/api";
import { dateTime } from "@/lib/format";
import { cn } from "@/lib/utils";

type RolesData = { roles: AdminRole[]; permissions: PermissionInfo[] };
const col = createColumnHelper<Features, AdminStaff>();

const ROLE_TONE: Record<string, string> = {
  admin: "bg-violet-600 text-white",
  moderator: "bg-sky-100 text-sky-800",
  finance: "bg-emerald-100 text-emerald-800",
};
const roleTone = (code: string) => ROLE_TONE[code] ?? "bg-pink-100 text-pink-800";

export default function StaffPage() {
  const roles = useQuery({ queryKey: ["roles"], queryFn: () => api<RolesData>("admin/roles") });
  return (
    <>
      <PageHeader title="Staff & roles"
        description="Who can sign in to this panel and what each role may do. Changes apply straight away, and every change is in the audit log." />
      <Tabs defaultValue="staff">
        <TabsList className="mb-4">
          <TabsTrigger value="staff"><Users /> Staff</TabsTrigger>
          <TabsTrigger value="roles"><KeyRound /> Roles &amp; permissions</TabsTrigger>
        </TabsList>
        <TabsContent value="staff"><StaffTab roles={roles.data?.roles ?? []} /></TabsContent>
        <TabsContent value="roles"><RolesTab data={roles.data} loading={roles.isLoading} /></TabsContent>
      </Tabs>
    </>
  );
}

// --- Staff -----------------------------------------------------------------------------
function StaffTab({ roles }: { roles: AdminRole[] }) {
  const qc = useQueryClient();
  const { data, isLoading } = useQuery({ queryKey: ["staff"], queryFn: () => api<AdminStaff[]>("admin/staff") });
  const [adding, setAdding] = useState(false);
  const [switching, setSwitching] = useState<AdminStaff | null>(null);

  const update = useMutation({
    mutationFn: (v: { id: string; roleCode?: string; active?: boolean }) =>
      api<AdminStaff>(`admin/staff/${v.id}`, { method: "PUT", body: { roleCode: v.roleCode, active: v.active } }),
    onSuccess: (s) => {
      toast.success(`${s.displayName}: ${s.active ? s.roleName : "access switched off"}`);
      qc.invalidateQueries({ queryKey: ["staff"] });
      qc.invalidateQueries({ queryKey: ["roles"] });
      setSwitching(null);
    },
    onError: (e) => toast.error(e.message),
  });

  const roleOptions = roles.map((r) => ({ value: r.code, label: r.name }));
  const columns = useMemo(() => [
    col.accessor("displayName", {
      header: "Name",
      cell: ({ row: { original: s } }) => (
        <div className="flex items-center gap-3">
          <span className="grid size-9 place-items-center rounded-full bg-[linear-gradient(135deg,#8B5CF6,#DB2777)] font-heading font-bold text-white">
            {s.displayName.slice(0, 1).toUpperCase()}
          </span>
          <div>
            <p className="font-semibold">{s.displayName}{s.isMe && <span className="ml-2 text-xs font-medium text-muted-foreground">(you)</span>}</p>
            <p className="text-xs text-muted-foreground">{s.phone}</p>
          </div>
        </div>
      ),
    }),
    col.accessor("roleName", {
      header: "Role",
      cell: ({ row: { original: s } }) => s.isMe || !s.active
        ? <Badge className={roleTone(s.roleCode)}>{s.roleName}</Badge>
        : (
          <Dropdown size="sm" className="w-44" ariaLabel={`Role for ${s.displayName}`} value={s.roleCode} options={roleOptions}
            disabled={update.isPending}
            onValueChange={(v) => v !== s.roleCode && update.mutate({ id: s.id, roleCode: v })} />
        ),
    }),
    col.accessor((s) => (s.active ? "Active" : "Switched off"), {
      id: "status", header: "Access",
      cell: (c) => <Badge variant={c.getValue() === "Active" ? "default" : "outline"}>{c.getValue()}</Badge>,
    }),
    col.accessor((s) => s.lastSignInAt ?? "", {
      id: "lastSignIn", header: "Last sign-in", sortFn: "datetime",
      cell: ({ row: { original: s } }) => (s.lastSignInAt ? dateTime(s.lastSignInAt) : <span className="text-muted-foreground">Never</span>),
    }),
    col.accessor("createdAt", { header: "Added", sortFn: "datetime", cell: (c) => dateTime(c.getValue()) }),
    col.display({
      id: "actions", header: "",
      cell: ({ row: { original: s } }) => s.isMe ? null : (
        <Button size="sm" variant={s.active ? "outline" : "default"} onClick={() => (s.active ? setSwitching(s) : update.mutate({ id: s.id, active: true }))}>
          <Power /> {s.active ? "Switch off" : "Switch on"}
        </Button>
      ),
    }),
  ], [roleOptions, update]);

  return (
    <>
      <DataTable columns={columns} data={data ?? []} exportName="staff" searchPlaceholder="Search staff…"
        empty={isLoading ? "Loading…" : "No staff yet"}
        filters={[{ type: "select", column: "roleName", label: "Roles" }, { type: "select", column: "status", label: "Access" }]}
        toolbar={<Button size="sm" onClick={() => setAdding(true)}><UserPlus /> Add staff</Button>} />
      <p className="mt-3 text-xs text-muted-foreground">
        You can&apos;t change your own role or access, and there must always be at least one active Admin. Staff sign in here with their phone number and an OTP.
      </p>
      <AddStaffDialog open={adding} roles={roles} onClose={() => setAdding(false)} />
      <Dialog open={!!switching} onOpenChange={(o) => !o && setSwitching(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Switch off {switching?.displayName}&apos;s access?</DialogTitle>
            <DialogDescription>They&apos;re signed out everywhere at once and can&apos;t sign in until someone switches them back on.</DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setSwitching(null)}>Cancel</Button>
            <Button variant="destructive" disabled={update.isPending} onClick={() => switching && update.mutate({ id: switching.id, active: false })}>
              Switch off
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}

function AddStaffDialog({ open, roles, onClose }: { open: boolean; roles: AdminRole[]; onClose: () => void }) {
  const qc = useQueryClient();
  const [f, setF] = useState({ name: "", phone: "", roleCode: "moderator" });
  const add = useMutation({
    mutationFn: () => api<AdminStaff>("admin/staff", { method: "POST", body: f }),
    onSuccess: (s) => {
      toast.success(`${s.displayName} added as ${s.roleName}. They can sign in with ${s.phone}.`);
      qc.invalidateQueries({ queryKey: ["staff"] });
      qc.invalidateQueries({ queryKey: ["roles"] });
      setF({ name: "", phone: "", roleCode: "moderator" });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });
  const phoneOk = /^(\+?91)?[6-9]\d{9}$/.test(f.phone.replace(/\s/g, ""));
  const role = roles.find((r) => r.code === f.roleCode);
  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>Add staff</DialogTitle>
          <DialogDescription>Use a number that isn&apos;t signed up in the app. They sign in to this panel with an OTP.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Name" htmlFor="st-name"><Input id="st-name" maxLength={40} value={f.name} onChange={(e) => setF({ ...f, name: e.target.value })} placeholder="Divya R" /></Field>
          <Field label="Mobile number" htmlFor="st-phone" hint={f.phone && !phoneOk ? "10-digit Indian mobile" : undefined}>
            <Input id="st-phone" inputMode="tel" value={f.phone} onChange={(e) => setF({ ...f, phone: e.target.value })} placeholder="98765 43210" aria-invalid={!!f.phone && !phoneOk} />
          </Field>
        </div>
        <Field label="Role" htmlFor="st-role">
          <Dropdown id="st-role" value={f.roleCode} onValueChange={(v) => setF({ ...f, roleCode: v })}
            options={roles.map((r) => ({ value: r.code, label: r.name }))} />
        </Field>
        {role && (
          <p className="rounded-xl bg-[#FAF7FD] p-3 text-xs text-muted-foreground">
            <b className="text-foreground">{role.name}:</b> {role.description || "Custom role"} · {role.permissions.length} permissions
          </p>
        )}
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={add.isPending || f.name.trim().length < 2 || !phoneOk} onClick={() => add.mutate()}>
            {add.isPending ? "Adding…" : "Add staff"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// --- Roles -----------------------------------------------------------------------------
function RolesTab({ data, loading }: { data?: RolesData; loading: boolean }) {
  const [edit, setEdit] = useState<AdminRole | "new" | null>(null);
  const [deleting, setDeleting] = useState<AdminRole | null>(null);
  const qc = useQueryClient();
  const remove = useMutation({
    mutationFn: (r: AdminRole) => api(`admin/roles/${r.code}`, { method: "DELETE" }),
    onSuccess: () => { toast.success("Role deleted"); qc.invalidateQueries({ queryKey: ["roles"] }); setDeleting(null); },
    onError: (e) => toast.error(e.message),
  });
  if (loading || !data) return <div className="h-64 animate-pulse rounded-3xl bg-white/60" />;
  const groups = [...new Set(data.permissions.map((p) => p.group))];

  return (
    <div className="space-y-6">
      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
        {data.roles.map((r) => (
          <div key={r.code} className="flex flex-col rounded-3xl border border-[#E7E4F0] bg-white p-5 shadow-sm">
            <div className="flex items-start justify-between gap-3">
              <div>
                <div className="flex items-center gap-2">
                  <Badge className={roleTone(r.code)}>{r.name}</Badge>
                  {r.isSystem && <span className="text-xs text-muted-foreground">Built-in</span>}
                </div>
                <p className="mt-2 text-sm text-muted-foreground">{r.description || "Custom role"}</p>
              </div>
              <span className="flex items-center gap-1 text-sm font-semibold"><Users className="size-4 text-muted-foreground" /> {r.members}</span>
            </div>
            <div className="mt-4 h-2 overflow-hidden rounded-full bg-[#F1EEF7]">
              <div className="h-full rounded-full bg-[linear-gradient(90deg,#7C3AED,#DB2777)]"
                style={{ width: `${(r.permissions.length / data.permissions.length) * 100}%` }} />
            </div>
            <p className="mt-1.5 text-xs text-muted-foreground">{r.permissions.length} of {data.permissions.length} permissions</p>
            <div className="mt-4 flex gap-2">
              {r.isAdmin
                ? <span className="flex items-center gap-1.5 text-xs text-muted-foreground"><Lock className="size-3.5" /> Always has everything</span>
                : <Button size="sm" variant="outline" onClick={() => setEdit(r)}><Pencil /> Edit</Button>}
              {!r.isSystem && (
                <Button size="sm" variant="ghost" onClick={() => setDeleting(r)} aria-label={`Delete ${r.name}`}><Trash2 className="text-destructive" /></Button>
              )}
            </div>
          </div>
        ))}
        <button type="button" onClick={() => setEdit("new")}
          className="flex min-h-40 flex-col items-center justify-center gap-2 rounded-3xl border-2 border-dashed border-[#DCD3EC] text-sm font-semibold text-violet-700 transition hover:bg-white">
          <Plus className="size-6" /> New role
        </button>
      </div>

      {/* Everything at a glance: roles across, permissions down. */}
      <div className="overflow-x-auto rounded-3xl border border-[#E7E4F0] bg-white shadow-sm">
        <table className="w-full min-w-[640px] text-sm">
          <thead>
            <tr className="border-b border-[#F1EEF7]">
              <th className="px-5 py-3 text-left font-semibold">Permission</th>
              {data.roles.map((r) => <th key={r.code} className="px-3 py-3 text-center font-semibold">{r.name}</th>)}
            </tr>
          </thead>
          <tbody>
            {groups.map((g) => (
              <PermissionGroupRows key={g} group={g} perms={data.permissions.filter((p) => p.group === g)} roles={data.roles} />
            ))}
          </tbody>
        </table>
      </div>

      <RoleDialog value={edit} permissions={data.permissions} onClose={() => setEdit(null)} />
      <Dialog open={!!deleting} onOpenChange={(o) => !o && setDeleting(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete the “{deleting?.name}” role?</DialogTitle>
            <DialogDescription>{deleting?.members ? "Move its staff to another role first." : "Nobody has this role."}</DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleting(null)}>Cancel</Button>
            <Button variant="destructive" disabled={!!deleting?.members || remove.isPending} onClick={() => deleting && remove.mutate(deleting)}>Delete</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

function PermissionGroupRows({ group, perms, roles }: { group: string; perms: PermissionInfo[]; roles: AdminRole[] }) {
  return (
    <>
      <tr className="bg-[#FAF7FD]">
        <td colSpan={roles.length + 1} className="px-5 py-2 text-xs font-bold uppercase tracking-wide text-muted-foreground">{group}</td>
      </tr>
      {perms.map((p) => (
        <tr key={p.code} className="border-b border-[#F7F4FB] last:border-0">
          <td className="px-5 py-2.5">{p.label}</td>
          {roles.map((r) => (
            <td key={r.code} className="px-3 py-2.5 text-center">
              {r.permissions.includes(p.code)
                ? <Check className="mx-auto size-4 text-emerald-600" aria-label="Yes" />
                : <span className="text-[#D9D3E6]" aria-label="No">—</span>}
            </td>
          ))}
        </tr>
      ))}
    </>
  );
}

function RoleDialog({ value, permissions, onClose }: { value: AdminRole | "new" | null; permissions: PermissionInfo[]; onClose: () => void }) {
  const qc = useQueryClient();
  const [f, setF] = useState<{ name: string; description: string; permissions: Permission[] }>({ name: "", description: "", permissions: [] });
  const [openedFor, setOpenedFor] = useState<typeof value>(null);
  if (value && value !== openedFor) {
    setOpenedFor(value);
    setF(value === "new" ? { name: "", description: "", permissions: ["dashboard.view"] }
      : { name: value.name, description: value.description, permissions: value.permissions });
  }
  const isSystem = value !== "new" && !!value?.isSystem;
  const save = useMutation({
    mutationFn: () => value === "new"
      ? api<AdminRole>("admin/roles", { method: "POST", body: f })
      : api<AdminRole>(`admin/roles/${(value as AdminRole).code}`, { method: "PUT", body: f }),
    onSuccess: (r) => { toast.success(`${r.name} saved`); qc.invalidateQueries({ queryKey: ["roles"] }); qc.invalidateQueries({ queryKey: ["me"] }); onClose(); },
    onError: (e) => toast.error(e.message),
  });
  const toggle = (p: Permission) =>
    setF((x) => ({ ...x, permissions: x.permissions.includes(p) ? x.permissions.filter((y) => y !== p) : [...x.permissions, p] }));
  const groups = [...new Set(permissions.map((p) => p.group))];

  return (
    <Dialog open={!!value} onOpenChange={(o) => !o && onClose()}>
      <DialogContent className="max-h-[92vh] overflow-y-auto sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2"><ShieldCheck className="size-5 text-violet-600" /> {value === "new" ? "New role" : `Edit ${f.name}`}</DialogTitle>
          <DialogDescription>Staff with this role get exactly these permissions. Changes apply on their next click.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Name" htmlFor="rl-name" hint={isSystem ? "Built-in roles keep their name" : undefined}>
            <Input id="rl-name" maxLength={40} disabled={isSystem} value={f.name} onChange={(e) => setF({ ...f, name: e.target.value })} placeholder="Support desk" />
          </Field>
          <Field label="What it's for" htmlFor="rl-desc">
            <Textarea id="rl-desc" rows={2} maxLength={200} value={f.description} onChange={(e) => setF({ ...f, description: e.target.value })} />
          </Field>
        </div>
        <div className="space-y-4">
          {groups.map((g) => {
            const perms = permissions.filter((p) => p.group === g);
            const all = perms.every((p) => f.permissions.includes(p.code));
            return (
              <fieldset key={g} className="rounded-2xl border border-[#EFEAF6] p-3">
                <legend className="flex items-center gap-3 px-1 text-xs font-bold uppercase tracking-wide text-muted-foreground">
                  {g}
                  <button type="button" className="font-semibold normal-case tracking-normal text-violet-700 hover:underline"
                    onClick={() => setF((x) => ({
                      ...x,
                      permissions: all ? x.permissions.filter((p) => !perms.some((q) => q.code === p)) : [...new Set([...x.permissions, ...perms.map((q) => q.code)])],
                    }))}>
                    {all ? "Clear" : "All"}
                  </button>
                </legend>
                <div className="grid gap-1 sm:grid-cols-2">
                  {perms.map((p) => {
                    const on = f.permissions.includes(p.code);
                    return (
                      <label key={p.code} className={cn("flex cursor-pointer items-start gap-2.5 rounded-xl px-2.5 py-2 text-sm transition", on ? "bg-violet-50" : "hover:bg-[#FAF7FD]")}>
                        <input type="checkbox" className="mt-0.5 size-4 accent-violet-600" checked={on} onChange={() => toggle(p.code)} />
                        <span>{p.label}</span>
                      </label>
                    );
                  })}
                </div>
              </fieldset>
            );
          })}
        </div>
        <DialogFooter>
          <span className="mr-auto self-center text-sm text-muted-foreground">{f.permissions.length} selected</span>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={save.isPending || f.name.trim().length < 2} onClick={() => save.mutate()}>{save.isPending ? "Saving…" : "Save role"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
