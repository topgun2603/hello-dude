import { beforeAll, describe, expect, it } from "vitest";
import {
  makeTestAadhaarZip, makeTestSigner, signedKycXml, TINY_JPEG, zipWithShareCode, type TestSigner,
} from "../../test/aadhaar-fixture.js";
import { ageOn, verifyOfflineKyc } from "./aadhaar.js";

let uidai: TestSigner;
let impostor: TestSigner;
beforeAll(async () => { [uidai, impostor] = await Promise.all([makeTestSigner(), makeTestSigner()]); });

const code = (p: Promise<unknown>) => p.then(() => "OK", (e: { code?: string }) => e.code);

describe("Aadhaar offline e-KYC", () => {
  it("opens the ZIP with the share code, checks the signature and reads the signed data", async () => {
    const generatedAt = new Date("2026-09-20T10:00:00Z");
    const zip = await makeTestAadhaarZip(uidai, { name: "Priya Raman", dob: "15-08-1998", gender: "F", last4: "4321", shareCode: "AB12", generatedAt });
    const kyc = await verifyOfflineKyc(zip, "AB12", [uidai.certPem]);
    expect(kyc).toMatchObject({ name: "Priya Raman", dob: "1998-08-15", gender: "F", last4: "4321" });
    expect(kyc.generatedAt.toISOString()).toBe("2026-09-20T10:00:00.000Z");
    expect(kyc.photoJpeg.equals(TINY_JPEG)).toBe(true);
  });

  it("rejects a wrong share code", async () => {
    const zip = await makeTestAadhaarZip(uidai, { shareCode: "1234" });
    expect(await code(verifyOfflineKyc(zip, "9999", [uidai.certPem]))).toBe("AADHAAR_SHARE_CODE_WRONG");
  });

  it("rejects a file signed by anyone other than the trusted certificate", async () => {
    const zip = await makeTestAadhaarZip(impostor);
    expect(await code(verifyOfflineKyc(zip, "1234", [uidai.certPem]))).toBe("AADHAAR_SIGNATURE_INVALID");
  });

  it("rejects a file edited after signing (e.g. a changed name or birth year)", async () => {
    const xml = signedKycXml(uidai, { name: "Priya Raman", dob: "15-08-2010" }).replace('dob="15-08-2010"', 'dob="15-08-1990"');
    const zip = await zipWithShareCode(xml, "1234");
    expect(await code(verifyOfflineKyc(zip, "1234", [uidai.certPem]))).toBe("AADHAAR_SIGNATURE_INVALID");
  });

  it("ignores a certificate embedded in the file (only configured certificates are trusted)", async () => {
    // The impostor's file carries the impostor's own cert in KeyInfo.
    const zip = await makeTestAadhaarZip(impostor);
    expect(await code(verifyOfflineKyc(zip, "1234", [uidai.certPem, "not a cert"]))).toBe("AADHAAR_SIGNATURE_INVALID");
  });

  it("rejects things that aren't an offline e-KYC ZIP", async () => {
    expect(await code(verifyOfflineKyc(Buffer.from("hello"), "1234", [uidai.certPem]))).toBe("AADHAAR_ZIP_INVALID");
    const unsigned = await zipWithShareCode("<OfflinePaperlessKyc referenceId=\"123420260920100000000\"/>", "1234");
    expect(await code(verifyOfflineKyc(unsigned, "1234", [uidai.certPem]))).toBe("AADHAAR_SIGNATURE_INVALID");
  });

  it("refuses to run without a configured UIDAI certificate", async () => {
    const zip = await makeTestAadhaarZip(uidai);
    expect(await code(verifyOfflineKyc(zip, "1234", []))).toBe("AADHAAR_NOT_CONFIGURED");
  });

  it("computes age in whole years", () => {
    const on = new Date("2026-09-23T00:00:00Z");
    expect(ageOn("2008-09-23", on)).toBe(18);
    expect(ageOn("2008-09-24", on)).toBe(17);
    expect(ageOn("1998-08-15", on)).toBe(28);
  });
});
