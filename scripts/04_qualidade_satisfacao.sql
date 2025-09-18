-- ⭐ Consultas de qualidade e satisfação
SELECT h.tipo, AVG(av.nota) AS nota_media FROM avaliacoes av JOIN hospedagens h ON av.hospedagem_id = h.hospedagem_id GROUP BY h.tipo;