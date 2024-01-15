Gehirn EDJ
==========

Gehirn EDJ の API ドキュメントは `OpenAPI 形式 <https://api.gis.gehirn.jp/edj/v1/openapi.json>`_ でも提供しています。

イベント形式
------------

Gehirn EDJ では、イベントを次の形式の JSON オブジェクトで表現します。

.. literalinclude:: ./event-schema.json
    :language: json


.. table:: プロパティ
   :align: left

   ===========================  ==================  ====
   プロパティ                   型                  説明
   ===========================  ==================  ====
   ."@version"                  string              イベントスキーマのバージョン。常に ``"1"`` が設定されます。
   .id                          string              イベントの ID

                                                    イベントはリトライなどにより複数回配信される場合があります。 ID で重複を検知できます。
   .service                     string              イベントが発生したサービスの ID
   .name                        string              イベントの種類
   .summary                     string              イベントの概要を表す文字列。最大 8KiB 。改行コードは LF 。
   .content                     any                 イベントの詳細を表す任意の JSON 。各サービスで別途定義されます。
   .attachments                 array               イベントの添付ファイル
   .attachments[].content_type  string              添付ファイルのメディアタイプ
   .attachments[].filename      string              添付ファイルのファイル名

                                                    空文字列が設定される場合もあります。
   .attachments[].encoding      string              添付ファイルの Content Transfer Encoding

                                                    ``"7bit"`` 、 ``"8bit"`` 、 ``"base64"`` のいずれかが設定されます。
   .attachments.content         string              添付ファイルの内容。 ".encoding" 方式によりエンコードされます。

                                                    添付ファイルを ``.content`` から取り出せる場合などに空文字列が設定される場合があります。
   .created_at                  string (date-time)  イベント発生日時
   .expires_at                  string (date-time)  イベント有効期限

                                                    プロパティが存在しない場合は、イベントに有効期限はありません。
   ===========================  ==================  ====

イベント例
~~~~~~~~~~

Gehirn MTA でメールを受信した場合に発生するイベントの例です。

HTTP サブスクライバーでは、ご指定の URL 以下の JSON オブジェクトが POST されます。

``.summary`` は定義の通り LF 改行コードが利用されますが、 ``.content.body`` は RFC 5322 に従い CRLF 改行コードが利用される場合があります。

.. literalinclude:: ./event-mta-incoming.json
    :language: json

廃止されたプロパティ
~~~~~~~~~~~~~~~~~~~~

以下のプロパティは、ほかのプロパティで置き換えられるなどの理由により廃止されました。

ただし、 HTTP サブスクライバーでは後方互換性のため引き続き以下のプロパティが設定されます。

.. table:: 廃止されたプロパティ
   :align: left

   ============  ======  ====
   プロパティ    型      説明
   ============  ======  ====
   .short        string  ``.summary`` で置き換えられました
   .raw          any     ``.content`` で置き換えられました
   .topic_id     string  廃止されました
   ============  ======  ====
