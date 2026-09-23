/**
 * DEV ONLY. Makes a test "Aadhaar offline e-KYC" ZIP signed by a local test
 * certificate, so companion KYC can be tried on a phone without real Aadhaar.
 *
 *   npm run test-aadhaar -- "Priya Raman" 15-08-1998 F
 *
 * First run creates .data/dev-uidai/{cert,key}.pem — point UIDAI_CERT_PATHS at
 * the cert in services/api/.env (dev only; production uses UIDAI's certificate).
 */
import { mkdir, readFile, writeFile } from "node:fs/promises";
import { existsSync } from "node:fs";
import { makeTestAadhaarZip, makeTestSigner, type TestSigner } from "../test/aadhaar-fixture.js";

const dir = ".data/dev-uidai";
await mkdir(dir, { recursive: true });
let signer: TestSigner;
if (existsSync(`${dir}/cert.pem`)) {
  signer = { certPem: await readFile(`${dir}/cert.pem`, "utf8"), privateKeyPem: await readFile(`${dir}/key.pem`, "utf8") };
} else {
  signer = await makeTestSigner();
  await writeFile(`${dir}/cert.pem`, signer.certPem);
  await writeFile(`${dir}/key.pem`, signer.privateKeyPem);
  console.log(`created test signer in ${dir} — set UIDAI_CERT_PATHS=${dir}/cert.pem in .env`);
}

const [name = "Priya Raman", dob = "15-08-1998", gender = "F"] = process.argv.slice(2);
const last4 = String(1000 + Math.floor(Math.random() * 9000));
const shareCode = "1234";
const zip = await makeTestAadhaarZip(signer, { name, dob, gender: gender as "M" | "F" | "T", last4, shareCode });
const file = `.data/test-aadhaar-${name.toLowerCase().replace(/\W+/g, "-")}.zip`;
await writeFile(file, zip);
console.log(`wrote ${file}  (name "${name}", DOB ${dob}, share code ${shareCode}, last 4 ${last4})`);
