# Listar todas las pools
virsh pool-list --all

# Ver detalles de una pool
virsh pool-info nombre_pool

# Ver ruta fisica
virsh pool-dumpxml nombre_pool | grep path

# Que hay dento de la pool
virsh vol-list --pool nombre_pool

# Frefresta la pool
virsh pool-refresh nombre_pool

# 1. Definir la regla permanente para el directorio de ISOs
semanage fcontext -a -t virt_content_t "/var/lib/virt_storage/metadata(/.*)?"

# 2. Aplicar la regla a los archivos existentes
restorecon -Rv /var/lib/virt_storage/metadata


##################################################
# Comando para lanzar el gestor texto/grafico  ###
##################################################

# Enciende la maquina virtual
virsh start nombre_maquina_virtual

# Conecta con la maquina virtual usando virt-viewer
virt-viewer --connect qemu:///system --wait nombre_maquina_virtual

# Alternativa con virt-manager
virt-manager --connect qemu:///system --wait nombre_maquina_virtual

# Alternativa con remote-viewer
# Obtener la direccion de visualizacion
virsh domdisplay nombre_maquina_virtual

# Comando para conectar con remote-viewer directamente
remote-viewer spice://localhost:5900

###########################################################
# Para aliviar el procesador si el antimalware de Windows #
# se pone como loco: Ojo usar solo en casos necesarios!   #
# Este comoando es ovbiamente PowerShell de Windows       #
###########################################################
Set-MpPreference -DisableRealtimeMonitoring $true

##################################################
# Comandos de supervivencia RESUMEN INICIAL    ###
##################################################
# Identidad Kerberos, obtener ticket.
kinit admin 
# Ver tickets obtenidos y su validez
klist
#Cerrar sesion administrativa
kdestroy
# Renovar ticket (si es posible)
kinit -R

# Gestion de IdM
# Listar usuarios
ipa user-find
# Creaar usuario
ipa user-add nombre_usuario --first=Nombre --last=Apellido --password
# Consultar registros DNS especificos
ipa dnsrecord-show zona_dominio nombre_registro
ipa dnsrecord-show raulvilchez.org idm
# Asignar usuario a grupo
ipa group-add-member nombre_grupo --users=nombre_usuario
# Modificar usuario
ipa user-mod nombre_usuario --phone=123456789
# Eliminar usuario
ipa user-del nombre_usuario


# Infrestructura (Host)
# Ver estado de VMs en el host
virsh list --all
# Comprobar el ahorro de espacio real
vdostats --hu
# Ver detalles de una VM
virsh dominfo nombre_maquina_virtual