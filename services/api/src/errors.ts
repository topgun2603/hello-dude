/** An error that is safe to show the client: HTTP status + stable machine code. */
export class ApiError extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    message?: string,
  ) {
    super(message ?? code);
  }
}

export const unauthorized = (code = "UNAUTHORIZED") => new ApiError(401, code, "Sign in again");
export const forbidden = (code = "FORBIDDEN") => new ApiError(403, code);
export const notFound = (code = "NOT_FOUND") => new ApiError(404, code);
export const conflict = (code: string, message?: string) => new ApiError(409, code, message);
