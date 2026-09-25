"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AnimatePresence, motion } from "framer-motion";
import { AlertTriangle, Check, Eye, ImageIcon, Mic, Video, VideoOff, X } from "lucide-react";
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
import { api, type KycCase, type KycItem, type PendingPhoto } from "@/lib/api";
import { date, dateTime, languageName } from "@/lib/format";
import { useCan } from "@/lib/access";

type Tab = "submitted" | "approved" | "rejected" | "photos";
/** Preset reasons, and what each asks the companion to send again. */
const REJECT_PRESETS: { text: string; redo: KycItem[] }[] = [
  { text: "Voice intro doesn't match — please record it again", redo: ["voice"] },
  { text: "Selfie doesn't look like an adult (18+)", redo: ["selfie"] },
  { text: "Face isn't clearly visible in the selfie", redo: ["selfie"] },
  { text: "Selfie is too dark or blurry — please retake in good light", redo: ["selfie"] },
  { text: "PAN photo is unreadable — please upload a clear photo", redo: ["pan"] },
  { text: "Date of birth looks wrong — please check it", redo: ["age"] },
  { text: "UPI ID doesn't work — please check it", redo: ["upi"] },
];
const REDO_LABEL: Record<KycItem, string> = { age: "Date of birth", selfie: "Selfie", voice: "Voice intro", pan: "PAN", upi: "UPI ID" };
const GENDER: Record<string, string> = { M: "Male", F: "Female", T: "Transgender", male: "Male", female: "Female", other: "Other" };

export default function KycPage() {
  const [tab, setTab] = useState<Tab>("submitted");
  const { data, isLoading } = useQuery({
    queryKey: ["kyc", tab], queryFn: () => api<KycCase[]>(`admin/kyc?status=${tab}`), enabled: tab !== "photos",
  });

  return (
    <>
      <PageHeader title="KYC review" description="Check the live selfie (an adult, a real face, matches the profile) and the declared age. PAN is optional — without it payouts carry 20% TDS. Every image you open is recorded in the audit log." />
      <Tabs value={tab} onValueChange={(v) => setTab(v as Tab)} className="mb-4">
        <TabsList>
          <TabsTrigger value="submitted">Waiting</TabsTrigger>
          <TabsTrigger value="approved">Approved</TabsTrigger>
          <TabsTrigger value="rejected">Rejected</TabsTrigger>
          <TabsTrigger value="photos"><ImageIcon /> Profile photos</TabsTrigger>
        </TabsList>
      </Tabs>
      {tab === "photos" && <PhotoQueue />}
      {tab !== "photos" && isLoading && <p className="text-sm text-muted-foreground">Loading…</p>}
      {tab !== "photos" && data?.length === 0 && (
        <Card><CardContent className="py-12 text-center text-sm text-muted-foreground">
          {tab === "submitted" ? "Nobody is waiting for review 🎉" : "Nothing here yet"}
        </CardContent></Card>
      )}
      <div className="space-y-4">
        <AnimatePresence initial={false}>
          {tab !== "photos" && data?.map((c) => <CaseCard key={c.userId} c={c} />)}
        </AnimatePresence>
      </div>
    </>
  );
}

function CaseCard({ c }: { c: KycCase }) {
  const canVideo = useCan()("companions.video");
  const qc = useQueryClient();
  const [rejecting, setRejecting] = useState(false);
  const [videoOpen, setVideoOpen] = useState(false);
  const approve = useMutation({
    mutationFn: () => api(`admin/kyc/${c.userId}/decision`, { method: "POST", body: { decision: "approve", reason: "Photos and details match" } }),
    onSuccess: () => { toast.success(`${c.displayName} approved — they can go online now`); qc.invalidateQueries({ queryKey: ["kyc"] }); qc.invalidateQueries({ queryKey: ["dashboard"] }); },
    onError: (e) => toast.error(e.message),
  });
  const nameMismatch = !!c.aadhaar.name && !c.aadhaar.name.toLowerCase().includes(c.displayName.toLowerCase());
  const legacy = !!c.aadhaar.last4; // verified with Aadhaar before it was dropped

  return (
    <motion.div layout initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, x: -24 }}>
      <Card>
        <CardContent className="grid gap-6 lg:grid-cols-[auto_1fr]">
          <div className="flex gap-3">
            {c.documents.includes("aadhaar_photo") && <Photo userId={c.userId} doc="aadhaar_photo" label="Aadhaar photo (older sign-up)" has />}
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
              <Item label="Date of birth (declared)" warn={c.declared.age !== null && c.declared.age < 18 ? "Under 18" : undefined}>
                {c.declared.birthDate ? `${date(c.declared.birthDate)} (${c.declared.age})` : legacy && c.aadhaar.dob ? `${date(c.aadhaar.dob)} (${c.aadhaar.age}, Aadhaar)` : "—"}
              </Item>
              <Item label="Gender">{GENDER[c.gender] ?? c.gender}</Item>
              {legacy && <Item label="Name on Aadhaar" warn={nameMismatch ? "Different from app name" : undefined}>{c.aadhaar.name ?? "—"}</Item>}
              {legacy && <Item label="Aadhaar">•••• •••• {c.aadhaar.last4}</Item>}
              <Item label="PAN" warn={c.panLast4 ? undefined : "Not given — 20% TDS on payouts"}>
                {c.panLast4 ? `••••••${c.panLast4}` : "—"}{c.documents.includes("pan") && <PanLink userId={c.userId} />}
              </Item>
              <Item label="UPI">{c.upi ?? "—"}</Item>
              <Item label="Academy">{c.academy.passed} of {c.academy.total} lessons</Item>
            </dl>

            {c.voice.needed && <VoiceIntro c={c} />}

            {c.rejectReason && <p className="rounded-lg bg-destructive/10 px-3 py-2 text-sm text-destructive">Rejected: {c.rejectReason}</p>}

            <div className="mt-auto flex flex-wrap gap-2">
              {c.status === "submitted" && (
                <>
                  <Button onClick={() => approve.mutate()} disabled={approve.isPending}><Check /> Approve</Button>
                  <Button variant="outline" onClick={() => setRejecting(true)}><X /> Reject</Button>
                </>
              )}
              {c.status === "approved" && canVideo && (
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

/** Loaded only when played, so opening the queue doesn't log listening to every clip. */
function VoiceIntro({ c }: { c: KycCase }) {
  const [shown, setShown] = useState(false);
  const has = c.documents.includes("voice");
  return (
    <div className="rounded-xl border bg-muted/40 p-3">
      <p className="text-xs font-medium text-muted-foreground">Voice intro — should read:</p>
      <p className="mb-2 text-sm font-semibold">“{c.voice.sentence ?? "—"}”</p>
      {!has ? (
        <p className="text-xs text-muted-foreground">
          {c.voice.checkedAt ? `Already checked on ${dateTime(c.voice.checkedAt)} (clip deleted).` : c.status === "approved" ? "Checked and deleted after the decision." : "Not recorded yet."}
        </p>
      ) : shown ? (
        <audio controls autoPlay src={`/api/v1/admin/kyc/${c.userId}/files/voice`} className="w-full">
          <track kind="captions" />
        </audio>
      ) : (
        <Button variant="outline" size="sm" onClick={() => setShown(true)}><Mic /> Play voice intro</Button>
      )}
      <p className="mt-2 text-xs text-muted-foreground">
        Check it&apos;s a woman&apos;s voice, it reads the sentence (the 4 digits change every time), and it fits the selfie. Approving pays the ₹10 joining bonus.
      </p>
    </div>
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
  const [redo, setRedo] = useState<KycItem[]>([]);
  const items: KycItem[] = ["age", "selfie", ...(c.voice.needed ? ["voice" as const] : []), "pan", "upi"];
  const toggle = (i: KycItem) => setRedo((r) => (r.includes(i) ? r.filter((x) => x !== i) : [...r, i]));
  const reject = useMutation({
    mutationFn: () => api(`admin/kyc/${c.userId}/decision`, { method: "POST", body: { decision: "reject", reason, redo } }),
    onSuccess: () => {
      toast.success(redo.length ? "Rejected — it comes back here by itself once they send those again" : "Rejected — they'll see your reason and can resubmit");
      qc.invalidateQueries({ queryKey: ["kyc"] });
      onClose();
      setReason("");
      setRedo([]);
    },
    onError: (e) => toast.error(e.message),
  });
  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Reject {c.displayName}&apos;s verification?</DialogTitle>
          <DialogDescription>The companion sees this reason in the app. Tick what they must send again — only those reset.</DialogDescription>
        </DialogHeader>
        <div className="flex flex-wrap gap-2">
          {REJECT_PRESETS.filter((p) => p.redo.every((i) => items.includes(i))).map((p) => (
            <button key={p.text} type="button"
              onClick={() => { setReason(p.text); setRedo((r) => [...new Set([...r, ...p.redo])]); }}
              className="rounded-full border px-3 py-1 text-xs hover:border-primary hover:text-primary">{p.text}</button>
          ))}
        </div>
        <Field label="Reason shown to the companion" htmlFor="kyc-reason">
          <Textarea id="kyc-reason" value={reason} onChange={(e) => setReason(e.target.value)} />
        </Field>
        <fieldset className="space-y-2">
          <legend className="mb-1 text-sm font-medium">Ask them to send again</legend>
          <div className="flex flex-wrap gap-2">
            {items.map((i) => (
              <label key={i} className={`flex cursor-pointer items-center gap-2 rounded-lg border px-3 py-1.5 text-sm ${redo.includes(i) ? "border-primary bg-primary/5 text-primary" : ""}`}>
                <input type="checkbox" className="accent-[#6D28D9]" checked={redo.includes(i)} onChange={() => toggle(i)} />
                {REDO_LABEL[i]}
              </label>
            ))}
          </div>
          <p className="text-xs text-muted-foreground">
            {redo.length ? "As soon as they send these, the case comes back to this queue by itself." : "Nothing ticked: they fix things and press Submit again."}
            {c.voice.needed && !redo.includes("voice") ? " Their voice intro counts as checked." : ""}
          </p>
        </fieldset>
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

// --- Profile photos -----------------------------------------------------------------
const PHOTO_REJECT_PRESETS = [
  "Doesn't look like the person in your KYC selfie",
  "Face isn't clearly visible — use a clear, well-lit photo of your face",
  "No nudity, suggestive poses or contact details in photos",
  "Group photos, celebrities and cartoons aren't allowed",
];

function PhotoQueue() {
  const { data, isLoading } = useQuery({ queryKey: ["photos"], queryFn: () => api<PendingPhoto[]>("admin/photos") });
  return (
    <>
      <p className="mb-3 text-sm text-muted-foreground">
        Companions&apos; own photos replace their avatar once approved. Check it&apos;s the same person as the KYC selfie, the face is clear,
        and there&apos;s nothing suggestive or any contact details. Callers never upload photos.
      </p>
      {isLoading && <p className="text-sm text-muted-foreground">Loading…</p>}
      {data?.length === 0 && <Card><CardContent className="py-12 text-center text-sm text-muted-foreground">No photos waiting 🎉</CardContent></Card>}
      <div className="space-y-4">
        <AnimatePresence initial={false}>
          {data?.map((p) => <PhotoCase key={p.user.id} p={p} />)}
        </AnimatePresence>
      </div>
    </>
  );
}

function PhotoCase({ p }: { p: PendingPhoto }) {
  const qc = useQueryClient();
  const [reason, setReason] = useState("");
  const [rejecting, setRejecting] = useState(false);
  const decide = useMutation({
    mutationFn: (decision: "approve" | "reject") =>
      api(`admin/photos/${p.user.id}/decision`, { method: "POST", body: { decision, reason: decision === "reject" ? reason : null } }),
    onSuccess: (_, decision) => {
      toast.success(decision === "approve" ? `${p.user.displayName}'s photo is live` : "Rejected — they'll see your reason");
      qc.invalidateQueries({ queryKey: ["photos"] });
      setRejecting(false);
      setReason("");
    },
    onError: (e) => toast.error(e.message),
  });
  return (
    <motion.div layout initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, x: -24 }}>
      <Card>
        <CardContent className="grid gap-6 lg:grid-cols-[auto_1fr]">
          <div className="flex gap-3">
            <figure className="w-40 space-y-1.5">
              <div className="aspect-[3/4] overflow-hidden rounded-xl border bg-muted">
                {/* eslint-disable-next-line @next/next/no-img-element -- signed, private URL */}
                <img src={`/api${p.pendingUrl}`} alt="New photo" className="size-full object-cover" />
              </div>
              <figcaption className="text-center text-xs text-muted-foreground">New photo</figcaption>
            </figure>
            <Photo userId={p.user.id} doc="selfie" label="KYC selfie" has={p.hasSelfie} />
          </div>
          <div className="flex min-w-0 flex-col gap-3">
            <div>
              <h2 className="font-heading text-xl font-extrabold">{p.user.displayName}</h2>
              <p className="text-sm text-muted-foreground">
                Sent {dateTime(p.submittedAt)} · KYC {p.user.kycStatus ?? "not started"}{p.currentUrl ? " · replaces their current photo" : ""}
              </p>
            </div>
            {rejecting && (
              <>
                <div className="flex flex-wrap gap-2">
                  {PHOTO_REJECT_PRESETS.map((r) => (
                    <button key={r} type="button" onClick={() => setReason(r)}
                      className="rounded-full border px-3 py-1 text-xs hover:border-primary hover:text-primary">{r}</button>
                  ))}
                </div>
                <Field label="Reason shown to the companion" htmlFor={`ph-${p.user.id}`}>
                  <Textarea id={`ph-${p.user.id}`} value={reason} onChange={(e) => setReason(e.target.value)} />
                </Field>
              </>
            )}
            <div className="mt-auto flex flex-wrap gap-2">
              {rejecting ? (
                <>
                  <Button variant="destructive" disabled={reason.trim().length < 3 || decide.isPending} onClick={() => decide.mutate("reject")}>Reject photo</Button>
                  <Button variant="outline" onClick={() => setRejecting(false)}>Cancel</Button>
                </>
              ) : (
                <>
                  <Button onClick={() => decide.mutate("approve")} disabled={decide.isPending}><Check /> Approve</Button>
                  <Button variant="outline" onClick={() => setRejecting(true)}><X /> Reject</Button>
                </>
              )}
            </div>
          </div>
        </CardContent>
      </Card>
    </motion.div>
  );
}
