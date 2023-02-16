#!/bin/bash
# must su root
# - "./config/docker-php-ext-xdebug.ini:/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
# - "./config/php.ini:/usr/local/etc/php/php.ini"
BACKUP_DIR=${BKUP_D:-/opt/backup}
CUSTOM_DIR=${CSTM_D:-/opt/custom}
CONFIG_DIR=${CNFG_D:-/opt/conf}

case $1 in
    force|--force|-f)
        _CMD_=force
        ;;
    *)
        _CMD_=''
        ;;
esac

if [[ -d ${CONFIG_DIR} && -d ${CUSTOM_DIR} ]];then
    cd ${CUSTOM_DIR}
    for f in `ls -1`;do
        TGT_FPATH="/$(echo $f | tr _ /)"
        echo "restore custom config and make link [${TGT_FPATH}] with ${_CMD_}"
        # remove link if --force
        if [[ -L ${TGT_FPATH} ]];then
            if [[ $_CMD_ == force ]];then
                sudo rm ${TGT_FPATH}
            else
                echo "Link already exists: [${TGT_FPATH}]" >&2
            fi
        fi
        # remove source config file if --force
        if [[ -e ${CONFIG_DIR}/$f ]];then
            if [[ $_CMD_ == force ]];then
                sudo mv ${CONFIG_DIR}/$f ${CONFIG_DIR}/$f.${TODT}
            else
                echo "Source config already exists: [${CONFIG_DIR}/$f]" >&2
            fi
        fi
        # copy custom config to config dir
        if [[ ! -e ${CONFIG_DIR}/$f ]];then
            sudo cp -pf ./$f ${CONFIG_DIR}/
            sudo chmod 777 ${CONFIG_DIR}/$f
        fi
        # create link
        if [[ ! -e ${TGT_FPATH} ]];then
            ln -s ${CONFIG_DIR}/$f ${TGT_FPATH}
        fi
    done
else
    echo "No Such Config and/or custom dir:[${CONFIG_DIR}] [${CUSTOM_DIR}]" >&2
    exit 1
fi
