#!/bin/bash
apachectl start
./2do.sh

DOMAIN=$(curl -s https://www.traceroot.de/hostname)
patch /etc/apache2/sites-available/$DOMAIN -i docker/docker-ssl.patch

apachectl restart

find /var/domains/ -name '*.log' -not -name '*gz' -print0 | xargs -0 tail -F

exit
while :; do
	sleep 1
	echo -n .
done
