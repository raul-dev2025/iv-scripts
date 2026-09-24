# Consulta no interactiva
su virt-admin -c "virsh list --all"

# Consulta interactiva
su virt-admin
# Tras el login; configurar la session
export LIBVIRT_DEFULT_URI='qemu:///system'
virsh start vm_ejemplo

# La interfaz grafica
xhost +SI:localusser:virt-admin
su virt-admin
virt-manager

