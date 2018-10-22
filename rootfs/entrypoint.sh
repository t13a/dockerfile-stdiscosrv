#!/bin/sh

set -euo pipefail

if [ -z "${NO_INIT_USER:-}" ]
then
    addgroup -g "${STDISCOSRV_GID}" stdiscosrv
    adduser -h "${STDISCOSRV_HOME}" -g stdiscosrv -s /sbin/nologin -G stdiscosrv -D -u "${STDISCOSRV_UID}" stdiscosrv
fi

cd "${STDISCOSRV_HOME}"

"${@}"
