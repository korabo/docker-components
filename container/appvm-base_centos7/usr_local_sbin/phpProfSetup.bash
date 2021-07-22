#!/usr/bin/env bash
# ver0.9.0 S.TAKEUCHI(SCR/SPG/KRB) 20210410

# find env var if defind
_ENV_PHPV_=${_PHPV_:-74}

# set given version as system default
_PHP_VERSION_=${1:-${_ENV_PHPV_}}

# make profile
echo "[ -f /etc/profile.d/modules.sh ] && . /etc/profile.d/modules.sh && module load php${_PHP_VERSION_}"
