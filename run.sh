#!/bin/sh

SPOOL_DIR="$(postconf mail_spool_directory | sed -E 's/.*= (.*)/\1/')"

mkdir ${SPOOL_DIR}/catchall ${SPOOL_DIR}/catchall/cur ${SPOOL_DIR}/catchall/new ${SPOOL_DIR}/catchall/tmp
chown catchall:catchall -R ${SPOOL_DIR}/catchall

exec /usr/local/bin/s6-svscan "/etc/s6"
