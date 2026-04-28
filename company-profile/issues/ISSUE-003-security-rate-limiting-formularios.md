# ISSUE-003 — Security: Rate Limiting em Formulários Públicos

**Título:** Implementar rate limiting e CAPTCHA em todos os formulários de contato  
**Labels:** `security`, `backend`, `alta-prioridade`  
**Estimativa:** S (até 8h)  
**Responsável Sugerido:** Nathan (Backend)  
**Criado em:** 2026-04-28  

---

## Contexto

Todos os sites cliente possuem formulário de contato que envia para `/api/contact`. Atualmente esses endpoints não têm proteção contra:
- **Flood/spam**: bots podem enviar centenas de requisições por segundo
- **Scraping de contatos**: respostas podem vazar dados de outros leads
- **Abuso de APIs de IA**: se o formulário aciona geração de conteúdo, custo pode explodir

---

## Problema

Endpoint `/api/contact` sem rate limiting = porta aberta para abuso. Impacto: caixa de entrada do cliente inundada, custo de API, reputação de IP comprometida.

---

## Passos de Execução

### Passo 1 — Rate Limiting com Upstash Redis
```typescript
// middleware.ts ou api/contact/route.ts
import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(5, "1 m"), // 5 req/min por IP
  analytics: true,
});

export async function POST(request: Request) {
  const ip = request.headers.get("x-forwarded-for") ?? "127.0.0.1";
  const { success, remaining } = await ratelimit.limit(ip);

  if (!success) {
    return Response.json(
      { error: "Muitas tentativas. Aguarde alguns minutos." },
      { status: 429, headers: { "Retry-After": "60" } }
    );
  }
  // continua processamento
}
```

### Passo 2 — CAPTCHA com Cloudflare Turnstile
```typescript
// Verificação server-side
async function validateTurnstile(token: string): Promise<boolean> {
  const res = await fetch(
    "https://challenges.cloudflare.com/turnstile/v0/siteverify",
    {
      method: "POST",
      body: JSON.stringify({
        secret: process.env.TURNSTILE_SECRET_KEY,
        response: token,
      }),
      headers: { "Content-Type": "application/json" },
    }
  );
  const data = await res.json();
  return data.success === true;
}
```

### Passo 3 — Adicionar variáveis de ambiente
```
TURNSTILE_SECRET_KEY=... (Vercel Env)
UPSTASH_REDIS_REST_URL=... (Vercel Env)
UPSTASH_REDIS_REST_TOKEN=... (Vercel Env)
```

### Passo 4 — Testar com bombardeio de requests
```bash
# Teste manual de rate limiting
for i in {1..10}; do
  curl -X POST https://site.vercel.app/api/contact \
    -H "Content-Type: application/json" \
    -d '{"name":"test","email":"t@t.com","message":"test"}'
  sleep 0.1
done
# A partir da 6ª request deve retornar 429
```

---

## Critérios de Aceite

- [ ] Rate limit de 5 req/min por IP em todos os endpoints `/api/contact`
- [ ] Resposta 429 com `Retry-After` header após limite excedido
- [ ] CAPTCHA Turnstile validado server-side (não apenas client-side)
- [ ] Log de tentativas bloqueadas (sem dados pessoais)
- [ ] Teste de carga executado e documentado
- [ ] Env vars configuradas no Vercel sem exposição de valores

---

## Variáveis de Ambiente Necessárias

| Variável | Provedor | Sensibilidade |
|---|---|---|
| `TURNSTILE_SECRET_KEY` | Cloudflare | Alta — nunca expor |
| `UPSTASH_REDIS_REST_URL` | Upstash | Média |
| `UPSTASH_REDIS_REST_TOKEN` | Upstash | Alta |
