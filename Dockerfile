FROM ubuntu:20.04

# Set-up ENV
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install curl gnupg2 ca-certificates lsb-release zip
RUN apt-get update
RUN apt-get install -y curl gnupg2 ca-certificates lsb-release zip

# Install Nginx
RUN apt-get install curl gnupg2 ca-certificates lsb-release zip
RUN echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt-key fingerprint ABF5BD827BD9BF62
RUN apt-get update
RUN apt-get install -y nginx nginx-module-geoip nginx-module-image-filter nginx-module-njs nginx-module-perl nginx-module-xslt

# Config nginx
COPY group2.conf /etc/nginx/conf.d/group2.conf
RUN rm -r /etc/nginx/conf.d/default.conf
	
# Install PHP
RUN apt-get install -y php php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-bz2 php-cgi php-enchant php-gmp php-imap php-intl php-ldap php-pspell php-snmp php-tidy php-xmlrpc php-xsl
RUN sed -i '/^listen =/c\listen = localhost:9000' /etc/php/7.4/fpm/pool.d/www.conf

CMD service nginx restart
CMD service php7.4-fpm restart
