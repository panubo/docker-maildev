FROM quay.io/panubo/postfix:1.6

# Install packages
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    bsd-mailx \
    apache2 \
    libapache2-mod-php \
    php-dom \
    php-imap \
    php-mbstring \
    php-sqlite3 \
    php-intl \
    libmail-imapclient-perl \
    libio-socket-ssl-perl \
    libdatetime-format-mail-perl \
    libgetopt-long-descriptive-perl \
    bzip2 \
    cron \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  ;

ENV MAILNAME maildev.example.com

COPY recipient_canonical_map /etc/postfix/recipient_canonical_map
COPY s6/dovecot /etc/s6/dovecot
COPY s6/apache2 /etc/s6/apache2
COPY s6/cron /etc/s6/cron
COPY mail.rc /etc/mail.rc
COPY dovecot.conf /etc/dovecot/local.conf

EXPOSE 143 110 80
VOLUME ["/var/mail"]

RUN set -x \
  && useradd -G mail -m catchall \
  && echo "catchall:password" | chpasswd \
  && postconf -e mail_spool_directory="/var/mail/" \
  && postconf -e smtpd_tls_received_header="yes" \
  && postconf -e recipient_canonical_classes="envelope_recipient" \
  && postconf -e recipient_canonical_maps="regexp:/etc/postfix/recipient_canonical_map" \
  && postconf -X mailbox_command \
  && echo "ssl = no" > /etc/dovecot/conf.d/10-ssl.conf \
  ;

ENV ROUNDCUBE_VERSION 1.6.5

RUN set -x \
  && rm /var/www/html/index.html \
  && curl -L "https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz" | tar -C /var/www/html --strip-components 1 -zx \
  && a2enmod rewrite deflate headers expires \
  ;

RUN set -x \
  && curl -L 'http://downloads.sourceforge.net/project/imaputils/imaputils.v-0.2.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fimaputils%2Ffiles%2F%3Fsource%3Dnavbar&ts=1458785865&use_mirror=heanet' | tar -C /usr/local/bin --strip-components 1 -jx imaputils.v-0.2/imaputils.pl \
  && chmod +x /usr/local/bin/imaputils.pl \
  ;

COPY htaccess /var/www/html/.htaccess
COPY roundcube.inc.php /var/www/html/config/config.inc.php
COPY autologon.php /var/www/html/plugins/autologon/autologon.php
COPY apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY crontab /etc/cron.d/maildev
COPY run.sh /run.sh

RUN set -x \
  && chmod 644 /etc/cron.d/maildev \
  ;

CMD ["/run.sh"]
