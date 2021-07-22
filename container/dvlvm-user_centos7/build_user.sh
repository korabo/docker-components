#!/usr/bin/env bash
# source variables
SCRIPT_REAL_PATH=$(realpath  "${BASH_SOURCE[0]}")
SCRIPT_DIR="$(dirname "${SCRIPT_REAL_PATH}")"
SCRIPT_NM_="$(basename "${SCRIPT_REAL_PATH}")"
BLD_TOOL="${SCRIPT_DIR}/../build-tool.bash"
[[ -f ${SCRIPT_DIR}/../build-def.bash ]] && . ${SCRIPT_DIR}/../build-def.bash

# Registry AND IMAGE DEF
# SRC
SRC_RGSTR_=${DKH_RGSTR_SVR_:-dflt}
SRC_IMG_NM_=${DVLVM_USER_SRC_IMG_NM_:-centos7}
SRC_IMG_TG_=${DVLVM_USER_SRC_IMG_TG_:-latest}
# TGT
RGSTR_SVR_=${DKH_RGSTR_SVR_:-dflt}
IMG_NM_=${DVLVM_USER_IMG_NM_:-dvlvm-lampx}
IMG_TG_=${DVLVM_USER_IMG_TG_:-latest}

# USER DEF
SUDR_GID_=${DVLVM_USER_SUDR_GID_:-500}
SUDR_GNM_=${DVLVM_USER_SUDR_GNM_:-dvlsudoers}
USER_GID_=${DVLVM_USER_USER_GID_:-1000}
USER_GNM_=${DVLVM_USER_USER_GNM_:-dvladmin}
USER_UID_=${DVLVM_USER_USER_UID_:-1000}
USER_NAM_=${DVLVM_USER_USER_NAM_:-dvladmin}
USER_PSW_=${DVLVM_USER_USER_PSW_:-dvladmin}
ALTUSERS_=${DVLVM_USER_ALTUSERS_:-dvlusr1,dvlusr2,dvlusr3,dvlusr4,dvlusr5}

DKR_FLNM_=Dockerfile.user
TAR_FLNM_=dflt
PWD_=$PWD


# in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
HELP_ON='^(|-h|--help|help)$'
if [[ $1 =~ $HELP_ON ]];then
    . ${BLD_TOOL} vrdo --help ${SCRIPT_NM_}
else
    . ${BLD_TOOL} vrdo $@
fi
