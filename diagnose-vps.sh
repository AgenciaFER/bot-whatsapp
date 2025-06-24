#!/bin/bash

# Script de diagnóstico completo do VPS
VPS_IP="147.79.83.63"

echo "🔍 DIAGNÓSTICO COMPLETO DO VPS"
echo "================================"

# Função para executar comandos no VPS
run_vps_cmd() {
    sshpass -p ",.DAg,poGVEAfMcc-9pD" ssh -o StrictHostKeyChecking=no root@$VPS_IP "$1"
}

echo "1. 🌐 Informações de Rede:"
run_vps_cmd "curl -s ifconfig.me && echo"
run_vps_cmd "ip addr show | grep 'inet ' | head -3"

echo -e "\n2. 🐳 Status Docker:"
run_vps_cmd "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

echo -e "\n3. 📡 Portas em Uso:"
run_vps_cmd "netstat -tlnp | grep -E ':(80|443|9000|9443)'"

echo -e "\n4. 🔧 Traefik Status:"
run_vps_cmd "docker logs traefik_traefik.1.* 2>/dev/null | tail -5 || echo 'Traefik não encontrado'"

echo -e "\n5. 📂 Arquivos do Bot:"
run_vps_cmd "ls -la /opt/bot-whatsapp/ | head -10"

echo -e "\n6. 🌍 DNS Resolution:"
run_vps_cmd "nslookup painel.agenciafer.com.br"

echo -e "\n7. 🔒 Teste HTTPS Local:"
run_vps_cmd "curl -s -o /dev/null -w '%{http_code}' -k https://localhost:9443"

echo -e "\n✅ Diagnóstico concluído!"
