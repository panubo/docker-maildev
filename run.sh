#!/bin/sh

mkdir /var/spool/mail/catchall /var/spool/mail/catchall/cur /var/spool/mail/catchall/new /var/spool/mail/catchall/tmp
chown catchall:catchall -R /var/spool/mail/catchall

exec /bin/s6-svscan "/etc/s6"
