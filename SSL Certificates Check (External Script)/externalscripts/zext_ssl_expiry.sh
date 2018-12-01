#!/bin/sh

SERVER=$1
TIMEOUT=25
RETVAL=0
SNI=$3
TIMESTAMP=`echo | date`

if [ -z "$2" ]
then
    PORT=443
else
    PORT=$2;
fi

EXPIRE_DATE=`echo QUIT | openssl s_client -connect $SERVER:$PORT -servername $SNI 2>/dev/null | openssl x509 -noout -dates 2>/dev/null | grep notAfter | cut -d'=' -f2 | awk '{
    if($1=="Jan"){mm=01}
    else if($1=="Feb"){mm=02}
    else if($1=="Mar"){mm=03}
    else if($1=="Apr"){mm=04}
    else if($1=="May"){mm=05}
    else if($1=="Jun"){mm=06}
    else if($1=="Jul"){mm=07}
    else if($1=="Aug"){mm=08}
    else if($1=="Sep"){mm=09}
    else if($1=="Oct"){mm=10}
    else if($1=="Nov"){mm=11}
    else if($1=="Dec"){mm=12}
    else{mm=13}
    printf("%s-%s-%02d %s", $4, mm, $2, $3);
}'`

EXPIRE_SECS=`date -d "${EXPIRE_DATE}" +%s`
EXPIRE_TIME=$(( ${EXPIRE_SECS} - `date +%s` ))

if test $EXPIRE_TIME -lt 0
then
    RETVAL=0
else
    RETVAL=$(( ${EXPIRE_TIME} / 24 / 3600 ))
fi

echo ${RETVAL}