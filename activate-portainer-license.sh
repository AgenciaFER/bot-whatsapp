#!/bin/bash

echo "=== ATIVADOR DE LICENÇA PORTAINER BUSINESS ==="
echo ""

PORTAINER_URL="https://painel.agenciafer.com.br"

echo "🔐 PASSO 1: Login no Portainer"
echo "Acesse: $PORTAINER_URL"
echo ""

echo "📝 PASSO 2: Criar/Fazer Login"
echo "- Se primeiro acesso: Crie usuário 'admin' com senha forte"
echo "- Se já tem conta: Faça login normalmente"
echo ""

echo "🎯 PASSO 3: Acessar Licenças"
echo "- Clique em 'Settings' (ícone de engrenagem) no menu lateral"
echo "- Clique em 'Licenses'"
echo "- OU acesse diretamente: $PORTAINER_URL/#!/settings/licenses"
echo ""

echo "🆓 PASSO 4: Ativar Licença Gratuita"
echo "- Clique em 'Get free license'"
echo "- Preencha os dados da empresa:"
echo "  • Company: Agência Fer"
echo "  • Email: seu-email@agenciafer.com.br"
echo "  • Nodes: até 5 (gratuito)"
echo ""

echo "✅ PASSO 5: Aplicar Licença"
echo "- Copie a chave de licença recebida"
echo "- Cole na área 'License key'"
echo "- Clique em 'Submit'"
echo ""

echo "🎉 PRONTO! Sua licença Business estará ativa!"
echo ""

echo "🔗 Acesse agora: $PORTAINER_URL"
