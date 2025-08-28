# Ceph installation
### Configuraciones en cada host


```
su -
```
> Ingresar la contraseña de root

Configurar hostnames en cada host

```
hostnamectl set-hostname ceph-1
hostnamectl set-hostname ceph-2
hostnamectl set-hostname ceph-3
```

```
nano /etc/network/interfaces
...
auto enp1s0
iface enp1s0 inet static
    address 192.168.1.6
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 8.8.8.8 8.8.4.4

```

```
nano /etc/resolv.conf
...
nameserver 8.8.8.8 
nameserver 8.8.4.4
```


```
apt update
```
```
apt install podman chrony lvm2 sudo curl
```

```
usermod -aG sudo icc115
```

```
echo 'icc115 ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/99-icc115-nopasswd
sudo chmod 440 /etc/sudoers.d/99-icc115-nopasswd
sudo visudo -cf /etc/sudoers.d/99-icc115-nopasswd   # debe decir “/etc/sudoers.d/...: parsed OK”

```

## Configuracion en ceph-1
```
CEPH_RELEASE=19.2.2
```
```
curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
```

```
sudo chmod +x cephadm
```
```
./cephadm add-repo --release squid
```
```
./cephadm install 
```

```
cephadm bootstrap --mon-ip 192.168.1.6 --ssh-user debian
```

> acceder via ip https://192.168.1.6:8443 


```
cephadm install ceph-common
```

```
ceph status
```

```
ssh-copy-id -f -i /etc/ceph/ceph.pub icc115@192.168.1.7
ssh-copy-id -f -i /etc/ceph/ceph.pub icc115@192.168.1.8
```

```
ceph orch host add ceph-2 192.168.1.7 --labels _admin
ceph orch host add ceph-3 192.168.1.8 --labels _admin
```
```
ceph orch apply osd --all-available-devices
```

```
ceph osd ls
```
```
ceph osd
```
> **Crear rbd pool desde la interfaz web con los valores por defecto**
```
ceph -s
```
> agregar tag mds en ceph-2 desde el dashboard y luego

```
ceph fs volume create cephfs --placement="label:mds"
```
> Agregar tag rgw a ceph-1 y ceph-2 desde el dashboard

```
ceph orch apply rgw radosgw '--placement=label:rgw count-per-host:1' --port=8001
```

```
ceph osd pool ls
```
