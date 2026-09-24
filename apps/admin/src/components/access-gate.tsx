"use client";

import { Lock } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect } from "react";
import { NAV } from "@/components/sidebar";
import { Button } from "@/components/ui/button";
import { pageAllowed, useCan, useMe } from "@/lib/access";
import { ApiError } from "@/lib/api";

/**
 * Shows a page only to staff whose role allows it. The API refuses anyway; this
 * just replaces a page full of errors with a clear message. Staff without the
 * dashboard land on the first page they can use.
 */
export function AccessGate({ children }: { children: React.ReactNode }) {
  const path = usePathname();
  const router = useRouter();
  const me = useMe();
  const can = useCan();
  const allowedNav = NAV.filter((n) => pageAllowed(n.href, can));
  const allowed = me.data ? pageAllowed(path, can) : true;

  useEffect(() => {
    if (me.data && path === "/" && !allowed && allowedNav[0]) router.replace(allowedNav[0].href);
  }, [me.data, path, allowed, allowedNav, router]);

  if (me.isLoading) return <div className="h-64 animate-pulse rounded-3xl bg-white/60" aria-busy="true" />;

  if (me.error) {
    const inactive = me.error instanceof ApiError && me.error.code === "STAFF_INACTIVE";
    return (
      <Blocked title={inactive ? "Your access is switched off" : "Couldn't check your access"}
        body={inactive ? "Ask an admin to switch it back on." : me.error.message}>
        <Button variant="outline" onClick={() => fetch("/api/auth/logout", { method: "POST" }).then(() => window.location.replace("/login"))}>
          Sign out
        </Button>
      </Blocked>
    );
  }

  if (!allowed) {
    return (
      <Blocked title="Your role can't open this page" body={`You're signed in as ${me.data?.roleName}. Ask an admin if you need access.`}>
        <div className="flex flex-wrap justify-center gap-2">
          {allowedNav.slice(0, 4).map((n) => (
            <Button key={n.href} variant="outline" nativeButton={false} render={<Link href={n.href} />}>{n.label}</Button>
          ))}
        </div>
      </Blocked>
    );
  }
  return <>{children}</>;
}

function Blocked({ title, body, children }: { title: string; body: string; children: React.ReactNode }) {
  return (
    <div className="mx-auto mt-10 flex max-w-md flex-col items-center gap-3 rounded-3xl border border-[#E7E4F0] bg-white p-8 text-center shadow-sm">
      <span className="grid size-14 place-items-center rounded-2xl bg-violet-50 text-violet-600"><Lock className="size-6" /></span>
      <h1 className="font-heading text-xl font-extrabold">{title}</h1>
      <p className="text-sm text-muted-foreground">{body}</p>
      <div className="mt-2">{children}</div>
    </div>
  );
}
