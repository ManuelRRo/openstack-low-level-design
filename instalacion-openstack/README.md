# Kolla ansible

Vamos a deplegar kolla-ansible en modo multinodo utilizando dos máquinas virtuales **(server-1,server-2)** y una física **(server-3)** con la siguiente configuración.

- Server 1
    - 2 interfaces de red
    - 8GB ram
    - 40GB de disco duro
- Server 2
    - 2 interfaces de red
    - 8GB ram
    - 2 discos uno de 40GB y uno de 100GB
- Server 3
    - 2 interfaces de red
    - 32GB de ram
    - 1TB de disco duro 

El **server-1** será nuestro nodo de **control**, **server-2** será el nodo de **storage** y el **server-3** el nodo de **compute**.