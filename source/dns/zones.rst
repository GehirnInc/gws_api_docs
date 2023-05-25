.. _zones:

ゾーン
======

.. contents:: 目次
   :depth: 3
   :backlinks: none

.. _zone-object:

ゾーンオブジェクト
------------------

.. code-block:: json

   {
     "type": "object",
     "properties": {
       "id": {
         "type": "string",
         "minLength": 36,
         "maxLength": 36
       },
       "name": {
         "type": "string",
         "minLength": 4,
         "maxLength": 255
       },
       "deletion_protection": {
         "type": "boolean"
       },
       "current_version_id": {
         "type": "string",
         "minLength": 36,
         "maxLength": 36
       }
     }
   }

.. _zone-object-properties:

.. table:: ゾーンオブジェクトプロパティ
   :align: left

   ====================  ========  ============  =====
   プロパティ　          型        編集可否      説明
   ====================  ========  ============  =====
   .id                   string    読み取り専用  ゾーンを一意に識別する ID
   .name                 string    読み取り専用  4文字以上255文字以下のドメイン名
   .deletion_protection  boolean   編集可        削除保護機能の設定状況
   .current_version_id   string    読み取り専用  現在アクティブな :doc:`versions` の ID
   ====================  ========  ============  =====

.. _create:

作成
----

Gehirn DNS に新しいゾーンを作成します。

ドメイン名は `事前に認証 <https://support.gehirn.jp/manual/project/add-domain/>`_ されている必要があります。

.. _create-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   POST /dns/v1/zones HTTP/1.1
   Host: api.gis.gehirn.jp
   Content-Type: application/json

   {
     "name": "example.net",
     "deletion_protection": true
   }

.. _create-request-body:

リクエストボディ
""""""""""""""""

作成したい\ |ゾーンオブジェクト|\ をリクエストしてください。

.. _create-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

作成された\ |ゾーンオブジェクト|\ が返ります。

.. _list:

一覧
----

Gehirn DNS に存在するすべてのゾーンを取得します。

.. _list-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   GET /dns/v1/zones HTTP/1.1
   Host: api.gis.gehirn.jp

.. _list-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _list-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

すべての\ |ゾーンオブジェクト|\ を要素とする JSON array がレスポンスされます。

.. code-block:: json

   [
     {
       "id": "ZONE-ID-1",
       "name": "example.net",
       "deletion_protection": true,
       "current_version_id": "VERSION-ID-1"
     },
     {
       "id": "ZONE-ID-2",
       "name": "example.org",
       "deletion_protection": true,
       "current_version_id": "VERSION-ID-2"
     }
   [



.. _get:

取得
----

Gehirn DNS に存在する個別のゾーンを取得します。

.. _get-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   GET /dns/v1/zones/:zone_id HTTP/1.1
   Host: api.gis.gehirn.jp

.. _get-request-parameters:

.. table:: パスパラメーター
   :align: left

   ============  ==
   パラメーター  値
   ============  ==
   zone_id       取得するゾーンの ID
   ============  ==

.. _get-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _get-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

指定した\ |ゾーンオブジェクト|\ が返ります。

.. _put:

編集
----

Gehirn DNS に存在する個別のゾーンを編集します。

.. _put-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   PUT /dns/v1/zones/:zone_id HTTP/1.1
   Host: api.gis.gehirn.jp
   Content-Type: application/json

   {
     "name": "example.net",
     "deletion_protection": true
   }

.. table:: パスパラメーター
   :align: left

   ============  ==
   パラメーター  値
   ============  ==
   zone_id       編集するゾーンの ID
   ============  ==

.. _put-request-body:

リクエストボディ
""""""""""""""""

編集を加えた\ |ゾーンオブジェクト|\ をリクエストしてください。

.. _put-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

編集された\ |ゾーンオブジェクト|\ が返ります。

.. _delete:

削除
----

Gehirn DNS から個別のゾーンを削除します。

.. _delete-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   DELETE /dns/v1/zones/:zone_id HTTP/1.1
   Host: api.gis.gehirn.jp

.. _delete-request-parameters:

.. table:: パスパラメーター
   :align: left

   ============  ==
   パラメーター  値
   ============  ==
   zone_id       削除するゾーンの ID
   ============  ==

.. _delete-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _delete-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

削除された\ |ゾーンオブジェクト|\ が返ります。

.. |ゾーンオブジェクト| replace:: `ゾーンオブジェクト <zone-object_>`_
