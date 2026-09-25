#!/bin/bash
# setup_pod_l2 - Configuración de infraestructura VLAN para aislamiento total

build_vlan() {
    echo "🏷️ Creando interfaz VLAN 20 sobre enp9s0..."
    # 1. Crear la interfaz VLAN con su propia IP (el host será el gateway del Pod)
    nmcli con add type vlan con-name Pod-VLAN dev enp9s0 id 20 \
          ipv4.method manual ipv4.addresses 192.168.20.1/24 ipv6.method ignore \
          ipv4.never-default yes

    echo "🏗️ Creando Bridge sobre la interfaz VLAN..."
    # 2. Crear el bridge (sin IP para el host en este nivel)
    nmcli con add type bridge con-name Pod-QXG ifname br_pod \
          ipv4.method disabled ipv6.method ignore ipv4.never-default yes
    
    # 3. Vincular el bridge a la interfaz virtual de la VLAN
    nmcli con add type ethernet con-name Pod-QXGs ifname enp9s0.20 master br_pod
    
    # Aplicar Hairpin
    nmcli connection modify Pod-QXGs bridge-port.hairpin yes

    # Levantar todo
    nmcli con up Pod-VLAN
    nmcli con up Pod-QXG
    nmcli con up Pod-QXGs
}

case "$1" in
    build)
        build_vlan
        echo "✅ Infraestructura VLAN 20 preparada (Gateway: 192.168.20.1)."
        ;;
    clean)
        echo "🧹 Limpiando interfaces..."
        nmcli con delete Pod-VLAN Pod-QXG Pod-QXGs 2>/dev/null
        nmcli con up work
        echo "✅ Sistema restaurado."
        ;;
    *)
        echo "Uso: $0 {build|clean}"
        ;;
esac