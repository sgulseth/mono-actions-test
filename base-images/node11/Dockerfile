FROM node:12-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install dependencies
ONBUILD COPY package.json yarn.lock ./
ONBUILD RUN yarn install --pure-lockfile

ONBUILD COPY . .

ONBUILD CMD [ "yarn", "start" ]
