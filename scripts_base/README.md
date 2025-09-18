# Scripts Base\n\nPasta destinada aos scripts fundamentais e de configuração do projeto.

-- 💰 Desempenho Financeiro
-- Consultas focadas em receita, ticket médio, sazonalidade e ocupação

-- 1. Hospedagens que mais geraram receita no último ano
SELECT h.hospedagem_id, h.tipo, SUM(a.preco_total) AS receita_total
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
WHERE YEAR(a.data_inicio) = YEAR(CURDATE()) - 1
GROUP BY h.hospedagem_id, h.tipo
ORDER BY receita_total DESC
LIMIT 10;

-- 2. Ticket médio por aluguel
SELECT AVG(preco_total) AS ticket_medio
FROM alugueis;

-- 3. Receita mensal (sazonalidade)
SELECT MONTH(a.data_inicio) AS mes, SUM(a.preco_total) AS receita_mensal
FROM alugueis a
GROUP BY MONTH(a.data_inicio)
ORDER BY mes;

-- 4. Taxa de ocupação média das hospedagens ativas
SELECT h.hospedagem_id, 
       ROUND(SUM(DATEDIFF(a.data_fim, a.data_inicio)) / 365 * 100, 2) AS taxa_ocupacao_percentual
FROM hospedagens h
LEFT JOIN alugueis a ON h.hospedagem_id = a.hospedagem_id
WHERE h.ativo = 1
GROUP BY h.hospedagem_id;

-- 5. Receita total por tipo de hospedagem
SELECT h.tipo, SUM(a.preco_total) AS receita_total
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
GROUP BY h.tipo
ORDER BY receita_total DESC;

