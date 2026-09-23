/**
 * Terms, Privacy, Community Guidelines, Grievance Officer and account deletion.
 * Public HTML at /legal/* (the URLs given to Google Play and linked from the
 * app), and structured blocks at /v1/legal/* for the app to render natively.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { notFound } from "../errors.js";
import { blocksHtml } from "../legal/markdown.js";
import { isLegalPage, LEGAL_PAGES, legalPage, type LegalPageId } from "../legal/pages.js";
import { numberSetting } from "../settings.js";

const APP_NAME = "Hello Dude!";

const Span = z.object({
  text: z.string(), bold: z.boolean().optional(), italic: z.boolean().optional(),
  href: z.string().optional().describe("Another legal page id (e.g. \"privacy\") or an absolute URL"),
}).meta({ id: "LegalSpan" });

const Cell = z.object({ spans: z.array(Span) }).meta({ id: "LegalCell" });

const Block = z.object({
  type: z.enum(["h1", "h2", "p", "ul", "ol", "table"]),
  spans: z.array(Span).optional().describe("h1, h2, p"),
  items: z.array(Cell).optional().describe("ul, ol"),
  head: z.array(Cell).optional().describe("table header cells"),
  rows: z.array(z.object({ cells: z.array(Cell) }).meta({ id: "LegalRow" })).optional().describe("table rows"),
}).meta({ id: "LegalBlock" });

const PageId = z.enum(Object.keys(LEGAL_PAGES) as [LegalPageId, ...LegalPageId[]]);

/** API routes, registered under /v1. */
export const legalApiRoutes: FastifyPluginAsyncZod = async (app) => {
  const load = async (id: LegalPageId) =>
    legalPage(id, app.deps.legal ?? {}, { appName: APP_NAME, refundWindowDays: await numberSetting(app.deps.db, "refund.window_days", 7) });

  app.get("/legal", {
    schema: {
      tags: ["legal"],
      summary: "The legal pages the app lists under Profile → Legal",
      response: { 200: z.array(z.object({ id: PageId, title: z.string(), url: z.string() })) },
    },
  }, async () => Object.entries(LEGAL_PAGES).map(([id, title]) => ({ id: id as LegalPageId, title, url: `/legal/${id}` })));

  app.get("/legal/:id", {
    schema: {
      tags: ["legal"],
      summary: "One legal page as blocks the app renders natively",
      params: z.object({ id: PageId }),
      response: { 200: z.object({ id: PageId, title: z.string(), draft: z.boolean(), blocks: z.array(Block) }) },
    },
  }, async (req) => load(req.params.id));
};

/** Public HTML pages (no /v1 prefix, no sign-in). */
export const legalHtmlRoutes: FastifyPluginAsyncZod = async (app) => {
  const refundDays = () => numberSetting(app.deps.db, "refund.window_days", 7);

  app.get("/legal", { schema: { hide: true } }, async (_req, reply) => {
    const links = Object.entries(LEGAL_PAGES).map(([id, title]) => `<li><a href="/legal/${id}">${title}</a></li>`).join("");
    return reply.type("text/html; charset=utf-8").header("cache-control", "public, max-age=300")
      .send(shell("Legal", `<h1>Legal</h1><ul class="index">${links}</ul>`, false));
  });

  app.get("/legal/:id", { schema: { hide: true, params: z.object({ id: z.string() }) } }, async (req, reply) => {
    const { id } = req.params;
    if (!isLegalPage(id)) throw notFound("PAGE_NOT_FOUND");
    const page = legalPage(id, app.deps.legal ?? {}, { appName: APP_NAME, refundWindowDays: await refundDays() });
    return reply.type("text/html; charset=utf-8").header("cache-control", "public, max-age=300")
      .send(shell(page.title, blocksHtml(page.blocks), page.draft));
  });
};

function shell(title: string, body: string, draft: boolean): string {
  const nav = Object.entries(LEGAL_PAGES).map(([id, t]) => `<a href="/legal/${id}">${t}</a>`).join("");
  return `<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${title} · ${APP_NAME}</title><meta name="robots" content="index,follow">
<style>
:root{--bg:#F7F6FB;--card:#fff;--text:#1B1340;--muted:#6B6485;--line:#ECE7F4;--accent:#DB2777}
@media (prefers-color-scheme:dark){:root{--bg:#0A0A18;--card:#16142C;--text:#F4F2FB;--muted:#C9C5DD;--line:#2A2745;--accent:#F472B6}}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--text);font:16px/1.65 system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
header{background:linear-gradient(90deg,#7C3AED,#DB2777 55%,#EA580C);color:#fff;padding:22px 16px}
header .in{max-width:820px;margin:0 auto;display:flex;align-items:center;gap:10px;font-weight:800;font-size:20px}
nav{max-width:820px;margin:0 auto;padding:12px 16px 0;display:flex;flex-wrap:wrap;gap:8px}
nav a{font-size:14px;color:var(--muted);text-decoration:none;border:1px solid var(--line);border-radius:999px;padding:4px 12px;background:var(--card)}
nav a:hover{color:var(--accent);border-color:var(--accent)}
main{max-width:820px;margin:16px auto 48px;padding:28px 20px;background:var(--card);border:1px solid var(--line);border-radius:20px}
h1{font-size:30px;line-height:1.2;margin:0 0 6px}h2{font-size:20px;margin:28px 0 8px}p,li{color:var(--text)}
em{color:var(--muted)}a{color:var(--accent)}ul,ol{padding-left:22px}li{margin:4px 0}
.table{overflow-x:auto}table{border-collapse:collapse;width:100%;font-size:15px}th,td{border-bottom:1px solid var(--line);text-align:left;padding:8px 10px;vertical-align:top}th{color:var(--muted);font-weight:600}
mark{background:#FDE68A;color:#1B1340;border-radius:4px;padding:0 3px}
.draft{max-width:820px;margin:12px auto 0;padding:10px 16px;border-radius:12px;background:#FEF3C7;color:#92400E;font-size:14px}
.index a{font-size:18px}footer{text-align:center;color:var(--muted);font-size:13px;padding-bottom:32px}
</style></head><body>
<header><div class="in">♥ ${APP_NAME}</div></header>
${draft ? '<div class="draft"><b>Draft.</b> Company details are not filled in yet — this page is not final.</div>' : ""}
<nav>${nav}</nav>
<main>${body}</main>
<footer>© ${new Date().getFullYear()} ${APP_NAME}</footer>
</body></html>`;
}
