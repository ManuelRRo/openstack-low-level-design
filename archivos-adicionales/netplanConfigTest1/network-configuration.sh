openstack network create ext-net \
  --external --share \
  --provider-network-type flat \
  --provider-physical-network flat

openstack subnet create --network ext-net \
  --allocation-pool start=192.168.31.101,end=192.168.31.150 \
  --dns-nameserver 8.8.4.4 --gateway 192.168.31.1 \
  --subnet-range 192.168.31.0/24 ext-net

openstack network create selfservice

openstack subnet create --network selfservice \
  --dns-nameserver 8.8.4.4 --gateway 172.16.1.1 \
  --subnet-range 172.16.1.0/24 selfservice
  
openstack router create router

openstack router add subnet router selfservice

openstack router set router --external-gateway ext-net

openstack port list --router router


openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano


openstack keypair create --public-key id_rsa.pub mykey


openstack security group rule create --proto icmp default

openstack security group rule create --proto tcp --dst-port 22 default


wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img

glance image-create --name "cirros" \
  --file cirros-0.4.0-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --visibility=public

openstack server create --flavor m1.nano --image cirros \
  --nic net-id=0622173a-a331-4eba-bb70-5d0e1aaeb40d --security-group default \
  --key-name mykey selfservice-instance

openstack floating ip create ext-net

openstack server add floating ip selfservice-instance 203.0.113.104
