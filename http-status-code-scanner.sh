#!/bin/bash

list=$1

for site in $(cat $list); 
do 
curl -s -o /dev/null -I -w "%{http_code}" https://$site —max-time 5; 
printf " - $site \n" & 
done > http-codes.txt

echo "Finished. Output file is http_codes.txt."

