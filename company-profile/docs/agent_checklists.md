# Checklists de Agentes Especializados — NPA Tecnologia

**Versão:** 1.0  
**Data:** 2026-04-28  

---

## Instruções

Cada agente abaixo possui:
- **10 tarefas mensuráveis** com critério claro de conclusão
- **2 a 4 issues iniciais** referenciando os arquivos em `issues/`

---

## 1. Agente: Product

**Responsabilidade:** Definir roadmap, priorizar backlog, mapear funcionalidades e KPIs.

### Checklist
- [ ] 1. Definir visão de produto do npa-gestao em 1 parágrafo claro
- [ ] 2. Priorizar top 10 itens do backlog com justificativa de negócio
- [ ] 3. Criar mapa de jornada do usuário (Nathan usando o npa-gestao)
- [ ] 4. Definir OKRs para Q3 2026 (3 objetivos, 2-3 resultados-chave cada)
- [ ] 5. Documentar o produto "marq" — o que é, para quem, status
- [ ] 6. Criar critérios de aceite para o MVP do npa-gestao
- [ ] 7. Definir métricas de sucesso do produto (DAU, retention, CSAT)
- [ ] 8. Mapear user stories para o módulo de propostas
- [ ] 9. Validar roadmap com stakeholders (Nathan) a cada sprint
- [ ] 10. Criar release notes para cada versão do npa-gestao

### Issues Iniciais
- `ISSUE-006` — Backend: CRUD de Clientes no NPA Gestão
- `ISSUE-013` — Sales: Pipeline de Vendas no NPA Gestão
- `ISSUE-017` — Product: Geração de Proposta em PDF
- `ISSUE-029` — Descoberta do projeto Marq (no backlog PB-029)

---

## 2. Agente: UX

**Responsabilidade:** Garantir usabilidade, acessibilidade e consistência visual entre projetos.

### Checklist
- [ ] 1. Criar design tokens oficiais (cores, tipografia, espaçamento) — ver ISSUE-011
- [ ] 2. Mapear fluxos de usuário para os 5 segmentos principais
- [ ] 3. Auditar acessibilidade (WCAG 2.1 AA) em 5 sites cliente prioritários
- [ ] 4. Criar guia de uso do design system com exemplos por segmento
- [ ] 5. Definir padrão de animações (Framer Motion vs GSAP por tipo de interação)
- [ ] 6. Criar template de wireframe por tipo de seção (hero, serviços, contato)
- [ ] 7. Auditar consistência de cores e tipografia entre todos os 15 sites
- [ ] 8. Criar checklist de UX para review antes de deploy
- [ ] 9. Definir padrão de responsividade mobile-first
- [ ] 10. Documentar componentes no Storybook com estados de interação

### Issues Iniciais
- `ISSUE-011` — UX: Definir Design Tokens Oficiais
- `ISSUE-007` — Frontend: Biblioteca de Componentes v1

---

## 3. Agente: Backend

**Responsabilidade:** APIs, banco de dados, segurança de dados e integrações server-side.

### Checklist
- [ ] 1. Implementar CRUD de clientes com API REST + validação Zod
- [ ] 2. Criar schema de banco de dados com migrations versionadas
- [ ] 3. Implementar autenticação Supabase Auth com middleware Next.js
- [ ] 4. Configurar rate limiting em todos os endpoints públicos
- [ ] 5. Implementar audit log para alterações em entidades críticas
- [ ] 6. Criar documentação OpenAPI para /api/v1
- [ ] 7. Implementar soft delete em todas as entidades
- [ ] 8. Criar job de backup diário do banco de dados
- [ ] 9. Implementar campo LGPD em tabela de contacts
- [ ] 10. Criar endpoint de geração de proposta em PDF

### Issues Iniciais
- `ISSUE-003` — Security: Rate Limiting em Formulários
- `ISSUE-006` — Backend: CRUD de Clientes
- `ISSUE-014` — DevOps: Backups Automáticos
- `ISSUE-017` — Product: Geração de Proposta em PDF

---

## 4. Agente: Frontend

**Responsabilidade:** UI, performance, SEO e componentes React/Next.js.

### Checklist
- [ ] 1. Implementar biblioteca de componentes reutilizáveis v1 (7 componentes)
- [ ] 2. Configurar Storybook com documentação de cada componente
- [ ] 3. Implementar SEO técnico em todos os 15 sites (meta tags, OG, sitemap)
- [ ] 4. Auditar Core Web Vitals (LCP, CLS, FID) em todos os sites
- [ ] 5. Implementar dark mode no npa-gestao e npa-notas
- [ ] 6. Criar template de layout por segmento (advocacia, gastro, beauty, etc.)
- [ ] 7. Implementar Lighthouse CI no pipeline de deploy
- [ ] 8. Configurar next/image para otimização automática de imagens
- [ ] 9. Implementar structured data (JSON-LD) por tipo de negócio
- [ ] 10. Criar página de erro 404 e 500 personalizadas por projeto

### Issues Iniciais
- `ISSUE-007` — Frontend: Biblioteca de Componentes v1
- `ISSUE-011` — UX: Design Tokens
- `ISSUE-015` — Frontend: SEO Técnico

---

## 5. Agente: DevOps

**Responsabilidade:** CI/CD, infraestrutura, monitoramento e deploys.

### Checklist
- [ ] 1. Padronizar pipeline de deploy (branch → PR → preview → prod) em todos os projetos
- [ ] 2. Configurar monitoramento de uptime para os 15 sites cliente
- [ ] 3. Implementar backups automáticos do banco de dados
- [ ] 4. Auditar e rotacionar credenciais de todos os projetos Vercel
- [ ] 5. Verificar certificados SSL em domínios próprios
- [ ] 6. Resolver/documentar projeto npa-gestao-deploy-temp
- [ ] 7. Configurar alertas de erros de deploy via e-mail/Slack/WhatsApp
- [ ] 8. Implementar GitHub Actions para testes automáticos em PRs
- [ ] 9. Criar runbook de incidentes (o que fazer quando um site cai)
- [ ] 10. Configurar Dependabot para alertas de dependências vulneráveis

### Issues Iniciais
- `ISSUE-004` — DevOps: npa-gestao-deploy-temp
- `ISSUE-008` — DevOps: SSL em Domínios Próprios
- `ISSUE-014` — DevOps: Backups Automáticos

---

## 6. Agente: Data

**Responsabilidade:** Modelagem de dados, analytics, relatórios e inventário.

### Checklist
- [ ] 1. Validar modelo de dados inferido contra schema real do Supabase
- [ ] 2. Criar views SQL para métricas de negócio (receita, pipeline, projetos)
- [ ] 3. Implementar dashboard de analytics no npa-gestao
- [ ] 4. Criar relatório mensal automatizado para clientes
- [ ] 5. Integrar Google Analytics 4 em todos os sites (com consentimento LGPD)
- [ ] 6. Criar índices de banco de dados para queries críticas
- [ ] 7. Implementar campo de categoria de dado (common/health/financial)
- [ ] 8. Criar job de exclusão de dados para compliance LGPD (policy de retenção)
- [ ] 9. Executar script de inventário de env vars e documentar resultado
- [ ] 10. Criar dashboard de uso de APIs de IA (tokens, custo por projeto)

### Issues Iniciais
- `ISSUE-010` — Security/Data: Inventário de Env Vars
- `ISSUE-018` — Data: Dashboard de Analytics

---

## 7. Agente: QA

**Responsabilidade:** Qualidade, testes, cobertura e critérios de aceite.

### Checklist
- [ ] 1. Configurar Vitest para testes unitários no npa-gestao
- [ ] 2. Configurar Playwright para testes E2E com 5 fluxos críticos
- [ ] 3. Definir cobertura mínima: 80% em funções críticas
- [ ] 4. Criar GitHub Action que barra merge se testes falharem
- [ ] 5. Criar checklist de QA pré-deploy por tipo de projeto
- [ ] 6. Executar testes manuais de formulários em todos os 15 sites
- [ ] 7. Testar responsividade em mobile (iOS Safari, Android Chrome)
- [ ] 8. Auditar performance com Lighthouse em todos os sites (score > 80)
- [ ] 9. Criar template de relatório de bug com reprodução passo a passo
- [ ] 10. Implementar testes de contrato para APIs externas (WhatsApp, OpenAI)

### Issues Iniciais
- `ISSUE-009` — QA: Implementar Suite de Testes no NPA Gestão

---

## 8. Agente: Security

**Responsabilidade:** Segurança de aplicações, credenciais, OWASP e proteção de dados.

### Checklist
- [ ] 1. Executar auditoria OWASP Top 10 no npa-gestao
- [ ] 2. Implementar rate limiting em todos os endpoints públicos
- [ ] 3. Auditar todos os env vars e identificar rotação necessária
- [ ] 4. Verificar que nenhuma chave de API está exposta em código-fonte/commits
- [ ] 5. Implementar headers de segurança HTTP (HSTS, CSP, X-Frame-Options)
- [ ] 6. Configurar CAPTCHA (Turnstile) em todos os formulários públicos
- [ ] 7. Implementar validação HMAC no webhook WhatsApp
- [ ] 8. Criar processo de resposta a incidentes de segurança
- [ ] 9. Executar `npm audit` e corrigir vulns críticas e altas
- [ ] 10. Configurar Dependabot para alertas automáticos de vulnerabilidades

### Issues Iniciais
- `ISSUE-003` — Security: Rate Limiting e CAPTCHA
- `ISSUE-010` — Security: Inventário de Env Vars
- `ISSUE-016` — Security: Auditoria OWASP Top 10

---

## 9. Agente: Legal/LGPD

**Responsabilidade:** Conformidade com LGPD, contratos, propriedade intelectual.

### Checklist
- [ ] 1. Implementar política de privacidade em todos os 15 sites cliente
- [ ] 2. Adicionar consentimento explícito para dados de saúde (odontologia, nutrição)
- [ ] 3. Elaborar RIPD para os 3 segmentos de dados sensíveis
- [ ] 4. Criar template de contrato padrão com cláusula de IP e LGPD
- [ ] 5. Nomear encarregado de dados (DPO) ou designar e-mail de contato
- [ ] 6. Criar política de retenção de dados por tipo e finalidade
- [ ] 7. Implementar banner de cookies em todos os sites
- [ ] 8. Criar processo de atendimento a solicitações do Art. 18 (titular)
- [ ] 9. Verificar CNPJ e regime tributário da NPA Tecnologia
- [ ] 10. Registrar marca "NPA Tecnologia" no INPI (avaliar)

### Issues Iniciais
- `ISSUE-001` — LGPD: Política de Privacidade em Advocacia
- `ISSUE-002` — LGPD: Dados Sensíveis de Saúde
- `ISSUE-019` — Legal: Contrato Padrão

---

## 10. Agente: Sales

**Responsabilidade:** Funil de vendas, propostas, CRM e crescimento de receita.

### Checklist
- [ ] 1. Implementar pipeline de vendas Kanban no npa-gestao
- [ ] 2. Criar template de proposta por segmento vertical
- [ ] 3. Definir ICP (Ideal Customer Profile) formal com dados reais
- [ ] 4. Configurar follow-up automático de propostas enviadas
- [ ] 5. Criar página de preços ou pacotes de serviço no site institucional
- [ ] 6. Definir SLA de resposta para novos leads (meta: < 2 horas)
- [ ] 7. Implementar tracking de origem de leads (GitHub, site, indicação)
- [ ] 8. Criar programa de indicação com benefício para clientes existentes
- [ ] 9. Auditar e atualizar portfólio público com todos os cases
- [ ] 10. Definir meta de receita para Q3 2026 e breakdown por segmento

### Issues Iniciais
- `ISSUE-013` — Sales: Pipeline de Vendas
- `ISSUE-017` — Product: Geração de Proposta em PDF
- `ISSUE-005` — Product: Portfólio de Odontologia

---

## 11. Agente: Integration

**Responsabilidade:** APIs externas, automações e integrações de IA.

### Checklist
- [ ] 1. Implementar notificação de leads via WhatsApp Business API
- [ ] 2. Criar endpoint de geração de copy via Claude/OpenAI a partir de briefing
- [ ] 3. Integrar validação CAPTCHA Turnstile em todos os formulários
- [ ] 4. Configurar webhook WhatsApp com validação HMAC
- [ ] 5. Implementar integração com sistema de agendamento (Calendly ou Cal.com)
- [ ] 6. Criar monitoramento de custo de APIs de IA por projeto
- [ ] 7. Implementar fallback entre providers de IA (Claude → GPT-4o → Gemini)
- [ ] 8. Integrar Google Analytics 4 com consentimento LGPD
- [ ] 9. Criar integração de e-mail transacional (Resend ou Postmark)
- [ ] 10. Documentar todas as integrações externas com limites de rate e custo

### Issues Iniciais
- `ISSUE-012` — Integration: WhatsApp Bot para Leads
- `ISSUE-020` — Integration: IA para Geração de Copy

---

*Checklists de agentes gerados com base no mapeamento da NPA Tecnologia. Revisar e adaptar conforme roadmap real.*
