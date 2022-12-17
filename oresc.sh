#!/bin/bash

# oresc is a open redirect scanner

url_flag=''
list_flag=''

print_usage() {
  printf "Usage: \n -u url (e.g. https://example.com) \n -l list (e.g. urls.txt)"
}

YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

no_args="true"
while getopts 'u:l:h' flag; do
  case "${flag}" in
    u) url_flag="${OPTARG}" ;;
    l) list_flag="${OPTARG}" ;;
    h) print_usage 
       exit 1 ;;
    *) print_usage 
       exit 1 ;;
  esac
  no_args="false"
done

if [ "$no_args" == "true"  ]
then
   print_usage
   exit
fi


if [ ! -z "$url_flag" ]
then
   echo "$url_flag" > oresc-urls-to-check.txt
elif [ ! -z "$list_flag" ]
then
   cat "$list_flag" > oresc-urls-to-check.txt
fi;


cat oresc-urls-to-check.txt | hakrawler -d 3 -dr -insecure -subs -timeout 1000 -u > urls.txt

cat oresc-urls-to-check.txt | waybackurls >> urls.txt

cat urls.txt \
| grep -a -i \=http \
| qsreplace "http://google.com" \
| while read target_url
do
if curl -s -L $target_url -I | grep -e "google.com" -e "HTTP" | grep -q " 301\| 302"
then
 printf "${YELLOW}[:Vulnerable:]${NO_COLOR} $target_url \n"
fi
done;

rm oresc-urls-to-check.txt hakrawler.txt urls.txt

exit
