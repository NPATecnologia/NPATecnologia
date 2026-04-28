#!/bin/bash
# =============================================================================
# scan_github.sh — Varredura de repositórios GitHub da NPA Tecnologia
# =============================================================================
# Uso: GITHUB_TOKEN=xxx ./scan_github.sh [--org NPATecnologia] [--output json]
# Requer: curl, jq
# ATENÇÃO: Nunca exponha o token em logs ou outputs

set -euo pipefail

ORG="${GITHUB_ORG:-NPATecnologia}"
TOKEN="${GITHUB_TOKEN:?Erro: GITHUB_TOKEN não definido}"
OUTPUT_FORMAT="${1:-text}"
OUTPUT_FILE="github_inventory_$(date '+%Y%m%d_%H%M%S').json"

BASE_URL="https://api.github.com"
HEADERS=(
  -H "Authorization: Bearer $TOKEN"
  -H "Accept: application/vnd.github+json"
  -H "X-GitHub-Api-Version: 2022-11-28"
)

log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }
error() { echo "[ERRO] $*" >&2; exit 1; }

# Verificar dependências
command -v curl &>/dev/null || error "curl não encontrado"
command -v jq &>/dev/null || error "jq não encontrado"

log "Iniciando varredura da org: $ORG"

# =============================================================================
# 1. Listar repositórios
# =============================================================================
log "Buscando repositórios..."
repos=$(curl -sf "${HEADERS[@]}" \
  "$BASE_URL/orgs/$ORG/repos?type=all&per_page=100&sort=updated" \
  | jq '[.[] | {
    id: .id,
    name: .name,
    full_name: .full_name,
    private: .private,
    description: .description,
    language: .language,
    default_branch: .default_branch,
    stars: .stargazers_count,
    forks: .forks_count,
    open_issues: .open_issues_count,
    created_at: .created_at,
    updated_at: .updated_at,
    pushed_at: .pushed_at,
    topics: .topics,
    has_pages: .has_pages,
    archived: .archived,
    url: .html_url
  }]')

REPO_COUNT=$(echo "$repos" | jq 'length')
log "Repositórios encontrados: $REPO_COUNT"

# =============================================================================
# 2. Listar branches por repositório
# =============================================================================
log "Buscando branches..."
branches_data="[]"
while IFS= read -r repo_name; do
  repo_branches=$(curl -sf "${HEADERS[@]}" \
    "$BASE_URL/repos/$ORG/$repo_name/branches?per_page=100" 2>/dev/null \
    | jq --arg repo "$repo_name" '[.[] | {
        repo: $repo,
        branch: .name,
        sha: .commit.sha,
        protected: .protected
      }]' \
    || echo "[]")
  branches_data=$(echo "$branches_data $repo_branches" | jq -s 'add')
done < <(echo "$repos" | jq -r '.[].name')

# =============================================================================
# 3. Listar Issues abertas
# =============================================================================
log "Buscando issues abertas..."
issues_data="[]"
while IFS= read -r repo_name; do
  repo_issues=$(curl -sf "${HEADERS[@]}" \
    "$BASE_URL/repos/$ORG/$repo_name/issues?state=open&per_page=50" 2>/dev/null \
    | jq --arg repo "$repo_name" '[.[] | select(.pull_request == null) | {
        repo: $repo,
        number: .number,
        title: .title,
        state: .state,
        labels: [.labels[].name],
        created_at: .created_at,
        url: .html_url
      }]' \
    || echo "[]")
  issues_data=$(echo "$issues_data $repo_issues" | jq -s 'add')
done < <(echo "$repos" | jq -r '.[].name')

# =============================================================================
# 4. Listar Pull Requests abertos
# =============================================================================
log "Buscando PRs abertos..."
prs_data="[]"
while IFS= read -r repo_name; do
  repo_prs=$(curl -sf "${HEADERS[@]}" \
    "$BASE_URL/repos/$ORG/$repo_name/pulls?state=open&per_page=50" 2>/dev/null \
    | jq --arg repo "$repo_name" '[.[] | {
        repo: $repo,
        number: .number,
        title: .title,
        head_branch: .head.ref,
        base_branch: .base.ref,
        draft: .draft,
        created_at: .created_at,
        url: .html_url
      }]' \
    || echo "[]")
  prs_data=$(echo "$prs_data $repo_prs" | jq -s 'add')
done < <(echo "$repos" | jq -r '.[].name')

# =============================================================================
# 5. Listar GitHub Actions Workflows
# =============================================================================
log "Buscando GitHub Actions workflows..."
workflows_data="[]"
while IFS= read -r repo_name; do
  repo_workflows=$(curl -sf "${HEADERS[@]}" \
    "$BASE_URL/repos/$ORG/$repo_name/actions/workflows" 2>/dev/null \
    | jq --arg repo "$repo_name" '[.workflows[] | {
        repo: $repo,
        id: .id,
        name: .name,
        state: .state,
        path: .path,
        url: .html_url
      }]' \
    || echo "[]")
  workflows_data=$(echo "$workflows_data $repo_workflows" | jq -s 'add')
done < <(echo "$repos" | jq -r '.[].name')

# =============================================================================
# 6. Gerar inventário JSON padronizado
# =============================================================================
log "Gerando inventário JSON..."

inventory=$(jq -n \
  --argjson repos "$repos" \
  --argjson branches "$branches_data" \
  --argjson issues "$issues_data" \
  --argjson prs "$prs_data" \
  --argjson workflows "$workflows_data" \
  --arg org "$ORG" \
  --arg date "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
  '{
    metadata: {
      source: "github",
      org: $org,
      scanned_at: $date,
      tool: "scan_github.sh v1.0"
    },
    summary: {
      total_repos: ($repos | length),
      total_branches: ($branches | length),
      total_open_issues: ($issues | length),
      total_open_prs: ($prs | length),
      total_workflows: ($workflows | length),
      private_repos: ($repos | map(select(.private == true)) | length),
      public_repos: ($repos | map(select(.private == false)) | length),
      archived_repos: ($repos | map(select(.archived == true)) | length)
    },
    repositories: $repos,
    branches: $branches,
    open_issues: $issues,
    open_pull_requests: $prs,
    workflows: $workflows
  }')

echo "$inventory" > "$OUTPUT_FILE"
log "Inventário salvo em: $OUTPUT_FILE"

# =============================================================================
# 7. Resumo no terminal
# =============================================================================
echo ""
echo "============================================"
echo " RESUMO DA VARREDURA GITHUB — $ORG"
echo "============================================"
echo "$inventory" | jq -r '
  "Repositórios:    \(.summary.total_repos) (\(.summary.private_repos) privados, \(.summary.public_repos) públicos)",
  "Branches:        \(.summary.total_branches)",
  "Issues abertas:  \(.summary.total_open_issues)",
  "PRs abertos:     \(.summary.total_open_prs)",
  "Workflows:       \(.summary.total_workflows)",
  "Arquivo:         '"$OUTPUT_FILE"'"
'
echo "============================================"

log "Varredura concluída."
