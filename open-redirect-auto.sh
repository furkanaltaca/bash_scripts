#!/bin/bash

domain=$1

echo $domain | hakrawler -d 3 -dr -insecure -subs -timeout 1000 -u > hakrawler.txt

cat hakrawler.txt \
| grep -a -i \=http \
| qsreplace "http://google.com" \
| while read target_url
do
if curl -s -L $target_url -I | grep -e "google.com" -e "HTTP" | grep -q " 301\| 302"
then
 echo $target_url
fi
done


