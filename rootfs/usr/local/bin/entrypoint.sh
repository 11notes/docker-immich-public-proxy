#!/bin/ash
  if [ -z "${1}" ]; then
    IMMICH_PUBLIC_PROXY_ENV="${APP_ROOT}/.env"
    echo "IMMICH_URL=\"${IMMICH_PUBLIC_PROXY_LOCAL_URL}\"" > ${IMMICH_PUBLIC_PROXY_ENV}
    echo "PROXY_PUBLIC_URL=\"${IMMICH_PUBLIC_PROXY_PUBLIC_URL}\"" >> ${IMMICH_PUBLIC_PROXY_ENV}
    echo "PORT=3000" >> ${IMMICH_PUBLIC_PROXY_ENV}
    echo "CACHE_AGE=2592000" >> ${IMMICH_PUBLIC_PROXY_ENV}

    if [ ! -z "${IMMICH_PUBLIC_PROXY_LIGHT_GALLERY_CONFIG}" ]; then
      elevenLogJSON info "setting custom lightGallery config"
      echo "${IMMICH_PUBLIC_PROXY_LIGHT_GALLERY_CONFIG}" > ${APP_ROOT}/config.json
    fi

    elevenLogJSON info "starting ${APP_NAME} v${APP_VERSION}"
    set -- node \
      ${APP_ROOT}/dist/index.js
  fi
  
  exec "$@"