#!/bin/bash

domain=$1
mainPath="/root/recon/$domain"

mkdir -p $mainPath

python3 ~/tools/ragno/ragno.py -d $domain -q -o $mainPath/ragno_urls.txt

rm -f $mainPath/openRedirectEndpoints.txt
cat $mainPath/ragno_urls.txt \
| grep -a -i \=http \
| qsreplace "http://google.com" \
| while read target_url do; \
do curl -s -L $target_url -I \
| grep "google.com" \
| grep -e "location" -e "Location" \
>> $mainPath/openRedirectEndpoints.txt; done
