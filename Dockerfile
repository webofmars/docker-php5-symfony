# vim:set ft=dockerfile:
FROM debian:jessie

MAINTAINER webofmars <contact@webofmars.com>

#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E9C74FEEA2098A6E && \
    #echo "deb http://packages.dotdeb.org/ jessie-php55 all" > /etc/apt/sources.list.d/php.list && \
    #echo "deb http://ftp.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list.d/php.list
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        php5-cli \
        php5-xdebug \
        php5-imagick \
        php5-gd \
        php5-mongo \
        php5-curl \
        php5-mcrypt \
        php5-intl \
        php5-mysqlnd \
        php5-sqlite \
        php5-redis \
        php5-pgsql \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl git && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS -k https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY php-extra.ini /etc/php5/mods-available/extra.ini
RUN php5enmod extra
COPY entrypoint.sh /root/entrypoint.sh
RUN chown root:root /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

VOLUME "/var/www"
WORKDIR "/var/www"

ENTRYPOINT ["/root/entrypoint.sh"]
EXPOSE 8000