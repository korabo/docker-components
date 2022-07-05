VSCode
==========

VSCodeのリモートコンテナによる開発環境の定義

phpdev:
----------
DebianベースのPHP公式Dockerイメージを元にバージ
ョンを指定してビルドできる。以下の４つのコンテかから構成される。

- データコンテナ
- MySQLコンテナ
- Smtp4devコンテナ(フェイクメールサーバ)
- Webコンテナ(Apache+PHP+postfix)
