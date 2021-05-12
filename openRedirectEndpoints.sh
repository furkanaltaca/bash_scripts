#!/bin/bash

domain=$1
mainPath="/root/recon/$domain"

mkdir -p $mainPath

deleteTempFiles(){
rm -f $mainPath/ragno_urls.txt
}

deleteTempFiles

python3 ~/tools/ragno/ragno.py -d $domain -q -o $mainPath/ragno_urls.txt

cat $mainPath/ragno_urls.txt \
| grep -a -i \=http \
| qsreplace "http://google.com" \
| while read target_url
do
if curl -s -L $target_url -I | grep -e "google.com" -e "HTTP" | grep -q " 301\| 302"
then
 echo $target_url
fi
done

deleteTempFiles
