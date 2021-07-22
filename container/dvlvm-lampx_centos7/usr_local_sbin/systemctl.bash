#!/usr/bin/bash
# psudo systemctl for develop apache app in Docker env.
# Ver0.9.0 S.TAKEUCHI(SCR/SPG/KRB) 20201015

_USG_="usage: $0 <chk|status|start|restart|reload|stop|...> <httpd|php-fpm|...>"

_CMD_='help'
_SVC_=''
if [[ -n $1 ]];then
  _CMD_=$1
fi
if [[ -n $2 ]];then
  _SVC_=`echo $2|sed -e 's/\.service$//'`
fi

case "$_SVC_" in
        httpd)
                _SVC_CMD_=/usr/local/sbin/httpdctl.bash
        ;;
        php-fpm)
                _SVC_CMD_=/usr/local/sbin/phpfpmctl.bash
        ;;
        *)
                if [[ -f /usr/local/sbin/${_SVC_}ctl.bash ]];then
                        _SVC_CMD_=/usr/local/sbin/${_SVC_}ctl.bash
                else
                        echo ${_USG_}
                        exit
                fi
        ;;
esac

# chk|status|start|restart|reload|stop
case "$_CMD_" in
        -h|--help|help)
                echo ${_USG_}
        ;;
        *)
                ${_SVC_CMD_} $_CMD_
        ;;
esac
