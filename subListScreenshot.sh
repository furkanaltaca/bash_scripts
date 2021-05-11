#!/bin/bash

mkdir ~/recon/$1
python3 ~/tools/Sublist3r/sublist3r.py -d $1 -o ~/recon/$1/subdomains.txt 
cat ~/recon/$1/subdomains.txt | httprobe > ~/recon/$1/httprobe.txt 
cat ~/recon/$1/httprobe.txt | grep https:// > ~/recon/$1/https.txt
cat ~/recon/$1/httprobe.txt | grep http:// > ~/recon/$1/http.txt
python3 ~/tools/EyeWitness/Python/EyeWitness.py -f ~/recon/$1/https.txt --web -d ~/recon/$1/eyewitness/https
python3 ~/tools/EyeWitness/Python/EyeWitness.py -f ~/recon/$1/http.txt --web -d ~/recon/$1/eyewitness/http
