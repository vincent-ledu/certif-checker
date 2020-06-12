#!/bin/bash


function check_certs_behind_lb () {
  if [ -z "$1" ]
  then
    echo "domain name missing"
    exit 1
  fi
  name="$1"
  shift

  now_epoch=$( date +%s )

  dig +noall +answer $name | while read _ _ _ _ ip;
  do
    echo -n "Domain: $name - $ip:"
    expiry_date=$( echo | openssl s_client -showcerts -servername $name -connect $ip:443 2>/dev/null | openssl x509 -inform pem -noout -enddate | cut -d "=" -f 2 )
    echo -n " $expiry_date";
    expiry_epoch=$( date -d "$expiry_date" +%s )
    expiry_days="$(( ($expiry_epoch - $now_epoch) / (3600 * 24) ))"
    echo "    $expiry_days days"
  done
}

function check_certs_simple () {
  line='-------------------------'

  if [ -z "$1" ]; then
    echo "domain name missing"
    exit 1
  fi
  name="$1"
  if [ $# -eq 2 ]; then
    PORT=$2
  else
    PORT=443
  fi
  shift

  now_epoch=$( date +%s )

  expiry_date=$( echo | openssl s_client -showcerts -servername $name -connect $name:$PORT 2>/dev/null | openssl x509 -inform pem -noout -enddate | cut -d "=" -f 2 )
  expiry_epoch=$( date -d "$expiry_date" +%s )
  expiry_days="$(( ($expiry_epoch - $now_epoch) / (3600 * 24) ))"
  printf "%s %s %sdays left\n" $name "${line:${#name}} $expiry_days"
}

while read line
do
  check_certs_simple "$line"
done < "${1:-/dev/stdin}"
