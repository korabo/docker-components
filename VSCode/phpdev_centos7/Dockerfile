# CentOS7 with Python, NodeJS, PHP MySQL, etc for develop/deploy
# develop with VSCode

FROM korabo/dvlvm_php:centos7.9.2009

LABEL MAINTAINER="S.TAKEUCHI(KRB/SPG)" version="1.x" updated="see-below" containerid="centos7-vsc-scaru"

ENV _ENVDEF_ phpdev_centos7

EXPOSE          80
EXPOSE          443

USER root

# require php/xdebug => pecl phpize gcc
RUN yum makecache fast\
    && yum install -y \
        php56-php-pecl-xdebug \
        php73-php-pecl-xdebug \
        php74-php-pecl-xdebug \
        php80-php-pecl-xdebug

WORKDIR /home/scaruadmin
USER scaruadmin

# ENTRYPOINT ["/bin/bash",  "-c", "sudo systemctl start httpd ; [ -t 1 ] && bash || sleep infinity"]
ENTRYPOINT ["/bin/bash",  "-c", "[ -t 1 ] && bash || sleep infinity"]

LABEL version="1.4" updated="201016"
