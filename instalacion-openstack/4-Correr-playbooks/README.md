# Despliegue

1. Crear dependencias de despliegue en cola
```
kolla-ansible bootstrap-servers -i ./multinode
```
2. Revisar configuración en cada host
```
kolla-ansible prechecks -i ./multinode
```
3. Desplegar openstack
```
kolla-ansible deploy -i ./multinode
```

# Instalar Openstack Client
1. Instalar cliente via pip
```
pip install python-openstackclient -c https://releases.openstack.org/constraints/upper/master
```
2. Instalar heat client
```
pip install python-heatclient
```

3. Generar credenciales del usuario admin
```
kolla-ansible post-deploy -i multinode
```
> Ejecuta en la ruta donde se encuentra el archivo multinode
4. Copia la contraseña del usuario admin del archivo /etc/kolla/clouds.yml

5. Crear el archivo **admin-openrc** en tu directorio actual y modifica tu contraseña y ip del controller

```
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=
export OS_AUTH_URL=http://192.168.1.20:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```
6. Aplicar las variables de entorno
```
. admin-openrc
```

7. **OPCIONAL**: Correr script init-runonce para comprobar el funcionamiento de los servicios básicos de openstack.

Modificar la red de neutron de acuerdo a tu configuración
```
ENABLE_EXT_NET=${ENABLE_EXT_NET:-1}
EXT_NET_CIDR=${EXT_NET_CIDR:-'192.168.1.0/24'}
EXT_NET_RANGE=${EXT_NET_RANGE:-'start=192.168.1.150,end=192.168.1.199'}
EXT_NET_GATEWAY=${EXT_NET_GATEWAY:-'192.168.1.1'}
```

Cambiar permisos de ejecución
```
chmod +x init-runonce
```

Ejecutar Script

```
./init-runonce
```