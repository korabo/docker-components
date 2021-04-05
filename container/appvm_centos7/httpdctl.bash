#!/usr/bin/env bash
# httpd control sccript
# ver0.9.0 S.TAKEUCHI(SCR/SPG/KRB) 20201015

_SVC_=httpd
_PS_=httpd

type -p ${_SVC_}
if [[ $? != 0 ]];then
  . /etc/profile
fi

_SVC_PATH_=`type -p ${_SVC_}`

svc_BIN="${_SVC_PATH_}"
# svc_BIN="/usr/bin/env ${_SVC_}"
svc_opts="-k"
pkill_BIN="pkill"
stt_BIN="ps -wHjlfC"

echo "<-- using ${_SVC_} [${_PS_}] on ${_SVC_PATH_} -->"
case "$1" in
        start|restart|stop|graceful|graceful-stop)
                echo "Executing $1 ${_SVC_} [${_PS_}] ... "
                $svc_BIN $svc_opts $1
                if [ "$?" != 0 ] ; then
                        echo " failed"
                        exit 1
                fi
                echo " done"
        ;;
        reload)
                $0 graceful
        ;;
        force-quit)
                echo "Terminating ${_SVC_} [${_PS_}] ... "
                $pkill_BIN -TERM ${_PS_}
                echo " done"
        ;;
        clean-restart)
                echo "<== Restart service ${_SVC_} [${_PS_}] ... "
                $0 stop
                sleep 5
                $0 force-quit
                echo "remove old pids"
                rm -rf /run/httpd/* /tmp/httpd*
                $0 start
                echo "==> done"
        ;;
        chk)
                echo "<== Check/Test config for ${_SVC_} [${_PS_}] ... "
                $svc_BIN -t
                if [ "$?" != 0 ] ; then
                        echo "==> test failed"
                        exit 1
                fi
                echo "==> done"
        ;;
        status)
                echo "Status of ${_SVC_} [${_PS_}] "
                $stt_BIN ${_PS_}
        ;;
        *)
                echo "usage: $0 <chk|clean-restart|start|restart|reload|graceful|graceful-stop|stop|force-quit> "
                exit 1
        ;;
esac

# ----- apachectl --help ----- #
# Usage: /usr/sbin/httpd [-D name] [-d directory] [-f file]
#                        [-C "directive"] [-c "directive"]
#                        [-k start|restart|graceful|graceful-stop|stop]
#                        [-v] [-V] [-h] [-l] [-L] [-t] [-T] [-S] [-X]
# Options:
#   -D name            : define a name for use in <IfDefine name> directives
#   -d directory       : specify an alternate initial ServerRoot
#   -f file            : specify an alternate ServerConfigFile
#   -C "directive"     : process directive before reading config files
#   -c "directive"     : process directive after reading config files
#   -e level           : show startup errors of level (see LogLevel)
#   -E file            : log startup errors to file
#   -v                 : show version number
#   -V                 : show compile settings
#   -h                 : list available command line options (this page)
#   -l                 : list compiled in modules
#   -L                 : list available configuration directives
#   -t -D DUMP_VHOSTS  : show parsed vhost settings
#   -t -D DUMP_RUN_CFG : show parsed run settings
#   -S                 : a synonym for -t -D DUMP_VHOSTS -D DUMP_RUN_CFG
#   -t -D DUMP_MODULES : show all loaded modules
#   -M                 : a synonym for -t -D DUMP_MODULES
#   -t                 : run syntax check for config files
#   -T                 : start without DocumentRoot(s) check
#   -X                 : debug mode (only one worker, do not detach)

# APCCTL='/usr/bin/env apachectl'

# # Make sure we're not confused by old, incompletely-shutdown httpd
# # context after restarting the container.  httpd won't start correctly
# # if it thinks it is already running.
# _OPT_=-T
# _CMD_=start
# if [[ -z $1 || $1 == clean-start ]];then
#   echo "stopping httpd"
#   exec ${APCCTL} -k stop
#   echo "remove old pids"
#   rm -rf /run/httpd/* /tmp/httpd*
# elif [[ $1 =~ ^(start|restart|graceful|graceful-stop|stop)$ ]];then
#   _OPT_=''
#   _CMD_=$1
# elif [[ $1 == chk ]];then
#   _OPT_=-t
#   _CMD_=''
# else
#   echo "usage: $0 <chk|clean-start|start|restart|graceful|graceful-stop|stop> "
#   exit
# fi

# if [[ -z $_CMD_ ]];then
#   echo "starting httpd $_OPT_"
#   exec ${APCCTL} $_OPT_
# else
#   echo "starting httpd $_OPT_ -k $_CMD_"
#   exec ${APCCTL} $_OPT_ -k $_CMD_
# fi
# echo "enable command: chk|clean-start|start|restart|graceful|graceful-stop|stop"
