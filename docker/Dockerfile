FROM debian

#RUN mkdir /tmp/webserver
RUN apt-get update
RUN apt-get -y install patch git curl #install curl #git
#COPY / /tmp/webserver/

#RUN git clone https://github.com/casperklein/webserver-pack
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
#RUN sed -i 's/^# Add HTTPS.*/exit/g' 2do.sh
RUN sed -i 's/bin\/cat/bin\/bash/g' 2do.sh

ADD docker-ssl.patch /root/webserver-pack-master
#RUN sed -i 's/^# Add HTTPS.*/exit/g' 2do.sh
#RUN patch /root/webserver-pack-master/sites-available/example.com -i example.patch

RUN ./install.sh

#RUN apachectl start
#RUN ./2do.sh
RUN a2dissite 000-default.conf

#ENTRYPOINT ["apachectl", "-D", "FOREGROUND"] #-D FOREGROUND
EXPOSE 80
EXPOSE 443
#CMD ["apachectl", "-D", "FOREGROUND"] #-D FOREGROUND

ADD docker-run.sh /root/webserver-pack-master
CMD ./docker-run.sh
