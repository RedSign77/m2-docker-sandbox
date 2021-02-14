FROM debian:buster-slim

RUN apt-get update && apt-get install -y apache2=2.4.38-3+deb10u4

RUN a2enmod rewrite headers proxy_fcgi

EXPOSE 80 443

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]