# Kolla ansible

Vamos a deplegar kolla-ansible en modo multinodo utilizando dos máquinas virtuales **(control01,storage01)** y una física **(compute01)** con la siguiente configuración.

- control01
    - OS ubuntu 24.04 noble
    - 2 interfaces de red
    - 8GB ram
    - 40GB de disco duro
- compute01
    - OS ubuntu 24.04 noble
    - 2 interfaces de red
    - 8GB ram
    - 2 discos uno de 40GB y uno de 100GB
- storage01
    - OS ubuntu 24.04 noble
    - 2 interfaces de red
    - 32GB de ram
    - 1TB de disco duro 

El **control01** será nuestro nodo de **control**, **storage01** será el nodo de **storage** y el **compute01** el nodo de **compute**.

# Configuración de red
<center>
<img src="../instalacion-openstack/image-1.png">
</center>

## Cambiar hostname
```
hostnamectl set-hostname hostname
```
> por ejemplo para establecer el nombre de control01 como hostname utiliza: **hostnamectl set-hostname control01**
## Configuracion de /etc/netplan/05-netplan.yml para las tres máquinas
```
network:
  version: 2
  ethernets:
    enp1s0: # interfaz de red interna
      dhcp4: no
      addresses: [192.168.31.14/24] # dirección ip
      routes:
        - to: default
          via: 192.168.31.1
      nameservers:
          addresses: [8.8.8.8,8.8.4.4]
    enp7s0: # interfaz de red externa
      dhcp4: no
      dhcp6: no
      accept-ra: false

```
> Nota: cambiar la direccion ip y el nombre de la interfaz de red de acorde a la maquina utilizada puedes ver el nombre de la interfaz usando el comando: $ **ip a**

### Aplicar cambios de configuracion de netplan 
```
sudo netplan try
```
Hacer click en aceptar y luego ejecuta
```
sudo netplan apply
```

## Configuracion de hostname en cada hosts
### agregar a la configuracion a cada hosts correspondiente
```
hostnamectl set-hostname control01
hostnamectl set-hostname compute01
hostnamectl set-hostname storage01
```
