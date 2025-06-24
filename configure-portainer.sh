#!/bin/bash

# Script para configurar Traefik + Portainer
VPS_IP="147.79.83.63"

echo "🚀 Configurando Traefik para expor Portainer..."

# Verificar se Portainer tem labels do Traefik
echo "📋 Verificando configuração atual do Portainer..."

# Criar configuração do Traefik para Portainer
cat > portainer-traefik.yml << 'EOF'
version: '3.8'

services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.portainer.rule=Host(\`painel.agenciafer.com.br\`)"
      - "traefik.http.routers.portainer.entrypoints=websecure"
      - "traefik.http.routers.portainer.tls.certresolver=letsencrypt"
      - "traefik.http.services.portainer.loadbalancer.server.port=9000"
      - "traefik.docker.network=traefik"

volumes:
  portainer_data:

networks:
  traefik:
    external: true
EOF

echo "✅ Arquivo de configuração criado: portainer-traefik.yml"
