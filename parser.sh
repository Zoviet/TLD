#!/bin/bash

#sudo apt install idn

json="[]"

curl -O https://data.iana.org/TLD/tlds-alpha-by-domain.txt

sed -i '1d' tlds-alpha-by-domain.txt | sort

while IFS= read -r line; do
  line=$(idn --idna-to-unicode $line)
  echo $line
  json=$(echo "$json" | jq --arg str "${line,,}" '. + [$str]')
done < tlds-alpha-by-domain.txt

echo "$json" > tld.json

sed -i ':a;N;$!ba;s/\n//g;s/ //g' tld.json
