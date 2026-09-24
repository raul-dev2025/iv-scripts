#!/bin/bash
# Ruta base de la infraestructura definida en el resumen técnico
BASE_DIR="/var/lib/virt_storage"

echo "Reparando permisos de la IV (RAULVILCHEZ.ORG)..."

# 1. Propiedad: Mantener virt-admin y grupo libvirt para coexistencia
chown -R virt-admin:libvirt "$BASE_DIR"

# 2. Directorios: Deben ser 775 para ser atravesables (bit +x)
find "$BASE_DIR" -type d -exec chmod 775 {} +

# 3. Archivos de Configuración y Datos: 664 (Sin ejecución)
# Solo aplicamos esto a carpetas de datos puros para no romper binarios de Podman
find "$BASE_DIR/configs" -type f -exec chmod 664 {} +
find "$BASE_DIR/vms" -type f -exec chmod 664 {} +
find "$BASE_DIR/metadata" -type f -exec chmod 664 {} +

# 4. Scripts y Binarios: Recuperar el bit de ejecución indispensable
if [ -d "$BASE_DIR/scripts" ]; then
    find "$BASE_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} +
fi

# 5. SELinux: Etiquetas específicas según el rol
# Discos de VM
chcon -R -t virt_image_t "$BASE_DIR/vms" 2>/dev/null
# Configuraciones para contenedores (necesario para el flag :Z)
chcon -R -t container_file_t "$BASE_DIR/configs/proxy" 2>/dev/null
chcon -R -t container_file_t "$BASE_DIR/containers" 2>/dev/null

echo "Infraestructura saneada."
