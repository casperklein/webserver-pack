FROM	debian:10-slim

ENV	PACKAGES="patch git curl"

RUN	apt-get update \
&&	apt-get -y install $PACKAGES \
&&	git clone https://github.com/casperklein/webserver-pack /root/webserver-pack

WORKDIR /root/webserver-pack

# Customize
RUN	sed -i 's/bin\/cat/bin\/bash/g' install.sh \
&&	sed -i 's/aptitude/apt-get -y/g' install.sh \
&&	sed -i 's/^openssl/exit #openssl/' install.sh \
&&	sed -i 's/^DOMAIN=n.*//g' 2do.sh \
&&	sed -i 's/^vi.*//g' 2do.sh \
&&	sed -i 's/^logrotate.*//g' 2do.sh \
&&	sed -i 's/bin\/cat/bin\/bash/g' 2do.sh

RUN ./install.sh

RUN a2dissite 000-default.conf

EXPOSE 80
EXPOSE 443

CMD docker/docker-run.sh
