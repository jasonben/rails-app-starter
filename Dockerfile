FROM ruby:alpine3.18

ARG APP_USER=ide
ARG APP_SRC=/usr/local/app/src

ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV SHELL /bin/bash

RUN apk add --no-cache postgresql-client postgresql-dev libpq build-base sqlite-dev bash glib-dev vips-dev libjpeg-turbo-dev ffmpeg poppler npm

RUN \
  addgroup -g 1000 -S ${APP_USER} && \
  adduser -D -u 1000 -G ${APP_USER} -S ${APP_USER} && \
  echo "${APP_USER}:password" | chpasswd

USER "${APP_USER}"

# Rails
COPY --chown=${APP_USER} src/server ${APP_SRC}/server
COPY --chown=${APP_USER} src/server ${APP_SRC}/server

# Static html/js
COPY --chown=${APP_USER} src/client ${APP_SRC}/client
COPY --chown=${APP_USER} src/client ${APP_SRC}/client

# Nginx config for html/js
COPY --chown=${APP_USER} docker/config/nginx/nginx.conf /etc/nginx/nginx.conf

# node_modules for html/js
WORKDIR ${APP_SRC}/client
RUN \
  npm install

# .bundle for Rails
WORKDIR ${APP_SRC}/server
RUN \
  gem install bundler:2.4.19 && \
  bundle update && \
  bundle install

RUN \
  bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=railsappstarterrailsappstarterrailsappstarterrailsappstarter
