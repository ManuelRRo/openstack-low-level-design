#!/bin/bash

echo "Running boot script"

# update and install pip and virtual-env
which pip3 || apt-get update && apt-get install -y python3-pip python3-venv install -y libgl1

# create a python virtual enviroment in default user
python3 -m venv /home/ubuntu/env

# change owner to ubuntu:ubuntu
chown -R ubuntu:ubuntu /home/ubuntu/env/


# activate virtual enviroment
source /home/ubuntu/env/bin/activate

if [[ "$OPT" == "tf-cpu" ]]; then
    pip3 install tensorflow-cpu
elif [[ "$OPT" == "tf-gpu" ]]; then
    pip3 install 'tensorflow[and-cuda]'
elif [[ "$OPT" == "pt-cpu" ]]; then
    pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cpu
elif [[ "$OPT" == "pt-gpu" ]]; then
    pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu130
    pip3 install ultralytics
else
  echo "software de entrenamiento no seleccionado"
fi

# deactivate virtual enviroment
deactivate

echo "execution finish"
# ... 
