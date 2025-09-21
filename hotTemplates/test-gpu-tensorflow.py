import tensorflow as tf

def detectar_dispositivo():
    # Lista de GPUs disponibles
    gpus = tf.config.list_physical_devices('GPU')
    if gpus:
        print("Se ha detectado una GPU.")
        for i, gpu in enumerate(gpus):
            print(f"  - GPU {i}: {gpu}")
    else:
        print("No se detectó GPU, se usará CPU.")

if __name__ == "__main__":
    detectar_dispositivo()
