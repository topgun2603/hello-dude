import Image from "next/image";
import { cn } from "@/lib/utils";

/** The brand coin (master artwork in design/brand/). */
export function Coin({ size = 16, className }: { size?: number; className?: string }) {
  return <Image src="/coin.png" alt="" width={size} height={size} className={cn("inline-block shrink-0", className)} />;
}

/** A pile of brand coins, for coin-related headers. */
export function CoinStack({ width = 120, className }: { width?: number; className?: string }) {
  // Source is 640×385.
  return <Image src="/coin_stack.png" alt="" width={width} height={Math.round(width * 385 / 640)} className={cn("shrink-0", className)} />;
}
