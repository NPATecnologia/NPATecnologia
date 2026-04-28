# Auditoria de Origem — NPA Tecnologia

**Versão:** 1.0  
**Data:** 2026-04-28  
**Agente:** Sênior de Execução  

---

## 1. Fontes Acessíveis

### 1.1 Repositório GitHub Local — `NPATecnologia/NPATecnologia`

| Campo | Valor |
|---|---|
| Tipo | Profile README Repository |
| Branch principal | `main` |
| Branch de trabalho | `claude/keen-sagan-Jv5tE` |
| Commits | 9 (desde 2026-04-20) |
| Arquivos mapeados | README.md, CHANGELOG.md, LICENSE, .github/workflows/snake.yml, .github/FUNDING.yml |

**Evidências extraídas:**
- Identidade da empresa: NPA Tecnologia, São Paulo/BR
- Responsável: Nathan (nathan@npatecnologia.com.br)
- Website: npatecnologia.com.br
- Stack tecnológico completo
- 14 cases em produção (via badges)
- 5 segmentos de atuação + 1 adicional descoberto via Vercel
- CI/CD: GitHub Actions (snake generator, daily cron 03:00 UTC)
- Licença: MIT (LICENSE)
- Funding: FUNDING.yml com link para npatecnologia.com.br

### 1.2 Vercel API — Team `npatecnologia`

| Campo | Valor |
|---|---|
| Team ID | `team_ttjhXLRaY12KSK3OJoAeGez7` |
| Team Slug | `npatecnologia` |
| Projetos encontrados | 19 |
| Data de consulta | 2026-04-28 |

**Inventário completo de projetos Vercel:**

| # | Nome | ID | Criado em | Segmento |
|---|---|---|---|---|
| 1 | npa-gestao | prj_CTlLevDANwWifdyifAB4TaC7jzNf | 2026-04-25 | Interno |
| 2 | npa-notas | prj_WF6nLeEUdlHRPWDwsXbTwfMKfNK2 | 2026-04-13 | Interno |
| 3 | npa-gestao-deploy-temp | prj_476rDET5quX6wSyc9TI40RAwOXlS | 2026-04-25 | Interno (temp) |
| 4 | graxinha-envelopamentos | prj_IEf8uEw1Xo16UPNBxhylfRvWD7e6 | 2026-04-04 | Automotivo |
| 5 | studio-kelly-beauty | prj_pUEMqAneJiGwdPKs1EuuqYrlZXBe | 2026-03-30 | Beauty |
| 6 | npa-tecnologia | prj_fPG2YJ4u8ztDOS5nkxc9o2jzaEjA | 2026-03-24 | Institucional |
| 7 | marq | prj_qB0hwmbs4m7UaMPvJarGN9tb1iUP | 2026-04-13 | Interno (desconhecido) |
| 8 | sirius-odontologia | prj_fYH08rDy7BN0zwCS3wYY5jpXPu0M | 2026-04-20 | Odontologia |
| 9 | samara-galli-advocacia | prj_YGL0K4eyVPZGmfsN7qO7MyCE3x5l | 2026-04-18 | Advocacia |
| 10 | advogado-gabriela-pan | prj_iZRIcVMn0aVd2KGhrjSolHTca9IG | 2026-04-18 | Advocacia |
| 11 | ocostellone | prj_7zqPMnLK0QD1TfGCPOIu3wseHlYj | 2026-04-15 | Gastronomia |
| 12 | fluari-odontologia | prj_pD4YY6g8PfdWr1fJAkuLmInn1WIG | 2026-04-20 | Odontologia |
| 13 | nutri-solange | prj_ZREpojD2BQd4hUrYan3KRJHEOqIt | 2026-03-26 | Saúde/Nutrição |
| 14 | studio-my-lash | prj_mpgxgLpO5HE2KZcPw3RLDWgn88qD | 2026-03-30 | Beauty |
| 15 | tiquatirao-restaurante | prj_WdJokdR51Qxf2XZREJuBIA9dBwqg | 2026-04-08 | Gastronomia |
| 16 | panelao-do-norte | prj_AGlwVTfwQPklhg4eBX16pKTPWFMD | 2026-04-08 | Gastronomia |
| 17 | nicole-pagliari-beauty | prj_JQpzvf08bHtBecqFFKyl3YVb7rwA | 2026-03-25 | Beauty |
| 18 | leal-loron | prj_bykrYQl1FsDwKSZ9STRHVOuSilIR | 2026-04-15 | Advocacia |
| 19 | emporio-esquina-da-fruta | prj_vidW4In1HXUuX1CklK0gJoaGbpfh | 2026-03-26 | Gastronomia |

**Distribuição por segmento:**
- Advocacia: 3 projetos (samara-galli, gabriela-pan, leal-loron)
- Gastronomia: 4 projetos (ocostellone, tiquatirao, panelao, emporio-esquina)
- Beauty/Estética: 3 projetos (kelly-beauty, my-lash, nicole-pagliari)
- Odontologia: 2 projetos (sirius, fluari) ← **novo segmento não documentado no README**
- Automotivo: 1 projeto (graxinha)
- Saúde/Nutrição: 1 projeto (nutri-solange)
- Interno/Produto: 4 projetos (npa-gestao, npa-notas, npa-gestao-deploy-temp, marq)
- Institucional: 1 projeto (npa-tecnologia)

---

## 2. Fontes Inacessíveis

| Fonte | Motivo de Bloqueio | Dados Perdidos |
|---|---|---|
| Repos privados de clientes | Sem token com escopo privado | Código-fonte, APIs, componentes |
| Supabase projects | Sem `SUPABASE_SERVICE_KEY` | Schema, tabelas, registros de migração |
| Figma | Sem `FIGMA_TOKEN` | Design system, protótipos, assets |
| Notion | Sem integration token | Docs internos, processos, wiki |
| Google Drive | Sem OAuth 2.0 | Proposta comercial, contratos |
| GitHub Actions histórico privado | Sem acesso org | Logs de CI, falhas |
| Vercel env vars | Protocolo de segurança | Variáveis de ambiente (localização registrada) |
| WhatsApp Business API | Sem credenciais | Config de chatbot/automação |
| Analytics (Google/Vercel) | Sem token | Tráfego, conversões, performance |

---

## 3. Evidências Encontradas

### Evidência 1 — Stack Técnico (README.md)
```
Next.js, React, TypeScript, JavaScript, Tailwind CSS
Node.js, Bun, PostgreSQL, Supabase, Prisma
Vercel, Docker, Git, GitHub, Figma
Vite, VSCode, Linux, Nginx, Python
OpenAI, Claude (Anthropic), Gemini, WhatsApp API
GSAP, Framer Motion
```

### Evidência 2 — Segmentos Verticais
```
Advocacia (3 projetos Vercel + 2 mencionados no README = 3 total)
Gastronomia (4 projetos Vercel + 4 no README = 4 total)
Beauty (3 projetos Vercel + 3 no README = 3 total)
Automotivo (1 Vercel + 3 no README = detectada divergência: Red Garage e Lowrider sem projeto Vercel próprio)
Saúde/Nutrição (1 Vercel + 1 README)
Odontologia (2 Vercel, 0 README = segmento oculto/novo)
```

### Evidência 3 — Projetos Internos
- `npa-gestao`: Sistema de gestão interna (criado 2026-04-25 — mais recente)
- `npa-notas`: App de notas interna (criado 2026-04-13)
- `marq`: Finalidade desconhecida (criado 2026-04-13, mesmo dia que npa-notas)
- `npa-gestao-deploy-temp`: Deploy temporário de npa-gestao (criado segundos após npa-gestao)

### Evidência 4 — GitHub Actions
```yaml
# snake.yml — cron diário 03:00 UTC, executa em push para main
# Gera SVGs de contribuição com palette brand: #7C3AED (roxo), #06B6D4 (ciano)
# Push para branch output via crazy-max/ghaction-github-pages@v4
```

### Evidência 5 — Identidade Visual (via README)
```
Cor primária: #7C3AED (roxo violeta)
Cor secundária: #06B6D4 (ciano)
Background: #0D1117 (dark)
Fonte: JetBrains Mono
Referências de design: Apple, Linear, Stripe, Vercel
```

### Evidência 6 — Localização de Segredos (sem expor valores)
```
Provável: vercel team env vars (SUPABASE_URL, SUPABASE_ANON_KEY, DATABASE_URL)
Provável: repos privados/.env (API keys OpenAI, WhatsApp, Gemini, etc.)
GITHUB_TOKEN: gerenciado pelo Actions (secreto automático)
```

---

## 4. Limitações

1. **Modelo de dados**: Inferido. Não validado contra schema real do Supabase.
2. **APIs documentadas**: Baseadas em padrão de mercado para o tipo de app. Não validadas contra código-fonte real.
3. **KPIs financeiros**: Completamente ausentes — sem acesso a CRM, analytics ou dados de faturamento.
4. **Histórico de issues**: Sem acesso a projetos/repositórios privados onde issues reais estariam.
5. **Red Garage e Lowrider**: Mencionados no README mas sem projeto Vercel próprio — podem usar repositório do cliente ou estarem hospedados externamente.
6. **FUNDING.yml**: Aponta para `npatecnologia.com.br` — indica intenção de monetização/sponsorship via GitHub Sponsors, mas sem dados de receita.

---

## 5. As 10 Funcionalidades Principais Mapeadas

| # | Funcionalidade | Fonte | Tipo | Projeto(s) |
|---|---|---|---|---|
| 1 | **Landing Pages de Alta Conversão** | README + 15 projetos Vercel | Core Service | Todos os projetos cliente |
| 2 | **Sistema de Gestão Interna (npa-gestao)** | Vercel | Produto Interno | npa-gestao |
| 3 | **App de Notas (npa-notas)** | Vercel | Produto Interno | npa-notas |
| 4 | **Automações com IA** | README (OpenAI, Claude, Gemini) | Feature Transversal | npa-gestao + projetos cliente |
| 5 | **Integração WhatsApp API** | README | Feature de Integração | Projetos com automação |
| 6 | **CI/CD Automatizado** | snake.yml | DevOps | Todos (via GitHub Actions + Vercel) |
| 7 | **Design System com Identidade Brand** | README (cores, fontes) | UX/Design | npa-tecnologia + templates |
| 8 | **Deploy Multi-projeto no Vercel** | Vercel API | DevOps | 19 projetos ativos |
| 9 | **Produto Desconhecido "Marq"** | Vercel | Produto Interno | marq |
| 10 | **Portfólio Digital por Segmento Vertical** | README + Vercel | Marketing/Sales | npa-tecnologia |

---

*Auditoria de origem concluída. Seguindo para geração dos artefatos principais.*
