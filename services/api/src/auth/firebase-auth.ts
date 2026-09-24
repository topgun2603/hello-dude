/**
 * Mobile-app phone sign-in through Firebase Auth: the app does the SMS code with
 * Firebase and sends us the resulting ID token; we verify it here and read the
 * phone number Firebase confirmed. The admin panel keeps its own OTP flow.
 */
import { readFileSync } from "node:fs";
import { cert, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { ApiError } from "../errors.js";

export interface PhoneVerifier {
  /** Returns the verified phone number (E.164) behind a Firebase ID token. */
  verifyIdToken(idToken: string): Promise<string>;
}

export function firebasePhoneVerifier(serviceAccountPath: string): PhoneVerifier {
  const credentials = JSON.parse(readFileSync(serviceAccountPath, "utf8"));
  const auth = getAuth(initializeApp({ credential: cert(credentials) }, "pesu-auth"));
  return {
    async verifyIdToken(idToken) {
      let phone: string | undefined;
      try {
        // checkRevoked: a user disabled in Firebase can't sign in with an old token.
        phone = (await auth.verifyIdToken(idToken, true)).phone_number;
      } catch {
        throw new ApiError(401, "FIREBASE_TOKEN_INVALID", "Sign-in expired, verify your number again");
      }
      if (!phone) throw new ApiError(400, "FIREBASE_NO_PHONE", "This sign-in has no phone number");
      return phone;
    },
  };
}

/** Used when FIREBASE_SERVICE_ACCOUNT_PATH isn't set (the app then uses the dev OTP). */
export const phoneVerifierNotConfigured: PhoneVerifier = {
  async verifyIdToken() {
    throw new ApiError(503, "FIREBASE_AUTH_NOT_CONFIGURED", "Phone sign-in isn't set up on this server");
  },
};
