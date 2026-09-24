"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AnimatePresence, motion } from "framer-motion";
import { Ban, CircleCheck, CircleOff, Eye, EyeOff, ImageOff, ShieldAlert, Video } from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import { toast } from "sonner";
import { Field } from "@/components/form-bits";
import { PageHeader } from "@/components/sidebar";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { api, type ModerationFlag, type ModerationStatus } from "@/lib/api";
import { dateTime } from "@/lib/format";
import { cn } from "@/lib/utils";

type Decision = "dismiss" | "suspend" | "ban";

export default function ModerationPage() {
  const [status, setStatus] = useState<ModerationStatus>("open");
  const [acting, setActing] = useState<{ flag: ModerationFlag; decision: Decision } | null>(null);
  const { data, isLoading } = useQuery({
    queryKey: ["moderation", status],
    queryFn: () => api<ModerationFlag[]>(`admin/moderation?status=${status}`),
    refetchInterval: status === "open" ? 15_000 : false,
  });

  return (
    <>
      <PageHeader title="Video moderation"
        description="Frames the app's on-device check flagged as nudity during video calls and lives. The video was already blurred (or the live camera paused); decide what happens to the person on camera." />
      <Tabs value={status} onValueChange={(v) => setStatus(v as ModerationStatus)} className="mb-5">
        <TabsList>
          <TabsTrigger value="open">To review</TabsTrigger>
          <TabsTrigger value="actioned">Actioned</TabsTrigger>
          <TabsTrigger value="dismissed">Dismissed</TabsTrigger>
        </TabsList>
      </Tabs>

      {isLoading ? (
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {Array.from({ length: 3 }, (_, i) => <div key={i} className="h-96 animate-pulse rounded-3xl bg-muted" />)}
        </div>
      ) : !data?.length ? (
        <div className="flex flex-col items-center gap-2 rounded-3xl border border-[#EFEAF6] bg-white py-16 text-center">
          <span className="grid size-14 place-items-center rounded-full bg-emerald-50 text-emerald-600"><ShieldAlert className="size-6" /></span>
          <b>{status === "open" ? "Nothing to review 🎉" : "Nothing here yet"}</b>
          <span className="text-sm text-muted-foreground">
            {status === "open" ? "Flagged frames from video calls show up here within seconds." : "Reviewed frames are deleted 30 days after the decision."}
          </span>
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          <AnimatePresence initial={false}>
            {data.map((f, i) => (
              <motion.div key={f.id} layout initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, scale: 0.96 }}
                transition={{ delay: Math.min(i, 8) * 0.04 }}>
                <FlagCard flag={f} onDecide={(decision) => setActing({ flag: f, decision })} />
              </motion.div>
            ))}
          </AnimatePresence>
        </div>
      )}
      <DecisionDialog acting={acting} onClose={() => setActing(null)} />
    </>
  );
}

function FlagCard({ flag: f, onDecide }: { flag: ModerationFlag; onDecide: (d: Decision) => void }) {
  // The frame is fetched (and the view audit-logged) only when an admin chooses to look.
  const [revealed, setRevealed] = useState(false);
  const pct = Math.round(f.score * 100);
  const profile = `/${f.subject.role === "companion" ? "companions" : "callers"}/${f.subject.id}`;
  return (
    <article className="overflow-hidden rounded-3xl border border-[#EFEAF6] bg-white shadow-[0_12px_32px_-24px_rgba(109,40,217,0.45)]">
      <div className="relative aspect-[4/3] bg-[#1B1340]">
        {!f.hasFrame ? (
          <div className="grid size-full place-items-center text-center text-sm text-white/70">
            <span className="flex flex-col items-center gap-2"><ImageOff className="size-6" />Frame deleted (retention policy)</span>
          </div>
        ) : revealed ? (
          <>
            {/* eslint-disable-next-line @next/next/no-img-element -- private, uncached admin image */}
            <img src={`/api/v1/admin/moderation/${f.id}/frame`} alt="Flagged frame" className="size-full object-contain" />
            <button type="button" onClick={() => setRevealed(false)} aria-label="Hide frame"
              className="absolute right-3 top-3 grid size-9 place-items-center rounded-full bg-black/55 text-white hover:bg-black/70">
              <EyeOff className="size-4" />
            </button>
          </>
        ) : (
          <button type="button" onClick={() => setRevealed(true)}
            className="group grid size-full place-items-center bg-[radial-gradient(60%_60%_at_50%_45%,rgba(236,72,153,0.35),transparent_70%),linear-gradient(160deg,#2A0F3F,#1E0B30)] text-white">
            <span className="flex flex-col items-center gap-2 text-center">
              <span className="grid size-12 place-items-center rounded-full bg-white/10 transition group-hover:scale-110 group-hover:bg-white/20"><Eye className="size-5" /></span>
              <b className="text-sm">May contain nudity</b>
              <span className="text-xs text-white/70">Click to view · the view is logged</span>
            </span>
          </button>
        )}
        <span className={cn("absolute left-3 top-3 rounded-full px-2.5 py-1 text-xs font-bold",
          pct >= 90 ? "bg-rose-500 text-white" : pct >= 80 ? "bg-amber-400 text-amber-950" : "bg-white/90 text-foreground")}>
          {pct}% match
        </span>
      </div>

      <div className="space-y-3 p-4">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <Link href={profile} className="font-heading text-lg font-bold hover:text-primary hover:underline">{f.subject.displayName}</Link>
            <p className="text-xs capitalize text-muted-foreground">
              {f.subject.role} · {f.subject.status}
              {f.subject.flags > 1 && <span className="ml-1.5 rounded-full bg-rose-50 px-2 py-0.5 font-semibold normal-case text-rose-600">{f.subject.flags} flags total</span>}
            </p>
          </div>
          <span className={`flex shrink-0 items-center gap-1 rounded-full px-2.5 py-1 text-xs font-medium ${f.liveId ? "bg-rose-50 text-rose-700" : f.groupId ? "bg-emerald-50 text-emerald-700" : "bg-violet-50 text-violet-700"}`}>
            <Video className="size-3.5" /> {f.liveId ? "Live stream" : f.groupId ? "Group video" : "Video call"}
          </span>
        </div>
        <p className="text-sm text-muted-foreground">
          Flagged {dateTime(f.createdAt)} on {f.detectedBy.displayName}&apos;s phone ({f.detectedBy.role})
        </p>

        {f.status === "open" ? (
          <div className="grid grid-cols-3 gap-2">
            <Button variant="outline" size="sm" onClick={() => onDecide("dismiss")}><CircleCheck /> Dismiss</Button>
            <Button size="sm" className="bg-amber-500 text-white hover:bg-amber-600" onClick={() => onDecide("suspend")}><CircleOff /> Suspend</Button>
            <Button variant="destructive" size="sm" onClick={() => onDecide("ban")}><Ban /> Ban</Button>
          </div>
        ) : (
          <div className="rounded-2xl bg-[#FAF7FD] p-3 text-sm">
            <p className="font-medium capitalize">{f.status} by {f.reviewer ?? "—"} · {f.reviewedAt ? dateTime(f.reviewedAt) : ""}</p>
            {f.note && <p className="mt-1 text-muted-foreground">{f.note}</p>}
          </div>
        )}
      </div>
    </article>
  );
}

function DecisionDialog({ acting, onClose }: { acting: { flag: ModerationFlag; decision: Decision } | null; onClose: () => void }) {
  const qc = useQueryClient();
  const [note, setNote] = useState("");
  const [openedFor, setOpenedFor] = useState<typeof acting>(null);
  if (acting && acting !== openedFor) {
    setOpenedFor(acting);
    setNote(acting.decision === "dismiss" ? "False alarm — no nudity" : "");
  }
  const save = useMutation({
    mutationFn: () => api(`admin/moderation/${acting!.flag.id}/resolve`, { method: "POST", body: { decision: acting!.decision, note } }),
    onSuccess: () => {
      const d = acting!.decision;
      toast.success(d === "dismiss" ? "Dismissed" : `${acting!.flag.subject.displayName} is now ${d === "ban" ? "banned" : "suspended"}`);
      qc.invalidateQueries({ queryKey: ["moderation"] });
      qc.invalidateQueries({ queryKey: ["dashboard"] });
      qc.invalidateQueries({ queryKey: ["user", acting!.flag.subject.id] });
      onClose();
    },
    onError: (e) => toast.error(e.message),
  });
  const d = acting?.decision;
  const name = acting?.flag.subject.displayName;
  return (
    <Dialog open={!!acting} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{d === "dismiss" ? "Dismiss this flag?" : d === "ban" ? `Ban ${name}?` : `Suspend ${name}?`}</DialogTitle>
          <DialogDescription>
            {d === "dismiss"
              ? "Marks it as a false alarm. Nothing happens to the account."
              : `${name} is signed out everywhere, taken offline, and any call they are on ends now.${d === "ban" ? " A ban is permanent." : " You can reactivate them later."}`}
          </DialogDescription>
        </DialogHeader>
        <Field label="Note (saved in the audit log)" htmlFor="mod-note">
          <Textarea id="mod-note" value={note} onChange={(e) => setNote(e.target.value)} />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button variant={d === "dismiss" ? "default" : "destructive"} disabled={note.trim().length < 3 || save.isPending} onClick={() => save.mutate()}>
            {save.isPending ? "Saving…" : d === "dismiss" ? "Dismiss" : d === "ban" ? "Ban" : "Suspend"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
