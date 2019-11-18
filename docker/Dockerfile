FROM	debian:10-slim as build

ENV	USER="casperklein"
ENV	NAME="webserver-pack"
ENV	VERSION="latest"

ENV	PACKAGES="patch git curl"

RUN	apt-get update \
&&	apt-get -y install $PACKAGES \
&&	git clone https://github.com/casperklein/webserver-pack /root/webserver-pack

WORKDIR /root/webserver-pack

# Customize
RUN	sed -i 's/bin\/cat/bin\/bash/g' setup.sh \
&&	sed -i 's/aptitude/apt-get -y/g' setup.sh \
&&	sed -i 's/^openssl/exit #openssl/' setup.sh \
&&	sed -i 's/^DOMAIN=n.*//g' vhost.sh \
&&	sed -i 's/^vi.*//g' vhost.sh \
&&	sed -i 's/^logrotate.*//g' vhost.sh \
&&	sed -i 's/bin\/cat/bin\/bash/g' vhost.sh

RUN ./setup.sh

RUN a2dissite 000-default.conf


# Final image
RUN	apt-get -y install dumb-init \
&&	rm -rf /var/lib/apt/lists/*
FROM	scratch
COPY	--from=build / /
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

EXPOSE 80
EXPOSE 443

WORKDIR /root/webserver-pack
CMD	docker/docker-run.sh
