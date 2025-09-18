-- 👥 Consultas de clientes
SELECT c.nome, COUNT(a.aluguel_id) AS reservas FROM alugueis a JOIN clientes c ON a.cliente_id = c.cliente_id GROUP BY c.nome;