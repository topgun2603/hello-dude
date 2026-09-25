/**
 * Private, encrypted object storage for KYC files. Every object is sealed with
 * AES-256-GCM before it leaves the process, so a leaked bucket or disk is
 * useless without KYC_ENCRYPTION_KEY. Dev writes to a local folder; production
 * swaps in an S3-compatible bucket (India region) behind the same interface.
 */
import { createCipheriv, createDecipheriv, randomBytes } from "node:crypto";
import { mkdir, readFile, rm, writeFile } from "node:fs/promises";
import path from "node:path";
import { DeleteObjectCommand, GetObjectCommand, PutObjectCommand, S3Client } from "@aws-sdk/client-s3";

export interface ObjectStore {
  put(key: string, data: Buffer): Promise<void>;
  get(key: string): Promise<Buffer>;
  /** Removes the object; no error if it is already gone. */
  delete(key: string): Promise<void>;
}

const IV_BYTES = 12;
const TAG_BYTES = 16;

export function parseKey(base64: string): Buffer {
  const key = Buffer.from(base64, "base64");
  if (key.length !== 32) throw new Error("KYC_ENCRYPTION_KEY must be 32 bytes, base64-encoded");
  return key;
}

/** iv | tag | ciphertext */
export function seal(key: Buffer, plain: Buffer): Buffer {
  const iv = randomBytes(IV_BYTES);
  const cipher = createCipheriv("aes-256-gcm", key, iv);
  const body = Buffer.concat([cipher.update(plain), cipher.final()]);
  return Buffer.concat([iv, cipher.getAuthTag(), body]);
}

export function open(key: Buffer, sealed: Buffer): Buffer {
  const iv = sealed.subarray(0, IV_BYTES);
  const tag = sealed.subarray(IV_BYTES, IV_BYTES + TAG_BYTES);
  const decipher = createDecipheriv("aes-256-gcm", key, iv);
  decipher.setAuthTag(tag);
  return Buffer.concat([decipher.update(sealed.subarray(IV_BYTES + TAG_BYTES)), decipher.final()]);
}

/** Object keys look like "kyc/<userId>/selfie": letters, digits, / _ - only (no dots, so no path tricks). */
function checkKey(k: string): void {
  if (!/^[a-z0-9/_-]+$/i.test(k) || k.includes("..")) throw new Error(`bad object key ${k}`);
}

/** Encrypted files on local disk (development). */
export function localEncryptedStore(dir: string, key: Buffer): ObjectStore {
  const fileFor = (k: string) => {
    checkKey(k);
    return path.join(dir, `${k}.bin`);
  };
  return {
    async put(k, data) {
      const file = fileFor(k);
      await mkdir(path.dirname(file), { recursive: true });
      await writeFile(file, seal(key, data));
    },
    async get(k) {
      return open(key, await readFile(fileFor(k)));
    },
    async delete(k) {
      await rm(fileFor(k), { force: true });
    },
  };
}

/** The part of the AWS SDK S3 client the store uses (a fake in tests). */
export interface S3Like {
  send(command: PutObjectCommand | GetObjectCommand | DeleteObjectCommand): Promise<unknown>;
}

/**
 * Encrypted objects in an S3-compatible bucket (AWS Mumbai or Cloudflare R2,
 * India region). Sealed before upload, so the bucket only ever holds ciphertext.
 */
export function s3EncryptedStore(client: S3Like, bucket: string, key: Buffer): ObjectStore {
  const objectKey = (k: string) => {
    checkKey(k);
    return `${k}.bin`;
  };
  return {
    async put(k, data) {
      await client.send(new PutObjectCommand({
        Bucket: bucket, Key: objectKey(k), Body: seal(key, data), ContentType: "application/octet-stream",
      }));
    },
    async get(k) {
      const res = await client.send(new GetObjectCommand({ Bucket: bucket, Key: objectKey(k) })) as
        { Body?: { transformToByteArray(): Promise<Uint8Array> } };
      if (!res.Body) throw new Error(`no object ${k}`);
      return open(key, Buffer.from(await res.Body.transformToByteArray()));
    },
    async delete(k) {
      await client.send(new DeleteObjectCommand({ Bucket: bucket, Key: objectKey(k) }));
    },
  };
}

export interface StoreConfig {
  KYC_STORAGE_DIR: string;
  S3_BUCKET?: string;
  S3_REGION: string;
  S3_ENDPOINT?: string;
  S3_ACCESS_KEY_ID?: string;
  S3_SECRET_ACCESS_KEY?: string;
}

/** S3/R2 when S3_BUCKET is set, else encrypted files under KYC_STORAGE_DIR. */
export function storeFromConfig(cfg: StoreConfig, key: Buffer): ObjectStore {
  if (!cfg.S3_BUCKET) return localEncryptedStore(cfg.KYC_STORAGE_DIR, key);
  const client = new S3Client({
    region: cfg.S3_REGION,
    ...(cfg.S3_ENDPOINT ? { endpoint: cfg.S3_ENDPOINT } : {}),
    ...(cfg.S3_ACCESS_KEY_ID && cfg.S3_SECRET_ACCESS_KEY
      ? { credentials: { accessKeyId: cfg.S3_ACCESS_KEY_ID, secretAccessKey: cfg.S3_SECRET_ACCESS_KEY } }
      : {}),
  });
  return s3EncryptedStore(client, cfg.S3_BUCKET, key);
}

/** In-memory store for tests. */
export function memoryStore(): ObjectStore & { keys(): string[] } {
  const objects = new Map<string, Buffer>();
  return {
    // Same key rules as the real stores, so tests catch bad keys.
    async put(k, data) { checkKey(k); objects.set(k, Buffer.from(data)); },
    async get(k) {
      const v = objects.get(k);
      if (!v) throw new Error(`no object ${k}`);
      return v;
    },
    async delete(k) { objects.delete(k); },
    keys: () => [...objects.keys()],
  };
}
