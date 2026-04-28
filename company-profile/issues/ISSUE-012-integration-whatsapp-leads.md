# ISSUE-012 — Integration: WhatsApp Bot para Notificação de Leads

**Título:** Implementar envio automático de leads via WhatsApp após formulário de contato  
**Labels:** `integration`, `backend`, `whatsapp`, `produto`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan (Backend/Integration)  
**Criado em:** 2026-04-28  

---

## Contexto

Atualmente os leads captados pelos formulários de contato dos sites cliente são armazenados no banco de dados ou enviados por e-mail. O cliente (ex: advogada, nutricionista) pode demorar horas para ver o novo lead.

A NPA já usa WhatsApp Business API (mencionada no README). Integrar o envio automático de leads por WhatsApp aumenta significativamente a taxa de resposta ao lead (estudos mostram que responder em <5min aumenta conversão em 10x).

---

## Problema

Leads captados sem notificação imediata ao cliente = perda de conversão.

---

## Passos de Execução

### 1. Configurar WhatsApp Cloud API

```bash
# Env vars necessárias (Vercel)
WHATSAPP_API_TOKEN=...        # Bearer token da Meta API
WHATSAPP_PHONE_NUMBER_ID=...  # ID do número de negócios
WHATSAPP_VERIFY_TOKEN=...     # Token de verificação do webhook
```

### 2. Criar serviço de envio

```typescript
// lib/whatsapp.ts
interface LeadMessage {
  clientPhone: string;  // Número do cliente NPA (quem recebe o lead)
  leadName: string;
  leadPhone: string;
  leadMessage: string;
  projectName: string;
}

export async function sendLeadNotification(data: LeadMessage) {
  const message = `🔔 *Novo Lead — ${data.projectName}*

👤 Nome: ${data.leadName}
📱 Telefone: ${data.leadPhone}
💬 Mensagem: ${data.leadMessage}

Responda em até 5 minutos para maximizar a conversão!`;

  const response = await fetch(
    `https://graph.facebook.com/v18.0/${process.env.WHATSAPP_PHONE_NUMBER_ID}/messages`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${process.env.WHATSAPP_API_TOKEN}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        messaging_product: "whatsapp",
        to: data.clientPhone,
        type: "text",
        text: { body: message },
      }),
    }
  );

  if (!response.ok) {
    const err = await response.json();
    throw new Error(`WhatsApp API error: ${JSON.stringify(err)}`);
  }

  return response.json();
}
```

### 3. Integrar no handler do formulário

```typescript
// app/api/contact/route.ts
import { sendLeadNotification } from "@/lib/whatsapp";

export async function POST(request: Request) {
  const body = await request.json();
  
  // Salvar no banco
  const { data: contact } = await supabase
    .from("contacts")
    .insert({ ...body, project_id: PROJECT_ID })
    .select()
    .single();

  // Notificar via WhatsApp (sem bloquear resposta ao lead)
  sendLeadNotification({
    clientPhone: CLIENT_WHATSAPP_PHONE,
    leadName: body.name,
    leadPhone: body.phone,
    leadMessage: body.message,
    projectName: PROJECT_NAME,
  }).catch((err) => console.error("WhatsApp notification failed:", err));

  return Response.json({ success: true, id: contact.id });
}
```

### 4. Configurar webhook para receber respostas

```typescript
// app/api/whatsapp/webhook/route.ts
export async function GET(request: Request) {
  // Verificação inicial do webhook pela Meta
  const { searchParams } = new URL(request.url);
  const mode = searchParams.get("hub.mode");
  const token = searchParams.get("hub.verify_token");
  const challenge = searchParams.get("hub.challenge");

  if (mode === "subscribe" && token === process.env.WHATSAPP_VERIFY_TOKEN) {
    return new Response(challenge, { status: 200 });
  }
  return new Response("Forbidden", { status: 403 });
}

export async function POST(request: Request) {
  const body = await request.json();
  // Processar mensagens recebidas
  // ...
  return Response.json({ received: true });
}
```

---

## Critérios de Aceite

- [ ] Env vars configuradas no Vercel (sem exposição)
- [ ] Mensagem WhatsApp enviada em < 5s após formulário submetido
- [ ] Falha no WhatsApp não bloqueia resposta ao lead (async)
- [ ] Log de envio registrado (sem dados sensíveis em excesso)
- [ ] Webhook de verificação funcionando
- [ ] Fallback por e-mail se WhatsApp falhar
- [ ] Testado com número de telefone real em sandbox Meta

---

## Segurança

- Validar payload do webhook com HMAC-SHA256 (`X-Hub-Signature-256`)
- Nunca logar o token de autorização
- Rate limit no endpoint de webhook (proteção contra replay)
