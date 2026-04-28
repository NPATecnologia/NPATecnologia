# ISSUE-004 — DevOps: Remover/Documentar Projeto npa-gestao-deploy-temp

**Título:** Investigar e resolver projeto temporário npa-gestao-deploy-temp no Vercel  
**Labels:** `devops`, `cleanup`, `infra`  
**Estimativa:** S (até 8h)  
**Responsável Sugerido:** Nathan (DevOps)  
**Criado em:** 2026-04-28  

---

## Contexto

O projeto `npa-gestao-deploy-temp` (ID: `prj_476rDET5quX6wSyc9TI40RAwOXlS`) foi criado no Vercel apenas **segundos após** o projeto `npa-gestao` (`prj_CTlLevDANwWifdyifAB4TaC7jzNf`), em 2026-04-25. O nome sugere que foi criado para resolver um problema de deploy urgente.

Projetos temporários esquecidos em produção representam:
- Custo desnecessário na conta Vercel
- Possível exposição de endpoint/build artifacts
- Confusão no inventário de projetos
- Potencial divergência de versão em relação ao projeto principal

---

## Problema

Projeto temporário ativo sem documentação de propósito ou plano de descomissionamento.

---

## Passos de Execução

1. **Auditar o projeto** via Vercel Dashboard:
   - Qual branch está deployado?
   - Tem domínio customizado?
   - Tem env vars diferentes do npa-gestao principal?
   - Tem tráfego ativo?

2. **Decisão de destino:**
   - Se sem tráfego → remover o projeto
   - Se com tráfego → redirecionar para npa-gestao e remover
   - Se config diferente → documentar e padronizar no projeto principal

3. **Se remover** — antes:
   ```bash
   # Exportar env vars (somente nomes, não valores)
   vercel env ls --token=$VERCEL_TOKEN > env_backup_deploy_temp.txt
   
   # Confirmar que npa-gestao tem todas as env vars necessárias
   vercel env ls -p npa-gestao --token=$VERCEL_TOKEN
   ```

4. **Documentar no npa-gestao** o que motivou a criação do projeto temp

5. **Remover** via Vercel Dashboard ou CLI:
   ```bash
   vercel project rm npa-gestao-deploy-temp --token=$VERCEL_TOKEN
   ```

---

## Critérios de Aceite

- [ ] Projeto `npa-gestao-deploy-temp` removido ou com status documentado
- [ ] Nenhuma perda de funcionalidade no npa-gestao principal
- [ ] Inventário Vercel atualizado (19 → 18 projetos após remoção)
- [ ] Documento explicando o incidente de deploy criado (post-mortem mínimo)
- [ ] Pipeline de deploy do npa-gestao padronizado para evitar recorrência

---

## Recomendação de Processo

Para evitar recorrência, adotar:
1. Preview deployments em PRs (ao invés de novo projeto)
2. Branch `staging` com ambiente de homologação permanente
3. Nunca criar projeto "temp" — usar `--prebuilt` do Vercel CLI se necessário
