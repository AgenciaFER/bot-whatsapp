#!/bin/bash

# Script para corrigir o Bot WhatsApp
VPS_IP="147.79.83.6"
PASSWORD="L.mUnmSaXI9//l@yKLG7"

echo "🔧 === CORREÇÃO DO BOT WHATSAPP ==="
echo ""

# Função para executar comandos no VPS
run_vps() {
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@$VPS_IP "$1"
}

echo "🛑 1. PARANDO BOT ATUAL:"
run_vps "docker service update --replicas 0 bot-whatsapp-stack_bot-whatsapp"

echo ""
echo "⏳ Aguardando parada completa..."
sleep 10

echo ""
echo "🧹 2. LIMPANDO SESSÕES TRAVADAS:"
run_vps "docker volume rm bot-whatsapp-stack_whatsapp_session -f 2>/dev/null || echo 'Volume já limpo'"

echo ""
echo "🔄 3. RECRIANDO VOLUME DE SESSÃO:"
run_vps "docker volume create bot-whatsapp-stack_whatsapp_session"

echo ""
echo "🚀 4. REINICIANDO BOT:"
run_vps "docker service update --replicas 1 bot-whatsapp-stack_bot-whatsapp"

echo ""
echo "⏳ Aguardando inicialização..."
sleep 20

echo ""
echo "📋 5. VERIFICANDO STATUS:"
run_vps "docker service ps bot-whatsapp-stack_bot-whatsapp | head -3"

echo ""
echo "📱 6. PROCURANDO QR CODE:"
run_vps "docker service logs bot-whatsapp-stack_bot-whatsapp --tail 30 | grep -i 'qr\|scan\|code' | tail -5"

echo ""
echo "🔗 7. TESTE DE CONECTIVIDADE:"
echo "HTTP Status:" $(curl -s -o /dev/null -w "%{http_code}" http://147.79.83.6:3000)

echo ""
echo "✅ Correção concluída! Verifique os logs para o QR code."
