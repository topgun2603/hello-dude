/**
 * Chat safety filter (CLAUDE.md: block phone numbers, UPI IDs and payment
 * requests). Deliberately strict: a blocked message is never delivered and the
 * sender is told why, so they can rephrase. Each block is a strike (routes/chat.ts).
 *
 * Tricks it sees through (owner, 2026-09-24): digits in Indian scripts, emoji and
 * look-alike letters ("98O6l"), number words in the launch languages ("onbadhu
 * ettu", "nau aath"), spacing/punctuation between digits, and a number split over
 * several messages (checkSplit).
 */
export type BlockReason = "phone_number" | "upi_id" | "payment_request" | "contact_app";

/** Zero digit of each script whose 0–9 are consecutive code points. */
const DIGIT_ZEROS = [
  0x0966, 0x09e6, 0x0a66, 0x0ae6, 0x0b66, 0x0be6, 0x0c66, 0x0ce6, 0x0d66, // Devanagari … Malayalam
  0xff10, // fullwidth
  0x1d7ce, 0x1d7d8, 0x1d7e2, 0x1d7ec, 0x1d7f6, // mathematical bold / double-struck / sans / mono
];

/** Any digit-like character → ASCII digit (or the character unchanged). */
function asciiDigit(ch: string): string {
  const cp = ch.codePointAt(0)!;
  for (const zero of DIGIT_ZEROS) if (cp >= zero && cp <= zero + 9) return String(cp - zero);
  if (cp >= 0x2460 && cp <= 0x2468) return String(cp - 0x2460 + 1); // ①–⑨
  if (cp >= 0x2776 && cp <= 0x277e) return String(cp - 0x2776 + 1); // ❶–❾
  if (cp === 0x24ea || cp === 0x24ff) return "0"; // ⓪ ⓿
  const sup = "⁰¹²³⁴⁵⁶⁷⁸⁹".indexOf(ch);
  if (sup >= 0) return String(sup);
  const sub = "₀₁₂₃₄₅₆₇₈₉".indexOf(ch);
  if (sub >= 0) return String(sub);
  return ch;
}

/** Number words in the launch languages (romanised, plus Tamil and Hindi script) → digit. */
const NUMBER_WORDS: Record<string, string> = {};
const add = (digit: number, words: string) => { for (const w of words.split(" ")) NUMBER_WORDS[w] = String(digit); };
add(0, "zero oh nil poojiyam pujjiyam poojyam pujyam sunna sunnaa sonne shunya shoonya shunyo shunno பூஜ்யம் பூஜ்ஜியம் शून्य");
add(1, "one onnu ondru onru ondu okati ek ekk ஒன்று ஒண்ணு एक");
add(2, "two rendu irandu randu eradu dui don do doh இரண்டு ரெண்டு दो");
add(3, "three moonu moondru munu moodu mooru moonnu teen tin மூன்று மூணு तीन");
add(4, "four naalu naangu nalu naalugu naalku char chaar நான்கு நாலு चार");
add(5, "five anju ainthu ainju aidu anchu paanch panch pach paach அஞ்சு ஐந்து पांच पाँच");
add(6, "six aaru aru chhe chhah chah cheh chhoy saha ஆறு छह छः");
add(7, "seven ezhu ezu yezhu edu elu yelu saat saath ஏழு सात");
add(8, "eight ettu yettu enimidi entu aath aat atth எட்டு आठ");
add(9, "nine onbadhu onbathu ombodhu ombathu ombattu tommidi nau nav noy ஒன்பது नौ");
const NUMBER_WORD_RE = new RegExp(
  `(?<![\\p{L}\\p{M}])(${Object.keys(NUMBER_WORDS).sort((a, b) => b.length - a.length).join("|")})(?![\\p{L}\\p{M}])`, "giu");

/**
 * Text → digit runs, after undoing the tricks: script/emoji digits, number words,
 * look-alike letters next to digits, and separators between digits.
 */
export function digitRuns(text: string): string[] {
  // Up to 5 non-letter characters between digits are padding: "98 76-54" → "987654".
  return (normalise(text).replace(/(?<=\d)[^\p{L}\p{M}\d]{1,5}(?=\d)/gu, "").match(/\d+/g) ?? []);
}

/** Undoes the tricks, leaving separators in place. */
function normalise(text: string): string {
  let t = Array.from(text.normalize("NFKC"), asciiDigit).join("")
    .replace(/[\u{FE0F}\u{20E3}]/gu, "") // keycap emoji: 9️⃣ → 9
    .toLowerCase()
    .replace(NUMBER_WORD_RE, (w) => ` ${NUMBER_WORDS[w.toLowerCase()]} `);
  // Look-alikes only where they touch a digit: "98o6l2" → "980612". Twice for "ol" pairs.
  for (let i = 0; i < 2; i++) {
    t = t.replace(/(?<=\d)[o]|[o](?=\d)/g, "0").replace(/(?<=\d)[li|!]|[li|!](?=\d)/g, "1");
  }
  return t;
}

const UPI = /\b[a-z0-9.\-_]{2,}@(ok[a-z]+|ybl|ibl|axl|upi|paytm|apl|yapl|fbl|jupiteraxis|ptyes|ptsbi|ptaxis|pthdfc|sbi|icici|hdfcbank|axisbank|kotak|freecharge|airtel|jio)\b/i;
const PAYMENT = /\b(g\s*pay|google\s*pay|phone\s*pe|paytm|bhim|upi|send (me )?money|transfer (me )?money|pay me|recharge (my|me)|bank (account|details)|account number|ifsc|qr code)\b/i;
const CONTACT_APPS = /\b(whats\s*app|wa\.me|insta(gram)?|telegram|snap\s*chat|facebook|fb id|signal app|my number|your number|call me on|dm me|my no\b|ur no\b|your no\b|contact number|mobile number|phone number)\b/i;

export function checkMessage(text: string): BlockReason | null {
  if (digitRuns(text).some((run) => run.length >= 8)) return "phone_number";
  if (UPI.test(text)) return "upi_id";
  if (PAYMENT.test(text)) return "payment_request";
  if (CONTACT_APPS.test(text)) return "contact_app";
  return null;
}

/** Digits of a message that is mostly a number (e.g. "98765", "nine 8 7"), else "". */
export function numberPart(text: string): string {
  const digits = digitRuns(text).join("");
  // Letters left once number words became digits.
  const letters = (normalise(text).match(/\p{L}/gu) ?? []).length;
  const words = digitRuns(text).length;
  // "98765" or "9 8 7 6" or "nine eight" count; "I'm 25 and free at 9" doesn't.
  return digits.length >= 2 && (letters <= 4 || digits.length * 3 >= letters + words) ? digits : "";
}

/**
 * A phone number sent in pieces: the sender's recent number-like messages (oldest
 * first) plus this one add up to 8+ digits.
 */
export function checkSplit(recent: string[], text: string): BlockReason | null {
  const now = numberPart(text);
  if (!now) return null;
  const total = recent.map(numberPart).join("") + now;
  return total.length >= 8 ? "phone_number" : null;
}

export const BLOCK_MESSAGES: Record<BlockReason, string> = {
  phone_number: "Phone numbers can't be shared in chat. Keep talking here in Hello Dude!.",
  upi_id: "UPI IDs can't be shared in chat. All payments stay inside the app.",
  payment_request: "Asking for or offering payments outside the app isn't allowed.",
  contact_app: "Moving the chat to other apps or sharing contact details isn't allowed. Keep talking here.",
};
