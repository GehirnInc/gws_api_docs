#!/bin/bash
set -eu

GEHIRN_API_STATIC_TOKEN_ID=""
GEHIRN_API_STATIC_TOKEN_SECRET=""
GEHIRN_MTA_DOMAIN_URL="https://api.gis.gehirn.jp/mta/v1/domains/:domain_id"

FROM="from@example.jp"
TO="to@example.net"

curl \
    --user "$GEHIRN_API_STATIC_TOKEN_ID:$GEHIRN_API_STATIC_TOKEN_SECRET" \
    -H 'Content-Type: application/json' \
    https://api.gis.gehirn.jp/mta/v1/tasks\?is_sync\=true \
    --data-binary @<(jq \
      -nf /dev/stdin \
      --arg self "$GEHIRN_MTA_DOMAIN_URL" \
      --arg from "$FROM" \
      --arg to "$TO" \
      --arg subject "メール送信のテスト" \
      --arg cty "text/plain; charset=UTF-8" \
      --arg body "本文" \
      --arg attachment "$(base64 -w0 attachment.png)" \
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
      "Auto-Submitted": ["auto-generated"]
    },
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
)
