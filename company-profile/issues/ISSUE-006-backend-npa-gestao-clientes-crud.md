# ISSUE-006 — Backend: CRUD de Clientes no NPA Gestão

**Título:** Implementar CRUD completo de clientes com API e UI no npa-gestao  
**Labels:** `backend`, `product`, `npa-gestao`, `alta-prioridade`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan (Backend + Frontend)  
**Criado em:** 2026-04-28  

---

## Contexto

O `npa-gestao` é o sistema de gestão interna da NPA Tecnologia, criado em 2026-04-25. O cadastro de clientes é a funcionalidade mais fundamental do CRM e deve ser a primeira a ser implementada, pois todas as outras entidades (projetos, propostas, faturas) dependem dela.

---

## Problema

Sem cadastro de clientes, o npa-gestao não pode ser usado para gerenciar o portfólio atual de 15 clientes. A gestão continua sendo feita de forma manual (planilhas, WhatsApp), gerando risco operacional.

---

## Passos de Execução

### 1. Criar tabela no Supabase

```sql
CREATE TABLE clients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(200) NOT NULL,
  segment varchar(50) NOT NULL 
    CHECK (segment IN ('advocacia','gastronomia','beauty','automotivo','saude','odontologia','outro')),
  email varchar(200) UNIQUE,
  phone varchar(20),
  website varchar(200),
  vercel_project_id varchar(100),
  status varchar(20) NOT NULL DEFAULT 'active'
    CHECK (status IN ('active','inactive','churned')),
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz
);

CREATE INDEX idx_clients_segment ON clients(segment);
CREATE INDEX idx_clients_status ON clients(status);
```

### 2. Criar API Routes (Next.js App Router)

```
app/
  api/
    v1/
      clients/
        route.ts         → GET (list) + POST (create)
        [id]/
          route.ts       → GET (detail) + PUT (update) + DELETE (soft)
```

**GET /api/v1/clients:**
```typescript
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const segment = searchParams.get("segment");
  const status = searchParams.get("status") ?? "active";

  const query = supabase
    .from("clients")
    .select("*")
    .eq("status", status)
    .order("name");

  if (segment) query.eq("segment", segment);

  const { data, error } = await query;
  if (error) return Response.json({ error: error.message }, { status: 500 });
  return Response.json({ data, count: data.length });
}
```

### 3. Criar UI

- Página `/clientes` com tabela/cards por segmento
- Formulário de criação/edição com validação (React Hook Form + Zod)
- Filtro por segmento e status
- Search por nome

### 4. Validação com Zod

```typescript
import { z } from "zod";

export const clientSchema = z.object({
  name: z.string().min(2).max(200),
  segment: z.enum(['advocacia','gastronomia','beauty','automotivo','saude','odontologia','outro']),
  email: z.string().email().optional(),
  phone: z.string().max(20).optional(),
  website: z.string().url().optional().or(z.literal("")),
  vercel_project_id: z.string().optional(),
  notes: z.string().max(5000).optional(),
});
```

---

## Critérios de Aceite

- [ ] Tabela `clients` criada no Supabase com migration versionada
- [ ] `GET /api/v1/clients` retorna lista com filtros de segmento e status
- [ ] `POST /api/v1/clients` cria cliente com validação Zod
- [ ] `PUT /api/v1/clients/:id` atualiza campos (incluindo `updated_at`)
- [ ] `DELETE /api/v1/clients/:id` faz soft delete (adicionar `deleted_at`)
- [ ] UI com formulário funcional e tabela paginada
- [ ] Autenticação exigida (Supabase Auth middleware)
- [ ] Testes unitários para validação Zod
- [ ] Migration versionada e commited no repositório

---

## Dependências

- Supabase projeto configurado com connection string no `.env`
- Autenticação Supabase Auth configurada no npa-gestao
