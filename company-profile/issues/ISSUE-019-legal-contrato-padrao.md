# ISSUE-019 — Legal: Criar Template de Contrato Padrão de Prestação de Serviços

**Título:** Elaborar e implementar contrato padrão de prestação de serviços de desenvolvimento  
**Labels:** `legal`, `produto`, `sales`, `alta-prioridade`  
**Estimativa:** M (até 24h)  
**Responsável Sugerido:** Nathan + advogado parceiro  
**Criado em:** 2026-04-28  

---

## Contexto

A NPA Tecnologia entregou 15+ projetos sem evidência de contrato padronizado. Um contrato bem elaborado protege a empresa em casos de:
- Escopo mal definido (scope creep)
- Inadimplência do cliente
- Disputas sobre propriedade intelectual
- Solicitações de retrabalho excessivo
- Rescisão sem justificativa

---

## Problema

Sem contrato padrão, cada relação comercial é uma aposta. Risco jurídico e financeiro para a NPA.

---

## Cláusulas Mínimas Obrigatórias

### 1. Identificação das Partes
```
CONTRATANTE: [Nome/Razão Social], CNPJ/CPF: [xxx], Endereço: [xxx]
CONTRATADA: NPA Tecnologia, CNPJ: [xxx], nathan@npatecnologia.com.br
```

### 2. Objeto do Contrato
```
Desenvolvimento de [tipo de projeto] conforme especificações do Briefing 
anexo (Anexo A), com entrega estimada em [X] dias úteis após aprovação 
do design/wireframe.
```

### 3. Escopo e Limitações
```
3.1 Estão incluídos no escopo:
    - [lista de funcionalidades do briefing]
    - X rodadas de revisão de design
    - Y rodadas de revisão de conteúdo
    - Deploy em produção na plataforma Vercel

3.2 Não estão incluídos:
    - Manutenção após entrega (objeto de contrato separado)
    - Criação de conteúdo textual e fotográfico
    - Registro de domínio (custo por conta do Contratante)
    - Integração não descrita no Briefing
```

### 4. Valor e Forma de Pagamento
```
4.1 Valor total: R$ [X.XXX,00]
4.2 50% na assinatura deste contrato
4.3 50% na entrega do projeto em produção
4.4 Atraso no pagamento: juros de 1% a.m. + multa de 2%
4.5 Após 15 dias de atraso, a Contratada pode suspender o acesso ao projeto
```

### 5. Propriedade Intelectual
```
5.1 Após quitação integral, o Contratante recebe licença de uso do código desenvolvido
5.2 A Contratada mantém o direito de mencionar o projeto em seu portfólio
5.3 Componentes de terceiros (open source) mantêm suas licenças originais
5.4 O código-fonte desenvolvido não pode ser revendido sem autorização expressa
```

### 6. Sigilo e Confidencialidade
```
Ambas as partes comprometem-se a manter sigilo sobre informações 
confidenciais recebidas, pelo prazo de 2 anos após o encerramento do contrato.
```

### 7. LGPD
```
A Contratada, no exercício de suas funções, tratará dados pessoais do 
Contratante e seus clientes na condição de Operadora (Art. 5, VII LGPD),
exclusivamente para cumprimento deste contrato, conforme Anexo B — 
DPA (Data Processing Agreement).
```

### 8. Rescisão
```
8.1 Rescisão por qualquer das partes com 15 dias de aviso
8.2 Rescisão pelo Contratante após início: pagamento proporcional ao trabalho executado
8.3 Rescisão por inadimplência: 10% de multa sobre o valor não pago
```

### 9. Foro
```
Fica eleito o Foro da Comarca de São Paulo/SP para dirimir quaisquer 
controvérsias decorrentes deste contrato.
```

---

## Passos de Execução

1. **Contratar advogado** para revisar o template (recomendação: advogado especialista em direito digital)
2. **Criar Anexo A** — Briefing padrão por segmento
3. **Criar Anexo B** — DPA (Data Processing Agreement) LGPD
4. **Integrar no npa-gestao**: geração de contrato a partir da proposta aprovada
5. **Assinatura digital**: integrar ZapSign (BR) ou DocuSign para assinatura eletrônica

---

## Critérios de Aceite

- [ ] Template de contrato com todas as 9 cláusulas revisado por advogado
- [ ] Anexo A (Briefing) criado por segmento
- [ ] Anexo B (DPA) criado
- [ ] Template no formato .docx e .pdf
- [ ] Integrado ao npa-gestao (geração automática)
- [ ] Assinatura eletrônica configurada (ZapSign ou similar)
- [ ] Usado em todos os novos contratos a partir desta issue

---

## Custo Estimado

| Item | Custo Estimado |
|---|---|
| Advogado — revisão do contrato | R$ 800–R$ 2.000 |
| ZapSign (assinatura eletrônica) | R$ 0 (plano gratuito até 5 docs/mês) |
| DocuSign (se necessário) | USD 10-45/mês |
