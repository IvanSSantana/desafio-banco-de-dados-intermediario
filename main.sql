-- Estruturando as tabelas
CREATE TABLE Produto (
    id_produto INT PRIMARY KEY IDENTITY,
    nome_produto VARCHAR(100)
);

CREATE TABLE Produto_Categoria (
    id_produto INT,
    id_categoria INT,
    categoria VARCHAR(100),
    CONSTRAINT fk_id_pc FOREIGN KEY (id_produto)
    REFERENCES Produto(id_produto)
    ON DELETE CASCADE -- Ao deletar na tabela pai, aqui também deleta
);

CREATE TABLE Produto_Estoque (
    id_produto INT,
    quantidade INT
    -- Removi a foreign key para permitir produtos fora linha, mas no estoque
);

-- Inserindo valores não desejados na query 2
INSERT INTO Produto(nome_produto) VALUES ('Máquina de datilografia 5500x');
INSERT INTO Produto_Categoria(id_produto, id_categoria, categoria)
VALUES (1, 1, 'Eletrônicos');
INSERT INTO Produto_Estoque(id_produto, quantidade) VALUES (1, 24);

-- Inserindo valores requisitados na query 2
INSERT INTO Produto(nome_produto) VALUES ('Camiseta Vulcânica');
INSERT INTO Produto_Categoria(id_produto, id_categoria, categoria)
VALUES (2, 2, 'Roupas');
INSERT INTO Produto_Estoque(id_produto, quantidade) VALUES (2, 100);

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
);

-- QUERY 3 (Solução 1: fatiamento de strings)
-- Estruturação da tabela
CREATE TABLE Clientes (
    id_cliente INT IDENTITY PRIMARY KEY,
    nome VARCHAR(100),
    genero VARCHAR(1) -- M ou F
);

INSERT into Clientes (nome, genero) VALUES ('Pedro Velho Teixeira', 'M');
INSERT into Clientes (nome, genero) VALUES ('Olívia Palito Barroca', 'F');
INSERT into Clientes (nome) VALUES ('Itamar Fonseca Oliveira');

-- O solicitado pelo enunciado
ALTER TABLE Clientes
ADD nome_completo VARCHAR(110);

UPDATE Clientes
SET nome_completo =  
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
END);

SELECT * FROM Clientes;
DROP TABLE Clientes;

-- QUERY 3 (Solução 2: concatenando campos)
-- Estruturação da entidade
CREATE TABLE Clientes (
    id_cliente INT IDENTITY PRIMARY KEY,
    primeiro_nome VARCHAR(50),
    meio_nome VARCHAR(100),
    ultimo_nome VARCHAR(50),
    genero VARCHAR(1) -- M ou F
);

INSERT INTO Clientes (primeiro_nome, meio_nome, ultimo_nome, genero)
  VALUES ('Pedro', 'Augusto', 'Teixeira', 'M');
INSERT INTO Clientes (primeiro_nome, meio_nome, ultimo_nome, genero)
  VALUES ('Maria', 'Palito', 'Pereira', 'F');
INSERT INTO Clientes (primeiro_nome, meio_nome, ultimo_nome)
  VALUES ('Itamar', 'Fonseca', 'Castro');
INSERT INTO Clientes (primeiro_nome, ultimo_nome)
  VALUES ('Marcos', 'Peixe');
INSERT INTO Clientes ()
  VALUES ();

-- Requisitado pelo enunciado
ALTER TABLE Clientes
ADD nome_completo VARCHAR(200);

SELECT
CASE genero
  WHEN 'M' THEN
    CONCAT_WS(' ', 'Sr.', primeiro_nome, 
    SUBSTRING(meio_nome, 1, 1), ultimo_nome)
  WHEN 'F' THEN
    CONCAT_WS(' ', 'Sra.', primeiro_nome, 
    SUBSTRING(meio_nome, 1, 1), ultimo_nome)
  ELSE
    CONCAT_WS(' ', primeiro_nome, 
    SUBSTRING(meio_nome, 1, 1), ultimo_nome)
END
-- Dessa maneira automicamente se adapta a campos nulos
FROM Clientes;

UPDATE Clientes
SET nome_completo =
(CASE genero
  WHEN 'M' THEN
    CONCAT_WS(' ', 'Sr.', primeiro_nome, 
    SUBSTRING(meio_nome, 1, 1), ultimo_nome)
  WHEN 'F' THEN
    CONCAT_WS(' ', 'Sra.', primeiro_nome, 
    SUBSTRING(meio_nome, 1, 1), ultimo_nome)
  ELSE
    CONCAT_WS(' ', primeiro_nome, 
    SUBSTRING(meio_nome, 1, 1), ultimo_nome)
END);

SELECT * FROM Clientes;

