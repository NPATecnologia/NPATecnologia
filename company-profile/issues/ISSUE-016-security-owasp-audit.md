# ISSUE-016 — Security: Auditoria OWASP Top 10 no NPA Gestão

**Título:** Executar auditoria de segurança OWASP Top 10 no npa-gestao  
**Labels:** `security`, `audit`, `npa-gestao`, `alta-prioridade`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan (Security)  
**Criado em:** 2026-04-28  

---

## Contexto

O npa-gestao é um sistema interno que armazena dados de clientes, propostas e faturas. Embora seja de uso interno, uma vulnerabilidade pode expor dados confidenciais de 15+ clientes. A auditoria OWASP Top 10 cobre as vulnerabilidades mais críticas de aplicações web.

---

## Checklist OWASP Top 10 (2021)

### A01 — Broken Access Control
- [ ] Verificar que todas as rotas `/api/v1/*` exigem autenticação
- [ ] Verificar que usuário A não pode ver dados de usuário B
- [ ] Testar acesso direto a URLs protegidas sem session
- [ ] Verificar que IDs sequenciais não permitem enumeration (usar UUIDs — ✅ já planejado)

```typescript
// middleware.ts — verificação de autenticação
export async function middleware(request: NextRequest) {
  const session = await getSession(request);
  if (!session && request.nextUrl.pathname.startsWith("/api/v1")) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }
}
```

### A02 — Cryptographic Failures
- [ ] Verificar que senhas nunca são armazenadas em texto claro (Supabase Auth cuida disso)
- [ ] Verificar que HTTPS é forçado em todos os endpoints
- [ ] Verificar que JWTs são assinados com chave forte
- [ ] Verificar que `NEXT_PUBLIC_*` vars não contêm segredos

### A03 — Injection
- [ ] Verificar que todas as queries usam parametrização (Supabase/Prisma — ✅ por padrão)
- [ ] Verificar que inputs do usuário não são passados diretamente a queries SQL
- [ ] Testar campos de busca com payloads de SQL Injection: `' OR '1'='1`
- [ ] Verificar sanitização de inputs em prompts de IA (prompt injection)

### A04 — Insecure Design
- [ ] Verificar que há separação de ambientes (dev/staging/prod)
- [ ] Verificar que dados de teste não usam dados reais de clientes

### A05 — Security Misconfiguration
- [ ] Verificar headers de segurança:

```typescript
// next.config.ts
const securityHeaders = [
  { key: "X-DNS-Prefetch-Control", value: "on" },
  { key: "Strict-Transport-Security", value: "max-age=63072000; includeSubDomains; preload" },
  { key: "X-Frame-Options", value: "SAMEORIGIN" },
  { key: "X-Content-Type-Options", value: "nosniff" },
  { key: "Referrer-Policy", value: "origin-when-cross-origin" },
  { key: "Permissions-Policy", value: "camera=(), microphone=(), geolocation=()" },
];
```

### A06 — Vulnerable Components
- [ ] Executar `npm audit` e corrigir vulnerabilidades críticas/altas
- [ ] Configurar Dependabot para alertas automáticos
- [ ] Verificar que versões de Next.js e Supabase estão atualizadas

```bash
npm audit --production
npm audit fix
```

### A07 — Authentication Failures
- [ ] Verificar que session expira após inatividade
- [ ] Verificar que refresh tokens têm rotação
- [ ] Não há "lembrar senha" que armazene credenciais em claro

### A08 — Software and Data Integrity
- [ ] Verificar que CI/CD tem workflow de build verificado (não usa scripts externos sem hash)
- [ ] Subresource Integrity (SRI) para scripts externos

### A09 — Security Logging
- [ ] Implementar log de tentativas de login falhadas
- [ ] Log de acesso a recursos protegidos
- [ ] Alertas para padrões suspeitos (muitas requests de um IP)

### A10 — Server-Side Request Forgery
- [ ] Verificar que endpoints que fazem fetch para URLs externas validam a URL
- [ ] Não permitir que usuário controle URLs para recursos internos

---

## Ferramentas de Auditoria

```bash
# OWASP ZAP (automático)
docker run -v $(pwd):/zap/wrk/:rw owasp/zap2docker-stable \
  zap-baseline.py -t https://npa-gestao.vercel.app -r report.html

# npm audit
npm audit --production

# Snyk (opcional)
npx snyk test

# Headers check
curl -I https://npa-gestao.vercel.app | grep -i "strict\|x-frame\|x-content"
```

---

## Critérios de Aceite

- [ ] Checklist OWASP Top 10 preenchido com resultado de cada item
- [ ] Zero vulnerabilidades críticas abertas
- [ ] Headers de segurança configurados e verificados
- [ ] `npm audit` sem vulns críticas ou altas
- [ ] Relatório de auditoria salvo em `evidence/security_audit_YYYY-MM-DD.md`
- [ ] Itens médios priorizados para próximo sprint
