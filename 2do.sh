#!/bin/cat

# SECURITY ------------------------------------------------------------------------------------------------------------

vi /etc/apache2/conf-enabled/security.conf
	# will be overwritten by mod_security2
	ServerTokens Full
	# mod_security2
	SecServerSignature "HAL9000"

	# Don't add a line containing the server version and virtual host name to server-generated pages
	ServerSignature Off

	# Disallow TRACE method
	TraceEnable Off

aptitude install libapache2-mod-security2
vi /etc/apache2/mods-enabled/security2.conf
	disable all stuff

# verify
httpheader localhost

# TLS ---------------------------------------------------------------------------------------------

vi /etc/apache2/mods-enabled/ssl.conf

	# https://bettercrypto.org/

	# enable only secure protocols: SSLv3 and TLSv1, but not SSLv2 and SSLv3
	SSLProtocol All -SSLv2 -SSLv3
	SSLHonorCipherOrder On
	SSLCompression off
	SSLCipherSuite 'EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA256:EECDH:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!IDEA:!ECDSA:kEDH:CAMELLIA128-SHA:AES128-SHA'

	# OCSP Stapling
	SSLStaplingReturnResponderErrors off
	SSLStaplingResponderTimeout 5
	SSLStaplingCache "shmcb:${APACHE_RUN_DIR}/ssl_stapling_cache(512000)"

# NEW vHOST ---------------------------------------------------------------------------------------

DOMAIN=$(curl -s https://www.traceroot.de/hostname)
DOMAIN=newdomain.tld

cd /etc/apache2/sites-available/

# create initial config
cp example.com $DOMAIN
cp example.com-settings $DOMAIN-settings
sed -i "s/example\.com/$DOMAIN/g" $DOMAIN

# adjust settings
vi $DOMAIN $DOMAIN-settings
cd -

# create directory structure
cd /var/domains
mkdir -pv "$DOMAIN"/logs
mkdir -v "$DOMAIN"/tmp
chmod 770 "$DOMAIN"/logs "$DOMAIN"/tmp
chown root: "$DOMAIN"/logs "$DOMAIN"/tmp
chown :www-data "$DOMAIN"/tmp
cd -

# activate site
a2ensite $DOMAIN

# add $DOMAIN
vi /etc/hosts

# logrotate
cp vhost-logrotate /etc/logrotate.d/

# test
logrotate -d /etc/logrotate.d/vhost-logrotate 2>&1 | grep considering
logrotate -d /etc/logrotate.d/vhost-logrotate

# simulate rotate
logrotate -df /etc/logrotate.d/vhost-logrotate

# NEW vHOST TLS -----------------------------------------------------------------------------------

DOMAIN=$(curl -s https://www.traceroot.de/hostname)
DOMAIN=newdomain.tld

# request certificate
git clone https://github.com/Neilpang/acme.sh
cd acme.sh
./acme.sh --issue -d $DOMAIN --webroot /var/domains/$DOMAIN

# create PEM file suitable for apache
cat ~/.acme.sh/$DOMAIN/fullchain.cer ~/.acme.sh/$DOMAIN/$DOMAIN.key > /ssl/$DOMAIN.pem

cd /etc/apache2/sites-available/
vi $DOMAIN $DOMAIN-settings
