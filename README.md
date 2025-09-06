# openstack-low-level-design

Comandos de instalación para el despliegue de openstack utilizando kolla-ansible con soporte para GPU por medio de PCI Passthrough y conexión externa con cluster ceph

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

virsh list --all
 3    firewall-1                      running
 -    4-ubuntu24.04-kolla-1           shut off
 -    4-ubuntu24.04-kolla-2           shut off
 -    4-ubuntu24.04-kolla-3           shut off
 -    4-ubuntu24.04-kolla-storage01   shut off
 -    5-icc115@vm1                    shut off
 -    5-icc115@vm2                    shut off
 -    5-icc115@vm3                    shut off
 -    5-icc115@vm4                    shut off
 -    k-worker1                       shut off
 -    k-worker1-clone2-template       shut off
 -    k8-master                       shut off
 -    k8-worker2                      shut off
 -    k8-worker3                      shut off

sudo virsh net-define /tmp/br0-net.xml
sudo virsh net-start br0-net
sudo virsh net-autostart br0-net
sudo virsh net-list --all

manuel@manuel-hp:/tmp$ virsh domiflist ubuntu24.04-vm1
 Interface   Type     Source    Model    MAC
------------------------------------------------------------
 vnet2       bridge   br0-net   virtio   52:54:00:26:27:2a

manuel@manuel-hp:/tmp$ virsh domiflist ubuntu24.04-vm2
 Interface   Type     Source    Model    MAC
------------------------------------------------------------
 vnet3       bridge   br0-net   virtio   52:54:00:ad:24:73

manuel@manuel-hp:/tmp$ 


sudo bridge vlan set dev nm-bridge vid 10
sudo bridge vlan set dev nm-bridge vid 20
sudo bridge vlan set dev nm-bridge vid 30
sudo bridge vlan set dev nm-bridge vid 40

sudo bridge vlan add dev vnet7 vid 10
sudo bridge vlan add dev vnet7 vid 20
sudo bridge vlan add dev vnet7 vid 30
sudo bridge vlan add dev vnet7 vid 40

sudo bridge vlan add dev vnet8 vid 10
sudo bridge vlan add dev vnet8 vid 20
sudo bridge vlan add dev vnet8 vid 30
sudo bridge vlan add dev vnet8 vid 40

sudo bridge vlan add dev vnet9 vid 10
sudo bridge vlan add dev vnet9 vid 20
sudo bridge vlan add dev vnet9 vid 30
sudo bridge vlan add dev vnet9 vid 40

sudo bridge vlan add dev enxc8a362be49d8 vid 10
sudo bridge vlan add dev enxc8a362be49d8 vid 20
sudo bridge vlan add dev enxc8a362be49d8 vid 30
sudo bridge vlan add dev enxc8a362be49d8 vid 40



sudo ip link set dev br0 type bridge vlan_filtering 1 vlan_default_pvid 0

sudo bridge vlan add dev vnet1 vid 10 pvid untagged
sudo bridge vlan add dev vnet2 vid 10 pvid untagged
sudo bridge vlan add dev vnet3 vid 10 pvid untagged
sudo bridge vlan add dev enxc8a362be49d8 vid 10

sudo bridge vlan del dev vnet1 vid 10 pvid untagged
sudo bridge vlan del dev vnet2 vid 10 pvid untagged
sudo bridge vlan del dev vnet3 vid 10 pvid untagged
sudo bridge vlan del dev enxc8a362be49d8 vid 10

sudo bridge vlan add dev vnet2 vid 10
sudo bridge vlan add dev vnet2 vid 10
sudo bridge vlan add dev vnet3 vid 10

# Puerto físico al switch/OPNsense como trunk VLAN10
sudo bridge vlan del dev enxc8a362be49d8 vid 10

sudo bridge vlan del dev vnet2 vid 10
sudo bridge vlan del dev vnet2 vid 10
sudo bridge vlan del dev vnet3 vid 10

# Puerto físico al switch/OPNsense como trunk VLAN10
sudo bridge vlan del dev enxc8a362be49d8 vid 10


