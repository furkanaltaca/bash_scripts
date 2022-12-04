#!/bin/bash

list=$1

mkdir third-levels

for domain in $(cat $list | grep -Po "(\w+\.\w+\.\w+)$" | sort -u);
do
subfinder -d $domain -o third-levels/$domain.txt
cat third-levels/$domain.txt | sort -u >> all-third-level-domains.txt;
done
