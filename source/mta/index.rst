Gehirn MTA
==========

このドキュメントでは `Gehirn MTA`_ が提供する API のご利用方法を説明します。

.. contents:: 目次
   :depth: 3
   :backlinks: none

メッセージ送信
--------------

HTTP リクエスト
~~~~~~~~~~~~~~~


.. code-block:: http

   POST /mta/v1/tasks?is_sync=true HTTP/1.1
   Host: api.gis.gehirn.jp
   Content-Type: application/json

リクエストボディ
""""""""""""""""

.. literalinclude:: ./send_message.json
    :language: json


=====================================  ========  ====
プロパティ                             型        説明
=====================================  ========  ====
.procedure                             string    ``send_message`` 固定
.arguments.self                        string    メール送信元 Gehirn MTA ドメインの URL ``https://api.gis.gehirn.jp/mta/v1/domains/:domain_id``
.arguments.from                        []string  メール作成者のリスト（ |mailbox-list|_ 形式）
                                                 :ref:`Sender と From について` もあわせて参照してください。
.arguments.sender                      string    メール送信者（|mailbox|_ 形式）
                                                 :ref:`Sender と From について` もあわせて参照してください。
.arguments.to                          []string  :mailheader:`To` 送信先のリスト（ |mailbox-list|_ 形式）
.arguments.cc                          []string  :mailheader:`Cc` 送信先のリスト（ |mailbox-list|_ 形式）
.arguments.bcc                         []string  :mailheader:`Bcc` 送信先のリスト（ |mailbox-list|_ 形式）
.arguments.subject                     string    メールサブジェクト (UTF-8)
.arguments.content_type                string    メール本文の :mailheader:`Content-Type`
                                                 * text/*
                                                 * multipart/*
.arguments.body                        string    メール本文
.arguments.attacuments[]               []object  添付ファイルのリスト

                                                 .arguments.content_type = text/\* のときのみ使用できます。
                                                 multipart/* の場合は .arguments.body に直接エンコーディングしてください。
.arguments.attacuments[].filename      string    添付ファイルのファイル名
.arguments.attacuments[].content_type  string    添付ファイルの :mailheader:`Content-Type`
.arguments.attacuments[].content       string    添付ファイル (Base64)
=====================================  ========  ====

.. |mailbox| replace:: RFC 5322 mailbox
.. _mailbox: https://datatracker.ietf.org/doc/html/rfc5322.html#section-3.4

.. |mailbox-list| replace:: RFC 5322 mailbox
.. _mailbox-list: https://datatracker.ietf.org/doc/html/rfc5322.html#section-3.4


コード例
~~~~~~~~

text/plain
""""""""""

.. code-block:: bash

   #!/bin/bash
   set -eu
   
   GEHIRN_API_STATIC_TOKEN_ID=""
   GEHIRN_API_STATIC_TOKEN_SECRET=""
   GEHIRN_MTA_DOMAIN_URL="https://api.gis.gehirn.jp/mta/v1/domains/:domain_id"
   
   FROM="from@example.jp"
   TO="to@example.net"
   
   jq \
       -nf /dev/stdin \
       --arg self "$GEHIRN_MTA_DOMAIN_URL" \
       --arg from "$FROM" \
       --arg to "$TO" \
       --arg subject "メール送信のテスト" \
       --arg cty "text/plain; charset=UTF-8" \
       --arg body "本文" \
       --arg attachment "$(base64 -w0 attachment.png)" \
       << 'EOF' | \
     curl \
         --user "$GEHIRN_API_STATIC_TOKEN_ID:$GEHIRN_API_STATIC_TOKEN_SECRET" \
         -H 'Content-Type: application/json' \
         --data-binary @- \
         https://api.gis.gehirn.jp/mta/v1/tasks\?is_sync\=true
   {
     "procedure": "send_message",
     "arguments": {
       "self": $self,
       "from": [$from],
       "to": [$to],
       "subject": $subject,
       "content_type": $cty,
       "body": $body,
       "attachments": [
         {
           "filename": "attachment.png",
           "content_type": "image/png",
           "content": $attachment
         }
       ]
     }
   }
   EOF


multipart/alternative
"""""""""""""""""""""

.. code-block:: bash

   #!/bin/bash
   set -eu
   
   GEHIRN_API_STATIC_TOKEN_ID=""
   GEHIRN_API_STATIC_TOKEN_SECRET=""
   GEHIRN_MTA_DOMAIN_URL="https://api.gis.gehirn.jp/mta/v1/domains/:domain_id"
   
   FROM="from@example.jp"
   TO="to@example.net"

   BODY='--randomboundary
   Content-Type: text/plain; charset=UTF-8
   Content-Transfer-Encoding: quoted-printable

   Hello, World
   --randomboundary
   Content-Type: text/html; charset=UTF-8
   Content-Transfer-Encoding: quoted-printable

   <html><head></head><body>Hello, World</body></html>
   --randomboundary--'
   
   jq \
       -nf /dev/stdin \
       --arg self "$GEHIRN_MTA_DOMAIN_URL" \
       --arg from "$FROM" \
       --arg to "$TO" \
       --arg subject "マルチパートメールのテスト" \
       --arg cty 'multipart/alternative; boundary="randomboundary"' \
       --arg body "$(echo -n "$BODY"| perl -pe 's/\n/\r\n/')" \
       << 'EOF' | \
     curl \
         --user "$GEHIRN_API_STATIC_TOKEN_ID:$GEHIRN_API_STATIC_TOKEN_SECRET" \
         -H 'Content-Type: application/json' \
         --data-binary @- \
         https://api.gis.gehirn.jp/mta/v1/tasks\?is_sync\=true
   {
     "procedure": "send_message",
     "arguments": {
       "self": $self,
       "from": [$from],
       "to": [$to],
       "subject": $subject,
       "content_type": $cty,
       "body": $body
     }
   }
   EOF


Sender と From について
-----------------------

:rfc:`RFC 5322 <5322#section-3.6.2>` ではメールの作成者を示す From を連名で複数指定することが許されています。
このとき、実際に送信を担当した人またはシステムを Sender として示すことが求められています。

このため、 Gehirn MTA の :ref:`send_message <メッセージ送信>` API では次の条件を満たすことを求めています。

* ``.arguments.from[]`` にメール作成者がひとつのみ指定されている

* または ``.arguments.sender`` に有効なメール送信者が指定されている

  * このとき ``.arguments.from[]`` にメール作成者を複数指定することが許可されます

ただし、送信元認証メカニズムのひとつである :rfc:`DMARC <7489#section-5>` では、 From に複数のメール作成者が指定された場合の取り扱い方法を定めていません。
このため、 From に複数のメール作成者を指定した場合は、 DMARC の設定内容によってはメール送信先で受け取りを拒否されたり検疫されたりする場合があります。

したがって、現在では From に単一のメール作成者を指定することを推奨します。


.. _Gehirn MTA: https://www.gehirn.jp/mta/
