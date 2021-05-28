# VSCODE PHP Develop Env

## PHP FPM

```
/etc/opt/remi/php74/php.ini
/etc/opt/remi/php74/php.d/*.conf
/etc/opt/remi/php74/php-fpm.conf
/etc/opt/remi/php74/php-fpm.d/*.conf
```

```
# sudo /usr/local/sbin/phpfpmctl.bash status
sudo systemctl status php-fpm
sudo systemctl status httpd

# php-pfm
sudo sed -i -e 's/^user = \(.*\)/user = dvladmin/g' /etc/opt/remi/php74/php-fpm.d/www.conf
sudo sed -i -e 's/^group = \(.*\)/group = dvladmin/g' /etc/opt/remi/php74/php-fpm.d/www.conf


# change user
sudo sed -i -e 's/^User \(.*\)/User dvladmin/g' /etc/httpd/conf/httpd.conf
sudo sed -i -e 's/^Group \(.*\)/Group dvladmin/g' /etc/httpd/conf/httpd.conf


# change prefork => event
sudo sed -i -e 's/^\(LoadModule mpm_prefork_module .*\)/#\1/g' /etc/httpd/conf.modules.d/00-mpm.conf
sudo sed -i -e 's/^\(LoadModule mpm_worker_module .*\)/#\1/g' /etc/httpd/conf.modules.d/00-mpm.conf
sudo sed -i -e 's/^#\(LoadModule mpm_event_module .*\)/\1/g' /etc/httpd/conf.modules.d/00-mpm.conf

# mpm
cat <<_EOL_ >| /etc/httpd/conf.d/mpm.conf
# Event
<IfModule mpm_event_module>
StartServers 3
MinSpareThreads 75
MaxSpareThreads 250
ThreadsPerChild 25
MaxRequestWorkers 400
MaxConnectionsPerChild 0

KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5
</Ifmodule>
_EOL_



cat <<_EOL_ >| /etc/httpd/conf.d/dvlhome.conf
<VirtualHost *:80>
    # ServerName dvl.local.none
    DocumentRoot /home/dvladmin/www/html
    # DocumentRoot /var/www/html

    # ProxyPassMatch でPHPファイルはfcgiに流すように指定
    ProxyPassMatch ^(.*\.php(/.*)?)$ fcgi://127.0.0.1:9074/home/dvladmin/www/html/ disablereuse=on
    # ProxyPassMatch ^(.*\.php(/.*)?)$ fcgi://127.0.0.1:9074/var/www/html/ disablereuse=on

    # ついでにphpMyAdminを使う場合の設定
    # ProxyPassMatch ^/phpmyadmin/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/usr/share/phpMyAdmin/ disablereuse=on
    # ProxyPassMatch ^/phpmyadmin/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/usr/share/phpMyAdminindex.php disablereuse=on

    # バックエンド側へはKeepAliveしない
    SetEnv proxy-nokeepalive 1
    # タイムアウト設定。無ければTimeoutの値になる。
    ProxyTimeout 60

    DirectoryIndex  index.php
    Alias /app /home/dvladmin/www/app
    <Directory "/home/dvladmin/www">
        Options FollowSymLinks
        AllowOverride None
        Require all granted
        # php_value max_execution_time 300
        # php_value memory_limit 128M
        # php_value post_max_size 16M
        # php_value upload_max_filesize 2M
        # php_value max_input_time 300
        # php_value date.timezone Europe/Riga
    </Directory>
</VirtualHost>
_EOL_


mkdir -p /home/dvladmin/www/html
echo "<?php phpinfo(); ?>" >| /home/dvladmin/www/html/index.php

sudo systemctl restart php-fpm
sudo systemctl restart httpd

curl --location http://127.0.0.1/index.php \
       --header 'Host: dvl.local.none'
#       --output file.tar.gz \

```

### MySQL
```
mysql -h gateway -P 13306 -p -u admin
```

### EC-Cube
```
cd ~/source

git clone https://github.com/EC-CUBE/ec-cube2.git
cd ec-cube2
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
php composer.phar install --no-dev --no-interaction -o


cd ~
ln -s ~/source/ec-cube2/html  ~/www/app
```
