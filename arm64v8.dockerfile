# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Build
  FROM --platform=linux/arm64 11notes/node:stable as build
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin

  USER root

  RUN set -ex; \
    apk add --no-cache --update \
      git; \
    git clone https://github.com/alangrainger/immich-public-proxy.git; \
    cd /immich-public-proxy; \
    npm install --save;

# :: Header
  FROM --platform=linux/arm64 11notes/node:stable
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  COPY --from=util /util/docker /usr/local/bin
  COPY --from=build /immich-public-proxy /node
  ENV APP_NAME="immich-public-proxy"
  ENV APP_VERSION="latest"
  ENV NODE_ENV="production"
  ENV IMMICH_URL="http://localhost:3000"
  ENV PORT=3000
  ENV CACHE_AGE=2592000

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