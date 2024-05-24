.. include:: ../definitions.rst

.. _title:

Gehirn MTA
==========

このドキュメントでは `Gehirn MTA`_ が提供する API のご利用方法を説明します。

Gehirn MTA の API ドキュメントは `OpenAPI 形式 <https://api.gis.gehirn.jp/mta/v1/openapi.json>`_ でも提供しています。

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
   .arguments.reply_to                    []string                  このメールへの返信を受け取る返信先のリスト ( |mailbox-list|_ 形式)
   .arguments.to                          []string                  :mailheader:`To` 送信先のリスト（ |mailbox-list|_ 形式）
   .arguments.cc                          []string                  :mailheader:`Cc` 送信先のリスト（ |mailbox-list|_ 形式）
   .arguments.bcc                         []string                  :mailheader:`Bcc` 送信先のリスト（ |mailbox-list|_ 形式）
   .arguments.message_id                  string                    このメールを一意に特定する ID
   .arguments.in_reply_to                 []string                  返信先のメールの :mailheader:`Message-ID`

                                                                    :ref:`threading` もあわせて参照してください。
   .arguments.references                  []string                  このメールに関連するメール (スレッド) の :mailheader:`Message-ID`

                                                                    :ref:`threading` もあわせて参照してください。
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

.. |mailbox-list| replace:: RFC 5322 mailbox-list
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

.. _threading:

メールスレッドの指定
--------------------

:mailheader:`In-Reply-To` フィールドと :mailheader:`References` フィールドはともに関連するメール (スレッド) を参照するためのフィールドですが、使用方法が異なります。

ここで簡単にご説明いたします。より詳しくは :rfc:`RFC 5322 <5322#section-3.6.4>` を参照してください。

In-Reply-To
~~~~~~~~~~~

:mailheader:`In-Reply-To` フィールドには、そのメールが返信する直接の親にあたるメールの :mailheader:`Message-ID` を指定します。親が :mailheader:`Message-ID` を持たない場合は指定しません。

References
~~~~~~~~~~

一方、 :mailheader:`References` フィールドには親に加え祖先 (親の親、さらにその親) にあたるメールの :mailheader:`Message-ID` を指定します。

:mailheader:`References` フィールドの値は、標準的には以下のようにして組み立てます。

1. 値を空文字列で初期化します
2. 以下のいずれかの手順により、祖先を指定します

    - 親メールが :mailheader:`References` を含む場合、その値を使用します
    - 親メールが :mailheader:`References` を含まずに :mailheader:`In-Reply-To` を含み、かつその内容が単独の親を参照する場合、その値を使用します
    - これ以外の場合はなにもしません

3. 親メールが :mailheader:`Message-ID` を含む場合、その値を追加します

この手順を返信を作成するたびに繰り返すことで、すべての関連するメールを :mailheader:`References` フィールドで参照することができます。

Gmail におけるスレッド
~~~~~~~~~~~~~~~~~~~~~~

Gmail では送信者や受信者、件名に応じたメールのスレッド化が行われますが、:mailheader:`References` フィールドにより明示的にスレッドを制御することができます。
Gehirn MTA から送信するメールが正しくスレッド化されたり、反対に同じ件名でもスレッド化を解除したいときには :mailheader:`References` フィールドをご指定ください。

詳しくは `Threading changes in Gmail conversation view <https://workspaceupdates.googleblog.com/2019/03/threading-changes-in-gmail-conversation-view.html>`_ をご参照ください。
