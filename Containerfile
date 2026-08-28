FROM ubuntu:26.04 AS source

ADD --checksum=sha256:db68ff2857f6f5dce83ed1903309a54503269a3829569f08ddaf629d77d428ee https://github.com/Floorp-Projects/Floorp/releases/download/v12.17.1/floorp-linux-x86_64.tar.xz /tmp/app.tar.xz

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
