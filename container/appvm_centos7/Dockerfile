# CentOS7 with Python, NodeJS, PHP MySQL, etc for develop/deploy

# https://kappariver.hatenablog.jp/entry/2018/08/12/000919
# https://qiita.com/bezeklik/items/9766003c19f9664602fe
# https://www.saintsouth.net/blog/update-libstdcpp-on-centos6/

# centos7 image: https://hub.docker.com/_/centos
FROM centos:7.9.2009

LABEL MAINTAINER="S.TAKEUCHI(KRB/SPG)" version="see-label" updated="see-label" containerid="appvm_centos7"

ENV container docker
ENV _ENVDEF_ app-vm_centos7

# Refresh yum database
RUN echo "timeout=60" >> /etc/yum.conf \
    && yum makecache fast

# Install Alt Repos
RUN yum install -y \
        epel-release \
        https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
        centos-release-scl-rh \
        centos-release-scl \
        yum-utils \
        scl-utils \
    && yum-config-manager --enable centos-sclo-rh-testing \
    && yum-config-manager --enable remi

# install deltarpm
RUN yum install -y deltarpm

# Install packages needed

RUN yum -y groupinstall "Development Tools" \
        --setopt=group_package_types=mandatory,default

RUN yum install -y \
        sudo ntp wget vim-common vim-enhanced vim-minimal \
        unzip zip vixie-cron iftop bc \
        lsof rrdtool screen nkf expect \
        unar mailcap glibc-common m4 hg


RUN yum install -y \
        libicu libtool-ltdl mcrypt unixODBC aspell net-snmp net-snmp-utils libtidy libxslt


# httpd 2.4.6 on CentOS7 from base

RUN yum install -y \
      httpd httpd-devel httpd-tools mod_ssl

# MySQL5.7
# add repo for mysql-community
RUN yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm \
    && yum-config-manager --disable mysql80-community \
    && yum-config-manager  --enable mysql57-community

RUN yum install -y \
        mysql-community-server mysql-community-devel

# Nfs, etc

RUN yum install -y \
        nfs-utils nfs-utils-lib


# SCL
# https://www.softwarecollections.org/en/scls/rhscl/rh-python36/
# RHEL7
# RUN yum-config-manager --enable rhel-server-rhscl-7-rpms \
#   && yum-config-manager --enable rhel-server-rhscl-beta-7-rpms \
# CentOS7
# RUN yum-config-manager --enable centos-sclo-rh-testing \


# ##### PYTHON ##### #

### Python36 ###
ENV _PYTV_ 36
RUN yum-config-manager --enable centos-sclo-rh-testing \
  && yum install -y rh-python${_PYTV_}

### Python38 ###
ENV _PYTV_ 38
RUN yum-config-manager --enable centos-sclo-rh-testing \
  && yum install -y rh-python${_PYTV_}

# ##### NODEJS ##### #

### Nodejs10 ###
ENV _NDJV_ 10
RUN yum-config-manager --enable centos-sclo-rh \
  && yum install -y rh-nodejs${_NDJV_}

### Nodejs12 ###
ENV _NDJV_ 12
RUN yum-config-manager --enable centos-sclo-rh \
  && yum install -y rh-nodejs${_NDJV_}

### Nodejs14 ###
ENV _NDJV_ 14
RUN yum-config-manager --enable centos-sclo-rh \
  && yum install -y rh-nodejs${_NDJV_}

# ##### PHP ##### #
# yum remove php-*
RUN yum remove -y php-*

# https://qiita.com/bezeklik/items/860ba080bf4c664cd8e9

# ##### PHP56 ##### #
ENV _PHPV_ 56
# yum install --disablerepo=* --enablerepo=epel,remi,remi-safe,remi-php56 php php-mbstring php-mysql php-gd
# COMMON
RUN yum-config-manager --enable remi-php${_PHPV_} \
    && yum install -y \
        php${_PHPV_} \
        php${_PHPV_}-php \
        php${_PHPV_}-php-{cli,common,devel} \
        php${_PHPV_}-php-{gd,xml,mbstring,mysqlnd} \
        php${_PHPV_}-php-{pdo,pear,process,tidy} \
        php${_PHPV_}-php-{opcache,pecl-apcu,pecl-memcached,pecl-zip} \
        php${_PHPV_}-php-fpm
# FPM: PHP5.x: change process manager + listen port for php-pfm
RUN set -xeu && \
    sed -i '/pm = /s/dynamic/ondemand/' /etc/opt/remi/php${_PHPV_}/php-fpm.d/www.conf && \
    sed -i "s/9000/90${_PHPV_}/" /etc/opt/remi/php${_PHPV_}/php-fpm.d/www.conf
    # sed -i '/pm = /s/dynamic/ondemand/' /opt/remi/php${_PHPV_}/root/etc/php-fpm.d/www.conf && \
    # sed -i "s/9000/90${_PHPV_}/" /opt/remi/php${_PHPV_}/root/etc/php-fpm.d/www.conf
# PHP56 only
RUN yum-config-manager --enable remi-php${_PHPV_} \
    && yum install -y \
        php${_PHPV_}-php-{pecl-jsonc,pecl-jsonc-devel}

# ##### PHP73 ##### #
ENV _PHPV_ 73
# COMMON
RUN yum-config-manager --enable remi-php${_PHPV_} \
    && yum install -y \
        php${_PHPV_} \
        php${_PHPV_}-php \
        php${_PHPV_}-php-{cli,common,devel} \
        php${_PHPV_}-php-{gd,xml,mbstring,mysqlnd} \
        php${_PHPV_}-php-{pdo,pear,process,tidy} \
        php${_PHPV_}-php-{opcache,pecl-apcu,pecl-memcached,pecl-zip} \
        php${_PHPV_}-php-fpm
# FPM: PHP7.x: change process manager + listen port for php-fpm
RUN set -xeu && \
    sed -i '/pm = /s/dynamic/ondemand/' /etc/opt/remi/php${_PHPV_}/php-fpm.d/www.conf && \
    sed -i "s/9000/90${_PHPV_}/" /etc/opt/remi/php${_PHPV_}/php-fpm.d/www.conf
# PHP7x only
RUN yum-config-manager --enable remi-php${_PHPV_} \
    && yum install -y \
        php${_PHPV_}-php-json

# ##### PHP74 ##### #
ENV _PHPV_ 74
# COMMON
RUN yum-config-manager --enable remi-php${_PHPV_} \
    && yum install -y \
        php${_PHPV_} \
        php${_PHPV_}-php \
        php${_PHPV_}-php-{cli,common,devel} \
        php${_PHPV_}-php-{gd,xml,mbstring,mysqlnd} \
        php${_PHPV_}-php-{pdo,pear,process,tidy} \
        php${_PHPV_}-php-{opcache,pecl-apcu,pecl-memcached,pecl-zip} \
        php${_PHPV_}-php-fpm
# FPM: PHP7.x: change process manager + listen port for php-fpm
RUN set -xeu && \
    sed -i '/pm = /s/dynamic/ondemand/' /etc/opt/remi/php${_PHPV_}/php-fpm.d/www.conf && \
    sed -i "s/9000/90${_PHPV_}/" /etc/opt/remi/php${_PHPV_}/php-fpm.d/www.conf
# PHP7x only
RUN yum-config-manager --enable remi-php${_PHPV_} \
    && yum install -y \
        php${_PHPV_}-php-json

# ##### PHP80 ##### #
ENV _PHPV_ 80
# COMMON
RUN yum-config-manager --enable remi-php${_PHPV_} \
    && yum install -y \
        php${_PHPV_} \
        php${_PHPV_}-php \
        php${_PHPV_}-php-{cli,common,devel} \
        php${_PHPV_}-php-{gd,xml,mbstring,mysqlnd} \
        php${_PHPV_}-php-{pdo,pear,process,tidy} \
        php${_PHPV_}-php-{opcache,pecl-apcu,pecl-memcached,pecl-zip} \
        php${_PHPV_}-php-fpm
# FPM: PHP8.x: change process manager + listen port for php-fpm
RUN set -xeu && \
    sed -i '/pm = /s/dynamic/ondemand/' /etc/opt/remi/php${_PHPV_}/php-fpm.d/www.conf && \
    sed -i "s/9000/90${_PHPV_}/" /etc/opt/remi/php${_PHPV_}/php-fpm.d/www.conf
# PHP8x only
RUN yum-config-manager --enable remi-php${_PHPV_} \
    && yum install -y \
        php${_PHPV_}-php-json


# ##### /usr/loca/{bin,sbin} systemctl,httpdctl,phpfpmctl,httpdLogView,phpProfSetup ##### #
COPY httpdctl.bash /usr/local/sbin
COPY phpfpmctl.bash /usr/local/sbin
COPY httpdLogView.bash /usr/local/bin
COPY systemctl.bash /usr/local/bin
COPY phpProfSetup.bash /usr/local/sbin
RUN chmod 0755 /usr/local/sbin/* /usr/local/bin/* && \
    mv /usr/bin/systemctl /usr/bin/systemctl.org && \
    ln -s /usr/local/bin/systemctl.bash /usr/bin/systemctl


# ###### ------- System Defautl, System Common -------- ##### #

# ARGS
ARG SYS_PYTV=SYS
ARG SYS_PHPV=74
ARG SYS_NODEV=12

# set PythonXX as system default, after remove old profile: use system default, cause yum use python2
ENV _PYTV_ ${SYS_PYTV}
RUN set -xe && \
    /bin/rm -f /etc/profile.d/rh-python*.sh && \
    if [ "${_PYTV_}" != "SYS" ];then /bin/cp /opt/rh/rh-python${_PYTV_}/enable /etc/profile.d/rh-python${_PYTV_}.sh; fi

# set PHPxx as system default, after remove old profile
ENV _PHPV_ ${SYS_PHPV}
RUN set -xe && \
    /bin/rm -f /etc/profile.d/php*.sh && \
    if [ "${_PHPV_}" != "SYS" ];then bash /usr/local/sbin/phpProfSetup.bash ${_PHPV_} >| /etc/profile.d/php${_PHPV_}.sh; fi

# set nodeXX as system default, after remove old profile
ENV _NDJV_ ${SYS_NODEV}
RUN set -xe && \
    /bin/rm -f /etc/profile.d/rh-node*.sh && \
    if [ "${_NDJV_}" != "SYS" ];then /bin/cp /opt/rh/rh-nodejs${_NDJV_}/enable /etc/profile.d/rh-node${_NDJV_}.sh; fi

# ##### PHP common ##### #
# https://qiita.com/erik_t/items/0b3492f38f6cd8605a4c
# php-pecl-zip Release 1.19.2:	PHP Version: PHP 5.4.0 or newer PEAR Package: PEAR 1.7.0 or newer
RUN . /etc/profile.d/php${_PHPV_}.sh && \
    yum-config-manager --enable remi-php${_PHPV_} && \
    yum install -y \
        php-pecl-zip \
        composer \
        php-fedora-autoloader

# update all + remove cache files
RUN yum update -y \
    && yum clean all

# ##### LANG ##### #
# RUN set -xeu && \
#   localectl set-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# ENTRYPOINT ["/bin/bash",  "-c", "[ -t 1 ] && bash || sleep infinity"]
# CMD [ "/usr/local/sbin/httpdctl.bash" ]

LABEL version="1.3" updated="20210409" collections="Python 36,38 NodeJS 10,12,14 PHP 56,73,74,80 MySQL 57"
