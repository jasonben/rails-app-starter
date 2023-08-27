FROM ruby:alpine3.18

ARG APP_USER=ide
ARG APP_SRC=/jasonben/ide/code/src
ARG BUNDLE=/jasonben/ide/bundle

RUN mkdir -p ${BUNDLE}
ENV GEM_HOME ${BUNDLE}
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
  echo "${APP_USER}:password" | chpasswd && \
  chown -R ${APP_USER}:${APP_USER} /jasonben/ide

USER "${APP_USER}"

# client and server source code
COPY --chown=${APP_USER} src ${APP_SRC}

# Nginx config for html/js
COPY --chown=${APP_USER} docker/config/nginx/nginx.conf /etc/nginx/nginx.conf

# node_modules for html/js
WORKDIR ${APP_SRC}/client
RUN \
  npm install

# .bundle for Rails
WORKDIR ${APP_SRC}/server
RUN \
  gem install bundler:2.4.18 && \
  bundle install

RUN \
  bundle exec \
    rails assets:precompile \
      RAILS_ENV=production \
      SECRET_KEY_BASE=railsappstarterrailsappstarterrailsappstarterrailsappstarter
