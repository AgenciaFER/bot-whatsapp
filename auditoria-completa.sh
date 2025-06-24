#!/bin/bash

# 🔍 SCRIPT DE AUDITORIA AUTOMÁTICA - PORTAINER E BOT
# Arquivo: auditoria-completa.sh
# Uso: ./auditoria-completa.sh

# Credenciais VPS
VPS_PASSWORD="L.mUnmSaXI9//l@yKLG7"
VPS_IP="147.79.83.6"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para executar comandos na VPS
vps_exec() {
    sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no root@$VPS_IP "$1"
}

# Função para imprimir seções
print_section() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}===========================================${NC}\n"
}

# Função para verificar se comando existe
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ Erro: $1 não está instalado${NC}"
        echo "Instale com: brew install $1 (macOS) ou apt install $1 (Linux)"
        exit 1
    fi
}

echo -e "${PURPLE}🚀 Iniciando Auditoria Completa do Portainer e Bot WhatsApp${NC}"
echo -e "${YELLOW}📅 Data: $(date)${NC}\n"

# Verificar dependências
check_command "sshpass"

print_section "📊 1. STATUS GERAL DO PORTAINER"
echo -e "${YELLOW}Verificando API do Portainer...${NC}"
vps_exec "curl -s https://painel.agenciafer.com.br/api/status 2>/dev/null | head -3 || echo 'API não acessível'"

echo -e "\n${YELLOW}Versão do Docker:${NC}"
vps_exec "docker version --format 'Docker Server: {{.Server.Version}}' 2>/dev/null || echo 'Docker não acessível'"

print_section "🐳 2. CONTAINERS E SERVIÇOS"
echo -e "${YELLOW}Containers ativos:${NC}"
vps_exec "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}' 2>/dev/null || echo 'Erro ao listar containers'"

echo -e "\n${YELLOW}Serviços Docker Swarm:${NC}"
vps_exec "docker service ls 2>/dev/null || echo 'Modo Swarm não ativo ou erro'"

print_section "🤖 3. STATUS DETALHADO DO BOT WHATSAPP"
echo -e "${YELLOW}Procurando pelo bot...${NC}"
BOT_STATUS=$(vps_exec "docker ps | grep bot 2>/dev/null")
if [ -n "$BOT_STATUS" ]; then
    echo -e "${GREEN}✅ Bot encontrado:${NC}"
    echo "$BOT_STATUS"
    
    echo -e "\n${YELLOW}Logs recentes do bot:${NC}"
    vps_exec "BOT_CONTAINER=\$(docker ps --filter 'name=bot' --format '{{.Names}}' | head -1); if [ ! -z \"\$BOT_CONTAINER\" ]; then docker logs --tail 15 \$BOT_CONTAINER; fi" 2>/dev/null
    
    echo -e "\n${YELLOW}Verificando QR Code:${NC}"
    QR_CODE=$(vps_exec "BOT_CONTAINER=\$(docker ps --filter 'name=bot' --format '{{.Names}}' | head -1); if [ ! -z \"\$BOT_CONTAINER\" ]; then docker logs --tail 50 \$BOT_CONTAINER | grep -A 5 'QR CODE' | tail -10; fi" 2>/dev/null)
    if [ -n "$QR_CODE" ]; then
        echo -e "${GREEN}📱 QR Code disponível nos logs${NC}"
    else
        echo -e "${YELLOW}⚠️ QR Code não encontrado nos logs recentes${NC}"
    fi
else
    echo -e "${RED}❌ Bot não encontrado${NC}"
    echo -e "${YELLOW}Verificando serviços do bot...${NC}"
    vps_exec "docker service ls | grep bot 2>/dev/null || echo 'Nenhum serviço do bot encontrado'"
fi

print_section "💾 4. RECURSOS DO SISTEMA"
echo -e "${YELLOW}Uso de CPU e Memória:${NC}"
vps_exec "echo 'CPU:' && top -bn1 | head -3 | tail -1 && echo 'Memória:' && free -h | head -2" 2>/dev/null

echo -e "\n${YELLOW}Uso de Disco:${NC}"
vps_exec "df -h | head -5" 2>/dev/null

echo -e "\n${YELLOW}Volumes Docker:${NC}"
vps_exec "docker volume ls | wc -l && echo 'volumes encontrados'" 2>/dev/null

print_section "🔐 5. SEGURANÇA E CONECTIVIDADE"
echo -e "${YELLOW}Testando conectividade com Portainer:${NC}"
PORTAINER_STATUS=$(vps_exec "curl -s -o /dev/null -w '%{http_code}' https://painel.agenciafer.com.br 2>/dev/null")
if [ "$PORTAINER_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ Portainer acessível (HTTP $PORTAINER_STATUS)${NC}"
else
    echo -e "${RED}❌ Portainer inacessível (HTTP $PORTAINER_STATUS)${NC}"
fi

echo -e "\n${YELLOW}Verificando certificado SSL:${NC}"
SSL_DAYS=$(vps_exec "echo | openssl s_client -servername painel.agenciafer.com.br -connect painel.agenciafer.com.br:443 2>/dev/null | openssl x509 -noout -checkend 2592000 2>/dev/null && echo 'OK' || echo 'EXPIRADO'" 2>/dev/null)
if [ "$SSL_DAYS" = "OK" ]; then
    echo -e "${GREEN}✅ Certificado SSL válido${NC}"
else
    echo -e "${RED}⚠️ Certificado SSL pode estar expirando${NC}"
fi

print_section "📊 6. RELATÓRIO FINAL"
echo -e "${YELLOW}Resumo da auditoria:${NC}"

# Contar containers
CONTAINER_COUNT=$(vps_exec "docker ps | wc -l" 2>/dev/null)
CONTAINER_COUNT=$((CONTAINER_COUNT - 1)) # Remove header line

# Verificar bot
BOT_RUNNING=$(vps_exec "docker ps | grep -c bot" 2>/dev/null)

# Verificar Portainer
PORTAINER_RUNNING=$(vps_exec "docker ps | grep -c portainer" 2>/dev/null)

echo -e "📦 Containers ativos: ${GREEN}$CONTAINER_COUNT${NC}"
echo -e "🤖 Bot WhatsApp: $([ "$BOT_RUNNING" -gt 0 ] && echo -e "${GREEN}✅ Ativo${NC}" || echo -e "${RED}❌ Inativo${NC}")"
echo -e "🐳 Portainer: $([ "$PORTAINER_RUNNING" -gt 0 ] && echo -e "${GREEN}✅ Ativo${NC}" || echo -e "${RED}❌ Inativo${NC}")"
echo -e "🌐 API Portainer: $([ "$PORTAINER_STATUS" = "200" ] && echo -e "${GREEN}✅ Acessível${NC}" || echo -e "${RED}❌ Inacessível${NC}")"

print_section "🎯 AÇÕES RECOMENDADAS"
if [ "$BOT_RUNNING" -eq 0 ]; then
    echo -e "${YELLOW}⚠️ Bot não está rodando. Execute: docker stack deploy -c stack-config.yml bot-stack${NC}"
fi

if [ "$PORTAINER_STATUS" != "200" ]; then
    echo -e "${YELLOW}⚠️ Portainer inaccessível. Verifique o container e rede${NC}"
fi

if [ "$CONTAINER_COUNT" -eq 0 ]; then
    echo -e "${RED}⚠️ Nenhum container ativo. Verifique o Docker${NC}"
fi

echo -e "\n${GREEN}✅ Auditoria concluída!${NC}"
echo -e "${CYAN}📝 Para mais detalhes, consulte o arquivo TUTORIAL_ACESSO_VPS.md${NC}"

# Função adicional: Gerar QR Code se bot estiver ativo
if [ "$BOT_RUNNING" -gt 0 ]; then
    echo -e "\n${PURPLE}📱 Deseja visualizar o QR Code do bot? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        print_section "📱 QR CODE DO BOT"
        vps_exec "BOT_CONTAINER=\$(docker ps --filter 'name=bot' --format '{{.Names}}' | head -1); docker logs --tail 100 \$BOT_CONTAINER | grep -A 35 'QR CODE' | tail -40" 2>/dev/null
    fi
fi
