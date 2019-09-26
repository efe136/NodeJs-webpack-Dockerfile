FROM node:10.16.0-alpine as node
USER root

#### Proxy i an optional variant for enterprise that uses proxy.
#ENV http_proxy 'http://0.0.0.0:8080'
#ENV https_proxy 'http://0.0.0.0:8080'

WORKDIR /tmp
COPY package.json /tmp/
RUN npm config set registry http://registry.npmjs.org/ && npm install --ignore-scripts --unsafe-perm
WORKDIR /usr/app
COPY . /usr/app/
RUN cp -a /tmp/node_modules /usr/app/
#RUN npm install webpack@latest webpack-cli@latest -g ## It is needed when you use webpack command intead of npm run build. 
RUN set -xe && \
    apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    git --version && bash --version && ssh -V && npm -v && node -v
RUN ls
RUN npm rebuild node-sass 
RUN npm run build

ENV NODE_ENV=dev  ## node env is usefull to make image for production or development. If you need u can change env to production.
ENV PORT=4000
EXPOSE 4000
