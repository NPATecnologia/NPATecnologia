# ISSUE-014 — DevOps: Backups Automáticos do Banco de Dados

**Título:** Configurar backup diário do PostgreSQL/Supabase com teste de restore  
**Labels:** `devops`, `data`, `infra`, `alta-prioridade`  
**Estimativa:** S (até 8h)  
**Responsável Sugerido:** Nathan (DevOps)  
**Criado em:** 2026-04-28  

---

## Contexto

O npa-gestao e npa-notas usam Supabase (PostgreSQL). Esses bancos contêm dados críticos de negócio: clientes, propostas, faturas, notas. O Supabase Pro inclui backups automáticos, mas o plano Free tem limitações. Independente do provedor, é essencial ter processo de backup documentado e testado.

---

## Problema

Sem processo de backup documentado e testado, um incidente de corrupção de dados ou exclusão acidental pode causar perda irreversível de informações de negócio.

---

## Passos de Execução

### 1. Verificar o plano atual do Supabase

- Plano Free: PITR por 7 dias (limitado)
- Plano Pro: PITR por 30 dias + backups diários

### 2. Script de backup externo (complementar)

```bash
#!/bin/bash
# scripts/scan_scripts/backup_supabase.sh
# Backup do PostgreSQL Supabase para arquivo local

DB_URL="${DATABASE_URL:?DATABASE_URL não definido}"
BACKUP_DIR="./backups"
DATE=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="$BACKUP_DIR/npa_backup_$DATE.sql"

mkdir -p "$BACKUP_DIR"

echo "Iniciando backup: $BACKUP_FILE"

pg_dump \
  --no-password \
  --format=custom \
  --compress=9 \
  --exclude-table=auth.* \
  "$DB_URL" \
  > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
  SIZE=$(du -sh "$BACKUP_FILE" | cut -f1)
  echo "Backup concluído: $BACKUP_FILE ($SIZE)"
  
  # Remover backups com mais de 30 dias
  find "$BACKUP_DIR" -name "npa_backup_*.sql" -mtime +30 -delete
  echo "Backups antigos removidos"
else
  echo "ERRO: Falha no backup!" >&2
  # Enviar alerta (via curl para webhook ou email)
  exit 1
fi
```

### 3. Configurar upload para S3/Cloudflare R2 (opcional)

```bash
# Após backup, fazer upload para storage externo
aws s3 cp "$BACKUP_FILE" "s3://npa-backups/$(basename $BACKUP_FILE)"
# ou
rclone copy "$BACKUP_FILE" r2:npa-backups/
```

### 4. Automatizar com GitHub Actions (Cron)

```yaml
# .github/workflows/backup.yml
name: Database Backup
on:
  schedule:
    - cron: "0 4 * * *"  # 04:00 UTC = 01:00 BRT
  workflow_dispatch:

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install PostgreSQL client
        run: sudo apt-get install -y postgresql-client
      - name: Run backup
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
        run: bash scripts/scan_scripts/backup_supabase.sh
      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: db-backup-${{ github.run_number }}
          path: backups/
          retention-days: 30
```

### 5. Testar restore (mensal)

```bash
# Teste de restore em banco temporário
pg_restore \
  --no-owner \
  --no-acl \
  -d "postgresql://user:pass@localhost/test_restore" \
  "$BACKUP_FILE"

echo "Verificando tabelas restauradas..."
psql -d "postgresql://user:pass@localhost/test_restore" \
  -c "SELECT schemaname, tablename, n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC;"
```

---

## Critérios de Aceite

- [ ] Script de backup executável e documentado
- [ ] Backup roda diariamente (GitHub Actions cron ou similar)
- [ ] Arquivo de backup gerado sem erro
- [ ] Backup antigo (>30 dias) removido automaticamente
- [ ] Alerta enviado se backup falhar
- [ ] Teste de restore documentado e executado com sucesso
- [ ] RTO (Recovery Time Objective) definido: < 4 horas
- [ ] RPO (Recovery Point Objective) definido: < 24 horas

---

## Checklist Mensal de Restore

- [ ] Restaurar backup mais recente em ambiente de teste
- [ ] Verificar integridade das tabelas críticas (clients, projects, invoices)
- [ ] Documentar resultado no `evidence/backup_restore_log.md`
