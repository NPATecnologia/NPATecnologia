#!/bin/bash
# =============================================================================
# scan_notion.sh — Varredura de páginas Notion da NPA Tecnologia
# =============================================================================
# Uso: NOTION_TOKEN=xxx ./scan_notion.sh
# Requer: curl, jq
# Obter token em: notion.so/my-integrations → Nova integração

set -euo pipefail

NOTION_TOKEN="${NOTION_TOKEN:?Erro: NOTION_TOKEN não definido. Criar em notion.so/my-integrations}"
OUTPUT_FILE="notion_inventory_$(date '+%Y%m%d_%H%M%S').json"

BASE_URL="https://api.notion.com/v1"
HEADERS=(
  -H "Authorization: Bearer $NOTION_TOKEN"
  -H "Notion-Version: 2022-06-28"
  -H "Content-Type: application/json"
)

log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }
error() { echo "[ERRO] $*" >&2; exit 1; }

command -v curl &>/dev/null || error "curl não encontrado"
command -v jq &>/dev/null || error "jq não encontrado"

log "Iniciando varredura Notion..."

# =============================================================================
# 1. Buscar usuário autenticado
# =============================================================================
me=$(curl -sf "${HEADERS[@]}" "$BASE_URL/users/me" 2>/dev/null || echo "{}")
user_name=$(echo "$me" | jq -r '.name // "Desconhecido"')
log "Autenticado como: $user_name"

# =============================================================================
# 2. Buscar databases acessíveis
# =============================================================================
log "Buscando databases..."
search_db=$(curl -sf "${HEADERS[@]}" \
  -X POST "$BASE_URL/search" \
  -d '{"filter": {"value": "database", "property": "object"}, "page_size": 100}' \
  2>/dev/null || echo '{"results": []}')

databases=$(echo "$search_db" | jq '[.results[] | {
  source: "notion",
  id: .id,
  name: (.title[0].plain_text // "Sem título"),
  url: .url,
  type: "notion_database",
  last_modified: .last_edited_time,
  owner: "npatecnologia",
  properties: (.properties | keys),
  notes: ""
}]')

DB_COUNT=$(echo "$databases" | jq 'length')
log "Databases encontrados: $DB_COUNT"

# =============================================================================
# 3. Buscar páginas acessíveis
# =============================================================================
log "Buscando páginas..."
search_pages=$(curl -sf "${HEADERS[@]}" \
  -X POST "$BASE_URL/search" \
  -d '{"filter": {"value": "page", "property": "object"}, "page_size": 100}' \
  2>/dev/null || echo '{"results": []}')

pages=$(echo "$search_pages" | jq '[.results[] | {
  source: "notion",
  id: .id,
  name: (
    if .properties.title.title[0].plain_text then
      .properties.title.title[0].plain_text
    elif .properties.Name.title[0].plain_text then
      .properties.Name.title[0].plain_text
    else
      "Sem título"
    end
  ),
  url: .url,
  type: "notion_page",
  last_modified: .last_edited_time,
  owner: "npatecnologia",
  notes: ""
}]')

PAGE_COUNT=$(echo "$pages" | jq 'length')
log "Páginas encontradas: $PAGE_COUNT"

# =============================================================================
# 4. Gerar inventário
# =============================================================================
inventory=$(jq -n \
  --argjson dbs "$databases" \
  --argjson pages "$pages" \
  --arg date "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
  '{
    metadata: {
      source: "notion",
      scanned_at: $date,
      tool: "scan_notion.sh v1.0"
    },
    summary: {
      total_databases: ($dbs | length),
      total_pages: ($pages | length)
    },
    databases: $dbs,
    pages: $pages
  }')

echo "$inventory" > "$OUTPUT_FILE"
log "Inventário salvo em: $OUTPUT_FILE"

echo ""
echo "============================================"
echo " RESUMO DA VARREDURA NOTION"
echo "============================================"
echo "$inventory" | jq -r '
  "Databases: \(.summary.total_databases)",
  "Páginas:   \(.summary.total_pages)",
  "Arquivo:   '"$OUTPUT_FILE"'"
'
echo "============================================"

log "Varredura concluída."
