## Using S2I PHP 8.0 version supported by Cirrus as a safe copy
FROM registry.cirrus.ibm.com/ubi8/php-80:latest


## File Author / Maintainer
LABEL org.opencontainers.image.authors=""


## Environment variables
ENV PHP_CONTAINER_SCRIPTS_PATH /usr/share/container-scripts/php/
ENV HTTPD_CONFIGURATION_PATH /opt/app-root/etc/conf.d

## For dnf, must be run as root
USER root
RUN dnf update -y && dnf upgrade -y
RUN dnf install nano iputils net-tools -y
RUN mkdir -p /tmp/src
RUN chmod -R 777 /tmp/src
RUN chmod -R 777 /opt/app-root


## Copy content from GitHub directory to pre-defined HTTPD directory 
COPY . /opt/app-root/src/
RUN chmod -R 777 /opt/app-root


## installation additional packages
RUN dnf install php-pear php-devel -y
RUN pecl channel-update pecl.php.net


## Preparation to run HTTPD and expose network port
RUN chmod -R 777 /run/httpd 
CMD /usr/libexec/s2i/run
EXPOSE 8080
