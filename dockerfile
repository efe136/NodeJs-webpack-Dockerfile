FROM node:10.16.0-alpine as node
USER root
ENV http_proxy 'http://10.0.9.24:8080'
ENV https_proxy 'http://10.0.9.24:8080'

WORKDIR /tmp
COPY package.json /tmp/
RUN npm config set registry http://registry.npmjs.org/ && npm install --ignore-scripts --unsafe-perm
WORKDIR /usr/app
COPY . /usr/app/
RUN cp -a /tmp/node_modules /usr/app/
RUN npm install webpack@latest webpack-cli@latest -g
RUN set -xe && \
    apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    git --version && bash --version && ssh -V && npm -v && node -v
RUN ls
RUN npm rebuild node-sass 
RUN npm run build

ENV NODE_ENV=dev
ENV PORT=4000
EXPOSE 4000
