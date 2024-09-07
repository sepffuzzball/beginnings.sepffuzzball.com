# Create build environment
FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.20@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5 AS build
COPY --from=golang:1.13-alpine /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:${PATH}"
RUN \
    apk add --no-cache \
      git \
      unzip \
      wget
RUN wget https://github.com/tmedwards/tweego/releases/download/v2.1.1/tweego-2.1.1-linux-x64.zip
RUN unzip tweego-2.1.1-linux-x64.zip \
    && chmod +x tweego

COPY ./src/format.js /storyformats/harlowe-3/format.js
WORKDIR /src
COPY ./src .

# Build twine site.
RUN ../tweego Beginnings.twee -o /src/index.html

FROM docker.io/library/nginx:1.27@sha256:447a8665cc1dab95b1ca778e162215839ccbb9189104c79d7ec3a81e14577add
# implement changes required to run NGINX as an less-privileged user
RUN \
    sed -i 's,/var/run/nginx.pid,/tmp/nginx.pid,' /etc/nginx/nginx.conf \
 && sed -i "/^http {/a \    proxy_temp_path /tmp/proxy_temp;\n    client_body_temp_path /tmp/client_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;\n" /etc/nginx/nginx.conf \
 # nginx user must own the cache and etc directory to write cache and tweak the nginx config
 && chown -R 101:0 /var/cache/nginx \
 && chmod -R g+w /var/cache/nginx \
 && chown -R 101:0 /etc/nginx \
 && chmod -R g+w /etc/nginx

COPY --chown=nginx:nginx --from=build /src/index.html /site/index.html
COPY --chown=nginx:nginx ./default.conf /etc/nginx/conf.d/

USER nginx