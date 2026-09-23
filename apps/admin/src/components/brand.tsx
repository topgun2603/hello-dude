import { cn } from "@/lib/utils";

/** Round gradient badge with the sound-wave glyph. */
export function BrandMark({ size = 36 }: { size?: number }) {
  return (
    <span style={{ width: size, height: size }}
      className="grid shrink-0 place-items-center rounded-full bg-[linear-gradient(135deg,#F472B6,#DB2777_55%,#9D174D)] shadow-[0_10px_30px_-10px_rgba(236,72,153,0.8)]">
      <svg width={size / 2} height={size / 2} viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.4" strokeLinecap="round" aria-hidden>
        <path d="M4 10v4M8 7v10M12 4v16M16 7v10M20 10v4" />
      </svg>
    </span>
  );
}

/** Logo + "Hello Dude! Admin". The app name is a placeholder. */
export function Brand({ inverted = false }: { inverted?: boolean }) {
  return (
    <div className="flex items-center gap-2.5">
      <BrandMark />
      <span className="font-heading text-lg font-extrabold tracking-tight">
        Hello Dude! <span className={cn("font-bold", inverted ? "text-white/60" : "text-muted-foreground")}>Admin</span>
      </span>
    </div>
  );
}
