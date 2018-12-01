# TCP State Count Per Port

## How to use

- Put this script in any directory you want
- Add this script into crontab and let it run every minute

``` crontab
* * * * * /var/lib/zabbix/tcpstate.sh &> /tmp/tcpstate.err
```

## Changes

- 2017/09/19
  - First Draft