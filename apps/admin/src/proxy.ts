import { NextResponse, type NextRequest } from "next/server";

/**
 * Optimistic check only: pages need a refresh-token cookie, otherwise go to
 * /login. The real authorisation happens in the API on every request.
 */
export function proxy(request: NextRequest) {
  if (!request.cookies.has("pesu_admin_rt")) {
    const login = new URL("/login", request.url);
    return NextResponse.redirect(login);
  }
  return NextResponse.next();
}

export const config = {
  // Static images in public/ (login artwork) must load before sign-in.
  matcher: ["/((?!login|api|_next|favicon.ico|.*\\.(?:png|jpg|jpeg|svg|webp)$).*)"],
};
