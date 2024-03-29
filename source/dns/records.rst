.. _records:

レコード
========

.. _object:

レコードオブジェクト
--------------------

リソースレコードを :ref:`作成 <post-dns-v1-records>` する時や :ref:`編集 <put-dns-v1-records>` する時は、 POST リクエストや PUT リクエストのボディとして JSON 形式のレコードオブジェクトを送信します。


.. _object-properties:

共通プロパティ
~~~~~~~~~~~~~~

次のプロパティはリソースタイプに関わらず共通して指定します。

``.type`` で指定するリソースタイプに応じて ``.records[]`` 配列の要素に指定するオブジェクトの形式が異なります。
詳しくはそれぞれのセクションをご覧ください。


=============  =======  ====
プロパティ     型       説明
=============  =======  ====
.id            string   レコードを一意に特定する ID (read-only)
.name          string   ドメイン名（オーナーネーム）
.type          string   以下のいずれかのリソースタイプ

                        - :ref:`A <type-a>`
                        - :ref:`NS <type-ns>`
                        - :ref:`CNAME <type-cname>`
                        - :ref:`MX <type-mx>`
                        - :ref:`TXT <type-txt>`
                        - :ref:`AAAA <type-aaaa>`
                        - :ref:`SRV <type-srv>`
                        - :ref:`SVCB <type-svcb>`
                        - :ref:`HTTPS <type-svcb>`
                        - :ref:`CAA <type-caa>`

.enable_alias  boolean  :ref:`alias` 利用有無

                        以下のリソースタイプでご利用になれます。

                        - A
                        - AAAA
                        - MX （非推奨）
                        - TXT （非推奨）
                        - SRV （非推奨）

.alias_to      string   エイリアス先
.ttl           integer  TTL
.records[]     array    ``.type`` で指定したリソースタイプに応じたレコードオブジェクトのリスト
=============  =======  ====

ドメイン名の指定方法
""""""""""""""""""""

レコードオブジェクト内におけるドメイン名の指定方法は次の 3 通りがあります。

絶対名 (FQDN)
  末尾がドットで終わるドメイン名は絶対名として解釈されます。ゾーン外部のドメイン名を指定する時は、常に絶対名を指定します。

  例えばドメイン名に ``www.example.net.`` を指定した時、ゾーンに関わらず ``www.example.net.`` に解決されます。

相対名
  末尾がドットで終わらないドメイン名はゾーン内部の相対名として解釈されます。

  例えば ``example.net.`` ゾーン内でドメイン名に ``www`` を指定した時、 ``www.example.net.`` に解決されます。

Zone Apex
  ドメイン名に ``@`` を単独で指定した時、 Zone Apex として解釈されます。

  例えば ``example.net.`` ゾーン内でドメイン名に ``@`` を指定した時、 ``example.net.`` に解決されます。


.. _type-a:

A リソースレコード
~~~~~~~~~~~~~~~~~~

.. code-block:: json

   {
     "name": "example.net.",
     "type": "A",
     "enable_alias": false,
     "ttl": 3600,
     "records": [
       {
         "address": "192.0.2.10"
       }
     ]
   }

===================  ======  ====
プロパティ           型      説明
===================  ======  ====
.records[].address   string  IPv4 アドレス
===================  ======  ====


.. _type-ns:

NS リソースレコード
~~~~~~~~~~~~~~~~~~~

.. code-block:: json

   {
     "name": "example.net.",
     "type": "NS",
     "enable_alias": false,
     "ttl": 86400,
     "records": [
       {
         "nsdname": "ns2.gehirndns.com."
       },
       {
         "nsdname": "ns2.example.jp."
       },
       {
         "nsdname": "ns2.example.net."
       },
       {
         "nsdname": "ns2.example.org."
       }
     ]
   }

==================  ======  ====
プロパティ          型      説明
==================  ======  ====
.records[].nsdname  string  ネームサーバーのドメインネーム
==================  ======  ====


.. _type-cname:

CNAME リソースレコード
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: json

   {
     "name": "example.net.",
     "type": "CNAME",
     "enable_alias": false,
     "ttl": 86400,
     "records": [
       {
         "cname": "cname.example.org."
       }
     ]
   }

================  ======  ====
プロパティ        型       説明
================  ======  ====
.records[].cname  string  CNAME
================  ======  ====


.. _cname-restriction:

CNAME の注意点
""""""""""""""

CNAME はほかのドメイン名の「別名」を設定するためのリソースタイプです。
このため、 DNS の仕様を定めた :rfc:`RFC1034 <1034#section-3.6.2>` により以下の制約があります。

- ``.records[]`` 配列の要素は常に 1 つみ許可されます。
- Zone Apex に作成することはできません。

  - Zone Apex に CNAME を指定したい場合は、 :ref:`alias` のご利用をご検討ください。

- ひとつのドメイン名においてほかのリソースタイプと共存することができません。

  つまり、 ``www IN A`` と ``www IN CNAME`` を同時に作成することはできません。
  CNAME が関係しない ``www IN A`` と ``www IN AAAA`` は同時に作成することができます。


.. _type-mx:

MX リソースレコード
~~~~~~~~~~~~~~~~~~~

.. code-block:: json

   {
     "name": "example.net.",
     "type": "MX",
     "enable_alias": false,
     "ttl": 86400,
     "records": [
       {
         "prio": 10,
         "exchange": "mx1.mta.gis.gehirn.jp."
       },
       {
         "prio": 10,
         "exchange": "mx2.mta.gis.gehirn.jp."
       },
       {
         "prio": 10,
         "exchange": "mx3.mta.gis.gehirn.jp."
       },
       {
         "prio": 10,
         "exchange": "mx4.mta.gis.gehirn.jp."
       },
       {
         "prio": 10,
         "exchange": "mx5.mta.gis.gehirn.jp."
       }
     ]
   }

===================  =======  ====
プロパティ           型       説明
===================  =======  ====
.records[].prio      integer  優先度
.records[].exchange  string   メールエクスチェンジのドメインネーム
===================  =======  ====


.. _type-txt:

TXT リソースレコード
~~~~~~~~~~~~~~~~~~~~

.. code-block:: json

   {
     "name": "example.net.",
     "type": "TXT",
     "enable_alias": false,
     "ttl": 86400,
     "records": [
       {
         "data": "v=spf1 +include:_spf.gehirn.jp -all"
       }
     ]
   }

================  ======  ====
プロパティ        型      説明
================  ======  ====
.records[].data   string  TXT データ
================  ======  ====


.. _type-aaaa:

AAAA リソースレコード
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: json

   {
     "name": "example.net.",
     "type": "AAAA",
     "enable_alias": false,
     "ttl": 3600,
     "records": [
       {
         "address": "2001:db8::10"
       }
     ]
   }

===================  ======  ====
プロパティ           型      説明
===================  ======  ====
.records[].address   string  IPv6 アドレス
===================  ======  ====


.. _type-srv:

SRV リソースレコード
~~~~~~~~~~~~~~~~~~~~

.. code-block:: json

   {
     "name": "_submission._tcp.example.net.",
     "type": "SRV",
     "enable_alias": false,
     "ttl": 86400,
     "records": [
       {
         "prio": 10,
         "weight": 0,
         "target": "mx.mta.gis.gehirn.jp.",
         "port": 587
       }
     ]
   }

==================  =======  ====
プロパティ          型       説明
==================  =======  ====
.records[].prio     integer  優先度
.records[].weight   integer  ウェイト
.records[].target   string   ターゲットのドメインネーム
.records[].port     integer  ポート番号
==================  =======  ====


.. _type-svcb:

SVCB/HTTPS リソースレコード
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: json

   {
     "name": "example.net.",
     "type": "HTTPS",
     "enable_alias": false,
     "ttl": 3600,
     "records": [
       {
         "prio": 1,
         "target": ".",
         "params": {
           "alpn": "h2,h3"
         }
       }
     ]
   }

==================  ======================  ========================  ====
プロパティ          型                      要否                      説明
==================  ======================  ========================  ====
.records[].prio     integer                 必須                      優先度
.records[].target   string                  必須                      ターゲットのドメインネーム
.records[].params   object<string, string>  任意                      SVCB パラメーター

                                                                      パラメーターキーは以下のいずれか

                                                                      - ``mandatory``
                                                                      - ``alpn``
                                                                      - ``no-default-alpn``
                                                                      - ``port``
                                                                      - ``ipv4hint``
                                                                      - ``ech``
                                                                      - ``ipv6hint``
                                                                      - ``keyNNNNN`` 形式
==================  ======================  ========================  ====


.. _type-caa:

CAA リソースレコード
~~~~~~~~~~~~~~~~~~~~

.. code-block:: json

   {
     "name": "example.net.",
     "type": "CAA",
     "enable_alias": false,
     "ttl": 3600,
     "records": [
       {
         "flags": 0,
         "tag": "issue",
         "value": "pki.example.org."
       }
     ]
   }

================  =======  ====
プロパティ        型       説明
================  =======  ====
.records[].flags  integer  フラグ
.records[].tag    string   タグ
.records[].value  string   値
================  =======  ====

.. _alias:

エイリアス
~~~~~~~~~~

Gehirn DNS では、指定したドメイン名を解決した結果のリソースレコードを応答するエイリアス機能を提供しています。

DNS の仕様上 Zone Apex で CNAME を使用することはできませんが、エイリアス機能を利用することで CNAME に似た機能を Zone Apex でも実現しています。

エイリアス機能は、 CNAME Flattening などとも呼ばれます。

なお、 A または AAAA 以外のリソースタイプでエイリアス機能を利用することは非推奨になりました。
また、ゾーン内でエイリアス機能を利用することもリソースタイプに関わらず推奨していません。

.. code-block::  json

   {
     "name": "example.net.",
     "type": "A",
     "enable_alias": true,
     "alias_to": "www.example.org."
   }

エイリアス代替手段
""""""""""""""""""

==========  ========
用途        代替手段
==========  ========
MX          値を直接ご入力ください。
            ``.records[].exchange`` に共通の名前を指定することで、その名前の A/AAAA リソースレコードを一度更新するだけでメールサーバーの IP アドレスを一斉に切り替えることができます。
TXT (DKIM)  CNAME をご利用ください。
            DKIM は ``default._domainkey`` のような公開鍵ごとに固有のオーナーネームを使用するため、常に CNAME で代替することができます。
TXT (SPF)   SPF 標準の ``include`` ディレクティブまたは ``redirect`` 修飾子をご利用ください。 例: ``v=spf1 +include:_spf.gehirn.jp -all``
SRV         値を直接ご入力ください。
            SRV リソースレコードは ``_service._proto`` 形式の固有のオーナーネームを使用するため、 CNAME で代替することができます。
            また、 ``.records[].target`` に CNAME を指定することもできます。
==========  ========


JSON Schema
~~~~~~~~~~~

レコードオブジェクト全体の JSON Schema は以下の通りです。

.. literalinclude:: ./record-schema.json
    :language: json


.. _record-request-using-name:

ドメイン名とリソースタイプによるレコード指定方法
-------------------------------------------------

以下で説明する操作のうち、作成・取得・編集・削除は HTTP リクエストパスにレコード ID の代わりに操作対象のドメイン名とリソースタイプを指定することもできます。

この方法ではレコードの一覧から操作対象の ID を特定する必要がなく、直接レコード作成・編集・削除することができます。
このため、例えば Gehirn DNS を DDNS のように利用する場合などに活用できます。


リクエストパス
~~~~~~~~~~~~~~

.. code-block::

   /dns/v1/zones/{zone_id}/versions/{version_id}/records/{domain_name}/IN/{record_type}

.. table:: パスパラメーター
   :align: left

   =============  ==
   パラメーター   値
   =============  ==
   zone_id        レコードが存在する\ :doc:`zones`\ の ID
   version_id     レコードが存在するバージョンの ID
   domain_name    リソースレコードの名前

                  ここで指定するドメイン名は FQDN である必要があります。
                  相対名や `@` を指定することはできません。

                  また、 PUT リクエストではリクエストボディの `.name` と一致する必要があります

   resource_type  リソースレコードのタイプ

                  PUT リクエストではリクエストボディの `.type` と一致する必要があります
   =============  ==

.. table:: HTTP メソッド
   :align: left

   =============  ====
   HTTP メソッド  効果
   =============  ====
   GET            レコードを :ref:`取得 <get-dns-v1-records>` します。存在しない場合は HTTP 404 エラーが応答されます。
   PUT            レコードを :ref:`作成 <post-dns-v1-records>` または :ref:`編集 <put-dns-v1-records>` します。指定されたレコードが存在しない場合は新たに作成し、存在する場合は編集します。
   DELETE         レコードを :ref:`削除 <delete-dns-v1-records>` します。存在しない場合は HTTP 404 エラーが応答されます。
   =============  ====

作成・編集リクエスト例
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: http

   PUT /dns/v1/zones/:zone_id/versions/:version_id/records/example.net./IN/A HTTP/1.1
   Host: api.gis.gehirn.jp
   Content-Type: application/json

   {
     "name": "example.net.",
     "type": "A",
     "enable_alias": false,
     "ttl": 3600,
     "records": [
       {
         "address": "192.0.2.10"
       }
     ]
   }


.. _post-dns-v1-records:

作成
----

指定した\ :doc:`versions`\ に新しいレコードを追加します。

|ドメイン名とリソースタイプによるレコード指定方法| もご利用になれます。

.. _create-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   POST /dns/v1/zones/:zone_id/versions/:version_id/records HTTP/1.1
   Host: api.gis.gehirn.jp
   Content-Type: application/json

   {
     "name": "example.net.",
     "type": "A",
     "enable_alias": false,
     "ttl": 3600,
     "records": [
       {
         "address": "192.0.2.10"
       }
     ]
   }

.. _create-request-parameters:

.. table:: パスパラメーター
   :align: left

   ============  ==
   パラメーター  値
   ============  ==
   zone_id       レコードを追加する\ :doc:`zones`\ の ID
   version_id    レコードを追加するバージョンの ID
   ============  ==

.. _create-request-body:

リクエストボディ
""""""""""""""""

追加したい |レコードオブジェクト| をリクエストしてください。

.. _create-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

追加された |レコードオブジェクト| が返ります。

.. _list-dns-v1-records:

一覧
----

指定した\ :doc:`versions`\ に存在するすべてのレコードを取得します。

.. _list-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   GET /dns/v1/zones/:zone_id/versions/:version_id/records HTTP/1.1
   Host: api.gis.gehirn.jp

.. _list-request-parameters:

パラメーター
""""""""""""

+--------------+---------------------------------------------+
| パラメーター | 値                                          |
+==============+=============================================+
| zone_id      | 取得するレコードを含む\ :doc:`zones`\ の ID |
+--------------+---------------------------------------------+
| version_id   | 取得するレコードを含むバージョンの ID       |
+--------------+---------------------------------------------+

.. _list-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _list-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

ひとつ以上の\ |レコードオブジェクト|\ を含む JSON array が返ります。

.. _get-dns-v1-records:

取得
----

指定した\ :doc:`versions`\ に存在する個別のレコードを取得します。

|ドメイン名とリソースタイプによるレコード指定方法| もご利用になれます。

.. _get-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   GET /dns/v1/zones/:zone_id/versions/:version_id/records/:record_id HTTP/1.1
   Host: api.gis.gehirn.jp

.. _get-request-parameters:

.. table:: パスパラメーター
   :align: left

   ============  ==
   パラメーター  値
   ============  ==
   zone_id       取得するレコードを含む\ :doc:`zones`\ の ID
   version_id    取得するレコードを含むバージョンの ID
   record_id     取得するレコードの ID
   ============  ==

.. _get-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _get-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

指定した\ |レコードオブジェクト|\ が返ります。

.. _put-dns-v1-records:

編集
----

指定した\ :doc:`versions`\ に存在する個別のレコードを編集します。

|ドメイン名とリソースタイプによるレコード指定方法| もご利用になれます。

.. _put-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   PUT /dns/v1/zones/:zone_id/versions/:version_id/records/:record_id HTTP/1.1
   Host: api.gis.gehirn.jp

.. _put-request-parameters:

リクエストパラメータ
""""""""""""""""""""

+--------------+---------------------------------------------+
| パラメーター | 値                                          |
+==============+=============================================+
| zone_id      | 編集するレコードを含む\ :doc:`zones`\ の ID |
+--------------+---------------------------------------------+
| version_id   | 編集するレコードを含むバージョンの ID       |
+--------------+---------------------------------------------+
| record_id    | 編集するレコードの ID                       |
+--------------+---------------------------------------------+

.. _put-request-body:

リクエストボディ
""""""""""""""""

編集した\ |レコードオブジェクト|\ をリクエストしてください。

.. _put-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

編集された\ |レコードオブジェクト|\ が返ります。

.. _delete-dns-v1-records:

削除
----

指定した\ :doc:`versions`\ から個別のレコードを削除します。

|ドメイン名とリソースタイプによるレコード指定方法| もご利用になれます。

.. _delete-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   DELETE /dns/v1/zones/:zone_id/versions/:version_id/records/:record_id HTTP/1.1
   Host: api.gis.gehirn.jp

.. _delete-request-parameters:

パラメーター
""""""""""""

+--------------+---------------------------------------------+
| パラメーター | 値                                          |
+==============+=============================================+
| zone_id      | 削除するレコードを含む\ :doc:`zones`\ の ID |
+--------------+---------------------------------------------+
| version_id   | 削除するレコードを含むバージョンの ID       |
+--------------+---------------------------------------------+
| record_id    | 削除するレコードの ID                       |
+--------------+---------------------------------------------+

|ドメイン名とリソースタイプによるレコード指定方法| もご利用になれます。

.. _delete-request-body:

リクエストボディ
""""""""""""""""

リクエストボディは必要ありません。

.. _delete-response:

HTTP レスポンス
~~~~~~~~~~~~~~~

削除された\ |レコードオブジェクト|\ が返ります。

.. |レコードオブジェクト| replace:: `レコードオブジェクト <object_>`_
.. |ドメイン名とリソースタイプによるレコード指定方法| replace:: :ref:`ドメイン名とリソースタイプによるレコード指定方法 <record-request-using-name>`
