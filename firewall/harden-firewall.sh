#!/usr/bin/bash
# Before using this script run the below commands
#  ipset create list-ipv4 hash:net family inet
#  ipset create list-ipv6 hash:net family inet6
#
cwdf=$(realpath $0)
cwdd=$(dirname ${cwdf})
TMP=/tmp
CNv4="https://www.ipdeny.com/ipblocks/data/countries/cn.zone"
RUv4="https://www.ipdeny.com/ipblocks/data/countries/ru.zone"
KPv4="https://www.ipdeny.com/ipblocks/data/countries/kp.zone"
CNv6="https://www.ipdeny.com/ipv6/ipaddresses/blocks/cn.zone"
RUv6="https://www.ipdeny.com/ipv6/ipaddresses/blocks/ru.zone"

rm ${TMP}/cn.zone ${TMP}/ru.zone ${TMP}/kp.zone
rm ${TMP}/list-ipv6.ipset ${TMP}/list-ipv4.ipset 

cd ${TMP}
wget ${CNv4}
cd ${TMP}
wget ${RUv4}
cd ${TMP}
wget ${KPv4}
cat ${TMP}/cn.zone ${TMP}/ru.zone ${TMP}/kp.zone > ${cwdd}/dist/dropcidr4.txt
sed -i 's|^|add list-ipv4 |g' ${TMP}/kp.zone
sed -i 's|^|add list-ipv4 |g' ${TMP}/ru.zone
sed -i 's|^|add list-ipv4 |g' ${TMP}/cn.zone
cat ${TMP}/cn.zone ${TMP}/ru.zone ${TMP}/kp.zone > ${TMP}/list-ipv4.ipset
rm ${TMP}/cn.zone ${TMP}/ru.zone ${TMP}/kp.zone

cd ${TMP}
wget ${RUv6}
cd ${TMP}
wget ${CNv6}
cat ${TMP}/cn.zone ${TMP}/ru.zone > ${cwdd}/dist/dropcidr6.txt
sed -i 's|^|add list-ipv6 |g' ${TMP}/cn.zone
sed -i 's|^|add list-ipv6 |g' ${TMP}/ru.zone
cat ${TMP}/cn.zone ${TMP}/ru.zone > ${TMP}/list-ipv6.ipset
rm ${TMP}/cn.zone ${TMP}/ru.zone

ipset restore -! < ${TMP}/list-ipv4.ipset
ipset restore -! < ${TMP}/list-ipv6.ipset

rm ${TMP}/list-ipv6.ipset ${TMP}/list-ipv4.ipset 
iptables --flush
ip6tables --flush
iptables -I OUTPUT -p tcp -m set --match-set list-ipv4 dst -j DROP
ip6tables -I OUTPUT -p tcp -m set --match-set list-ipv6 dst -j DROP

