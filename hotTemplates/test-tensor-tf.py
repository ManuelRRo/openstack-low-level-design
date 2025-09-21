import tensorflow as tf

# Crear dos tensores constantes
a = tf.constant([[1.0, 2.0],
                 [3.0, 4.0]])
b = tf.constant([[5.0, 6.0],
                 [7.0, 8.0]])

# Operación de multiplicación de matrices
c = tf.matmul(a, b)

print("Tensor A:")
print(a.numpy())

print("\nTensor B:")
print(b.numpy())

print("\nResultado de A x B:")
print(c.numpy())
