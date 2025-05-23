# Generated by https://smithery.ai. See: https://smithery.ai/docs/build/project-config
# Stage 1: Build
FROM node:lts-alpine AS builder
WORKDIR /app

# Install dependencies and build
COPY package.json package-lock.json tsconfig.json tsconfig.test.json ./
COPY src ./src
COPY examples ./examples
RUN npm ci --ignore-scripts && npm run build && npm prune --production

# Stage 2: Runtime
FROM node:lts-alpine
WORKDIR /app

# Copy production artifacts
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package.json ./package.json

# Default environment
ENV NODE_ENV=production

# Expose no ports (stdio transport)
ENTRYPOINT ["node", "dist/cli.js"]
