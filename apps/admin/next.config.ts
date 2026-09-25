import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Dev server only: also allow http://127.0.0.1:9001 (not just localhost).
  allowedDevOrigins: ["127.0.0.1"],
  poweredByHeader: false,
  // Self-contained server for the Docker image (apps/admin/Dockerfile).
  output: "standalone",
};

export default nextConfig;
