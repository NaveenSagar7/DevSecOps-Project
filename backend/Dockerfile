FROM node:20 AS build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --only=production && npm cache clean --force

FROM node:20-alpine AS production

WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN apk --no-cache add dumb-init=1.2.5-r3

COPY --from=build /app/node_modules ./node_modules

COPY src ./src

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 5000

ENTRYPOINT ["dumb-init", "--"]

CMD ["node", "src/index.js"]


