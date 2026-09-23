import { MobileNav, Sidebar } from "@/components/sidebar";
import { TopBar } from "@/components/top-bar";

export default function PanelLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-screen">
      <Sidebar />
      <div className="relative min-w-0 flex-1 overflow-x-clip">
        {/* Soft pink / lavender glows behind the content */}
        <div aria-hidden className="pointer-events-none absolute inset-x-0 top-0 h-[520px] bg-[radial-gradient(60%_80%_at_85%_0%,rgba(244,114,182,0.18),transparent_70%),radial-gradient(50%_70%_at_20%_0%,rgba(167,139,250,0.16),transparent_70%)]" />
        <MobileNav />
        <main className="relative px-4 py-5 md:px-8">
          <TopBar />
          {children}
        </main>
        <footer className="relative flex flex-wrap items-center justify-between gap-2 border-t px-4 py-4 text-xs text-muted-foreground md:px-8">
          <span>© {new Date().getFullYear()} Hello Dude! Admin</span>
          <span className="flex items-center gap-1.5"><span className="text-pink-500">♥</span> Built for a kinder internet.</span>
        </footer>
      </div>
    </div>
  );
}
