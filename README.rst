==========
iv-scripts
==========

Colección centralizada de scripts de administración y automatización para Infraestructura Virtual (IV).


ipa-cloner
==========

Automatización de clonación de máquinas virtuales y enrolamiento en FreeIPA.

Descripción
-----------

Este repositorio contiene las herramientas y scripts para la provisión,
configuración de red y enrolamiento automatizado de nodos en la infraestructura
virtual (IV) conectada al servidor FreeIPA.

Estructura del Proyecto
-----------------------

* ``scripts/``: Scripts de automatización y clonación de imágenes base.
* ``docs/``: Documentación técnica del proyecto.

Requisitos
----------

* **OS:** Linux (KVM / QEMU / libvirt)
* **Herramientas:** ``virt-admin``, ``guestmount``, NetworkManager
* **Servicios:** Servidor FreeIPA activo en la red del laboratorio