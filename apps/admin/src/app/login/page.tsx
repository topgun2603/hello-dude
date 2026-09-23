"use client";

import { AnimatePresence, motion } from "framer-motion";
import { ArrowRight, BarChart3, Heart, ShieldCheck, UsersRound } from "lucide-react";
import Image from "next/image";
import { useRef, useState } from "react";
import { toast } from "sonner";
import { BrandMark } from "@/components/brand";
import { LoveLoader } from "@/components/love-loader";

async function post(path: string, body: unknown) {
  const res = await fetch(path, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body) });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data?.error?.message ?? "Something went wrong");
  return data;
}

/** Keeps the loader up long enough to be seen instead of flashing. */
const atLeast = <T,>(p: Promise<T>, ms: number) =>
  Promise.all([p, new Promise((r) => setTimeout(r, ms))]).then(([v]) => v);

const FEATURES = [
  { icon: Heart, title: "Companions", sub: "Onboard & manage" },
  { icon: UsersRound, title: "Calls & Users", sub: "Live monitoring" },
  { icon: BarChart3, title: "Reports", sub: "Insights & growth" },
  { icon: ShieldCheck, title: "Safe Platform", sub: "Build trust" },
];

export default function LoginPage() {
  return (
    <main className="relative grid min-h-screen place-items-center overflow-hidden bg-[#1A0B2E] p-3 sm:p-6 lg:p-8">
      {/* Blurred bokeh backdrop behind the card */}
      <Image src="/login_admin_right_bg.png" alt="" fill preload sizes="100vw" className="scale-110 object-cover opacity-70 blur-2xl" />
      <div className="absolute inset-0 bg-[#1A0B2E]/30" />

      <motion.div initial={{ opacity: 0, y: 14 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.4 }}
        className="relative grid w-full max-w-[1480px] overflow-hidden rounded-[28px] shadow-[0_40px_120px_-30px_rgba(0,0,0,0.7)] ring-1 ring-white/15 lg:min-h-[min(900px,calc(100vh-4rem))] lg:grid-cols-[1.1fr_1fr]">
        <Showcase />
        <SignIn />
      </motion.div>
    </main>
  );
}

// ---------------------------------------------------------------------------
// Left: dark story panel with the two people facing each other.

function Showcase() {
  return (
    <section className="relative hidden flex-col justify-between overflow-hidden p-10 text-white lg:flex xl:p-12">
      <Image src="/login_admin_right_bg.png" alt="" fill sizes="55vw" className="object-cover object-left" />
      <div className="absolute inset-0 bg-[linear-gradient(180deg,rgba(24,9,46,0.72)_0%,rgba(24,9,46,0.35)_35%,rgba(18,7,36,0.55)_55%,rgba(15,6,32,0.96)_78%)]" />

      {/* People: he faces right, she faces left */}
      <motion.div initial={{ opacity: 0, x: -24 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 0.15, duration: 0.6 }}
        className="pointer-events-none absolute -left-[6%] top-[13%] w-[60%]">
        <Image src="/login_male_cutout.png" alt="" width={1374} height={1145} preload sizes="35vw" className="h-auto w-full [mask-image:linear-gradient(to_bottom,black_55%,transparent_92%)]" />
      </motion.div>
      <motion.div initial={{ opacity: 0, x: 24 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 0.25, duration: 0.6 }}
        className="pointer-events-none absolute -right-[7%] top-[22%] w-[58%]">
        <Image src="/login_girl.png" alt="" width={1377} height={1142} preload sizes="35vw" className="h-auto w-full [mask-image:linear-gradient(to_bottom,black_50%,transparent_90%)]" />
      </motion.div>
      {/* Fade the bodies into the text area */}
      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-[55%] bg-[linear-gradient(180deg,transparent_0%,rgba(18,7,36,0.85)_38%,#12072A_62%)]" />

      <header className="relative flex items-start justify-between gap-6">
        <div className="flex items-center gap-4">
          <BrandMark size={72} />
          <div>
            <p className="font-heading text-[38px] font-extrabold leading-none tracking-tight">Hello Dude!</p>
            <p className="mt-1.5 text-lg text-white/80">Admin Console</p>
          </div>
        </div>
        <p className="mt-3 text-[11px] font-semibold tracking-[0.28em] text-white/75">TALK • VIBE • CONNECT</p>
      </header>

      <p aria-hidden className="pointer-events-none absolute left-[46%] top-[20%] -rotate-[18deg] font-hand text-[30px] leading-[1.05] text-pink-200">
        Real People<br />Real Conversations <span className="text-pink-400">♥</span>
      </p>

      <div className="relative">
        <h1 className="font-heading text-[44px] font-extrabold leading-[1.08] tracking-tight xl:text-5xl">
          Manage a kinder,<br />
          <span className="bg-[linear-gradient(90deg,#F472B6,#EC4899_50%,#FB923C)] bg-clip-text text-transparent">more connected world.</span>
        </h1>
        <p className="mt-3 text-lg text-white/85">Different languages. Same vibe. Real conversations.</p>

        <ul className="mt-8 grid grid-cols-2 gap-x-4 gap-y-4 2xl:grid-cols-4">
          {FEATURES.map(({ icon: Icon, title, sub }) => (
            <li key={title} className="flex items-center gap-3">
              <span className="grid size-11 shrink-0 place-items-center rounded-xl border border-pink-300/30 bg-white/5 text-pink-400 backdrop-blur">
                <Icon className="size-6" />
              </span>
              <span>
                <span className="block whitespace-nowrap text-[15px] font-semibold">{title}</span>
                <span className="block whitespace-nowrap text-xs text-white/65">{sub}</span>
              </span>
            </li>
          ))}
        </ul>

        <p className="mt-10 font-hand text-[26px] leading-tight text-white/90">
          &ldquo;Good Conversations<br />Build a Kinder World&rdquo;
        </p>
        <span className="mt-2 block h-0.5 w-12 rounded-full bg-pink-500" />
      </div>
    </section>
  );
}

// ---------------------------------------------------------------------------
// Right: sign-in form (phone → 6-digit OTP).

function SignIn() {
  const [step, setStep] = useState<"phone" | "code">("phone");
  const [phone, setPhone] = useState("");
  const [code, setCode] = useState("");
  const [busy, setBusy] = useState(false);
  const [entering, setEntering] = useState(false);

  async function sendCode(e?: React.FormEvent) {
    e?.preventDefault();
    setBusy(true);
    try {
      await post("/api/auth/otp", { phone }).catch((err: Error) => {
        if (!/Wait \d+ seconds/.test(err.message)) throw err; // a recent code is still valid
      });
      setStep("code");
    } catch (err) {
      toast.error((err as Error).message);
    } finally {
      setBusy(false);
    }
  }

  async function verify(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setEntering(true);
    try {
      const { displayName } = await atLeast(post("/api/auth/verify", { phone, code }), 1200);
      toast.success(`Welcome, ${displayName}`);
      // Full load: the new session cookie applies everywhere and the loader
      // stays up until the dashboard replaces this page. (router.replace +
      // router.refresh cancelled the navigation and left the loader spinning.)
      window.location.replace("/");
    } catch (err) {
      setEntering(false);
      setBusy(false);
      toast.error((err as Error).message);
      setCode("");
    }
  }

  const button = "flex h-14 w-full items-center justify-center gap-2 rounded-2xl bg-[linear-gradient(90deg,#EC4899,#C026D3_55%,#7C3AED)] text-[17px] font-semibold text-white shadow-[0_14px_30px_-12px_rgba(192,38,211,0.7)] transition hover:brightness-110 disabled:opacity-50 disabled:hover:brightness-100";

  return (
    <>
    <LoveLoader show={entering} title="Signing you in…" subtitle="Different languages. Same vibe." />
    <section className="relative flex min-h-[calc(100vh-1.5rem)] flex-col overflow-hidden bg-[#FBF7FD] text-[#1B1340] sm:min-h-[calc(100vh-3rem)] lg:min-h-0">
      <Image src="/login_right_bg.png" alt="" fill sizes="(min-width: 1024px) 45vw, 100vw" className="object-cover" />

      <div className="relative flex flex-1 flex-col items-center justify-center px-6 py-12 sm:px-12">
        <div className="w-full max-w-[440px]">
          <div className="flex items-center justify-center gap-4">
            <BrandMark size={76} />
            <div>
              <p className="font-heading text-[40px] font-extrabold leading-none tracking-tight">Hello Dude!</p>
              <p className="mt-1.5 text-lg text-[#5B5478]">Admin Console</p>
            </div>
          </div>

          <h2 className="mt-10 text-center font-heading text-[32px] font-extrabold tracking-tight">Welcome Back 👋</h2>
          <p className="mt-1.5 text-center text-[#5B5478]">Continue to your admin account</p>

          <div className="mt-8">
            <AnimatePresence mode="wait">
              {step === "phone" ? (
                <motion.form key="phone" onSubmit={sendCode} className="space-y-5"
                  initial={{ opacity: 0, x: -10 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: 10 }}>
                  <div>
                    <label htmlFor="phone" className="mb-2 block text-[15px] font-semibold">Mobile number</label>
                    <div className="flex h-14 overflow-hidden rounded-2xl border border-[#E4DDF0] bg-white shadow-sm focus-within:border-pink-400 focus-within:ring-4 focus-within:ring-pink-200/60">
                      <span className="flex items-center gap-2 border-r border-[#E4DDF0] px-4 font-semibold">
                        <IndiaFlag /> +91
                      </span>
                      <input id="phone" inputMode="numeric" autoComplete="tel-national" autoFocus maxLength={10}
                        placeholder="Enter your mobile number" value={phone}
                        onChange={(e) => setPhone(e.target.value.replace(/\D/g, ""))}
                        className="min-w-0 flex-1 bg-transparent px-4 text-[16px] outline-none placeholder:text-[#A39DB8]" />
                    </div>
                  </div>
                  <button type="submit" className={button} disabled={busy || !/^[6-9]\d{9}$/.test(phone)}>
                    {busy ? "Sending…" : <>Send OTP <ArrowRight className="size-5" /></>}
                  </button>
                </motion.form>
              ) : (
                <motion.form key="code" onSubmit={verify} className="space-y-5"
                  initial={{ opacity: 0, x: -10 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: 10 }}>
                  <div>
                    <label htmlFor="code" className="mb-2 block text-[15px] font-semibold">
                      Enter the 6-digit code sent to +91 {phone}
                    </label>
                    <CodeBoxes value={code} onChange={setCode} />
                  </div>
                  <button type="submit" className={button} disabled={busy || code.length !== 6}>
                    {busy ? "Checking…" : <>Sign in <ArrowRight className="size-5" /></>}
                  </button>
                  <div className="flex justify-between text-sm font-medium">
                    <button type="button" className="text-[#6D28D9] hover:underline" onClick={() => { setStep("phone"); setCode(""); }}>
                      Change number
                    </button>
                    <button type="button" className="text-[#6D28D9] hover:underline disabled:opacity-50" disabled={busy} onClick={() => sendCode()}>
                      Resend code
                    </button>
                  </div>
                </motion.form>
              )}
            </AnimatePresence>
          </div>

          <p className="mt-8 flex items-center justify-center gap-2 text-sm text-[#5B5478]">
            <ShieldCheck className="size-4 shrink-0" /> Only authorised admin users can access this console.
          </p>
        </div>
      </div>

      <p aria-hidden className="pointer-events-none absolute bottom-16 right-8 hidden -rotate-12 text-right font-hand text-[26px] leading-[1.05] text-[#6D28D9] sm:block">
        Different languages.<br />Same vibe. <span className="text-pink-500">♥</span>
      </p>
      <footer className="relative border-t border-[#EDE6F5]/80 px-8 py-4 text-sm text-[#6B6487]">
        © {new Date().getFullYear()} Hello Dude!
      </footer>
    </section>
    </>
  );
}

/** One real input under six boxes, so paste and SMS autofill still work. */
function CodeBoxes({ value, onChange }: { value: string; onChange: (v: string) => void }) {
  const input = useRef<HTMLInputElement>(null);
  const [focused, setFocused] = useState(true);
  return (
    <div className="relative" onClick={() => input.current?.focus()}>
      <div className="grid grid-cols-6 gap-2.5" aria-hidden>
        {Array.from({ length: 6 }, (_, i) => {
          const active = focused && (i === value.length || (i === 5 && value.length === 6));
          return (
            <span key={i} className={
              "grid h-14 place-items-center rounded-2xl border bg-white font-heading text-2xl font-bold shadow-sm transition " +
              (active ? "border-pink-400 ring-4 ring-pink-200/60" : "border-[#E4DDF0]")}>
              {value[i] ?? ""}
            </span>
          );
        })}
      </div>
      <input id="code" ref={input} inputMode="numeric" autoComplete="one-time-code" autoFocus maxLength={6} value={value}
        onFocus={() => setFocused(true)} onBlur={() => setFocused(false)}
        onChange={(e) => onChange(e.target.value.replace(/\D/g, "").slice(0, 6))}
        className="absolute inset-0 h-full w-full cursor-text opacity-0" />
    </div>
  );
}

/** Inline flag: Windows doesn't render flag emoji. */
function IndiaFlag() {
  return (
    <svg width="26" height="18" viewBox="0 0 27 18" className="rounded-[3px] shadow-sm ring-1 ring-black/5" aria-hidden>
      <rect width="27" height="6" fill="#FF9933" />
      <rect y="6" width="27" height="6" fill="#fff" />
      <rect y="12" width="27" height="6" fill="#138808" />
      <circle cx="13.5" cy="9" r="2.2" fill="none" stroke="#000080" strokeWidth="0.7" />
    </svg>
  );
}
