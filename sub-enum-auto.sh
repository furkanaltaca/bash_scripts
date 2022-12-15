#!/bin/bash

domain=$1
working_dir=$(pwd)

# assetfinder
assetfinder $domain > assetfinder.txt &&

# subfinder
subfinder -silent -d $domain -o subfinder.txt >/dev/null &&

# sudomy
cd /opt/Sudomy &&
sudo ./sudomy -d $domain -o $working_dir --no-probe >/dev/null&&
cd $working_dir
cp Sudomy-Output/$domain/subdomain.txt sudomy.txt &&
sudo rm -rf Sudomy-Output

#crtsh
curl -i -k "https://crt.sh/?q=%25.$domain" | html2text > crtsh-response.txt &&
cat crtsh-response.txt | awk -F " " '{print $5}' | grep $domain | sort -u > crtsh.txt &&
sudo rm -rf crtsh-response.txt

# append all subdomains in a file
cat assetfinder.txt subfinder.txt sudomy.txt crtsh.txt | sort -u > subdomains.txt &&

sudo rm -rf assetfinder.txt subfinder.txt sudomy.txt crtsh.txt

echo -e "$(cat subdomains.txt|wc -l) domains found. \n Directory: ./subdomains.txt \n Finished."

exit


