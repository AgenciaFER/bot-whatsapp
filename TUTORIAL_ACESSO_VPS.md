# 🔐 Tutorial Completo - Acesso VPS e Auditoria Portainer

## 📋 Informações de Acesso

### 🖥️ Credenciais VPS
- **IP:** `147.79.83.6`
- **Usuário:** `root`
- **Senha:** `L.mUnmSaXI9//l@yKLG7`
- **Painel Portainer:** `https://painel.agenciafer.com.br`

### 🔑 Comando Base de Acesso
```bash
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6
```

## 🛠️ Scripts Automatizados

### 📁 Arquivo Principal: `vps-auto.sh`
O arquivo `vps-auto.sh` contém todas as credenciais e funções automatizadas.

### 🔧 Função Útil
```bash
# Função para executar comandos remotos
vps_exec() {
    sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "$1"
}
```

---

## 🔍 AUDITORIA COMPLETA DO PORTAINER

### 1. 📊 Status Geral do Sistema
```bash
# Verificar status do Portainer
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo '=== STATUS PORTAINER ==='
curl -s https://painel.agenciafer.com.br/api/status | jq '.' 2>/dev/null || curl -s https://painel.agenciafer.com.br/api/status
echo ''
echo '=== VERSÃO ATUAL ==='
docker version --format 'Docker: {{.Server.Version}}'
echo ''
"
```

### 2. 🐳 Containers e Serviços
```bash
# Listar todos os containers
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo '=== CONTAINERS ATIVOS ==='
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}'
echo ''
echo '=== SERVIÇOS DOCKER SWARM ==='
docker service ls --format 'table {{.Name}}\t{{.Replicas}}\t{{.Image}}\t{{.Ports}}'
echo ''
"
```

### 3. 🤖 Status do Bot WhatsApp
```bash
# Verificar especificamente o bot
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo '=== STATUS BOT WHATSAPP ==='
docker ps | grep bot || echo 'Bot não encontrado'
echo ''
echo '=== SERVIÇOS DO BOT ==='
docker service ls | grep bot || echo 'Nenhum serviço do bot encontrado'
echo ''
echo '=== LOGS RECENTES DO BOT ==='
BOT_CONTAINER=\$(docker ps --filter 'name=bot' --format '{{.Names}}' | head -1)
if [ ! -z \"\$BOT_CONTAINER\" ]; then
    echo \"Container encontrado: \$BOT_CONTAINER\"
    docker logs --tail 20 \$BOT_CONTAINER
else
    echo 'Nenhum container do bot ativo'
fi
"
```

### 4. 💾 Recursos do Sistema
```bash
# Verificar recursos
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo '=== RECURSOS DO SISTEMA ==='
echo 'CPU e Memória:'
top -bn1 | head -5
echo ''
echo 'Uso de Disco:'
df -h
echo ''
echo 'Volumes Docker:'
docker volume ls
echo ''
echo 'Redes Docker:'
docker network ls
"
```

### 5. 🔐 Segurança e Licenças
```bash
# Verificar licenças e segurança
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo '=== LICENÇAS PORTAINER ==='
curl -s https://painel.agenciafer.com.br/api/motd 2>/dev/null || echo 'API não acessível'
echo ''
echo '=== CERTIFICADOS SSL ==='
echo | openssl s_client -servername painel.agenciafer.com.br -connect painel.agenciafer.com.br:443 2>/dev/null | openssl x509 -noout -dates 2>/dev/null || echo 'Erro ao verificar certificado'
echo ''
"
```

### 6. 📈 Logs e Monitoramento
```bash
# Verificar logs importantes
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo '=== LOGS DO PORTAINER ==='
PORTAINER_CONTAINER=\$(docker ps --filter 'name=portainer' --format '{{.Names}}' | head -1)
if [ ! -z \"\$PORTAINER_CONTAINER\" ]; then
    docker logs --tail 10 \$PORTAINER_CONTAINER
else
    echo 'Container Portainer não encontrado'
fi
echo ''
echo '=== EVENTOS DOCKER RECENTES ==='
docker events --since '1h' --until '0s' 2>/dev/null | tail -10 || echo 'Nenhum evento recente'
"
```

---

## 🚀 COMANDOS RÁPIDOS PARA AUDITORIA

### ⚡ Auditoria Completa (Um Comando)
```bash
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo '🔍 === AUDITORIA COMPLETA PORTAINER E BOT ===' && echo ''
echo '📊 1. STATUS PORTAINER:' && curl -s https://painel.agenciafer.com.br/api/status | head -3
echo '' && echo '🐳 2. CONTAINERS:' && docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
echo '' && echo '⚙️ 3. SERVIÇOS:' && docker service ls
echo '' && echo '🤖 4. BOT LOGS:' && docker logs --tail 5 \$(docker ps --filter 'name=bot' -q) 2>/dev/null || echo 'Bot não encontrado'
echo '' && echo '💾 5. RECURSOS:' && df -h | head -2 && free -h
echo '' && echo '🔗 6. REDES:' && docker network ls | grep -v bridge
echo '' && echo '✅ AUDITORIA CONCLUÍDA'
"
```

### 🤖 Verificação Específica do Bot
```bash
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo '🤖 === STATUS DETALHADO DO BOT ===' && echo ''
BOT_SERVICE=\$(docker service ls | grep bot | awk '{print \$1}')
if [ ! -z \"\$BOT_SERVICE\" ]; then
    echo 'Serviço encontrado:' \$BOT_SERVICE
    docker service ps \$BOT_SERVICE
    echo '' && echo 'Logs recentes:'
    docker service logs --tail 10 \$BOT_SERVICE
else
    echo 'Nenhum serviço do bot encontrado'
    echo 'Containers diretos:'
    docker ps | grep bot || echo 'Nenhum container do bot'
fi
"
```

### 🎯 QR Code do Bot (Se Ativo)
```bash
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo '📱 === QR CODE DO BOT ===' && echo ''
BOT_CONTAINER=\$(docker ps --filter 'name=bot' --format '{{.Names}}' | head -1)
if [ ! -z \"\$BOT_CONTAINER\" ]; then
    echo 'Buscando QR Code nos logs...'
    docker logs --tail 100 \$BOT_CONTAINER | grep -A 35 'QR CODE' | tail -40
else
    echo 'Bot não está ativo. Containers disponíveis:'
    docker ps --format '{{.Names}}'
fi
"
```

---

## 📝 COMANDOS DE MANUTENÇÃO

### 🔄 Reiniciar Bot
```bash
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
BOT_SERVICE=\$(docker service ls | grep bot | awk '{print \$1}')
if [ ! -z \"\$BOT_SERVICE\" ]; then
    echo 'Reiniciando serviço do bot...'
    docker service update --force \$BOT_SERVICE
else
    echo 'Nenhum serviço do bot encontrado'
fi
"
```

### 🧹 Limpeza do Sistema
```bash
sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6 "
echo 'Limpando sistema Docker...'
docker system prune -f
docker volume prune -f
echo 'Limpeza concluída'
"
```

---

## 🎯 COMO USAR

1. **Para auditoria completa**, execute:
   ```bash
   ./vps-auto.sh
   ```

2. **Para verificação rápida**, use o comando de auditoria completa acima

3. **Para problemas específicos**, use os comandos individuais

4. **Para acesso interativo**:
   ```bash
   sshpass -p "L.mUnmSaXI9//l@yKLG7" ssh -o StrictHostKeyChecking=no root@147.79.83.6
   ```

---

## 🔔 ALERTAS IMPORTANTES

- ⚠️ **Senha visível**: As credenciais estão em texto plano neste arquivo
- 🔒 **Segurança**: Mantenha este arquivo em local seguro
- 🔄 **Monitoramento**: Execute auditoria regularmente
- 📱 **QR Code**: Se múltiplos QR codes aparecerem, reinicie o bot

---

## 📞 TROUBLESHOOTING RÁPIDO

| Problema | Solução |
|----------|---------|
| Bot não responde | Verificar logs e reiniciar serviço |
| QR Code corrompido | Limpar volumes e reiniciar |
| Portainer inacessível | Verificar status do container |
| Falta de recursos | Executar limpeza do sistema |

**Arquivo criado:** `TUTORIAL_ACESSO_VPS.md`
**Status:** ✅ Pronto para uso independente
