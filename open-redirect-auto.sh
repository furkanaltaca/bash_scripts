#!/bin/bash

domain=$1

python3 /opt/ragno/ragno.py -d $domain -q -o ragno_urls.txt

cat ragno_urls.txt \
| grep -a -i \=http \
| qsreplace "http://google.com" \
| while read target_url
do
if curl -s -L $target_url -I | grep -e "google.com" -e "HTTP" | grep -q " 301\| 302"
then
 echo $target_url
fi
done


