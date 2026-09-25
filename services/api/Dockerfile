# API + worker image (same code, different command). Build from the repo root:
#   docker build -f services/api/Dockerfile -t hellodude-api .
# Commands:  node dist/server.js | node dist/worker.js | node dist/db/migrate.js
# The "build" stage doubles as a tools image (tsx + scripts: make-admin, seed-dev, storage-check):
#   docker build -f services/api/Dockerfile --target build -t hellodude-api-tools .
FROM node:22-alpine AS build
WORKDIR /app/services/api
COPY services/api/package.json services/api/package-lock.json ./
RUN npm ci
COPY services/api/tsconfig.json ./
COPY services/api/src ./src
COPY services/api/scripts ./scripts
RUN npm run build

FROM build AS prod-deps
RUN npm prune --omit=dev

FROM node:22-alpine
ENV NODE_ENV=production
WORKDIR /app/services/api
COPY --from=prod-deps /app/services/api/node_modules ./node_modules
COPY --from=build /app/services/api/dist ./dist
COPY services/api/package.json ./
# The migration runner reads ../../../../db/migrations relative to dist/db/migrate.js.
COPY db/migrations /app/db/migrations
USER node
EXPOSE 9000
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s \
  CMD wget -qO- http://127.0.0.1:9000/health >/dev/null || exit 1
CMD ["node", "dist/server.js"]
