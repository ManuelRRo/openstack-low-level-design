# Ceph installation
### Configuraciones en cada host


```
su -
```
> Ingresar la contraseña de root

Configurar hostnames en cada host

```
# tambier hacer el cambio en nano /etc/hosts
hostnamectl set-hostname ceph-osd1
hostnamectl set-hostname ceph-osd2
hostnamectl set-hostname ceph-osd3
```

```
nano /etc/network/interfaces
...
auto enp1s0
iface enp1s0 inet static
    address 192.168.31.6
    netmask 255.255.255.0
    gateway 192.168.31.1
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
apt install podman chrony lvm2 sudo curl net-tools sudo
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
cephadm bootstrap --mon-ip 192.168.1.6 --ssh-user icc115
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

##################################################################
###################################################################

Adding key to icc115@localhost authorized_keys...
Adding host ceph-admin...
Deploying mon service with default placement...
Deploying mgr service with default placement...
Deploying crash service with default placement...
Deploying ceph-exporter service with default placement...
Deploying prometheus service with default placement...
Deploying grafana service with default placement...
Deploying node-exporter service with default placement...
Deploying alertmanager service with default placement...
Enabling the dashboard module...
Waiting for the mgr to restart...
Waiting for mgr epoch 9...
mgr epoch 9 is available
Generating a dashboard self-signed certificate...
Creating initial admin user...
Fetching dashboard port number...
Ceph Dashboard is now available at:

	     URL: https://ceph-admin:8443/
	    User: admin
	Password: lrd5cnjuuy

Enabling client.admin keyring and conf on hosts with "admin" label
Saving cluster configuration to /var/lib/ceph/30796ba2-ba87-11f0-9500-5254003b4585/config directory
You can access the Ceph CLI as following in case of multi-cluster or non-default config:

	sudo /usr/sbin/cephadm shell --fsid 30796ba2-ba87-11f0-9500-5254003b4585 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring

Or, if you are only running a single cluster on this host:

	sudo /usr/sbin/cephadm shell 

Please consider enabling telemetry to help improve Ceph:

	ceph telemetry on

For more information see:

	https://docs.ceph.com/en/latest/mgr/telemetry/

Bootstrap complete.
root@ceph-admin:~# 
