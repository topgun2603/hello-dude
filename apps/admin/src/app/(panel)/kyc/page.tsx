"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AnimatePresence, motion } from "framer-motion";
import { AlertTriangle, Check, Eye, Video, VideoOff, X } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";
import { Field } from "@/components/form-bits";
import { PageHeader } from "@/components/sidebar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { api, type KycCase } from "@/lib/api";
import { date, dateTime, languageName } from "@/lib/format";

type Tab = "submitted" | "approved" | "rejected";
const REJECT_PRESETS = [
  "Selfie doesn't match the Aadhaar photo",
  "Selfie is too dark or blurry — please retake in good light",
  "PAN photo is unreadable — please upload a clear photo",
  "Name on the app doesn't match Aadhaar",
];
const GENDER: Record<string, string> = { M: "Male", F: "Female", T: "Transgender", male: "Male", female: "Female", other: "Other" };

export default function KycPage() {
  const [tab, setTab] = useState<Tab>("submitted");
  const { data, isLoading } = useQuery({ queryKey: ["kyc", tab], queryFn: () => api<KycCase[]>(`admin/kyc?status=${tab}`) });

  return (
    <>
      <PageHeader title="KYC review" description="Compare the Aadhaar photo with the live selfie. Every image you open is recorded in the audit log." />
      <Tabs value={tab} onValueChange={(v) => setTab(v as Tab)} className="mb-4">
        <TabsList>
          <TabsTrigger value="submitted">Waiting</TabsTrigger>
          <TabsTrigger value="approved">Approved</TabsTrigger>
          <TabsTrigger value="rejected">Rejected</TabsTrigger>
        </TabsList>
      </Tabs>
      {isLoading && <p className="text-sm text-muted-foreground">Loading…</p>}
      {data?.length === 0 && (
        <Card><CardContent className="py-12 text-center text-sm text-muted-foreground">
          {tab === "submitted" ? "Nobody is waiting for review 🎉" : "Nothing here yet"}
        </CardContent></Card>
      )}
      <div className="space-y-4">
        <AnimatePresence initial={false}>
          {data?.map((c) => <CaseCard key={c.userId} c={c} />)}
        </AnimatePresence>
      </div>
    </>
  );
}

function CaseCard({ c }: { c: KycCase }) {
  const qc = useQueryClient();
  const [rejecting, setRejecting] = useState(false);
  const [videoOpen, setVideoOpen] = useState(false);
  const approve = useMutation({
    mutationFn: () => api(`admin/kyc/${c.userId}/decision`, { method: "POST", body: { decision: "approve", reason: "Photos and details match" } }),
    onSuccess: () => { toast.success(`${c.displayName} approved — they can go online now`); qc.invalidateQueries({ queryKey: ["kyc"] }); qc.invalidateQueries({ queryKey: ["dashboard"] }); },
    onError: (e) => toast.error(e.message),
  });
  const nameMismatch = !!c.aadhaar.name && !c.aadhaar.name.toLowerCase().includes(c.displayName.toLowerCase());

  return (
    <motion.div layout initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, x: -24 }}>
      <Card>
        <CardContent className="grid gap-6 lg:grid-cols-[auto_1fr]">
          <div className="flex gap-3">
            <Photo userId={c.userId} doc="aadhaar_photo" label="Aadhaar photo" has={c.documents.includes("aadhaar_photo")} />
            <Photo userId={c.userId} doc="selfie" label={`Live selfie · ${c.selfieBlinks ?? 0} blinks`} has={c.documents.includes("selfie")} />
          </div>

          <div className="flex min-w-0 flex-col gap-4">
            <div className="flex flex-wrap items-start justify-between gap-2">
              <div>
                <h2 className="font-heading text-xl font-extrabold">{c.displayName}</h2>
                <p className="text-sm text-muted-foreground">
                  {c.phone} · {languageName(c.primaryLanguage)} · {c.submittedAt ? `submitted ${dateTime(c.submittedAt)}` : "not submitted"}
                </p>
              </div>
              {c.status === "rejected" && <Badge variant="destructive">Rejected</Badge>}
              {c.status === "approved" && <Badge>Approved{c.videoEnabled ? " · video on" : ""}</Badge>}
            </div>

            <dl className="grid grid-cols-2 gap-x-6 gap-y-2 text-sm sm:grid-cols-3">
              <Item label="Name on Aadhaar" warn={nameMismatch ? "Different from app name" : undefined}>{c.aadhaar.name ?? "—"}</Item>
              <Item label="Date of birth" warn={c.aadhaar.age !== null && c.aadhaar.age < 18 ? "Under 18" : undefined}>
                {c.aadhaar.dob ? `${date(c.aadhaar.dob)} (${c.aadhaar.age})` : "—"}
              </Item>
              <Item label="Gender">{GENDER[c.aadhaar.gender ?? ""] ?? "—"} <span className="text-muted-foreground">(app: {GENDER[c.gender] ?? c.gender})</span></Item>
              <Item label="Aadhaar">•••• •••• {c.aadhaar.last4 ?? "????"}</Item>
              <Item label="e-KYC downloaded">{c.aadhaar.generatedAt ? dateTime(c.aadhaar.generatedAt) : "—"}</Item>
              <Item label="PAN">{c.panLast4 ? `••••••${c.panLast4}` : "—"}{c.documents.includes("pan") && <PanLink userId={c.userId} />}</Item>
              <Item label="UPI">{c.upi ?? "—"}</Item>
              <Item label="Academy">{c.academy.passed} of {c.academy.total} lessons</Item>
            </dl>

            {c.rejectReason && <p className="rounded-lg bg-destructive/10 px-3 py-2 text-sm text-destructive">Rejected: {c.rejectReason}</p>}

            <div className="mt-auto flex flex-wrap gap-2">
              {c.status === "submitted" && (
                <>
                  <Button onClick={() => approve.mutate()} disabled={approve.isPending}><Check /> Approve</Button>
                  <Button variant="outline" onClick={() => setRejecting(true)}><X /> Reject</Button>
                </>
              )}
              {c.status === "approved" && (
                <Button variant="outline" onClick={() => setVideoOpen(true)}
                  disabled={!c.videoEnabled && c.academy.passed < c.academy.total}
                  title={!c.videoEnabled && c.academy.passed < c.academy.total ? "Finish the academy first" : undefined}>
                  {c.videoEnabled ? <><VideoOff /> Turn video off</>
                    : c.academy.passed < c.academy.total ? <><Video /> Video needs the academy ({c.academy.passed}/{c.academy.total})</>
                    : <><Video /> Unlock video calls</>}
                </Button>
              )}
            </div>
          </div>
        </CardContent>
      </Card>
      <RejectDialog c={c} open={rejecting} onClose={() => setRejecting(false)} />
      <VideoDialog c={c} open={videoOpen} onClose={() => setVideoOpen(false)} />
    </motion.div>
  );
}

function Item({ label, warn, children }: { label: string; warn?: string; children: React.ReactNode }) {
  return (
    <div className="min-w-0">
      <dt className="text-xs text-muted-foreground">{label}</dt>
      <dd className="truncate font-medium">{children}</dd>
      {warn && <dd className="flex items-center gap-1 text-xs font-medium text-warning"><AlertTriangle className="size-3" />{warn}</dd>}
    </div>
  );
}

/** Loaded only when clicked, so opening the queue doesn't log views of every image. */
function Photo({ userId, doc, label, has }: { userId: string; doc: string; label: string; has: boolean }) {
  const [shown, setShown] = useState(false);
  return (
    <figure className="w-40 space-y-1.5">
      <div className="grid aspect-[3/4] place-items-center overflow-hidden rounded-xl border bg-muted">
        {!has ? <span className="text-xs text-muted-foreground">Missing</span> : shown ? (
          // eslint-disable-next-line @next/next/no-img-element -- private, uncached, decrypted per request
          <img src={`/api/v1/admin/kyc/${userId}/files/${doc}`} alt={label} className="size-full object-cover" />
        ) : (
          <Button variant="ghost" size="sm" onClick={() => setShown(true)}><Eye /> Show</Button>
        )}
      </div>
      <figcaption className="text-center text-xs text-muted-foreground">{label}</figcaption>
    </figure>
  );
}

function PanLink({ userId }: { userId: string }) {
  return (
    <a className="ml-2 text-xs font-medium text-primary" target="_blank" rel="noreferrer" href={`/api/v1/admin/kyc/${userId}/files/pan`}>
      view card
    </a>
  );
}

function RejectDialog({ c, open, onClose }: { c: KycCase; open: boolean; onClose: () => void }) {
  const qc = useQueryClient();
  const [reason, setReason] = useState("");
  const reject = useMutation({
    mutationFn: () => api(`admin/kyc/${c.userId}/decision`, { method: "POST", body: { decision: "reject", reason } }),
    onSuccess: () => { toast.success("Rejected — they'll see your reason and can resubmit"); qc.invalidateQueries({ queryKey: ["kyc"] }); onClose(); setReason(""); },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Reject {c.displayName}&apos;s verification?</DialogTitle>
          <DialogDescription>The companion sees this reason in the app and can fix it and resubmit.</DialogDescription>
        </DialogHeader>
        <div className="flex flex-wrap gap-2">
          {REJECT_PRESETS.map((p) => (
            <button key={p} type="button" onClick={() => setReason(p)}
              className="rounded-full border px-3 py-1 text-xs hover:border-primary hover:text-primary">{p}</button>
          ))}
        </div>
        <Field label="Reason shown to the companion" htmlFor="kyc-reason">
          <Textarea id="kyc-reason" value={reason} onChange={(e) => setReason(e.target.value)} />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button variant="destructive" disabled={reason.trim().length < 3 || reject.isPending} onClick={() => reject.mutate()}>Reject</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function VideoDialog({ c, open, onClose }: { c: KycCase; open: boolean; onClose: () => void }) {
  const qc = useQueryClient();
  const [reason, setReason] = useState("");
  const enable = !c.videoEnabled;
  const save = useMutation({
    mutationFn: () => api(`admin/companions/${c.userId}/video`, { method: "POST", body: { enabled: enable, reason } }),
    onSuccess: () => { toast.success(enable ? "Video calls unlocked" : "Video calls turned off"); qc.invalidateQueries({ queryKey: ["kyc"] }); onClose(); setReason(""); },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{enable ? `Unlock video for ${c.displayName}?` : `Turn off video for ${c.displayName}?`}</DialogTitle>
          <DialogDescription>
            {enable ? "Only after the academy lessons and a clean record (no upheld reports)." : "Callers will only be able to voice-call them."}
          </DialogDescription>
        </DialogHeader>
        <Field label="Reason (audit log)" htmlFor="video-reason">
          <Textarea id="video-reason" value={reason} onChange={(e) => setReason(e.target.value)}
            placeholder={enable ? "e.g. Academy complete, 4.8★ over 60 calls" : "e.g. Report upheld on 22 Sep"} />
        </Field>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button disabled={reason.trim().length < 3 || save.isPending} onClick={() => save.mutate()}>{enable ? "Unlock video" : "Turn off"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
