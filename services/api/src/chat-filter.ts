/**
 * Chat safety filter (CLAUDE.md: block phone numbers, UPI IDs and payment
 * requests). Deliberately strict: a blocked message is never delivered and the
 * sender is told why, so they can rephrase.
 */
export type BlockReason = "phone_number" | "upi_id" | "payment_request" | "contact_app";

const DIGIT_WORDS: Record<string, string> = {
  zero: "0", one: "1", two: "2", three: "3", four: "4", five: "5", six: "6", seven: "7", eight: "8", nine: "9",
};

/** Collapses tricks like "9 8 7 6-5 4.3 2 1 0" or "nine eight seven…" into digit runs. */
function digitRuns(text: string): string[] {
  const words = text.toLowerCase().replace(/\b(zero|one|two|three|four|five|six|seven|eight|nine)\b/g, (w) => DIGIT_WORDS[w]!);
  return words.replace(/(?<=\d)[\s.\-_/()]+(?=\d)/g, "").match(/\d+/g) ?? [];
}

const UPI = /\b[a-z0-9.\-_]{2,}@(ok[a-z]+|ybl|ibl|axl|upi|paytm|apl|yapl|fbl|jupiteraxis|ptyes|ptsbi|ptaxis|pthdfc|sbi|icici|hdfcbank|axisbank|kotak|freecharge|airtel|jio)\b/i;
const PAYMENT = /\b(g\s*pay|google\s*pay|phone\s*pe|paytm|bhim|upi|send (me )?money|transfer (me )?money|pay me|recharge (my|me)|bank (account|details)|account number|ifsc|qr code)\b/i;
const CONTACT_APPS = /\b(whats\s*app|wa\.me|insta(gram)?|telegram|snap\s*chat|facebook|fb id|signal app|my number|your number|call me on|dm me)\b/i;

export function checkMessage(text: string): BlockReason | null {
  if (digitRuns(text).some((run) => run.length >= 8)) return "phone_number";
  if (UPI.test(text)) return "upi_id";
  if (PAYMENT.test(text)) return "payment_request";
  if (CONTACT_APPS.test(text)) return "contact_app";
  return null;
}

export const BLOCK_MESSAGES: Record<BlockReason, string> = {
  phone_number: "Phone numbers can't be shared in chat. Keep talking here in Hello Dude!.",
  upi_id: "UPI IDs can't be shared in chat. All payments stay inside the app.",
  payment_request: "Asking for or offering payments outside the app isn't allowed.",
  contact_app: "Moving the chat to other apps isn't allowed. Keep talking here.",
};
