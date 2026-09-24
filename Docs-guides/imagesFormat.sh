#!/bin/bash

##################################################
# Comandos para gestionar las imagenes de disco  ###
##################################################
# Convertir una imagen de disco a otro formato
qemu-img convert -O formato_origen imagen_origen.img formato_destino imagen_destino.img
# Ejemplo: Convertir una imagen QCOW2 a RAW
qemu-img convert -O raw imagen_origen.qcow2 imagen_destino.raw
# Ejemplo: Convertir una imagen RAW a QCOW2
qemu-img convert -O qcow2 imagen_origen.raw imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a VMDK
qemu-img convert -O vmdk imagen_origen.qcow2 imagen_destino.vmdk
# Ejemplo: Convertir una imagen VMDK a QCOW2
qemu-img convert -O qcow2 imagen_origen.vmdk imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a VHDX
qemu-img convert -O vhdx imagen_origen.qcow2 imagen_destino.vhdx
# Ejemplo: Convertir una imagen VHDX a QCOW2
qemu-img convert -O qcow2 imagen_origen.vhdx imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a VHD
qemu-img convert -O vhd imagen_origen.qcow2 imagen_destino.vhd
# Ejemplo: Convertir una imagen VHD a QCOW2
qemu-img convert -O qcow2 imagen_origen.vhd imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a RAW comprimido
qemu-img convert -O raw -c imagen_origen.qcow2 imagen_destino.raw
# Ejemplo: Convertir una imagen RAW comprimido a QCOW2
qemu-img convert -O qcow2 -c imagen_origen.raw imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a QCOW2 comprimido
qemu-img convert -O qcow2 -c imagen_origen.qcow2 imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 comprimido a RAW
qemu-img convert -O raw imagen_origen.qcow2 imagen_destino.raw
# Ejemplo: Convertir una imagen RAW a RAW comprimido
qemu-img convert -O raw -c imagen_origen.raw imagen_destino.raw
# Ejemplo: Convertir una imagen RAW comprimido a RAW
qemu-img convert -O raw imagen_origen.raw imagen_destino.raw
# Ejemplo: Convertir una imagen QCOW2 a VDI
qemu-img convert -O vdi imagen_origen.qcow2 imagen_destino.vdi
# Ejemplo: Convertir una imagen VDI a QCOW2
qemu-img convert -O qcow2 imagen_origen.vdi imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a Parallels (PVM)
qemu-img convert -O parallels imagen_origen.qcow2 imagen_destino.pvm
# Ejemplo: Convertir una imagen Parallels (PVM) a QCOW2
qemu-img convert -O qcow2 imagen_origen.pvm imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a QED
qemu-img convert -O qed imagen_origen.qcow2 imagen_destino.qed
# Ejemplo: Convertir una imagen QED a QCOW2
qemu-img convert -O qcow2 imagen_origen.qed imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a Bochs (BIOS)
qemu-img convert -O bochs imagen_origen.qcow2 imagen_destino.bochs
# Ejemplo: Convertir una imagen Bochs (BIOS) a QCOW2
qemu-img convert -O qcow2 imagen_origen.bochs imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a Sheepdog
qemu-img convert -O sheepdog imagen_origen.qcow2 imagen_destino.sheepdog
# Ejemplo: Convertir una imagen Sheepdog a QCOW2
qemu-img convert -O qcow2 imagen_origen.sheepdog imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a RBD (RADOS Block Device)
qemu-img convert -O rbd imagen_origen.qcow2 imagen_destino.rbd
# Ejemplo: Convertir una imagen RBD (RADOS Block Device) a QCOW2
qemu-img convert -O qcow2 imagen_origen.rbd imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a GlusterFS
qemu-img convert -O gluster imagen_origen.qcow2 imagen_destino.gluster
# Ejemplo: Convertir una imagen GlusterFS a QCOW2
qemu-img convert -O qcow2 imagen_origen.gluster imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a HTTP
qemu-img convert -O http imagen_origen.qcow2 imagen_destino.http
# Ejemplo: Convertir una imagen HTTP a QCOW2
qemu-img convert -O qcow2 imagen_origen.http imagen_destino.qcow2
# Ejemplo: Convertir una imagen QCOW2 a FTP
qemu-img convert -O ftp imagen_origen.qcow2 imagen_destino.ftp
# Ejemplo: Convertir una imagen FTP a QCOW2
qemu-img convert -O qcow2 imagen_origen.ftp imagen_destino.qcow2