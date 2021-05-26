#!/usr/bin/env bash
_VENV_PROF_SET_VER_='ver0.9.0 S.TAKEUCHI(SCR/SPG/KRB) 20210410'
# usage: $0 python-version php-version node-version python-venv node-global

HLP_USAGE="HELP: -h,--help,help"
# in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
HELP_ON='^(|-h|--help|help)$'
if [[ $1 =~ $HELP_ON ]];then
  echo "### $0 <<<${_VENV_PROF_SET_VER_}>>> ###"
  echo "## nitialize and/or print venv profile script for given args"
  echo "usage:$0 (<-p|print>) p1:<replace|delete> p2:<veprof> (p3:<dflt>|venvProfFile p4:<dflt>|shProfFile)"
  echo "e.g.) $0 -p replace veprof '~/.v_prof' ---> print initialize line with gievn venv_prof file"
  echo "      $0 -p delete  veprof dflt  dflt  ---> print deleted line with default profs ,~/.venv_profile and  ~/.bash_profile"
  echo "## Initialize and/or print language setup script"
  echo "usage:$0 (<-p|print>) p1:<replace|delete> p2:<py|php|node|java> p3 p4 (p5))"
  echo "    p3: <dflt|sys>|version"
  echo "    p4: <dflt|.venv_prof file path"
  echo "   (p5: <dflt|nop>|python-venv-dir|node-global-dir)"
  echo "e.g.) $0 replace py   36   ~/.v_prof       ---> replace env-conf with python 3.6 to given prof_file"
  echo "      $0 -p -r   py   38   dflt     ~/venv ---> print   env-conf with python 3.6 with python-venv-dir"
  echo "      $0 replace py   sys  dflt      nop   ---> replace env-conf with system default python with no venv to default prof_file"
  echo "      $0 delete  php                       ---> delete  env-conf about php with default prof_file"
  echo "      $0 replace node 12   dflt      dflt  ---> replace env-conf with node 12 with default prof_file, default npm-global"
  echo "      $0 replace java 1.8.0                ---> replace env-conf with java1.8.0 with default prof_file"
  echo "  $HLP_USAGE"
  exit 0
fi


# find env var if defind
_DFLT_PYTV_=${_PYTV_:-38}
_DFLT_PHPV_=${_PHPV_:-80}
_DFLT_NDJV_=${_NDJV_:-14}
_DFLT_JVAV_=${_JVAV_:-11}
_DFLT_PYVENV_='~/venv'
_DFLT_NPMPFX_='~/.node-global'
_DFLT_PRF_='~/.venv_profile'
_DFLT_SHP_='~/.bash_profile'

unset tmpfile

atexit() {
  [[ -n ${tmpfile-} ]] && rm -f "$tmpfile"
}

trap atexit EXIT
trap 'rc=$?; trap - EXIT; atexit; exit $?' INT PIPE TERM

tmpfile=$(mktemp "/tmp/${0##*/}.tmp.XXXXXX")

# ### ----- FUNCTIONS ----- ### #
# remove btw block
# awk -v f=0 "/${_B}/{f=1} !(f==1); /${_F}/{f=0}" aaa.txt
function removeBlock {
    # 1:file, 2:bgn, 3:fin
    local _p1_=$1
    local _crnt_prof_file_=$(eval "echo ${_p1_}")
    if [[ -f ${_crnt_prof_file_} ]];then
        awk -v f=0 "/${2}/{f=1} !(f==1); /${3}/{f=0}" ${_crnt_prof_file_}
    fi
    return
}

# get default value if giben value is matched $2/i
function cnvMatched {
    local _p1_=$1
    shift
    local _resp_=${_p1_}
    shopt -s nocasematch
    while [[ -n $1 ]];do
        local _p2_=$1
        shift
        local _p3_=$1
        shift
        [[ ${_p1_} == ${_p2_} ]] && _resp_=${_p3_} && break
    done
    shopt -u nocasematch
    echo ${_resp_}
    return
}

# ### WARN: MARK, BGN, FIN must accord RegExp safe
# VE: mark
_VE_MARK_="# - VENV:PROFILE ${_VENV_PROF_SET_VER_} - #"

# SH: print profile def for venv
_SH_BGN_='# ----- BGN SH-PROFILE:VENV ENABLE ----- #'
_SH_FIN_='# ----- FIN SH-PROFILE:VENV ENABLE ----- #'
function sh_prof {
    local _prf_file_=$1
    cat <<_EOL_
${_SH_BGN_}
[ -f ${_prf_file_} ] && . ${_prf_file_}
${_SH_FIN_}
_EOL_
}
# PYTHON: print profile def
_PY_BGN_='# ----- BGN PROFILE:PYTHON ENABLE ----- #'
_PY_FIN_='# ----- FIN PROFILE:PYTHON ENABLE ----- #'
function python_prof {
    local _pyv_=$1
    local _venv_=$2
    # print config
    cat <<_EOL_
${_PY_BGN_}
if [[ \${MY_PYTHON_VER:-TBD} == TBD ]];then
    _PYTHON_VER=${_pyv_}
    _PYVENV_HOME=${_venv_:-NON}
    [[ \${_PYTHON_VER} != SYS ]] && . scl_source enable rh-python\${_PYTHON_VER}
    # create venv if not
    if [[ \${_PYVENV_HOME} != NON ]];then
        if [[ ! -d \${_PYVENV_HOME}/bin ]];then
            python -m venv --without-pip \${_PYVENV_HOME}
            curl -o ~/get-pip.py https://bootstrap.pypa.io/get-pip.py
            . \${_PYVENV_HOME}/bin/activate
            python ~/get-pip.py
            /bin/rm -f ~/get-pip.py
        fi
        # check already in venv, activate if not
        _IN_VENV_=\$(python -c "import sys;print('YES') if (sys.base_prefix != sys.prefix) else print('')")
        if [[ -z \${_IN_VENV_} && -f \${_PYVENV_HOME}/bin/activate ]];then
            . \${_PYVENV_HOME}/bin/activate
        fi
    fi
    export MY_PYTHON_VER=\${_PYTHON_VER}   # DEFIN VER
    export MY_PYVENV_HOME=\${_PYVENV_HOME} # DEFIN HOME
fi
${_PY_FIN_}
_EOL_
}

# NODEJS: print profile def
_ND_BGN_='# ----- BGN PROFILE:NODEJS ENABLE ----- #'
_ND_FIN_='# ----- FIN PROFILE:NODEJS ENABLE ----- #'
function nodejs_prof {
    local _njv_=$1
    local _prefix_=$2
    # print prof for given version
    cat <<_EOL_
${_ND_BGN_}
if [[ \${MY_NODEJS_VER:-TBD} == TBD ]];then
    _NODEJS_VER=${_njv_}          # DEFIN VER
    _NODEPX_HOME=${_prefix_:-NON} # DEFIN HOME
    [[ \${_NODEJS_VER} != SYS ]] && . scl_source enable rh-nodejs\${_NODEJS_VER}
    # create global if not
    if [[ \${_NODEPX_HOME} != NON ]];then
        # add PATH
        PATH=\${_NODEPX_HOME}/bin\${PATH:+:\${PATH}}
        # create global dir, if not
        if [[ ! -d \${_NODEPX_HOME} ]];then
            /bin/mkdir -p \${_NODEPX_HOME}                                          # create global-dir if given
            [[ -f ~/.npmrc ]] && sed -i 's/^\([ ]*prefix[ ]*=.*\)/# \1/g' ~/.npmrc  # Update .npmrc
            echo "prefix = \${_NODEPX_HOME}" >>  ~/.npmrc                           # add prefix def
        fi
    else
        # No add PATH
        # remove global dir in .npmrc
        [[ -f ~/.npmrc ]] && grep -qe '^[ ]*prefix[ ]*=.*$' ~/.npmrc && \\
         sed -i 's/^\([ ]*prefix[ ]*=.*\)/# \1/g' ~/.npmrc  # Update .npmrc
    fi
    export MY_NODEJS_VER=\${_NODEJS_VER}   # DEFIN VER
    export MY_NODEPX_HOME=\${_NODEPX_HOME} # DEFIN HOME
fi
${_ND_FIN_}
_EOL_
}

# PHP: print profile def
_PH_BGN_='# ----- BGN PROFILE:PHP ENABLE ----- #'
_PH_FIN_='# ----- FIN PROFILE:PHP ENABLE ----- #'
function php_prof {
    local _phv_=$1
    local _PHP_PROF_=$(. /usr/local/sbin/phpProfSetup.bash '${_PHP_VER}')

    # print prof for given version
    cat <<_EOL_
${_PH_BGN_}
if [[ \${MY_PHP_VER:-TBD} == TBD ]];then
    _PHP_VER=${_phv_}
    [[ \${_PHP_VER} != SYS ]] && ${_PHP_PROF_}
    export MY_PHP_VER=\${_PHP_VER}    # DEFIN VER
fi
${_PH_FIN_}
_EOL_
}

# JAVA: print profile def
_JV_BGN_='# ----- BGN PROFILE:JAVA ENABLE ----- #'
_JV_FIN_='# ----- FIN PROFILE:JAVA ENABLE ----- #'
function java_prof {
    local _jav_=$1

    # print prof for given version
    cat <<_EOL_
${_JV_BGN_}
if [[ \${MY_JAVA_VER:-TBD} == TBD ]];then
    _JAVA_VER=${_jav_}
    if [[ \${_JAVA_VER} != SYS ]];then
        JAVA_HOME=\$(/usr/local/sbin/javaProfSetup.bash \${_JAVA_VER} jdkhome)
        export JAVA_HOME=\${JAVA_HOME}
        export PATH=\${JAVA_HOME}/bin\${PATH:+:\${PATH}}
    fi
    export MY_JAVA_VER=\${_JAVA_VER}    # DEFIN VER
fi
${_JV_FIN_}
_EOL_
}

function printProf {
    local _p1_=$1
    local _crnt_prof_file_=$(eval "echo ${_p1_}")
    if [[ -f ${_crnt_prof_file_} ]];then
        echo "# ----- BGN:CRNT:PROFILE: ${_crnt_prof_file_} ----- #"
        cat ${_crnt_prof_file_}
        echo "# ----- FIN:CRNT:PROFILE: ${_crnt_prof_file_} ----- #"
    else
        echo "# --<< No Such PROFILE: ${_crnt_prof_file_} >>-- #"
    fi
    return
}

function printOrReplace {
    # p1:_PRINT_ONLY_ p2:_REPLACE_ p3:tmpfile p4:target_file
    local _ponly_=$1 # Y|N
    local _instr_=$2 # R|D
    local _source_=$3
    local _p4_=$4
    local _target_=$(eval "echo ${_p4_}")
    echo "### BGN:Generate for:[${_instr_}] print-only:[${_ponly_}] TARGET PROFILE:${_target_} ###"
    cat ${_source_}
    if [[ ${_ponly_} != Y ]];then
        if [[ ! -f ${_target_} ]];then
            echo "## --<< Create PROFILE:${_target_} >>-- ##"
        fi
        cat ${_source_} >| ${_target_}
    fi
    echo "### FIN:Generate for:[${_instr_}] print-only:[${_ponly_}] TARGET PROFILE:${_target_} ###"
}

# ##### EXECUTE ##### #
_PRINT_ONLY_='N'
# p1:<-p|--print|print>|<-r|--replace|replace>|<-d|--delete|delete>
_P1_=$1
shift
case ${_P1_} in
    -p|--print|print)
        _PRINT_ONLY_='Y'
        _P1_=$1
        shift
        ;;
    *)
        ;;
esac

# p2:<veprof|shprof>
# p2:<py|php|node|java>
_P2_=$1
shift

_REPLACE_=E

# ### INIT or other ### #
case ${_P1_} in
    -r|--replace|replace)
        _REPLACE_=R
        _CMD_=${_P2_}
        ;;
    -d|--delete|delete)
        _REPLACE_=D
        _CMD_=${_P2_}
        ;;
    *)
        _CMD_=ERR1
        ;;
esac

case ${_CMD_} in
    ERR1)
        ;;
    veprof)
        _VPRF_=${1:-dflt}
        shift
        _SPRF_=${1:-dflt}
        shift
        _VPRFL_=$(cnvMatched "${_VPRF_}" dflt "${_DFLT_PRF_}")
        printProf ${_VPRFL_}
        _SPRFL_=$(cnvMatched "${_SPRF_}" dflt "${_DFLT_SHP_}")
        printProf ${_SPRFL_}
        ;;
    *)
        _VER_=${1:-dflt}
        shift
        _PRF_=${1:-dflt}
        shift
        _PTH_=${1:-dflt}
        shift
        _PRFL_=$(cnvMatched "${_PRF_}" dflt "${_DFLT_PRF_}" nop '')
        printProf ${_PRFL_}
        ;;
esac


_R_=0
case ${_CMD_} in
    ERR1)
        echo "No such arg p1:${_P1_}" >&2
        echo ${HLP_USAGE} >&2
        _R_=1
        ;;
    veprof)
        # .venv_profile
        [[ -n ${_VPRFL_} ]] && echo ${_VE_MARK_} >| ${tmpfile}
        printOrReplace  ${_PRINT_ONLY_} ${_REPLACE_} ${tmpfile} ${_VPRFL_}
        # .bash_profile
        [[ -n ${_SPRFL_} ]] && removeBlock ${_SPRFL_} "${_SH_BGN_}" "${_SH_FIN_}"  >| ${tmpfile}
        [[ ${_REPLACE_} != D ]] && sh_prof ${_VPRFL_} >> ${tmpfile}
        printOrReplace ${_PRINT_ONLY_} ${_REPLACE_} ${tmpfile} ${_SPRFL_}
        ;;
    py|python)
        [[ -n ${_PRFL_} ]] && removeBlock ${_PRFL_} "${_PY_BGN_}" "${_PY_FIN_}" >| ${tmpfile}
        _V_=$(cnvMatched "${_VER_}" dflt "${_DFLT_PYTV_}" sys 'SYS')
        _PYT_VENV_=$(cnvMatched "${_PTH_}" dflt "${_DFLT_PYVENV_}" nop '')
        [[ ${_REPLACE_} != D ]] && python_prof ${_V_} ${_PYT_VENV_} >> ${tmpfile}
        printOrReplace ${_PRINT_ONLY_} ${_REPLACE_} ${tmpfile} ${_PRFL_}
        ;;
    php)
        [[ -n ${_PRFL_} ]] && removeBlock ${_PRFL_} "${_PH_BGN_}" "${_PH_FIN_}" >| ${tmpfile}
        _V_=$(cnvMatched "${_VER_}" dflt "${_DFLT_PHPV_}" sys 'SYS')
        [[ ${_REPLACE_} != D ]] && php_prof ${_V_} >> ${tmpfile}
        printOrReplace ${_PRINT_ONLY_} ${_REPLACE_} ${tmpfile} ${_PRFL_}
        ;;
    node|nodejs)
        [[ -n ${_PRFL_} ]] && removeBlock ${_PRFL_} "${_ND_BGN_}" "${_ND_FIN_}" >| ${tmpfile}
        _V_=$(cnvMatched "${_VER_}" dflt "${_DFLT_NDJV_}" sys 'SYS')
        _NPM_PRFX_=$(cnvMatched "${_PTH_}" dflt "${_DFLT_NPMPFX_}" nop '')
        [[ ${_REPLACE_} != D ]] && nodejs_prof ${_V_} ${_NPM_PRFX_} >> ${tmpfile}
        printOrReplace ${_PRINT_ONLY_} ${_REPLACE_} ${tmpfile} ${_PRFL_}
        ;;
    java)
        [[ -n ${_PRFL_} ]] && removeBlock ${_PRFL_} "${_JV_BGN_}" "${_JV_FIN_}" >| ${tmpfile}
        _V_=$(cnvMatched "${_VER_}" dflt "${_DFLT_JVAV_}" sys 'SYS')
        [[ ${_REPLACE_} != D ]] && java_prof ${_V_} >> ${tmpfile}
        printOrReplace ${_PRINT_ONLY_} ${_REPLACE_} ${tmpfile} ${_PRFL_}
        ;;
    *)
        echo "No such arg p2:${_P2_}" >&2
        echo ${HLP_USAGE} >&2
        _R_=2
        ;;
esac

/bin/rm -rf ${tmpfile} 2>/dev/null

exit ${_R_}