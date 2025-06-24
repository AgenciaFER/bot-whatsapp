#!/bin/bash

# Script VPS com credenciais automáticas
VPS_PASSWORD="L.mUnmSaXI9//l@yKLG7"
VPS_IP="147.79.83.6"

# Função para executar comandos no VPS
vps_exec() {
    sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no root@$VPS_IP "$1"
}

echo "🚀 === VERIFICAÇÃO E ATUALIZAÇÃO PORTAINER ==="
echo ""

echo "📊 Verificando versão atual do Portainer..."
CURRENT_VERSION=$(vps_exec 'curl -s https://painel.agenciafer.com.br/api/status | grep -o "\"Version\":\"[^\"]*"' | cut -d'"' -f4)
echo "Versão atual: $CURRENT_VERSION"

echo ""
echo "📋 Verificando se há atualizações disponíveis..."
echo "Versão disponível: 2.27.0 LTS (conforme mensagem mostrada)"

echo ""
echo "🔍 Status dos serviços principais:"
vps_exec 'docker service ls --format "table {{.Name}}\t{{.Replicas}}\t{{.Image}}"'

echo ""
echo "💡 Opções disponíveis:"
echo "1. Manter versão atual (2.27.6) - mais recente"
echo "2. Verificar licença Business"
echo "3. Atualizar Portainer (se necessário)"
echo "4. Verificar bot WhatsApp"

echo ""
echo "ℹ️  Nota: Sua versão 2.27.6 é mais recente que a 2.27.0 LTS mencionada"
