#!/usr/bin/env bash
_USER_ENV_SET_VER_='ver0.9.1 S.TAKEUCHI(SCR/SPG/KRB) 20210428'
# usage: $0 python-version php-version node-version python-venv node-global

VE_SETUP_SCRIPT_NM='venvProfSet.bash'

HLP_USAGE="HELP: -h,--help,help"
# in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
HELP_ON='^(|-h|--help|help)$'
if [[ $1 =~ $HELP_ON ]];then
  echo "Initialize and print venv setup script for given args ${_USER_ENV_SET_VER_}"
  echo "usage:$0 (<-p|print|-pp|pprint>) p1:<replace|delete> p2:<dflt>|venvProfFile p3:<dflt>|shProfFile"
  echo "    p4:<dflt|sys>|py_ver  p5:<dflt|nop>|python-venv-dir"
  echo "    p6:<dflt|sys>|php_ver"
  echo "    p7:<dflt|sys>|node_ver p8:<dflt|nop>|node-global-dir"
  echo "    p9:<dflt|sys>|java_ver"
  echo "e.g.) $0 -pp replace '~/.v_prof' ---> print initialize line with gievn venv_prof file, default py php node java version"
  echo "      $0 -pp delete  dflt  dflt  ---> print deleted line with default profs ,~/.venv_profile and  ~/.bash_profile"
  echo "      $0 -p  replace dflt  dflt  ---> print call ${VE_SETUP_SCRIPT_NM} with given parameters"
  echo "      $0 replace dflt        dflt 36  dflt  sys  sys  nop  sys  ---> replace env-conf with python 3.6 to default prof_file"
  echo "      $0 replace '~/.v_prof' dflt sys nop   sys  dflt dflt sys  ---> replace env-conf with default node to given prof_file"
  echo "      $0 replace dflt        dflt 38  dflt  74   12   dflt 1.8.0 ---> replace env-conf with py38 php74 node12 java1.8.0 to default prof_file"
  echo "  $HLP_USAGE"
  exit 0
fi

# source variables
SCRIPT_REAL_PATH=$(realpath  "${BASH_SOURCE[0]}")
SCRIPT_DIR="$(dirname "${SCRIPT_REAL_PATH}")"
SCRIPT_NM_="$(basename "${SCRIPT_REAL_PATH}")"
VE_SETUP_SCRIPT="${SCRIPT_DIR}/${VE_SETUP_SCRIPT_NM}"


_PRINT_ONLY_=''
_CMD_=''
_PRF_=''
_SHP_=''
_PYTV_=''
_PYVENV_=''
_PHPV_=''
_NDJV_=''
_NPMPFX_=''
_JVAV_=''


function delete_profile {
    local P_OPT_=$1
    if [[ ${P_OPT_} == callprint ]];then
        P_OPT_='-p'
    cat <<_EOL_
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} veprof ${_PRF_} ${_SHP_}
_EOL_
    else
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} veprof ${_PRF_} ${_SHP_}
    fi
}

function replace_profile {
    local P_OPT_=$1
    if [[ ${P_OPT_} == callprint ]];then
        P_OPT_='-p'
    cat << _EOL_
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} veprof ${_PRF_} ${_SHP_}
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} py   ${_PYTV_}  ${_PRF_} ${_PYVENV_}
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} php  ${_PHPV_}  ${_PRF_}
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} node ${_NDJV_} ${_PRF_} ${_NPMPFX_}
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} java ${_JVAV_} ${_PRF_}
_EOL_
    else
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} veprof ${_PRF_} ${_SHP_}
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} py   ${_PYTV_}  ${_PRF_} ${_PYVENV_}
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} php  ${_PHPV_}  ${_PRF_}
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} node ${_NDJV_} ${_PRF_} ${_NPMPFX_}
        ${VE_SETUP_SCRIPT} ${P_OPT_} ${_CMD_} java ${_JVAV_} ${_PRF_}
    fi
}

# init nodejs global
# bash -ic '. ~/.venv_profile && npm install --global pnpm@5.18.9'


# ##### EXECUTE ##### #
_PRINT_ONLY_=''
# p1:<-p|--print|print>|<-r|--replace|replace>|<-d|--delete|delete>
case $1 in
    -pp|--pprint|pprint)
        _PRINT_ONLY_='-p'
        shift
        _CMD_=$1
        ;;
    -p|--print|print)
        _PRINT_ONLY_='callprint'
        shift
        _CMD_=$1
        ;;
    *)
        _CMD_=$1
        ;;
esac

shift
_PRF_=$1
shift
_SHP_=$1
shift
_PYTV_=$1
shift
_PYVENV_=$1
shift
_PHPV_=$1
shift
_NDJV_=$1
shift
_NPMPFX_=$1
shift
_JVAV_=$1
shift

# ### execution ### #
_R_=0
case ${_CMD_} in
    -r|--replace|replace)
        replace_profile ${_PRINT_ONLY_}
        ;;
    -d|--delete|delete)
        delete_profile ${_PRINT_ONLY_}
        ;;
    *)
        echo "No such arg p1:${_CMD_}" >&2
        echo "  $HLP_USAGE" >&2
        _R_=1
        ;;
esac

exit ${_R_}
