"use client";

import {
  FlexRender,
  createFacetedRowModel,
  createFacetedUniqueValues,
  createFilteredRowModel,
  createPaginatedRowModel,
  createSortedRowModel,
  columnFacetingFeature,
  columnFilteringFeature,
  filterFn_includesString,
  globalFilteringFeature,
  rowPaginationFeature,
  rowSortingFeature,
  sortFn_alphanumeric,
  sortFn_basic,
  sortFn_datetime,
  sortFn_text,
  tableFeatures,
  useTable,
  type ColumnDef,
  type FilterFn,
  type RowData,
} from "@tanstack/react-table";
import {
  ArrowDown, ArrowUp, ArrowUpDown, CalendarRange, ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight,
  Download, Search, X,
} from "lucide-react";
import { motion } from "framer-motion";
import { useMemo, useState } from "react";
import { Dropdown } from "@/components/dropdown";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { cn } from "@/lib/utils";

// ---------------------------------------------------------------------------
// Filter functions

type DateRange = [from: number | null, to: number | null];

/** Keeps rows whose date (ISO string) falls inside [from, to] (epoch ms, either end open). */
const dateBetween: FilterFn<any, any> = (row, columnId, [from, to]: DateRange) => { // eslint-disable-line @typescript-eslint/no-explicit-any
  const v = row.getValue(columnId);
  if (v == null) return false;
  const t = new Date(v as string).getTime();
  return (from == null || t >= from) && (to == null || t <= to);
};
dateBetween.autoRemove = (v?: DateRange) => !v || (v[0] == null && v[1] == null);

/** Exact match on the value as text (works for strings, numbers, booleans and null). */
const sameValue: FilterFn<any, any> = (row, columnId, value: string) => String(row.getValue(columnId) ?? "") === value; // eslint-disable-line @typescript-eslint/no-explicit-any
sameValue.autoRemove = (v?: string) => v == null || v === "";

/** Sorting, search, filters, facet counts and pagination — shared by every list in the panel. */
export const tableFeatureSet = tableFeatures({
  rowSortingFeature,
  rowPaginationFeature,
  columnFilteringFeature,
  globalFilteringFeature,
  columnFacetingFeature,
  sortedRowModel: createSortedRowModel(),
  paginatedRowModel: createPaginatedRowModel(),
  filteredRowModel: createFilteredRowModel(),
  facetedRowModel: createFacetedRowModel(),
  facetedUniqueValues: createFacetedUniqueValues(),
  sortFns: { alphanumeric: sortFn_alphanumeric, basic: sortFn_basic, datetime: sortFn_datetime, text: sortFn_text },
  filterFns: { includesString: filterFn_includesString, dateBetween, sameValue },
});
export type Features = typeof tableFeatureSet;

// ---------------------------------------------------------------------------
// Filter definitions passed in by each page

export type TableFilter =
  /** Dropdown of the values present in the column, with counts. */
  | { type: "select"; column: string; label: string; format?: (value: string) => string; icon?: React.ReactNode }
  /** Date range with presets (today, 7/30/90 days, this month) or custom from/to. */
  | { type: "date"; column: string; label: string };

const PAGE_SIZES = [10, 20, 50, 100];

/** Rounded "pill" look for the toolbar controls. */
const pill = "h-11 rounded-xl border-[#ECE7F4] bg-white text-sm font-medium shadow-[0_1px_2px_rgba(20,18,43,0.04)] hover:border-[#DCD3EC]";

const DATE_PRESETS = [
  { id: "", label: "Any time" },
  { id: "today", label: "Today" },
  { id: "7d", label: "Last 7 days" },
  { id: "30d", label: "Last 30 days" },
  { id: "90d", label: "Last 90 days" },
  { id: "month", label: "This month" },
  { id: "custom", label: "Custom range…" },
] as const;
type Preset = (typeof DATE_PRESETS)[number]["id"];

function presetRange(p: Preset): DateRange {
  const now = new Date();
  const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime();
  const day = 86_400_000;
  switch (p) {
    case "today": return [startOfToday, null];
    case "7d": return [startOfToday - 6 * day, null];
    case "30d": return [startOfToday - 29 * day, null];
    case "90d": return [startOfToday - 89 * day, null];
    case "month": return [new Date(now.getFullYear(), now.getMonth(), 1).getTime(), null];
    default: return [null, null];
  }
}

/** "2026-09-23" in local time -> epoch ms at the start (or end) of that day. */
const dayStart = (s: string) => (s ? new Date(`${s}T00:00:00`).getTime() : null);
const dayEnd = (s: string) => (s ? new Date(`${s}T23:59:59.999`).getTime() : null);

// ---------------------------------------------------------------------------

export function DataTable<T extends RowData>({
  columns,
  data,
  empty = "Nothing here yet",
  pageSize = 20,
  filters = [],
  search = true,
  searchPlaceholder = "Search…",
  exportName,
  onRowClick,
  toolbar,
  rowNumbers = false,
  emptyState,
}: {
  columns: ColumnDef<Features, T, any>[]; // eslint-disable-line @typescript-eslint/no-explicit-any
  data: T[];
  empty?: string;
  pageSize?: number;
  /** Column filters shown in the toolbar. */
  filters?: TableFilter[];
  /** Free-text search across all text columns. */
  search?: boolean;
  searchPlaceholder?: string;
  /** Adds an "Export CSV" button; the file is named `<exportName>-<date>.csv`. */
  exportName?: string;
  /** Makes rows clickable (e.g. open a detail page). */
  onRowClick?: (row: T) => void;
  /** Extra controls placed at the end of the toolbar. */
  toolbar?: React.ReactNode;
  /** Adds a leading "#" column numbering the rows across pages. */
  rowNumbers?: boolean;
  /** Icon + title + hint shown instead of `empty` when there is no data at all. */
  emptyState?: { icon: React.ReactNode; title: string; hint?: string };
}) {
  // Attach the right filter function to every filterable column.
  const cols = useMemo(() => {
    const byColumn = new Map(filters.map((f) => [f.column, f.type]));
    return columns.map((c) => {
      const id = (c as { id?: string; accessorKey?: string }).id ?? (c as { accessorKey?: string }).accessorKey;
      const type = id ? byColumn.get(id) : undefined;
      return type ? { ...c, filterFn: type === "date" ? "dateBetween" : "sameValue" } as typeof c : c;
    });
  }, [columns, filters]);

  const table = useTable({
    features: tableFeatureSet,
    columns: cols,
    data,
    globalFilterFn: "includesString",
    initialState: { pagination: { pageIndex: 0, pageSize }, globalFilter: "", columnFilters: [] },
  });

  const { pageIndex, pageSize: size } = table.state.pagination;
  const rows = table.getRowModel().rows;
  const filteredCount = table.getFilteredRowModel().rows.length;
  const pages = Math.max(1, table.getPageCount());
  const filtering = !!table.state.globalFilter || table.state.columnFilters.length > 0;
  const [datePresets, setDatePresets] = useState<Record<string, Preset>>({});
  const [customDates, setCustomDates] = useState<Record<string, { from: string; to: string }>>({});

  function resetAll() {
    table.setGlobalFilter("");
    table.resetColumnFilters(true);
    setDatePresets({});
    setCustomDates({});
  }

  function exportCsv() {
    const leaf = table.getAllLeafColumns().filter((c) => c.accessorFn);
    const head = leaf.map((c) => (typeof c.columnDef.header === "string" ? c.columnDef.header : c.id));
    const cell = (v: unknown) => {
      const s = v == null ? "" : typeof v === "object" ? JSON.stringify(v) : String(v);
      return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
    };
    const lines = [head.map(cell).join(","),
      ...table.getSortedRowModel().rows.map((r) => leaf.map((c) => cell(r.getValue(c.id))).join(","))];
    // Leading BOM so Excel opens the file as UTF-8 (₹ and Indic names).
    const url = URL.createObjectURL(new Blob([String.fromCharCode(0xfeff), lines.join("\n")], { type: "text/csv;charset=utf-8" }));
    const a = Object.assign(document.createElement("a"), { href: url, download: `${exportName}-${new Date().toISOString().slice(0, 10)}.csv` });
    a.click();
    URL.revokeObjectURL(url);
  }

  const showToolbar = search || filters.length > 0 || !!exportName || !!toolbar;
  const first = filteredCount === 0 ? 0 : pageIndex * size + 1;
  const last = Math.min(filteredCount, (pageIndex + 1) * size);

  return (
    <div className="space-y-3">
      {showToolbar && (
        <div className="flex flex-wrap items-center gap-3 rounded-2xl border border-[#EFEAF6] bg-white/90 p-3 shadow-[0_12px_32px_-22px_rgba(109,40,217,0.25)] backdrop-blur">
          {search && (
            <div className="relative min-w-48 flex-1 sm:max-w-sm">
              <Search className="pointer-events-none absolute left-3.5 top-3.5 size-4 text-pink-500" />
              <Input className={cn(pill, "pl-10 pr-9")} placeholder={searchPlaceholder} aria-label="Search"
                value={(table.state.globalFilter as string) ?? ""} onChange={(e) => table.setGlobalFilter(e.target.value)} />
              {!!table.state.globalFilter && (
                <button type="button" aria-label="Clear search" onClick={() => table.setGlobalFilter("")}
                  className="absolute right-3 top-3.5 grid size-4 place-items-center rounded-full bg-muted-foreground/40 text-white hover:bg-muted-foreground/60">
                  <X className="size-3" />
                </button>
              )}
            </div>
          )}

          {filters.map((f) => {
            const column = table.getColumn(f.column);
            if (!column) return null;
            if (f.type === "select") {
              const values = [...column.getFacetedUniqueValues().entries()]
                .map(([v, n]) => [String(v ?? ""), n] as const)
                .sort(([a], [b]) => a.localeCompare(b));
              return (
                <Dropdown key={f.column} ariaLabel={f.label} icon={f.icon} highlightActive className="w-auto min-w-40"
                  value={(column.getFilterValue() as string) ?? ""} onValueChange={(v) => column.setFilterValue(v || undefined)}
                  options={[
                    { value: "", label: `All ${f.label === f.label.toUpperCase() ? f.label : f.label.toLowerCase()}`, count: column.getFacetedRowModel().rows.length },
                    // Rows with no value can't be picked (the empty string means "All").
                    ...values.filter(([v]) => v !== "").map(([v, n]) => ({ value: v, label: f.format ? f.format(v) : v, count: n })),
                  ]} />
              );
            }
            const preset = datePresets[f.column] ?? "";
            const custom = customDates[f.column] ?? { from: "", to: "" };
            const setCustom = (next: { from: string; to: string }) => {
              setCustomDates((s) => ({ ...s, [f.column]: next }));
              column.setFilterValue([dayStart(next.from), dayEnd(next.to)] satisfies DateRange);
            };
            return (
              <div key={f.column} className="flex flex-wrap items-center gap-2">
                <Dropdown ariaLabel={`${f.label} range`} icon={<CalendarRange />} highlightActive className="w-auto min-w-48"
                  value={preset}
                  onValueChange={(v) => {
                    const p = v as Preset;
                    setDatePresets((s) => ({ ...s, [f.column]: p }));
                    if (p === "custom") setCustom(custom);
                    else column.setFilterValue(p ? presetRange(p) : undefined);
                  }}
                  renderValue={(v) => `${f.label}: ${(DATE_PRESETS.find((p) => p.id === v)?.label ?? "Any time").toLowerCase().replace("…", "")}`}
                  options={DATE_PRESETS.map((p) => ({ value: p.id, label: p.label, separator: p.id === "custom" }))} />
                {preset === "custom" && (
                  <span className="flex items-center gap-1.5 text-sm text-muted-foreground">
                    <Input type="date" className={cn(pill, "w-auto")} aria-label={`${f.label} from`} value={custom.from} max={custom.to || undefined}
                      onChange={(e) => setCustom({ ...custom, from: e.target.value })} />
                    to
                    <Input type="date" className={cn(pill, "w-auto")} aria-label={`${f.label} to`} value={custom.to} min={custom.from || undefined}
                      onChange={(e) => setCustom({ ...custom, to: e.target.value })} />
                  </span>
                )}
              </div>
            );
          })}

          {filtering && (
            <Button variant="ghost" size="sm" onClick={resetAll} className="text-muted-foreground">
              <X /> Reset
            </Button>
          )}
          <div className="ml-auto flex items-center gap-2">
            {toolbar}
            {exportName && (
              <button type="button" onClick={exportCsv} disabled={filteredCount === 0}
                className="inline-flex h-11 items-center gap-2 rounded-xl bg-[linear-gradient(90deg,#EC4899,#DB2777)] px-5 text-sm font-semibold text-white shadow-[0_10px_24px_-10px_rgba(219,39,119,0.8)] transition hover:brightness-110 disabled:opacity-50">
                <Download className="size-4" /> Export CSV
              </button>
            )}
          </div>
        </div>
      )}

      <div className="overflow-hidden rounded-2xl border border-[#EFEAF6] bg-white/95 shadow-[0_12px_32px_-22px_rgba(109,40,217,0.25)]">
      <div className="overflow-x-auto">
        <Table>
          <TableHeader>
            {table.getHeaderGroups().map((group) => (
              <TableRow key={group.id} className="border-[#F1EEF7] bg-[#FAF8FD] hover:bg-[#FAF8FD]">
                {rowNumbers && <TableHead className="h-12 w-12 pl-5 text-[13px] font-semibold text-foreground/80">#</TableHead>}
                {group.headers.map((header) => {
                  const sorted = header.column.getIsSorted();
                  const canSort = header.column.getCanSort();
                  return (
                    <TableHead key={header.id} className="h-12 text-[13px] font-semibold text-foreground/80">
                      {header.isPlaceholder ? null : canSort ? (
                        <button type="button" onClick={header.column.getToggleSortingHandler()}
                          className="inline-flex items-center gap-1 hover:text-foreground">
                          <FlexRender header={header} />
                          {sorted === "asc" ? <ArrowUp className="size-3" /> : sorted === "desc"
                            ? <ArrowDown className="size-3" /> : <ArrowUpDown className="size-3 opacity-40" />}
                        </button>
                      ) : <FlexRender header={header} />}
                    </TableHead>
                  );
                })}
              </TableRow>
            ))}
          </TableHeader>
          <TableBody>
            {rows.length === 0 ? (
              <TableRow>
                <TableCell colSpan={cols.length + (rowNumbers ? 1 : 0)} className="h-28 text-center text-muted-foreground">
                  {filtering && data.length > 0 ? (
                    <span>No rows match these filters. <button type="button" className="font-medium text-primary underline-offset-4 hover:underline" onClick={resetAll}>Reset filters</button></span>
                  ) : emptyState ? (
                    <span className="flex flex-col items-center gap-1.5 py-6">
                      <span className="mb-1 grid size-12 place-items-center rounded-full bg-[#F4EEFB] text-violet-500 [&_svg]:size-5">{emptyState.icon}</span>
                      <b className="text-sm text-foreground">{emptyState.title}</b>
                      {emptyState.hint && <span className="text-xs">{emptyState.hint}</span>}
                    </span>
                  ) : empty}
                </TableCell>
              </TableRow>
            ) : rows.map((row, i) => (
              <motion.tr key={row.id} initial={{ opacity: 0, y: 4 }} animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.18, delay: Math.min(i, 12) * 0.015 }}
                onClick={onRowClick ? (e) => {
                  // Buttons and links inside the row keep their own behaviour.
                  if ((e.target as HTMLElement).closest("button, a, input, select, textarea, [role=button]")) return;
                  onRowClick(row.original);
                } : undefined}
                className={cn("border-b border-[#F1EEF7] transition-colors hover:bg-[#FBF9FE]", onRowClick && "cursor-pointer")}>
                {rowNumbers && <TableCell className="py-3.5 pl-5 text-sm text-muted-foreground">{pageIndex * size + i + 1}</TableCell>}
                {row.getAllCells().map((cell) => (
                  <TableCell key={cell.id} className="py-3.5"><FlexRender cell={cell} /></TableCell>
                ))}
              </motion.tr>
            ))}
          </TableBody>
        </Table>
      </div>

      <div className="flex flex-wrap items-center justify-between gap-3 px-5 py-4 text-sm text-muted-foreground">
        <div className="flex items-center gap-2">
          <span>Rows per page</span>
          <Dropdown ariaLabel="Rows per page" size="sm" className="w-20" value={String(size)}
            onValueChange={(v) => table.setPageSize(Number(v))}
            options={PAGE_SIZES.map((n) => ({ value: String(n), label: String(n) }))} />
          <span className="ml-2">
            {first}–{last} of {filteredCount}
            {filteredCount !== data.length && <span className="text-muted-foreground/70"> (filtered from {data.length})</span>}
          </span>
        </div>
        <nav className="flex items-center gap-1" aria-label="Pagination">
          <Button variant="outline" size="icon-sm" className="rounded-full" onClick={() => table.setPageIndex(0)} disabled={!table.getCanPreviousPage()} aria-label="First page">
            <ChevronsLeft />
          </Button>
          <Button variant="outline" size="icon-sm" className="rounded-full" onClick={() => table.previousPage()} disabled={!table.getCanPreviousPage()} aria-label="Previous page">
            <ChevronLeft />
          </Button>
          {pageWindow(pageIndex, pages).map((p, i) => p === null
            ? <span key={`gap-${i}`} className="px-1">…</span>
            : (
              <Button key={p} size="icon-sm" variant={p === pageIndex ? "default" : "ghost"} onClick={() => table.setPageIndex(p)}
                className={cn("rounded-full", p === pageIndex && "bg-[linear-gradient(135deg,#EC4899,#DB2777)] text-white shadow-[0_6px_14px_-6px_rgba(219,39,119,0.8)]")}
                aria-label={`Page ${p + 1}`} aria-current={p === pageIndex ? "page" : undefined}>
                {p + 1}
              </Button>
            ))}
          <Button variant="outline" size="icon-sm" className="rounded-full" onClick={() => table.nextPage()} disabled={!table.getCanNextPage()} aria-label="Next page">
            <ChevronRight />
          </Button>
          <Button variant="outline" size="icon-sm" className="rounded-full" onClick={() => table.setPageIndex(pages - 1)} disabled={!table.getCanNextPage()} aria-label="Last page">
            <ChevronsRight />
          </Button>
        </nav>
      </div>
      </div>
    </div>
  );
}

/** Page numbers to show: first, last, and two either side of the current page, with gaps as null. */
function pageWindow(current: number, total: number): (number | null)[] {
  const keep = new Set([0, total - 1, current - 2, current - 1, current, current + 1, current + 2]);
  const out: (number | null)[] = [];
  for (let p = 0; p < total; p++) {
    if (!keep.has(p)) continue;
    if (out.length && (out[out.length - 1] as number) < p - 1) out.push(null);
    out.push(p);
  }
  return out;
}
