# Plano de Execução — Company Profile NPA Tecnologia

**Versão:** 1.0  
**Data:** 2026-04-28  
**Responsável:** Agente Sênior de Execução (Claude Code)  
**Branch:** claude/keen-sagan-Jv5tE  

---

## 1. Objetivo

Produzir documentação institucional completa e auditável da **NPA Tecnologia**, cobrindo identidade, portfólio, stack técnica, inventário de APIs, modelo de dados, backlog priorizado, issues rastreáveis, scripts de varredura e plano de melhoria contínua — tudo a partir de fontes locais e integráveis disponíveis no ambiente de execução.

---

## 2. Escopo

| Dimensão | Incluído | Excluído |
|---|---|---|
| Documentação institucional | Sim | Dados financeiros detalhados (sem acesso) |
| Inventário técnico (Vercel, GitHub) | Sim | Jira/Asana, Figma, Notion (sem token) |
| Backlog e roadmap | Sim | Sprints ativos em ferramentas externas |
| Issues estruturadas | Sim | Comentários de PRs históricos |
| Scripts de varredura | Sim | Execução automática remota |
| Diagrama ER | Sim (Mermaid) | PNG (sem canvas local) |
| Dados sensíveis / segredos | Nunca exposto | — |

---

## 3. Fontes a Mapear

### Fontes Acessíveis (confirmadas)
| Fonte | Status | Evidência |
|---|---|---|
| GitHub repo `NPATecnologia/NPATecnologia` | ✅ Acessível | Arquivo local clonado |
| README.md do repositório | ✅ Lido | Identidade, stack, cases |
| CHANGELOG.md | ✅ Lido | Histórico de versões do perfil |
| `.github/workflows/snake.yml` | ✅ Lido | CI/CD: GitHub Actions |
| Vercel Team `npatecnologia` | ✅ API respondeu | 19 projetos listados |
| Commits e branches do git local | ✅ Acessível | `git log`, `git branch` |

### Fontes Inacessíveis (sem credenciais/token)
| Fonte | Motivo | Ação Alternativa |
|---|---|---|
| Repositórios privados de clientes | Sem acesso direto | Script de varredura gerado |
| Figma | Sem token | Script + playbook manual |
| Notion | Sem token | Script + playbook manual |
| Google Drive | Sem OAuth | Script + playbook manual |
| Supabase (projetos internos) | Sem token de serviço | Script SQL + instruções |
| Logs de produção Vercel | Requer deploy linkado | Instruções manuais |
| Variáveis de ambiente dos projetos | Segurança — jamais exposto | Inventário de localização |

---

## 4. Suposições Documentadas

1. **Stack padrão dos projetos cliente**: Next.js 14+ com App Router, Tailwind CSS, TypeScript, deploy via Vercel. Confirmado por nomenclatura dos projetos e badges do README.
2. **Banco de dados**: Supabase (PostgreSQL) para projetos internos (npa-gestao, npa-notas, marq). Landing pages de clientes provavelmente são estáticas ou com API mínima.
3. **Autenticação**: Supabase Auth (padrão do ecossistema) ou NextAuth para projetos com login.
4. **Domínios**: Vercel subdomínios `.vercel.app` para a maioria; domínios próprios detectados em Studio Kelly Beauty, Studio Nicole Pagliari e Graxinha Envelopamentos (via README).
5. **Responsável técnico principal**: Nathan (nathan@npatecnologia.com.br) — único contato identificado.
6. **Modelo de negócio**: Serviço B2B — desenvolvimento de sites/apps para pequenas e médias empresas por segmento vertical.
7. **Copilot GitHub**: Não evidenciado no repositório público; registrado como "não aplicável no momento".
8. **Segmentos adicionais**: Odontologia detectada via Vercel (sirius-odontologia, fluari-odontologia) mas não mencionada no README público — segmento em expansão.

---

## 5. Agentes e Especialidades

| Agente | Responsabilidade no Projeto |
|---|---|
| Product | Roadmap, backlog priorizado, OKRs |
| UX | Padrões de design, consistência entre clientes |
| Backend | APIs, banco de dados, integrações |
| Frontend | Stack Next.js/React, componentes reutilizáveis |
| DevOps | CI/CD, Vercel, GitHub Actions, monitoramento |
| Data | Modelo de dados, inventário de entidades |
| QA | Cobertura de testes, critérios de aceite |
| Security | LGPD, segredos, vulnerabilidades |
| Legal/LGPD | Conformidade, privacidade, contratos |
| Sales | CRM, funil, proposta de valor |
| Integration | APIs externas, WhatsApp, IA |

---

## 6. Milestones

| Milestone | Artefatos | Data Alvo |
|---|---|---|
| **Checkpoint 1** | Plano, auditoria pré, scripts base, 5 issues, auditoria rascunho | Dia 1 |
| **Checkpoint 2** | Company profile rascunho, API inventory, 10 issues | Dia 1 |
| **Checkpoint 3** | Docs completos, backlog 50 itens, ERD, scripts finais, 20+ issues, pós-auditoria, improvement plan | Dia 1 |

---

## 7. Riscos

| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|
| Acesso negado a repositórios privados | Alta | Alto | Scripts de varredura + playbooks manuais |
| Stack real diverge das suposições | Média | Médio | Marcar claramente "suposição" nos artefatos |
| Projetos Vercel sem dados de deploy | Baixa | Baixo | Usar inventário de criação (createdAt) |
| Segredos expostos acidentalmente | Baixa | Crítico | Revisão manual antes de commit |
| Modelo de dados incompleto | Alta | Médio | Documentar lacunas e gerar scripts de descoberta |

---

## 8. Critérios de Aceitação

- [x] `plan_execution.md` existe e está estruturado
- [ ] `plan_audit_pre.md` existe
- [ ] `auditoria_origem.md` lista fontes acessíveis e inacessíveis
- [ ] `company_profile.md` está completo e estruturado por seção
- [ ] `api_inventory.md` existe com lacunas documentadas
- [ ] Backlog tem ~50 itens com todos os campos
- [ ] Existem pelo menos 20 issues `.md` individuais
- [ ] Scripts são executáveis ou têm instruções claras
- [ ] Nenhum segredo exposto
- [ ] `post_execution_audit.md` identifica gaps
- [ ] `improvement_plan.md` prioriza melhorias por sprint

---

## 9. Cronograma

```
Dia 1 (2026-04-28)
├── 00:00 — Exploração do repositório e Vercel API
├── 00:05 — plan_execution.md + plan_audit_pre.md
├── 00:15 — auditoria_origem.md + scripts iniciais
├── 00:30 — company_profile.md + summary
├── 00:50 — api_inventory.md + data_model.md + er_diagram.mmd
├── 01:10 — roadmap.md + prod_backlog.csv (50 itens)
├── 01:30 — 20 issues .md individuais
├── 01:50 — scripts de varredura completos
├── 02:00 — post_execution_audit.md + improvement_plan.md
└── 02:10 — commit + push + PR
```

---

*Gerado automaticamente pelo Agente Sênior de Execução. Revisão humana recomendada antes de compartilhamento externo.*
