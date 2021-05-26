# Docker Build Util. ver 1.0 20210402 ST(KRB/SPG)
# source variables
SCRIPT_REAL_PATH=$(realpath  "${BASH_SOURCE[0]}")
SCRIPT_DIR="$(dirname "${SCRIPT_REAL_PATH}")"
SCRIPT_NM="${BASH_SOURCE[0]}"

# in windows bash, $ must be escaped; cannto use ^(|-h|--help)$ as regex
HELP_ON='^(|-h|--help|help|dflt)$'

# HELP
function showHelp {
    local SCRIPT_NM_=$1
    echo "Docker build utility for buld,run,tag,push"
    echo "usage: $SCRIPT_NM_ p1:<-h|--help|help>"
    echo "usage: $SCRIPT_NM_ p1:<vrdo>  <bld|run|push|load|save|-h|--help|help> (...)"
    echo "  e.g.) $SCRIPT_NM_ vrdo bld => build using variables"
    echo "usage: $SCRIPT_NM_ p1:<bld>   p2:ImageName (p3:TagName p4:DockerFilePath)"
    echo "     : $SCRIPT_NM_ p1:<run>   p2:ImageName (p3:TagName p4:RegistryHost command...)"
    echo "     : $SCRIPT_NM_ p1:<push>  p2:ImageName (p3:TagName p4:RegistryHost)"
    echo "     : $SCRIPT_NM_ p1:<save>  p2:ImageName (p3:TagName p4:TarFileName)"
    echo "     : $SCRIPT_NM_ p1:<load>  p2:ImageName (p3:TagName p4:TarFileName)"
    echo "  e.g.) $SCRIPT_NM_ bld appvm centos7"
    echo "      ) $SCRIPT_NM_ run centos latest"
    echo "      ) $SCRIPT_NM_ push centos latest myregistry.server.none"
    echo "      ) $SCRIPT_NM_ load appvm latest => load from appvm_latest.tar"
    echo "      ) $SCRIPT_NM_ save appvm latest => save unto appvm_latest.tar"
    echo "      ) $SCRIPT_NM_ load dflt  dflt   my_docker.tar => load from given file"
    echo "      ) $SCRIPT_NM_ save appvm latest my_docker.tar => save unto given file"
    return
}

function DBGECHO_ {
  echo "$@"
  return
}

function NOP_ {
  # NOP
  return
}

# DBGECHO=DBGECHO_
# DBGEXEC=DBGECHO_
DBGECHO=NOP_
DBGEXEC=''

function showHelpVrdo {
    local SCRIPT_NM_=$1
    echo "Docker build utility for buld,run,tag,push about ${RGSTR_SVR_}${IMG_NM_}:${IMG_TG_}"
    echo "usage: ${SCRIPT_NM_} <bld|run|push|load|save|-h|--help|help> (p2 p3)"
    echo "  e.g.) ${SCRIPT_NM_} bld"
    echo "      ) ${SCRIPT_NM_} bld DockerfilePath"
    echo "      ) ${SCRIPT_NM_} bld DockerfilePath WorkDir"
    echo "      ) ${SCRIPT_NM_} save"
    echo "      ) ${SCRIPT_NM_} save my_docker.tar"
    return
}

function fillFrmArgs {
  # fillFrmArgs ${_CMD1_} ${_CMD2_} ${_ARG3_} ${_ARG4_}
  _CMD_=${1}
  _P2_=${2}
  _P3_=${3}
  _P4_=${4}
  if [[ ${_CMD_} =~ $HELP_ON ]];then
    _CMD_=hlp
    _P2_=''
    _P3_=''
    _P4_=''
    _SNM_=${SCRIPT_NM}
    _HELP_=showHelp
  fi
  return
}

function appendArgs {
  local _ARG_ITEM_=$1
  local _ATG_VALU_=$2
  [[ -n ${_ATG_VALU_} ]] && _BLD_ARGS_="${_BLD_ARGS_} --build-arg ${_ARG_ITEM_}=${_ATG_VALU_}"
}

function fillFrmVrdoArgs {
  # fillFrmVrdoArgs ${_CMD2_} ${_ARG3_} ${_ARG4_}
  # param from variable
  _CMD_=${1}
  if [[ ${_CMD_} =~ $HELP_ON ]];then
    _CMD_=hlp
  fi
  _P2_=${IMG_NM_}
  _P3_=${IMG_TG_}
  _P4_=''
  _PX_=''
  case ${_CMD_} in
      hlp)
        _SNM_=${2}
        _HELP_=showHelpVrdo
        ;;
      bld)
        _P4_=${2:-${DKR_FLNM_}}
        _PX_="${3:-${PWD_}}"
        appendArgs DK_IMG "${SRC_IMG_NM_}"
        appendArgs DK_TAG "${SRC_IMG_TG_}"
        appendArgs SYS_PYTV "${SYS_PYTV_}"
        appendArgs SYS_PHPV "${SYS_PHPV_}"
        appendArgs SYS_NODEV "${SYS_NODEV_}"
        appendArgs SYS_JAVAV "${SYS_JAVAV_}"
        appendArgs SUDR_GID "${SUDR_GID_}"
        appendArgs SUDR_GNM "${SUDR_GNM_}"
        appendArgs USER_GID "${USER_GID_}"
        appendArgs USER_GNM "${USER_GNM_}"
        appendArgs USER_UID "${USER_UID_}"
        appendArgs USER_NAM "${USER_NAM_}"
        appendArgs USER_PSW "${USER_PSW_}"
        appendArgs ALTUSERS "${ALTUSERS_}"
        ;;
      load|save)
        _P4_=${2:-${TAR_FLNM_}}
        _PX_=${3}
        ;;
      run)
        _P4_=${2:-dflt}
        _PX_=${3}
        ;;
      *)
        _P4_=${2:-${RGSTR_SVR_}}
        _PX_=${3}
        ;;
  esac
  return
}

# findValue ${variabl} default-val
function findValue {
  local _ret_=${1}
  if [[ ${1} == dflt ]];then
    _ret_=${2}
  fi
  echo $_ret_
  return
}


# given args
_CMD1_=${1:-help}
shift
_CMD2_=${1}
shift
_ARG3_=${1}
shift
_ARG4_=${1}
shift
# init vars
_CMD_=''
_P2_=''
_P3_=''
_P4_=''
_PX_=''
_BLD_ARGS_=''
_HELP_=''
_RET_=''

if [[ ${_CMD1_} == vrdo ]];then
  # param from variable
  fillFrmVrdoArgs ${_CMD2_} ${_ARG3_} ${_ARG4_}
else
  fillFrmArgs ${_CMD1_} ${_CMD2_} ${_ARG3_} ${_ARG4_}
fi

$DBGECHO L:145 1:${_CMD1_} 2:${_CMD2_} 3:${_ARG3_} 4:${_ARG4_}

# fill variable from args
_IMGNM_=$(findValue "${_P2_}" "")
_TAGNM_=$(findValue "${_P3_}" "")

echo "executing ${_CMD_} on ${_IMGNM_}:${_TAGNM_}"
# export DOCKER_BUILDKIT=0
# export COMPOSE_DOCKER_CLI_BUILD=0
_MSG_=DONE
$DBGECHO L:155 2:${_P2_} 3:${_P3_} 4:${_P4_} X:${_PX_} _IMGNM_:${_IMGNM_} _TAGNM_:${_TAGNM_}
case ${_CMD_} in
    hlp)
      ${_HELP_} ${_SNM_}
      ;;
    bld)
      _DKFILE_=$(findValue "${_P4_}" "Dockerfile")
      $DBGEXEC docker build -f ${_DKFILE_} -t ${_IMGNM_}:${_TAGNM_}  ${_BLD_ARGS_} $@ ${_PX_}
      ;;
    run)
      # docker run --rm -it image:tag bash -l . . .
      _RNCMD_=`findValue "${_P4_}" "bash -l"`
      $DBGEXEC docker run --rm -it -v /mnt/c/home:/mnt/home  ${_IMGNM_}:${_TAGNM_} ${_RNCMD_} ${_PX_} $@
      ;;
    push)
      _RGSTRY_=$(findValue "${_P4_}" "")
      if [[ -n ${_RGSTRY_} ]];then
        $DBGEXEC docker tag ${_IMGNM_}:${_TAGNM_} ${_RGSTRY_}/${_IMGNM_}:${_TAGNM_}
        $DBGEXEC docker push ${_RGSTRY_}/${_IMGNM_}:${_TAGNM_}
      else
        $DBGEXEC docker push ${_IMGNM_}:${_TAGNM_}
      fi
      ;;
    load)
      _LTRNM_=$(findValue "${_P4_}" "${_IMGNM_}_${_TAGNM_}.tar")
      $DBGEXEC docker load -i ${_LTRNM_//\//+}
      ;;
    save)
      _STRNM_=$(findValue "${_P4_}" "${_IMGNM_}_${_TAGNM_}.tar")
      $DBGEXEC docker save -o ${_STRNM_//\//+} ${_IMGNM_}:${_TAGNM_}
      ;;
    *)
      _MSG_="ILLEGAL/WRONG CMD: ${_CMD_}"
      ;;
esac

echo "${_MSG_}"
