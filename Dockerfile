ARG ALPINE_IMAGE=alpine
ARG GOLANG_ALPINE_IMAGE=golang:alpine

FROM ${GOLANG_ALPINE_IMAGE} AS builder

ARG SYNCTHING_BRANCH=master
ARG SYNCTHING_REPOSITORY=https://github.com/syncthing/syncthing

ENV CGO_ENABLED=0

WORKDIR /go/src/github.com/syncthing/syncthing

RUN apk add --no-cache git && \
    git clone -b "${SYNCTHING_BRANCH}" "${SYNCTHING_REPOSITORY}" "$(pwd)" && \
    rm -f stdiscosrv && \
    go run build.go -no-upgrade build stdiscosrv

FROM ${ALPINE_IMAGE}

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

CMD [ "su-exec", "stdiscosrv", "stdiscosrv" ]
