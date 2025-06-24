#!/bin/bash

# Script para análise completa do Bot WhatsApp
VPS_IP="147.79.83.6"
PASSWORD="L.mUnmSaXI9//l@yKLG7"

echo "🤖 === ANÁLISE COMPLETA DO BOT WHATSAPP ==="
echo ""

# Função para executar comandos no VPS
run_vps() {
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@$VPS_IP "$1"
}

echo "📊 1. STATUS GERAL DO BOT:"
run_vps "docker service ls | grep bot-whatsapp"

echo ""
echo "🔍 2. DETALHES DO CONTAINER:"
run_vps "docker service ps bot-whatsapp-stack_bot-whatsapp"

echo ""
echo "📋 3. LOGS RECENTES (últimas 20 linhas):"
run_vps "docker service logs bot-whatsapp-stack_bot-whatsapp --tail 20"

echo ""
echo "🌐 4. TESTE DE CONECTIVIDADE:"
echo "HTTP Status:" $(curl -s -o /dev/null -w "%{http_code}" http://147.79.83.6:3000)
echo "Health Check:" $(curl -s http://147.79.83.6:3000/health 2>/dev/null || echo "Endpoint não disponível")

echo ""
echo "🔧 5. CONFIGURAÇÃO DO BOT:"
run_vps "docker service inspect bot-whatsapp-stack_bot-whatsapp --format '{{json .Spec.TaskTemplate.ContainerSpec.Env}}' 2>/dev/null | jq -r '.[]' | head -10"

echo ""
echo "💾 6. VOLUMES DO BOT:"
run_vps "docker volume ls | grep bot-whatsapp"

echo ""
echo "📈 7. USO DE RECURSOS:"
run_vps "docker stats --no-stream --format 'table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}' | grep bot-whatsapp"

echo ""
echo "🔍 8. VERIFICAR SESSÃO WHATSAPP:"
run_vps "docker exec $(docker ps -q -f name=bot-whatsapp) ls -la /app/sessions/ 2>/dev/null || echo 'Sessão não acessível via exec'"

echo ""
echo "🚀 9. RESTART DO BOT (se necessário):"
echo "Para reiniciar: docker service update --force bot-whatsapp-stack_bot-whatsapp"
