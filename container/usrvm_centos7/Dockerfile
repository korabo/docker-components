# CentOS7 with Python, NodeJS, PHP MySQL, etc for develop/deploy

# https://docs.docker.com/engine/reference/builder/
# https://kappariver.hatenablog.jp/entry/2018/08/12/000919
# https://qiita.com/bezeklik/items/9766003c19f9664602fe

FROM korabo/appvm:centos7.9.2009

LABEL MAINTAINER="S.TAKEUCHI(KRB/SPG)" containerid="appvm_centos7-usr"
# ENV container docker
ENV _ENVDEF_P_ ${_ENVDEF_}:${_ENVDEF_P_}
ENV _ENVDEF_ appvm_centos7-usr
# ARGS
ARG dvlusr='dvladmin'

# set TIMEZONE
RUN  set -xeu && \
  echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock && \
  echo 'UTC=true' >> /etc/sysconfig/clock && \
  ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime


# group sudoers
# user /  1000/1000/500 for VSCode
RUN set -xeu && \
    groupadd -g 500 dvl-sudoers && \
    groupadd -g 1000 ${dvlusr} && \
    useradd -u 1000 -g ${dvlusr} -G adm,video,dvl-sudoers -d /home/${dvlusr} -s /bin/bash -m ${dvlusr} && \
    echo ${dvlusr} | passwd --stdin ${dvlusr} && \
    echo '%dvl-sudoers ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/dvl_sudoers && \
    chmod 0440 /etc/sudoers.d/dvl_sudoers

# add each service account for dev, runtime
RUN set -xeu && \
    _uid_=1001 && \
    for sausr in frnt back job api;do \
        useradd -o -u ${_uid_} -g 1000  -G adm,video,dvl-sudoers -c "${dvlusr}-${sausr} role account" -d /home/${dvlusr}-${sausr} -s /bin/bash -m ${dvlusr}-${sausr} ; \
        _uid_=$((_uid_ + 1)) ; \
    done

VOLUME [ "/sys/fs/cgroup" ]

# set locale
RUN yum reinstall -y glibc-common && yum clean all
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# config profile to $HOME/.bash_profile
RUN set -xe && \
    echo "# venv profile" >| /tmp/.venv_profile && \
    echo "[ -f ~/.venv_profile ] && . ~/.venv_profile" > /tmp/.bash_profile && \
    sudo -u ${dvlusr} bash -c "cat /tmp/.venv_profile >| /home/${dvlusr}/.venv_profile" && \
    sudo -u ${dvlusr} bash -c "cat /tmp/.bash_profile >> /home/${dvlusr}/.bash_profile" && \
    for sausr in frnt back job api;do \
        sudo -u ${dvlusr}-${sausr} bash -c "cat /tmp/.venv_profile >| /home/${dvlusr}-${sausr}/.venv_profile" ; \
        sudo -u ${dvlusr}-${sausr} bash -c "cat /tmp/.bash_profile >> /home/${dvlusr}-${sausr}/.bash_profile" ; \
    done

# clear /tmp
RUN set -xeu && \
    cd /tmp && \
    ls -A1 | xargs /bin/rm -rf

COPY venvProfSetup.bash /usr/local/sbin
RUN chmod 0755 /usr/local/sbin/*

WORKDIR /home/${dvlusr}
USER ${dvlusr}

LABEL version-usr="1.3.1" updated-usr="20210410"
