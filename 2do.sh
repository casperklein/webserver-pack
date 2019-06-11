#!/bin/cat

# vHost include -------------------------------------------------------------------------------------------------------

apache2.conf
	# parse all files instead of only *.conf
	IncludeOptional sites-enabled/

# LOGGING -------------------------------------------------------------------------------------------------------------

apache2.conf
	# If you are behind a reverse proxy, you might want to change %h into %{X-Forwarded-For}
	LogFormat "%t [%V:%p] %{X-Forwarded-For}i,%h %u \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" proxy

	# 'combined' extended with vhosts
	LogFormat "%t [%V:%p] %h %u \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" detailed

# SECURITY ------------------------------------------------------------------------------------------------------------

conf-enabled/security.conf
	# will be overwritten by mod_security2
	ServerTokens Full
	# mod_security2
	SecServerSignature "HAL9000"

	# Don't add a line containing the server version and virtual host name to server-generated pages
	ServerSignature Off

	# Disallow TRACE method
	TraceEnable Off

#apt install libapache2-mod-security2
mods-enabled/security2.conf
	disable all stuff

# verify
httpheader localhost

# NEW vHOST -----------------------------------------------------------------------------------------------------------

DOMAIN=newdomain.tld

cd /etc/apache2/sites-available/

cp example.com $DOMAIN
cp example.com-settings $DOMAIN-settings

cd /var/domains
mkdir -pv "$DOMAIN"/logs
mkdir -v "$DOMAIN"/tmp
chmod 770 "$DOMAIN"/logs
chmod 777 "$DOMAIN"/tmp			

# add $DOMAIN
vi /etc/hosts

# logrotate?
