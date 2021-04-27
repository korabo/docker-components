#!/usr/bin/env bash
RGSTR_SVR_=dflt
# RGSTR_SVR='docker.io'
IMG_NM_=korabo/dvlvm-node
IMG_TG_=centos7.9.2009
DKR_FLNM_=Dockerfile.node
TAR_FLNM_=dflt
PWD_=$PWD

# source variables
SCRIPT_REAL_PATH=$(realpath  "${BASH_SOURCE[0]}")
SCRIPT_DIR="$(dirname "${SCRIPT_REAL_PATH}")"
SCRIPT_NM_="$(basename "${SCRIPT_REAL_PATH}")"
BLD_TOOL="${SCRIPT_DIR}/../build-tool.bash"


# in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
HELP_ON='^(|-h|--help|help)$'
if [[ $1 =~ $HELP_ON ]];then
    . ${BLD_TOOL} vrdo --help ${SCRIPT_NM_}
    exit 0
fi

. ${BLD_TOOL} vrdo $@
