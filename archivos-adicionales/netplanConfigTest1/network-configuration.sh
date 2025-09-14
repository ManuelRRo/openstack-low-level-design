openstack network create ext-net \
  --external --share \
  --provider-network-type flat \
  --provider-physical-network physnet1

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

# Create Vlan Network instead of external 
openstack network create ext-vlan \
  --external --share \
  --provider-network-type vlan \
  --provider-physical-network physnet1 \
  --provider-segment 40

openstack subnet create ext-vlan-subnet \
  --network ext-vlan \
  --subnet-range 172.29.248.0/22 \
  --gateway 172.29.248.1 \
  --allocation-pool start=172.29.248.100,end=172.29.251.200 \
  --dns-nameserver 8.8.4.4 \
  --no-dhcp

openstack network create selfservice
openstack subnet create selfservice-subnet \
  --network selfservice \
  --subnet-range 172.16.1.0/24 \
  --gateway 172.16.1.1 \
  --dns-nameserver 8.8.4.4

openstack router create router
openstack router add subnet router selfservice-subnet
openstack router set router --external-gateway ext-vlan
openstack port list --router router

#################################
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
openstack flavor create --id 0 --vcpus 1 --ram 512 --disk 20 m1.medium


openstack keypair create --public-key id_rsa.pub mykey

openstack security group rule create --proto icmp default

openstack security group rule create --proto tcp --dst-port 22 default


wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

glance image-create --name "ubuntu-noble" \
  --file noble-server-cloudimg-amd64.img \
  --disk-format qcow2 --container-format bare \
  --property os_type=linux \
  --visibility=public

openstack server create --flavor m1.medium --image ubuntu-noble \
  --nic net-id=4ae01051-271c-4a9c-a0a4-1f69cf3bc7b5 --security-group default \
  --key-name mykey ubuntu

openstack floating ip create ext-vlan

openstack server add floating ip selfservice-instance 203.0.113.104



