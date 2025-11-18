# dentro del lxc de glance ejecutar este script para update venv
# despues de instalar python3-rados y python3-rbd

# Añadir los dist-packages del sistema al venv de glance
cat << 'EOF' > /openstack/venvs/glance-31.0.1/lib/python3.12/site-packages/ceph_bindings.pth
/usr/lib/python3/dist-packages
/usr/lib/python3.12/dist-packages
EOF
