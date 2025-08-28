1. Instalar dependencias del entorno virtual
```
pip install git+https://opendev.org/openstack/kolla-ansible@master
```
2. Crear directorio **/etc/kolla**
```
sudo mkdir -p /etc/kolla
sudo chown $USER:$USER /etc/kolla
```
3. Copiar globals.yml y passwords.yml a **/etc/kolla**
```
cp -r /path/to/venv/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
```
4. Copiar el inventario **multinode** al directorio actual
```
cp /path/to/venv/share/kolla-ansible/ansible/inventory/multinode .
```
# Instalar dependencias de Ansible Galaxy
```
kolla-ansible install-deps
```

# Generar contraseñas
```
kolla-genpwd
```
# Configurar globals.yml
- Configuraciones de imagen
```
kolla_base_distro: "ubuntu"
```
- Configuracion de red

Dejaremos comentadas las siguiente lineas porque haremos la configuracion pertinente en el archivo del inventario **multinode**
```
# network_interface: "eth0"
```

```
# neutron_external_interface: "eth1"
```
Escogeremos una ip disponible dentro de la red-1 mencionada en las configuraciones iniciales
```
kolla_internal_vip_address: "192.168.1.20"
```
- Habilitar servicios adicionales
En esta parte habilitaremos cinder,glance y nova.
```
enable_cinder: "yes"
enable_cinder_backend_lvm: "yes"
cinder_backend_ceph: "yes"
glance_backend_ceph: "yes"
nova_backend_ceph: "yes"
```

# Configurar inventario multinode
```
# These initial groups are the only groups required to be modified. The
# additional groups are for more control of the environment.
[control]
# These hostname must be resolvable from your deployment host
localhost       ansible_connection=local network_interface=enp1s0 neutron_external_interface=enp7s0

[network]
neutron_external_interface=enxc8a362be4bf6
localhost ansible_connection=local network_interface=enp1s0 neutron_external_interface=enp7s0

[compute]
compute01 ansible_ssh_user=icc115 network_interface=enp3s0 neutron_external_interface=enxc8a362be4bf6 

[monitoring]
localhost ansible_connection=local network_interface=enp1s0 neutron_external_interface=enp7s0

[storage]
storage01 ansible_ssh_user=icc115 network_interface=enp10s0 neutron_external_interface=enp11s0

[deployment]
localhost ansible_connection=local network_interface=enp1s0 neutron_external_interface=enp7s0

```

# Configurar cinder-volumes
## LVM 
Crear en cada nodo de storage
```
pvcreate /dev/vdb 
vgcreate cinder-volumes /dev/vdb
```