# ISSUE-011 — UX: Definir Design Tokens Oficiais da NPA

**Título:** Criar e publicar design tokens (cor, tipografia, espaçamento) para uso em todos os projetos  
**Labels:** `ux`, `design`, `frontend`, `produto`  
**Estimativa:** S (até 8h)  
**Responsável Sugerido:** Nathan (UX/Frontend)  
**Criado em:** 2026-04-28  

---

## Contexto

A NPA Tecnologia tem uma identidade visual clara mapeada no README:
- Primária: `#7C3AED` (roxo violeta)
- Secundária: `#06B6D4` (ciano)
- Background dark: `#0D1117`
- Tipografia: JetBrains Mono (código) + sans-serif para textos (não especificado)

No entanto, esses tokens não estão formalizados em arquivo compartilhável, fazendo com que cada projeto defina suas próprias cores no `tailwind.config.ts` de forma ad hoc.

---

## Problema

Sem tokens centralizados:
- Cores `brand` variam entre projetos
- Futuras mudanças de identidade visual precisam ser feitas projeto a projeto
- Não há fonte de verdade para designers e desenvolvedores

---

## Passos de Execução

### 1. Criar arquivo de tokens

```typescript
// packages/tokens/src/index.ts

export const colors = {
  brand: {
    primary: "#7C3AED",      // Roxo violeta
    secondary: "#06B6D4",    // Ciano
    primaryDark: "#5B21B6",  // Roxo escuro (hover)
    primaryLight: "#8B5CF6", // Roxo claro (focus)
  },
  background: {
    dark: "#0D1117",
    card: "#1F2937",
    surface: "#111827",
  },
  text: {
    primary: "#E5E7EB",
    secondary: "#A0A0A0",
    muted: "#6B7280",
  },
  feedback: {
    success: "#22C55E",
    error: "#DC2626",
    warning: "#F59E0B",
    info: "#3B82F6",
  },
};

export const typography = {
  fontFamily: {
    sans: ["Inter", "system-ui", "sans-serif"],
    mono: ["JetBrains Mono", "monospace"],
  },
  fontSize: {
    xs: "0.75rem",
    sm: "0.875rem",
    base: "1rem",
    lg: "1.125rem",
    xl: "1.25rem",
    "2xl": "1.5rem",
    "3xl": "1.875rem",
    "4xl": "2.25rem",
    "5xl": "3rem",
  },
};

export const spacing = {
  section: "5rem",    // Padding entre seções
  container: "1.25rem", // Padding lateral mobile
  gap: "1.5rem",     // Gap padrão entre elementos
};

export const animation = {
  duration: {
    fast: "150ms",
    normal: "300ms",
    slow: "600ms",
  },
  easing: {
    default: "cubic-bezier(0.4, 0, 0.2, 1)",
    spring: "cubic-bezier(0.175, 0.885, 0.32, 1.275)",
  },
};
```

### 2. Integrar no Tailwind Config

```typescript
// tailwind.config.ts (compartilhado)
import { colors, typography } from "@npa/tokens";

export default {
  theme: {
    extend: {
      colors: {
        brand: colors.brand,
        surface: colors.background,
      },
      fontFamily: typography.fontFamily,
    },
  },
};
```

### 3. Criar variáveis CSS para uso em estilos globais

```css
/* styles/tokens.css */
:root {
  --color-brand-primary: #7C3AED;
  --color-brand-secondary: #06B6D4;
  --color-bg-dark: #0D1117;
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', monospace;
}
```

---

## Critérios de Aceite

- [ ] Pacote `@npa/tokens` criado e versionado
- [ ] Tokens cobrem: cores, tipografia, espaçamento, animação
- [ ] Integrado no Tailwind config de pelo menos 2 projetos
- [ ] CSS variables geradas automaticamente dos tokens
- [ ] Documentação das cores com swatches no Storybook
- [ ] Versão 1.0.0 publicada com CHANGELOG

---

## Tokens de Segmento (Opcional v2)

Cada segmento tem sua cor de destaque:
- Advocacia: `#7C3AED` (roxo)
- Gastronomia: `#06B6D4` (ciano)
- Beauty: `#EC4899` (rosa)
- Automotivo: `#DC2626` (vermelho)
- Saúde: `#22C55E` (verde)
- Odontologia: `#0EA5E9` (azul claro)
