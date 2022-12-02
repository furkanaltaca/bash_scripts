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

# merge and output all subdomains with httprobe
cat assetfinder.txt subfinder.txt sudomy.txt | sort -u > subdomains.txt &&
cat subdomains.txt | httprobe > httprobe.txt &&

sudo rm -rf assetfinder.txt subfinder.txt sudomy.txt

echo -e "$(cat all-unique-subdomains.txt|wc -l) domains found. \n Files: subdomains.txt, httprobe.txt \n Finished."
