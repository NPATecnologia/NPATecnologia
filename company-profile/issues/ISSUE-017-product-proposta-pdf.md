# ISSUE-017 — Product: Geração de Proposta em PDF no NPA Gestão

**Título:** Gerar PDF de proposta comercial a partir de template no npa-gestao  
**Labels:** `product`, `backend`, `npa-gestao`, `frontend`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan  
**Criado em:** 2026-04-28  

---

## Contexto

Atualmente as propostas da NPA são criadas manualmente (Word, Google Docs ou Canva). Integrar a geração de PDF no npa-gestao permite:
- Consistência visual em todas as propostas
- Rastreamento de quando a proposta foi aberta (opcional)
- Histórico de propostas por cliente
- Geração rápida a partir de briefing

---

## Problema

Propostas manuais são inconsistentes, demoram mais para produzir e não são rastreáveis.

---

## Passos de Execução

### 1. Escolher biblioteca de PDF

**Opção A — @react-pdf/renderer** (recomendado para Next.js)
```bash
npm install @react-pdf/renderer
```

**Opção B — Puppeteer** (gera PDF do HTML — mais fácil de estilizar)
```bash
npm install puppeteer
```

Recomendação: `@react-pdf/renderer` para SSR/Edge compatibility.

### 2. Criar template de proposta

```typescript
// components/ProposalDocument.tsx
import { Document, Page, Text, View, StyleSheet, Image } from "@react-pdf/renderer";

const styles = StyleSheet.create({
  page: { padding: 40, fontFamily: "Helvetica", backgroundColor: "#FFFFFF" },
  header: { flexDirection: "row", justifyContent: "space-between", marginBottom: 30 },
  logo: { width: 120 },
  title: { fontSize: 24, fontWeight: "bold", color: "#7C3AED", marginBottom: 8 },
  section: { marginBottom: 20 },
  sectionTitle: { fontSize: 12, fontWeight: "bold", color: "#374151", marginBottom: 8 },
  table: { display: "table", width: "100%", borderStyle: "solid", borderWidth: 1, borderColor: "#E5E7EB" },
  tableRow: { flexDirection: "row" },
  tableCell: { flex: 1, padding: 8, fontSize: 10 },
  total: { fontSize: 16, fontWeight: "bold", color: "#7C3AED", textAlign: "right" },
  footer: { position: "absolute", bottom: 30, left: 40, right: 40, fontSize: 9, color: "#9CA3AF", textAlign: "center" },
});

export function ProposalDocument({ proposal }: { proposal: Proposal }) {
  return (
    <Document>
      <Page size="A4" style={styles.page}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.title}>NPA Tecnologia</Text>
          <Text style={{ fontSize: 10, color: "#6B7280" }}>
            nathan@npatecnologia.com.br{"\n"}
            npatecnologia.com.br
          </Text>
        </View>

        {/* Destinatário */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>PROPOSTA PARA</Text>
          <Text>{proposal.client.name}</Text>
        </View>

        {/* Serviços */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>SERVIÇOS</Text>
          <View style={styles.table}>
            {proposal.services.map((service, i) => (
              <View key={i} style={styles.tableRow}>
                <View style={[styles.tableCell, { flex: 3 }]}>
                  <Text style={{ fontWeight: "bold" }}>{service.name}</Text>
                  <Text style={{ fontSize: 9, color: "#6B7280" }}>{service.description}</Text>
                </View>
                <View style={[styles.tableCell, { flex: 1, alignItems: "flex-end" }]}>
                  <Text>R$ {service.price.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}</Text>
                </View>
              </View>
            ))}
          </View>
        </View>

        {/* Total */}
        <Text style={styles.total}>
          TOTAL: R$ {proposal.total.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}
        </Text>

        {/* Condições */}
        <View style={[styles.section, { marginTop: 20 }]}>
          <Text style={styles.sectionTitle}>CONDIÇÕES</Text>
          <Text style={{ fontSize: 10 }}>{proposal.payment_terms}</Text>
          <Text style={{ fontSize: 10, marginTop: 4 }}>
            Válido até: {new Date(proposal.valid_until).toLocaleDateString("pt-BR")}
          </Text>
        </View>

        {/* Footer */}
        <Text style={styles.footer}>
          NPA Tecnologia — São Paulo, SP — npatecnologia.com.br{"\n"}
          Esta proposta é confidencial e destinada exclusivamente ao destinatário acima.
        </Text>
      </Page>
    </Document>
  );
}
```

### 3. API de geração de PDF

```typescript
// app/api/v1/proposals/[id]/pdf/route.ts
import { renderToBuffer } from "@react-pdf/renderer";
import { ProposalDocument } from "@/components/ProposalDocument";

export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  // Buscar proposta do banco
  const { data: proposal } = await supabase
    .from("proposals")
    .select("*, client:clients(*)")
    .eq("id", params.id)
    .single();

  if (!proposal) return Response.json({ error: "Not found" }, { status: 404 });

  const buffer = await renderToBuffer(<ProposalDocument proposal={proposal} />);

  return new Response(buffer, {
    headers: {
      "Content-Type": "application/pdf",
      "Content-Disposition": `attachment; filename="proposta-${proposal.id}.pdf"`,
    },
  });
}
```

---

## Critérios de Aceite

- [ ] PDF gerado com logo, serviços, total e condições
- [ ] Endpoint `GET /api/v1/proposals/:id/pdf` funcional
- [ ] Download disponível na UI (botão "Baixar PDF")
- [ ] PDF gerado em < 3s
- [ ] PDF renderiza corretamente em mobile (A4, portrait)
- [ ] Proposta marcada como "enviada" ao gerar PDF
- [ ] Histórico de PDFs gerados registrado (timestamp)
