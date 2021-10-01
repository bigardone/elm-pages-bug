FROM node:14-alpine3.13 as source

ENV ELM_HOME "elm/cache"

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

# COPY yarn.lock /usr/src/app/
RUN yarn --ignore-platform
RUN yarn build --base "elm-pages-bug"

FROM nginx:stable

COPY --from=source /usr/src/app/dist /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/

