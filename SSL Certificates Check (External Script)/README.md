# SSL Certificates Check

## Forked from

- URL: [SSL Certificates Check](https://share.zabbix.com/cat-app/web-servers/ssl-certificates-check-new)

## How to use

- Download and put these scripts in any directory such as `</path/to/externalscripts/>`
- Run container [zabbix-proxy-sqlite3](https://hub.docker.com/r/zabbix/zabbix-proxy-sqlite3)

  ``` sh
  docker container run \
  --name zabbix-proxy-sqlite3 \
  --env ZBX_HOSTNAME=pwowzasa802 \
  --env ZBX_SERVER_HOST=<Host_IP> \
  --env ZBX_DEBUGLEVEL=3 \
  --publish 10051:10051 \
  --restart unless-stopped \
  --volume <path/to/externalscripts>:/usr/lib/zabbix/externalscripts \
  --detach zabbix/zabbix-proxy-sqlite3:latest
  ```

- Install openssl in container [zabbix-proxy-sqlite3](https://hub.docker.com/r/zabbix/zabbix-proxy-sqlite3)

  ``` sh
  # docker container exec -it zabbix-proxy-sqlite3 bash
  bash-4.3# apk add --no-cache openssl
  fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/main/x86_64/APKINDEX.tar.gz
  fetch http://dl-cdn.alpinelinux.org/alpine/v3.4/community/x86_64/APKINDEX.tar.gz
  (1/1) Installing openssl (1.0.2n-r0)
  Executing busybox-1.24.2-r14.trigger
  Executing ca-certificates-20161130-r0.trigger
  OK: 74 MiB in 44 packages
  bash-4.3# exit
  #
  ```

- Upload the template into Zabbix Web GUI
- Configure Macros to meet your requirement
  
| Macro | Default Value | Description |
|-------|---------------|-------------|
| {$SNI} | {HOST.NAME} | Allows you to pass a different SNI to openssl on the Zabbix server for site certificate monitoring |
| {$SSL_EXPIRY_NOTCLASSIFIED} | 90 | Threshold of remaining days until expiration to throw a trigger of 'Not Classified' severity |
| {$SSL_EXPIRY_INFO} | 60 | Threshold of remaining days until expiration to throw a trigger of 'Information' severity |
| {$SSL_EXPIRY_AVG} | 30 | Threshold of remaining days until expiration to throw a trigger of 'Average' severity |
| {$SSL_EXPIRY_WARN} | 15 | Threshold of remaining days until expiration to throw a trigger of 'Warning' severity |
| {$SSL_EXPIRY_HIGH} | 7 | Threshold of remaining days until expiration to throw a trigger of 'High' severity |
| {$SSL_HOST} | {HOST.CONN} | Hostname ("Website") to monitor. |
| {$SSL_PORT} | 443 | Port on which to test certificate. |

## Changes

- 2018/12/01
  - Edit zext_ssl_expiry.sh and zext_ssl_issuer.sh to let openssl terminate after operation finish.
  - Edit zext_ssl_expiry.sh to support command `date -d "YYYY-MM-DD HH:MI:SS" +%s` in Alpine Linux which come with [zabbix-proxy-sqlite3](https://hub.docker.com/r/zabbix/zabbix-proxy-sqlite3) container