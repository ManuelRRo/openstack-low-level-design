export FCOS_VERSION="38.20230806.3.0"
wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/${FCOS_VERSION}/x86_64/fedora-coreos-${FCOS_VERSION}-openstack.x86_64.qcow2.xz
unxz fedora-coreos-${FCOS_VERSION}-openstack.x86_64.qcow2.xz

openstack image create \
                      --disk-format=qcow2 \
                      --container-format=bare \
                      --file=fedora-coreos-${FCOS_VERSION}-openstack.x86_64.qcow2 \
                      --property os_distro='fedora-coreos' \
                      fedora-coreos-latest

# la network tiene que ser externa no se permite selfservice

openstack coe cluster template create k8s-v1.28.9-calico \
   --image fedora-coreos-latest \
   --external-network ext-net \
   --dns-nameserver 8.8.8.8 \
   --flavor m1.small \               #aqui es donde podria el poner el flavor de la grafica
   --master-flavor m1.small \
   --coe kubernetes \
   --network-driver calico \
   --labels kube_tag=v1.28.9-rancher1,container_runtime=containerd,containerd_version=1.6.31,containerd_tarball_sha256=75afb9b9674ff509ae670ef3ab944ffcdece8ea9f7d92c42307693efa7b6109d,cloud_provider_tag=v1.27.3,cinder_csi_plugin_tag=v1.27.3,k8s_keystone_auth_tag=v1.27.3,magnum_auto_healer_tag=v1.27.3,octavia_ingress_controller_tag=v1.27.3,calico_tag=v3.26.4



# usar el id que genera el cluster template porque no jala en el nombre del cluster template
openstack coe cluster create kubernetes-cluster \
                    --cluster-template edb2d537-186c-4626-8961-414082a71d74 \
                    --master-count 1 \
                    --node-count 1 \
                    --keypair mykey