import torch

def test_gpu():
    print("=== PyTorch GPU Test ===")
    print("Versión de PyTorch:", torch.__version__)
    print("CUDA disponible:", torch.cuda.is_available())

    if torch.cuda.is_available():
        print("Número de GPUs:", torch.cuda.device_count())
        print("Nombre de la GPU:", torch.cuda.get_device_name(0))

        # Crear dos tensores grandes en GPU y sumarlos
        a = torch.rand(10000, 10000, device="cuda")
        b = torch.rand(10000, 10000, device="cuda")
        c = a + b
        print("Cálculo en GPU exitoso. Resultado shape:", c.shape)

        # Mover resultado a CPU y verificar
        c_cpu = c.to("cpu")
        print("Resultado movido a CPU. Valor medio:", c_cpu.mean().item())
    else:
        print(" No se detectó GPU. Revisa la configuración de CUDA/PyTorch.")

if __name__ == "__main__":
    test_gpu()
