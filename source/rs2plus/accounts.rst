.. _accounts:

アカウント
==========

.. contents:: 目次
   :depth: 3
   :backlinks: none


.. _object:

オブジェクト
------------

.. literalinclude:: account-schema.json
    :language: json

.. _object-properties:

プロパティ
~~~~~~~~~~

=============================  =======  ========  ====
プロパティ                     型       編集可否  説明
=============================  =======  ========  ====
.id                            string   不可      アカウントを一意に特定する ID
.label                         string   可        アカウントを識別する任意のラベル
.hostname                      string   不可      アカウントのホストネーム
.created_at                    string   不可      アカウントの作成日時
.ipv4_address                  string   不可      アカウントのプライベート IPv4 アドレス

                                                  アカウント内で公開するウェブサーバーはこの IPv4 アドレスまたは ``0.0.0.0`` をリッスンします。
.ssh_port                      integer  不可      アカウントに SSH 接続する際のポート番号

                                                  * 接続先ホストネームは .hostserver.hostname を利用します
                                                  * ``ssh -p {.ssh_port} {username}@{.hostserver.hostname}``
.snapshot_interval_in_minute   integer  可        自動スナップショットを撮る間隔（分単位）

                                                  60 の倍数かつ 1440 の約数、または 1440 の倍数
.snapshot_archive_interval     integer  可        未使用
.snapshot_archive_generation   integer  可        未使用
.plan.id                       string   不可      プランを特定する ID
.plan.name                     string   不可      プラン名
.plan.cpu_count                integer  不可      利用できる vCPU の数
.plan.memory_in_bytes          integer  不可      利用できるメモリの量（ B 単位）
.plan.disk_size_in_gb          integer  不可      利用できるストレージの量（ GiB 単位）
.plan.max_snapshot_count       integer  不可      保存できるスナップショットの最大数
.hostserver.id                 string   不可      ホストサーバーを特定する ID
.hostserver.hostname           string   不可      ホストサーバーのホストネーム
=============================  =======  ========  ====

サンプルオブジェクト
~~~~~~~~~~~~~~~~~~~~

.. literalinclude:: account.json
    :language: json


.. _create:

作成
----

新しいアカウントを作成します。

新しいアカウントが作成された時点からご利用料金が発生します。

.. _create-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   POST /rs2p/v1/containers HTTP/1.1
   Host: api.gis.gehirn.jp
   Content-Type: application/json

.. _create-request-body:

リクエストボディ
""""""""""""""""

.. code-block:: json

   {
     "type": "object",
     "properties": {
       "plan_id": {
         "type": "string"
       },
       "label": {
         "type": "string",
         "maxLength": 255
       }
     },
     "required": [ "plan_id", "label" ]
   }


.. _create-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

作成された\ |アカウントオブジェクト|\ が返ります。


.. _list:

一覧
----

Gehirn RS2 Plus に存在するすべてのアカウントを取得します。

.. _list-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   GET /rs2p/v1/containers HTTP/1.1
   Host: api.gis.gehirn.jp

.. _list-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _list-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

空の JSON array またはひとつ以上の\ |アカウントオブジェクト|\ を含む JSON array がレスポンスされます。


.. _get:

取得
----

Gehirn RS2 Plus に存在する個別のアカウントを取得します。

.. _get-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   GET /rs2p/v1/containers/{container_id} HTTP/1.1
   Host: api.gis.gehirn.jp

.. _get-request-parameters:

パラメーター
""""""""""""

============  ==
パラメーター  値
============  ==
container_id  取得するアカウントの ID
============  ==

.. _get-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _get-response:

HTTP レスポンス
~~~~~~~~~~~~~~~~~

指定した\ |アカウントオブジェクト|\ が返ります。


.. put:

設定
----

個別のアカウントを設定します。

.. _put-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   PUT /rs2p/v1/containers/{container_id} HTTP/1.1
   Host: api.gis.gehirn.jp
   Content-Type: application/json

.. _put-request-parameters:

パラメーター
""""""""""""

============  ==
パラメーター  値
============  ==
container_id  編集するアカウントの ID
============  ==

.. _put-request-body:

リクエストボディ
""""""""""""""""

編集を行った\ |アカウントオブジェクト|\ をリクエストしてください。

.. _put-response:

HTTP レスポンス
~~~~~~~~~~~~~~~~~

更新された\ |アカウントオブジェクト|\ が返ります。


.. _delete:

削除
----

アカウントを削除します。

いかなる場合もアカウントの削除は取り消せず、削除されたデータも復元できないのでご注意ください。

.. _delete-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   DELETE /rs2p/v1/containers/{container_id} HTTP/1.1
   Host: api.gis.gehirn.jp

.. _delete-request-parameters:

パラメーター
""""""""""""

============  ==
パラメーター  値
============  ==
container_id  削除するアカウントの ID
============  ==

.. _delete-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _delete-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

削除された\ |アカウントオブジェクト|\ が返ります。

.. |アカウントオブジェクト| replace:: `アカウントオブジェクト <object_>`_
