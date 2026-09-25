/** Checks the configured file store (S3/R2 or local): upload, stored bytes are encrypted, read back, delete. */
import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { loadConfig } from "../src/config.js";
import { parseKey, storeFromConfig } from "../src/storage.js";
const cfg = loadConfig();
const store = storeFromConfig(cfg, parseKey(cfg.KYC_ENCRYPTION_KEY));
const key = "healthcheck/s3-test";
const secret = Buffer.from("hello-dude s3 check " + Date.now());
await store.put(key, secret);
console.log("1. upload: ok");
if (!cfg.S3_BUCKET) { console.log("S3_BUCKET not set: using local disk"); process.exit(0); }
const raw = new S3Client({ region: cfg.S3_REGION, credentials: { accessKeyId: cfg.S3_ACCESS_KEY_ID!, secretAccessKey: cfg.S3_SECRET_ACCESS_KEY! } });
const obj = await raw.send(new GetObjectCommand({ Bucket: cfg.S3_BUCKET!, Key: key + ".bin" }));
const bytes = Buffer.from(await obj.Body!.transformToByteArray());
console.log("2. stored in bucket is encrypted:", !bytes.includes(secret), `(${bytes.length} bytes)`);
console.log("3. read back matches:", (await store.get(key)).equals(secret));
await store.delete(key);
try { await store.get(key); console.log("4. delete: FAILED, still there"); } catch { console.log("4. delete: ok"); }
