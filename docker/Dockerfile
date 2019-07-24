FROM debian

RUN apt-get update
RUN apt-get -y install patch git curl

ADD https://github.com/casperklein/webserver-pack/archive/master.tar.gz /root
WORKDIR /root/
RUN tar xzvf master.tar.gz

WORKDIR /root/webserver-pack-master

# Customize
RUN sed -i 's/bin\/cat/bin\/bash/g' install.sh
RUN sed -i 's/aptitude/apt-get -y/g' install.sh
RUN sed -i 's/^openssl/exit #openssl/' install.sh
RUN sed -i 's/^DOMAIN=n.*//g' 2do.sh
RUN sed -i 's/^vi.*//g' 2do.sh
RUN sed -i 's/^logrotate.*//g' 2do.sh
RUN sed -i 's/bin\/cat/bin\/bash/g' 2do.sh

RUN ./install.sh

RUN a2dissite 000-default.conf

EXPOSE 80
EXPOSE 443

CMD docker/docker-run.sh
