/**
 * Indian mobile numbers only at launch. Accepts "9876543210", "09876543210",
 * "+91 98765 43210" etc. and returns E.164 ("+919876543210"), or null.
 */
export function normalizeIndianMobile(input: string): string | null {
  const digits = input.replace(/[\s\-()]/g, "");
  const m = /^(?:\+?91|0)?([6-9]\d{9})$/.exec(digits);
  return m ? `+91${m[1]}` : null;
}

/** "+919876543210" -> "+91 ••••••3210". Use this whenever a phone number is logged or shown. */
export function maskPhone(e164: string): string {
  return `${e164.slice(0, 3)} ••••••${e164.slice(-4)}`;
}
