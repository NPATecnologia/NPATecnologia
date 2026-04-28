# ISSUE-013 — Sales: Pipeline de Vendas no NPA Gestão

**Título:** Implementar Kanban de pipeline de vendas no npa-gestao  
**Labels:** `product`, `sales`, `frontend`, `npa-gestao`  
**Estimativa:** L (até 80h)  
**Responsável Sugerido:** Nathan  
**Criado em:** 2026-04-28  

---

## Contexto

A NPA Tecnologia capta leads via GitHub profile, npatecnologia.com.br e indicações. Atualmente não há sistema para rastrear o status de cada oportunidade desde o primeiro contato até o contrato assinado. Isso causa:
- Perda de leads por falta de follow-up
- Dificuldade de prever receita futura
- Impossibilidade de medir taxa de conversão

---

## Problema

Pipeline de vendas inexistente ou gerenciado manualmente, causando perda de oportunidades.

---

## Passos de Execução

### 1. Criar tabela de pipeline

```sql
CREATE TABLE pipeline_cards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id uuid REFERENCES clients(id),
  title varchar(300) NOT NULL,
  stage varchar(50) NOT NULL DEFAULT 'lead'
    CHECK (stage IN ('lead','contato','proposta','negociacao','contrato','entregue','perdido')),
  segment varchar(50),
  estimated_value numeric(10,2),
  contact_name varchar(200),
  contact_phone varchar(20),
  contact_email varchar(200),
  source varchar(100), -- github, site, indicacao, whatsapp
  notes text,
  next_action text,
  next_action_date date,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz,
  lost_reason text,
  won_at timestamptz
);

CREATE INDEX idx_pipeline_stage ON pipeline_cards(stage);
```

### 2. Criar UI Kanban

```tsx
// app/pipeline/page.tsx
const STAGES = [
  { key: "lead", label: "Lead", color: "gray" },
  { key: "contato", label: "Contato Feito", color: "blue" },
  { key: "proposta", label: "Proposta Enviada", color: "purple" },
  { key: "negociacao", label: "Em Negociação", color: "orange" },
  { key: "contrato", label: "Contrato Assinado", color: "green" },
  { key: "entregue", label: "Entregue", color: "emerald" },
  { key: "perdido", label: "Perdido", color: "red" },
];

// Drag and drop com @dnd-kit/core
// Card com: título, segmento, valor estimado, próxima ação, data
```

### 3. Métricas de pipeline

```sql
-- View de métricas
CREATE VIEW pipeline_metrics AS
SELECT
  stage,
  COUNT(*) as count,
  SUM(estimated_value) as total_value,
  AVG(estimated_value) as avg_value
FROM pipeline_cards
WHERE created_at > NOW() - INTERVAL '90 days'
GROUP BY stage;
```

### 4. Alertas de follow-up

```typescript
// Cron job (Vercel Cron Functions) — diário às 08:00
// Lista cards com next_action_date = hoje e envia WhatsApp para Nathan
```

---

## Critérios de Aceite

- [ ] Tabela `pipeline_cards` criada com migration
- [ ] Kanban com 7 colunas funcionando
- [ ] Drag-and-drop entre colunas atualiza `stage` no banco
- [ ] Formulário para criar novo card de pipeline
- [ ] Métricas: contagem e valor total por estágio
- [ ] Filtro por segmento e período
- [ ] Alerta de follow-up para `next_action_date` = hoje
- [ ] Integrado com clientes existentes (via `client_id`)

---

## Wireframe (Texto)

```
[Lead (3)]  [Contato (5)]  [Proposta (4)]  [Negociação (2)]  [Contrato (1)]  [Perdido (2)]
┌──────────┐ ┌──────────┐   ┌──────────┐   ┌──────────┐     ┌──────────┐    ┌──────────┐
│Sirius    │ │Graxinha  │   │Red Garage│   │Studio XYZ│     │Fluari    │    │Lead 001  │
│Odonto    │ │Envelo.   │   │Landing   │   │Landing   │     │Odonto    │    │ R$ 3.000 │
│R$ 4.500  │ │R$ 6.000  │   │R$ 3.500  │   │R$ 5.000  │     │R$ 8.000  │    │Perdido:  │
│Ação: Call│ │→ Proposta│   │Aguardar  │   │Follow-up │     │Iniciar   │    │Preço     │
│Amanhã    │ │Hoje      │   │retorno   │   │2 dias    │     │design    │    │          │
└──────────┘ └──────────┘   └──────────┘   └──────────┘     └──────────┘    └──────────┘
```
