.. _zones:

ゾーン
======

.. contents:: 目次
   :depth: 3
   :backlinks: none

.. _object:

オブジェクト
------------

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
       "current_version_id": {
         "type": "string",
         "minLength": 36,
         "maxLength": 36
       }
     }
   }

.. _object-properties:

プロパティ
~~~~~~~~~~

+--------------------+--------+----------------------------------------+
| プロパティ　       | 型     | 説明                                   |
+====================+========+========================================+
| id                 | string | ゾーンを一意に識別する ID              |
+--------------------+--------+----------------------------------------+
| name               | string | 4文字以上255文字以下のドメイン名       |
+--------------------+--------+----------------------------------------+
| current_version_id | string | 現在アクティブな :doc:`versions` の ID |
+--------------------+--------+----------------------------------------+

.. _create:

作成
----

Gehirn DNS に新しいゾーンを作成します。

.. _create-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   POST /dns/v1/zones HTTP/1.1
   Host: api.gis.gehirn.jp

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

ひとつ以上の\ |ゾーンオブジェクト|\ を要素とする JSON array がレスポンスされます。

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

パラメーター
""""""""""""

+--------------+---------------------+
| パラメーター | 値                  |
+==============+=====================+
| zone_id      | 取得するゾーンの ID |
+--------------+---------------------+

.. _get-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _get-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

指定した\ |ゾーンオブジェクト|\ が返ります。

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

パラメーター
""""""""""""

+--------------+----------------------+
| パラメーター | 値                   |
+==============+======================+
|  zone_id     |  削除するゾーンの ID |
+--------------+----------------------+

.. _delete-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _delete-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

削除された\ |ゾーンオブジェクト|\ が返ります。

.. |ゾーンオブジェクト| replace:: `ゾーンオブジェクト <object_>`_
