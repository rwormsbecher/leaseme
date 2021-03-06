FROM node:16-alpine AS development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install glob rimraf

RUN npm install --only=development

# RUN --mount=type=secret,id=DATABASE_CONNECTION_STRING export DATABASE_CONNECTION_STRING=$(cat /run/secrets/DATABASE_CONNECTION_STRING) 

COPY . .

RUN npm run build




FROM node:12.19.0-alpine3.9 as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

# RUN --mount=type=secret,id=DATABASE_CONNECTION_STRING export DATABASE_CONNECTION_STRING=$(cat /run/secrets/DATABASE_CONNECTION_STRING) 

COPY . .

COPY --from=development /usr/src/app/dist ./dist

CMD ["node", "dist/main"]