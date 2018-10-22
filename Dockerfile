FROM golang:alpine AS builder

ARG SYNCTHING_BRANCH=v0.14.51
ARG SYNCTHING_REPOSITORY=https://github.com/syncthing/syncthing

ENV CGO_ENABLED=0

WORKDIR /go/src/github.com/syncthing/syncthing

RUN apk add --no-cache git && \
    git clone -b "${SYNCTHING_BRANCH}" "${SYNCTHING_REPOSITORY}" "$(pwd)" && \
    rm -f stdiscosrv && \
    go run build.go -no-upgrade build stdiscosrv

FROM alpine

ENV STDISCOSRV_USER=stdiscosrv
ENV STDISCOSRV_UID=1000
ENV STDISCOSRV_GID=1000
ENV STDISCOSRV_HOME=/stdiscosrv

COPY --from=builder /go/src/github.com/syncthing/syncthing/stdiscosrv /usr/local/bin/stdiscosrv
COPY /rootfs /

RUN apk add --no-cache \
    ca-certificates \
    su-exec

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "su-exec", "stdiscosrv", "/usr/local/bin/stdiscosrv" ]
