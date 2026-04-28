#!/usr/bin/env node
// build_apresentacao.mjs — Gera apresentacao-npa.html e apresentacao-npa.pdf
// Requer: node >= 18, playwright instalado globalmente

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const OUTPUT = path.resolve(ROOT, 'output');

fs.mkdirSync(OUTPUT, { recursive: true });

// ─── Dados da empresa (extraídos e curados dos .md) ───────────────────────

const SERVICOS = [
  {
    emoji: '🚀',
    titulo: 'Landing Page Premium',
    descricao: 'Site institucional de alta conversão com animações sofisticadas e design de referência. Do briefing ao ar em até 12 dias úteis.',
    cor: '#7C3AED',
  },
  {
    emoji: '⚙️',
    titulo: 'Web Application',
    descricao: 'Aplicações web completas com login, banco de dados, painel administrativo e integrações. Escalável desde o primeiro dia.',
    cor: '#06B6D4',
  },
  {
    emoji: '🤖',
    titulo: 'Automação com IA',
    descricao: 'Chatbots, geração de conteúdo, análise de documentos e atendimento automatizado com OpenAI, Claude e Gemini.',
    cor: '#8B5CF6',
  },
  {
    emoji: '💬',
    titulo: 'Integração WhatsApp',
    descricao: 'Atendimento automático, notificações de leads e respostas inteligentes via WhatsApp Business API.',
    cor: '#22C55E',
  },
  {
    emoji: '🔧',
    titulo: 'Manutenção & Evolução',
    descricao: 'Suporte contínuo, atualizações, novos módulos e melhorias. Seu site sempre no ar e sempre evoluindo.',
    cor: '#F59E0B',
  },
];

const SEGMENTOS = [
  {
    nome: 'Advocacia',
    cor: '#7C3AED',
    bg: '#F5F3FF',
    emoji: '⚖️',
    cases: ['Samara Galli Advocacia', 'Leal & Loron', 'Dra. Gabriela Pan'],
    pitch: 'Sites que transmitem autoridade e captam clientes que buscam por advogados no Google.',
  },
  {
    nome: 'Gastronomia',
    cor: '#06B6D4',
    bg: '#ECFEFF',
    emoji: '🍽️',
    cases: ['Tiquatirão Mar & Brasa', 'Panelão do Norte', 'O Costellone', 'Empório Esquina da Fruta'],
    pitch: 'Cardápios digitais, fotos de impacto e botão de reserva integrado ao WhatsApp.',
  },
  {
    nome: 'Beauty & Estética',
    cor: '#EC4899',
    bg: '#FDF2F8',
    emoji: '💅',
    cases: ['Studio Kelly Beauty', 'Studio Nicole Pagliari', 'Studio My Lash'],
    pitch: 'Sites que vendem o ambiente antes da cliente chegar. Agendamento e galeria integrados.',
  },
  {
    nome: 'Automotivo',
    cor: '#DC2626',
    bg: '#FEF2F2',
    emoji: '🚗',
    cases: ['Graxinha Envelopamentos', 'Red Garage', 'Lowrider'],
    pitch: 'Portfólio visual de serviços que converte visitante em orçamento no mesmo dia.',
  },
  {
    nome: 'Saúde & Nutrição',
    cor: '#22C55E',
    bg: '#F0FDF4',
    emoji: '🥗',
    cases: ['Solange Camargo Nutricionista'],
    pitch: 'Credibilidade clínica com design humano. Depoimentos e consulta online facilitados.',
  },
  {
    nome: 'Odontologia',
    cor: '#0EA5E9',
    bg: '#F0F9FF',
    emoji: '🦷',
    cases: ['Sirius Odontologia', 'Fluari Odontologia'],
    pitch: 'Sites que reduzem o medo do paciente e facilitam o agendamento da primeira consulta.',
  },
];

const PROCESSO = [
  { numero: '01', titulo: 'Briefing', descricao: 'Reunião rápida para entender o negócio, público-alvo, referências e objetivos do site.' },
  { numero: '02', titulo: 'Design', descricao: 'Criação do layout no Figma com identidade visual do cliente. Aprovação antes de codar.' },
  { numero: '03', titulo: 'Desenvolvimento', descricao: 'Código limpo, rápido e responsivo. Stack moderna que garante performance e escalabilidade.' },
  { numero: '04', titulo: 'Revisão', descricao: 'Até 3 rodadas de ajustes com o cliente. Nada vai ao ar sem aprovação.' },
  { numero: '05', titulo: 'Deploy', descricao: 'Site no ar em minutos com domínio configurado, SSL e monitoramento de uptime.' },
];

const FUNIL = [
  { etapa: 'Descoberta', detalhe: 'GitHub, portfolio, indicação de cliente atual', icone: '🔍' },
  { etapa: 'Interesse', detalhe: 'Visita ao site npatecnologia.com.br', icone: '👀' },
  { etapa: 'Contato', detalhe: 'E-mail ou WhatsApp direto com Nathan', icone: '✉️' },
  { etapa: 'Proposta', detalhe: 'Orçamento personalizado por segmento em até 24h', icone: '📋' },
  { etapa: 'Fechamento', detalhe: 'Contrato + 50% antecipado para iniciar', icone: '✅' },
  { etapa: 'Entrega', detalhe: 'MVP → revisões → deploy em produção', icone: '🚀' },
  { etapa: 'Manutenção', detalhe: 'Contrato mensal opcional de suporte e evolução', icone: '🔧' },
];

const OBJECOES = [
  {
    objecao: '"Já tenho site no ar."',
    resposta: 'Nosso trabalho não é fazer qualquer site — é fazer um site que vende. Se o seu atual não está gerando leads, a conversa vale.',
  },
  {
    objecao: '"É caro demais."',
    resposta: 'Um site que traz 2 clientes novos por mês paga o investimento em 30 dias. O que custa é ficar sem presença digital profissional.',
  },
  {
    objecao: '"Não entendo de tecnologia."',
    resposta: 'Você não precisa. Cuidamos de tudo, do domínio ao deploy. Você aprova o design e usa o site.',
  },
  {
    objecao: '"Preciso pensar."',
    resposta: 'Claro. Mas vagas são limitadas — trabalhamos com poucos clientes por mês para garantir qualidade. Quando podemos conversar?',
  },
];

// ─── Template HTML ─────────────────────────────────────────────────────────

function buildHtml() {
  const servicosHtml = SERVICOS.map(s => `
    <div class="card">
      <div class="card-emoji">${s.emoji}</div>
      <h3 class="card-title" style="color:${s.cor}">${s.titulo}</h3>
      <p class="card-desc">${s.descricao}</p>
    </div>`).join('');

  const segmentosHtml = SEGMENTOS.map(seg => `
    <div class="seg-card" style="border-top: 4px solid ${seg.cor}; background:${seg.bg}">
      <div class="seg-header">
        <span class="seg-emoji">${seg.emoji}</span>
        <span class="seg-nome" style="color:${seg.cor}">${seg.nome}</span>
      </div>
      <p class="seg-pitch">${seg.pitch}</p>
      <div class="seg-cases">
        ${seg.cases.map(c => `<span class="badge" style="background:${seg.cor}20;color:${seg.cor};border:1px solid ${seg.cor}40">${c}</span>`).join('')}
      </div>
    </div>`).join('');

  const processoHtml = PROCESSO.map((p, i) => `
    <div class="step">
      <div class="step-num">${p.numero}</div>
      <div class="step-body">
        <h4 class="step-title">${p.titulo}</h4>
        <p class="step-desc">${p.descricao}</p>
      </div>
      ${i < PROCESSO.length - 1 ? '<div class="step-arrow">→</div>' : ''}
    </div>`).join('');

  const funilHtml = FUNIL.map(f => `
    <div class="funil-item">
      <span class="funil-icon">${f.icone}</span>
      <div>
        <strong>${f.etapa}</strong>
        <span class="funil-detalhe">${f.detalhe}</span>
      </div>
    </div>`).join('');

  const objecoesHtml = OBJECOES.map(o => `
    <div class="objecao-card">
      <p class="objecao-q">${o.objecao}</p>
      <p class="objecao-a">${o.resposta}</p>
    </div>`).join('');

  return `<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>NPA Tecnologia — Apresentação Comercial</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --brand: #7C3AED;
      --accent: #06B6D4;
      --dark: #0D1117;
      --gray: #6B7280;
      --light: #F9FAFB;
      --border: #E5E7EB;
      --text: #111827;
    }

    body {
      font-family: 'Inter', system-ui, sans-serif;
      color: var(--text);
      background: #fff;
      line-height: 1.6;
      font-size: 16px;
    }

    /* ── CAPA ── */
    .cover {
      background: linear-gradient(135deg, #4C1D95 0%, var(--brand) 50%, #1D4ED8 100%);
      color: #fff;
      padding: 80px 60px;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      page-break-after: always;
    }
    .cover-tag {
      font-size: 13px;
      font-weight: 600;
      letter-spacing: 3px;
      text-transform: uppercase;
      opacity: 0.7;
      margin-bottom: 24px;
    }
    .cover-title {
      font-size: 72px;
      font-weight: 900;
      line-height: 1.05;
      margin-bottom: 16px;
    }
    .cover-sub {
      font-size: 22px;
      font-weight: 400;
      opacity: 0.85;
      max-width: 560px;
      margin-bottom: 48px;
    }
    .cover-divider {
      width: 80px;
      height: 4px;
      background: var(--accent);
      border-radius: 2px;
      margin-bottom: 48px;
    }
    .cover-meta {
      display: flex;
      gap: 40px;
      flex-wrap: wrap;
    }
    .cover-meta-item { opacity: 0.8; font-size: 15px; }
    .cover-meta-item strong { display: block; opacity: 1; font-size: 17px; font-weight: 700; }

    /* ── SEÇÕES ── */
    section {
      padding: 72px 60px;
      page-break-inside: avoid;
    }
    section:nth-child(even) { background: var(--light); }

    .section-tag {
      font-size: 12px;
      font-weight: 700;
      letter-spacing: 3px;
      text-transform: uppercase;
      color: var(--brand);
      margin-bottom: 12px;
    }
    .section-title {
      font-size: 38px;
      font-weight: 800;
      line-height: 1.15;
      margin-bottom: 16px;
      color: var(--text);
    }
    .section-lead {
      font-size: 18px;
      color: var(--gray);
      max-width: 640px;
      margin-bottom: 48px;
    }

    /* ── QUEM SOMOS ── */
    .quem-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 40px;
      align-items: start;
    }
    .quem-text { font-size: 17px; line-height: 1.75; color: #374151; }
    .quem-text p + p { margin-top: 16px; }
    .quem-stats {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    .stat-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 20px;
      text-align: center;
    }
    .stat-num {
      font-size: 36px;
      font-weight: 900;
      color: var(--brand);
      line-height: 1;
    }
    .stat-label {
      font-size: 13px;
      color: var(--gray);
      margin-top: 6px;
    }
    .refs {
      margin-top: 32px;
      padding: 20px 24px;
      background: #fff;
      border-left: 4px solid var(--accent);
      border-radius: 0 8px 8px 0;
    }
    .refs p { font-size: 14px; color: var(--gray); }
    .refs strong { color: var(--text); }

    /* ── SERVIÇOS ── */
    .cards-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 24px;
    }
    .card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 28px 24px;
      transition: box-shadow .2s;
    }
    .card-emoji { font-size: 32px; margin-bottom: 14px; }
    .card-title { font-size: 17px; font-weight: 700; margin-bottom: 10px; }
    .card-desc { font-size: 14px; color: var(--gray); line-height: 1.6; }

    /* ── PORTFÓLIO ── */
    .seg-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 20px;
    }
    .seg-card {
      border-radius: 12px;
      padding: 24px;
    }
    .seg-header {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 12px;
    }
    .seg-emoji { font-size: 22px; }
    .seg-nome { font-size: 18px; font-weight: 700; }
    .seg-pitch { font-size: 14px; color: #374151; margin-bottom: 16px; line-height: 1.55; }
    .seg-cases { display: flex; flex-wrap: wrap; gap: 8px; }
    .badge {
      font-size: 12px;
      font-weight: 600;
      padding: 4px 10px;
      border-radius: 100px;
    }

    /* ── PROCESSO ── */
    .steps {
      display: flex;
      align-items: flex-start;
      gap: 0;
      flex-wrap: nowrap;
      overflow-x: auto;
    }
    .step {
      display: flex;
      align-items: flex-start;
      flex: 1;
      min-width: 140px;
    }
    .step-num {
      width: 44px;
      height: 44px;
      border-radius: 50%;
      background: var(--brand);
      color: #fff;
      font-weight: 800;
      font-size: 15px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }
    .step-body { padding: 0 12px; flex: 1; }
    .step-title { font-size: 15px; font-weight: 700; margin-bottom: 6px; }
    .step-desc { font-size: 13px; color: var(--gray); line-height: 1.5; }
    .step-arrow {
      font-size: 20px;
      color: var(--border);
      margin-top: 12px;
      flex-shrink: 0;
    }

    /* ── COMO VENDER ── */
    .vender-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 48px; }
    .funil { display: flex; flex-direction: column; gap: 0; }
    .funil-item {
      display: flex;
      align-items: center;
      gap: 16px;
      padding: 16px 20px;
      border-left: 3px solid var(--border);
      position: relative;
    }
    .funil-item:first-child { border-top-left-radius: 8px; }
    .funil-item:last-child { border-bottom-left-radius: 8px; border-left-color: var(--brand); }
    .funil-item:nth-last-child(-n+3) { border-left-color: var(--accent); }
    .funil-icon { font-size: 22px; width: 36px; text-align: center; flex-shrink: 0; }
    .funil-item strong { display: block; font-size: 14px; font-weight: 700; }
    .funil-detalhe { font-size: 13px; color: var(--gray); }

    .objecoes { display: flex; flex-direction: column; gap: 16px; }
    .objecao-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 20px;
    }
    .objecao-q {
      font-size: 14px;
      font-weight: 700;
      color: #DC2626;
      margin-bottom: 8px;
    }
    .objecao-a { font-size: 14px; color: #374151; line-height: 1.55; }

    /* ── ICP ── */
    .icp-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 32px; }
    .icp-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 20px;
    }
    .icp-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--brand); margin-bottom: 8px; }
    .icp-value { font-size: 15px; font-weight: 600; color: var(--text); }

    /* ── CTA FINAL ── */
    .cta-section {
      background: linear-gradient(135deg, #4C1D95 0%, var(--brand) 100%);
      color: #fff;
      text-align: center;
      padding: 80px 60px;
    }
    .cta-title { font-size: 42px; font-weight: 900; margin-bottom: 16px; }
    .cta-sub { font-size: 18px; opacity: 0.85; margin-bottom: 40px; }
    .cta-buttons { display: flex; gap: 16px; justify-content: center; flex-wrap: wrap; }
    .btn {
      display: inline-block;
      padding: 16px 32px;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 700;
      text-decoration: none;
    }
    .btn-primary { background: #fff; color: var(--brand); }
    .btn-secondary { background: transparent; color: #fff; border: 2px solid rgba(255,255,255,0.5); }
    .cta-footer { margin-top: 48px; font-size: 13px; opacity: 0.6; }

    @media print {
      .cover { min-height: auto; padding: 60px 40px; }
      section { padding: 48px 40px; }
      .cards-grid { grid-template-columns: repeat(2, 1fr); }
      .steps { flex-wrap: wrap; }
    }
  </style>
</head>
<body>

<!-- CAPA -->
<div class="cover">
  <p class="cover-tag">Apresentação Comercial · 2026</p>
  <h1 class="cover-title">NPA<br/>Tecnologia</h1>
  <p class="cover-sub">Software world-class para negócios que levam qualidade a sério.</p>
  <div class="cover-divider"></div>
  <div class="cover-meta">
    <div class="cover-meta-item"><strong>São Paulo, Brasil</strong>Localização</div>
    <div class="cover-meta-item"><strong>15+ projetos</strong>Em produção</div>
    <div class="cover-meta-item"><strong>7 segmentos</strong>Verticais atendidos</div>
    <div class="cover-meta-item"><strong>nathan@npatecnologia.com.br</strong>Contato</div>
  </div>
</div>

<!-- QUEM SOMOS -->
<section id="quem-somos">
  <p class="section-tag">Sobre nós</p>
  <h2 class="section-title">Quem somos</h2>
  <div class="quem-grid">
    <div class="quem-text">
      <p>A <strong>NPA Tecnologia</strong> é um microestúdio de desenvolvimento de software baseado em São Paulo. Construímos landing pages sofisticadas, aplicações web robustas e automações com inteligência artificial para pequenas e médias empresas que entendem o valor de uma presença digital diferenciada.</p>
      <p>Nosso padrão de referência são empresas como Apple, Linear, Stripe e Vercel. Aplicamos esse mesmo nível de cuidado com qualidade — de código, de design e de entrega — nos projetos de cada cliente.</p>
      <p>Somos especialistas em segmentos verticais: advocacia, gastronomia, beauty & estética, automotivo, saúde e odontologia. Entendemos o cliente do cliente, e é isso que faz a diferença no resultado.</p>
      <div class="refs">
        <p><strong>Responsável:</strong> Nathan</p>
        <p><strong>E-mail:</strong> nathan@npatecnologia.com.br</p>
        <p><strong>Site:</strong> npatecnologia.com.br</p>
      </div>
    </div>
    <div>
      <div class="quem-stats">
        <div class="stat-card"><div class="stat-num">15+</div><div class="stat-label">Projetos em produção</div></div>
        <div class="stat-card"><div class="stat-num">7</div><div class="stat-label">Segmentos verticais</div></div>
        <div class="stat-card"><div class="stat-num">3</div><div class="stat-label">IAs integradas</div></div>
        <div class="stat-card"><div class="stat-num">12d</div><div class="stat-label">Prazo médio de entrega</div></div>
      </div>
    </div>
  </div>
</section>

<!-- O QUE FAZEMOS -->
<section id="servicos">
  <p class="section-tag">Serviços</p>
  <h2 class="section-title">O que fazemos</h2>
  <p class="section-lead">Do primeiro briefing ao deploy em produção. Entregamos projetos completos, sem terceirizar qualidade.</p>
  <div class="cards-grid">${servicosHtml}</div>
</section>

<!-- PORTFÓLIO -->
<section id="portfolio">
  <p class="section-tag">Cases</p>
  <h2 class="section-title">Nosso portfólio</h2>
  <p class="section-lead">Projetos reais, em produção, atendendo clientes reais. Cada segmento tem sua linguagem — sabemos falar todas.</p>
  <div class="seg-grid">${segmentosHtml}</div>
</section>

<!-- COMO FUNCIONA -->
<section id="processo">
  <p class="section-tag">Processo</p>
  <h2 class="section-title">Como funciona</h2>
  <p class="section-lead">Um processo claro e direto. Sem surpresas, sem escopo arrastando, sem retrabalho desnecessário.</p>
  <div class="steps">${processoHtml}</div>
</section>

<!-- COMO VENDER -->
<section id="como-vender">
  <p class="section-tag">Playbook de Vendas</p>
  <h2 class="section-title">Como vender</h2>
  <p class="section-lead">Para o time comercial: quem é o cliente ideal, como o funil funciona e como responder às objeções mais comuns.</p>

  <div class="icp-grid">
    <div class="icp-card"><div class="icp-label">Perfil do cliente</div><div class="icp-value">Pequenas e médias empresas que entendem que design e tecnologia geram resultado</div></div>
    <div class="icp-card"><div class="icp-label">Canal de entrada</div><div class="icp-value">Indicação de clientes atuais, portfólio no GitHub e site npatecnologia.com.br</div></div>
    <div class="icp-card"><div class="icp-label">Ticket estimado</div><div class="icp-value">R$ 3.000 – R$ 8.000 por projeto · Manutenção mensal opcional</div></div>
    <div class="icp-card"><div class="icp-label">Prazo de fechamento</div><div class="icp-value">1 a 5 dias após envio de proposta</div></div>
    <div class="icp-card"><div class="icp-label">Diferencial a reforçar</div><div class="icp-value">Padrão Apple/Stripe aplicado a negócios locais — raro no mercado</div></div>
    <div class="icp-card"><div class="icp-label">Segmentos quentes</div><div class="icp-value">Advocacia, beauty e odontologia — alta percepção de valor por presença digital</div></div>
  </div>

  <div class="vender-grid">
    <div>
      <h3 style="font-size:20px;font-weight:700;margin-bottom:20px;">Funil de Vendas</h3>
      <div class="funil">${funilHtml}</div>
    </div>
    <div>
      <h3 style="font-size:20px;font-weight:700;margin-bottom:20px;">Objeções Comuns</h3>
      <div class="objecoes">${objecoesHtml}</div>
    </div>
  </div>
</section>

<!-- CTA FINAL -->
<div class="cta-section">
  <h2 class="cta-title">Vamos construir<br/>algo juntos?</h2>
  <p class="cta-sub">Do briefing ao deploy, cuidamos de tudo. Você foca no seu negócio.</p>
  <div class="cta-buttons">
    <a href="mailto:nathan@npatecnologia.com.br" class="btn btn-primary">Solicitar orçamento</a>
    <a href="https://npatecnologia.com.br" class="btn btn-secondary">Ver portfólio completo</a>
  </div>
  <p class="cta-footer">NPA Tecnologia · São Paulo, Brasil · npatecnologia.com.br</p>
</div>

</body>
</html>`;
}

// ─── Gerar PDF via Playwright ──────────────────────────────────────────────

async function generatePdf(htmlPath, pdfPath) {
  const globalModules = (await import('child_process')).execSync('npm root -g').toString().trim();
  const { createRequire } = await import('module');
  const req = createRequire(import.meta.url);
  const { chromium } = req(`${globalModules}/playwright`);
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(`file://${htmlPath}`, { waitUntil: 'networkidle' });
  await page.pdf({
    path: pdfPath,
    format: 'A4',
    printBackground: true,
    margin: { top: '15mm', bottom: '15mm', left: '10mm', right: '10mm' },
  });
  await browser.close();
  console.log(`  ✓ PDF gerado: ${path.basename(pdfPath)}`);
}

// ─── Main ──────────────────────────────────────────────────────────────────

async function main() {
  console.log('\n🚀 NPA Tecnologia — Build de Apresentação Comercial\n');

  const html = buildHtml();
  const htmlFile = path.join(OUTPUT, 'apresentacao-npa.html');
  const pdfFile = path.join(OUTPUT, 'apresentacao-npa.pdf');

  fs.writeFileSync(htmlFile, html, 'utf8');
  console.log(`  ✓ HTML gerado: ${path.relative(process.cwd(), htmlFile)}`);

  console.log('  ⏳ Gerando PDF com Playwright (aguarde ~10s)...');
  try {
    await generatePdf(htmlFile, pdfFile);
  } catch (err) {
    console.error(`  ✗ PDF falhou: ${err.message}`);
    console.log('  → Abra o HTML no browser e use Ctrl+P para imprimir como PDF.');
  }

  console.log(`\n✅ Concluído!\n`);
  console.log(`   HTML: ${htmlFile}`);
  console.log(`   PDF:  ${pdfFile}`);
  console.log(`\n   Abra o HTML em qualquer browser para visualizar.\n`);
}

main().catch(err => {
  console.error('Erro:', err);
  process.exit(1);
});
