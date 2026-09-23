import { describe, expect, it } from "vitest";
import { checkMessage } from "./chat-filter.js";

describe("chat safety filter", () => {
  it.each([
    ["call me at 9876543210", "phone_number"],
    ["my no is +91 98765 43210", "phone_number"],
    ["9 8 7 6 5 4 3 2 1 0", "phone_number"],
    ["98765-432-10", "phone_number"],
    ["nine eight seven six five four three two one zero", "phone_number"],
    ["pay to karthik@oksbi", "upi_id"],
    ["priya.s@ybl", "upi_id"],
    ["send money on gpay", "payment_request"],
    ["can you phonepe me 100", "payment_request"],
    ["my bank account details", "payment_request"],
    ["add me on whatsapp", "contact_app"],
    ["follow my insta", "contact_app"],
    ["message me on Telegram", "contact_app"],
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
  ])("lets ordinary chat through: %j", (text) => {
    expect(checkMessage(text)).toBeNull();
  });
});
