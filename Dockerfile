FROM ruby:alpine3.16

ARG APP_USER=jasonb
ARG APP_SRC=/usr/local/app/src/server

ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

RUN apk add --no-cache postgresql-client postgresql-dev libpq build-base sqlite-dev bash glib-dev vips-dev libjpeg-turbo-dev ffmpeg poppler

RUN \
  addgroup -g 1000 -S ${APP_USER} && \
  adduser -D -u 1000 -G ${APP_USER} -S ${APP_USER} && \
  echo "${APP_USER}:password" | chpasswd

USER "${APP_USER}"
COPY --chown=${APP_USER} src/server ${APP_SRC}
WORKDIR ${APP_SRC}

RUN mkdir -p tmp/pids
