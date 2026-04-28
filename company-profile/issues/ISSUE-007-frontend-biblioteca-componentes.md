# ISSUE-007 — Frontend: Biblioteca de Componentes Reutilizáveis v1

**Título:** Criar biblioteca de componentes Next.js + Tailwind compartilhada entre projetos  
**Labels:** `frontend`, `ux`, `produto`, `design-system`  
**Estimativa:** L (até 80h)  
**Responsável Sugerido:** Nathan (Frontend)  
**Criado em:** 2026-04-28  

---

## Contexto

A NPA Tecnologia desenvolve landing pages para múltiplos clientes em segmentos diferentes. Atualmente cada projeto replica manualmente componentes como Hero, CTA, Footer, NavBar e ContactForm. Isso causa:
- Inconsistência visual entre projetos
- Retrabalho em cada novo cliente
- Dificuldade de atualizar um padrão em todos os projetos

---

## Problema

Sem biblioteca compartilhada, o tempo de entrega é maior e a qualidade varia entre projetos.

---

## Passos de Execução

### 1. Estrutura do Pacote

```
packages/
  ui/
    src/
      components/
        Hero/
          index.tsx
          Hero.stories.tsx
          types.ts
        CTA/
        Footer/
        NavBar/
        ContactForm/
        Testimonials/
        SectionWrapper/
      tokens/
        colors.ts
        typography.ts
        spacing.ts
      index.ts
    package.json
    tsconfig.json
    tailwind.config.ts
```

### 2. Componente Hero (exemplo)

```typescript
// packages/ui/src/components/Hero/index.tsx
interface HeroProps {
  title: string;
  subtitle?: string;
  ctaLabel: string;
  ctaHref: string;
  backgroundType?: "gradient" | "image" | "video";
  accentColor?: string;
}

export function Hero({
  title,
  subtitle,
  ctaLabel,
  ctaHref,
  accentColor = "#7C3AED",
}: HeroProps) {
  return (
    <section
      className="min-h-screen flex flex-col items-center justify-center px-6 text-center"
      style={{ "--accent": accentColor } as React.CSSProperties}
    >
      <h1 className="text-5xl font-bold tracking-tight">{title}</h1>
      {subtitle && <p className="mt-4 text-xl text-gray-600">{subtitle}</p>}
      <a
        href={ctaHref}
        className="mt-8 px-8 py-4 rounded-xl font-semibold text-white transition hover:opacity-90"
        style={{ backgroundColor: accentColor }}
      >
        {ctaLabel}
      </a>
    </section>
  );
}
```

### 3. Configurar Storybook

```bash
npx storybook@latest init
# Adicionar addon-a11y para acessibilidade
npm install @storybook/addon-a11y
```

### 4. Publicar como pacote interno (npm workspace ou turborepo)

```json
// package.json raiz
{
  "workspaces": ["apps/*", "packages/*"]
}
```

### 5. Consumir em projeto cliente

```typescript
import { Hero, Footer, ContactForm } from "@npa/ui";
```

---

## Componentes da v1 (escopo mínimo)

| Componente | Prioridade | Variantes |
|---|---|---|
| `Hero` | Crítico | gradient, image, video-bg |
| `NavBar` | Crítico | fixed, transparent, solid |
| `Footer` | Crítico | minimal, completo com links |
| `ContactForm` | Crítico | modal, inline, sidebar |
| `CTA` | Alta | primário, secundário, banner |
| `Testimonials` | Alta | cards, carrossel, lista |
| `SectionWrapper` | Alta | com/sem padding, com/sem fundo |

---

## Critérios de Aceite

- [ ] Pacote `@npa/ui` configurado como workspace
- [ ] 7 componentes implementados com TypeScript e props documentadas
- [ ] Storybook deployado e acessível
- [ ] Cada componente tem ao menos 2 variantes documentadas
- [ ] Design tokens (cores, tipografia) centralizados
- [ ] Usado em pelo menos 1 projeto novo de cliente
- [ ] README do pacote com instruções de instalação e uso
- [ ] Acessibilidade básica: contraste, aria-labels, foco visível

---

## Notas

- Usar Framer Motion para animações de entrada (já usado nos projetos)
- Integrar com GSAP apenas para casos avançados (não incluir no bundle base)
- Considerar usar Radix UI como primitivos acessíveis para Modal, Dialog, etc.
