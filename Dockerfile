FROM oven/bun:1-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN bun install

COPY . .
RUN bun run build

FROM oven/bun:1-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/src/h2-bridge.mjs ./h2-bridge.mjs
COPY --from=builder /app/node_modules ./node_modules
COPY package.json .

RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser

USER appuser

ENTRYPOINT ["bun", "run", "dist/cli.js"]
