FROM nginx:1.21-alpine@sha256:91528597e842ab1b3b25567191fa7d4e211cb3cc332071fa031cfed2b5892f9e

COPY www /usr/share/nginx/html
COPY container/default.conf /etc/nginx/conf.d/default.conf
