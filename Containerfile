FROM ubuntu:26.04 AS source

ADD --checksum=sha256:2f59e332766d8ca5e966cc655450a0f1d3cf6e286f9f52172f8bd3caa7858ffc https://github.com/Floorp-Projects/Floorp/releases/download/v12.17.2/floorp-linux-x86_64.tar.xz /tmp/app.tar.xz

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
