# Roadmap — NPA Tecnologia

**Versão:** 1.0  
**Data:** 2026-04-28  
**Horizonte:** Q2 2026 – Q1 2027  

---

## Visão Geral

```
Q2 2026 (Abr–Jun)   → FUNDAÇÃO: Conformidade, padronização, operação
Q3 2026 (Jul–Set)   → PRODUTO: npa-gestao CRM completo, design system
Q4 2026 (Out–Dez)   → ESCALA: Pacotes verticais, automação IA, SaaS
Q1 2027 (Jan–Mar)   → EXPANSÃO: Novos segmentos, time, posicionamento
```

---

## Fase 1 — Fundação (Q2 2026)

**Objetivo:** Garantir conformidade legal, padronizar operação e consolidar o portfólio existente.

### Sprint 1 (Mai 1–14)
- [ ] Implementar política de privacidade em todos os 15 sites cliente
- [ ] Adicionar banner de cookies LGPD-compliant em cada site
- [ ] Criar campos LGPD na tabela `contacts` do banco de dados
- [ ] Definir template padrão de contrato de prestação de serviços
- [ ] Inventariar todos os segredos/env vars por projeto

### Sprint 2 (Mai 15–28)
- [ ] Criar template de briefing por segmento (advocacia, gastronomia, beauty, etc.)
- [ ] Documentar processo de entrega: briefing → Figma → dev → QA → deploy
- [ ] Adicionar segmento de odontologia ao README e npatecnologia.com.br
- [ ] Criar Red Garage e Lowrider como projetos Vercel separados (ou documentar situação atual)
- [ ] Implementar monitoramento de uptime (UptimeRobot ou Vercel Analytics)

### Sprint 3 (Jun 1–14)
- [ ] Estruturar npa-gestao: cadastro de clientes e projetos funcional
- [ ] Implementar pipeline de vendas no npa-gestao (lead → proposta → contrato → entrega)
- [ ] Criar primeira versão do CRM com histórico de comunicação
- [ ] Definir SLAs internos de entrega por tipo de projeto

### Sprint 4 (Jun 15–30)
- [ ] Criar biblioteca de componentes reutilizáveis v1 (hero, CTA, testimonials, footer)
- [ ] Padronizar deploy pipeline com preview deployments para todos os novos projetos
- [ ] Implementar health check automatizado para os 15 sites em produção
- [ ] Revisar e atualizar README público com segmento de odontologia e novos cases

---

## Fase 2 — Produto (Q3 2026)

**Objetivo:** Transformar ferramentas internas em produto e elevar a qualidade técnica.

### Sprint 5 (Jul 1–14)
- [ ] npa-gestao: módulo financeiro (faturas, pagamentos, MRR)
- [ ] Integrar geração de propostas com PDF automático
- [ ] Implementar notificações WhatsApp para marcos de projeto

### Sprint 6 (Jul 15–28)
- [ ] Design system oficial v1: tokens de cor, tipografia, componentes base
- [ ] Storybook para documentação de componentes
- [ ] Migrar todos os templates de landing page para o design system

### Sprint 7 (Ago 1–14)
- [ ] npa-gestao: dashboard de analytics (receita, projetos, pipeline)
- [ ] Integrar OpenAI para geração de proposta a partir de briefing
- [ ] Implementar automação de follow-up de propostas via e-mail/WhatsApp

### Sprint 8 (Ago 15–28)
- [ ] Criar suite de testes para npa-gestao (Vitest + Playwright)
- [ ] Implementar CI/CD completo: lint → test → build → preview → deploy
- [ ] Definir política de versionamento semântico para projetos internos

### Sprint 9 (Set 1–14)
- [ ] npa-gestao: módulo de contratos com assinatura digital (DocuSign ou similar)
- [ ] Implementar Sentry para monitoramento de erros em produção
- [ ] Criar runbook de incidentes

### Sprint 10 (Set 15–30)
- [ ] Lançar npa-gestao v1.0 em produção estável
- [ ] Documentação completa de API (Swagger/OpenAPI)
- [ ] Audit de segurança interno (OWASP Top 10)

---

## Fase 3 — Escala (Q4 2026)

**Objetivo:** Criar pacotes de serviço, aumentar automatização e preparar para crescimento.

### Sprint 11–12 (Out 2026)
- [ ] Lançar página de serviços com pacotes por segmento e preços públicos
- [ ] Criar landing page de vendas por segmento (ex: "Site para advogados")
- [ ] SEO técnico: sitemap, meta tags, structured data em todos os sites

### Sprint 13–14 (Nov 2026)
- [ ] Integrar IA para geração de conteúdo de landing pages (seções, copy, FAQ)
- [ ] Criar template de onboarding automático para novos clientes
- [ ] Avaliar viabilidade de SaaS do npa-gestao para outros microestúdios

### Sprint 15–16 (Dez 2026)
- [ ] Retrospectiva anual e planejamento de 2027
- [ ] Definir meta de headcount para Q1 2027
- [ ] Criar programa de parceria/indicação para clientes existentes

---

## Fase 4 — Expansão (Q1 2027)

**Objetivo:** Novos segmentos, time e posicionamento de mercado.

### Sprint 17–18 (Jan 2027)
- [ ] Expandir para segmentos: educação, imobiliário, clínicas médicas
- [ ] Contratar primeiro colaborador (dev ou designer)
- [ ] Criar processo de onboarding de colaboradores

### Sprint 19–20 (Fev–Mar 2027)
- [ ] Lançar produto SaaS (se viabilidade confirmada em Q4 2026)
- [ ] Meta: 25 projetos cliente ativos
- [ ] Meta: R$ XX.000 de MRR (a definir com dados reais)

---

## Dependências Críticas do Roadmap

| Item | Depende de | Risco |
|---|---|---|
| npa-gestao financeiro | Schema de banco validado | Médio |
| Design system | Acesso ao Figma (token) | Médio |
| Contratos digitais | Definição de fornecedor (DocuSign/ZapSign) | Baixo |
| SaaS npa-gestao | npa-gestao v1.0 estável | Alto |
| Expansão de time | Receita suficiente (Q3 2026) | Alto |

---

*Roadmap sujeito a revisão quinzenal. Atualizar após cada sprint com status real.*
