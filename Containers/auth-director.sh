#!/bin/sh
# Orquestador de Infraestructura SSO - RAULVILCHEZ.ORG

ACCION=$1

# Función para encender (Fase 1)
start() {
    echo "🚀 Preparando infraestructura de Pod (IP .27) via br_pod..."
    
    podman pod create \
          --name auth \
          --network "pasta:-4,-i,br_pod,-a,192.168.20.27,-g,192.168.20.1,-M,02:42:ac:11:00:1b,--mtu,1500,-d,-l,/tmp/pasta.log" \
          --userns=keep-id \
          -p 8080:8080 -p 8443:8443 \
          --add-host ipa.raulvilchez.org:192.168.17.39 

    # Pausa técnica: necesitamos que el proceso 'pasta' haya creado el tap
    # y esté escuchando en el bridge antes de mapear su MAC.
    echo "⏳ Esperando sincronización de red..."
    sleep 2

    # Inyección quirúrgica: asociamos la MAC directamente al bridge.
    # 'temp' permite que el kernel la gestione si el proceso muere,
    # pero 'static' asegura que no se pierda por falta de tráfico.    
    sudo bridge fdb add 02:42:ac:11:00:1b dev enp9s0.20 master static

    echo "✅ FDB actualizada para 02:42:ac:11:00:1b en br_pod"

    echo "📦 Levantando Authelia-Auth dentro del Pod..."
    /bin/sh ./authelia-auth.sh 
    
    echo "🌐 Levantando Proxy-Auth dentro del Pod..."
    /bin/sh ./proxy.sh 
}

stop() {
    echo "🛑 Iniciando apagado controlado..."
    
    # Detener y eliminar el Pod (esto elimina automáticamente los contenedores internos)
    echo "📦 Eliminando infraestructura del Pod (auth)..."
    sudo bridge fdb del 02:42:ac:11:00:1b dev enp9s0.20 master static 2>/dev/null    
    podman pod rm -f auth
    
    echo "✨ Infraestructura limpia y puerto enp9s0 liberado."
}

# Lógica de decisión corregida
case "$ACCION" in
    shutdown|stop)
        stop
        ;;
    start|up)
        start
        ;;
    *)
        echo "Uso: $0 {up|start|stop|shutdown}"
        ;;
esac