ARG ALPINE_IMAGE=alpine
ARG GOLANG_IMAGE=golang:alpine

FROM ${ALPINE_IMAGE} AS collector

ARG SYNCTHING_BRANCH=master
ARG SYNCTHING_SRC=https://github.com/syncthing/syncthing/archive/${SYNCTHING_BRANCH}.zip
ARG SYNCTHING_SRC_ROOT=syncthing-${SYNCTHING_BRANCH}
ARG SYNCTHING_DEST=/syncthing.zip

ADD "${SYNCTHING_SRC}" "${SYNCTHING_DEST}"

RUN [ -d /syncthing ] || (unzip "${SYNCTHING_DEST}" && mv "${SYNCTHING_SRC_ROOT}" /syncthing)

FROM ${GOLANG_IMAGE} AS builder

ENV CGO_ENABLED=0

COPY --from=collector /syncthing /go/src/github.com/syncthing/syncthing

WORKDIR /go/src/github.com/syncthing/syncthing

RUN go run build.go -no-upgrade build stdiscosrv

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
