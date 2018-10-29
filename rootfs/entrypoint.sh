#!/bin/sh

set -euo pipefail

addgroup -g "${STDISCOSRV_GID}" stdiscosrv
adduser -h "${STDISCOSRV_HOME}" -g stdiscosrv -s /sbin/nologin -G stdiscosrv -D -u "${STDISCOSRV_UID}" stdiscosrv
cd "${STDISCOSRV_HOME}"
exec su-exec stdiscosrv stdiscosrv "${@}"
