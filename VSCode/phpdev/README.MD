phpdev
==========

Ver. 2022-07-12 ST(KORABO/SPIGA)

構成
----------
4つのコンテナで構成される(docker-compose.ymlにて定義)

１）ボリューム(ソースや設定の保存用)
Volume 定義のみで非活性状態

２）データベース(MySQL)
hostname: "mysql57"
ホストマシンから接続する場合は、localhost:23306

３）メールサーバ(Smtp4dev: StartTLSに対応)
hostname: 'smtp4de
公開URL http://localhost:25080/

４）ウェブサーバ(Apache+PHP)
hostname: 'dvlvm'
公開URL http://localhost:28080/
ビルド設定「SYS_PHPV」でPHPバージョンを指定可能(デフォは8.0)

MySQL
----------
Docker環境のウェブサーバコンテナ内からは、以下のように接続

```bash
mysql -h mysql57 -u mysql --password=mysql -D dvldb
```

Smtp4dev
----------
Docker環境のウェブサーバコンテナ内からは、以下のように接続
## ウェブサーバ内のPostfix経由
```bash
# start postfix
/usr/local/bin/start-postfix
# send mail
# x nc -v -u localhost 25
swaks -server localhost  \
  --to test@test.local --from test@dvlvm.local

mailx -r test@dvlvm.local -s "test mail" test@test.local << [][]
This is test mail. on $(date)
[][]
# stop postfix if needed
# postfix stop
```
## Smtp4devコンテナに直接接続
```bash
# X openssl s_client -connect smtp4dev:25 -starttls smtp
swaks -server smtp4dev:25 -tls \
  --auth-user API_USR --auth-password API_KEY \
  --to test@test.local --from test@dvlvm.local

```
## メールキューの確認と強制送信
```bash
mailq
postqueue -f
```


PHP+Apache
----------
環境確認用に、以下のURLで、php.info() 画面が表示される
http://localhost:28081/


Tips & Trics
==========
## パッケージインストール
Docker内のパッケージインストールでは、入力が必要な処理は実行不可なので、以下のように「Debian Non-Interactive」指定をする。

```
# Install packages
RUN set -x \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ここにパッケージを空白区切りで指定 例）postfix mailutils procps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  ;
```

## PHP Extention
docker-php-ext-installで導入可能なPHP拡張
```
bcmath bz2 calendar ctype curl dba dom enchant exif ffi fileinfo filter ftp gd gettext gmp hash iconv imap intl json ldap mbstring mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline reflection session shmop simplexml snmp soap sockets sodium spl standard sysvmsg sysvsem sysvshm tidy tokenizer xml xmlreader xmlwriter xsl zend_test zip
```

## 試しで拡張モジュールを読込んでみるときの注意
/usr/local/etc/以外は永続化されないので、確認できたらDockerfileに記述してビルドしなおすことが必要。
その前に、以下のように「sudo -E」を指定して環境変数を読込んだ状態でないと正しく動作しないので、注意すること。
```bash
sudo -E /usr/local/bin/docker-php-ext-enable mysqli
```

## Dockerファイルから単独ビルドする方法
例：Dockerfile.dvl
```bash
# 最終イメージ名：タグ名を「-t　name:tag」で指定
docker build -f Dockerfile.dvl -t php:dvl .
# アーギュメントを指定する場合
docker build -f Dockerfile.dvl -t php:dvl --build-arg SYS_PHPV=7.4 .
```
