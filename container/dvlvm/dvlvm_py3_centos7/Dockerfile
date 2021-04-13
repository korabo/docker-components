# CentOS7 with Python, NodeJS, PHP MySQL, etc for develop/deploy

# https://docs.docker.com/engine/reference/builder/
# https://kappariver.hatenablog.jp/entry/2018/08/12/000919
# https://qiita.com/bezeklik/items/9766003c19f9664602fe

FROM korabo/usrvm:centos7.9.2009

LABEL MAINTAINER="S.TAKEUCHI(KRB/SPG)" containerid="appvm_centos7-dvl"
ENV _ENVDEF_P_ ${_ENVDEF_}:${_ENVDEF_P_}
ENV _ENVDEF_ appvm_centos7-dvl

# Additional packages
USER root


# ###### ------- System Defautl, System Common -------- ##### #

# ARGS
# dflt: dvladmin/dvladmin  1000/1000
ARG USERNAME=dvladmin
ARG USERPASW=dvladmin
ARG USER_GNM=dvladmin
ARG USER_UID=1000
ARG USER_GID=1000
ARG VENV_CFG=.venv_profile
ARG SYS_PYTV=SYS
ARG SYS_PHPV=74
ARG SYS_NODEV=12
ARG MY_PYTV=38
ARG MY_PHPV=74
ARG MY_NODEV=12
ARG MY_PYVENV=dflt
ARG MY_NODEPX=dflt

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

# config venv
# venv profile for appvm-dvl, python36,nodejs12,php74
# venvProfSetup.bash python-version php-version node-version python-venv node-global
RUN set -xe && \
    sudo -u ${USERNAME} bash -ic "/usr/local/sbin/venvProfSetup.bash ${MY_PYTV} ${MY_PHPV} ${MY_NODEV} ${MY_PYVENV} ${MY_NODEPX} >| /home/${USERNAME}/${VENV_CFG}" && \
    for sausr in frnt back job api;do \
        sudo -u ${USERNAME}-${sausr} bash -ic "/usr/local/sbin/venvProfSetup.bash ${MY_PYTV} ${MY_PHPV} ${MY_NODEV} ${MY_PYVENV} ${MY_NODEPX} >| /home/${USERNAME}-${sausr}/${VENV_CFG}" ; \
    done

USER $USERNAME:$USER_GNM
WORKDIR /home/$USERNAME


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

LABEL version-dvl="1.3.1" updated-dvl="20210410"
