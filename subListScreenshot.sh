#!/bin/bash

mainPath="recon/$1"
mkdir ~/$mainPath
python3 ~/tools/Sublist3r/sublist3r.py -d $1 -o ~/$mainPath/subdomains.txt 
cat ~/$mainPath/subdomains.txt | httprobe > ~/$mainPath/httprobe.txt
cat ~/$mainPath/httprobe.txt | grep https:// > ~/$mainPath/https.txt
cat ~/$mainPath/httprobe.txt | grep http:// > ~/$mainPath/http.txt
python3 ~/tools/EyeWitness/Python/EyeWitness.py -f ~/$mainPath/https.txt --web -d ~/$mainPath/eyewitness/https
python3 ~/tools/EyeWitness/Python/EyeWitness.py -f ~/$mainPath/http.txt --web -d ~/$mainPath/eyewitness/http
