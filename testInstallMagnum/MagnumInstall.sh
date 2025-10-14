## prerequisites
mysql 

CREATE DATABASE magnum;

GRANT ALL PRIVILEGES ON magnum.* TO 'magnum'@'localhost' \
  IDENTIFIED BY '1c1497a7d91f73562cc17';
GRANT ALL PRIVILEGES ON magnum.* TO 'magnum'@'%' \
  IDENTIFIED BY '1c1497a7d91f73562cc17';

. openrc

openstack user create --domain default \
  --password-prompt magnum

openstack role add --project service --user magnum admin

openstack service create --name magnum \
  --description "OpenStack Container Infrastructure Management Service" \
  container-infra

openstack endpoint create --region RegionOne \
  container-infra public http://172.29.238.46:9511/v1

openstack endpoint create --region RegionOne \
  container-infra internal http://172.29.238.46:9511/v1

openstack endpoint create --region RegionOne \
  container-infra admin http://172.29.238.46:9511/v1

openstack domain create --description "Owns users and projects \
  created by magnum" magnum

openstack user create --domain magnum --password-prompt \
  magnum_domain_admin

# poner esa password 1c1497a7d91f73562cc17

openstack role add --domain magnum --user-domain magnum --user \
  magnum_domain_admin admin

# Install y configura components
DEBIAN_FRONTEND=noninteractive apt-get install magnum-api magnum-conductor 

#######################################33
nano /etc/magnum/magnum.conf
##########################################
[api]
...
host = 172.29.238.46

[certificates]
...
cert_manager_type = x509keypair

# [certificates]
# ...
# cert_manager_type = barbican

##########################################

[cinder_client]
...
region_name = RegionOne

[database]
...
connection = mysql+pymysql://magnum:1c1497a7d91f73562cc17@172.29.236.11:3306/magnum

[keystone_authtoken]
...
memcached_servers = controller:11211
auth_version = v3
www_authenticate_uri = http://172.29.236.11:5000
project_domain_id = default
project_name = service
user_domain_id = default
password = 1c1497a7d91f73562cc17
username = magnum
auth_url = http://172.29.236.11:5000
auth_type = password
admin_user = magnum
admin_password = 1c1497a7d91f73562cc17
admin_tenant_name = service

[trust]
...
trustee_domain_name = magnum
trustee_domain_admin_name = magnum_domain_admin
trustee_domain_admin_password = 1c1497a7d91f73562cc17
trustee_keystone_interface = internal

[oslo_messaging_notifications]
...
driver = messaging

[DEFAULT]
...
transport_url = rabbit://magnum:58da6e769aba46fdbb5afbf4120b3ecf1702f925e58b09b82b0@172.29.236.253:5671