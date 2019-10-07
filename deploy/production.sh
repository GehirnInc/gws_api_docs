#!/usr/bin/env bash

LOGIN_NAME="rs2p"
HOSTNAME="s9.rs2plus.gehirn.ne.jp"
PORT=22311
TARGET="/var/www/support.gehirn.jp/apidocs/"

ROOT=$(cd "$(dirname "$0")"; cd ../; pwd)

rsync --delete -pthrvz --rsh="ssh -p ${PORT}" "${ROOT}/build/html/" "${LOGIN_NAME}@${HOSTNAME}:${TARGET}"
