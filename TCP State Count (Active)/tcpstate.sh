#!/bin/bash

#-----------------------------------------------------------#
#   Author Name : Sawit Meekwamdee                          #
#   Program     : tcpstate.sh                               #
#   Description : Count TCP state each port                 #
#-----------------------------------------------------------#
#
# Change History
#   v1.0    19/09/2017 Sawit M. - First draft

test -z $1 && ( echo "Error: please supply port"; exit 1; )
PORT=$1

(
/usr/sbin/ss -ant sport eq :${PORT} | grep -v ^State | awk -v dd="`date +'%s'`" -v app="NGINX" '
BEGIN {
    s["ESTAB"] = 0;
    s["SYN-SENT"] = 0;
    s["SYN-RECV"] = 0;
    s["FIN-WAIT-1"] = 0;
    s["FIN-WAIT-2"] = 0;
    s["TIME-WAIT"] = 0;
    s["CLOSED"] = 0;
    s["CLOSE-WAIT"] = 0;
    s["LAST-ACK"] = 0;
    s["LISTEN"] = 0;
    s["CLOSING"] = 0;
}{
    a[$1]++;
}END{
    for(i in a) {
        s[i] = a[i];
    }
    for (i in s) {
        printf(" - %s.TCP[%s] %d %d\n", app, i, dd, s[i]);
    }
}'
) | zabbix_sender -vv -T -r -c /etc/zabbix/zabbix_agentd.conf -s `hostname` -i -