#!/bin/cat

# New vHost ---------------------------------------------------------------------------------------

DOMAIN=$(curl -s https://www.traceroot.de/hostname)
DOMAIN=newdomain.tld

cd /etc/apache2/sites-available/

# create initial config
cp example.com $DOMAIN
cp example.com-settings $DOMAIN-settings
sed -i "s/example\.com/$DOMAIN/g" $DOMAIN

# adjust settings
vi $DOMAIN $DOMAIN-settings

# create directory structure
cd /var/domains
mkdir -pv "$DOMAIN"/logs
mkdir -v "$DOMAIN"/tmp
chmod 770 "$DOMAIN"/logs "$DOMAIN"/tmp
chown root: "$DOMAIN"/logs "$DOMAIN"/tmp
chown :www-data "$DOMAIN"/tmp

# add default content
echo 'hello world' > "$DOMAIN"/index.html

# activate site
a2ensite $DOMAIN
apachectl reload

# add $DOMAIN
vi /etc/hosts

# test logrotate
logrotate -d /etc/logrotate.d/vhost-logrotate 2>&1 | grep considering
logrotate -d /etc/logrotate.d/vhost-logrotate

# simulate rotate
logrotate -df /etc/logrotate.d/vhost-logrotate

# Add HTTPS support -----------------------------------------------------------------------------------

DOMAIN=$(curl -s https://www.traceroot.de/hostname)
DOMAIN=newdomain.tld

# request certificate
git clone https://github.com/Neilpang/acme.sh
cd acme.sh
./acme.sh --issue -d $DOMAIN --webroot /var/domains/$DOMAIN

# create PEM file suitable for apache
cat ~/.acme.sh/$DOMAIN/fullchain.cer ~/.acme.sh/$DOMAIN/$DOMAIN.key > /ssl/$DOMAIN.pem

# create PEM file suitable for apache with own DH prime
cat ~/.acme.sh/$DOMAIN/fullchain.cer ~/.acme.sh/$DOMAIN/$DOMAIN.key /ssl/dhparams.pem > /ssl/$DOMAIN.pem

# enable HTTPS
cd /etc/apache2/sites-available/
vi $DOMAIN $DOMAIN-settings
apachectl configtest && service apache2 restart
