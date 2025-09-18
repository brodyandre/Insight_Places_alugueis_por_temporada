# 📊 InsightPlaces - Consultas SQL para Análise de Negócio

Este repositório contém **consultas SQL** desenvolvidas sobre o banco de dados fictício **InsightPlaces**, que simula uma plataforma de hospedagens por temporada (similar a Airbnb, Booking, etc).  

O objetivo é demonstrar como **perguntas de negócio** podem ser traduzidas em **consultas SQL**, gerando insights para **tomadores de decisão** em áreas como:

- 💰 **Desempenho Financeiro**
- 🏠 **Gestão de Propriedades**
- 👥 **Segmentação de Clientes**
- ⭐ **Qualidade e Satisfação**
- 🌍 **Expansão e Estratégia de Mercado**

---

## 📂 Estrutura do Repositório
```
Insight_Places_alugueis_por_temporada/
│── README.md
│── docs/
│    └── perguntas_negocio.md
│── scripts/
│    ├── 01_desempenho_financeiro.sql
│    ├── 02_gestao_propriedades.sql
│    ├── 03_clientes_segmentacao.sql
│    ├── 04_qualidade_satisfacao.sql
│    ├── 05_expansao_mercado.sql
│── scripts_base/
│    ├── 0-criacao_banco.sql
│    ├── 1-enderecos.sql
│    ├── 2-clientes.sql
│    ├── 3-proprietarios.sql
│    ├── 4-hospedagens.sql
│    ├── 5-alugueis.sql
│    ├── 6-avaliacoes.sql
│    ├── 7-consultas.sql
│    └── 8-regioes_geograficas.sql
```

---

## 🚀 Como usar
1. Clone este repositório:
   ```bash
   git clone https://github.com/brodyandre/Insight_Places_alugueis_por_temporada.git
   ```
2. Importe os scripts de base (`/scripts_base`) em seu MySQL para criar e popular o banco.
3. Execute as consultas em `/scripts` para responder às perguntas de negócio.

---

## 📌 Autor
Projeto desenvolvido por [@brodyandre](https://github.com/brodyandre).  
Apresentado como **portfólio profissional** no GitHub e LinkedIn.
