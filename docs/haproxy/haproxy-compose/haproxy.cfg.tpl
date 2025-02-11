# _version=1

global
  daemon
  user haproxy
  group haproxy
  stats timeout 30s
  maxconn 4000

defaults
  mode http
  log global
  option httplog
  option dontlognull
  option http-server-close
  option redispatch
  timeout http-request    10s
  timeout queue           1m
  timeout connect         10s
  timeout client          1m
  timeout server          1m
  timeout http-keep-alive 10s
  timeout check           10s
  maxconn                 3000

userlist dataplaneapi
  user admin insecure-password admin

listen stats
  bind :1936
  log global
  stats enable
  stats uri /stats
  stats hide-version
  stats refresh 30s
  stats show-node
  stats show-desc Stats for HAProxy
  stats auth admin:admin

program api
  command /usr/bin/dataplaneapi --host 0.0.0.0 --port 5555 --haproxy-bin /usr/sbin/haproxy --config-file /usr/local/etc/haproxy/haproxy.cfg --reload-cmd "kill -SIGUSR2 1" --reload-delay 5 --userlist dataplaneapi
  no option start-on-reload
