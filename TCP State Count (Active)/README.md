# TCP State Count Per Port

## Objective

- To count TCP state of NGINX and Varnish base on port they listen to

## How to use

- Put this script in any directory you want
- Add this script into crontab and let it run every minute

``` crontab
* * * * * /var/lib/zabbix/tcpstate.sh &> /tmp/tcpstate.err
```

## Changes

- 2017/09/19
  - First Draft