#!/bin/bash
# setup_pod_l2 - Configuración de infraestructura L2 para Pod Rootless

config_l2() {
    echo "⚙️ Aplicando restricciones de aislamiento a Pod-QXG..."
    # Configuración del Bridge para evitar conflictos con la gestión (eno1)
    nmcli connection modify Pod-QXG \
        ipv4.method disabled \
        ipv6.method ignore \
        ipv4.never-default yes \
        ipv6.never-default yes \
        connection.autoconnect-priority -10

    echo "⚙️ Activando Hairpin en el puerto físico..."
    # Configuración del puerto esclavo
    nmcli connection modify Pod-QXGs bridge-port.hairpin yes
}

case "$1" in
    build)
        echo "🏗️ Creando infraestructura Bridge..."
        # Crear Bridge
        nmcli con add type bridge con-name Pod-QXG ifname br_pod \
            ipv4.method disabled ipv6.method ignore 
        
        # Crear Puerto Esclavo
        nmcli con add type ethernet con-name Pod-QXGs ifname enp9s0 master br_pod 
        
        # Aplicar lógica de aislamiento y hairpin
        config_l2
        
        # Levantar interfaces
        nmcli con up Pod-QXG 
        nmcli con up Pod-QXGs 
        
        echo "✅ Red preparada. Verifica 'nmcli device status'." 
        ;;
    clean)
        echo "🧹 Limpiando interfaces y recuperando gestión..."
        nmcli con delete Pod-QXG 2>/dev/null
        nmcli con delete Pod-QXGs 2>/dev/null
        nmcli con delete Pod-VLAN 2>/dev/null
        nmcli con up work
        echo "✅ Sistema restaurado."
        ;;
    *)
        echo "Uso: $0 {build|clean}"
        ;;
esac