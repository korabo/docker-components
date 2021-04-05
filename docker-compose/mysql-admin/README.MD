# MySQL(MariaDB) + PhpMyAdmin

## executing containers
- Options: <ps|up -d|down|stop|rm>
### start as daemon
```
docker-compose -f mysql-admin.yaml up -d
```
### list processes
```
docker-compose -f mysql-admin.yaml ps
```
### stop containers
```
docker-compose -f mysql-admin.yaml down
```
### remove container
```
docker-compose -f mysql-admin.yaml rm
```
---
## How to Use MySQL DB
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

# Definitions
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
