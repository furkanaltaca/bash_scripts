#!/bin/bash

domain=$1
mainPath="/root/recon/$domain"

mkdir -p $mainPath

rm -f $mainPath/ragno_urls.txt
rm -f $mainPath/openRedirectEndpoints.txt
rm -f $mainPath/qsreplace.txt

python3 ~/tools/ragno/ragno.py -d $domain -q -o $mainPath/ragno_urls.txt

cat $mainPath/ragno_urls.txt \
| grep -a -i \=http \
| qsreplace "http://google.com" > $mainPath/qsreplace.txt

while read target_url
do
if curl -s -L $target_url -I | grep -e "google.com" -e "HTTP" | grep -q "301\|302"
then
 echo $target_url >> $mainPath/openRedirectEndpoints.txt
fi
done < $mainPath/qsreplace.txt

rm -f $mainPath/ragno_urls.txt
rm -f $mainPath/qsreplace.txt
