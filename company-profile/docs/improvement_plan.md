# Plano de Melhoria — NPA Tecnologia Company Profile

**Versão:** 1.0  
**Data:** 2026-04-28  
**Horizonte:** 6 sprints de 2 semanas (12 semanas / ~3 meses)  

---

## Princípios do Plano

1. **Segurança e compliance primeiro** — LGPD e OWASP antes de novas features
2. **Validar antes de expandir** — confirmar dados reais antes de ampliar documentação
3. **Incremental** — cada sprint entrega valor mensurável
4. **Responsabilidade única** — cada item tem um responsável definido

---

## Sprint 1 (Mai 01–14, 2026) — COMPLIANCE E SEGURANÇA

**Objetivo:** Eliminar riscos legais e de segurança críticos.

| Prioridade | Item | Responsável | Critério de Aceite | Estimativa | Dependência |
|---|---|---|---|---|---|
| P0 | Implementar política de privacidade em sites de advocacia e saúde | Nathan + advogado | Páginas no ar; link no footer | M | — |
| P0 | Adicionar banner de cookies LGPD em todos os 15 sites | Nathan | Banner funcional; GA4 bloqueado sem aceite | M | — |
| P0 | Rate limiting + CAPTCHA em formulários de contato | Nathan | 429 após 5 req/min; Turnstile validado server-side | S | — |
| P1 | Inventário de env vars (nomes apenas) | Nathan | Planilha de nomes por projeto; zero valores expostos | S | VERCEL_TOKEN disponível |
| P1 | Verificar SSL em domínios próprios | Nathan | Certificados com > 30 dias; monitoramento ativo | S | — |

**Critérios de aceitação do Sprint:**
- [ ] Sites de advocacia e saúde com política de privacidade publicada
- [ ] Zero formulários sem rate limiting
- [ ] Inventário de env vars gerado e documentado

---

## Sprint 2 (Mai 15–28, 2026) — VALIDAÇÃO TÉCNICA

**Objetivo:** Validar dados inferidos contra realidade dos repositórios.

| Prioridade | Item | Responsável | Critério de Aceite | Estimativa | Dependência |
|---|---|---|---|---|---|
| P0 | Executar scripts de varredura com tokens reais | Nathan | Inventários GitHub e Vercel gerados | S | GITHUB_TOKEN, VERCEL_TOKEN |
| P0 | Validar modelo de dados contra schema real Supabase | Nathan | `data_model.md` atualizado com schema real | M | Acesso ao Supabase |
| P1 | Mapear endpoints reais de API (scan dos repos privados) | Nathan | `api_inventory.md` atualizado com endpoints reais | M | Acesso aos repos |
| P1 | Documentar projeto Marq | Nathan | Documento de produto criado; status definido | S | — |
| P2 | Gerar er_diagram.png via Mermaid CLI | Nathan | Arquivo .png gerado e commitado | S | npm install mmdc |

**Critérios de aceitação do Sprint:**
- [ ] Modelo de dados validado (ou divergências documentadas)
- [ ] `api_inventory.md` com pelo menos 50% dos endpoints reais
- [ ] Projeto Marq documentado

---

## Sprint 3 (Jun 01–14, 2026) — PRODUTO CORE

**Objetivo:** Consolidar npa-gestao com funcionalidades base operacionais.

| Prioridade | Item | Responsável | Critério de Aceite | Estimativa | Dependência |
|---|---|---|---|---|---|
| P0 | CRUD de clientes no npa-gestao | Nathan | API + UI funcionando; 15 clientes cadastrados | M | Schema validado (Sprint 2) |
| P0 | Pipeline de vendas Kanban | Nathan | 7 colunas; drag-and-drop; alertas de follow-up | L | CRUD clientes |
| P1 | Geração de proposta em PDF | Nathan | PDF gerado em < 3s; download na UI | M | CRUD clientes |
| P2 | Backup automático do banco de dados | Nathan | Backup diário rodando; teste de restore OK | S | — |

**Critérios de aceitação do Sprint:**
- [ ] npa-gestao gerenciando clientes e propostas
- [ ] Pipeline de vendas com todos os 15 clientes catalogados
- [ ] Backup automático configurado e testado

---

## Sprint 4 (Jun 15–28, 2026) — QUALIDADE E TESTES

**Objetivo:** Elevar qualidade técnica com testes e auditoria de segurança.

| Prioridade | Item | Responsável | Critério de Aceite | Estimativa | Dependência |
|---|---|---|---|---|---|
| P0 | Suite de testes npa-gestao (Vitest + Playwright) | Nathan | Cobertura > 80%; E2E para 5 fluxos; CI integrado | L | npa-gestao funcional |
| P0 | Auditoria OWASP Top 10 | Nathan | Relatório preenchido; zero issues críticas abertas | M | — |
| P1 | SEO técnico em sites prioritários (advocacia + saúde) | Nathan | Lighthouse SEO > 90 nos 6 sites | M | — |
| P2 | Headers de segurança HTTP em todos os projetos | Nathan | HSTS, CSP, X-Frame configurados | S | — |

**Critérios de aceitação do Sprint:**
- [ ] npa-gestao com testes automatizados rodando no CI
- [ ] Nenhuma vulnerabilidade crítica OWASP aberta
- [ ] SEO técnico implementado nos sites de advocacia e saúde

---

## Sprint 5 (Jul 01–14, 2026) — DESIGN SYSTEM E IA

**Objetivo:** Criar fundações de design reutilizável e integrar IA.

| Prioridade | Item | Responsável | Critério de Aceite | Estimativa | Dependência |
|---|---|---|---|---|---|
| P0 | Design tokens oficiais (pacote @npa/tokens) | Nathan | Tokens documentados; aplicados em 2 projetos | S | — |
| P0 | Biblioteca de componentes v1 (7 componentes) | Nathan | Storybook deployado; usado em 1 novo projeto | L | Design tokens |
| P1 | Geração de copy via IA (Claude/OpenAI) | Nathan | Endpoint funcional; testado em 3 segmentos | M | — |
| P2 | Notificação de leads via WhatsApp | Nathan | Mensagem entregue em < 5s; fallback por email | M | WhatsApp API token |

**Critérios de aceitação do Sprint:**
- [ ] Design system v1 publicado e documentado
- [ ] Geração de copy de IA reduzindo tempo de criação em > 50%

---

## Sprint 6 (Jul 15–28, 2026) — ANALYTICS E ESCALA

**Objetivo:** Implementar métricas, analytics e preparar para crescimento.

| Prioridade | Item | Responsável | Critério de Aceite | Estimativa | Dependência |
|---|---|---|---|---|---|
| P0 | Dashboard de analytics no npa-gestao | Nathan | MRR, pipeline, projetos visíveis; carrega em < 2s | M | Módulo financeiro |
| P0 | Contrato padrão de prestação de serviços | Nathan + advogado | Contrato revisado; usado em novos contratos | M | — |
| P1 | GA4 em todos os 15 sites (com consentimento) | Nathan | GA4 ativo; conversões rastreadas; LGPD compliant | M | Banner cookies (Sprint 1) |
| P2 | Atualizar company_profile.md com dados reais | Nathan | Seções financeira e KPIs com números reais | S | Dashboard pronto |

**Critérios de aceitação do Sprint:**
- [ ] Dashboard de analytics mostrando MRR real
- [ ] Contrato padrão em uso
- [ ] Company profile atualizado com métricas reais

---

## Itens Críticos Pendentes (sem sprint definida)

| Item | Urgência | Responsável | Bloqueador |
|---|---|---|---|
| CNPJ e regularização legal da NPA | Alta | Nathan | Verificar situação atual |
| Registro de marca "NPA Tecnologia" no INPI | Média | Nathan + advogado | Custo e disponibilidade |
| Contratação de colaborador | Baixa | Nathan | Receita suficiente (Q3 2026) |
| SaaS do npa-gestao | Baixa | Nathan | npa-gestao v1.0 estável |

---

## Dependências Críticas do Plano

```
[Sprint 1: LGPD] ──────────────────────────────────────────▶ [Compliance básico]
[Sprint 2: Validação] ──────────────────────────────────────▶ [Dados confiáveis]
[Sprint 3: Produto Core] ──────────────────────────────────▶ [npa-gestao funcional]
    │
    ├──▶ [Sprint 4: Qualidade] ────────▶ [npa-gestao estável]
    │
    └──▶ [Sprint 5: Design + IA] ──────▶ [Entregas mais rápidas]
              │
              └──▶ [Sprint 6: Analytics] ──▶ [Decisões baseadas em dados]
```

---

## Riscos do Plano

| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|
| Nathan não ter tempo para todos os sprints (solopreneur) | Alta | Alto | Reduzir escopo por sprint; focar top 3 itens |
| Acesso a repositórios privados não liberado | Média | Médio | Usar scripts de varredura localmente |
| Custo de APIs de IA exceder orçamento | Baixa | Médio | Monitorar tokens por request desde o início |
| Advogado para LGPD não disponível rapidamente | Média | Alto | Templates públicos como base enquanto aguarda |
| npa-gestao atrasar por mudança de escopo | Média | Alto | Congelar escopo do MVP antes de iniciar Sprint 3 |

---

## Métricas de Sucesso do Plano

| Métrica | Baseline (Hoje) | Meta (90 dias) |
|---|---|---|
| Sites com política de privacidade | 0/15 | 15/15 |
| Cobertura de testes npa-gestao | 0% | > 80% |
| Vulnerabilidades OWASP críticas | Desconhecido | 0 |
| Issues LGPD críticas resolvidas | 0/3 | 3/3 |
| Backlog priorizado e em execução | 0% | 50% concluído |
| Dashboard de analytics ativo | Não | Sim |

---

*Plano de melhoria revisado a cada sprint. Próxima revisão: 2026-05-14.*
