# Auditoria Pré-Execução do Plano — NPA Tecnologia

**Versão:** 1.0  
**Data:** 2026-04-28  
**Auditado por:** Agente de Auditoria Interna  
**Referência:** `plan_execution.md` v1.0  

---

## 1. Resultado Geral

| Dimensão | Status | Observação |
|---|---|---|
| Cobertura de fontes | ⚠️ Parcial | Repositórios privados e Figma/Notion sem acesso |
| Lacunas de acesso documentadas | ✅ OK | Todas registradas com ação alternativa |
| Dependências críticas mapeadas | ✅ OK | Vercel API funcional, GitHub local disponível |
| Riscos identificados | ✅ OK | 5 riscos com mitigação |
| Critérios de aceitação claros | ✅ OK | 11 critérios checkáveis |
| Cronograma realista | ✅ OK | Execução incremental em um único ciclo |
| Segurança de dados | ✅ OK | Protocolo de não-exposição de segredos definido |

**Veredito: APROVADO com ressalvas. Ajustes menores aplicados (seção 5).**

---

## 2. Cobertura das Fontes

### Fontes Confirmadas como Acessíveis
| Fonte | Cobertura Esperada | Gap Identificado |
|---|---|---|
| `README.md` | Identidade, stack, cases (14 projetos) | Sem detalhes de pricing ou SLA |
| `CHANGELOG.md` | Histórico do profile README (v1–v4) | Não cobre histórico de projetos cliente |
| `.github/workflows/snake.yml` | CI/CD do perfil público | Workflows internos inacessíveis |
| Vercel API — 19 projetos | Nome, ID, createdAt | Sem env vars, logs, framework detectado |
| Git log local | 9 commits, 2 branches | Histórico de repos privados ausente |

### Fontes Inacessíveis — Impacto Avaliado
| Fonte | Impacto no Plano | Compensação Aplicada |
|---|---|---|
| Repositórios privados de clientes | Alto — código-fonte, APIs, .env | Scripts de varredura + instruções manuais |
| Figma | Médio — design system, protótipos | Seção de design inferida por evidências |
| Notion | Baixo — docs internos | Playbook de integração gerado |
| Google Drive | Baixo — docs comerciais | Playbook de integração gerado |
| Supabase projetos | Alto — schema, tabelas, migrações | Script SQL + modelo de dados inferido |
| WhatsApp API configs | Médio — integração de IA | Documentado como suposição |

---

## 3. Lacunas de Acesso

### Lacuna 1 — Repositórios Privados
- **Severidade:** Alta
- **Risco:** Inventário técnico incompleto; APIs reais não mapeadas
- **Ação:** Scripts `scan_github.sh` e `scan_env.sh` gerados para execução manual
- **Suposição documentada:** Stack Next.js 14+ com App Router confirmada por evidências indiretas

### Lacuna 2 — Banco de Dados (Supabase)
- **Severidade:** Alta  
- **Risco:** Modelo de dados inferido, não verificado
- **Ação:** Script SQL `discover_schema.sql` gerado; instruções para `supabase db pull`
- **Suposição documentada:** Entidades baseadas em padrão de projetos do segmento (clients, projects, proposals, invoices)

### Lacuna 3 — Variáveis de Ambiente
- **Severidade:** Crítica para segurança
- **Risco:** Segredos potencialmente hardcoded ou mal rotacionados
- **Ação:** Script `list_env_locations.sh` gerado (lista localização, nunca valores)
- **Recomendação:** Auditoria manual urgente + migração para vault (Vercel Env, Doppler ou 1Password)

### Lacuna 4 — KPIs e Métricas de Negócio
- **Severidade:** Média
- **Risco:** Seções financeira e de vendas do company profile ficarão com dados inferidos
- **Ação:** Estrutura criada com placeholders e instruções para preenchimento

### Lacuna 5 — Design Assets (Figma)
- **Severidade:** Baixa
- **Risco:** Seção de design incompleta
- **Ação:** Script `scan_figma.sh` gerado; design system inferido por cores do README (#7C3AED roxo, #06B6D4 ciano)

---

## 4. Dependências Críticas

```
[Vercel API] ─────────────────── OK (autenticado, 19 projetos)
[GitHub local] ────────────────── OK (clonado, 9 commits)
[Supabase API] ────────────────── BLOQUEADO (sem service key)
[Figma API] ───────────────────── BLOQUEADO (sem token)
[Notion API] ──────────────────── BLOQUEADO (sem integration token)
[Google Drive API] ────────────── BLOQUEADO (sem OAuth)
[WhatsApp Business API] ───────── BLOQUEADO (sem credentials)
```

---

## 5. Ajustes ao Plano Aplicados

| # | Ajuste | Motivo |
|---|---|---|
| 1 | Adicionado segmento "Odontologia" ao company_profile | Detectado via Vercel (sirius-odontologia, fluari-odontologia) — ausente no README |
| 2 | Projeto `marq` e `npa-notas` adicionados ao inventário como "ferramentas internas" | Não documentados no README público |
| 3 | `npa-gestao-deploy-temp` marcado como projeto temporário/descartável | Nome sugere artefato de deploy pontual |
| 4 | Risco de segredos elevado de "Baixo" para "Crítico" | Padrão de mercado: projetos Next.js têm múltiplos .env |
| 5 | Seção Copilot marcada como "não aplicável" | Nenhuma evidência de uso no repositório |

---

## 6. Riscos Adicionais Identificados na Auditoria

| Risco | Probabilidade | Impacto | Ação |
|---|---|---|---|
| Projeto `npa-gestao-deploy-temp` sugere processo de deploy não padronizado | Média | Médio | Documentar e incluir como issue de DevOps |
| README público não menciona odontologia (2 projetos) — inconsistência de portfólio | Alta | Baixo | Registrar como issue de Sales/Marketing |
| Ausência de testes visíveis no repositório público | Alta | Alto | Issue de QA prioritária |
| LGPD: sites de clientes (advocacia, saúde) processam dados sensíveis | Alta | Crítico | Issue de Security/Legal urgente |

---

## 7. Parecer Final

O plano está **apto para execução** com as ressalvas documentadas. As lacunas de acesso são estruturais (ausência de tokens/credenciais) e não impedem a entrega — os scripts e playbooks compensam a falta de acesso direto. O risco mais relevante é o de conformidade LGPD em projetos de advocacia e saúde, que deve ser escalado imediatamente para revisão humana.

---

*Auditoria pré-execução concluída. Prosseguindo para fase de execução.*
