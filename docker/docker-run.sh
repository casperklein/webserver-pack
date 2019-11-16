#!/bin/bash
apachectl start
./2do.sh

DOMAIN=$(curl -s https://www.traceroot.de/hostname)
patch /etc/apache2/sites-available/$DOMAIN -i docker/docker-ssl.patch

apachectl restart

echo "###############################################################"
echo "Apache is now serving:"
echo
echo "http://$DOMAIN"
echo "https://$DOMAIN"
echo "###############################################################"

find /var/domains/ -name '*.log' -not -name '*gz' -print0 | xargs -0 tail -F
