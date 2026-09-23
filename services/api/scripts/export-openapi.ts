/**
 * Writes openapi.json without starting servers or touching the database.
 * The Flutter app's Dart client is generated from this file.
 */
import { writeFile } from "node:fs/promises";
import { buildApp, type AppDeps } from "../src/app.js";

// Routes only read their dependencies at registration; none are called here.
const placeholder: object = new Proxy({}, { get: (_t, key) => (key === "logger" || key === "realtime" || key === "devTools" ? false : placeholder) });
const app = await buildApp(placeholder as AppDeps);
await app.ready();
const out = new URL("../openapi.json", import.meta.url);
await writeFile(out, JSON.stringify(app.swagger(), null, 2) + "\n");
console.log(`wrote ${out.pathname}`);
await app.close();
