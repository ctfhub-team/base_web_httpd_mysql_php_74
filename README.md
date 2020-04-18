# 基础镜像 WEB Httpd Mariadb PHP 7.4

- L: Linux
- A: Apache Httpd
- M: MySQL - Mariadb
- P: PHP 7.4
- PHP MySQL Ext
    + mysql
    + mysqli

## Example

TODO:

## Usage

### Conf

- apache /etc/apache2/
- php /usr/local/etc/php/php.ini

### ENV

- FLAG=ctfhub{httpd_mysql_php_74}

You should rewrite flag.sh when you use this image.
The `$FLAG` is not mandatory, but i hope you use it!

### Files

- src 网站源码
    + db.sql **This file should be use in Dockerfile**
    + index.php
    + ...etc
- Dockerfile
- docker-compose.yml

#### db.sql

You should create database and user!

```sql
DROP DATABASE IF EXISTS `ctfhub`;
CREATE DATABASE ctfhub;
GRANT SELECT,INSERT,UPDATE,DELETE on ctfhub.* to ctfhub@'127.0.0.1' identified by 'ctfhub';
GRANT SELECT,INSERT,UPDATE,DELETE on ctfhub.* to ctfhub@localhost identified by 'ctfhub';
use ctfhub;

-- create table...
```

### Dockerfile

```
FROM ctfhub/base_web_httpd_mysql_php_74

COPY src /var/www/html
COPY _files/flag.sh /flag.sh

RUN sh -c 'mysqld_safe &' \
    && sleep 5s \
    && mysql -uroot -proot -e "source /var/www/html/db.sql" \
    && rm -f /var/www/html/db.sql
```

