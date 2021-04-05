# CentOS7 on user dvladmin with Python36, Node10, PHP7.3 7.4 8.0, MySQL, etc for develop

# https://docs.docker.com/engine/reference/builder/
# https://kappariver.hatenablog.jp/entry/2018/08/12/000919
# https://qiita.com/bezeklik/items/9766003c19f9664602fe
# https://www.saintsouth.net/blog/update-libstdcpp-on-centos6/

FROM korabo/usrvm:centos7.9.2009

LABEL MAINTAINER="S.TAKEUCHI(KRB/SPG)" version="see-label" updated="see-label" containerid="appvm_centos7-dvl"
ARG dvlusr='dvladmin'
ENV _ENVDEF_ appvm_centos7-dvl

USER root

# Image Magic + JPeg

RUN yum makecache fast\
    && yum install -y \
        ImageMagick ImageMagick-devel \
        lcms2 openjpeg2 \
    && yum clean all


# Ghost Script

RUN yum makecache fast\
    && yum install -y \
        ghostscript ghostscript-devel ghostscript-fonts \
    && yum clean all

# ##### PHP56 ##### #
ENV _PHPV_ 56
RUN yum-config-manager --enable remi \
    && yum install -y \
        php${_PHPV_}-php-pecl-imagick

# ##### PHP73 ##### #
ENV _PHPV_ 73
RUN yum-config-manager --enable remi \
    && yum install -y \
        php${_PHPV_}-php-pecl-imagick

# ##### PHP74 ##### #
ENV _PHPV_ 74
RUN yum-config-manager --enable remi \
    && yum install -y \
        php${_PHPV_}-php-pecl-imagick

# ##### PHP80 ##### #
ENV _PHPV_ 80
RUN yum-config-manager --enable remi \
    && yum install -y \
        php${_PHPV_}-php-pecl-imagick

# use dvladmin/svladmin  1000/1000
ARG USERNAME=${dvlusr}
ARG USERPASW=${dvlusr}
ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_GNM=${dvlusr}
ARG _CFGF_=.venv_profile

USER $USERNAME:$USER_GNM
WORKDIR /home/$USERNAME

# venv profile for appvm-dvl, python36,nodejs10,phpXX
ENV _PHPV_ 74
RUN set -xeu && \
  echo "#venv profile for dvlvm_centos7, python36,nodejs10,php${_PHPV_}" >| ${_CFGF_} && \
  echo "source scl_source enable rh-python36" >> ${_CFGF_} && \
  echo "source scl_source enable rh-nodejs10" >> ${_CFGF_} && \
  echo "PHPV=${_PHPV_}" >> ${_CFGF_} && \
  echo "[ -f /etc/profile.d/modules.sh ] && . /etc/profile.d/modules.sh && module load php\${PHPV}" >> ${_CFGF_}

# # ##### LANG ##### #
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

# ENTRYPOINT ["sudo", "/bin/bash", "-c", "[ -t 1 ] && bash || exec"]
# ENTRYPOINT ["/bin/bash",  "-c", "[ -t 1 ] && bash || sleep infinity"]
# CMD [ "/usr/local/sbin/httpdctl.bash" ]
# ENTRYPOINT ["/bin/bash",  "-c", "sudo /usr/local/sbin/httpdctl.bash && [ -t 1 ] && bash || sleep infinity"]


# # If you’re using PHP-FPM :
# phpfpmctl restart

LABEL version="1.0" updated="20210405"
