#!/bin/bash

# subenum is a subdomain enumeration automate script

domain=$1
working_dir=$(pwd)

# assetfinder
assetfinder $domain > assetfinder.txt &&

# subfinder
subfinder -silent -d $domain -o subfinder.txt >/dev/null &&

#crtsh
curl -i -k "https://crt.sh/?q=%25.$domain" | html2text > crtsh-response.txt &&
cat crtsh-response.txt | awk -F " " '{print $5}' | grep $domain | sort -u > crtsh.txt &&
rm crtsh-response.txt

# append all subdomains in a file
cat assetfinder.txt subfinder.txt crtsh.txt | sort -u > subdomains.txt &&

rm assetfinder.txt subfinder.txt crtsh.txt

echo -e "$(cat subdomains.txt|wc -l) domains found. \n Directory: ./subdomains.txt \n Finished."

exit


