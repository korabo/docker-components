#!/usr/bin/env bash
# phpfpm control sccript
# ver0.9.0 S.TAKEUCHI(SCR/SPG/KRB) 20201015

_SVC_=php-fpm
_PS_=php-fpm

type -p ${_SVC_}
if [[ $? != 0 ]];then
  . /etc/profile
fi

_SVC_PATH_=`type -p ${_SVC_}`

# PHPFPMCTL='/usr/bin/env php-fpm'
# -F (nodaemon), -D (daemon), -R (as root)
# /opt/remi/php56/root/etc/sysconfig/php-fpm

svc_BIN="${_SVC_PATH_}"
# svc_BIN="/usr/bin/env ${_SVC_}"
svc_opts="-D"
pkill_BIN="pkill"
stt_BIN="ps -wHjlfC"

echo "<-- using ${_SVC_} [${_PS_}] on ${_SVC_PATH_} -->"
case "$1" in
        start)
                echo "Starting ${_SVC_} [${_PS_}] ... "
                $svc_BIN $svc_opts
                if [ "$?" != 0 ] ; then
                        echo " failed"
                        exit 1
                fi
                echo " done"
        ;;
        stop)
                echo "Gracefully shutting down ${_SVC_} [${_PS_}] ... "
                $pkill_BIN -QUIT ${_PS_}
                echo " done"
        ;;
        force-quit)
                echo "Terminating ${_SVC_} [${_PS_}] ... "
                $pkill_BIN -TERM ${_PS_}
                echo " done"
        ;;
        restart)
                echo "<== Restart service ${_SVC_} [${_PS_}] ... "
                $0 stop
                sleep 5
                $0 force-quit
                $0 start
                echo "==> done"
        ;;
        reload)
                echo "Reload service ${_SVC_} [${_PS_}] ... "
                $pkill_BIN -USR2 ${_PS_}
                # kill -USR2 `cat $php_fpm_PID`
                echo " done"
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
                echo "usage: $0 <chk|status|start|restart|reload|stop|force-quit> "
                exit 1
        ;;
esac

# ----- php-fpm --help -----
# Usage: php [-n] [-e] [-h] [-i] [-m] [-v] [-t] [-p <prefix>] [-g <pid>] [-c <file>] [-d foo[=bar]] [-y <file>] [-D] [-F [-O]]
#   -c <path>|<file> Look for php.ini file in this directory
#   -n               No php.ini file will be used
#   -d foo[=bar]     Define INI entry foo with value 'bar'
#   -e               Generate extended information for debugger/profiler
#   -h               This help
#   -i               PHP information
#   -m               Show compiled in modules
#   -v               Version number
#   -p, --prefix <dir>
#                    Specify alternative prefix path to FastCGI process manager (default: /opt/remi/php56/root/usr).
#   -g, --pid <file>
#                    Specify the PID file location.
#   -y, --fpm-config <file>
#                    Specify alternative path to FastCGI process manager config file.
#   -t, --test       Test FPM configuration and exit
#   -D, --daemonize  force to run in background, and ignore daemonize option from config file
#   -F, --nodaemonize
#                    force to stay in foreground, and ignore daemonize option from config file
#   -O, --force-stderr
#                    force output to stderr in nodaemonize even if stderr is not a TTY
#   -R, --allow-to-run-as-root
#                    Allow pool to run as root (disabled by default)
