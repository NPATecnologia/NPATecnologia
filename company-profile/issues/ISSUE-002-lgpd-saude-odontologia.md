# ISSUE-002 — LGPD: Dados de Saúde em Sites de Nutrição e Odontologia

**Título:** Conformidade LGPD para dados sensíveis de saúde  
**Labels:** `lgpd`, `legal`, `urgente`, `backend`, `security`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan + advogado especialista em LGPD  
**Criado em:** 2026-04-28  

---

## Contexto

Os projetos Solange Camargo Nutricionista, Sirius Odontologia e Fluari Odontologia coletam dados que podem ser classificados como **dados sensíveis de saúde** (Art. 11 LGPD). O tratamento de dados sensíveis exige **base legal mais restrita** — apenas consentimento explícito ou necessidade de tratamento médico (Art. 11, I e II-f).

O tratamento inadequado de dados de saúde pode resultar em:
- Sanções administrativas da ANPD
- Dano moral e ação civil do titular
- Dano reputacional para o cliente e para a NPA

---

## Problema

1. Formulários de contato dos 3 sites não têm consentimento explícito para dados de saúde
2. Banco de dados não diferencia dados comuns de dados sensíveis
3. Ausência de RIPD (Relatório de Impacto à Proteção de Dados) para tratamento de saúde
4. Dados potencialmente retidos indefinidamente (sem política de retenção)

---

## Passos de Execução

1. **Auditar formulários** de contato em Solange Nutri, Sirius e Fluari:
   - Quais campos coletam (nome, queixa de saúde, histórico, etc.)
   - Onde são armazenados
   - Quem tem acesso

2. **Implementar consentimento explícito e específico**:
   ```tsx
   <label>
     <input type="checkbox" name="lgpd_health_consent" required />
     Autorizo o tratamento dos meus dados de saúde para fins de
     agendamento e contato, conforme{" "}
     <a href="/politica-privacidade">Política de Privacidade</a>.
   </label>
   ```

3. **Adicionar campos no banco**:
   ```sql
   ALTER TABLE contacts ADD COLUMN data_category varchar(20) DEFAULT 'common';
   -- 'common' | 'health' | 'financial'
   ALTER TABLE contacts ADD COLUMN health_consent boolean DEFAULT false;
   ALTER TABLE contacts ADD COLUMN health_consent_at timestamptz;
   ```

4. **Criar política de retenção**:
   - Dados de saúde: máximo 2 anos após último contato
   - Job automático de exclusão após prazo

5. **Elaborar RIPD** (Relatório de Impacto à Proteção de Dados) — documento formal

6. **Nomear DPO** ou designar e-mail de encarregado de dados (ex: privacidade@cliente.com.br)

---

## Critérios de Aceite

- [ ] Consentimento explícito para dados de saúde em todos os 3 formulários
- [ ] Campo `health_consent` e `data_category` no banco de dados
- [ ] Política de retenção definida e documentada
- [ ] RIPD elaborado para cada site (simplificado)
- [ ] DPO/encarregado nomeado e publicado na política de privacidade
- [ ] Notificação de brecha em 72h documentada no processo interno

---

## Referências

- LGPD Art. 11: Tratamento de dados sensíveis
- LGPD Art. 37: Registro de operações
- Resolução CD/ANPD nº 2/2022: RIPD

---

*Issue de conformidade crítica. Prazo máximo recomendado: 30 dias.*
