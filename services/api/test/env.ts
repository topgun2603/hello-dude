// Test databases are separate from the dev ones so tests can wipe them freely.
export const TEST_DATABASE_URL =
  process.env.TEST_DATABASE_URL ?? "postgres://pesu:pesu@localhost:55432/pesu_test";
export const TEST_REDIS_URL = process.env.TEST_REDIS_URL ?? "redis://localhost:56379/15";
