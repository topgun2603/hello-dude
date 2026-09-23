/**
 * UIDAI Aadhaar Paperless Offline e-KYC.
 *
 * The resident downloads a password-protected ZIP from the UIDAI site; the
 * password is the 4-character "share code" they choose. Inside is one XML file
 * digitally signed by UIDAI:
 *
 *   <OfflinePaperlessKyc referenceId="<last 4 of Aadhaar><YYYYMMDDHHMMSSsss>">
 *     <UidData>
 *       <Poi name=".." dob="DD-MM-YYYY" gender="M|F|T" e=".." m=".."/>
 *       <Poa .../>
 *       <Pht>base64 JPEG</Pht>
 *     </UidData>
 *     <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">...</Signature>
 *   </OfflinePaperlessKyc>
 *
 * We verify the signature against UIDAI's published certificate only (never
 * the certificate embedded in the file), read the data from the signed bytes
 * (not the raw document, which defeats signature-wrapping), and keep only
 * name, DOB, gender, photo and the last 4 digits — never a full Aadhaar number.
 */
import { DOMParser } from "@xmldom/xmldom";
import { configure, Uint8ArrayReader, Uint8ArrayWriter, ZipReader } from "@zip.js/zip.js";
import { SignedXml } from "xml-crypto";
import { ApiError } from "../errors.js";

configure({ useWebWorkers: false });

const DSIG_NS = "http://www.w3.org/2000/09/xmldsig#";
const MAX_ZIP_BYTES = 5 * 1024 * 1024;

export interface AadhaarKyc {
  name: string;
  dob: string;            // YYYY-MM-DD
  gender: "M" | "F" | "T";
  last4: string;
  generatedAt: Date;      // when the resident downloaded the ZIP from UIDAI
  photoJpeg: Buffer;
}

const bad = (code: string, message: string) => new ApiError(400, code, message);

export async function verifyOfflineKyc(
  zip: Buffer,
  shareCode: string,
  trustedCertsPem: string[],
): Promise<AadhaarKyc> {
  if (!trustedCertsPem.length) throw new ApiError(503, "AADHAAR_NOT_CONFIGURED", "Aadhaar verification is not set up yet");
  if (zip.length > MAX_ZIP_BYTES) throw bad("AADHAAR_ZIP_TOO_LARGE", "That file is too large to be an Aadhaar offline ZIP");

  const xml = await readXml(zip, shareCode);
  const signed = verifySignature(xml, trustedCertsPem);
  return parseKyc(signed);
}

async function readXml(zip: Buffer, shareCode: string): Promise<string> {
  let reader: ZipReader<Uint8ArrayReader> | undefined;
  try {
    reader = new ZipReader(new Uint8ArrayReader(new Uint8Array(zip)), { password: shareCode });
    const entries = (await reader.getEntries()).filter((e) => !e.directory);
    const xmlEntry = entries.find((e) => e.filename.toLowerCase().endsWith(".xml"));
    if (entries.length !== 1 || !xmlEntry || !("getData" in xmlEntry)) {
      throw bad("AADHAAR_ZIP_INVALID", "This isn't an Aadhaar offline e-KYC ZIP");
    }
    const bytes = await xmlEntry.getData(new Uint8ArrayWriter());
    return Buffer.from(bytes).toString("utf8");
  } catch (e) {
    if (e instanceof ApiError) throw e;
    const msg = String((e as Error)?.message ?? e);
    if (/password/i.test(msg)) throw bad("AADHAAR_SHARE_CODE_WRONG", "The share code doesn't open this file");
    throw bad("AADHAAR_ZIP_INVALID", "This isn't an Aadhaar offline e-KYC ZIP");
  } finally {
    await reader?.close().catch(() => {});
  }
}

/** Returns the canonical XML that the signature actually covers. */
function verifySignature(xml: string, trustedCertsPem: string[]): string {
  const doc = new DOMParser().parseFromString(xml, "text/xml");
  const sigNodes = doc.getElementsByTagNameNS(DSIG_NS, "Signature");
  if (sigNodes.length !== 1) throw bad("AADHAAR_SIGNATURE_INVALID", "The Aadhaar file isn't signed by UIDAI");

  for (const cert of trustedCertsPem) {
    const sig = new SignedXml({ publicCert: cert, getCertFromKeyInfo: () => null });
    sig.loadSignature(sigNodes[0] as unknown as Node);
    let ok = false;
    try {
      ok = sig.checkSignature(xml);
    } catch {
      ok = false;
    }
    if (!ok) continue;
    // The one signed reference must be the whole document (URI="").
    const refs = sig.getSignedReferences();
    if (refs.length !== 1) break;
    return refs[0]!;
  }
  throw bad("AADHAAR_SIGNATURE_INVALID", "The Aadhaar file isn't signed by UIDAI, or was changed");
}

function parseKyc(signedXml: string): AadhaarKyc {
  const doc = new DOMParser().parseFromString(signedXml, "text/xml");
  const root = doc.documentElement;
  if (!root || root.localName !== "OfflinePaperlessKyc") throw bad("AADHAAR_ZIP_INVALID", "Unexpected Aadhaar file format");

  const ref = root.getAttribute("referenceId") ?? "";
  const m = /^(\d{4})(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d{3})$/.exec(ref);
  if (!m) throw bad("AADHAAR_ZIP_INVALID", "Unexpected Aadhaar reference id");
  const [, last4, y, mo, d, h, mi, s, ms] = m;
  // referenceId timestamps are Indian Standard Time.
  const generatedAt = new Date(`${y}-${mo}-${d}T${h}:${mi}:${s}.${ms}+05:30`);

  const poi = doc.getElementsByTagName("Poi")[0];
  const pht = doc.getElementsByTagName("Pht")[0];
  const name = poi?.getAttribute("name")?.trim();
  const dobRaw = poi?.getAttribute("dob")?.trim() ?? "";
  const gender = poi?.getAttribute("gender")?.trim().toUpperCase();
  const photoB64 = pht?.textContent?.replace(/\s+/g, "");
  const dm = /^(\d{2})-(\d{2})-(\d{4})$/.exec(dobRaw);
  if (!name || !dm || !["M", "F", "T"].includes(gender ?? "") || !photoB64) {
    throw bad("AADHAAR_ZIP_INVALID", "The Aadhaar file is missing name, date of birth, gender or photo");
  }
  return {
    name,
    dob: `${dm[3]}-${dm[2]}-${dm[1]}`,
    gender: gender as AadhaarKyc["gender"],
    last4: last4!,
    generatedAt,
    photoJpeg: Buffer.from(photoB64, "base64"),
  };
}

/** Whole years between a YYYY-MM-DD birth date and `on`. */
export function ageOn(dob: string, on: Date = new Date()): number {
  const [y, m, d] = dob.split("-").map(Number) as [number, number, number];
  let age = on.getUTCFullYear() - y;
  if (on.getUTCMonth() + 1 < m || (on.getUTCMonth() + 1 === m && on.getUTCDate() < d)) age--;
  return age;
}
