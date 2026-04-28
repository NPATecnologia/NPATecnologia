# Inventário de APIs — NPA Tecnologia

**Versão:** 1.0  
**Data:** 2026-04-28  
**Status:** Inferido (sem acesso ao código-fonte dos repositórios privados)  
**Suposição:** Projetos Next.js com App Router usam Route Handlers (`/app/api/`) como endpoints.  

---

## Aviso

Os endpoints abaixo são **inferidos** com base na stack (Next.js, Supabase, OpenAI, WhatsApp API) e nos padrões típicos do segmento. Os endpoints reais devem ser validados contra o código-fonte dos repositórios privados.

---

## 1. APIs Internas — NPA Gestão (`npa-gestao`)

### 1.1 Clientes

| Método | Endpoint | Descrição | Auth |
|---|---|---|---|
| `GET` | `/api/v1/clients` | Listar todos os clientes | Bearer Token |
| `POST` | `/api/v1/clients` | Criar novo cliente | Bearer Token |
| `GET` | `/api/v1/clients/:id` | Detalhar cliente | Bearer Token |
| `PUT` | `/api/v1/clients/:id` | Atualizar cliente | Bearer Token |
| `DELETE` | `/api/v1/clients/:id` | Remover cliente (soft delete) | Bearer Token |

### 1.2 Projetos

| Método | Endpoint | Descrição | Auth |
|---|---|---|---|
| `GET` | `/api/v1/projects` | Listar projetos com filtros | Bearer Token |
| `POST` | `/api/v1/projects` | Criar projeto vinculado a cliente | Bearer Token |
| `GET` | `/api/v1/projects/:id` | Detalhar projeto | Bearer Token |
| `PUT` | `/api/v1/projects/:id` | Atualizar status/campos | Bearer Token |
| `POST` | `/api/v1/projects/:id/milestone` | Adicionar milestone | Bearer Token |

### 1.3 Propostas

| Método | Endpoint | Descrição | Auth |
|---|---|---|---|
| `GET` | `/api/v1/proposals` | Listar propostas | Bearer Token |
| `POST` | `/api/v1/proposals` | Criar nova proposta | Bearer Token |
| `GET` | `/api/v1/proposals/:id` | Detalhar proposta | Bearer Token |
| `PUT` | `/api/v1/proposals/:id/status` | Atualizar status (draft/sent/accepted/rejected) | Bearer Token |

**Exemplo de payload — `POST /api/v1/proposals`:**
```json
{
  "client_id": "uuid-do-cliente",
  "title": "Landing Page Premium — Consultório Odontológico",
  "segment": "odontologia",
  "services": [
    {
      "name": "Landing Page",
      "description": "Página institucional responsiva com animações",
      "price": 4500.00
    },
    {
      "name": "Integração WhatsApp",
      "description": "Botão de contato + automação de resposta",
      "price": 800.00
    }
  ],
  "total": 5300.00,
  "currency": "BRL",
  "valid_until": "2026-05-28",
  "payment_terms": "50% antecipado, 50% na entrega",
  "notes": "Prazo estimado: 12 dias úteis"
}
```

**Resposta esperada (201 Created):**
```json
{
  "id": "prop_xxxxxxxxxxxxxxxx",
  "status": "draft",
  "created_at": "2026-04-28T14:00:00Z",
  "client_id": "uuid-do-cliente",
  "title": "Landing Page Premium — Consultório Odontológico",
  "total": 5300.00,
  "currency": "BRL",
  "valid_until": "2026-05-28",
  "url": "https://npa-gestao.vercel.app/proposals/prop_xxx"
}
```

### 1.4 Financeiro

| Método | Endpoint | Descrição | Auth |
|---|---|---|---|
| `GET` | `/api/v1/invoices` | Listar faturas | Bearer Token |
| `POST` | `/api/v1/invoices` | Emitir fatura | Bearer Token |
| `PUT` | `/api/v1/invoices/:id/pay` | Marcar como pago | Bearer Token |
| `GET` | `/api/v1/dashboard/revenue` | Receita consolidada | Bearer Token |

---

## 2. APIs de Integração — Projetos Cliente

### 2.1 Formulário de Contato (Landing Pages)

| Método | Endpoint | Descrição | Auth |
|---|---|---|---|
| `POST` | `/api/contact` | Envio de formulário de contato | Nenhuma (público) |

**Payload típico:**
```json
{
  "name": "João Silva",
  "email": "joao@email.com",
  "phone": "+5511999999999",
  "message": "Gostaria de um orçamento",
  "source": "landing_page_hero"
}
```

**Riscos:**
- Sem rate limiting → suscetível a spam/flood
- Sem validação de CAPTCHA
- Dados de contato armazenados sem política de retenção clara (risco LGPD)

### 2.2 WhatsApp API

| Método | Endpoint | Descrição | Auth |
|---|---|---|---|
| `POST` | `/api/whatsapp/webhook` | Receber mensagens do WhatsApp | Verificação de token |
| `POST` | `/api/whatsapp/send` | Enviar mensagem | Bearer Token interno |

**Riscos:**
- Token de verificação do webhook deve ser rotacionado
- Payload do webhook deve ser validado (hash HMAC)

### 2.3 IA — Geração de Conteúdo

| Método | Endpoint | Descrição | Auth |
|---|---|---|---|
| `POST` | `/api/ai/generate` | Gerar texto via OpenAI/Claude/Gemini | Bearer Token interno |
| `POST` | `/api/ai/chat` | Chat com contexto do cliente | Bearer Token interno |

**Payload:**
```json
{
  "model": "claude-sonnet-4-6",
  "prompt": "Gere uma bio profissional para advogada tributarista",
  "context": {
    "segment": "advocacia",
    "client": "Samara Galli"
  },
  "max_tokens": 500
}
```

**Riscos:**
- Custo descontrolado se sem limite de tokens por requisição
- Prompt injection se input do usuário não for sanitizado
- API keys expostas em client-side code (verificar)

---

## 3. APIs Externas Consumidas

| API | Provider | Uso | Localização de Credencial |
|---|---|---|---|
| Chat Completions | OpenAI | Geração de conteúdo, chatbots | Env var `OPENAI_API_KEY` |
| Messages API | Anthropic (Claude) | Análise e geração | Env var `ANTHROPIC_API_KEY` |
| Generative AI | Google Gemini | Alternativa/multimodal | Env var `GOOGLE_API_KEY` |
| WhatsApp Cloud API | Meta | Automação de mensagens | Env var `WHATSAPP_TOKEN` |
| Supabase REST | Supabase | CRUD banco de dados | Env var `SUPABASE_URL` + `SUPABASE_ANON_KEY` |
| Supabase Auth | Supabase | Autenticação | Env var `SUPABASE_JWT_SECRET` |
| Vercel | Vercel | Deploy e edge functions | `VERCEL_TOKEN` (CI) |

---

## 4. Autenticação

### Padrão Detectado (Inferido)
- **Supabase Auth** para projetos internos (npa-gestao, npa-notas)
- **JWT** gerado pelo Supabase, validado via middleware Next.js
- **API keys** para integrações de IA (armazenadas em Vercel Env Vars)
- **Bearer Token** para APIs internas

### Fluxo de Autenticação (Supabase Auth)
```
1. Usuário faz login → POST /auth/v1/token (Supabase)
2. Supabase retorna access_token (JWT) + refresh_token
3. Next.js middleware valida JWT em cada request protegida
4. Refresh automático via Supabase Auth helpers
```

---

## 5. Lacunas de Documentação

| Lacuna | Impacto | Ação Recomendada |
|---|---|---|
| Endpoints reais não validados | Alto | Auditar código-fonte dos repos privados |
| Rate limiting não documentado | Alto | Implementar e documentar limites |
| Versionamento de API | Médio | Definir política de versioning (/v1, /v2) |
| Documentação OpenAPI/Swagger | Alto | Gerar spec Swagger para npa-gestao |
| Testes de contrato de API | Alto | Implementar com Vitest ou Jest |
| Monitoramento de erros API | Médio | Integrar Sentry ou LogRocket |
| SLAs de disponibilidade | Baixo | Definir uptime targets por endpoint |

---

## 6. Riscos de Segurança nas APIs

| Risco | Severidade | Mitigação |
|---|---|---|
| CAPTCHA ausente em formulários públicos | Alta | Implementar Turnstile (Cloudflare) ou reCAPTCHA |
| Sem rate limiting explícito | Alta | Vercel Edge Middleware + upstash/ratelimit |
| API keys potencialmente em client bundle | Crítica | Auditar bundle com `next build --debug` |
| CORS não verificado | Média | Definir `Access-Control-Allow-Origin` explícito |
| Sem sanitização de input em prompts de IA | Alta | Validar e sanitizar antes de chamar APIs de IA |
| Webhook WhatsApp sem validação HMAC | Alta | Implementar verificação de assinatura |

---

*Inventário de API inferido. Executar `scan_apis.sh` em cada repositório privado para validar endpoints reais.*
