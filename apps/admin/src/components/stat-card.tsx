"use client";

import { animate, motion, useMotionValue, useTransform } from "framer-motion";
import { useEffect } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { cn } from "@/lib/utils";

/** Counts up to the value when it changes. */
export function AnimatedNumber({ value, format = (n) => n.toLocaleString("en-IN") }: { value: number; format?: (n: number) => string }) {
  const mv = useMotionValue(0);
  const text = useTransform(mv, (v) => format(Math.round(v)));
  useEffect(() => {
    const controls = animate(mv, value, { duration: 0.6, ease: "easeOut" });
    return () => controls.stop();
  }, [mv, value]);
  return <motion.span>{text}</motion.span>;
}

export function StatCard({
  label, value, format = (n) => n.toLocaleString("en-IN"), hint, tone = "default", index = 0,
}: {
  label: string; value: number | undefined; format?: (n: number) => string; hint?: React.ReactNode;
  tone?: "default" | "success" | "warning" | "danger"; index?: number;
}) {
  return (
    <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: index * 0.05 }}>
      <Card className="h-full">
        <CardContent className="space-y-1">
          <p className="text-sm font-medium text-muted-foreground">{label}</p>
          <p className={cn("font-heading text-3xl font-extrabold tracking-tight",
            tone === "success" && "text-success", tone === "warning" && "text-warning", tone === "danger" && "text-destructive")}>
            {value === undefined ? <span className="text-muted-foreground/40">—</span> : <AnimatedNumber value={value} format={format} />}
          </p>
          {hint && <p className="text-xs text-muted-foreground">{hint}</p>}
        </CardContent>
      </Card>
    </motion.div>
  );
}
