sudo lxc-copy -n ubuntu-24-amd64 -N infra1-magnum

# mostar contenido de archivos de config
grep -vE '^(#|$)' /etc/magnum/magnum.conf

systemctl restart magnum-api
systemctl restart magnum-conductor

openssl s_client -connect 172.29.236.253:5671 -servername 172.29.236.253 -brief
