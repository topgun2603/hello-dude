import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { call, createAppHarness, json, type AppHarness } from "../../test/app-harness.js";
import { inline, parse } from "../legal/markdown.js";
import { LEGAL_PAGES, legalPage } from "../legal/pages.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });

describe("markdown subset", () => {
  it("parses headings, lists, tables and inline marks", () => {
    const blocks = parse("# Title\n\n_Effective x_\n\n## One\n- a **b**\n- see [Privacy](privacy)\n\n1. first\n2. second\n\n| A | B |\n|---|---|\n| 1 | 2 |\n");
    expect(blocks.map((b) => b.type)).toEqual(["h1", "p", "h2", "ul", "ol", "table"]);
    expect(blocks[3]!.items![1]).toEqual({ spans: [{ text: "see " }, { text: "Privacy", href: "privacy" }] });
    expect(blocks[5]).toMatchObject({ head: [{ spans: [{ text: "A" }] }, { spans: [{ text: "B" }] }], rows: [{ cells: [{ spans: [{ text: "1" }] }, { spans: [{ text: "2" }] }] }] });
    expect(inline("snake_case_name stays")).toEqual([{ text: "snake_case_name stays" }]);
  });
});

describe("legal pages", () => {
  it("every page renders; missing company details mark it as a draft", () => {
    for (const id of Object.keys(LEGAL_PAGES) as (keyof typeof LEGAL_PAGES)[]) {
      const draft = legalPage(id, {}, { appName: "Hello Dude!", refundWindowDays: 7 });
      expect(draft.blocks.length).toBeGreaterThan(2);
      const flat = JSON.stringify(draft.blocks);
      expect(flat).not.toContain("{{");
    }
    const filled = legalPage("grievance", {
      companyName: "HD Pvt Ltd", companyAddress: "Chennai", supportEmail: "s@x.in", grievanceOfficerName: "A. Officer",
      grievanceEmail: "g@x.in", jurisdictionCity: "Chennai", effectiveDate: "1 Oct 2026",
    }, { appName: "Hello Dude!", refundWindowDays: 7 });
    expect(filled.draft).toBe(false);
    expect(JSON.stringify(filled.blocks)).toContain("g@x.in");
    expect(legalPage("terms", {}, { appName: "Hello Dude!", refundWindowDays: 7 }).draft).toBe(true);
  });

  it("serves public HTML and app blocks without signing in", async () => {
    const html = await call(h, "GET", "/legal/privacy");
    expect(html.statusCode).toBe(200);
    expect(html.headers["content-type"]).toContain("text/html");
    expect(html.body).toContain("<h1>Privacy Policy</h1>");
    expect(html.body).toContain("Draft.");
    expect(html.body).toContain('href="/legal/delete-account"');
    expect((await call(h, "GET", "/legal/nope")).statusCode).toBe(404);
    expect((await call(h, "GET", "/legal")).body).toContain("Community Guidelines");

    const list = json<{ id: string }[]>(await call(h, "GET", "/v1/legal"));
    expect(list.map((p) => p.id)).toEqual(["terms", "privacy", "community", "grievance", "delete-account"]);
    const page = json<{ title: string; draft: boolean; blocks: { type: string }[] }>(await call(h, "GET", "/v1/legal/terms"));
    expect(page).toMatchObject({ title: "Terms of Use", draft: true });
    expect(page.blocks[0]!.type).toBe("h1");
    expect((await call(h, "GET", "/v1/legal/other")).statusCode).toBe(400);
  });
});
