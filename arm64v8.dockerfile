# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Build
  FROM 11notes/node:stable as build
  ENV BUILD_VERSION=1.3.3

  USER root

  RUN set -ex; \
    apk add --no-cache --update \
      git; \
    git clone https://github.com/alangrainger/immich-public-proxy.git -b v${BUILD_VERSION}; \
    cd /immich-public-proxy; \
    npm install --save --omit=dev; \
    npx tsc --noCheck; \
    rm -rf \
      docs \
      Docker* \
      docker* \
      .docker* \
      .env* \
      .eslint* \
      .git* \
      LICENSE \
      README* \
      src;

# :: Header
  FROM --platform=linux/arm64 11notes/node:stable
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  COPY --from=util /util/docker /usr/local/bin
  COPY --from=build /immich-public-proxy /node
  ENV NODE_ENV=production
  ENV APP_NAME="immich-public-proxy"
  ENV APP_VERSION=1.3.3
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

# :: Monitor
  HEALTHCHECK --interval=5s --timeout=2s CMD /usr/local/bin/healthcheck.sh || exit 1

# :: Start
  USER docker