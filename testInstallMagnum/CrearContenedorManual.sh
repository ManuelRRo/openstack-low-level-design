sudo lxc-copy -n ubuntu-24-amd64 -N infra1-magnum

# mostar contenido de archivos de config
grep -vE '^(#|$)' /etc/magnum/magnum.conf

systemctl restart magnum-api
systemctl restart magnum-conductor

openssl s_client -connect 172.29.236.253:5671 -servername 172.29.236.253 -brief

# comando para revisar logs fallidos de heat
openstack stack resource list -n 5 7f5245b5-cb75-413b-b203-25777d21d757

# Eventos con detalle (mira los últimos, busca "FAILED", "WaitCondition")
openstack stack event list --nested-depth 5 7f5245b5-cb75-413b-b203-25777d21d757

