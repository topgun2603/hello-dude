"use client";

import { Select as SelectPrimitive } from "@base-ui/react/select";
import { Check, ChevronDown } from "lucide-react";
import { cn } from "@/lib/utils";

export interface DropdownOption {
  value: string;
  label: string;
  /** Small count badge on the right (e.g. how many rows have this value). */
  count?: number;
  /** Leading icon or dot shown in the list. */
  icon?: React.ReactNode;
  /** A thin line above this option (e.g. before "Custom range…"). */
  separator?: boolean;
}

// Base UI treats "" as "no value", so the "All …" option uses a sentinel internally.
const EMPTY = "__all__";
const toInner = (v: string) => (v === "" ? EMPTY : v);
const toOuter = (v: string) => (v === EMPTY ? "" : v);

/**
 * shadcn / Base UI select styled for the panel: rounded pill trigger with an
 * optional icon, pink tint while a filter is applied, animated popup with check
 * marks and count badges. `value` "" is a normal option (use it for "All …").
 */
export function Dropdown({
  value, onValueChange, options, icon, id, ariaLabel, className, size = "md", highlightActive = false, disabled, renderValue,
}: {
  value: string;
  onValueChange: (value: string) => void;
  options: DropdownOption[];
  icon?: React.ReactNode;
  id?: string;
  ariaLabel?: string;
  className?: string;
  size?: "sm" | "md" | "lg";
  /** Tint the trigger pink whenever the value isn't "" (for filters). */
  highlightActive?: boolean;
  disabled?: boolean;
  /** Custom text in the closed trigger (the list still shows each option's label). */
  renderValue?: (value: string) => React.ReactNode;
}) {
  const active = highlightActive && value !== "";
  return (
    <SelectPrimitive.Root
      value={toInner(value)}
      onValueChange={(v) => onValueChange(toOuter(String(v ?? "")))}
      items={options.map((o) => ({ value: toInner(o.value), label: o.label }))}
      disabled={disabled}
    >
      <SelectPrimitive.Trigger
        id={id}
        aria-label={ariaLabel}
        className={cn(
          "group inline-flex w-full items-center gap-2 rounded-xl border bg-white text-left font-medium outline-none transition-all",
          "border-[#ECE7F4] text-foreground shadow-[0_1px_2px_rgba(20,18,43,0.04)] hover:border-[#DCD3EC] hover:shadow-[0_4px_14px_-8px_rgba(109,40,217,0.35)]",
          "focus-visible:border-pink-300 focus-visible:ring-3 focus-visible:ring-pink-200/60 data-popup-open:border-pink-300 data-popup-open:ring-3 data-popup-open:ring-pink-200/60",
          "disabled:cursor-not-allowed disabled:opacity-60",
          size === "sm" && "h-9 px-3 text-sm", size === "md" && "h-11 px-3.5 text-sm", size === "lg" && "h-12 px-4 text-[15px]",
          active && "border-pink-300 bg-pink-50/80 text-pink-700 hover:border-pink-400",
          className,
        )}
      >
        {icon && <span className={cn("flex shrink-0 [&_svg]:size-4", active ? "text-pink-600" : "text-muted-foreground")}>{icon}</span>}
        <SelectPrimitive.Value className="min-w-0 flex-1 truncate">
          {renderValue ? (v: string) => renderValue(toOuter(v)) : undefined}
        </SelectPrimitive.Value>
        <ChevronDown className={cn("size-4 shrink-0 transition-transform duration-200 group-data-popup-open:rotate-180",
          active ? "text-pink-500" : "text-muted-foreground")} />
      </SelectPrimitive.Trigger>

      <SelectPrimitive.Portal>
        <SelectPrimitive.Positioner side="bottom" align="start" sideOffset={6} alignItemWithTrigger={false} className="z-50 outline-none">
          <SelectPrimitive.Popup
            className={cn(
              "max-h-(--available-height) min-w-(--anchor-width) origin-(--transform-origin) overflow-y-auto rounded-2xl border border-[#EFEAF6] bg-white p-1.5",
              "shadow-[0_18px_40px_-16px_rgba(76,29,149,0.35)] outline-none",
              "transition-[opacity,transform] duration-150 data-ending-style:scale-95 data-ending-style:opacity-0 data-starting-style:scale-95 data-starting-style:opacity-0",
            )}
          >
            <SelectPrimitive.List>
              {options.map((o) => (
                <div key={o.value}>
                  {o.separator && <div className="-mx-1.5 my-1.5 h-px bg-[#F1EEF7]" />}
                  <SelectPrimitive.Item
                    value={toInner(o.value)}
                    className={cn(
                      "group/item relative flex cursor-pointer select-none items-center gap-2.5 rounded-xl py-2 pl-3 pr-9 text-sm text-foreground/85 outline-none transition-colors",
                      "data-highlighted:bg-[#FBF5FD] data-highlighted:text-foreground data-selected:font-semibold data-selected:text-pink-700",
                    )}
                  >
                    {o.icon && <span className="flex shrink-0 text-muted-foreground group-data-selected/item:text-pink-600 [&_svg]:size-4">{o.icon}</span>}
                    <SelectPrimitive.ItemText className="flex-1 whitespace-nowrap">{o.label}</SelectPrimitive.ItemText>
                    {o.count !== undefined && (
                      <span className="rounded-full bg-[#F4F0FA] px-2 py-0.5 text-[11px] font-semibold tabular-nums text-muted-foreground group-data-selected/item:bg-pink-100 group-data-selected/item:text-pink-700">
                        {o.count}
                      </span>
                    )}
                    <SelectPrimitive.ItemIndicator className="absolute right-3 flex text-pink-600">
                      <Check className="size-4" strokeWidth={2.5} />
                    </SelectPrimitive.ItemIndicator>
                  </SelectPrimitive.Item>
                </div>
              ))}
            </SelectPrimitive.List>
          </SelectPrimitive.Popup>
        </SelectPrimitive.Positioner>
      </SelectPrimitive.Portal>
    </SelectPrimitive.Root>
  );
}
