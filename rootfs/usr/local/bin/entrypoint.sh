#!/bin/ash
  if [ -z "${1}" ]; then
    IMMICH_PUBLIC_PROXY_ENV="${APP_ROOT}/.env"
    echo "IMMICH_URL=\"${IMMICH_PUBLIC_PROXY_LOCAL_URL}\"" > ${IMMICH_PUBLIC_PROXY_ENV}
    echo "PROXY_PUBLIC_URL=\"${IMMICH_PUBLIC_PROXY_PUBLIC_URL}\"" >> ${IMMICH_PUBLIC_PROXY_ENV}
    echo "PORT=3000" >> ${IMMICH_PUBLIC_PROXY_ENV}
    echo "CACHE_AGE=2592000" >> ${IMMICH_PUBLIC_PROXY_ENV}

    cd ${APP_ROOT}
    set -- npm start
  fi
  
  exec "$@"