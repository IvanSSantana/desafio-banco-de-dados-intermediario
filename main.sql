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
/* CREATE TABLE Clientes (
    id_cliente INT IDENTITY PRIMARY KEY,
    nome VARCHAR(100),
    genero VARCHAR(1) -- M ou F
) 

INSERT into Clientes (nome, genero) VALUES ('Pedro Velho Teixeira', 'M');
INSERT into Clientes (nome, genero) VALUES ('Olívia Palito Barroca', 'F');
INSERT into Clientes (nome) VALUES ('Itamar Fonseca Oliveira'); */

ALTER TABLE Clientes
ADD Nome_Completo VARCHAR(110);

UPDATE Clientes
SET Nome_Completo =  
(CASE genero
  WHEN 'M' THEN -- Homem
    CONCAT_WS(' ',
      'Sr.', -- Título
      SUBSTRING(nome, 1, PATINDEX('% %', nome)-1),  -- Primeiro nome
      SUBSTRING(nome, (PATINDEX('% %', nome) + 1), 1), -- Meio inicial
      SUBSTRING(SUBSTRING(nome, PATINDEX('% %', nome)+1), -- Nome sem o primeiro
        PATINDEX('% %', SUBSTRING(nome, PATINDEX('% %', nome)+1))+1)) -- Começando do terceiro nome

  WHEN 'F' THEN -- Mulher
  CONCAT_WS(' ',
    'Sra.',
    SUBSTRING(nome, 1, PATINDEX('% %', nome)-1),
    SUBSTRING(nome, (PATINDEX('% %', nome) + 1), 1), 
    SUBSTRING(SUBSTRING(nome, PATINDEX('% %', nome)+1),
      PATINDEX('% %', SUBSTRING(nome, PATINDEX('% %', nome)+1))+1))

ELSE -- Caso não tenha gênero, não terá título
  CONCAT_WS(' ',
    SUBSTRING(nome, 1, PATINDEX('% %', nome)-1),
    SUBSTRING(nome, (PATINDEX('% %', nome) + 1), 1), 
    SUBSTRING(SUBSTRING(nome, PATINDEX('% %', nome)+1),
      PATINDEX('% %', SUBSTRING(nome, PATINDEX('% %', nome)+1))+1))
END)

SELECT * FROM Clientes