# Criando o BANCO DE DADOS NO MySQL WORKBENCH 8 
### Rode no MySQL WorkBench o script abaixo para que o banco seja criado
```sql
-- Drop database if exists
DROP DATABASE IF EXISTS insightplaces;

-- Create database
CREATE DATABASE insightplaces;
USE insightplaces;

CREATE TABLE proprietarios (
proprietario_id VARCHAR(255) PRIMARY KEY,
nome VARCHAR(255),
cpf_cnpj VARCHAR(20),
contato VARCHAR(255)
);

CREATE TABLE clientes (
    cliente_id VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(14),
    contato VARCHAR(255)
);

CREATE TABLE enderecos (
    endereco_id VARCHAR(255) PRIMARY KEY,
    rua VARCHAR(255),
    numero INT,
    bairro VARCHAR(255),
    cidade VARCHAR(255),
    estado VARCHAR(2),
    cep VARCHAR(10)
);

CREATE TABLE hospedagens (
    hospedagem_id VARCHAR(255) PRIMARY KEY,
    tipo VARCHAR(50),
    endereco_id VARCHAR(255),
    proprietario_id VARCHAR(255),
		ativo bool,
    FOREIGN KEY (endereco_id) REFERENCES enderecos(endereco_id),
    FOREIGN KEY (proprietario_id) REFERENCES proprietarios(proprietario_id)
);

CREATE TABLE alugueis (
    aluguel_id VARCHAR(255) PRIMARY KEY,
    cliente_id VARCHAR(255),
    hospedagem_id VARCHAR(255),
    data_inicio DATE,
    data_fim DATE,
    preco_total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

CREATE TABLE avaliacoes (
avaliacao_id VARCHAR(255) PRIMARY KEY,
cliente_id VARCHAR(255),
hospedagem_id VARCHAR(255),
nota INT,
comentario TEXT,
FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);
```
# Como carregar os arquivos csv para o banco de dados

Para popularmos as tabelas do nosso banco de dados, devemos na interface do MySQL WorkBench na guia da esquerda clicarmos com o botão direito do mouse sobre a tabela de "enderecos". Aparecerá um menu onde nos escolheremos a opção: "Table Data Import Wizard". Na janela que se abre, indicamos o local onde a pasta com on nossos arquivos csv está localizada (lembre-se que nesse passo você ja deve ter clonado este repositório para a sua máquina local). Selecione o diretório onde os arquivos estão e clique em "next". OBS.: carregue os arquivos csv exatamente na ordem que eles estão numerado, sendo enderecos o primeiro. Devido as tabelas possuirem relacionamentos isso se faz necessário. Na sequencia, na próxima tela que se abre, deixe a opção "use existing table" selecionada. Clique em next, na sequencia mantenha o "encoding" como o padrão "utf-8" mantendo inalterado todo o resto. Clique em next e em next novamente. Pronto... os dados estarão carregados. Repita este processo para as demais tabelas.

# Os Scripts abaixo respondem as seguintes perguntas de negócio da pasta "docs":

A - Desempenho Financeiro

B - Gestão e Propriedade

C - Clientes e Segmentação

D - Qualidade e Satisfaçãp

E - Expansã de Mercado

---

-- A - 💰 Desempenho Financeiro
-- Consultas focadas em receita, ticket médio, sazonalidade e ocupação

-- 1. Hospedagens que mais geraram receita no último ano
```sql
SELECT h.hospedagem_id, h.tipo, SUM(a.preco_total) AS receita_total
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
WHERE YEAR(a.data_inicio) = YEAR(CURDATE()) - 1
GROUP BY h.hospedagem_id, h.tipo
ORDER BY receita_total DESC
LIMIT 10;
```

-- 2. Ticket médio por aluguel
```sql
SELECT AVG(preco_total) AS ticket_medio
FROM alugueis;
```

-- 3. Receita mensal (sazonalidade)
```sql
SELECT MONTH(a.data_inicio) AS mes, SUM(a.preco_total) AS receita_mensal
FROM alugueis a
GROUP BY MONTH(a.data_inicio)
ORDER BY mes;
```

-- 4. Taxa de ocupação média das hospedagens ativas
```sql
SELECT h.hospedagem_id, 
       ROUND(SUM(DATEDIFF(a.data_fim, a.data_inicio)) / 365 * 100, 2) AS taxa_ocupacao_percentual
FROM hospedagens h
LEFT JOIN alugueis a ON h.hospedagem_id = a.hospedagem_id
WHERE h.ativo = 1
GROUP BY h.hospedagem_id;
```

-- 5. Receita total por tipo de hospedagem
```sql
SELECT h.tipo, SUM(a.preco_total) AS receita_total
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
```

-- B - 🏠 Gestão de Propriedades
-- Consultas para análise de hospedagens, proprietários e distribuição geográfica

-- 1. Quantidade de hospedagens ativas e inativas
```sql
SELECT ativo, COUNT(*) AS total
FROM hospedagens
GROUP BY ativo;
```

-- 2. Quantidade de hospedagens por tipo
```sql
SELECT tipo, COUNT(*) AS total
FROM hospedagens
GROUP BY tipo;
```

-- 3. Proprietários com maior número de imóveis cadastrados
```sql
SELECT p.nome, COUNT(h.hospedagem_id) AS total_imoveis
FROM hospedagens h
JOIN proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY p.nome
ORDER BY total_imoveis DESC
LIMIT 10;
```

-- 4. Distribuição de imóveis por estado
```sql
SELECT e.estado, COUNT(h.hospedagem_id) AS total_hospedagens
FROM hospedagens h
JOIN enderecos e ON h.endereco_id = e.endereco_id
GROUP BY e.estado
ORDER BY total_hospedagens DESC;
```

-- 5. Distribuição de imóveis por região geográfica
```sql
SELECT rg.regiao, COUNT(h.hospedagem_id) AS total_hospedagens
FROM hospedagens h
JOIN enderecos e ON h.endereco_id = e.endereco_id
JOIN regioes_geograficas rg ON e.estado = rg.estado
GROUP BY rg.regiao
ORDER BY total_hospedagens DESC;
```

-- C - 👥 Segmentação de Clientes
-- Consultas para identificar perfil, recorrência e valor dos clientes

-- 1. Clientes que mais realizaram reservas
```sql
SELECT c.nome, COUNT(a.aluguel_id) AS total_reservas
FROM alugueis a
JOIN clientes c ON a.cliente_id = c.cliente_id
GROUP BY c.nome
ORDER BY total_reservas DESC
LIMIT 10;
```

-- 2. Clientes que geraram maior receita total
```sql
SELECT c.nome, SUM(a.preco_total) AS receita_total
FROM alugueis a
JOIN clientes c ON a.cliente_id = c.cliente_id
GROUP BY c.nome
ORDER BY receita_total DESC
LIMIT 10;
```

-- 3. Distribuição de clientes por estado
```sql
SELECT e.estado, COUNT(DISTINCT a.cliente_id) AS total_clientes
FROM alugueis a
JOIN clientes c ON a.cliente_id = c.cliente_id
JOIN enderecos e ON e.endereco_id = (
  SELECT endereco_id FROM hospedagens h WHERE h.hospedagem_id = a.hospedagem_id LIMIT 1
)
GROUP BY e.estado
ORDER BY total_clientes DESC;
```

-- 4. Clientes recorrentes vs. novos
```sql
SELECT CASE 
         WHEN reservas > 1 THEN 'Recorrente' 
         ELSE 'Novo' 
       END AS tipo_cliente,
       COUNT(*) AS total_clientes
FROM (
  SELECT cliente_id, COUNT(aluguel_id) AS reservas
  FROM alugueis
  GROUP BY cliente_id
) AS t
GROUP BY tipo_cliente;
```

-- 5. Preferência de clientes por tipo de hospedagem
```sql
SELECT c.nome, h.tipo, COUNT(a.aluguel_id) AS reservas
FROM alugueis a
JOIN clientes c ON a.cliente_id = c.cliente_id
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
GROUP BY c.nome, h.tipo
ORDER BY reservas DESC;


GROUP BY h.tipo
ORDER BY receita_total DESC;
```

-- D - ⭐ Qualidade e Satisfação
-- Consultas para analisar notas, avaliações e correlação com preços

-- 1. Nota média por tipo de hospedagem
```sql
SELECT h.tipo, AVG(av.nota) AS nota_media
FROM avaliacoes av
JOIN hospedagens h ON av.hospedagem_id = h.hospedagem_id
GROUP BY h.tipo;
```

-- 2. Hospedagens com melhores avaliações
```sql
SELECT h.hospedagem_id, h.tipo, AVG(av.nota) AS nota_media
FROM avaliacoes av
JOIN hospedagens h ON av.hospedagem_id = h.hospedagem_id
GROUP BY h.hospedagem_id, h.tipo
ORDER BY nota_media DESC
LIMIT 10;
```

-- 3. Hospedagens com piores avaliações
```sql
SELECT h.hospedagem_id, h.tipo, AVG(av.nota) AS nota_media
FROM avaliacoes av
JOIN hospedagens h ON av.hospedagem_id = h.hospedagem_id
GROUP BY h.hospedagem_id, h.tipo
ORDER BY nota_media ASC
LIMIT 10;
```

-- 4. Comentários mais frequentes (palavras-chave)
-- (Dependente de análise de texto, exemplo simples com LIKE)
```sql
SELECT comentario
FROM avaliacoes
WHERE comentario LIKE '%limpeza%' OR comentario LIKE '%atendimento%' OR comentario LIKE '%localização%';
```

-- 5. Correlação entre preço da hospedagem e nota média
```sql
SELECT h.hospedagem_id, AVG(av.nota) AS nota_media, AVG(a.preco_total) AS preco_medio
FROM avaliacoes av
JOIN hospedagens h ON av.hospedagem_id = h.hospedagem_id
JOIN alugueis a ON a.hospedagem_id = h.hospedagem_id
GROUP BY h.hospedagem_id
ORDER BY nota_media DESC;
```

-- E - 🌍 Expansão e Estratégia de Mercado
-- Consultas para identificar oportunidades de crescimento e análise regional

-- 1. Receita total por região geográfica
```sql
SELECT rg.regiao, SUM(a.preco_total) AS receita_total
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN enderecos e ON h.endereco_id = e.endereco_id
JOIN regioes_geograficas rg ON e.estado = rg.estado
GROUP BY rg.regiao
ORDER BY receita_total DESC;
```

-- 2. Quantidade de hospedagens ativas por região
```sql
SELECT rg.regiao, COUNT(h.hospedagem_id) AS total_hospedagens
FROM hospedagens h
JOIN enderecos e ON h.endereco_id = e.endereco_id
JOIN regioes_geograficas rg ON e.estado = rg.estado
WHERE h.ativo = 1
GROUP BY rg.regiao
ORDER BY total_hospedagens DESC;
```

-- 3. Cidades com alta demanda (reservas) e baixa oferta (hospedagens)
```sql
SELECT e.cidade, COUNT(a.aluguel_id) AS total_reservas, COUNT(DISTINCT h.hospedagem_id) AS oferta_hospedagens
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN enderecos e ON h.endereco_id = e.endereco_id
GROUP BY e.cidade
HAVING total_reservas > 10 AND oferta_hospedagens < 5
ORDER BY total_reservas DESC;
```

-- 4. Diferença de preço médio por região
```sql
SELECT rg.regiao, AVG(a.preco_total) AS preco_medio
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN enderecos e ON h.endereco_id = e.endereco_id
JOIN regioes_geograficas rg ON e.estado = rg.estado
GROUP BY rg.regiao
ORDER BY preco_medio DESC;
```
-- 5. Tipos de hospedagem mais vantajosos por região
```sql
SELECT rg.regiao, h.tipo, SUM(a.preco_total) AS receita_total
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN enderecos e ON h.endereco_id = e.endereco_id
JOIN regioes_geograficas rg ON e.estado = rg.estado
GROUP BY rg.regiao, h.tipo
ORDER BY rg.regiao, receita_total DESC;
```
