#!/bin/bash

# Script para acesso ao VPS
VPS_IP="147.79.83.6"
PASSWORD="L.mUnmSaXI9//l@yKLG7"

echo "🔗 Conectando ao VPS $VPS_IP..."

# Função para executar comandos no VPS
run_vps_cmd() {
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@$VPS_IP "$1"
}

# Verificar se está conectado
echo "📋 Verificando conexão..."
run_vps_cmd "whoami && pwd"
