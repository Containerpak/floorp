FROM ubuntu:26.04 AS source

ADD --checksum=sha256:9b2c1bbe985f02a009d8b5294ced411ddf2ff1c9c3b5d83e857635222693c890 https://github.com/Floorp-Projects/Floorp/releases/download/v12.17.0/floorp-linux-x86_64.tar.xz /tmp/app.tar.xz

RUN apt-get update && \
    apt-get install -y --no-install-recommends xz-utils && \
    mkdir -p /out && \
    tar -xJf /tmp/app.tar.xz -C /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/floorp"

COPY --from=source /out/floorp /opt/floorp

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libdbus-glib-1-2 libnss3 libx11-xcb1 libxt6 xdg-utils && \
    ln -sf /opt/floorp/floorp /usr/bin/floorp && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/floorp.png
COPY floorp.desktop /usr/share/applications/floorp.desktop
