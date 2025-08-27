# Ceph installation
Configurar hostnames en cada host

```
sudo hostnamectl set-hostname ceph-1
sudo hostnamectl set-hostname ceph-2
sudo hostnamectl set-hostname ceph-3
```

```
sudo apt update
```
```
sudo apt install podman chrony lvm2
```
```
CEPH_RELEASE=19.2.2
```
```
curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH-RELEASE}/el9/noarch/cepadm 
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
cephadm bootstrap --mon-ip 192.168.31.30 --ssh-user debian
```

```
go to the ip
```

```
cephadm install ceph-common
```

```
ceph status
```

```
ssh-copy-id -f -i /etc/ceph/ceph.pub debian@192.168.31.31
ssh-copy-id -f -i /etc/ceph/ceph.pub debian@192.168.31.32
```

```
ceph orch host add ceph-2 192.168.31.31 --labels _admin
ceph orch host add ceph-3 192.168.31.32 --labels _admin
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

```
ceph -s
```
agregar tag mds en ceph-2 desde el dashboard y luego

```
ceph fs volume create cephfs --placement="label:mds"
```
Agregar rgw a ceph-1 y ceph-2 desde el dashboard

```
ceph orch apply rgw radosgw '--placement=label:rgw count-per-host:1' --port=8001
```

```
ceph osd pool ls
```
