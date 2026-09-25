const inr = new Intl.NumberFormat("en-IN", { style: "currency", currency: "INR", maximumFractionDigits: 2 });
const num = new Intl.NumberFormat("en-IN");

/** 30000 paise -> "₹300" (drops .00). */
export const rupees = (paise: number) => inr.format(paise / 100).replace(/\.00$/, "");
export const count = (n: number) => num.format(n);

export const LANGUAGES: Record<string, string> = {
  ta: "Tamil", te: "Telugu", kn: "Kannada", ml: "Malayalam", hi: "Hindi", bn: "Bengali", mr: "Marathi", en: "English",
};
export const languageName = (code: string) => LANGUAGES[code] ?? code;

export const REPORT_REASONS: Record<string, string> = {
  abuse: "Abusive or rude", sexual_content: "Sexual content", spam: "Spam or selling", fraud: "Asked for money / UPI",
  underage: "Seems under 18", off_platform: "Shared number / pay outside app", other: "Something else",
};

export const dateTime = (iso: string) =>
  new Date(iso).toLocaleString("en-IN", { day: "numeric", month: "short", hour: "numeric", minute: "2-digit", timeZone: "Asia/Kolkata" });

export const date = (iso: string) =>
  new Date(iso).toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric", timeZone: "Asia/Kolkata" });
