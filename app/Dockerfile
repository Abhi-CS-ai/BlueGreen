# ===== Build Stage =====
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY src ./src

# ===== Runtime Stage =====
FROM node:18-alpine

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app /app

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "src/server.js"]
