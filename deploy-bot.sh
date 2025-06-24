#!/bin/bash

# Script de Deploy do Bot WhatsApp
VPS_IP="147.79.83.63"
BOT_DIR="/opt/bot-whatsapp"

echo "🤖 Iniciando deploy do Bot WhatsApp..."

# Função para executar comandos no VPS
run_vps_cmd() {
    sshpass -p ",.DAg,poGVEAfMcc-9pD" ssh -o StrictHostKeyChecking=no root@$VPS_IP "$1"
}

# 1. Verificar se os arquivos estão no VPS
echo "📂 Verificando arquivos transferidos..."
run_vps_cmd "ls -la $BOT_DIR"

# 2. Construir a imagem Docker
echo "🐳 Construindo imagem Docker do bot..."
run_vps_cmd "cd $BOT_DIR && docker build -t bot-whatsapp:latest ."

# 3. Criar docker-compose para produção
echo "📄 Criando configuração de produção..."
run_vps_cmd "cd $BOT_DIR && cat > docker-compose.prod.yml << 'EOF'
version: '3.8'

services:
  bot-whatsapp:
    image: bot-whatsapp:latest
    container_name: bot-whatsapp
    restart: unless-stopped
    environment:
      - NODE_ENV=production
    volumes:
      - ./config:/app/config
      - ./logs:/app/logs
      - ./exports:/app/exports
      - ./tmp:/app/tmp
    networks:
      - traefik
    labels:
      - \"traefik.enable=true\"
      - \"traefik.http.routers.bot.rule=Host(\\\`bot.agenciafer.com.br\\\`)\"
      - \"traefik.http.routers.bot.entrypoints=websecure\"
      - \"traefik.http.routers.bot.tls.certresolver=letsencrypt\"
      - \"traefik.http.services.bot.loadbalancer.server.port=3000\"

networks:
  traefik:
    external: true
EOF"

# 4. Iniciar o bot
echo "🚀 Iniciando o bot WhatsApp..."
run_vps_cmd "cd $BOT_DIR && docker-compose -f docker-compose.prod.yml up -d"

# 5. Verificar status
echo "📊 Verificando status do bot..."
run_vps_cmd "docker ps | grep bot-whatsapp"

echo "✅ Deploy concluído!"
