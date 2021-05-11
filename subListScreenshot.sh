#!/bin/bash

domain=$1
mainPath="/root/recon/$1"
mkdir -p $mainPath

python3 ~/tools/Sublist3r/sublist3r.py -d $domain -o $mainPath/subdomains.txt

cat $mainPath/subdomains.txt | httprobe > $mainPath/httprobe.txt
cat $mainPath/httprobe.txt | grep https:// > $mainPath/https.txt
cat $mainPath/httprobe.txt | grep http:// > $mainPath/http.txt

mkdir -p $mainPath/eyewitness
python3 ~/tools/EyeWitness/Python/EyeWitness.py -f $mainPath/https.txt -d $mainPath/eyewitness/https --web --no-prompt
python3 ~/tools/EyeWitness/Python/EyeWitness.py -f $mainPath/http.txt -d $mainPath/eyewitness/http --web --no-prompt

echo "done. path: $mainPath/eyewitness/"

