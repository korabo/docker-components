#!/usr/bin/env bash
# ver0.9.0 S.TAKEUCHI(SCR/SPG/KRB) 20210410
# usage: $0 python-version php-version node-version python-venv node-global

HLP_USAGE="HELP: -h,--help,help"
# in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
HELP_ON='^(|-h|--help|help)$'
if [[ $1 =~ $HELP_ON ]];then
  echo "Initialize and print venv setup script for given args"
  echo "usage:$0 p1 p2 p3 (p4 p5)"
  echo "   p1: <sys|dflt>|python-version"
  echo "   p2: <sys|dflt>|php-version"
  echo "   p3: <sys|dflt>|node-version"
  echo "  (p4: <nop|dflt>|python-venv-dir)"
  echo "  (p5: <nop|dflt>|node-global-dir)"
  echo "e.g.) $0 36  74  12  ~/venv ~/.node-global ---> print env-conf with python36 php7.4 nodejs12 with python-venv-dir, nodejs-global-dir"
  echo "    ) $0 36  nop nop dflt     ---> print env-conf with python36 and system default php,nodejs with default python-venv-dir"
  echo "    ) $0 sys 80  14  nop dflt ---> print env-conf with php80 nodejs14 and system default python with no venv-dir, default nodejs-global-dir"
  echo "  $HLP_USAGE"
  exit 0
fi

# find env var if defind
_DFLT_PYTV_=${_PYTV_:-36}
_DFLT_PHPV_=${_PHPV_:-74}
_DFLT_NDJV_=${_NDJV_:-12}
_DFLT_PYVENV_='~/venv'
_DFLT_NPMPFX_='~/.node-global'

# ### ----- FUNCTIONS ----- ### #
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

# PYTHON: print profile def
function python_prof {
    local _pyv_=$1
    local _venv_=$2
    # print config
    cat <<_EOL_
# ---------- PYTHON ---------- #
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
# ##### ENABLE:PYTHON ##### #
_EOL_
}

# NODEJS: print profile def
function nodejs_prof {
    local _njv_=$1
    local _prefix_=$2
    # print prof for given version
    cat <<_EOL_
# ---------- NODEJS ---------- #
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
# ##### ENABLE:NODEJS ##### #
_EOL_
}

# PHP: print profile def
function php_prof {
    local _phv_=$1
    local _PHP_PROF_=$(. /usr/local/sbin/phpProfSetup.bash '${_PHP_VER}')

    # print prof for given version
    cat <<_EOL_
# ---------- PHP ---------- #
if [[ \${MY_PHP_VER:-TBD} == TBD ]];then
    _PHP_VER=${_phv_}
    [[ \${_PHP_VER} != SYS ]] && ${_PHP_PROF_}
    export MY_PHP_VER=\${_PHP_VER}    # DEFIN VER
fi
# ##### -- ENABLE:PHP -- ##### #
_EOL_
}

# set given version as system default
_PYT_VERSION_=$(cnvMatched "${1}" dflt "${_DFLT_PYTV_}" sys 'SYS')
shift
_PHP_VERSION_=$(cnvMatched "${1}" dflt "${_DFLT_PHPV_}" sys 'SYS')
shift
_NDJ_VERSION_=$(cnvMatched "${1}" dflt "${_DFLT_PHPV_}" sys 'SYS')
shift
_PYT_VENV_=$(cnvMatched "${1}" dflt "${_DFLT_PYVENV_}" nop '')
shift
_NPM_PRFX_=$(cnvMatched "${1}" dflt "${_DFLT_NPMPFX_}" nop '')
shift

# Print Python Prof
python_prof "${_PYT_VERSION_}" "${_PYT_VENV_}"
# Print PHP Prof
php_prof "${_PHP_VERSION_}"
# Print Nodejs Prof
nodejs_prof "${_NDJ_VERSION_}" "${_NPM_PRFX_}"
