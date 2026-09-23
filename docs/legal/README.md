# Legal pages

Source for the public policy pages. The API serves them as HTML at `/legal/<page>`
and as blocks the app renders at `/v1/legal/<page>` (see `services/api/src/legal/`).

| File | Public URL | Used for |
|---|---|---|
| `terms.md` | `/legal/terms` | Terms of Use (sign-up screen, Profile → Legal) |
| `privacy.md` | `/legal/privacy` | Privacy Policy — **Play Console "Privacy policy" URL** |
| `community.md` | `/legal/community` | Community Guidelines (Play UGC policy) |
| `grievance.md` | `/legal/grievance` | Grievance Officer (IT Rules 2021) |
| `delete-account.md` | `/legal/delete-account` | **Play Console "Delete account" URL** |

**Status: draft.** Have a lawyer review them before launch.

## Company details
Placeholders like `{{COMPANY_NAME}}` are filled from the API's environment. Until
every one is set, the pages show a "Draft" banner and highlight what's missing.

```
LEGAL_COMPANY_NAME=
LEGAL_COMPANY_ADDRESS=
LEGAL_SUPPORT_EMAIL=
LEGAL_GRIEVANCE_OFFICER_NAME=
LEGAL_GRIEVANCE_EMAIL=
LEGAL_JURISDICTION_CITY=
LEGAL_EFFECTIVE_DATE=
```

`{{APP_NAME}}` and `{{REFUND_WINDOW_DAYS}}` (admin setting `refund.window_days`) are filled automatically.

## Keep them true
The retention periods in `privacy.md` §4 are enforced by `services/api/src/retention.ts`
(hourly, in the worker). Change both together. Supported Markdown: `#`/`##`, paragraphs,
`-`/`1.` lists, tables, `**bold**`, `_italic_`, `[link](page-id)`.
