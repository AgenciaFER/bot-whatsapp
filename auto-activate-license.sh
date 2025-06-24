#!/bin/bash

# Script para ativação automática da licença via API
PORTAINER_URL="https://painel.agenciafer.com.br"

echo "=== ATIVAÇÃO AUTOMÁTICA PORTAINER BUSINESS ==="
echo ""

read -p "📧 Digite seu email: " EMAIL
read -p "🏢 Nome da empresa [Agência Fer]: " COMPANY
COMPANY=${COMPANY:-"Agência Fer"}

echo ""
echo "🔍 Verificando status do Portainer..."
STATUS=$(curl -s "$PORTAINER_URL/api/status")
echo "Status: $STATUS"

echo ""
echo "🔐 Para continuar, você precisa:"
echo "1. Acessar: $PORTAINER_URL"
echo "2. Fazer login/criar conta admin"
echo "3. Ir para Settings → Licenses"
echo "4. Clicar em 'Get free license'"
echo "5. Usar os dados:"
echo "   • Email: $EMAIL"
echo "   • Company: $COMPANY"
echo ""

echo "💡 Quer que eu te ajude de outra forma? Digite 'api' para tentar via API"
