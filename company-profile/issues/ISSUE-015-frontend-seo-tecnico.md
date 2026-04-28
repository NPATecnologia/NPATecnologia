# ISSUE-015 — Frontend: SEO Técnico em Todos os Sites Cliente

**Título:** Implementar SEO técnico completo (sitemap, OG, structured data) em 15 sites  
**Labels:** `frontend`, `marketing`, `seo`, `alta-prioridade`  
**Estimativa:** L (até 80h)  
**Responsável Sugerido:** Nathan (Frontend)  
**Criado em:** 2026-04-28  

---

## Contexto

Sites de pequenos negócios dependem de SEO local e orgânico para captar clientes. Atualmente há evidência de que os sites usam Next.js, mas não há garantia de que implementam corretamente:
- Meta tags de título e descrição únicas por página
- Open Graph para compartilhamento em redes sociais
- Twitter Cards
- Sitemap.xml dinâmico
- Structured data (Schema.org) por segmento
- robots.txt

Cada segmento tem structured data específico:
- Advocacia: `LegalService`
- Gastronomia: `Restaurant`
- Beauty: `BeautySalon`
- Odontologia: `Dentist`
- Saúde: `HealthAndBeautyBusiness`

---

## Problema

Sites sem SEO técnico adequado não aparecem nos resultados de busca local, perdendo tráfego orgânico gratuito que o cliente pagou para ter.

---

## Passos de Execução

### 1. Template de metadata por projeto (Next.js App Router)

```typescript
// app/layout.tsx
import { Metadata } from "next";

export const metadata: Metadata = {
  title: {
    template: "%s | Samara Galli Advocacia",
    default: "Samara Galli Advocacia — Especialista em Direito Trabalhista, São Paulo",
  },
  description: "Advogada trabalhista em São Paulo. Atendimento personalizado em ações trabalhistas, rescisões e direitos do trabalhador. Consulta gratuita.",
  keywords: ["advogada trabalhista São Paulo", "direito trabalhista", "ação trabalhista"],
  openGraph: {
    type: "website",
    locale: "pt_BR",
    url: "https://samara-galli-advocacia.vercel.app",
    siteName: "Samara Galli Advocacia",
    images: [{ url: "/og-image.jpg", width: 1200, height: 630 }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Samara Galli Advocacia",
    description: "Advogada trabalhista em São Paulo.",
    images: ["/og-image.jpg"],
  },
  robots: { index: true, follow: true },
  alternates: { canonical: "https://samara-galli-advocacia.vercel.app" },
};
```

### 2. Sitemap dinâmico

```typescript
// app/sitemap.ts
import { MetadataRoute } from "next";

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    {
      url: "https://samara-galli-advocacia.vercel.app",
      lastModified: new Date(),
      changeFrequency: "monthly",
      priority: 1,
    },
    {
      url: "https://samara-galli-advocacia.vercel.app/sobre",
      lastModified: new Date(),
      changeFrequency: "yearly",
      priority: 0.8,
    },
  ];
}
```

### 3. Structured Data — Advocacia (LegalService)

```typescript
// components/JsonLd.tsx
export function LegalServiceJsonLd({ lawyer }: { lawyer: LawyerData }) {
  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{
        __html: JSON.stringify({
          "@context": "https://schema.org",
          "@type": "LegalService",
          name: lawyer.name,
          description: lawyer.description,
          url: lawyer.url,
          telephone: lawyer.phone,
          address: {
            "@type": "PostalAddress",
            addressLocality: "São Paulo",
            addressRegion: "SP",
            addressCountry: "BR",
          },
          geo: {
            "@type": "GeoCoordinates",
            latitude: "-23.5489",
            longitude: "-46.6388",
          },
          openingHours: "Mo-Fr 09:00-18:00",
          priceRange: "$$",
        }),
      }}
    />
  );
}
```

### 4. Structured Data por Segmento

| Segmento | Schema.org Type | Campos Críticos |
|---|---|---|
| Advocacia | `LegalService` | name, telephone, address, openingHours |
| Gastronomia | `Restaurant` | name, servesCuisine, menu, priceRange |
| Beauty | `BeautySalon` | name, openingHours, hasMap |
| Odontologia | `Dentist` | name, medicalSpecialty, telephone |
| Saúde/Nutrição | `Physician` | name, medicalSpecialty, availableService |
| Automotivo | `AutoDealer` ou `AutomotiveBusiness` | name, services |

---

## Critérios de Aceite

- [ ] `metadata` definido em cada `layout.tsx` com título e descrição únicos
- [ ] Open Graph implementado com imagem 1200x630 específica
- [ ] `sitemap.ts` criado e acessível em `/sitemap.xml`
- [ ] `robots.txt` criado com regras corretas
- [ ] Structured data implementado por tipo de segmento
- [ ] Google Search Console sem erros críticos para todos os 15 sites
- [ ] Rich Results Test aprovado (structured data)
- [ ] Lighthouse SEO score > 90 em todos os sites

---

## Prioridade de Implementação

1. Sites com domínio próprio (3) — mais críticos para SEO
2. Sites de advocacia (3) — alto valor por cliente
3. Sites de saúde e odontologia (3) — buscas locais frequentes
4. Gastronomia (4) e outros
