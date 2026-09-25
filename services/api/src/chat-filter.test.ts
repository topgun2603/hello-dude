import { describe, expect, it } from "vitest";
import { checkMessage, checkSplit } from "./chat-filter.js";

describe("chat safety filter", () => {
  it.each([
    ["call me at 9876543210", "phone_number"],
    ["my no is +91 98765 43210", "phone_number"],
    ["9 8 7 6 5 4 3 2 1 0", "phone_number"],
    ["98765-432-10", "phone_number"],
    ["nine eight seven six five four three two one zero", "phone_number"],
    // Tricks (owner, 2026-09-24)
    ["௯௮௭௬௫௪௩௨௧௦", "phone_number"], // Tamil digits
    ["९८७६५४३२१०", "phone_number"], // Devanagari digits
    ["9️⃣8️⃣7️⃣6️⃣5️⃣4️⃣3️⃣2️⃣1️⃣0️⃣", "phone_number"], // keycap emoji
    ["98O6l2345O", "phone_number"], // look-alike letters
    ["onbadhu ettu ezhu aaru anju naalu moonu rendu onnu poojiyam", "phone_number"], // Tamil words
    ["nau aath saat chhe paanch char teen do ek shunya", "phone_number"], // Hindi words
    ["ஒன்பது எட்டு ஏழு ஆறு அஞ்சு நாலு மூணு ரெண்டு ஒண்ணு பூஜ்யம்", "phone_number"], // Tamil script words
    ["9, 8, 7, 6, 5 * 4 * 3 * 2 * 1 * 0", "phone_number"],
    ["pay to karthik@oksbi", "upi_id"],
    ["priya.s@ybl", "upi_id"],
    ["send money on gpay", "payment_request"],
    ["can you phonepe me 100", "payment_request"],
    ["my bank account details", "payment_request"],
    ["add me on whatsapp", "contact_app"],
    ["follow my insta", "contact_app"],
    ["message me on Telegram", "contact_app"],
    ["send your mobile number", "contact_app"],
  ])("blocks %j (%s)", (text, reason) => {
    expect(checkMessage(text)).toBe(reason);
  });

  it.each([
    "Hi Karthik! Free for a call tonight?",
    "Yes, after 9. Is that okay?",
    "I watched 3 movies in 2024, the best was at 7:30 pm",
    "My email is private, sorry",
    "Anytime! Take care and sleep well",
    "நன்றி, see you at 10",
    "Oh ok, do you want to talk at 8 or 9?",
    "I have 2 sisters and 1 brother, we live in Madurai",
    "Call at 10:30, I'll be free for 20 minutes",
  ])("lets ordinary chat through: %j", (text) => {
    expect(checkMessage(text)).toBeNull();
  });

  it("catches a number sent in pieces over several messages", () => {
    expect(checkSplit(["98765"], "43210")).toBe("phone_number");
    expect(checkSplit(["nine eight seven", "6 5 4"], "3210")).toBe("phone_number");
    // Ordinary messages with a number in them don't add up.
    expect(checkSplit(["I'm 25 years old", "free after 9 tonight"], "see you at 10")).toBeNull();
    expect(checkSplit(["25"], "30")).toBeNull(); // 4 digits
  });
});
