#!/usr/bin/env bash

set -e

SPOOL_DIR="$(postconf mail_spool_directory | sed -E 's/.*= (.*)/\1/')"

mkdir -p ${SPOOL_DIR}/catchall ${SPOOL_DIR}/catchall/cur ${SPOOL_DIR}/catchall/new ${SPOOL_DIR}/catchall/tmp
chown catchall:catchall -R ${SPOOL_DIR}/catchall

# Generate snakeoil certs
dpkg-reconfigure -f noninteractive ssl-cert

exec /usr/bin/s6-svscan "/etc/s6"
