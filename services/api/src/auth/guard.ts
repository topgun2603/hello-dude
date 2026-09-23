import type { FastifyRequest } from "fastify";
import { forbidden, unauthorized } from "../errors.js";
import type { AccessClaims, Role } from "./tokens.js";

declare module "fastify" {
  interface FastifyRequest { auth: AccessClaims | null }
}

/** preHandler: requires a valid access token, optionally with one of `roles`. */
export function requireAuth(...roles: Role[]) {
  return async (req: FastifyRequest) => {
    const header = req.headers.authorization;
    if (!header?.startsWith("Bearer ")) throw unauthorized();
    req.auth = await req.server.deps.tokens.verifyAccess(header.slice(7));
    if (roles.length && !roles.includes(req.auth.role)) throw forbidden("WRONG_ROLE");
  };
}

/** preHandler: reads the token if one is sent, but lets anonymous requests through. */
export function optionalAuth() {
  return async (req: FastifyRequest) => {
    const header = req.headers.authorization;
    if (header?.startsWith("Bearer ")) req.auth = await req.server.deps.tokens.verifyAccess(header.slice(7));
  };
}

/** The signed-in user. Only call from routes guarded by requireAuth. */
export function me(req: FastifyRequest): AccessClaims {
  if (!req.auth) throw unauthorized();
  return req.auth;
}

/** OpenAPI security requirement for bearer-token routes. */
export const bearer = [{ bearer: [] }];
