export FCOS_VERSION="35.20220116.3.0"
wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/${FCOS_VERSION}/x86_64/fedora-coreos-${FCOS_VERSION}-openstack.x86_64.qcow2.xz
unxz fedora-coreos-${FCOS_VERSION}-openstack.x86_64.qcow2.xz

openstack image create \
                      --disk-format=qcow2 \
                      --container-format=bare \
                      --file=fedora-coreos-${FCOS_VERSION}-openstack.x86_64.qcow2 \
                      --property os_distro='fedora-coreos' \
                      fedora-coreos-latest

# la network tiene que ser externa no se permite selfservice

openstack coe cluster template create kubernetes-cluster-template \
                     --image fedora-coreos-latest \
                     --external-network ext-net \     
                     --dns-nameserver 8.8.8.8 \
                     --master-flavor m1.small \
                     --flavor m1.small \
                     --coe kubernetes

# usar el id que genera el cluster template porque no jala en el nombre del cluster template
openstack coe cluster create kubernetes-cluster2 \
                        --cluster-template 033db07f-99e5-490d-814f-acb026d25a3f \
                        --master-count 1 \
                        --node-count 1 \
                        --keypair mykey