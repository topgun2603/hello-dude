/**
 * The public legal pages (docs/legal/*.md) with the company's details filled
 * in. Anything not configured yet shows as "[… to be filled]" and marks the
 * page as a draft, so an unfinished policy can't go live unnoticed.
 */
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { parse, type Block } from "./markdown.js";

const DIR = fileURLToPath(new URL("../../../../docs/legal/", import.meta.url));

export const LEGAL_PAGES = {
  terms: "Terms of Use",
  privacy: "Privacy Policy",
  community: "Community Guidelines",
  grievance: "Grievance Redressal",
  "delete-account": "Delete your account",
} as const;
export type LegalPageId = keyof typeof LEGAL_PAGES;

/** Company details for the policies (env LEGAL_*). */
export interface LegalInfo {
  companyName?: string;
  companyAddress?: string;
  supportEmail?: string;
  grievanceOfficerName?: string;
  grievanceEmail?: string;
  jurisdictionCity?: string;
  effectiveDate?: string;
}

const LABELS: Record<keyof LegalInfo, string> = {
  companyName: "Company name", companyAddress: "Registered address", supportEmail: "Support email",
  grievanceOfficerName: "Grievance Officer name", grievanceEmail: "Grievance email",
  jurisdictionCity: "Jurisdiction city", effectiveDate: "Effective date",
};

export interface LegalPage { id: LegalPageId; title: string; blocks: Block[]; draft: boolean }

export function legalPage(id: LegalPageId, info: LegalInfo, extra: { appName: string; refundWindowDays: number }): LegalPage {
  const values: Record<string, string> = {
    APP_NAME: extra.appName,
    REFUND_WINDOW_DAYS: String(extra.refundWindowDays),
    COMPANY_NAME: info.companyName ?? "",
    COMPANY_ADDRESS: info.companyAddress ?? "",
    SUPPORT_EMAIL: info.supportEmail ?? "",
    GRIEVANCE_OFFICER_NAME: info.grievanceOfficerName ?? "",
    GRIEVANCE_EMAIL: info.grievanceEmail ?? "",
    JURISDICTION_CITY: info.jurisdictionCity ?? "",
    EFFECTIVE_DATE: info.effectiveDate ?? "",
  };
  const labelFor: Record<string, string> = {
    COMPANY_NAME: LABELS.companyName, COMPANY_ADDRESS: LABELS.companyAddress, SUPPORT_EMAIL: LABELS.supportEmail,
    GRIEVANCE_OFFICER_NAME: LABELS.grievanceOfficerName, GRIEVANCE_EMAIL: LABELS.grievanceEmail,
    JURISDICTION_CITY: LABELS.jurisdictionCity, EFFECTIVE_DATE: LABELS.effectiveDate,
  };
  let draft = false;
  const md = readFileSync(`${DIR}${id}.md`, "utf8").replace(/\{\{([A-Z_]+)\}\}/g, (_, key: string) => {
    const v = values[key];
    if (v) return v;
    draft = true;
    return `[${labelFor[key] ?? key} to be filled]`;
  });
  return { id, title: LEGAL_PAGES[id], blocks: parse(md), draft };
}

export const isLegalPage = (id: string): id is LegalPageId => id in LEGAL_PAGES;
