# CentOS7 with Python36, Node10, PHP5.6,7.3,7.4,8.0 MySQL, etc for develop

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


# ##### PYTHON36 ##### #

# Install Python36
# https://www.softwarecollections.org/en/scls/rhscl/rh-python36/
# RHEL7
# RUN yum-config-manager --enable rhel-server-rhscl-7-rpms \
#   && yum-config-manager --enable rhel-server-rhscl-beta-7-rpms \
# CentOS7
RUN yum-config-manager --enable centos-sclo-rh-testing \
  && yum install -y rh-python36


# ##### NODEJS ##### #

# RHEL7
# RUN yum-config-manager --enable rhel-server-rhscl-7-rpms \
#   && yum-config-manager --enable rhel-server-rhscl-beta-7-rpms \
# CentOS7
RUN yum-config-manager --enable centos-sclo-rh-testing \
  && yum install -y rh-nodejs10

# set node10 as system default
RUN /bin/cp /opt/rh/rh-nodejs10/enable /etc/profile.d/rh-node10.sh

# ##### PHP ##### #
# yum remove php-*
RUN yum remove -y php-*

# https://qiita.com/bezeklik/items/860ba080bf4c664cd8e9

# ##### PHP56 ##### #
ENV _PHPV_ 56
# yum install --disablerepo=* --enablerepo=epel,remi,remi-safe,remi-php56 php php-mbstring php-mysql php-gd
# COMMON
RUN yum-config-manager --enable remi \
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
RUN yum-config-manager --enable remi \
    && yum install -y \
        php${_PHPV_}-php-{pecl-jsonc,pecl-jsonc-devel}

# ##### PHP73 ##### #
ENV _PHPV_ 73
# COMMON
RUN yum-config-manager --enable remi \
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
RUN yum-config-manager --enable remi \
    && yum install -y \
        php${_PHPV_}-php-json

# ##### PHP74 ##### #
ENV _PHPV_ 74
# COMMON
RUN yum-config-manager --enable remi \
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
RUN yum-config-manager --enable remi \
    && yum install -y \
        php${_PHPV_}-php-json

# ##### PHP80 ##### #
ENV _PHPV_ 80
# COMMON
RUN yum-config-manager --enable remi \
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
RUN yum-config-manager --enable remi \
    && yum install -y \
        php${_PHPV_}-php-json


# set PHP74 as system default
ENV _PHPV_ 74
RUN echo "if [ -f /etc/profile.d/modules.sh ];then" > /etc/profile.d/php${_PHPV_}.sh && \
    echo "  . /etc/profile.d/modules.sh" >> /etc/profile.d/php${_PHPV_}.sh && \
    echo "  module load php${_PHPV_}" >> /etc/profile.d/php${_PHPV_}.sh && \
    echo "fi" >> /etc/profile.d/php${_PHPV_}.sh
# RUN . /etc/profile.d/modules.sh && \
#     module load php${_PHPV_}

# ##### PHP common ##### #
# https://qiita.com/erik_t/items/0b3492f38f6cd8605a4c
RUN . /etc/profile.d/modules.sh && \
    module load php${_PHPV_} && \
    yum-config-manager --enable remi && \
    yum install -y --enablerepo=remi,remi-php74 \
        php-pecl-zip \
        composer \
        php-fedora-autoloader

# update all + remove cache files
RUN yum update -y \
    && yum clean all

# ##### httpdctl ##### #
COPY httpdctl.bash /usr/local/sbin
COPY phpfpmctl.bash /usr/local/sbin
COPY httpdLogView.bash /usr/local/bin
COPY systemctl.bash /usr/local/bin
RUN chmod 0755 /usr/local/sbin/* /usr/local/bin/* && \
    mv /usr/bin/systemctl /usr/bin/systemctl.org && \
    ln -s /usr/local/bin/systemctl.bash /usr/bin/systemctl

# ##### LANG ##### #
# RUN set -xeu && \
#   localectl set-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# ENTRYPOINT ["/bin/bash",  "-c", "[ -t 1 ] && bash || sleep infinity"]
# CMD [ "/usr/local/sbin/httpdctl.bash" ]

LABEL version="1.1" updated="20210403"
