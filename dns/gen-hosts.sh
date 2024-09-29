#!/usr/bin/bash
# Before running this files update the phishing dbs from here -
#   https://openphish.com/feed.txt
#   http://data.phishtank.com/data/online-valid.csv
#
cwdf=$(realpath $0)
cwdd=$(dirname ${cwdf})
TMP=/tmp
OP=${cwdd}/db_openphish/feed.txt
PT=${cwdd}/db_phishtank/online-valid.csv

if [ ! -d ${cwdd}/hosts ]
then
	git clone https://github.com/StevenBlack/hosts.git
	pip3 install -r hosts/requirements.txt
fi

cp -f ${cwdd}/whitelist ${cwdd}/hosts/

cat ${OP} | cut -d / -f 3 > ${TMP}/OP.txt
cat ${PT} | cut -d , -f 2 | cut -d / -f 3 > ${TMP}/PT.txt

cat ${TMP}/OP.txt ${TMP}/PT.txt | sort | uniq > ${cwdd}/blacklist
rm ${TMP}/OP.txt ${TMP}/PT.txt

sed -i 's|^|0.0.0.0 |g' ${cwdd}/blacklist
cp -f ${cwdd}/blacklist ${cwdd}/hosts/

cd ${cwdd}/hosts
python3 updateHostsFile.py --auto --extensions fakenews gambling

cp -f ${cwdd}/hosts/hosts ${cwdd}/dist






