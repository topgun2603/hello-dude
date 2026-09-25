import { randomBytes } from "node:crypto";
import { DeleteObjectCommand, GetObjectCommand, PutObjectCommand } from "@aws-sdk/client-s3";
import { describe, expect, it } from "vitest";
import { s3EncryptedStore, type S3Like } from "./storage.js";

/** Stands in for a bucket: keeps whatever bytes were uploaded. */
function fakeBucket() {
  const objects = new Map<string, Buffer>();
  const client: S3Like = {
    async send(cmd) {
      const { Bucket, Key } = cmd.input as { Bucket: string; Key: string };
      const id = `${Bucket}/${Key}`;
      if (cmd instanceof PutObjectCommand) { objects.set(id, Buffer.from(cmd.input.Body as Buffer)); return {}; }
      if (cmd instanceof GetObjectCommand) {
        const body = objects.get(id);
        if (!body) throw Object.assign(new Error("NoSuchKey"), { name: "NoSuchKey" });
        return { Body: { transformToByteArray: async () => new Uint8Array(body) } };
      }
      if (cmd instanceof DeleteObjectCommand) { objects.delete(id); return {}; }
      throw new Error("unexpected command");
    },
  };
  return { client, objects };
}

describe("S3 / R2 store", () => {
  it("uploads only ciphertext, reads it back, deletes, and refuses path tricks", async () => {
    const { client, objects } = fakeBucket();
    const store = s3EncryptedStore(client, "hd-kyc", randomBytes(32));
    const selfie = Buffer.from("pretend this is a selfie jpeg");

    await store.put("kyc/user-1/selfie", selfie);
    const stored = objects.get("hd-kyc/kyc/user-1/selfie.bin")!;
    expect(stored).toBeDefined();
    expect(stored.includes(selfie)).toBe(false);
    expect(await store.get("kyc/user-1/selfie")).toEqual(selfie);

    await store.delete("kyc/user-1/selfie");
    expect(objects.size).toBe(0);
    await expect(store.get("kyc/user-1/selfie")).rejects.toThrow();
    await expect(store.put("../escape", selfie)).rejects.toThrow(/bad object key/);
  });

  it("a different key can't read the bucket", async () => {
    const { client } = fakeBucket();
    await s3EncryptedStore(client, "b", randomBytes(32)).put("kyc/u/pan", Buffer.from("ABCPE1234F"));
    await expect(s3EncryptedStore(client, "b", randomBytes(32)).get("kyc/u/pan")).rejects.toThrow();
  });
});
