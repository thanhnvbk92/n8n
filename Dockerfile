# Base image có Node 18
FROM node:22-bullseye AS build

WORKDIR /app

# Copy file cấu hình trước để cache dependencies
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install

# Copy toàn bộ source
COPY . .

# Build project
RUN NODE_OPTIONS="--max_old_space_size=4096" pnpm build

# ========================
# Stage chạy thực tế
# ========================
FROM node:22-bullseye

WORKDIR /app
COPY --from=build /app ./

EXPOSE 5678
CMD ["pnpm", "start"]
