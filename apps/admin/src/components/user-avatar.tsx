import Image from "next/image";
import { cn } from "@/lib/utils";

/** Illustrated avatars chosen from gender at sign-up (masters in design/brand/avatars/). */
const PICTURES: Record<number, string> = {
  1: "/avatars/female.jpg",
  2: "/avatars/male.jpg",
  3: "/avatars/transgender.jpg",
};

const TINTS = [
  "bg-pink-100 text-pink-600", "bg-sky-100 text-sky-600", "bg-orange-100 text-orange-600",
  "bg-violet-100 text-violet-600", "bg-emerald-100 text-emerald-600", "bg-amber-100 text-amber-700",
];

/** The same avatar the app shows: a picture for ids 1–3, otherwise a tinted initial. */
export function UserAvatar({ id, name, avatarId, size = 44, className }: {
  id: string; name: string; avatarId?: number | null; size?: number; className?: string;
}) {
  const picture = avatarId ? PICTURES[avatarId] : undefined;
  if (picture) {
    return (
      <Image src={picture} alt="" width={size} height={size}
        className={cn("shrink-0 rounded-full object-cover ring-2 ring-white shadow-sm", className)} />
    );
  }
  const tint = TINTS[[...id].reduce((n, c) => n + c.charCodeAt(0), 0) % TINTS.length];
  return (
    <span style={{ width: size, height: size, fontSize: size * 0.4 }}
      className={cn("grid shrink-0 place-items-center rounded-full font-heading font-bold", tint, className)}>
      {name.trim().charAt(0).toUpperCase() || "?"}
    </span>
  );
}
