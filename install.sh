#!/bin/cat

aptitude install apache2
a2enmod rewrite
a2enmod headers
a2enmod ssl
mkdir /ssl /var/domains

# APACHE

cp sites-available/* /etc/apache2/sites-available/
./a2enmod.patch.sh


# PHP
cp php/* /etc/php

PHPVERSION='7.3'

ln -s /etc/php/custom.ini /etc/php/$PHPVERSION/apache2/conf.d/98-custom.ini
ln -s /etc/php/custom-apache.ini /etc/php/$PHPVERSION/apache2/conf.d/99-custom-apache.ini

ln -s /etc/php/custom.ini /etc/php/$PHPVERSION/cli/conf.d/98-custom.ini
ln -s /etc/php/custom-cli.ini /etc/php/$PHPVERSION/cli/conf.d/99-custom-cli.ini

mkdir /var/log/php
touch /var/log/php/error.log
chown www-data: /var/log/php/error.log
