#!/bin/bash

# Deberas lanzar este escript como root, para poder
# actuar sobre el recurso de red.

# 1. Limpieza de entradas FDB previas para evitar duplicados
bridge fdb del 52:54:00:11:17:27 dev br_pod 2>/dev/null

# 2. Registro de la MAC en el bridge (Modo Filtrado Estricto)
bridge fdb add 52:54:00:11:17:27 dev br_pod master

