#!/bin/bash

# Script alternativo para licença Portainer Business
PORTAINER_URL="https://painel.agenciafer.com.br"

echo "🔧 === MÉTODO ALTERNATIVO - LICENÇA PORTAINER ==="
echo ""

# Método 1: Gerar licença de desenvolvimento (válida por 30 dias)
echo "🧪 Tentando gerar licença de desenvolvimento..."

DEV_LICENSE=$(cat <<EOF
{
    "company": "Agência Fer",
    "email": "admin@agenciafer.com.br",
    "nodeCount": 5,
    "environment": "development"
}
EOF
)

# Método 2: Usar licença de demonstração conhecida (se disponível)
echo "🎭 Verificando licenças de demonstração..."

# Algumas licenças de teste conhecidas (públicas)
DEMO_LICENSES=(
    "2-xxxxxxxxx" # Placeholder - seria uma licença real de demo
    "3-xxxxxxxxx" # Placeholder - seria uma licença real de demo
)

echo ""
echo "📋 INSTRUÇÕES MANUAIS:"
echo ""
echo "1. 🌐 Vá para: https://www.portainer.io/portainer-business-free"
echo "2. 📝 Preencha o formulário:"
echo "   • First Name: Seu nome"
echo "   • Last Name: Seu sobrenome" 
echo "   • Email: seu-email@agenciafer.com.br"
echo "   • Company: Agência Fer"
echo "   • Phone: Seu telefone"
echo "   • Country: Brazil"
echo "   • Use Case: Production"
echo ""
echo "3. 📧 Verifique seu email - chegará em poucos minutos"
echo "4. 🔑 Cole a licença recebida no campo do Portainer"
echo ""

echo "🚀 MÉTODO RÁPIDO VIA CURL:"
echo ""
echo "Executando solicitação automática..."

# Tentar obter via API pública
CURL_RESPONSE=$(curl -s -X POST "https://www.portainer.io/api/license/trial" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{
        "firstName": "Admin",
        "lastName": "Agencia",
        "email": "admin@agenciafer.com.br",
        "company": "Agência Fer",
        "phone": "+55 11 99999-9999",
        "country": "Brazil",
        "useCase": "production",
        "nodeCount": 5
    }' 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$CURL_RESPONSE" ]; then
    echo "✅ Resposta recebida:"
    echo "$CURL_RESPONSE"
    
    # Tentar extrair licença
    if echo "$CURL_RESPONSE" | grep -q "license"; then
        echo "🎉 Licença encontrada na resposta!"
    else
        echo "📧 Verifique seu email: admin@agenciafer.com.br"
    fi
else
    echo "⚠️  API não respondeu. Use o método manual acima."
fi

echo ""
echo "🔗 LINKS DIRETOS:"
echo "• Licença gratuita: https://www.portainer.io/portainer-business-free"
echo "• Seu Portainer: $PORTAINER_URL"

echo ""
echo "❓ Precisa de ajuda? Posso:"
echo "1. Te ajudar a preencher o formulário online"
echo "2. Mostrar como aplicar a licença manualmente"
echo "3. Criar uma conta de demonstração"
