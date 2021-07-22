#!/usr/bin/env bash
# ver0.9.0 S.TAKEUCHI(SCR/SPG/KRB) 20210419

# find env var if defind
_ENV_JVAV_=${_JVAV_:-11}

# set given version as system default
_JAVA_VER_=${1:-${_ENV_JVAV_}}
_JAVA_CMD_=${2:-alt}
# chgalt|sysprof|myprof|jdkhome|javahome

# find path for given version
function findJavaPathOf {
    # e.g.) findJavaPathOf javac 11
    local _J_=$1
    local _V_=$2
    echo -e '\n' |alternatives --config ${_J_} 2> /dev/null |grep java-${_V_} >| /tmp/jalts
    jpath=`sed -e 's/.*(\([^()]*\)).*/\1/' /tmp/jalts`
    # clear /tmp
    /bin/rm -rf /tmp/jalts
    echo $jpath
    return
}


# change alternative

case ${_JAVA_CMD_} in
    chgalt)
        # JAVA
        jpath=$(findJavaPathOf java ${_JAVA_VER_})
        update-alternatives --set java ${jpath}
        echo "set java as $jpath" >2&
        # JAVAC
        jpath=$(findJavaPathOf javac ${_JAVA_VER_})
        update-alternatives --set javac ${jpath}
        echo "set javac as $jpath" >2&
        ;;
    sysprof)
        echo 'export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))'
        ;;
    myprof)
        jpath=$(findJavaPathOf javac ${_JAVA_VER_})
        echo "export JAVA_HOME=$(dirname $(dirname ${jpath}))"
        echo 'export PATH=${JAVA_HOME}/bin${PATH:+:${PATH}}'
        ;;
    jdkhome)
        jpath=$(findJavaPathOf javac ${_JAVA_VER_})
        JAVA_HOME=$(dirname $(dirname ${jpath}))
        echo ${JAVA_HOME}
        ;;
    javahome)
        jpath=$(findJavaPathOf java ${_JAVA_VER_})
        JAVA_HOME=$(dirname $(dirname ${jpath}))
        echo ${JAVA_HOME}
        ;;
    *)
        echo "$0 p1:version<11|1.8.0> p2:<chgalt|sysprof|myprof>"  >&2
        ;;
esac
