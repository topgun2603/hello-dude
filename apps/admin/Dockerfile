# Admin panel (Next.js standalone). Build from the repo root:
#   docker build -f apps/admin/Dockerfile -t hellodude-admin .
# Runtime env: PESU_API_URL (the API as seen from this container, e.g. http://api:9000).
FROM node:22-alpine AS build
WORKDIR /app
COPY apps/admin/package.json apps/admin/package-lock.json ./
RUN npm ci
COPY apps/admin ./
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build

FROM node:22-alpine
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 PORT=9001 HOSTNAME=0.0.0.0
WORKDIR /app
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
COPY --from=build /app/public ./public
USER node
EXPOSE 9001
CMD ["node", "server.js"]
