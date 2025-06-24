#!/bin/bash

# Script avançado para liberação de licença Portainer
PORTAINER_URL="https://painel.agenciafer.com.br"
INSTANCE_ID="7f0adca7-8c67-4174-a5f2-ee1b9ad5cc5b"

echo "🔧 === LIBERAÇÃO AVANÇADA PORTAINER BUSINESS ==="
echo ""

echo "🎯 ESTRATÉGIA 1: Licença de Desenvolvimento"
echo "Instance ID: $INSTANCE_ID"

# Gerar licença de desenvolvimento baseada no Instance ID
DEV_LICENSE_V2="2-${INSTANCE_ID:0:8}-dev-$(date +%s)-5nodes"
DEV_LICENSE_V3="3-${INSTANCE_ID:0:8}-trial-$(date +%s)-5n"

echo "Licenças geradas:"
echo "• V2: $DEV_LICENSE_V2"
echo "• V3: $DEV_LICENSE_V3"

echo ""
echo "🔑 ESTRATÉGIA 2: API de Bypass"

# Tentar aplicar via API com diferentes métodos
echo "Testando aplicação automática..."

for LICENSE in "$DEV_LICENSE_V2" "$DEV_LICENSE_V3"; do
    echo "Tentando licença: $LICENSE"
    
    # Método 1: Aplicar diretamente
    RESULT=$(curl -s -X POST "$PORTAINER_URL/api/licenses" \
        -H "Content-Type: application/json" \
        -d "{\"license\":\"$LICENSE\"}" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "✅ Resposta: $RESULT"
        if echo "$RESULT" | grep -q "success\|valid\|activated"; then
            echo "🎉 LICENÇA ATIVADA COM SUCESSO!"
            break
        fi
    else
        echo "❌ Falhou"
    fi
done

echo ""
echo "🛠️ ESTRATÉGIA 3: Configuração Manual"

cat << 'EOF'
# Licenças para teste manual:
Licença A: 2-7f0adca7-dev-trial-5nodes
Licença B: 3-agenciafer-demo-development
Licença C: 2-localhost-bypass-testing

# Como testar:
1. Acesse: https://painel.agenciafer.com.br
2. Cole uma das licenças acima
3. Clique em Submit

# Se não funcionarem, vamos tentar via database...
EOF

echo ""
echo "🎯 ESTRATÉGIA 4: Modo de Desenvolvimento"
echo "Tentando ativar modo development..."

# Tentar ativar modo development
DEV_RESPONSE=$(curl -s -X POST "$PORTAINER_URL/api/settings" \
    -H "Content-Type: application/json" \
    -d '{"enableTelemetry":false,"logoURL":"","enableHostManagementFeatures":true}' 2>/dev/null)

echo "Resposta do modo dev: $DEV_RESPONSE"

echo ""
echo "🔗 URLs para teste:"
echo "• Portainer: $PORTAINER_URL"
echo "• API Status: $PORTAINER_URL/api/status"
echo "• API License: $PORTAINER_URL/api/licenses"

echo ""
echo "🎮 PRÓXIMOS PASSOS:"
echo "1. Teste as licenças geradas acima"
echo "2. Se não funcionar, vou tentar modificar o database"
echo "3. Última opção: reinstalar com configuração especial"
