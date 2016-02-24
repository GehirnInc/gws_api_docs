Gehirn Web Services API Documentation
=====================================

このリポジトリでは、 `Gehirn Web Services API Documentation`_ を構成するすべてのコンテンツを管理しています。
Gehirn Web Services API Documentation は、\ `ゲヒルン株式会社`_\ が運営する\ `Gehirn Web Services`_ と、 `Gehirn Infrastructure Services`_ をはじめとする各追加サービスで提供する Web API のご利用方法を説明するドキュメントです。


ビルド方法
----------

`Gehirn Web Services API Documentation`_ が提供するすべての文書は、 reStructuredText_ マークアップ言語で記述し、 Python 製のドキュメンテーションツール Sphinx_ を用いて静的な HTML ファイルにビルドしています。

そのため、 Gehirn Web Services API Documentation をビルドするためには、 Sphinx がインストールされた環境が必要です。
Sphinx は Python Package Index で配布されているため、 Python 標準のパッケージマネージャー ``pip`` を用いてインストールすることができます。
``pip`` を用いたインストール方法のコマンド例を以下に示します。

.. code-block:: shell

   pip install sphinx

`GehirnInc/gws_api_docs`_ は Sphinx が提供する Makefile を含んでいるため、 Sphinx をインストールした環境のルートディレクトリへ移動し、以下に示す ``make`` コマンドを実行することで、静的な HTML を出力することができます。

.. code-block:: shell

   make html

ビルドされた HTML はカレントディレクトリの ``build/html`` 以下に出力されます。


コントリビュート方法
--------------------

ドキュメントの内容の正確性には注意を払っていますが、もしドキュメントの不備にお気づきの場合は、以下に示すいずれかの方法で当社までご報告いただけると幸いです。
なお、ご報告いただく際は、ご報告いただく不備が存在するドキュメントが記述されている自然言語を用いてください。
また、すでに同一の不備が Issues_ と `Pull Requests`_ のどちらでも報告されていない事をご確認ください。

ご報告いただいた不備は、当社でその内容を検証したうえで、できるだけ速やかに修正させていただきます。

Issue で報告する
~~~~~~~~~~~~~~~~

発見いただいた不備を説明する新しい Issue を `GehirnInc/gws_api_docs`_ の Issues_ から作成してください。
作成いただく Issue には以下の情報を含むようにしてください。

#. 当該不備が存在する `Gehirn Web Services API Documentation`_ の URL
#. 当該不備のご説明
#. どのように修正されるべきか（任意）
#. お客様の Gehirn ID （ `Gehirn ID Center`_ に開設されている場合)

Pull Request を作成する
~~~~~~~~~~~~~~~~~~~~~~~

発見いただいた不備をお客様によって修正していただいたうえで、 `GehirnInc/gws_api_docs`_ の **master** ブランチに対する Pull Request を作成してください。

なお、お客様がすでに `Gehirn ID Center`_ に Gehirn ID を開設されている場合は、当該 Gehirn ID を Pull Request と併せてご連絡ください。


ご注意
------

* このドキュメントでカバーする内容は `Gehirn Web Services`_ とその各追加サービスで提供する **Web API のご利用方法** に限ります。

  * サービスの機能や価格などについては、 `Gehirn Web Services サービスサイト <Gehirn Web Services_>`_ をご参照ください。
  * サービス自体のご利用方法については、 `Gehirn Support Center`_ をご参照ください。

* Issues_ 及び `Pull Requests`_ でご報告いただける内容は `Gehirn Web Services API Documentation`_ に存在する不備に限ります。

  * お客様がご利用中の環境で発生している問題については、 `Gehirn Support Center`_ 内の `お問い合わせ`_ フォームから当社までご連絡ください。
  * Issues_ 及び `Pull Requests`_ はインターネットで広く公開されている事にご留意いただき、コンフィデンシャルな情報を含まないようにしてください。

.. _Sphinx: http://www.sphinx-doc.org/
.. _reStructuredText: http://docutils.sourceforge.net/rst.html

.. _ゲヒルン株式会社: http://www.gehirn.co.jp/
.. _Gehirn Web Services: https://www.gehirn.jp/
.. _Gehirn Infrastructure Services: https://gis.gehirn.jp/
.. _Gehirn ID Center: https://gic.gehirn.jp/

.. _Gehirn Web Services API Documentation: #
.. _Gehirn Support Center:  https://support.gehirn.jp/
.. _お問い合わせ: https://support.gehirn.jp/contact/

.. _GehirnInc/gws_api_docs: https://github.com/GehirnInc/gws_api_docs
.. _Issues: https://github.com/GehirnInc/gws_api_docs/issues
.. _Pull Requests: https://github.com/GehirnInc/gws_api_docs/pulls
