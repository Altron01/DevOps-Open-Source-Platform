FROM node:18.12.1-alpine3.17 AS builder

WORKDIR app

COPY ["package.json", "package-lock.json", "./"]

RUN npm install

FROM node:18.12.1-alpine3.17 AS app

WORKDIR app

COPY --from=builder /app/node_modules ./node_modules
COPY . .

CMD npm start
