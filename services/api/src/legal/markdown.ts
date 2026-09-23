/**
 * Tiny Markdown subset for the legal pages in docs/legal (we write them, so the
 * subset is enough): #/## headings, paragraphs, - and 1. lists, | tables |,
 * **bold**, _italic_ and [links](target). One parse feeds both the public HTML
 * pages and the structured blocks the app renders natively.
 */

export interface Span { text: string; bold?: boolean; italic?: boolean; href?: string }
/** A list item or table cell. (Objects, not nested arrays: the Dart generator can't map List<List<…>>.) */
export interface Cell { spans: Span[] }
export interface Block {
  type: "h1" | "h2" | "p" | "ul" | "ol" | "table";
  /** h1, h2, p */
  spans?: Span[];
  /** ul, ol */
  items?: Cell[];
  /** table: header cells, then rows of cells */
  head?: Cell[];
  rows?: { cells: Cell[] }[];
}

const INLINE = /(\*\*[^*]+\*\*|(?<![\w])_[^_]+_(?![\w])|\[[^\]]+\]\([^)]+\))/g;

export function inline(text: string): Span[] {
  const out: Span[] = [];
  let last = 0;
  for (const m of text.matchAll(INLINE)) {
    if (m.index > last) out.push({ text: text.slice(last, m.index) });
    const tok = m[0];
    if (tok.startsWith("**")) out.push({ text: tok.slice(2, -2), bold: true });
    else if (tok.startsWith("_")) out.push({ text: tok.slice(1, -1), italic: true });
    else {
      const [, label, href] = /^\[([^\]]+)\]\(([^)]+)\)$/.exec(tok)!;
      out.push({ text: label!, href: href! });
    }
    last = m.index + tok.length;
  }
  if (last < text.length) out.push({ text: text.slice(last) });
  return out;
}

const cells = (line: string): Cell[] => line.trim().replace(/^\||\|$/g, "").split("|").map((c) => ({ spans: inline(c.trim()) }));

export function parse(md: string): Block[] {
  const blocks: Block[] = [];
  const lines = md.replace(/\r\n/g, "\n").split("\n");
  let para: string[] = [];
  const flush = () => {
    if (para.length) blocks.push({ type: "p", spans: inline(para.join(" ")) });
    para = [];
  };
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]!;
    const t = line.trim();
    if (!t) { flush(); continue; }
    const h = /^(#{1,2})\s+(.*)$/.exec(t);
    if (h) { flush(); blocks.push({ type: h[1]!.length === 1 ? "h1" : "h2", spans: inline(h[2]!) }); continue; }
    const list = /^(-|\d+\.)\s+/.exec(t);
    if (list) {
      flush();
      const type = list[1] === "-" ? "ul" : "ol";
      const items: Cell[] = [];
      while (i < lines.length && /^(-|\d+\.)\s+/.test(lines[i]!.trim())) {
        items.push({ spans: inline(lines[i]!.trim().replace(/^(-|\d+\.)\s+/, "")) });
        i++;
      }
      i--;
      blocks.push({ type, items });
      continue;
    }
    if (t.startsWith("|")) {
      flush();
      const head = cells(t);
      i += 2; // skip the |---| separator
      const rows: { cells: Cell[] }[] = [];
      while (i < lines.length && lines[i]!.trim().startsWith("|")) rows.push({ cells: cells(lines[i++]!) });
      i--;
      blocks.push({ type: "table", head, rows });
      continue;
    }
    para.push(t);
  }
  flush();
  return blocks;
}

// ---------------------------------------------------------------------------
// HTML

const esc = (s: string) => s.replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]!);

/** Text still containing an unfilled {{PLACEHOLDER}} is highlighted so drafts are obvious. */
const text = (s: string) => esc(s).replace(/\[([A-Z][^\]]*? to be filled)\]/g, '<mark>[$1]</mark>');

export function spansHtml(spans: Span[]): string {
  return spans.map((s) => {
    let h = text(s.text);
    if (s.bold) h = `<strong>${h}</strong>`;
    if (s.italic) h = `<em>${h}</em>`;
    if (s.href) {
      const external = /^(https?:|mailto:)/.test(s.href);
      h = `<a href="${esc(external ? s.href : `/legal/${s.href}`)}">${h}</a>`;
    }
    return h;
  }).join("");
}

export function blocksHtml(blocks: Block[]): string {
  return blocks.map((b) => {
    switch (b.type) {
      case "h1": return `<h1>${spansHtml(b.spans!)}</h1>`;
      case "h2": return `<h2>${spansHtml(b.spans!)}</h2>`;
      case "p": return `<p>${spansHtml(b.spans!)}</p>`;
      case "ul": case "ol": return `<${b.type}>${b.items!.map((it) => `<li>${spansHtml(it.spans)}</li>`).join("")}</${b.type}>`;
      case "table": return `<div class="table"><table><thead><tr>${b.head!.map((c) => `<th>${spansHtml(c.spans)}</th>`).join("")}</tr></thead><tbody>${
        b.rows!.map((r) => `<tr>${r.cells.map((c) => `<td>${spansHtml(c.spans)}</td>`).join("")}</tr>`).join("")}</tbody></table></div>`;
    }
  }).join("\n");
}
