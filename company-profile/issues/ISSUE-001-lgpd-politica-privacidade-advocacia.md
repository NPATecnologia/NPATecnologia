# ISSUE-001 — Política de Privacidade: Sites de Advocacia

**Título:** Implementar política de privacidade LGPD-compliant nos sites de advocacia  
**Labels:** `lgpd`, `legal`, `urgente`, `frontend`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan (dev) + revisão jurídica  
**Criado em:** 2026-04-28  

---

## Contexto

Os sites Samara Galli Advocacia, Leal & Loron e Dra. Gabriela Pan processam dados pessoais de potenciais clientes (nome, e-mail, telefone, relatos jurídicos via formulário de contato). A LGPD (Lei 13.709/2018) exige que o controlador informe ao titular como seus dados são tratados **antes ou no momento da coleta** (Art. 9).

Atualmente nenhum dos três sites possui página de política de privacidade visível. Isso configura **infração ao Art. 9 da LGPD** e expõe a NPA Tecnologia e seus clientes a sanções da ANPD.

---

## Problema

- Ausência de `/politica-privacidade` nos 3 sites de advocacia
- Formulários de contato coletam dados sem informar finalidade, prazo de retenção ou responsável pelo tratamento
- Dados de natureza jurídica podem ser considerados sensíveis em contexto (Art. 11 LGPD)

---

## Passos de Execução

1. **Criar template de política de privacidade** com as seguintes seções:
   - Controlador dos dados (nome, CNPJ, e-mail)
   - Dados coletados e finalidade
   - Base legal (legítimo interesse / consentimento)
   - Prazo de retenção
   - Compartilhamento com terceiros
   - Direitos do titular (Art. 18 LGPD)
   - Canal de contato com o DPO/encarregado
   - Data da última atualização

2. **Personalizar o template** para cada escritório (nome do controlador = cliente, não NPA)

3. **Criar página `/politica-privacidade`** em cada site Next.js

4. **Adicionar link no footer** de todas as páginas com texto "Política de Privacidade"

5. **Atualizar formulário de contato** para incluir checkbox de consentimento:
   ```tsx
   <label>
     <input type="checkbox" required />
     Li e concordo com a{" "}
     <a href="/politica-privacidade">Política de Privacidade</a>
   </label>
   ```

6. **Registrar campo `lgpd_consent`** no banco de dados ao salvar o contato

---

## Critérios de Aceite

- [ ] Página `/politica-privacidade` existente e acessível nos 3 sites
- [ ] Link no footer em todas as páginas
- [ ] Checkbox de consentimento no formulário de contato (required)
- [ ] Campo `lgpd_consent` e `lgpd_consent_at` persistidos no banco
- [ ] Texto da política cobre pelo menos os 8 requisitos do Art. 9 LGPD
- [ ] Página indexável mas não necessariamente ranqueada (meta robots: index)
- [ ] Revisada por advogado antes de publicar em produção

---

## Riscos

- **Risco de sanção ANPD** enquanto não implementado: até R$ 50M por infração
- **Risco de bloqueio de negócio**: clientes advocacia podem exigir conformidade

---

*Template de issue gerado pelo Agente de Execução. Revisar com Nathan antes de criar no GitHub.*
