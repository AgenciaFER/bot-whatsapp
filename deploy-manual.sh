#!/bin/bash

# 🚀 SCRIPT DE DEPLOY MANUAL DO BOT WHATSAPP
# Este script deve ser executado na VPS após enviar os arquivos

echo "🚀 Iniciando deploy do Bot WhatsApp..."

# Criar diretório de deploy
mkdir -p /opt/bot-whatsapp
cd /opt/bot-whatsapp

echo "📦 Construindo imagem Docker..."
docker build -t bot-whatsapp:latest .

echo "📋 Verificando se imagem foi criada..."
docker images | grep bot-whatsapp

echo "🔧 Fazendo deploy no Docker Swarm..."
docker stack deploy -c stack-portainer.yml bot-stack

echo "📊 Verificando status do serviço..."
docker service ls | grep bot

echo "📝 Mostrando logs (últimas 50 linhas)..."
sleep 10
docker service logs --tail 50 bot-stack_bot-whatsapp || echo "Serviço ainda não está pronto, aguarde..."

echo "✅ Deploy concluído!"
echo "🔍 Para monitorar logs: docker service logs -f bot-stack_bot-whatsapp"
echo "🐳 Para ver status: docker service ls"
echo "📱 Acesse o Portainer em: https://painel.agenciafer.com.br:9443"
