define DOMAIN		example.com
define DOMAIN_PATH	/var/domains/${DOMAIN}
define DOMAIN_SETTINGS	/etc/apache2/sites-available/${DOMAIN}-settings
define DOMAIN_CERT	/ssl/${DOMAIN}.pem

# HTTP
<VirtualHost *:80>
	include ${DOMAIN_SETTINGS}
</VirtualHost>

# HTTPS
#<VirtualHost *:443>
#	# Force TLS for 1 year
#	# Header always set Strict-Transport-Security max-age=31536000
#	include /etc/apache2/sites-available/_sslSettings
#	include ${DOMAIN_SETTINGS}
#</VirtualHost>

# Allowing the use of .htaccess files and access to DocumentRoot
<Directory "${DOMAIN_PATH}">
	Options FollowSymlinks
	AllowOverride All
	Require all granted
</Directory>

# Disallow web access to confidential directorys
<Directory "${DOMAIN_PATH}/logs">
	Require all denied
</Directory>

<Directory "${DOMAIN_PATH}/tmp">
	Require all denied
</Directory>
