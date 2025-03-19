FROM node:16 AS builder
WORKDIR /app
COPY package.json .
RUN npm install

FROM node:16
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
CMD ["node", "server.js"]
