#!/usr/bin/bash
cwdf=$(realpath $0)
cwdd=$(dirname ${cwdf})
TMP=/tmp
HOSTS=${cwdd}/dist/hosts
rm ${cwdd}/dist/unbound-hosts-block.conf
cat ${HOSTS} | grep '^0\.0\.0\.0' | awk '{print "local-zone: \""$2"\" static"}' | tee --append ${cwdd}/dist/unbound-hosts-block.conf > /dev/null

