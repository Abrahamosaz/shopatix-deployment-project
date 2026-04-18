# =========================
# 1. BUILD STAGE
# =========================
FROM node:22-alpine AS builder

# Install git
RUN apk add --no-cache git

WORKDIR /app

# Build arguments
ARG REPO_TAG
ARG APP_NAME

# Clone using Docker Secrets (avoids exposing PAT in layers)
RUN --mount=type=secret,id=github_token \
    GITHUB_TOKEN=$(cat /run/secrets/github_token) && \
    git clone --depth 1 --branch $REPO_TAG https://${GITHUB_TOKEN}@github.com/codepeepsdevs/shopatix-backend-microservices.git .

# Install dependencies
RUN npm install

# Build the microservice
RUN npx nest build $APP_NAME


# =========================
# 2. RUNTIME STAGE
# =========================
FROM node:22-alpine AS runner

WORKDIR /app

COPY --from=builder /app/package*.json ./
RUN npm install --only=production
COPY --from=builder /app/dist ./dist

ARG APP_NAME
ENV APP_NAME=$APP_NAME

CMD ["sh", "-c", "node dist/apps/$APP_NAME/main.js"]