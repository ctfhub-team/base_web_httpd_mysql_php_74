FROM php:7.4-apache

LABEL Organization="CTFHUB" Author="Virink <virink@outlook.com>"

ENV TZ=Asia/Shanghai

COPY _files /tmp/

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && apt-get update -y; apt-get install -y net-tools wget mariadb-server; \
    # mysql ext
    docker-php-source extract \
    && docker-php-ext-install mysqli pdo_mysql \
    && docker-php-source delete; \
    # init mysql
    # && sed -i 's/skip-network/#skip-network/' /etc/my.cnf.d/mariadb-server.cnf \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql \
    && sh -c 'mysqld_safe &' \
    && sleep 5s \
    && mysqladmin -uroot password 'root' \
    # Fix: Update all root password
    && mysql -uroot -proot -e "UPDATE mysql.user SET Password=PASSWORD('root') WHERE user='root';" \
    && mysql -uroot -proot -e "create user ping@'%' identified by 'ping';"; \
    # configure file
    cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && sed -i -e 's/display_errors.*/display_errors = Off/' /usr/local/etc/php/php.ini \
    && mv /tmp/flag.sh /flag.sh \
    && mv /tmp/docker-php-entrypoint /usr/local/bin/docker-php-entrypoint \
    && chmod +x /usr/local/bin/docker-php-entrypoint \
    && echo '<?php phpinfo();' > /var/www/html/index.php \
    && chown -R www-data:www-data /var/www/html \
    # clear
    && rm -rf /tmp/*

WORKDIR /var/www/html

EXPOSE 80