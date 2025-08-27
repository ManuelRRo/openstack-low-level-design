> Ejecutar las siguientes configuraciones en el nodo **control01**

# Instalar dependencias
### Actualizar repositorio de paquetes
```
sudo apt update
```
### Instalar paquetes
```
sudo apt install git python3-dev libffi-dev gcc libssl-dev libdbus-glib-1-dev
```
## Instalar dependencias para el entorno virtual
1. instalar dependencias del entorno virtual
```
sudo apt install python3-venv
```
2. Crear entorno virtual de python
```
python3 -m venv /path/to/venv
source /path/to/venv/bin/activate
```
3. Actualizar la version de pip
```
pip install -U pip
```
 
