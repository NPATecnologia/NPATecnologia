#!/bin/bash
# =============================================================================
# list_env_locations.sh — Inventaria NOMES de env vars por projeto Vercel
# =============================================================================
# SEGURANÇA: Este script NUNCA exibe valores de variáveis de ambiente.
# Apenas lista nomes, targets e tipos — suficiente para auditoria de cobertura.
#
# Uso: VERCEL_TOKEN=xxx ./list_env_locations.sh
# Saída: Markdown no terminal + JSON em arquivo

set -euo pipefail

TEAM_ID="${VERCEL_TEAM_ID:-team_ttjhXLRaY12KSK3OJoAeGez7}"
TOKEN="${VERCEL_TOKEN:?Erro: VERCEL_TOKEN não definido}"
OUTPUT_FILE="env_inventory_$(date '+%Y%m%d_%H%M%S').json"

BASE_URL="https://api.vercel.com"
AUTH_HEADER="Authorization: Bearer $TOKEN"

log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }

# Classificação de risco por padrão de nome
classify_risk() {
  local key="$1"
  if [[ "$key" =~ (SECRET|PRIVATE_KEY|SIGNING_KEY) ]]; then
    echo "CRÍTICO"
  elif [[ "$key" =~ (API_KEY|TOKEN|PASSWORD|PASSWD|PWD) ]]; then
    echo "ALTO"
  elif [[ "$key" =~ (DATABASE_URL|DB_URL|MONGO_URI|REDIS_URL) ]]; then
    echo "CRÍTICO"
  elif [[ "$key" =~ (SUPABASE_SERVICE|JWT_SECRET) ]]; then
    echo "CRÍTICO"
  elif [[ "$key" =~ (NEXT_PUBLIC_) ]]; then
    echo "BAIXO (público)"
  elif [[ "$key" =~ (URL|HOST|PORT|REGION) ]]; then
    echo "BAIXO"
  else
    echo "MÉDIO"
  fi
}

log "Iniciando inventário de env vars — Team: $TEAM_ID"
log "ATENÇÃO: Apenas nomes são exibidos/registrados. Valores nunca são expostos."

# Listar projetos
projects=$(curl -sf \
  -H "$AUTH_HEADER" \
  "$BASE_URL/v9/projects?teamId=$TEAM_ID&limit=100" \
  | jq -r '.projects[] | "\(.id)|\(.name)"')

echo ""
echo "# Inventário de Variáveis de Ambiente — NPA Tecnologia"
echo "# Gerado em: $(date '+%Y-%m-%d %H:%M:%S BRT')"
echo "# SEGURANÇA: Valores NÃO incluídos"
echo ""

ALL_ENVS="[]"

while IFS='|' read -r project_id project_name; do
  log "Processando: $project_name"

  envs_json=$(curl -sf \
    -H "$AUTH_HEADER" \
    "$BASE_URL/v9/projects/$project_id/env?teamId=$TEAM_ID" 2>/dev/null \
    | jq --arg pid "$project_id" --arg pname "$project_name" \
    '[.envs[] | {
      project_id: $pid,
      project: $pname,
      key: .key,
      type: .type,
      target: (.target | join(",")),
      created_at: .createdAt,
      value_note: "NÃO EXPOSTO"
    }]' \
    || echo "[]")

  ENV_COUNT=$(echo "$envs_json" | jq 'length')
  ALL_ENVS=$(echo "$ALL_ENVS $envs_json" | jq -s 'add')

  echo "## Projeto: $project_name ($project_id)"
  echo "| Variável | Tipo | Target | Risco |"
  echo "|---|---|---|---|"

  while IFS= read -r key; do
    risk=$(classify_risk "$key")
    type=$(echo "$envs_json" | jq -r ".[] | select(.key == \"$key\") | .type")
    target=$(echo "$envs_json" | jq -r ".[] | select(.key == \"$key\") | .target")
    echo "| \`$key\` | $type | $target | $risk |"
  done < <(echo "$envs_json" | jq -r '.[].key' | sort)

  echo ""
done <<< "$projects"

# Gerar JSON de saída
TOTAL_ENVS=$(echo "$ALL_ENVS" | jq 'length')
CRITICAL=$(echo "$ALL_ENVS" | jq '[.[] | select(.key | test("SECRET|PRIVATE_KEY|DATABASE_URL|SERVICE_KEY|JWT_SECRET"))] | length')
HIGH=$(echo "$ALL_ENVS" | jq '[.[] | select(.key | test("API_KEY|TOKEN|PASSWORD"))] | length')
PUBLIC=$(echo "$ALL_ENVS" | jq '[.[] | select(.key | test("^NEXT_PUBLIC_"))] | length')

inventory=$(jq -n \
  --argjson envs "$ALL_ENVS" \
  --arg team "$TEAM_ID" \
  --arg date "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
  --argjson total "$TOTAL_ENVS" \
  --argjson critical "$CRITICAL" \
  --argjson high "$HIGH" \
  --argjson public "$PUBLIC" \
  '{
    metadata: {
      source: "vercel_env_audit",
      team_id: $team,
      scanned_at: $date,
      security: "VALORES NUNCA INCLUÍDOS NESTE INVENTÁRIO"
    },
    summary: {
      total_env_keys: $total,
      critical_risk: $critical,
      high_risk: $high,
      public_vars: $public
    },
    recommendations: [
      "Auditar manualmente todas as variáveis CRÍTICO para verificar rotação",
      "Confirmar que NEXT_PUBLIC_* não contêm segredos",
      "Implementar vault (Doppler, 1Password) para gestão centralizada",
      "Definir política de rotação: CRÍTICO=90d, ALTO=180d"
    ],
    env_keys_only: $envs
  }')

echo "$inventory" > "$OUTPUT_FILE"
log "Inventário salvo em: $OUTPUT_FILE"

echo ""
echo "============================================"
echo " RESUMO"
echo "============================================"
echo "Total de variáveis mapeadas: $TOTAL_ENVS"
echo "Classificação CRÍTICO:       $CRITICAL"
echo "Classificação ALTO:          $HIGH"
echo "Variáveis públicas:          $PUBLIC"
echo "Arquivo:                     $OUTPUT_FILE"
echo "============================================"
echo ""
echo "PRÓXIMOS PASSOS:"
echo "1. Verificar se todas as vars CRÍTICO têm rotação < 90 dias"
echo "2. Verificar se NEXT_PUBLIC_* vars não contêm segredos"
echo "3. Implementar vault para gestão centralizada"
