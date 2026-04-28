#!/bin/bash
# =============================================================================
# scan_figma.sh — Varredura de projetos Figma da NPA Tecnologia
# =============================================================================
# Uso: FIGMA_TOKEN=xxx ./scan_figma.sh [--team TEAM_ID]
# Requer: curl, jq
# Obter token em: https://www.figma.com/settings → Personal access tokens

set -euo pipefail

FIGMA_TOKEN="${FIGMA_TOKEN:?Erro: FIGMA_TOKEN não definido. Obter em figma.com/settings}"
FIGMA_TEAM_ID="${FIGMA_TEAM_ID:-}"
OUTPUT_FILE="figma_inventory_$(date '+%Y%m%d_%H%M%S').json"

BASE_URL="https://api.figma.com/v1"
AUTH_HEADER="X-Figma-Token: $FIGMA_TOKEN"

log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }
error() { echo "[ERRO] $*" >&2; exit 1; }

command -v curl &>/dev/null || error "curl não encontrado"
command -v jq &>/dev/null || error "jq não encontrado"

log "Iniciando varredura Figma..."

# =============================================================================
# 1. Verificar usuário autenticado
# =============================================================================
log "Verificando autenticação..."
me=$(curl -sf -H "$AUTH_HEADER" "$BASE_URL/me")
user_name=$(echo "$me" | jq -r '.handle // "desconhecido"')
user_email=$(echo "$me" | jq -r '.email // "desconhecido"')
log "Autenticado como: $user_name ($user_email)"

# =============================================================================
# 2. Listar teams (se FIGMA_TEAM_ID não definido)
# =============================================================================
if [ -z "$FIGMA_TEAM_ID" ]; then
  log "FIGMA_TEAM_ID não definido. Para listar projetos, defina a variável."
  log "Como encontrar o Team ID:"
  log "  1. Abra figma.com"
  log "  2. Selecione um projeto de time"
  log "  3. A URL será: figma.com/files/team/{TEAM_ID}/..."
  log "  4. Copie o TEAM_ID e reexecute: FIGMA_TEAM_ID=xxx ./scan_figma.sh"

  # Gerar inventário mínimo
  inventory=$(jq -n \
    --arg user "$user_name" \
    --arg email "$user_email" \
    --arg date "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    '{
      metadata: {
        source: "figma",
        scanned_at: $date,
        authenticated_as: $user,
        status: "PARCIAL — FIGMA_TEAM_ID não definido"
      },
      instructions: {
        step1: "Defina FIGMA_TEAM_ID com o ID do time NPA Tecnologia no Figma",
        step2: "Reexecute: FIGMA_TEAM_ID=xxx FIGMA_TOKEN=xxx ./scan_figma.sh",
        how_to_find_team_id: "URL do time Figma: figma.com/files/team/{TEAM_ID}/..."
      }
    }')

  echo "$inventory" > "$OUTPUT_FILE"
  log "Inventário parcial salvo em: $OUTPUT_FILE"
  exit 0
fi

# =============================================================================
# 3. Listar projetos do time
# =============================================================================
log "Buscando projetos do time $FIGMA_TEAM_ID..."
team_projects=$(curl -sf \
  -H "$AUTH_HEADER" \
  "$BASE_URL/teams/$FIGMA_TEAM_ID/projects" \
  | jq '[.projects[] | {
    source: "figma",
    id: (.id | tostring),
    name: .name,
    url: ("https://www.figma.com/files/project/" + (.id | tostring)),
    type: "figma_project",
    last_modified: null,
    owner: "npatecnologia",
    notes: ""
  }]')

PROJECT_COUNT=$(echo "$team_projects" | jq 'length')
log "Projetos encontrados: $PROJECT_COUNT"

# =============================================================================
# 4. Listar arquivos por projeto
# =============================================================================
log "Buscando arquivos..."
files_data="[]"
while IFS= read -r project_id; do
  project_name=$(echo "$team_projects" | jq -r ".[] | select(.id == \"$project_id\") | .name")

  project_files=$(curl -sf \
    -H "$AUTH_HEADER" \
    "$BASE_URL/projects/$project_id/files" 2>/dev/null \
    | jq --arg pname "$project_name" \
    '[.files[] | {
      source: "figma",
      id: .key,
      name: .name,
      url: ("https://www.figma.com/file/" + .key),
      type: "figma_file",
      project: $pname,
      last_modified: .last_modified,
      thumbnail_url: .thumbnail_url,
      owner: "npatecnologia",
      notes: ""
    }]' \
    || echo "[]")

  files_data=$(echo "$files_data $project_files" | jq -s 'add')
done < <(echo "$team_projects" | jq -r '.[].id')

# =============================================================================
# 5. Gerar inventário
# =============================================================================
inventory=$(jq -n \
  --argjson projects "$team_projects" \
  --argjson files "$files_data" \
  --arg team "$FIGMA_TEAM_ID" \
  --arg date "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
  '{
    metadata: {
      source: "figma",
      team_id: $team,
      scanned_at: $date,
      tool: "scan_figma.sh v1.0"
    },
    summary: {
      total_projects: ($projects | length),
      total_files: ($files | length)
    },
    projects: $projects,
    files: $files
  }')

echo "$inventory" > "$OUTPUT_FILE"
log "Inventário salvo em: $OUTPUT_FILE"

echo ""
echo "============================================"
echo " RESUMO DA VARREDURA FIGMA"
echo "============================================"
echo "$inventory" | jq -r '
  "Team:       \(.metadata.team_id)",
  "Projetos:   \(.summary.total_projects)",
  "Arquivos:   \(.summary.total_files)",
  "Arquivo:    '"$OUTPUT_FILE"'"
'
echo "============================================"

log "Varredura concluída."
