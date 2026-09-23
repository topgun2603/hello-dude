import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Dev server only: also allow http://127.0.0.1:9001 (not just localhost).
  allowedDevOrigins: ["127.0.0.1"],
  poweredByHeader: false,
};

export default nextConfig;
