# ISSUE-020 — Integration: IA para Geração de Copy de Landing Pages

**Título:** Implementar geração de conteúdo de landing page via OpenAI/Claude a partir do briefing  
**Labels:** `integration`, `ia`, `backend`, `produto`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan (Backend/Integration)  
**Criado em:** 2026-04-28  

---

## Contexto

A criação de copy (textos) para landing pages é uma das etapas mais demoradas do processo de entrega. A NPA usa OpenAI, Claude e Gemini (declarado no README). Automatizar a geração de copy a partir do briefing pode reduzir o tempo de criação de textos de 4h para 30min, liberando tempo para ajustes criativos.

---

## Problema

Geração manual de copy é lenta, inconsistente por segmento e não aproveita o investimento já feito em APIs de IA.

---

## Passos de Execução

### 1. Criar prompt template por segmento

```typescript
// lib/ai/prompts.ts
const SYSTEM_PROMPT = `Você é um copywriter especialista em landing pages de alta conversão para pequenos negócios brasileiros. 
Escreva textos diretos, persuasivos e com linguagem próxima ao público do segmento informado.
Não use jargões corporativos. Seja autêntico e específico.
Responda sempre em JSON com a estrutura exata solicitada.`;

const SEGMENT_CONTEXT: Record<string, string> = {
  advocacia: "Público: pessoas físicas com problemas trabalhistas, família ou civil. Tom: confiável, profissional, acessível. Evitar: linguagem jurídica técnica.",
  gastronomia: "Público: famílias e grupos para jantar fora. Tom: acolhedor, apetitoso, local. Evitar: preços ou promoções genéricas.",
  beauty: "Público: mulheres que buscam autoestima e cuidado pessoal. Tom: empoderador, sofisticado, íntimo. Evitar: promessas milagrosas.",
  odontologia: "Público: pacientes com medo do dentista ou que buscam estética dental. Tom: tranquilizador, confiável, moderno.",
  saude: "Público: pessoas que buscam mudanças de hábito e saúde. Tom: motivacional, científico mas acessível.",
  automotivo: "Público: proprietários de veículos que querem qualidade e confiança. Tom: técnico mas acessível, premium.",
};

export function buildCopyPrompt(briefing: Briefing): string {
  return `${SYSTEM_PROMPT}

SEGMENTO: ${briefing.segment}
CONTEXTO DO SEGMENTO: ${SEGMENT_CONTEXT[briefing.segment]}

INFORMAÇÕES DO CLIENTE:
- Nome: ${briefing.clientName}
- Especialidade: ${briefing.specialty}
- Diferenciais: ${briefing.differentials.join(", ")}
- Localização: ${briefing.location}
- CTA principal: ${briefing.mainCta}

Gere o copy das seguintes seções em JSON:
{
  "hero": {
    "headline": "título principal (<60 chars, impactante)",
    "subheadline": "subtítulo (<120 chars, explica o benefício principal)",
    "cta": "texto do botão CTA (<25 chars, ação clara)"
  },
  "about": {
    "title": "título da seção sobre (<40 chars)",
    "text": "texto da seção sobre (150-200 palavras, primeira pessoa)"
  },
  "services": {
    "title": "título da seção de serviços",
    "items": [
      { "name": "nome do serviço", "description": "descrição curta (1-2 frases)" }
    ]
  },
  "testimonials": {
    "title": "título da seção de depoimentos"
  },
  "faq": {
    "title": "título do FAQ",
    "items": [
      { "question": "pergunta frequente", "answer": "resposta clara (2-3 frases)" }
    ]
  },
  "contact": {
    "title": "título da seção de contato",
    "cta": "texto do botão de contato"
  },
  "seo": {
    "metaTitle": "meta title SEO (<60 chars)",
    "metaDescription": "meta description SEO (150-160 chars)"
  }
}`;
}
```

### 2. Criar endpoint de geração

```typescript
// app/api/v1/ai/generate-copy/route.ts
import Anthropic from "@anthropic-ai/sdk";
import { buildCopyPrompt } from "@/lib/ai/prompts";

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

export async function POST(request: Request) {
  const briefing = await request.json();

  const message = await anthropic.messages.create({
    model: "claude-sonnet-4-6",
    max_tokens: 2000,
    messages: [
      {
        role: "user",
        content: buildCopyPrompt(briefing),
      },
    ],
  });

  const content = message.content[0];
  if (content.type !== "text") {
    return Response.json({ error: "Unexpected response type" }, { status: 500 });
  }

  try {
    const copy = JSON.parse(content.text);
    return Response.json({ copy, usage: message.usage });
  } catch {
    return Response.json(
      { error: "Failed to parse AI response", raw: content.text },
      { status: 500 }
    );
  }
}
```

### 3. UI no npa-gestao

```
1. Formulário de briefing (tab "Briefing")
2. Botão "Gerar Copy com IA"
3. Loading state com animação
4. Resultado em tabs por seção (Hero, Sobre, Serviços, FAQ, SEO)
5. Cada campo editável inline
6. Botão "Copiar para clipboard"
7. Botão "Salvar no projeto"
```

---

## Critérios de Aceite

- [ ] Endpoint `/api/v1/ai/generate-copy` funcional
- [ ] Retorno em < 10s para segmentos testados
- [ ] JSON estruturado com todas as seções documentadas
- [ ] Testado em 3 segmentos diferentes (advocacia, gastronomia, beauty)
- [ ] Custo por request monitorado (tokens in/out logados)
- [ ] Fallback para GPT-4o se Claude indisponível
- [ ] Input sanitizado antes de enviar para IA (prevenir prompt injection)
- [ ] UI com campos editáveis e cópia para clipboard
- [ ] Conteúdo gerado salvo no banco vinculado ao projeto

---

## Métricas de Sucesso

- Tempo de geração de copy: de 4h manual para < 30min com IA + revisão
- NPS interno: Nathan avalia qualidade do copy gerado em escala 1-5
- Taxa de uso: % de projetos que usaram geração por IA

---

## Segurança

- Nunca incluir dados de outros clientes no prompt (risco de vazamento cross-client)
- Limitar max_tokens por request para controlar custo
- Log de uso por projeto para auditoria de custo
