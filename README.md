![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine - Immich Public Proxy
![size](https://img.shields.io/docker/image-size/11notes/immich-public-proxy/1.3.3?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/immich-public-proxy/1.3.3?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/immich-public-proxy?color=2b75d6)

**Publicly expose Immich without giving access to API**

# SYNOPSIS
**What can I do with this?** This image will publicly expose your shared albums without the need to expose the /api endpoint. Simply set a WAN facing reverse proxy like Traefik for the ```IMMICH_PUBLIC_PROXY_PUBLIC_URL``` to redirect to this container on port :3000.

# COMPOSE
```yaml
name: "immich-public-proxy"
services:
  immich-public-proxy:
    image: "11notes/immich-public-proxy:1.3.3"
    container_name: "immich-public-proxy"
    environment:
      TZ: "Europe/Zurich"
      IMMICH_PUBLIC_PROXY_PUBLIC_URL: "https://photos.domain.com"
      IMMICH_PUBLIC_PROXY_LIGHT_GALLERY_CONFIG: |-
        {
          "lightGallery": {
            "controls": true,
            "download": false,
            "mobileSettings": {
              "controls": false,
              "showCloseIcon": true,
              "download": false
            }
          }
        }
    ports:
      - "3000:3000/tcp"
    restart: "always"
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /node | home directory of user docker |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |
| `HEALTHCHECK_URL` | URL to use for health check | http://localhost:3000/healthcheck |
| `IMMICH_PUBLIC_PROXY_LOCAL_URL` | Immich internal URL | http://immich.server:2283 |
| `IMMICH_PUBLIC_PROXY_PUBLIC_URL` | Immich external URL | https://immich.domain.com |
| `IMMICH_PUBLIC_PROXY_LIGHT_GALLERY_CONFIG` | Inline config for [lightGallery](https://github.com/sachinchoolur/lightGallery) |  |

# SOURCE
* [11notes/immich-public-proxy:1.3.3](https://github.com/11notes/docker-immich-public-proxy/tree/1.3.3)

# PARENT IMAGE
* [11notes/node:stable](https://hub.docker.com/r/11notes/node)

# BUILT WITH
* [immich-public-proxy](https://github.com/alangrainger/immich-public-proxy)
* [alpine](https://alpinelinux.org)

# TIPS
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a new version. Check the changelog for breaking changes. You can find all my repositories on [github](https://github.com/11notes).
    