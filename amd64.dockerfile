# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Build
  FROM 11notes/node:stable as build

  USER root

  RUN set -ex; \
    apk add --no-cache --update \
      git; \
    git clone https://github.com/alangrainger/immich-public-proxy.git; \
    cd /immich-public-proxy; \
    npm install --save;

# :: Header
  FROM 11notes/node:stable
  COPY --from=util /util/docker /usr/local/bin
  COPY --from=build /immich-public-proxy /node
  ENV APP_NAME="immich-public-proxy"
  ENV APP_VERSION="latest"
  ENV NODE_ENV="production"
  ENV IMMICH_PUBLIC_PROXY_LOCAL_URL="http://immich.server:2283"
  ENV IMMICH_PUBLIC_PROXY_PUBLIC_URL="https://immich.domain.com"

# :: Run
  USER root

  # :: prepare image
    RUN set -ex; \
      apk --no-cache --update upgrade;

  # :: copy root filesystem changes and add execution rights to init scripts
    COPY --chown=1000:1000 ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin;

  # :: change home path for existing user and set correct permission
    RUN set -ex; \
      usermod -d ${APP_ROOT} docker; \
      chown -R 1000:1000 \
        ${APP_ROOT};

# :: Start
  USER docker