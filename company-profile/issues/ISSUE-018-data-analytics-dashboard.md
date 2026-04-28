# ISSUE-018 — Data: Dashboard de Analytics no NPA Gestão

**Título:** Criar dashboard de métricas de negócio (receita, pipeline, projetos) no npa-gestao  
**Labels:** `data`, `product`, `frontend`, `npa-gestao`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan  
**Criado em:** 2026-04-28  

---

## Contexto

Sem visibilidade das métricas de negócio, é impossível tomar decisões baseadas em dados sobre crescimento, priorização e alocação de tempo. O npa-gestao deve ser a única fonte de verdade para KPIs operacionais e financeiros da NPA.

---

## Problema

Ausência de dashboard central para métricas de negócio = decisões baseadas em intuição.

---

## Passos de Execução

### 1. Criar views SQL para métricas

```sql
-- MRR por mês (receita recorrente mensal)
CREATE OR REPLACE VIEW monthly_revenue AS
SELECT
  DATE_TRUNC('month', paid_at) AS month,
  SUM(amount) AS revenue,
  COUNT(DISTINCT project_id) AS projects_paid
FROM invoices
WHERE status = 'paid' AND paid_at IS NOT NULL
GROUP BY 1
ORDER BY 1 DESC;

-- Projetos por status e segmento
CREATE OR REPLACE VIEW project_metrics AS
SELECT
  p.status,
  c.segment,
  COUNT(*) AS count,
  AVG(p.total_value) AS avg_value,
  SUM(p.total_value) AS total_value
FROM projects p
JOIN clients c ON p.client_id = c.id
GROUP BY p.status, c.segment;

-- Pipeline de vendas
CREATE OR REPLACE VIEW pipeline_summary AS
SELECT
  stage,
  COUNT(*) AS cards,
  SUM(estimated_value) AS total_estimated,
  AVG(estimated_value) AS avg_estimated
FROM pipeline_cards
WHERE created_at > NOW() - INTERVAL '90 days'
GROUP BY stage;
```

### 2. Criar API de métricas

```typescript
// app/api/v1/dashboard/route.ts
export async function GET() {
  const [revenue, projects, pipeline] = await Promise.all([
    supabase.from("monthly_revenue").select("*").limit(12),
    supabase.from("project_metrics").select("*"),
    supabase.from("pipeline_summary").select("*"),
  ]);

  return Response.json({
    revenue: revenue.data,
    projects: projects.data,
    pipeline: pipeline.data,
    generated_at: new Date().toISOString(),
  });
}
```

### 3. Criar componentes de gráfico

```typescript
// Usar Recharts (já popular no ecossistema React)
import {
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer
} from "recharts";

function RevenueChart({ data }: { data: MonthlyRevenue[] }) {
  return (
    <ResponsiveContainer width="100%" height={300}>
      <AreaChart data={data}>
        <defs>
          <linearGradient id="revenue" x1="0" y1="0" x2="0" y2="1">
            <stop offset="5%" stopColor="#7C3AED" stopOpacity={0.3} />
            <stop offset="95%" stopColor="#7C3AED" stopOpacity={0} />
          </linearGradient>
        </defs>
        <XAxis dataKey="month" tickFormatter={(v) => format(new Date(v), "MMM/yy", { locale: ptBR })} />
        <YAxis tickFormatter={(v) => `R$ ${(v / 1000).toFixed(0)}k`} />
        <Tooltip formatter={(v: number) => `R$ ${v.toLocaleString("pt-BR")}`} />
        <Area type="monotone" dataKey="revenue" stroke="#7C3AED" fill="url(#revenue)" />
      </AreaChart>
    </ResponsiveContainer>
  );
}
```

### 4. Cards de KPI

```typescript
function KpiCard({ label, value, trend, unit = "" }: KpiCardProps) {
  return (
    <div className="rounded-xl border border-gray-800 p-6 bg-gray-900">
      <p className="text-sm text-gray-400">{label}</p>
      <p className="mt-2 text-3xl font-bold text-white">
        {unit}{value.toLocaleString("pt-BR")}
      </p>
      <p className={`mt-1 text-sm ${trend > 0 ? "text-green-400" : "text-red-400"}`}>
        {trend > 0 ? "↑" : "↓"} {Math.abs(trend)}% vs mês anterior
      </p>
    </div>
  );
}
```

---

## Métricas do Dashboard

| Seção | Métricas |
|---|---|
| Visão Geral | MRR, Projetos ativos, Novos leads (30d), Taxa de conversão |
| Receita | Gráfico mensal 12m, Por segmento, Prevista vs Realizada |
| Pipeline | Cards por estágio, Valor total estimado, Velocidade de conversão |
| Projetos | Por status, Por segmento, Prazo médio de entrega |
| Clientes | Total, Novos (30d), Churn (90d), NPS (manual) |

---

## Critérios de Aceite

- [ ] Dashboard carrega em < 2s (com loading states)
- [ ] KPIs corretos (validados contra dados reais)
- [ ] Gráfico de receita mensal (12 meses)
- [ ] Pipeline de vendas com valor por estágio
- [ ] Filtro de período (7d, 30d, 90d, 12m)
- [ ] Dados atualizados em tempo real ou com refresh manual
- [ ] Mobile-responsive (gráficos redimensionados)
- [ ] Sem dados sensíveis de clientes visíveis no dashboard
