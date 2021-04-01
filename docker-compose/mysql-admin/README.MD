# MySQL(MariaDB) + PhpMyAdmin

## run containers
```
# options: <ps|up -d|down|stop|rm>
docker-compose -f mysql-admin.yaml up -d
```

### Usage
- from Browser (PHP MyAdmin)
  - http://docker-machine-ip:18080/
  - 例） http://localhost:18080/
  - 例） http://192.168.199.11:18080/
```
  データベース種類 MySQL
  サーバ       lcl-db  (MySQLのコンテナ名、DNS名、IP:port)
  ユーザ名     admin
  パスワード   admin
  データベース mydb
```
- from Container
```
  サーバ       lcl-db  (MySQLのコンテナ名)
  ユーザ名     admin
  パスワード   admin
  データベース mydb
```

## MySQL
https://hub.docker.com/_/mysql

### config
- image: mysql:5.7
- name: lcl-db
```
environment:
  MYSQL_DATABASE: mydb
  MYSQL_USER: admin
  MYSQL_PASSWORD: admin
  MYSQL_ROOT_PASSWORD: mypassword
ports:
  - 0.0.0.0:13306:3306
```
## PhpMyAdmin
https://www.phpmyadmin.net/

### config
- image: phpmyadmin/phpmyadmin
- hostname: 'phpmyadmin'
```
ports:
  - 18080:8080
```

## Adminer
https://www.adminer.org/

### config
- image: adminer
- name: adminer
```
ports:
  - 18080:8080
```
