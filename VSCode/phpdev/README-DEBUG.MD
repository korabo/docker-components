README-DEBUG
==========

## Xdebug 3.x 設定の注意点
```
;; /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
zend_extension=xdebug
xdebug.mode=debug
; xdebug.show_error_trace=1
; xdebug.max_nesting_level=512
xdebug.start_with_request=yes
xdebug.client_host=host.docker.internal
xdebug.discover_client_host=1
xdebug.client_port=9103
; xdebug.log=/tmp/xdebug.log

```
クライアント側はホスト上で動作する「VSCode + PHP debug拡張」なので、Dockerコンテナから見たクライアント側のホスト名は、以下のようになる。
```
host.docker.internal
```

## デバッグ開始
VSCのデバッグアイコン(蟲の付いた三角)をクリック

### launch.jsonの設定
以下の定義を埋め込むか、既存のものを訂正。ポートが標準と異なるので注意。

```launch.json
          {
             "name": "Listen for XDebug",
             "type": "php",
             "request": "launch",
             "port": 9103,
         },
```

## ログの見方

ログ出力場所の設定は、以下のファイルにある。

- SH_opt_conf/etc_apache2_sites-enabled_webapp.conf

ログ自体は、以下の2つに出力される。それ以外はDockerコンテナの標準出力となっている。logrotateされていないため、適宜ファイルを削除すること。

- PV_var_log/apache2/my-access.log
- PV_var_log/apache2/my-error.log