# Configuración para conectarse a un cluster externo
## Crear pools

Realizar las siguientes configuraciones en el node de administración 
del cluster ceph

```
ceph osd pool create images
ceph osd pool create volumes
ceph osd pool create backups
ceph osd pool create vms
```

## Inicializar pools

```
rbd pool init images
rbd pool init volumes
rbd pool init backups
rbd pool init vms
```

## Crear usuarios
```
ceph auth get-or-create client.glance mon 'profile rbd' osd 'profile rbd pool=images' mgr 'profile rbd pool=images' -o /etc/ceph/ceph.client.glance.keyring

ceph auth get-or-create client.cinder mon 'profile rbd' osd 'profile rbd pool=volumes, profile rbd pool=vms, profile rbd-read-only pool=images' mgr 'profile rbd pool=volumes, profile rbd pool=vms' -o /etc/ceph/ceph.client.cinder.keyring

ceph auth get-or-create client.cinder-backup mon 'profile rbd' osd 'profile rbd pool=backups' mgr 'profile rbd pool=backups' -o /etc/ceph/ceph.client.cinder-backup.keyring
```
> Despues de ejecutar cada uno de los comandos anteriores apareceran las credenciales de cada usario tomar nota porque se utilizarán más adelante  

# Configuracion en el nodo de despliegue

## Modificar en /etc/kolla/globals.yml

```
glance_backend_ceph: "yes"
cinder_backend_ceph: "yes"
nova_backend_ceph: "yes"
```

## Crear carpeta /etc/kolla/config en el nodo de despliegue con la siguiente estructura

```
└── config
    ├── cinder
    │   ├── cinder-backup
    │   │   ├── ceph.client.cinder-backup.keyring
    │   │   └── ceph.client.cinder.keyring
    │   └── cinder-volume
    │       ├── ceph.client.cinder.keyring
    │       └── ceph.conf
    ├── glance
    │   ├── ceph.client.glance.keyring
    │   └── ceph.conf
    └── nova
        ├── ceph.client.cinder.keyring
        └── ceph.conf
```
> Copiar las claves generadas anteriormente en su correspondiente usuario.

## Contenido de ceph.conf

```
[global]
fsid = b310aeec-8321-11f0-acbb-5254002d0f58
mon_host = 192.168.1.6,192.168.1.7,192.168.1.8
auth_cluster_required = cephx
auth_service_required = cephx
auth_client_required = cephx
```
> Adaptaló a tu configuración actual de ceph la puedes encontrar en el nodo de administración del cluster ceph en la siguiente ruta **/etc/ceph/ceph.conf**

