#!/bin/bash

echo "Running boot script"

# update and install pip and virtual-env
which pip3 || apt-get update && apt-get install -y python3-pip python3-venv libgl1 zip unzip

# create a python virtual enviroment in default user
python3 -m venv /home/ubuntu/env

# change owner to ubuntu:ubuntu
chown -R ubuntu:ubuntu /home/ubuntu/env/

# activate virtual enviroment
source /home/ubuntu/env/bin/activate

if [[ "$OPT" == "tf-cpu" ]]; then
    pip3 install --no-index --find-links http://172.21.1.9/whtfcpu/ --trusted-host 172.21.1.9 tensorflow-cpu
elif [[ "$OPT" == "tf-gpu" ]]; then
    pip3 install --no-index --find-links http://172.21.1.9/whtfgpu/ --trusted-host 172.21.1.9 'tensorflow[and-cuda]'
elif [[ "$OPT" == "pt-cpu" ]]; then
    pip3 install --no-index --find-links http://172.21.1.9/whptcpu/ --trusted-host 172.21.1.9 torch torchvision
    pip3 install --no-index --find-links http://172.21.1.9/whultralytics --trusted-host 172.21.1.9 ultralytics
    pip3 install --no-index --find-links http://172.21.1.9/whsv --trusted-host 172.21.1.9 supervision
    pip3 install --no-index --find-links http://172.21.1.9/whst --trusted-host 172.21.1.9 streamlit
elif [[ "$OPT" == "pt-gpu" ]]; then
    pip3 install --no-index --find-links http://172.21.1.9/whptgpu/ --trusted-host 172.21.1.9 torch torchvision
    pip3 install --no-index --find-links http://172.21.1.9/whultralytics --trusted-host 172.21.1.9 ultralytics
    pip3 install --no-index --find-links http://172.21.1.9/whsv --trusted-host 172.21.1.9 supervision
    pip3 install --no-index --find-links http://172.21.1.9/whst --trusted-host 172.21.1.9 streamlit
else
  echo "software de entrenamiento no seleccionado"
fi

# deactivate virtual enviroment
deactivate

#### demo
mkdir /home/ubuntu/demo

cd /home/ubuntu/demo

wget -r -np -nH --cut-dirs=1 http://172.21.1.9/demo/

chown -R ubuntu:ubuntu /home/ubuntu/demo/

#### trainmodels
mkdir /home/ubuntu/trainmodel

cd /home/ubuntu/trainmodel

wget -r -np -nH --cut-dirs=1 http://172.21.1.9/trainmodel/

chown -R ubuntu:ubuntu /home/ubuntu/trainmodel/


echo "execution finish"
# ... 

