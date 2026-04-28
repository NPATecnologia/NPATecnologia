#!/bin/bash
# build.sh — Gera apresentacao-npa.html e apresentacao-npa.pdf
# Uso: bash company-profile/scripts/build.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "NPA Tecnologia — Gerando apresentação comercial..."
node "$SCRIPT_DIR/build_apresentacao.mjs"
