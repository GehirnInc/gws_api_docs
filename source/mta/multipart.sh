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

curl \
    --user "$GEHIRN_API_STATIC_TOKEN_ID:$GEHIRN_API_STATIC_TOKEN_SECRET" \
    -H 'Content-Type: application/json' \
    https://api.gis.gehirn.jp/mta/v1/tasks\?is_sync\=true \
    --data-binary @<(jq \
      -nf /dev/stdin \
      --arg self "$GEHIRN_MTA_DOMAIN_URL" \
      --arg from "$FROM" \
      --arg to "$TO" \
      --arg subject "マルチパートメールのテスト" \
      --arg cty 'multipart/alternative; boundary="randomboundary"' \
      --arg body "$BODY" \
      << 'EOF'
{
  "procedure": "send_message",
  "arguments": {
    "self": $self,
    "from": [$from],
    "to": [$to],
    "subject": $subject,
    "content_type": $cty,
    "additional_header": {
      "Auto-Submitted": ["auto-generated"],
      "Content-Transfer-Encoding": ["7bit"],
    },
    "body": $body
  }
}
EOF
)
