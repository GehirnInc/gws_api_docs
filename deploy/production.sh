#!/usr/bin/env bash

LOGIN_NAME="yosida95"
HOSTNAME="a761dfca-7dac-4b96-86ff-6b6d333d64d9.gehirn.ne.jp"
PORT=22348
TARGET="/var/www/support.gehirn.jp/apidocs/"

ROOT=$(cd "$(dirname "$0")"; cd ../; pwd)

rsync --delete -pthrvz --rsh="ssh -p ${PORT}" "${ROOT}/build/html/" "${LOGIN_NAME}@${HOSTNAME}:${TARGET}"
