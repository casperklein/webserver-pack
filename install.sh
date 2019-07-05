#!/bin/cat

# APACHE
aptitude install apache2 libapache2-mod-security2
sed -i.bak 's/IncludeOptional sites-enabled\/\*\.conf/IncludeOptional sites-enabled\//g' /etc/apache2/apache2.conf

a2enmod rewrite
a2enmod headers
a2enmod ssl
mkdir /ssl /var/domains

cp sites-available/* /etc/apache2/sites-available/
cp conf-available/*  /etc/apache2/conf-available/

a2enconf z-custom-logs.conf
a2enconf z-custom-security.conf
a2enconf z-custom-ssl.conf

./a2enmod.patch.sh

# Logrotate
cp vhost-logrotate /etc/logrotate.d/

# PHP
curl https://packages.sury.org/php/README.txt

PHPVERSION='7.3'
aptitude install php$PHPVERSION

cp php/* /etc/php

ln -s /etc/php/custom.ini /etc/php/$PHPVERSION/apache2/conf.d/98-custom.ini
ln -s /etc/php/custom-apache.ini /etc/php/$PHPVERSION/apache2/conf.d/99-custom-apache.ini

ln -s /etc/php/custom.ini /etc/php/$PHPVERSION/cli/conf.d/98-custom.ini
ln -s /etc/php/custom-cli.ini /etc/php/$PHPVERSION/cli/conf.d/99-custom-cli.ini

mkdir /var/log/php
touch /var/log/php/error.log
chown www-data: /var/log/php/error.log
