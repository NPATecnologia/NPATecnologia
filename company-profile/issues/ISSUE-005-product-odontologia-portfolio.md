# ISSUE-005 — Product: Adicionar Segmento de Odontologia ao Portfólio

**Título:** Publicar cases de odontologia no README e npatecnologia.com.br  
**Labels:** `product`, `marketing`, `sales`, `documentação`  
**Estimativa:** S (até 8h)  
**Responsável Sugerido:** Nathan  
**Criado em:** 2026-04-28  

---

## Contexto

A NPA Tecnologia possui 2 projetos de odontologia ativos na Vercel (Sirius Odontologia e Fluari Odontologia), criados em 2026-04-20. No entanto, o README público (`github.com/NPATecnologia`) e o site institucional (`npatecnologia.com.br`) **não mencionam o segmento de odontologia**.

Isso representa perda de oportunidade de negócio: clínicas odontológicas que visitam o GitHub ou o site não veem cases do setor, reduzindo a probabilidade de conversão.

---

## Problema

Portfólio público desatualizado em relação ao portfólio real — 2 cases omitidos.

---

## Passos de Execução

### 1. Atualizar README.md

Adicionar seção após "Saúde & Nutrição":

```markdown
### Odontologia

<a href="https://sirius-odontologia.vercel.app">
  <img src="https://img.shields.io/badge/Sirius_Odontologia-0EA5E9?style=for-the-badge&logo=vercel&logoColor=white" />
</a>
<a href="https://fluari-odontologia.vercel.app">
  <img src="https://img.shields.io/badge/Fluari_Odontologia-0EA5E9?style=for-the-badge&logo=vercel&logoColor=white" />
</a>
```

### 2. Atualizar Typing SVG (se aplicável)

Adicionar frase sobre odontologia no texto rotativo.

### 3. Atualizar CHANGELOG.md

```markdown
## [v5] - 2026-04-28

### Added
- Segmento de Odontologia (Sirius e Fluari)
```

### 4. Atualizar npatecnologia.com.br

- Adicionar card de odontologia na seção de segmentos
- Adicionar os 2 cases na grade de portfólio

### 5. Atualizar Typing SVG

Adicionar uma linha sobre odontologia no texto rotativo do README.

---

## Critérios de Aceite

- [ ] README.md contém seção "Odontologia" com badges dos 2 projetos
- [ ] CHANGELOG.md atualizado com v5
- [ ] npatecnologia.com.br exibe os 2 cases de odontologia
- [ ] URLs dos projetos são acessíveis (HTTP 200)
- [ ] Commit com mensagem descritiva na branch main

---

## Notas

- Verificar com Nathan se os clientes Sirius e Fluari autorizaram a publicidade do case
- Confirmar URLs corretas dos projetos (podem ter domínio próprio ao invés de .vercel.app)
