# ISSUE-009 — QA: Implementar Suite de Testes no NPA Gestão

**Título:** Configurar Vitest + Playwright para testes unitários e E2E no npa-gestao  
**Labels:** `qa`, `testes`, `npa-gestao`, `alta-prioridade`  
**Estimativa:** L (até 80h)  
**Responsável Sugerido:** Nathan (QA + Dev)  
**Criado em:** 2026-04-28  

---

## Contexto

Não há evidência de testes automatizados em nenhum repositório público da NPA Tecnologia. O npa-gestao é um sistema crítico que gerencia clientes, projetos e finanças. Sem testes:
- Regressões podem passar para produção
- Refatorações são arriscadas
- Não há confiança para releases frequentes

---

## Problema

Ausência total de testes automatizados no sistema de gestão interna.

---

## Passos de Execução

### 1. Instalar dependências

```bash
# Vitest para testes unitários
npm install -D vitest @vitejs/plugin-react jsdom @testing-library/react @testing-library/jest-dom

# Playwright para E2E
npm install -D @playwright/test
npx playwright install
```

### 2. Configurar Vitest

```typescript
// vitest.config.ts
import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  test: {
    environment: "jsdom",
    globals: true,
    setupFiles: ["./src/test/setup.ts"],
    coverage: {
      provider: "v8",
      reporter: ["text", "lcov"],
      include: ["src/**/*.{ts,tsx}"],
      exclude: ["src/**/*.stories.*", "src/test/**"],
    },
  },
});
```

### 3. Testes unitários — validação Zod

```typescript
// src/schemas/client.test.ts
import { describe, it, expect } from "vitest";
import { clientSchema } from "./client";

describe("clientSchema", () => {
  it("deve aceitar cliente válido", () => {
    const result = clientSchema.safeParse({
      name: "Samara Galli Advocacia",
      segment: "advocacia",
      email: "contato@samaragalli.com.br",
    });
    expect(result.success).toBe(true);
  });

  it("deve rejeitar e-mail inválido", () => {
    const result = clientSchema.safeParse({
      name: "Cliente Teste",
      segment: "advocacia",
      email: "email-invalido",
    });
    expect(result.success).toBe(false);
    expect(result.error?.issues[0].path).toContain("email");
  });

  it("deve rejeitar segmento desconhecido", () => {
    const result = clientSchema.safeParse({
      name: "Cliente",
      segment: "inexistente",
    });
    expect(result.success).toBe(false);
  });
});
```

### 4. Testes E2E — fluxo crítico de criação de cliente

```typescript
// tests/e2e/clientes.spec.ts
import { test, expect } from "@playwright/test";

test.describe("Gestão de Clientes", () => {
  test.beforeEach(async ({ page }) => {
    // Login com usuário de teste
    await page.goto("/login");
    await page.fill("[name=email]", process.env.TEST_USER_EMAIL!);
    await page.fill("[name=password]", process.env.TEST_USER_PASSWORD!);
    await page.click("[type=submit]");
    await page.waitForURL("/dashboard");
  });

  test("deve criar novo cliente com sucesso", async ({ page }) => {
    await page.goto("/clientes/novo");
    await page.fill("[name=name]", "Sirius Odontologia Teste");
    await page.selectOption("[name=segment]", "odontologia");
    await page.fill("[name=email]", "contato@sirius.com.br");
    await page.click("[type=submit]");

    await expect(page).toHaveURL(/\/clientes\/[a-z0-9-]+/);
    await expect(page.locator("h1")).toContainText("Sirius Odontologia Teste");
  });

  test("deve exibir erro com e-mail duplicado", async ({ page }) => {
    await page.goto("/clientes/novo");
    await page.fill("[name=email]", "email-existente@test.com");
    // preencher e submeter...
    await expect(page.locator("[role=alert]")).toContainText("já cadastrado");
  });
});
```

### 5. Configurar CI/CD para testes

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  unit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci
      - run: npm run test -- --coverage

  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test
        env:
          TEST_USER_EMAIL: ${{ secrets.TEST_USER_EMAIL }}
          TEST_USER_PASSWORD: ${{ secrets.TEST_USER_PASSWORD }}
```

---

## Critérios de Aceite

- [ ] Vitest configurado e rodando (`npm test`)
- [ ] Cobertura > 80% nas funções de validação e handlers de API
- [ ] Playwright configurado com ao menos 5 testes E2E críticos
- [ ] GitHub Actions executa testes em todo PR
- [ ] PR não pode ser mergeado se testes falharem
- [ ] Relatório de cobertura publicado como artifact no CI
- [ ] Dados de teste não usam banco de produção

---

## Fluxos E2E Prioritários

1. Login / Logout
2. Criar cliente
3. Criar proposta
4. Visualizar dashboard de receita
5. Filtrar clientes por segmento
