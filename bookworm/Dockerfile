# Dockerfile for Debian with Russian locales and Moscow timezone
FROM debian:bookworm-slim
LABEL maintainer="Vladimir Tananko <v.tananko@gmail.com>"

ARG BUILD_DATE

# Labels
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.description="Debian with GnuPG and dirmngr"
LABEL org.label-schema.name="debian-pgp/bookworm"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.vcs-url="https://github.com/vtananko/debian-pgp/bookworm-slim"
LABEL org.label-schema.vendor="BS-Lab"


ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex; \
    if ! command -v gpg > /dev/null; then \
      sed -i -re "s/(http:\/\/)deb/\1ftp.ru/" \
        /etc/apt/sources.list.d/debian.sources; \
      apt-get update; \
      apt-get install -y --no-install-recommends \
        gnupg \
        dirmngr \
      ; \
      apt-get clean ; \
      rm -rf /var/lib/apt/lists/*; \
    fi

# vim:set ft=dockerfile:
