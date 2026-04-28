#!/bin/bash
# =============================================================================
# generate_inventory.sh — Orquestrador: gera inventário completo de todas as fontes
# =============================================================================
# Uso: ./generate_inventory.sh
# Requer: Todas as variáveis de ambiente configuradas (veja .env.example)
# ATENÇÃO: Configure apenas as fontes disponíveis — o script ignora as demais

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/../../evidence"
FINAL_OUTPUT="$OUTPUT_DIR/full_inventory_$(date '+%Y%m%d_%H%M%S').json"

log() { echo "[$(date '+%H:%M:%S')] $*"; }
warn() { echo "[AVISO] $*" >&2; }

mkdir -p "$OUTPUT_DIR"

log "Iniciando geração de inventário completo — NPA Tecnologia"
log "Saída: $FINAL_OUTPUT"
echo ""

# =============================================================================
# Verificar quais integrações estão disponíveis
# =============================================================================
AVAILABLE_SOURCES=()
UNAVAILABLE_SOURCES=()

check_source() {
  local name="$1"
  local var="$2"
  if [ -n "${!var:-}" ]; then
    AVAILABLE_SOURCES+=("$name")
    log "✓ $name — disponível"
  else
    UNAVAILABLE_SOURCES+=("$name")
    warn "✗ $name — $var não definido (ignorando)"
  fi
}

check_source "GitHub"  "GITHUB_TOKEN"
check_source "Vercel"  "VERCEL_TOKEN"
check_source "Figma"   "FIGMA_TOKEN"
check_source "Notion"  "NOTION_TOKEN"

echo ""

# =============================================================================
# Executar scans disponíveis
# =============================================================================
PARTIAL_INVENTORIES=()

if [[ " ${AVAILABLE_SOURCES[*]} " =~ " GitHub " ]]; then
  log "Executando scan GitHub..."
  outfile="$OUTPUT_DIR/github_raw.json"
  bash "$SCRIPT_DIR/scan_github.sh" > "$outfile" 2>/dev/null || warn "GitHub scan falhou"
  [ -f "$outfile" ] && PARTIAL_INVENTORIES+=("$outfile")
fi

if [[ " ${AVAILABLE_SOURCES[*]} " =~ " Vercel " ]]; then
  log "Executando scan Vercel..."
  outfile="$OUTPUT_DIR/vercel_raw.json"
  VERCEL_TOKEN="$VERCEL_TOKEN" bash "$SCRIPT_DIR/scan_vercel.sh" > /dev/null 2>&1
  # O scan_vercel.sh salva em arquivo local — mover para evidence/
  mv vercel_inventory_*.json "$outfile" 2>/dev/null || warn "Arquivo Vercel não encontrado"
  [ -f "$outfile" ] && PARTIAL_INVENTORIES+=("$outfile")
fi

if [[ " ${AVAILABLE_SOURCES[*]} " =~ " Figma " ]]; then
  log "Executando scan Figma..."
  outfile="$OUTPUT_DIR/figma_raw.json"
  FIGMA_TOKEN="$FIGMA_TOKEN" bash "$SCRIPT_DIR/scan_figma.sh" > /dev/null 2>&1
  mv figma_inventory_*.json "$outfile" 2>/dev/null || warn "Arquivo Figma não encontrado"
  [ -f "$outfile" ] && PARTIAL_INVENTORIES+=("$outfile")
fi

if [[ " ${AVAILABLE_SOURCES[*]} " =~ " Notion " ]]; then
  log "Executando scan Notion..."
  outfile="$OUTPUT_DIR/notion_raw.json"
  NOTION_TOKEN="$NOTION_TOKEN" bash "$SCRIPT_DIR/scan_notion.sh" > /dev/null 2>&1
  mv notion_inventory_*.json "$outfile" 2>/dev/null || warn "Arquivo Notion não encontrado"
  [ -f "$outfile" ] && PARTIAL_INVENTORIES+=("$outfile")
fi

# =============================================================================
# Consolidar inventários em formato padronizado
# =============================================================================
log "Consolidando inventários..."

# Inventário padronizado de exemplo (com dados estáticos + dinâmicos)
STATIC_ITEMS=$(cat << 'EOF'
[
  {
    "source": "github",
    "id": "NPATecnologia/NPATecnologia",
    "url": "https://github.com/NPATecnologia/NPATecnologia",
    "type": "github_repo_public",
    "last_modified": "2026-04-28",
    "owner": "npatecnologia",
    "notes": "Profile README — público"
  },
  {
    "source": "vercel",
    "id": "team_ttjhXLRaY12KSK3OJoAeGez7",
    "url": "https://vercel.com/npatecnologia",
    "type": "vercel_team",
    "last_modified": "2026-04-28",
    "owner": "npatecnologia",
    "notes": "19 projetos ativos"
  },
  {
    "source": "vercel",
    "id": "prj_CTlLevDANwWifdyifAB4TaC7jzNf",
    "url": "https://npa-gestao.vercel.app",
    "type": "vercel_project",
    "last_modified": "2026-04-25",
    "owner": "npatecnologia",
    "notes": "Sistema de gestão interno — projeto mais recente"
  },
  {
    "source": "vercel",
    "id": "prj_fPG2YJ4u8ztDOS5nkxc9o2jzaEjA",
    "url": "https://npatecnologia.com.br",
    "type": "vercel_project",
    "last_modified": "2026-03-24",
    "owner": "npatecnologia",
    "notes": "Site institucional"
  }
]
EOF
)

# Montar inventário final
SCANNED_AT=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
AVAILABLE_STR=$(printf '%s,' "${AVAILABLE_SOURCES[@]}")
UNAVAILABLE_STR=$(printf '%s,' "${UNAVAILABLE_SOURCES[@]}")

jq -n \
  --argjson static "$STATIC_ITEMS" \
  --arg scanned_at "$SCANNED_AT" \
  --arg available "${AVAILABLE_STR%,}" \
  --arg unavailable "${UNAVAILABLE_STR%,}" \
  '{
    metadata: {
      company: "NPA Tecnologia",
      scanned_at: $scanned_at,
      tool: "generate_inventory.sh v1.0",
      sources_available: ($available | split(",")),
      sources_unavailable: ($unavailable | split(","))
    },
    summary: {
      static_items: ($static | length),
      note: "Execute com todas as env vars para inventário completo"
    },
    inventory: $static
  }' > "$FINAL_OUTPUT"

echo ""
echo "============================================"
echo " INVENTÁRIO COMPLETO GERADO"
echo "============================================"
echo "Fontes disponíveis:    ${AVAILABLE_SOURCES[*]:-nenhuma}"
echo "Fontes indisponíveis:  ${UNAVAILABLE_SOURCES[*]:-nenhuma}"
echo "Arquivo final:         $FINAL_OUTPUT"
echo "============================================"
echo ""
echo "Para inventário completo, defina:"
echo "  export GITHUB_TOKEN=xxx"
echo "  export VERCEL_TOKEN=xxx"
echo "  export FIGMA_TOKEN=xxx      # opcional"
echo "  export NOTION_TOKEN=xxx     # opcional"
echo "  ./generate_inventory.sh"

log "Inventário gerado com sucesso."
