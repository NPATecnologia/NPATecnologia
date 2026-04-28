# ISSUE-008 — DevOps: Verificar SSL em Domínios Próprios

**Título:** Auditar e automatizar renovação de certificados SSL nos domínios customizados  
**Labels:** `devops`, `security`, `infra`, `alta-prioridade`  
**Estimativa:** S (até 8h)  
**Responsável Sugerido:** Nathan (DevOps)  
**Criado em:** 2026-04-28  

---

## Contexto

Três projetos da NPA Tecnologia usam domínios próprios (não .vercel.app):
- `graxinhaenvelopamentos.com.br` (Graxinha Envelopamentos)
- `studiokellybeauty.com.br` (Studio Kelly Beauty)
- `studionicolepagliari.com.br` (Studio Nicole Pagliari)

Se esses domínios estão apontados para a Vercel, o SSL é gerenciado automaticamente. Porém, se houver qualquer configuração manual (Nginx, VPS, etc.), o certificado Let's Encrypt precisa ser renovado a cada 90 dias. Um certificado expirado causa:
- Aviso de segurança no browser → fuga imediata de visitantes
- Queda de ranking no Google
- Dano à reputação do cliente

---

## Problema

Sem monitoramento de expiração de SSL, risco de certificados expirarem sem aviso.

---

## Passos de Execução

### 1. Verificar status atual dos certificados

```bash
#!/bin/bash
# Verificar SSL de domínios
domains=(
  "graxinhaenvelopamentos.com.br"
  "studiokellybeauty.com.br"
  "studionicolepagliari.com.br"
)

for domain in "${domains[@]}"; do
  echo "=== $domain ==="
  echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null \
    | openssl x509 -noout -dates 2>/dev/null
  echo ""
done
```

### 2. Verificar onde estão hospedados

```bash
# Checar se aponta para Vercel
for domain in graxinhaenvelopamentos.com.br studiokellybeauty.com.br studionicolepagliari.com.br; do
  echo "=== $domain ==="
  dig +short "$domain"
  curl -sI "https://$domain" | grep -i "x-vercel\|server:"
  echo ""
done
```

### 3. Configurar alerta de expiração

Se na Vercel → a renovação é automática. Configurar alerta de domínio no Vercel Dashboard.

Se em VPS com Certbot:
```bash
# Verificar cron de renovação
crontab -l | grep certbot
# Deve existir algo como:
# 0 12 * * * /usr/bin/certbot renew --quiet
```

### 4. Adicionar monitoramento com UptimeRobot ou similar

- Criar monitor de tipo "SSL Certificate" para cada domínio
- Alertar quando faltarem 30 dias para expiração
- Alertar imediatamente se HTTPS falhar

---

## Critérios de Aceite

- [ ] Certificados dos 3 domínios verificados (validade > 30 dias)
- [ ] Confirmado onde estão hospedados (Vercel vs VPS)
- [ ] Monitoramento de expiração configurado
- [ ] Se VPS: certbot --renew testado e cron ativo
- [ ] Documento com resultado da auditoria criado
- [ ] Alerta chega ao Nathan antes de expirar

---

## Ação de Emergência (se certificado expirado)

```bash
# Via Certbot (se VPS)
sudo certbot renew --force-renewal -d dominio.com.br

# Via Vercel (se problema de DNS)
vercel domains add dominio.com.br
```
