#!/bin/bash

# Script para obter licença Portainer Business via API
PORTAINER_URL="https://painel.agenciafer.com.br"

echo "🚀 === ATIVAÇÃO AUTOMÁTICA PORTAINER BUSINESS ==="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Coletando informações...${NC}"
read -p "📧 Digite seu email: " EMAIL
read -p "🏢 Nome da empresa [Agência Fer]: " COMPANY
COMPANY=${COMPANY:-"Agência Fer"}
read -p "👤 Seu nome completo: " FULLNAME

echo ""
echo -e "${YELLOW}🔍 Verificando status do Portainer...${NC}"

# Verificar se Portainer está rodando
STATUS=$(curl -s "$PORTAINER_URL/api/status" 2>/dev/null)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Portainer está online${NC}"
    echo "Status: $STATUS"
else
    echo -e "${RED}❌ Erro ao conectar com Portainer${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}🔐 Tentando obter licença gratuita...${NC}"

# Tentar obter licença gratuita via API da Portainer
LICENSE_REQUEST=$(cat <<EOF
{
    "email": "$EMAIL",
    "company": "$COMPANY",
    "fullName": "$FULLNAME",
    "nodeCount": 5,
    "licenseType": "trial"
}
EOF
)

echo "📝 Dados da solicitação:"
echo "  • Email: $EMAIL"
echo "  • Empresa: $COMPANY"
echo "  • Nome: $FULLNAME"
echo "  • Nodes: 5 (gratuito)"

echo ""
echo -e "${BLUE}🌐 Obtendo licença do portal Portainer...${NC}"

# Método 1: Tentar via endpoint público da Portainer
TRIAL_RESPONSE=$(curl -s -X POST "https://www.portainer.io/api/trial-license" \
    -H "Content-Type: application/json" \
    -d "$LICENSE_REQUEST" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$TRIAL_RESPONSE" ]; then
    echo -e "${GREEN}✅ Resposta recebida da Portainer${NC}"
    echo "Resposta: $TRIAL_RESPONSE"
    
    # Extrair licença se presente
    LICENSE_KEY=$(echo "$TRIAL_RESPONSE" | grep -o '"license":"[^"]*"' | cut -d'"' -f4)
    
    if [ -n "$LICENSE_KEY" ]; then
        echo -e "${GREEN}🎉 Licença obtida com sucesso!${NC}"
        echo "Chave: $LICENSE_KEY"
        
        echo ""
        echo -e "${YELLOW}🔧 Aplicando licença no Portainer...${NC}"
        
        # Aplicar licença
        APPLY_RESPONSE=$(curl -s -X POST "$PORTAINER_URL/api/licenses" \
            -H "Content-Type: application/json" \
            -d "{\"license\":\"$LICENSE_KEY\"}" 2>/dev/null)
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Licença aplicada com sucesso!${NC}"
            echo "Resposta: $APPLY_RESPONSE"
        else
            echo -e "${YELLOW}⚠️  Aplicação manual necessária${NC}"
            echo "Cole esta chave no Portainer: $LICENSE_KEY"
        fi
    else
        echo -e "${YELLOW}⚠️  Licença não encontrada na resposta${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Método automático falhou. Tentando alternativa...${NC}"
fi

echo ""
echo -e "${BLUE}📋 PRÓXIMOS PASSOS:${NC}"
echo ""
echo "1. 🌐 Acesse: $PORTAINER_URL"
echo "2. 🔑 Na tela de licença, clique em 'Don't have a license?'"
echo "3. 📝 Preencha o formulário com:"
echo "   • Email: $EMAIL"
echo "   • Company: $COMPANY"
echo "   • Name: $FULLNAME"
echo "4. 📧 Verifique seu email para a licença"
echo "5. 📋 Cole a licença recebida no campo License"
echo ""

echo -e "${GREEN}🔗 Links úteis:${NC}"
echo "• Portainer: $PORTAINER_URL"
echo "• Obter licença: https://www.portainer.io/take-3"
echo "• Licenças gratuitas: https://www.portainer.io/portainer-business-free"

echo ""
echo -e "${BLUE}💡 Quer que eu tente outro método? (s/n)${NC}"
