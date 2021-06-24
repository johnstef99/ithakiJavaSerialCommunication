#!/bin/sh
#
# Use this script to quickly save ithaki codes a file
# Just change the credentials and run the script
#
#
#
#
#
#

# PUT YOUR CREDENTIALS HERE
name=IOANNIS
surname=STEFANIDIS
# AEM needs to be 5 digits
aem=09587

# logging in
echo -e "Login in using:\nName: $name\nSurname: $surname\nAEM: $aem\n"
session=$(curl 'http://ithaki.eng.auth.gr/netlab/main.php' \
  -H 'Connection: keep-alive' \
  -H 'Cache-Control: max-age=0' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Origin: http://ithaki.eng.auth.gr' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-GPC: 1' \
  -H 'Referer: http://ithaki.eng.auth.gr/netlab/' \
  -H 'Accept-Language: el,en-US;q=0.9,en;q=0.8' \
  --data-raw "fi=$name&fa=$surname&am=$aem&op=1" \
  --compressed \
  --insecure 2>&1 \
  | grep session \
  | grep -Po 'value="\K[^"]*')
echo -e "Got session: $session\n"

# ask for codes
curl 'http://ithaki.eng.auth.gr/netlab/action.php' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36' \
  -H 'Origin: http://ithaki.eng.auth.gr' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Referer: http://ithaki.eng.auth.gr/netlab/main.php' \
  --data-raw "session=$session&fi=$name&fa=$surname&am=$aem&x=1" \
  --compressed \
  --insecure 2>&1 | grep ":" | grep "=red" | cut -d' ' -f6 > codes

# print codes
echo "Codes for this session:"
cat codes
