#!/bin/bash -e
set -eo pipefail
cd "$(dirname "$0")"
SRC_FILE=/tmp/rkn.src
TMP_FILE=/tmp/rkn.rsc
DST_FILE=/var/www/html/rkn.rsc
PARSER_VERSION=1.2
PARSER_FILE=network-list-parser-linux-amd64-${PARSER_VERSION}.bin
PARSER_URL=https://github.com/unsacrificed/network-list-parser/releases/download/v${PARSER_VERSION}/${PARSER_FILE}
echo "Download csv"
curl -sS 'https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv' | iconv -f cp1251> $SRC_FILE
echo "Generate rules"
echo '/ip firewall address-list' > $TMP_FILE
echo 'remove [/ip firewall address-list find list=rkn]' >> $TMP_FILE
if [ ! -f ${PARSER_FILE} ]; then
 wget ${PARSER_URL}
 chmod 755 ${PARSER_FILE}
fi
./${PARSER_FILE} -src-file $SRC_FILE -prefix 'add address=' -suffix ' list=rkn' >> $TMP_FILE
echo "" >> $TMP_FILE
echo "/log info $(date -d '+3 hours' +%D/%T)" >> $TMP_FILE
mv $TMP_FILE $DST_FILE
