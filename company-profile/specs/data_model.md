# Modelo de Dados — NPA Tecnologia

**Versão:** 1.0  
**Data:** 2026-04-28  
**Status:** Inferido (sem acesso ao schema real do Supabase)  
**Banco:** PostgreSQL via Supabase  

---

## Aviso

Modelo inferido a partir da stack (Supabase + Prisma) e dos projetos identificados (npa-gestao, npa-notas). Os schemas reais devem ser obtidos via `supabase db pull` ou `prisma db pull` nos repositórios privados.

**Comando para obter schema real:**
```bash
# Via Supabase CLI
supabase db pull --schema public

# Via Prisma (se configurado)
npx prisma db pull
```

---

## 1. Entidades Principais

### 1.1 `clients` — Clientes da NPA

| Campo | Tipo | Restrições | Descrição |
|---|---|---|---|
| `id` | `uuid` | PK, default gen_random_uuid() | Identificador único |
| `name` | `varchar(200)` | NOT NULL | Nome da empresa/pessoa |
| `segment` | `varchar(50)` | NOT NULL | advocacia, gastronomia, beauty, automotivo, saude, odontologia |
| `email` | `varchar(200)` | UNIQUE | E-mail principal |
| `phone` | `varchar(20)` | | Telefone/WhatsApp |
| `website` | `varchar(200)` | | URL do site entregue |
| `vercel_project_id` | `varchar(100)` | | ID do projeto Vercel |
| `status` | `varchar(20)` | default 'active' | active, inactive, churned |
| `notes` | `text` | | Observações gerais |
| `created_at` | `timestamptz` | default now() | Data de cadastro |
| `updated_at` | `timestamptz` | | Última atualização |

### 1.2 `projects` — Projetos Entregues

| Campo | Tipo | Restrições | Descrição |
|---|---|---|---|
| `id` | `uuid` | PK | Identificador |
| `client_id` | `uuid` | FK → clients.id | Cliente proprietário |
| `name` | `varchar(200)` | NOT NULL | Nome do projeto |
| `type` | `varchar(50)` | NOT NULL | landing_page, web_app, automation, integration |
| `status` | `varchar(30)` | NOT NULL | briefing, design, development, review, delivered, maintenance |
| `start_date` | `date` | | Data de início |
| `delivery_date` | `date` | | Data de entrega real |
| `estimated_days` | `int` | | Prazo estimado em dias úteis |
| `repo_url` | `varchar(300)` | | URL do repositório GitHub |
| `deploy_url` | `varchar(300)` | | URL em produção |
| `stack` | `jsonb` | | Array de tecnologias usadas |
| `total_value` | `numeric(10,2)` | | Valor total do projeto |
| `created_at` | `timestamptz` | default now() | |
| `updated_at` | `timestamptz` | | |

### 1.3 `proposals` — Propostas Comerciais

| Campo | Tipo | Restrições | Descrição |
|---|---|---|---|
| `id` | `uuid` | PK | Identificador |
| `client_id` | `uuid` | FK → clients.id | Cliente alvo |
| `project_id` | `uuid` | FK → projects.id | Projeto vinculado (após aceite) |
| `title` | `varchar(300)` | NOT NULL | Título da proposta |
| `status` | `varchar(20)` | NOT NULL | draft, sent, accepted, rejected, expired |
| `services` | `jsonb` | NOT NULL | Array de serviços e valores |
| `total` | `numeric(10,2)` | NOT NULL | Valor total |
| `currency` | `char(3)` | default 'BRL' | Moeda |
| `valid_until` | `date` | | Validade da proposta |
| `payment_terms` | `text` | | Condições de pagamento |
| `notes` | `text` | | Observações |
| `sent_at` | `timestamptz` | | Quando foi enviada |
| `accepted_at` | `timestamptz` | | Quando foi aceita |
| `created_at` | `timestamptz` | default now() | |

### 1.4 `invoices` — Faturas

| Campo | Tipo | Restrições | Descrição |
|---|---|---|---|
| `id` | `uuid` | PK | Identificador |
| `project_id` | `uuid` | FK → projects.id | Projeto faturado |
| `client_id` | `uuid` | FK → clients.id | Cliente faturado |
| `amount` | `numeric(10,2)` | NOT NULL | Valor da parcela |
| `type` | `varchar(20)` | NOT NULL | advance (50% antecipado), final (50% entrega) |
| `status` | `varchar(20)` | NOT NULL | pending, paid, overdue |
| `due_date` | `date` | NOT NULL | Vencimento |
| `paid_at` | `timestamptz` | | Data de pagamento |
| `payment_method` | `varchar(50)` | | pix, transfer, boleto |
| `notes` | `text` | | |
| `created_at` | `timestamptz` | default now() | |

### 1.5 `notes` — Notas Internas (npa-notas)

| Campo | Tipo | Restrições | Descrição |
|---|---|---|---|
| `id` | `uuid` | PK | Identificador |
| `user_id` | `uuid` | FK → auth.users.id | Autor (Supabase Auth) |
| `title` | `varchar(300)` | NOT NULL | Título da nota |
| `content` | `text` | NOT NULL | Corpo da nota (Markdown) |
| `tags` | `text[]` | | Array de tags |
| `is_pinned` | `boolean` | default false | Fixada |
| `project_id` | `uuid` | FK → projects.id | Nota vinculada a projeto (opcional) |
| `created_at` | `timestamptz` | default now() | |
| `updated_at` | `timestamptz` | | |

### 1.6 `contacts` — Contatos de Sites Cliente

| Campo | Tipo | Restrições | Descrição |
|---|---|---|---|
| `id` | `uuid` | PK | Identificador |
| `project_id` | `uuid` | FK → projects.id | Projeto de origem |
| `name` | `varchar(200)` | NOT NULL | Nome do contato |
| `email` | `varchar(200)` | | E-mail |
| `phone` | `varchar(20)` | | Telefone |
| `message` | `text` | | Mensagem enviada |
| `source` | `varchar(100)` | | Seção/CTA de origem |
| `status` | `varchar(20)` | default 'new' | new, contacted, converted, dismissed |
| `created_at` | `timestamptz` | default now() | |

### 1.7 `milestones` — Marcos de Projeto

| Campo | Tipo | Restrições | Descrição |
|---|---|---|---|
| `id` | `uuid` | PK | Identificador |
| `project_id` | `uuid` | FK → projects.id | Projeto pai |
| `name` | `varchar(200)` | NOT NULL | Nome do marco |
| `description` | `text` | | Descrição |
| `status` | `varchar(20)` | default 'pending' | pending, in_progress, completed |
| `due_date` | `date` | | Prazo |
| `completed_at` | `timestamptz` | | Quando foi concluído |
| `created_at` | `timestamptz` | default now() | |

---

## 2. Relacionamentos

```
clients (1) ──────────── (N) projects
clients (1) ──────────── (N) proposals
clients (1) ──────────── (N) invoices
projects (1) ─────────── (N) milestones
projects (1) ─────────── (N) notes
projects (1) ─────────── (N) contacts
projects (1) ─────────── (N) invoices
proposals (1) ────────── (0..1) projects [após aceite]
auth.users (1) ─────── (N) notes
```

---

## 3. Índices Recomendados

```sql
-- Clientes
CREATE INDEX idx_clients_segment ON clients(segment);
CREATE INDEX idx_clients_status ON clients(status);

-- Projetos
CREATE INDEX idx_projects_client_id ON projects(client_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_delivery_date ON projects(delivery_date);

-- Propostas
CREATE INDEX idx_proposals_client_id ON proposals(client_id);
CREATE INDEX idx_proposals_status ON proposals(status);

-- Faturas
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_due_date ON invoices(due_date);

-- Contatos
CREATE INDEX idx_contacts_project_id ON contacts(project_id);
CREATE INDEX idx_contacts_status ON contacts(status);
```

---

## 4. Script SQL — Migração de Exemplo

```sql
-- Exemplo: renomear campo 'notes' para 'observations' na tabela clients
BEGIN;

-- 1. Adicionar nova coluna
ALTER TABLE clients ADD COLUMN observations text;

-- 2. Copiar dados
UPDATE clients SET observations = notes WHERE notes IS NOT NULL;

-- 3. Remover coluna antiga (após validação)
-- ALTER TABLE clients DROP COLUMN notes;

-- 4. Adicionar comentário de documentação
COMMENT ON COLUMN clients.observations IS 'Observações gerais sobre o cliente';

COMMIT;

-- Rollback se necessário:
-- BEGIN;
-- ALTER TABLE clients ADD COLUMN notes text;
-- UPDATE clients SET notes = observations;
-- ALTER TABLE clients DROP COLUMN observations;
-- COMMIT;
```

---

## 5. Riscos de Modelagem

| Risco | Severidade | Ação |
|---|---|---|
| `contacts` sem consentimento LGPD registrado | Crítico | Adicionar campos `lgpd_consent` e `lgpd_consent_at` |
| `projects.stack` como `jsonb` sem schema fixo | Médio | Criar enum ou tabela de tecnologias |
| Sem soft delete em todas as entidades | Médio | Adicionar `deleted_at` + índice parcial |
| `invoices` sem referência a proposta | Baixo | Adicionar FK `proposal_id` em invoices |
| Sem auditoria de alterações (audit log) | Alto | Implementar tabela `audit_log` ou usar pg_audit |
| `notes.content` sem limite de tamanho | Baixo | Definir limite de 100KB via aplicação |

---

## 6. Campos LGPD a Adicionar (Urgente)

```sql
-- Em todas as tabelas que armazenam dados pessoais:
ALTER TABLE contacts ADD COLUMN lgpd_consent boolean NOT NULL DEFAULT false;
ALTER TABLE contacts ADD COLUMN lgpd_consent_at timestamptz;
ALTER TABLE contacts ADD COLUMN lgpd_consent_ip varchar(45);

-- Campo para solicitação de exclusão (Art. 18 LGPD):
ALTER TABLE contacts ADD COLUMN deletion_requested_at timestamptz;
ALTER TABLE contacts ADD COLUMN deletion_completed_at timestamptz;
```

---

*Modelo de dados inferido. Executar `supabase db pull` nos projetos privados para obter schema real e comparar.*
