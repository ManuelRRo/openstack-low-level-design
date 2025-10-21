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
openstack flavor create --id 0 --vcpus 1 --ram 512 --disk 20 m1.tiny
openstack flavor create --id 2 --ram 2048 --disk 20 --vcpus 1 m1.small
openstack flavor create --id 1 --vcpus 1 --ram 512 --disk 20 m1.medium
openstack flavor create --id 2 --vcpus 1 --ram 1024 --disk 20 m1.large
openstack flavor create --id 4 --vcpus 4 --ram 8192 --disk 80 m1.x-large


openstack keypair create --public-key id_rsa.pub mykey

openstack security group rule create --proto icmp default

openstack security group rule create --proto tcp --dst-port 22 default


wget https://github.com/cirros-dev/cirros/releases/download/0.6.3/cirros-0.6.3-aarch64-disk.img
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

glance image-create --name "ubuntu-noble" \
  --file noble-server-cloudimg-amd64.img \
  --disk-format qcow2 --container-format bare \
  --property os_type=linux \
  --visibility=public

glance image-create --name "cirros" \
  --file cirros-0.6.3-aarch64-disk.img \
  --disk-format qcow2 --container-format bare \
  --property os_type=linux \
  --visibility=public

openstack server create --flavor m1.medium --image ubuntu-noble \
  --nic net-id=4cb1c162-5ac0-4a6f-a309-6e26767ac3b5 --security-group default \
  --key-name mykey ubuntu

openstack floating ip create ext-vlan

openstack server add floating ip selfservice-instance 203.0.113.104


# logearse como superusuario para resolver elprobrema de certificados de ssl
# actualizar el certificado de ese archivo y probrar luego con curl si ya actualiza
sudo -i
sudo i
vi /etc/pki/ca-trust/source/anchors/opnenstack-ca.crt
update-ca-trust
curl -v https://192.168.31.11:5000/v3
sudo journalctl -u heat-container-agent -f




