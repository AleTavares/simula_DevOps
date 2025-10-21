FROM node:18-alpine AS builder
COPY package.json package-lock.json ./
RUN npm install --only=production
WORKDIR /app
COPY . .
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app /app
EXPOSE 3000
CMD ["node", "src/server.js"]