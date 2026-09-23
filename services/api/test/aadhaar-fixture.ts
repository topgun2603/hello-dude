/**
 * Builds Aadhaar-offline-e-KYC-shaped ZIPs signed with a TEST certificate, so
 * the whole verification path runs in tests and on dev phones without real
 * Aadhaar data. Production trusts only UIDAI's certificate, so these files
 * are useless outside dev.
 */
import { Uint8ArrayReader, Uint8ArrayWriter, ZipWriter } from "@zip.js/zip.js";
import selfsigned from "selfsigned";
import { SignedXml } from "xml-crypto";

export interface TestSigner { privateKeyPem: string; certPem: string }

export async function makeTestSigner(): Promise<TestSigner> {
  const pems = await selfsigned.generate([{ name: "commonName", value: "Pesu TEST UIDAI signer - NOT REAL" }], {
    keySize: 2048, algorithm: "sha256", notAfterDate: new Date(Date.now() + 10 * 365 * 86_400_000),
  });
  return { privateKeyPem: pems.private, certPem: pems.cert };
}

// A 1×1 JPEG stands in for the resident photo.
export const TINY_JPEG = Buffer.from(
  "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/wAALCAABAAEBAREA/8QAFAABAAAAAAAAAAAAAAAAAAAACf/EABQQAQAAAAAAAAAAAAAAAAAAAAD/2gAIAQEAAD8AKp//2Q==",
  "base64",
);

export interface TestAadhaar {
  name?: string;
  dob?: string;          // DD-MM-YYYY
  gender?: "M" | "F" | "T";
  last4?: string;
  generatedAt?: Date;
  shareCode?: string;
  photo?: Buffer;
}

const pad = (n: number, w = 2) => String(n).padStart(w, "0");

/** referenceId timestamp in IST, like UIDAI. */
function istStamp(d: Date): string {
  const ist = new Date(d.getTime() + 5.5 * 3600_000);
  return `${ist.getUTCFullYear()}${pad(ist.getUTCMonth() + 1)}${pad(ist.getUTCDate())}` +
    `${pad(ist.getUTCHours())}${pad(ist.getUTCMinutes())}${pad(ist.getUTCSeconds())}${pad(ist.getUTCMilliseconds(), 3)}`;
}

export function signedKycXml(signer: TestSigner, a: TestAadhaar = {}): string {
  const esc = (s: string) => s.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/</g, "&lt;");
  const xml =
    `<OfflinePaperlessKyc referenceId="${a.last4 ?? "1234"}${istStamp(a.generatedAt ?? new Date())}">` +
    `<UidData>` +
    `<Poi dob="${a.dob ?? "15-08-1998"}" e="" gender="${a.gender ?? "F"}" m="" name="${esc(a.name ?? "Priya Raman")}"/>` +
    `<Poa careof="" country="India" dist="Chennai" house="" landmark="" loc="" pc="600001" po="" state="Tamil Nadu" street="" subdist="" vtc="Chennai"/>` +
    `<Pht>${(a.photo ?? TINY_JPEG).toString("base64")}</Pht>` +
    `</UidData></OfflinePaperlessKyc>`;
  const sig = new SignedXml({
    privateKey: signer.privateKeyPem,
    publicCert: signer.certPem,
    canonicalizationAlgorithm: "http://www.w3.org/TR/2001/REC-xml-c14n-20010315",
    signatureAlgorithm: "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256",
  });
  sig.addReference({
    xpath: "/*",
    isEmptyUri: true,
    digestAlgorithm: "http://www.w3.org/2001/04/xmlenc#sha256",
    transforms: ["http://www.w3.org/2000/09/xmldsig#enveloped-signature", "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"],
  });
  sig.computeSignature(xml);
  return sig.getSignedXml();
}

export async function zipWithShareCode(xml: string, shareCode: string, filename = "offlineaadhaar20260923.xml"): Promise<Buffer> {
  const writer = new ZipWriter(new Uint8ArrayWriter(), { password: shareCode, zipCrypto: true });
  await writer.add(filename, new Uint8ArrayReader(new TextEncoder().encode(xml)));
  return Buffer.from(await writer.close());
}

export async function makeTestAadhaarZip(signer: TestSigner, a: TestAadhaar = {}): Promise<Buffer> {
  return zipWithShareCode(signedKycXml(signer, a), a.shareCode ?? "1234");
}
