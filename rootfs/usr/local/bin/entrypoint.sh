#!/bin/ash
  if [ -z "${1}" ]; then
    IMMICH_PUBLIC_PROXY_ENV="${APP_ROOT}/.env"
    if [ ! -f ${IMMICH_PUBLIC_PROXY_ENV} ]; then
      elevenLogJSON info "config missing, creating …"
      echo "IMMICH_URL=\"${IMMICH_URL}\"" > ${IMMICH_PUBLIC_PROXY_ENV}
      echo "PORT=${PORT}" >> ${IMMICH_PUBLIC_PROXY_ENV}
      echo "CACHE_AGE=${CACHE_AGE}" >> ${IMMICH_PUBLIC_PROXY_ENV}
    fi

    cd ${APP_ROOT}
    set -- npm start
  fi
  
  exec "$@"