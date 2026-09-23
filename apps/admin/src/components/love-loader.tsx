"use client";

import { AnimatePresence, motion, useReducedMotion } from "framer-motion";
import { useSyncExternalStore } from "react";
import { createPortal } from "react-dom";

/**
 * Full-screen "two bubbles meet, a heart beats" loader for sign-in / sign-out.
 * Rendered in a portal so it covers the sidebar and top bar too.
 */
export function LoveLoader({ show, title, subtitle }: { show: boolean; title: string; subtitle?: string }) {
  // false during server render, true in the browser (where document.body exists)
  const inBrowser = useSyncExternalStore(noop, () => true, () => false);
  if (!inBrowser) return null;
  return createPortal(
    <AnimatePresence>
      {show && (
        <motion.div key="love-loader" role="status" aria-live="polite"
          initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} transition={{ duration: 0.25 }}
          className="fixed inset-0 z-[100] grid place-items-center bg-[radial-gradient(60%_60%_at_50%_45%,rgba(236,72,153,0.28),transparent_70%),linear-gradient(160deg,rgba(26,11,46,0.92),rgba(18,7,36,0.96))] backdrop-blur-md">
          <div className="flex flex-col items-center text-center">
            <Scene />
            <motion.p initial={{ y: 8, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ delay: 0.15 }}
              className="mt-2 font-heading text-2xl font-extrabold tracking-tight text-white">
              {title}
            </motion.p>
            {subtitle && (
              <motion.p initial={{ y: 8, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ delay: 0.25 }}
                className="mt-1 font-hand text-2xl text-pink-200">
                {subtitle}
              </motion.p>
            )}
            <Dots />
          </div>
        </motion.div>
      )}
    </AnimatePresence>,
    document.body,
  );
}

const noop = () => () => {};

const HEART = "M12 21s-7.5-4.6-9.6-9.2C.9 8.4 3 4.5 6.7 4.5c2.1 0 3.6 1.2 4.3 2.6h2c.7-1.4 2.2-2.6 4.3-2.6 3.7 0 5.8 3.9 4.3 7.3C19.5 16.4 12 21 12 21Z";

function Scene() {
  const still = useReducedMotion();
  const loop = { repeat: Infinity, ease: "easeInOut" } as const;
  return (
    <div className="relative h-44 w-72" aria-hidden>
      {/* floating mini hearts */}
      {!still && [0, 1, 2, 3, 4].map((i) => (
        <motion.svg key={i} viewBox="0 0 24 24" className="absolute bottom-10 size-4 fill-pink-400/80"
          style={{ left: `${30 + i * 10}%` }}
          initial={{ y: 0, opacity: 0, scale: 0.6 }}
          animate={{ y: -110, opacity: [0, 1, 0], scale: [0.6, 1, 0.8], x: i % 2 ? [0, 8, -4] : [0, -8, 4] }}
          transition={{ duration: 2.4, delay: i * 0.45, ...loop }}>
          <path d={HEART} />
        </motion.svg>
      ))}

      {/* pink bubble (left) and blue bubble (right) lean in toward each other */}
      <motion.div className="absolute left-4 top-10"
        animate={still ? undefined : { x: [0, 26, 26, 0], rotate: [0, 6, 6, 0] }}
        transition={{ duration: 2.4, times: [0, 0.35, 0.65, 1], ...loop }}>
        <Bubble from="#F472B6" to="#DB2777" wink />
      </motion.div>
      <motion.div className="absolute right-4 top-10"
        animate={still ? undefined : { x: [0, -26, -26, 0], rotate: [0, -6, -6, 0] }}
        transition={{ duration: 2.4, times: [0, 0.35, 0.65, 1], ...loop }}>
        <Bubble from="#67E8F9" to="#3B82F6" flip />
      </motion.div>

      {/* the heart that beats when they meet */}
      <div className="absolute left-1/2 top-2 -translate-x-1/2">
        {!still && (
          <motion.span className="absolute inset-0 rounded-full border-2 border-pink-400"
            animate={{ scale: [0.6, 1.9], opacity: [0.7, 0] }}
            transition={{ duration: 1.2, ...loop, ease: "easeOut" }} />
        )}
        <motion.svg viewBox="0 0 24 24" className="relative size-12 drop-shadow-[0_6px_18px_rgba(236,72,153,0.8)]"
          animate={still ? undefined : { scale: [1, 1.25, 1, 1.18, 1] }}
          transition={{ duration: 1.2, times: [0, 0.15, 0.3, 0.45, 1], ...loop }}>
          <defs>
            <linearGradient id="love-heart" x1="0" y1="0" x2="1" y2="1">
              <stop offset="0%" stopColor="#FBCFE8" />
              <stop offset="45%" stopColor="#F472B6" />
              <stop offset="100%" stopColor="#DB2777" />
            </linearGradient>
          </defs>
          <path d={HEART} fill="url(#love-heart)" />
        </motion.svg>
      </div>
    </div>
  );
}

/** Speech bubble with a little face, like the app icon. */
function Bubble({ from, to, wink, flip }: { from: string; to: string; wink?: boolean; flip?: boolean }) {
  const id = `bubble-${from.slice(1)}`;
  return (
    <svg width="96" height="88" viewBox="0 0 96 88" className={flip ? "-scale-x-100" : undefined}>
      <defs>
        <linearGradient id={id} x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" stopColor={from} />
          <stop offset="100%" stopColor={to} />
        </linearGradient>
      </defs>
      <path d="M48 4C24 4 6 18 6 38c0 11 6 21 16 27l-4 17 18-11c4 1 8 1 12 1 24 0 42-14 42-34S72 4 48 4Z"
        fill={`url(#${id})`} />
      <ellipse cx="30" cy="20" rx="12" ry="6" fill="#fff" opacity="0.3" transform="rotate(-20 30 20)" />
      <g stroke="#1A0B2E" strokeWidth="4" strokeLinecap="round" fill="none">
        {wink ? <path d="M58 34l8-4M58 34l8 4" /> : <path d="M58 36c2-4 7-4 9 0" />}
        <path d="M32 36c2-4 7-4 9 0" />
        <path d="M36 48c6 7 18 7 24 0" />
      </g>
    </svg>
  );
}

function Dots() {
  const still = useReducedMotion();
  return (
    <div className="mt-5 flex gap-2" aria-hidden>
      {[0, 1, 2].map((i) => (
        <motion.span key={i} className="size-2 rounded-full bg-pink-300"
          animate={still ? undefined : { y: [0, -6, 0], opacity: [0.4, 1, 0.4] }}
          transition={{ duration: 0.9, delay: i * 0.15, repeat: Infinity, ease: "easeInOut" }} />
      ))}
    </div>
  );
}
