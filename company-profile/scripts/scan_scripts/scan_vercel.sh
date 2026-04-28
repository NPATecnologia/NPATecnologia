#!/bin/bash
# =============================================================================
# scan_vercel.sh — Varredura de projetos Vercel da NPA Tecnologia
# =============================================================================
# Uso: VERCEL_TOKEN=xxx ./scan_vercel.sh [--team npatecnologia]
# Requer: curl, jq
# ATENÇÃO: Nunca exponha tokens ou env vars nos outputs

set -euo pipefail

TEAM_ID="${VERCEL_TEAM_ID:-team_ttjhXLRaY12KSK3OJoAeGez7}"
TOKEN="${VERCEL_TOKEN:?Erro: VERCEL_TOKEN não definido}"
OUTPUT_FILE="vercel_inventory_$(date '+%Y%m%d_%H%M%S').json"

BASE_URL="https://api.vercel.com"
AUTH_HEADER="Authorization: Bearer $TOKEN"

log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }
error() { echo "[ERRO] $*" >&2; exit 1; }

command -v curl &>/dev/null || error "curl não encontrado"
command -v jq &>/dev/null || error "jq não encontrado"

log "Iniciando varredura Vercel — Team: $TEAM_ID"

# =============================================================================
# 1. Listar projetos
# =============================================================================
log "Buscando projetos..."
projects=$(curl -sf \
  -H "$AUTH_HEADER" \
  "$BASE_URL/v9/projects?teamId=$TEAM_ID&limit=100" \
  | jq '[.projects[] | {
    source: "vercel",
    id: .id,
    name: .name,
    url: ("https://vercel.com/" + .accountId + "/" + .name),
    type: "project",
    last_modified: (.updatedAt // .createdAt | . / 1000 | todate),
    owner: "npatecnologia",
    framework: (.framework // "unknown"),
    node_version: (.nodeVersion // "unknown"),
    git_repo: (.link.repo // null),
    git_provider: (.link.type // null),
    created_at: (.createdAt / 1000 | todate),
    notes: ""
  }]')

PROJECT_COUNT=$(echo "$projects" | jq 'length')
log "Projetos encontrados: $PROJECT_COUNT"

# =============================================================================
# 2. Listar env var NAMES por projeto (sem expor valores)
# =============================================================================
log "Buscando nomes de variáveis de ambiente (sem valores)..."
env_inventory="[]"
while IFS= read -r project_id; do
  project_name=$(echo "$projects" | jq -r ".[] | select(.id == \"$project_id\") | .name")

  project_envs=$(curl -sf \
    -H "$AUTH_HEADER" \
    "$BASE_URL/v9/projects/$project_id/env?teamId=$TEAM_ID" 2>/dev/null \
    | jq --arg pid "$project_id" --arg pname "$project_name" \
    '[.envs[] | {
      project_id: $pid,
      project_name: $pname,
      key: .key,
      type: .type,
      target: .target,
      created_at: .createdAt,
      note: "VALOR NÃO EXPOSTO POR SEGURANÇA"
    }]' \
    || echo "[]")

  env_inventory=$(echo "$env_inventory $project_envs" | jq -s 'add')
done < <(echo "$projects" | jq -r '.[].id')

# =============================================================================
# 3. Listar últimos deploys por projeto
# =============================================================================
log "Buscando últimos deploys..."
deployments_data="[]"
while IFS= read -r project_id; do
  project_name=$(echo "$projects" | jq -r ".[] | select(.id == \"$project_id\") | .name")

  deploys=$(curl -sf \
    -H "$AUTH_HEADER" \
    "$BASE_URL/v6/deployments?projectId=$project_id&teamId=$TEAM_ID&limit=5" 2>/dev/null \
    | jq --arg pname "$project_name" \
    '[.deployments[] | {
      project: $pname,
      uid: .uid,
      url: .url,
      state: .state,
      created_at: (.createdAt / 1000 | todate),
      ready_at: (if .ready then (.ready / 1000 | todate) else null end),
      target: .target,
      meta_branch: .meta.githubCommitRef
    }]' \
    || echo "[]")

  deployments_data=$(echo "$deployments_data $deploys" | jq -s 'add')
done < <(echo "$projects" | jq -r '.[].id')

# =============================================================================
# 4. Gerar inventário padronizado
# =============================================================================
log "Gerando inventário JSON padronizado..."

inventory=$(jq -n \
  --argjson projects "$projects" \
  --argjson envs "$env_inventory" \
  --argjson deployments "$deployments_data" \
  --arg team "$TEAM_ID" \
  --arg date "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
  '{
    metadata: {
      source: "vercel",
      team_id: $team,
      scanned_at: $date,
      tool: "scan_vercel.sh v1.0",
      security_note: "Valores de env vars NUNCA incluídos neste inventário"
    },
    summary: {
      total_projects: ($projects | length),
      total_env_vars_keys: ($envs | length),
      total_deployments_sampled: ($deployments | length),
      projects_by_framework: ($projects | group_by(.framework) | map({framework: .[0].framework, count: length}))
    },
    projects: $projects,
    env_var_names_only: $envs,
    recent_deployments: $deployments
  }')

echo "$inventory" > "$OUTPUT_FILE"
log "Inventário salvo em: $OUTPUT_FILE"

# =============================================================================
# 5. Resumo no terminal
# =============================================================================
echo ""
echo "============================================"
echo " RESUMO DA VARREDURA VERCEL"
echo "============================================"
echo "$inventory" | jq -r '
  "Team:           \(.metadata.team_id)",
  "Projetos:       \(.summary.total_projects)",
  "Env Vars (IDs): \(.summary.total_env_vars_keys)",
  "Deploys amostrados: \(.summary.total_deployments_sampled)",
  "Arquivo:        '"$OUTPUT_FILE"'"
'
echo ""
echo "PROJETOS:"
echo "$projects" | jq -r '.[] | "  - \(.name) [\(.framework)] criado: \(.created_at)"'
echo "============================================"
echo ""
echo "ATENÇÃO: Valores de env vars NÃO estão no inventário (segurança)."
echo "Para auditar segredos, execute em ambiente controlado."

log "Varredura concluída."
