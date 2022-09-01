.. include:: ../definitions.rst

.. _title:

Gehirn MTA
==========

このドキュメントでは `Gehirn MTA`_ が提供する API のご利用方法を説明します。

.. contents:: 目次
   :depth: 3
   :backlinks: none


.. _send_message:

メッセージ送信
--------------

.. _send-message-request:

HTTP リクエスト
~~~~~~~~~~~~~~~

.. code-block:: http

   POST /mta/v1/tasks?is_sync=true HTTP/1.1
   Host: api.gis.gehirn.jp
   Content-Type: application/json

.. _send_message-request-body:

リクエストボディ
""""""""""""""""

.. literalinclude:: ./send_message.json
    :language: json


.. table:: リクエストプロパティ
   :align: left

   =====================================  ========================  ====
   プロパティ                             型                        説明
   =====================================  ========================  ====
   .procedure                             string                    ``send_message`` 固定
   .arguments.self                        string                    メール送信元 Gehirn MTA ドメインの URL ``https://api.gis.gehirn.jp/mta/v1/domains/:domain_id``
   .arguments.from                        []string                  メール作成者のリスト（ |mailbox-list|_ 形式）

                                                                    :ref:`sender-and-from` もあわせて参照してください。
   .arguments.sender                      string                    メール送信者（|mailbox|_ 形式）

                                                                    :ref:`sender-and-from` もあわせて参照してください。
   .arguments.to                          []string                  :mailheader:`To` 送信先のリスト（ |mailbox-list|_ 形式）
   .arguments.cc                          []string                  :mailheader:`Cc` 送信先のリスト（ |mailbox-list|_ 形式）
   .arguments.bcc                         []string                  :mailheader:`Bcc` 送信先のリスト（ |mailbox-list|_ 形式）
   .arguments.subject                     string                    メールサブジェクト (UTF-8)
   .arguments.content_type                string                    メール本文の :mailheader:`Content-Type`

                                                                    * text/*
                                                                    * multipart/*

   .arguments.additional_header           object<string, []string>  追加のヘッダーフィールド。

                                                                    任意の |optional-field|_ を指定できますが、一部のフィールドは Gehirn MTA により上書きされる場合があります。

                                                                    フィールドネームを含む 1 行の長さが MIME_ の制限 998 オクテットを超える場合は適宜 |FWS|_ を挿入してください。

                                                                    ``obs-unstruct`` 及び ``obs-FWS`` は利用できません。
   .arguments.body                        string                    メール本文

                                                                    改行コードは ``CRLF`` に正規化されます。

                                                                    ``.arguments.content_type`` が text/\* の場合は自動的に Content-Transfer-Encoding の変換が行われます。
                                                                    また ``.arguments.attachments`` の指定がある場合は自動的に ``multipart/mixed`` 形式に変換されます。
                                                                    有効な UTF-8 の文字列を指定してください。

                                                                    ``.arguments.content_type`` が multipart/\* の場合は改行コードの正規化を除き、自動的な変換は行われません。
                                                                    事前に必要な変換を施した ASCII 文字列を指定してください。
   .arguments.attacuments[]               []object                  添付ファイルのリスト

                                                                    ``.arguments.content_type`` がtext/\* のときのみ使用できます。
                                                                    multipart/* の場合は .arguments.body に直接エンコーディングしてください。
   .arguments.attacuments[].filename      string                    添付ファイルのファイル名
   .arguments.attacuments[].content_type  string                    添付ファイルの :mailheader:`Content-Type`
   .arguments.attacuments[].content       string                    添付ファイル (Base64)
   =====================================  ========================  ====

.. |FWS| replace:: RFC 5322 FWS
.. _FWS: https://datatracker.ietf.org/doc/html/rfc5322#section-3.2.2

.. |mailbox| replace:: RFC 5322 mailbox
.. _mailbox: https://datatracker.ietf.org/doc/html/rfc5322.html#section-3.4

.. |mailbox-list| replace:: RFC 5322 mailbox
.. _mailbox-list: https://datatracker.ietf.org/doc/html/rfc5322.html#section-3.4

.. |optional-field| replace:: RFC 5322 optional-field
.. _optional-field: https://datatracker.ietf.org/doc/html/rfc5322#section-3.6.8

.. _MIME: https://datatracker.ietf.org/doc/html/rfc2045.html

.. _send_message-code-examples:

コード例
~~~~~~~~

.. _send_message-code-text-plain:

text/plain
""""""""""


.. literalinclude:: ./plain.sh
    :language: bash

.. _send_message-code-multipart-alternative:

multipart/alternative
"""""""""""""""""""""


.. literalinclude:: ./multipart.sh
    :language: bash


.. _sender-and-from:

Sender と From について
-----------------------

:rfc:`RFC 5322 <5322#section-3.6.2>` ではメールの作成者を示す From を連名で複数指定することが許されています。
このとき、実際に送信を担当した人またはシステムを Sender として示すことが求められています。

このため、 Gehirn MTA の :ref:`send_message` API では次の条件を満たすことを求めています。

* ``.arguments.from[]`` にメール作成者がひとつのみ指定されている

* または ``.arguments.sender`` に有効なメール送信者が指定されている

  * このとき ``.arguments.from[]`` にメール作成者を複数指定することが許可されます

ただし、送信元認証メカニズムのひとつである :rfc:`DMARC <7489#section-5>` では、 From に複数のメール作成者が指定された場合の取り扱い方法を定めていません。
このため、 From に複数のメール作成者を指定した場合は、 DMARC の設定内容によってはメール送信先で受け取りを拒否されたり検疫されたりする場合があります。

したがって、現在では From に単一のメール作成者を指定することを推奨します。
