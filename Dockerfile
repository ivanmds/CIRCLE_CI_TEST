FROM node:14-alpine as builder

WORKDIR /usr/src/app

RUN npm i -g @nestjs/cli

COPY package.json ./
RUN npm install --only=prod

COPY . .

RUN npm run build --prod
RUN npm prune --production

FROM node:14-alpine as app

WORKDIR /usr/src/app

EXPOSE 3000

COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules

ENTRYPOINT [ "node", "dist/main" ]