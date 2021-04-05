#!/usr/bin/env bash
# httpd log view utility
# ver0.9.0 S.TAKEUCHI(SCR/SPG/KRB) 2010405

# define
HTTPD_LOG_DIR=/var/log/httpd
_SUEX_=''
[[ $EUID -ne 0 ]] && _SUEX_='sudo'

# source variables
SCRIPT_REAL_PATH=$(realpath  "${BASH_SOURCE[0]}")
SCRIPT_DIR="$(dirname "${SCRIPT_REAL_PATH}")"
SCRIPT_NM="${BASH_SOURCE[0]}"

# in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
HELP_ON='^(|-h|--help|help|dflt)$'

# HELP
function showHelp {
    local _ME_=${1}
    echo "usage: . ${_ME_} p1 (p2)"
    echo "params: p1:log_type(access_log/error_log)<-a|a|-e|e> p2:view/tail<-v=dflt|v|-t|t>"
    echo "e.g.)  . ${_ME_}  -e    => view error_log"
    echo "       . ${_ME_}  -a -t => tail acces_log"
    return 0
}

function defineExe {
        case "$1" in
                -t|t)
                _EXE_="tail -f"
                ;;
                *)
                _EXE_="less"
                ;;
        esac
}

# args
_ARG1_=$1
shift
_ARG2_=${1:-dflt}
shift

# variables
_EXE_=''
_LOGF_=''

# show/tail log
case "$_ARG1_" in
        -a|a)
                _LOGF_=${HTTPD_LOG_DIR}/access_log
                defineExe ${_ARG2_}
        ;;
        -e|e)
                _LOGF_=${HTTPD_LOG_DIR}/error_log
                defineExe ${_ARG2_}
        ;;
        ${HELP_ON})
                _EXE_=showHelp
                _LOGF_=${SCRIPT_NM}
                _SUEX_=''
        ;;
        *)
                _EXE_=showHelp
                _LOGF_=${SCRIPT_NM}
                _SUEX_=''
        ;;
esac

${_SUEX_} ${_EXE_} ${_LOGF_}
