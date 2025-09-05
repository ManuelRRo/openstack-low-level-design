# Ejemplos de Configuraciones de Red
## Instalar los siguientes paquetes

```
sudo apt install vlan bridge-utils
```
## VLans y puentes
```
network:
  version: 2
  ethernets: 
    enp1s0:
      dhcp4: no
    enp7s0:
      dhcp4: no
      addresses: [10.0.0.11/24]
    enp10s0:
      dhcp4: yes
  vlans:
    enp1s0.10:
      id: 10
      link: enp1s0
    enp1s0.20:
      id: 20
      link: enp1s0
  bridges:
    br-provider:
      interfaces: [enp1s0]
      dhcp4: no
      addresses: [192.168.122.11/24]
      routes:
        - to: default
        via: 192.168.122.1
      nameservers:
      addresses: [8.8.8.8,8.8.4.4]
    br-manage:
      addresses: [172.168.0.11/22]
      interfaces: [enp1s0.10]

```
## Puente con una interfaz de red
```
network:
  version: 2
  ethernets: 
    enp1s0:
      dhcp4: no
  bridges:
    br-provider:
      interfaces: [enp1s0]
      dhcp4: no
      addresses: [192.168.122.11/24]
      routes:
        - to: default
        via: 192.168.122.1
      nameservers:
      addresses: [8.8.8.8,8.8.4.4]
```

## Host configuration hp-laptop
```
network:
  version: 2
  ethernets:
    enxc8a362be49d8:
      dhcp4: no
    enx00e04c3601d5:
      optional: true
      dhcp4: false
      dhcp6: false
  bridges:
    nm-bridge:
      interfaces: [enxc8a362be49d8]
      dhcp4: no
      addresses: [192.168.31.15/24]
      routes:
        - to: default
          via: 192.168.31.1
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
    br-lan:
      dhcp4: false
      dhcp6: false
      interfaces: [enx00e04c3601d5]
      link-local: []
```

## FIRST TRY VLAN - WAL
```
network:
  version: 2
  ethernets:
    enp1s0:
      dhcp4: no
    enp7s0:
      dhcp4: false
    enp8s0:
      dhcp4: no
      addresses: [10.0.0.11/24]
  vlans:
    enp7s0-vlan20:
      id: 20
      link: enp7s0
  bridges:
    interfaces: [enp7s0-vlan20]
    dhcp4: false
    routes:
      - to: 0.0.0.0
        via: 192.168.2.1
        metric: 100
        on-link: true
    nameservers:
        addresses: [1.1.1.1,8.8.8.8]

```
### SECOND TRY VLAN - 2
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: no
    enp7s0:
      dhcp4: false
    enp8s0:
      dhcp4: no
      addresses: [10.0.0.13/24]
  bridges:
    br0-vlan20:
      dhcp4: no
      interfaces: [enp7s0-vlan20]
      addresses: [192.168.2.8/24]
      routes:
        - to: default
          via: 192.168.2.1
          metric: 100
          on-link: true
      nameservers:
          addresses: [1.1.1.1,8.8.8.8]
    br0-vlan30:
      dhcp4: no
      interfaces: [enp7s0-vlan30]
      addresses: [192.168.3.8/24]
  vlans:
    enp7s0-vlan20:
      id: 20
      link: enp7s0
      accept-ra: no
    enp7s0-vlan30:
      id: 30
      link: enp7s0
      accept-ra: no
```
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s25:
      dhcp4: true
  bridges:
    br0:
      addresses: [ 10.3.99.25/24 ]
      interfaces: [ vlan15 ]
  vlans:
    vlan15:
      accept-ra: no
      id: 15
      link: enp0s25
```
### Consulta configuracion netplan 
Mi máquina host(mi laptop) tiene configurado los siguientes bridges 
Utilizo nm-bridge para usar en kvm con la red WAN de opnsense
Utilizo br-lan para usar en kvm con la red LAN de opnsense
y ya instale en ambas máquinas virtuales los paqutes de vlan y bridge-utils

```
apt install vlan bridge-utils
```

```
network:
  version: 2
  ethernets:
    enxc8a362be49d8:
      dhcp4: no
    enx00e04c3601d5:
      optional: true
      dhcp4: false
      dhcp6: false
  bridges:
    nm-bridge:
      interfaces: [enxc8a362be49d8]
      dhcp4: no
      addresses: [192.168.31.15/24]
      routes:
        - to: default
          via: 192.168.31.1
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
    br-lan:
      dhcp4: false
      dhcp6: false
      interfaces: [enx00e04c3601d5]
      link-local: []
```
tengo dos máquinas virtuales(vm3,vm4) con la siguiente configuracion de vlans

VLAN20 -> 192.168.2.0/24

VLAN30 -> 192.168.3.0/24

Y en kvm estoy usando el bridge br-lan para la interfaz **enp7s0**
Al configurar de la siguiente manera las máquinas si recibo ping en las vlan
### vm3 
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: no
    enp7s0:
      dhcp4: no
    enp8s0:
      dhcp4: false
      addresses: [10.0.0.12/24]
  vlans:
    enp7s0-vlan20:
      id: 20
      link: enp7s0
      addresses: [192.168.2.7/24]
      routes:
        - to: default
          via: 192.168.2.1
    enp7s0-vlan30:
      id: 30
      link: enp7s0
      addresses: [192.168.3.7/24]
```
### vm4
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: no
    enp7s0:
      dhcp4: no
    enp8s0:
      dhcp4: false
      addresses: [10.0.0.13/24]
  vlans:
    enp7s0-vlan20:
      id: 20
      link: enp7s0
      addresses: [192.168.2.8/24]
      routes:
        - to: default
          via: 192.168.2.1
    enp7s0-vlan30:
      id: 30
      link: enp7s0
      addresses: [192.168.2.8/24]

```

Pero de la siguiente manera utilizando los bridge no logran comunicarse mediante ping las dos máquinas virtuales

### vm3
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: no
    enp7s0:
      dhcp4: false
    enp8s0:
      dhcp4: no
      addresses: [10.0.0.13/24]
  bridges:
    br0-vlan20:
      dhcp4: no
      interfaces: [enp7s0-vlan20]
      addresses: [192.168.2.7/24]
      routes:
        - to: default
          via: 192.168.2.1
          metric: 100
          on-link: true
      nameservers:
          addresses: [1.1.1.1,8.8.8.8]
    br0-vlan30:
      dhcp4: no
      interfaces: [enp7s0-vlan30]
      addresses: [192.168.3.8/24]
  vlans:
    enp7s0-vlan20:
      id: 20
      link: enp7s0
      accept-ra: no
    enp7s0-vlan30:
      id: 30
      link: enp7s0
      accept-ra: no
```

### vm4
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: no
    enp7s0:
      dhcp4: false
    enp8s0:
      dhcp4: no
      addresses: [10.0.0.13/24]
  bridges:
    br0-vlan20:
      dhcp4: no
      interfaces: [enp7s0-vlan20]
      addresses: [192.168.2.8/24]
      routes:
        - to: default
          via: 192.168.2.1
          metric: 100
          on-link: true
      nameservers:
          addresses: [1.1.1.1,8.8.8.8]
    br0-vlan30:
      dhcp4: no
      interfaces: [enp7s0-vlan30]
      addresses: [192.168.3.8/24]
  vlans:
    enp7s0-vlan20:
      id: 20
      link: enp7s0
      accept-ra: no
    enp7s0-vlan30:
      id: 30
      link: enp7s0
      accept-ra: no
```

Ya habilite todas las reglas del firewall en pass para que no haya problema con el trafico pero aun asi con la configuracion del bridge no funciona el ping entre hosts solo hace ping al gateway de cada vlan.

Qué otras configuraciones podría intentar para utilizar el bridge
     

```
sudo bridge br-lan vlan show

```

sudo ovs-vsctl set port vnet6 trunks=10,20,30
sudo ovs-vsctl set port vnet12 trunks=10,20,30
sudo ovs-vsctl set port vnet17 trunks=10,20,30
sudo ovs-vsctl set port vnet21 trunks=10,20,30
sudo ovs-vsctl set port vnet22 trunks=10,20,30

sudo ovs-vsctl set port vnet17 trunks=10,20,30
sudo ovs-vsctl set port vnet22 trunks=10,20,30

sudo ovs-vsctl list port vnet17
_uuid               : ec4c9a11-c270-478b-8510-35a348191cc4
bond_active_slave   : []
bond_downdelay      : 0
bond_fake_iface     : false
bond_mode           : []
bond_updelay        : 0
cvlans              : []
external_ids        : {}
fake_bridge         : false
interfaces          : [70f20409-02bb-4a42-b67b-02921e43e362]
lacp                : []
mac                 : []
name                : vnet17
other_config        : {}
protected           : false
qos                 : []
rstp_statistics     : {}
rstp_status         : {}
statistics          : {}
status              : {}
tag                 : []
trunks              : [10, 20, 30]
vlan_mode           : []
manuel@manuel-hp:~$ sudo ovs-vsctl list port vnet21
_uuid               : b9f605da-2830-43c6-99c5-3162d969128c
bond_active_slave   : []
bond_downdelay      : 0
bond_fake_iface     : false
bond_mode           : []
bond_updelay        : 0
cvlans              : []
external_ids        : {}
fake_bridge         : false
interfaces          : [8f35c9aa-0ff7-4385-b601-7b74635a0dca]
lacp                : []
mac                 : []
name                : vnet21
other_config        : {}
protected           : false
qos                 : []
rstp_statistics     : {}
rstp_status         : {}
statistics          : {}
status              : {}
tag                 : []
trunks              : []
vlan_mode           : []
