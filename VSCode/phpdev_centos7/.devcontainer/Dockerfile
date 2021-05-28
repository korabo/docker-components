# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.159.0/containers/php/.devcontainer/base.Dockerfile

ARG DK_IMG=korabo/dvlvm-lampx-user
ARG DK_TAG=centos7.9.2009
FROM ${DK_IMG}:${DK_TAG}

# [Python:Option] version: 36,38 / venv dir
ARG PY_VERSION="sys"
ARG PY_VENV="nop"
# [PHP:Option] version: no,80,74,73,56
ARG PHP_VERSION="74"
# [NODE:Option] version: 10,12,14 / Install global
ARG NODE_VERSION="14"
ARG NPM_PRFX=dflt
ARG NODE_GLOBALS="pnpm"
# [Java:Option] version: 1.8.0,11
ARG JAVA_VERSION="sys"

# UserEnv
# userEnvSet.bash -p -r venv-prof bash_prof V.python  venv V.php V.nodejs npmprefix V.java
RUN set -xeu && \
    /usr/local/sbin/userEnvSet.bash -r dflt dflt ${PY_VERSION} ${PY_VENV} ${PHP_VERSION} ${NODE_VERSION} ${NPM_PRFX} ${JAVA_VERSION}

# [Optional] Uncomment this line to install global node packages.
RUN set -xe && \
    . ~/.bash_profile && \
    for gmodu in ${NODE_GLOBALS};do \
        npm install --global ${gmodu}; \
    done

# [Optional] Uncomment this section to install additional OS packages.
# Install xdebug
RUN sudo yum makecache fast\
    && sudo yum install -y \
        php${PHP_VERSION}-php-pecl-xdebug

# RUN    echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini

# Open port: http https phpfpm
EXPOSE          80
EXPOSE          443
EXPOSE          9000
EXPOSE          90${PHP_VERSION}

# WORKDIR /home/dvladmin
# USER dvladmin

# ENTRYPOINT ["/bin/bash",  "-c", "sudo systemctl start httpd ; [ -t 1 ] && bash || sleep infinity"]
ENTRYPOINT ["/bin/bash",  "-c", "[ -t 1 ] && bash -l || sleep infinity"]

LABEL version="1.5.0" updated="20200428"
