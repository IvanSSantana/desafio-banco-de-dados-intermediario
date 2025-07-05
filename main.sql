-- QUERY 1
SELECT P.nome_produto, PC.categoria, PE.quantidade
  FROM Produto P
    INNER JOIN Produto_Categoria PC ON P.id_produto = PC.id_produto
    INNER JOIN Produto_Estoque PE ON P.id_produto = PE.id_produto;

-- QUERY 2
DELETE FROM Produto 
    WHERE id_produto IN (
        SELECT P.id_produto 
          FROM Produto P
            INNER JOIN Produto_Categoria PC ON P.id_produto = PC.id_produto
        WHERE PC.categoria = 'Roupas'
)

-- QUERY 3
