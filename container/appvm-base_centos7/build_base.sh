#!/usr/bin/env bash
# source variables
SCRIPT_REAL_PATH=$(realpath  "${BASH_SOURCE[0]}")
SCRIPT_DIR="$(dirname "${SCRIPT_REAL_PATH}")"
SCRIPT_NM_="$(basename "${SCRIPT_REAL_PATH}")"
BLD_TOOL="${SCRIPT_DIR}/../build-tool.bash"
[[ -f ${SCRIPT_DIR}/../build-def.bash ]] && . ${SCRIPT_DIR}/../build-def.bash

# Registry AND IMAGE DEF
# SRC
SRC_RGSTR_=${CMN_RGSTR_SVR_:-dflt}
SRC_IMG_NM_=${APPVM_BASE_SRC_IMG_NM_:-centos7}
SRC_IMG_TG_=${APPVM_BASE_SRC_IMG_TG_:-latest}
#TGT
RGSTR_SVR_=${DKH_RGSTR_SVR_:-dflt}
IMG_NM_=${APPVM_BASE_IMG_NM_:-appvm-base}
IMG_TG_=${APPVM_BASE_IMG_TG_:-latest}

DKR_FLNM_=Dockerfile.base
TAR_FLNM_=dflt
PWD_=$PWD

# in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
HELP_ON='^(|-h|--help|help)$'
if [[ $1 =~ $HELP_ON ]];then
    . ${BLD_TOOL} vrdo --help ${SCRIPT_NM_}
else
    . ${BLD_TOOL} vrdo $@
fi


# # in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
# HELP_ON='^(|-h|--help|help)$'
# if [[ $1 =~ $HELP_ON ]];then
#   echo "Docker build utility for buld,run,tag,push about ${RGSTR_SVR}${IMG_NM}:${IMG_TG}"
#   echo "usage: $0 <bld|run|push|load|save|-h|--help|help>"
#   echo "  e.g.) $0 bld"
#   echo "  e.g.) $0 save my_docker.tar"
#   exit 0
# fi

# # source variables
# SCRIPT_REAL_PATH=$(realpath  "${BASH_SOURCE[0]}")
# SCRIPT_DIR="$(dirname "${SCRIPT_REAL_PATH}")"

# _P1_=${1}
# shift
# _P2_=${IMG_NM}
# _P3_=${IMG_TG}
# _P4_=''
# _PX_=''

# case ${_P1_} in
#     bld)
#       _P4_=${DKR_FLNM}
#       _PX_="${1:-${PWD}}"
#       shift
#       ;;
#     load)
#       _P4_=${1:-${TAR_FLNM}}
#       shift
#       ;;
#     save)
#       _P4_=${1:-${TAR_FLNM}}
#       shift
#       ;;
#     *)
#       _P4_=${RGSTR_SVR}
#       ;;
# esac

# # execute util
# if [[ ${#@} == 0 ]];then
#   . ${SCRIPT_DIR}/../build-util.bash ${_P1_} ${_P2_} ${_P3_} ${_P4_} ${_PX_}
# else
#   . ${SCRIPT_DIR}/../build-util.bash ${_P1_} ${_P2_} ${_P3_} ${_P4_} "$@" ${_PX_}
# fi

# # case $1 in
# #     bld)
# #       docker build -f Dockerfile -t ${IMG_NM}:${IMG_TG} ./
# #       ;;
# #     run)
# #       docker run --rm -it ${IMG_NM}:${IMG_TG} bash -l
# #       ;;
# #     push)
# #       docker tag ${IMG_NM}:${IMG_TG} ${RGSTR_SVR}${IMG_NM}:${IMG_TG}
# #       docker push ${RGSTR_SVR}${IMG_NM}:${IMG_TG}
# #       ;;
# #     load)
# #       _IMG_TAR=${IMG_TAR}
# #       [[ -n "$2" ]] && _IMG_TAR=$2
# #       docker load < ${_IMG_TAR}
# #       ;;
# #     save)
# #       _IMG_TAR=${IMG_TAR}
# #       [[ -n "$2" ]] && _IMG_TAR=$2
# #       docker save ${IMG_NM}:${IMG_TG} > ${_IMG_TAR}
# #       ;;
# #     *)
# #       ;;
# # esac
