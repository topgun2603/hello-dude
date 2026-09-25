/**
 * Phone OTP: 6 digits, valid 5 minutes, 5 wrong tries, 30 s between sends and
 * at most 3 sends per number per 10 minutes. Only an HMAC of the code is kept
 * in Redis, and codes are never logged.
 */
import { createHmac, randomInt, timingSafeEqual } from "node:crypto";
import type { Redis } from "ioredis";
import { ApiError } from "../errors.js";
import { maskPhone } from "./phone.js";

export const OTP_TTL_S = 300;
export const OTP_MAX_ATTEMPTS = 5;
export const OTP_RESEND_COOLDOWN_S = 30;
export const OTP_MAX_SENDS = 3;
export const OTP_SEND_WINDOW_S = 600;

export interface OtpSender {
  send(phoneE164: string, code: string): Promise<void>;
}

/** Development: sends nothing; every number's code is `fixedCode`. */
export function devOtpSender(log: (msg: string) => void): OtpSender {
  return {
    async send(phone) {
      log(`dev OTP requested for ${maskPhone(phone)} (use DEV_OTP_CODE)`);
    },
  };
}

/** MSG91 OTP API with a DLT-registered template. */
export function msg91OtpSender(authKey: string, templateId: string): OtpSender {
  return {
    async send(phone, code) {
      const url = new URL("https://control.msg91.com/api/v5/otp");
      url.searchParams.set("template_id", templateId);
      url.searchParams.set("mobile", phone.replace("+", ""));
      url.searchParams.set("otp", code);
      const res = await fetch(url, { method: "POST", headers: { authkey: authKey } });
      if (!res.ok) throw new ApiError(502, "OTP_SEND_FAILED", "Could not send the code, try again");
    },
  };
}

export class OtpService {
  constructor(
    private readonly redis: Redis,
    private readonly sender: OtpSender,
    private readonly secret: string,
    /** When set (dev only), this code is used instead of a random one. */
    private readonly fixedCode?: string,
    /** Staging: only these numbers may get a code (the fixed one); others are refused. */
    private readonly allowed?: (phone: string) => boolean,
  ) {}

  async send(phone: string): Promise<{ expiresInSeconds: number; resendAfterSeconds: number }> {
    if (this.allowed && !this.allowed(phone)) {
      throw new ApiError(403, "OTP_NOT_ALLOWED", "This test server only signs in its test accounts");
    }
    const cooldown = await this.redis.set(`otp:cooldown:${phone}`, "1", "EX", OTP_RESEND_COOLDOWN_S, "NX");
    if (!cooldown) {
      const ttl = await this.redis.ttl(`otp:cooldown:${phone}`);
      throw new ApiError(429, "OTP_COOLDOWN", `Wait ${Math.max(ttl, 1)} seconds before asking for a new code`);
    }
    const sends = await this.redis.incr(`otp:sends:${phone}`);
    if (sends === 1) await this.redis.expire(`otp:sends:${phone}`, OTP_SEND_WINDOW_S);
    if (sends > OTP_MAX_SENDS) throw new ApiError(429, "OTP_TOO_MANY_SENDS", "Too many codes requested, try again later");

    const code = this.fixedCode ?? String(randomInt(0, 1_000_000)).padStart(6, "0");
    await this.redis
      .multi()
      .del(`otp:${phone}`)
      .hset(`otp:${phone}`, "h", this.hash(phone, code), "tries", "0")
      .expire(`otp:${phone}`, OTP_TTL_S)
      .exec();
    await this.sender.send(phone, code);
    return { expiresInSeconds: OTP_TTL_S, resendAfterSeconds: OTP_RESEND_COOLDOWN_S };
  }

  /** Throws unless `code` is the live code for `phone`. A code works once. */
  async verify(phone: string, code: string): Promise<void> {
    const key = `otp:${phone}`;
    const stored = await this.redis.hget(key, "h");
    if (!stored) throw new ApiError(400, "OTP_EXPIRED", "The code has expired, ask for a new one");

    const tries = await this.redis.hincrby(key, "tries", 1);
    if (tries > OTP_MAX_ATTEMPTS) {
      await this.redis.del(key);
      throw new ApiError(429, "OTP_TOO_MANY_ATTEMPTS", "Too many wrong codes, ask for a new one");
    }
    const a = Buffer.from(stored, "hex");
    const b = Buffer.from(this.hash(phone, code), "hex");
    if (a.length !== b.length || !timingSafeEqual(a, b)) {
      throw new ApiError(400, "OTP_INVALID", "That code is not right");
    }
    // DEL returns 0 if a parallel request already used this code.
    if ((await this.redis.del(key)) !== 1) throw new ApiError(400, "OTP_EXPIRED", "The code has expired, ask for a new one");
    await this.redis.del(`otp:sends:${phone}`);
  }

  private hash(phone: string, code: string): string {
    return createHmac("sha256", this.secret).update(`${phone}:${code}`).digest("hex");
  }
}
