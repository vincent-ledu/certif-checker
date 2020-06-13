#!/bin/bash

###############################################################################
####                                                                       ####
####  Script from https://stackoverflow.com/a/47878528/12325517            ####
####                                                                       ####
###############################################################################

function check_certs_simple () {
  line='-------------------------------------'

  if [ -z "$1" ]; then
    echo "Usage: $0 domain [PORT:443]"
    echo "  Exemple: $0 stackoverflow.com"
    echo "  Exemple: $0 stackoverflow.com 443"
    exit 1
  fi
  DOMAIN="$1"
  if [ $# -eq 2 ]; then
    PORT=$2
  else
    PORT=443
  fi
  
  OPTIONS=""
  if [ $PORT = "5432" ]; then
    # this is default port for postgre. using starttls postgres option
    OPTIONS="$OPTIONS -starttls postgres"
  fi

  now_epoch=$( date +%s )

  expiry_date=$( echo | openssl s_client $OPTIONS -showcerts -servername $DOMAIN \
    -connect $DOMAIN:$PORT 2>/dev/null | \
    openssl x509 -inform pem -noout -enddate | cut -d "=" -f 2 )
  expiry_epoch=$( date -d "$expiry_date" +%s )
  expiry_days="$(( ($expiry_epoch - $now_epoch) / (3600 * 24) ))"
  printf "%s %s %sdays left\n" $DOMAIN "${line:${#DOMAIN}} $expiry_days"
}

while read line
do
  check_certs_simple $line
done < "${1:-/dev/stdin}"
