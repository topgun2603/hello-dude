"use client";

// Engagement → Events (festival leaderboards) and Caller levels.
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createColumnHelper } from "@tanstack/react-table";
import { Pencil, Plus } from "lucide-react";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { DataTable, type Features } from "@/components/data-table";
import { Field } from "@/components/form-bits";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { api, type AdminEvent, type CallerLevel, type EventTheme } from "@/lib/api";
import { dateTime } from "@/lib/format";

const eventCol = createColumnHelper<Features, AdminEvent>();
const levelCol = createColumnHelper<Features, CallerLevel>();

const THEMES: EventTheme[] = ["festive", "pongal", "diwali", "onam", "holi", "love", "cricket"];
/** ISO → value for <input type="datetime-local"> (browser local time; admins are in IST). */
const toLocal = (iso: string) => {
  const d = new Date(iso);
  return new Date(d.getTime() - d.getTimezoneOffset() * 60_000).toISOString().slice(0, 16);
};

function eventStatus(e: AdminEvent) {
  const now = Date.now();
  if (!e.active) return "Off";
  if (new Date(e.endsAt).getTime() <= now) return e.badgesAwarded ? "Finished · badges given" : "Finished";
  return new Date(e.startsAt).getTime() <= now ? "Running" : "Scheduled";
}

/** A new event: starts now, runs a week. */
function blankEvent() {
  const now = Date.now();
  return {
    name: "", tagline: "", theme: "festive" as EventTheme, active: true,
    startsAt: toLocal(new Date(now).toISOString()), endsAt: toLocal(new Date(now + 7 * 86_400_000).toISOString()),
  };
}

export function Events() {
  const { data, isLoading } = useQuery({ queryKey: ["events"], queryFn: () => api<AdminEvent[]>("admin/events") });
  const [edit, setEdit] = useState<AdminEvent | "new" | null>(null);
  const columns = useMemo(() => [
    eventCol.accessor("name", { header: "Event", cell: (c) => <b>{c.getValue()}</b> }),
    eventCol.accessor("theme", { header: "Theme", cell: (c) => <span className="capitalize">{c.getValue()}</span> }),
    eventCol.accessor("startsAt", { header: "Starts", cell: (c) => dateTime(c.getValue()) }),
    eventCol.accessor("endsAt", { header: "Ends", cell: (c) => dateTime(c.getValue()) }),
    eventCol.accessor(eventStatus, { id: "status", header: "Status", cell: (c) => <Badge variant={c.getValue() === "Running" ? "default" : "outline"}>{c.getValue()}</Badge> }),
    eventCol.display({ id: "edit", header: "", cell: ({ row }) => <Button size="sm" variant="outline" onClick={() => setEdit(row.original)}><Pencil /> Edit</Button> }),
  ], []);
  return (
    <>
      <p className="mb-3 text-sm text-muted-foreground">While an event runs, the apps show its banner on Home and its own leaderboard. When it ends, the top companions and fans get an event badge (badges only, no cash).</p>
      <DataTable columns={columns} data={data ?? []} search={false} empty={isLoading ? "Loading…" : "No events yet"}
        toolbar={<Button size="sm" onClick={() => setEdit("new")}><Plus /> New event</Button>} />
      <EventDialog value={edit} onClose={() => setEdit(null)} />
    </>
  );
}

function EventDialog({ value, onClose }: { value: AdminEvent | "new" | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [f, setF] = useState(blankEvent);
  const [openedFor, setOpenedFor] = useState<typeof value>(null);
  if (value && value !== openedFor) {
    setOpenedFor(value);
    setF(value === "new" ? blankEvent() : {
      name: value.name, tagline: value.tagline ?? "", theme: value.theme, active: value.active,
      startsAt: toLocal(value.startsAt), endsAt: toLocal(value.endsAt),
    });
  }
  const valid = f.name.trim().length >= 3 && !!f.startsAt && !!f.endsAt && new Date(f.endsAt) > new Date(f.startsAt);
  const save = useMutation({
    mutationFn: () => {
      const body = {
        name: f.name.trim(), tagline: f.tagline.trim() || null, theme: f.theme, active: f.active,
        startsAt: new Date(f.startsAt).toISOString(), endsAt: new Date(f.endsAt).toISOString(),
        giftIds: value && value !== "new" ? value.giftIds : [],
      };
      return value === "new" ? api("admin/events", { method: "POST", body }) : api(`admin/events/${(value as AdminEvent).id}`, { method: "PUT", body });
    },
    onSuccess: () => { toast.success("Event saved"); qc.invalidateQueries({ queryKey: ["events"] }); onClose(); },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={!!value} onOpenChange={(o) => !o && onClose()}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>{value === "new" ? "New festival event" : "Edit event"}</DialogTitle>
          <DialogDescription>Example: &quot;Pongal week&quot;, 13–17 January, theme Pongal.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Name" htmlFor="ev-n"><Input id="ev-n" value={f.name} maxLength={60} onChange={(e) => setF({ ...f, name: e.target.value })} placeholder="Pongal week" /></Field>
          <Field label="Theme" htmlFor="ev-t">
            <select id="ev-t" className="h-9 w-full rounded-md border bg-background px-3 text-sm capitalize" value={f.theme}
              onChange={(e) => setF({ ...f, theme: e.target.value as EventTheme })}>
              {THEMES.map((t) => <option key={t} value={t}>{t}</option>)}
            </select>
          </Field>
          <div className="sm:col-span-2">
            <Field label="Tagline (optional)" htmlFor="ev-tg">
              <Input id="ev-tg" value={f.tagline} maxLength={120} onChange={(e) => setF({ ...f, tagline: e.target.value })} placeholder="Send Pongal gifts, top the board" />
            </Field>
          </div>
          <Field label="Starts" htmlFor="ev-s"><Input id="ev-s" type="datetime-local" value={f.startsAt} onChange={(e) => setF({ ...f, startsAt: e.target.value })} /></Field>
          <Field label="Ends" htmlFor="ev-e"><Input id="ev-e" type="datetime-local" value={f.endsAt} onChange={(e) => setF({ ...f, endsAt: e.target.value })} /></Field>
          <Field label="Status" htmlFor="ev-a">
            <Button id="ev-a" type="button" variant={f.active ? "default" : "outline"} onClick={() => setF({ ...f, active: !f.active })}>{f.active ? "Active" : "Off"}</Button>
          </Field>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={save.isPending || !valid} onClick={() => save.mutate()}>{save.isPending ? "Saving…" : "Save"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

export function CallerLevels() {
  const { data, isLoading } = useQuery({ queryKey: ["caller-levels"], queryFn: () => api<CallerLevel[]>("admin/caller-levels") });
  const [edit, setEdit] = useState<CallerLevel | null>(null);
  const columns = useMemo(() => [
    levelCol.accessor("level", { header: "Level", cell: (c) => <b>Level {c.getValue()}</b> }),
    levelCol.accessor("name", { header: "Name" }),
    levelCol.accessor("minCoins", { header: "Coins spent (lifetime)", cell: (c) => c.getValue().toLocaleString("en-IN") }),
    levelCol.accessor("perk", { header: "Perk shown", cell: (c) => c.getValue() ?? "—" }),
    levelCol.display({ id: "edit", header: "", cell: ({ row }) => <Button size="sm" variant="outline" onClick={() => setEdit(row.original)}><Pencil /> Edit</Button> }),
  ], []);
  return (
    <>
      <p className="mb-3 text-sm text-muted-foreground">Callers level up by lifetime coins spent on calls, gifts, lives and groups (refunds are taken back). Companions see the level in their Callers tab.</p>
      <DataTable columns={columns} data={data ?? []} search={false} empty={isLoading ? "Loading…" : "No levels"} />
      <CallerLevelDialog level={edit} onClose={() => setEdit(null)} />
    </>
  );
}

function CallerLevelDialog({ level, onClose }: { level: CallerLevel | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [f, setF] = useState({ name: "", minCoins: "", perk: "" });
  const [openedFor, setOpenedFor] = useState<CallerLevel | null>(null);
  if (level && level !== openedFor) {
    setOpenedFor(level);
    setF({ name: level.name, minCoins: String(level.minCoins), perk: level.perk ?? "" });
  }
  const save = useMutation({
    mutationFn: () => api(`admin/caller-levels/${level!.level}`, { method: "PUT",
      body: { name: f.name.trim(), minCoins: Number(f.minCoins), perk: f.perk.trim() || null } }),
    onSuccess: () => { toast.success("Level saved"); qc.invalidateQueries({ queryKey: ["caller-levels"] }); onClose(); },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={!!level} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Caller level {level?.level}</DialogTitle>
          <DialogDescription>Levels must stay in order: each needs more coins than the one below it.</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Name" htmlFor="cl-n"><Input id="cl-n" value={f.name} maxLength={30} onChange={(e) => setF({ ...f, name: e.target.value })} /></Field>
          <Field label="Coins spent to reach it" htmlFor="cl-c">
            <Input id="cl-c" type="number" min={0} disabled={level?.level === 1} value={f.minCoins} onChange={(e) => setF({ ...f, minCoins: e.target.value })} />
          </Field>
          <div className="sm:col-span-2">
            <Field label="Perk text (optional)" htmlFor="cl-p"><Input id="cl-p" value={f.perk} maxLength={80} onChange={(e) => setF({ ...f, perk: e.target.value })} /></Field>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={save.isPending || f.name.trim().length < 2} onClick={() => save.mutate()}>{save.isPending ? "Saving…" : "Save"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
