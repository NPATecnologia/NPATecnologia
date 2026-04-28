# ISSUE-010 — Security/Data: Inventário de Variáveis de Ambiente

**Título:** Mapear e auditar todos os env vars por projeto sem expor valores  
**Labels:** `security`, `devops`, `data`, `alta-prioridade`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan  
**Criado em:** 2026-04-28  

---

## Contexto

A NPA Tecnologia mantém 19 projetos no Vercel, cada um com potencialmente 5-15 variáveis de ambiente. Sem inventário, é impossível saber:
- Quais chaves de API estão sendo usadas e onde
- Quais credenciais precisam ser rotacionadas
- Se há segredos compartilhados indevidamente entre projetos
- Se há chaves antigas/revogadas ainda configuradas

---

## Problema

Ausência de gestão centralizada de segredos. Risco de vazamento, uso indevido e custo inesperado por chaves comprometidas.

---

## Passos de Execução

### 1. Executar script de inventário (sem expor valores)

```bash
#!/bin/bash
# scripts/scan_scripts/list_env_locations.sh
# Lista NOMES de env vars por projeto Vercel — NUNCA expõe valores

TEAM_ID="team_ttjhXLRaY12KSK3OJoAeGez7"
TOKEN="${VERCEL_TOKEN:?VERCEL_TOKEN não definido}"

# Listar todos os projetos
projects=$(curl -s \
  "https://api.vercel.com/v9/projects?teamId=$TEAM_ID&limit=100" \
  -H "Authorization: Bearer $TOKEN" \
  | jq -r '.projects[] | "\(.id)|\(.name)"')

echo "# Inventário de Env Vars — $(date '+%Y-%m-%d')"
echo "# ATENÇÃO: Apenas nomes, nunca valores"
echo ""

while IFS='|' read -r project_id project_name; do
  echo "## Projeto: $project_name ($project_id)"
  
  envs=$(curl -s \
    "https://api.vercel.com/v9/projects/$project_id/env?teamId=$TEAM_ID" \
    -H "Authorization: Bearer $TOKEN" \
    | jq -r '.envs[] | "- \(.key) [\(.target | join(","))] [\(.type)]"')
  
  echo "$envs"
  echo ""
done <<< "$projects"
```

### 2. Classificar variáveis por categoria de risco

| Padrão de Nome | Categoria | Risco | Rotação Recomendada |
|---|---|---|---|
| `*_SECRET_KEY` | API Secret | Crítico | 90 dias |
| `*_API_KEY` | API Key | Alto | 180 dias |
| `*_TOKEN` | Token | Alto | 90 dias |
| `DATABASE_URL` | Connection String | Crítico | Após incidente |
| `SUPABASE_*` | BaaS Config | Alto | 180 dias |
| `NEXT_PUBLIC_*` | Público (client) | Baixo | Não contém segredos |

### 3. Criar inventário JSON padronizado

```json
{
  "source": "vercel",
  "id": "prj_CTlLevDANwWifdyifAB4TaC7jzNf",
  "url": "https://vercel.com/npatecnologia/npa-gestao",
  "type": "env_inventory",
  "last_modified": "2026-04-28",
  "owner": "npatecnologia",
  "notes": "Env vars mapeadas — valores não incluídos por segurança"
}
```

### 4. Recomendações de vault

Para gestão centralizada de segredos, avaliar:
- **Vercel Env Vars** (já em uso — adicionar organização por projeto)
- **Doppler** (gratuito para times pequenos, sincroniza com Vercel)
- **1Password Secrets Automation** (pago, mais robusto)

---

## Critérios de Aceite

- [ ] Script `list_env_locations.sh` executável e funcional
- [ ] Inventário gerado listando NOMES de env vars por projeto (sem valores)
- [ ] Classificação de risco por padrão de nome aplicada
- [ ] Documento recomendando política de rotação por categoria
- [ ] Pelo menos 1 chave de alto risco identificada para rotação imediata
- [ ] Recomendação de vault documentada com comparativo de opções

---

## Ação Imediata Recomendada

Se qualquer chave de API estiver exposta em código-fonte ou commit history:
1. Revogar imediatamente no provider (OpenAI, Anthropic, etc.)
2. Gerar nova chave
3. Atualizar no Vercel
4. Verificar git log por vazamentos: `git log -p | grep -i "api_key\|secret\|token"`
