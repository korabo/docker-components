#!/usr/bin/env bash
RGSTR_SVR_=dflt
# RGSTR_SVR='docker.io'
SRC_IMG_NM_=centos
SRC_IMG_TG_='7.9.2009'
IMG_NM_=korabo/appvm-base
IMG_TG_=centos7.9.2009
DKR_FLNM_=Dockerfile.base
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

