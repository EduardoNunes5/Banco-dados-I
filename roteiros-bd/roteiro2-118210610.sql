-- roteiro 2 - Eduardo Afonso Nunes da Silva

-- questao 1 --
-- Criacao de uma tabela com os campos codigo_tarefa(INTEGER),
-- descricao(TEXT), cpf_funcionario (VARCHAR(11)), categoria(INTEGER),
-- estado_tarefa CHAR(1)

CREATE TABLE tarefas(
    codigo_tarefa INTEGER,
    descricao TEXT,
    cpf_funcionario VARCHAR(11),
    categoria INTEGER,
    estado_tarefa CHAR(1)
    );

-- Questão 1 --
INSERT INTO tarefas VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F'); 

 INSERT INTO tarefas VALUES (2147483647, 'limpar janelas da sala 203','98765432122', 1 , 'F');

 INSERT INTO tarefas VALUES (null, null, null, null, null);
--nao aceitar
INSERT INTO tarefas VALUES (2147483643, 'limpar chão do corredor superior','987654323211', 0, 'F');
--nao aceitar
INSERT INTO tarefas VALUES (2147483646, 'limpar chão do corredor superior','98765432321', 0, 'FF');
-- Questao 1 fim --

-- Questao 2
--alterar o tipo para bigint pois o valor do codigo saiu da faixa do INTEGER
ALTER TABLE tarefas ALTER COLUMN codigo_tarefa TYPE BIGINT;

INSERT INTO tarefas VALUES (2147483648, 'limpar portas do térreo','32323232955', 4, 'A');
-- Questao 2 fim

-- Questao 3 
-- Mudar tipo de categoria para que diminua a faixa de  valores
ALTER TABLE tarefas ALTER COLUMN categoria TYPE SMALLINT;
--nao aceitar
INSERT INTO tarefas VALUES (2147483649, 'limpar portas da entrada principal','32322525199', 32768, 'A');
--nao aceitar
INSERT INTO tarefas VALUES (2147483650, 'limpar janelas da entrada principal','32333233288', 32769, 'A');

INSERT INTO tarefas VALUES (2147483651, 'limpar portas do 1o andar','32323232911', 32767, 'A');

INSERT INTO tarefas VALUES (2147483652, 'limpar portas do 2o andar','32323232911', 32766, 'A');
-- Questao 3 fim --


--Questao 4

--deletando tuplas que possuam pelo menos um atributo NULL
DELETE FROM tarefas WHERE codigo_tarefa IS NULL OR descricao IS NULL OR cpf_funcionario IS NULL
    or categoria IS NULL OR estado_tarefa IS NULL;

--impedindo colunas com valor null
ALTER TABLE tarefas
    ALTER COLUMN codigo_tarefa SET NOT NULL,
    ALTER COLUMN descricao SET NOT NULL,
    ALTER COLUMN cpf_funcionario SET NOT NULL,
    ALTER COLUMN categoria SET NOT NULL,
    ALTER COLUMN estado_tarefa SET NOT NULL;
--renomeando as colunas 
ALTER TABLE tarefas RENAME COLUMN codigo_tarefa TO id;
ALTER TABLE tarefas RENAME COLUMN cpf_funcionario TO func_resp_cpf;
ALTER TABLE tarefas RENAME COLUMN categoria TO prioridade;
ALTER TABLE tarefas RENAME COLUMN estado_tarefa to status;

-- Questão 4 fim --

-- Questão 5 --
INSERT INTO tarefas VALUES(2147483653, 'limpar portas do 1o andar','32323232911', 2, 'A');

-- adicionando chave primaria para impedir criacao de novas tarefas com mesmo codigo
ALTER TABLE tarefas ADD CONSTRAINT pk_tarefas PRIMARY KEY (id);
--nao aceitar
INSERT INTO tarefas VALUES(2147483653, 'aparar gramas da área frontal','32323232911',3, 'A');

-- Questão 5 fim --

-- Questão 6
-- A
ALTER TABLE tarefas ADD CONSTRAINT checa_tamanho_cpf CHECK(LENGTH(func_resp_cpf) = 11);
--nao aceitar
INSERT INTO tarefas values(561564898, 'trancar portas do 2o andar','149432745889', 4, 'F');

INSERT INTO tarefas values(561564, 'trancar portas do 1o andar','149432', 4, 'F');
-- A fim

-- B --

UPDATE tarefas SET status = 'P' where status = 'A';
UPDATE tarefas SET status = 'C' where status = 'F';

ALTER TABLE tarefas ADD CONSTRAINT check_stat_PEC CHECK(status = 'P' OR status = 'E' OR status = 'C');

--testando constraint
--INSERT INTO tarefas VALUES (1312151, 'tarefa qualquer', '14945381654', 3, 'F');
-- B fim --


-- Questão 7 --

UPDATE tarefas SET prioridade = 5 WHERE prioridade > 5;

ALTER TABLE tarefas ADD CONSTRAINT check_prior CHECK(prioridade >= 0 AND prioridade <= 5);

--tests
--INSERT INTO tarefas VALUES (2412516, 'tarefa qualquer 2', '54128295978', -1, 'P');
--INSERT INTO tarefas VALUES (2412516, 'tarefa qualquer 2', '54128295978', 6, 'P');

-- 7 fim --

-- Questão 8 --

CREATE TABLE funcionario(
    cpf VARCHAR(11) PRIMARY KEY,
    data_nasc DATE NOT NULL,
    nome TEXT,
    funcao VARCHAR(11) NOT NULL,
    nivel CHAR(1) NOT NULL,
    superior_cpf VARCHAR(11),     
    CONSTRAINT check_rol  CHECK(nivel = 'J' OR nivel = 'P' OR nivel = 'S'),
    CONSTRAINT check_func CHECK(funcao = 'LIMPEZA' OR funcao = 'SUP_LIMPEZA'),
    CONSTRAINT check_sup CHECK((funcao = 'LIMPEZA' AND superior_cpf IS NOT NULL) or funcao = 'SUP_LIMPEZA' AND superior_cpf IS NULL)
);

ALTER TABLE funcionario ADD CONSTRAINT fk_funcionario FOREIGN KEY (superior_cpf) REFERENCES funcionario(cpf);
ALTER TABLE funcionario ALTER COLUMN nome TYPE VARCHAR(120);
ALTER TABLE funcionario ALTER COLUMN nome SET NOT NULL;
ALTER TABLE funcionario ADD CONSTRAINT check_cpf CHECK(LENGTH(cpf) = 11);


INSERT INTO funcionario (cpf,data_nasc, nome, funcao, nivel, superior_cpf) VALUES('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA','S', null);


INSERT INTO funcionario (cpf,data_nasc, nome, funcao, nivel, superior_cpf) VALUES('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
--nao funcionar
INSERT INTO funcionario (cpf,data_nasc, nome, funcao, nivel, superior_cpf) VALUES('12345678913', '1980-04-09', 'joao da silva', 'LIMPEZA', 'J', null);

-- Questao 8 fim --

-- Questão 9 --

INSERT INTO funcionario VALUES('07393368005', '1999-05-19', 'Pedro Too', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO funcionario VALUES('26216065041', '2002-06-19', 'Marie Burkhardt', 'SUP_LIMPEZA', 'J',NULL);
INSERT INTO funcionario VALUES('56221089000', '2005-03-21', 'Akai Ferreira', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO funcionario VALUES('07232774001', '1988-08-09', 'Socorro Jesus', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO funcionario VALUES('23149951046', '1995-09-30', 'Alex Stuff', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO funcionario VALUES('25654948911', '1999-07-19', 'Ersin Monteiro', 'LIMPEZA', 'J', '07393368005');
INSERT INTO funcionario VALUES('82325382010', '1998-06-05', 'Clour Much', 'LIMPEZA', 'S','26216065041');
INSERT INTO funcionario VALUES('52247084001', '2000-09-30', 'Enwoa Sousa', 'LIMPEZA', 'P', '56221089000');
INSERT INTO funcionario VALUES('91373226056', '1970-05-25', 'Gioki Yamashiro', 'LIMPEZA', 'J', '07232774001');
INSERT INTO funcionario VALUES('82857914083', '1988-11-17', 'Hilda Silva', 'LIMPEZA', 'S', '23149951046');

--n pegar todos --
INSERT INTO funcionario VALUES('07393368045', '1999-05-19', 'Pedro Too', 'SUP_LIMPEZA', 'P', '07393368005'); 
--sup nao pode ter sup

INSERT INTO funcionario VALUES('82857914083', '1988-11-17', 'Hilda S.', 'LIMPEZA', 'S', '23149951046');
-- ja existe

INSERT INTO funcionario VALUES('56221049000', '2005-03-21', null, 'SUP_LIMPEZA', 'S', NULL); 
--atributo null

INSERT INTO funcionario VALUES('07232774031', null, 'Socorro Jesus', 'SUP_LIMPEZA', 'P', NULL); 
--data nascimento null

INSERT INTO funcionario VALUES(null, '1995-09-30', 'Alex Stuff', 'SUP_LIMPEZA', 'J', NULL); 
--cpf null

 INSERT INTO funcionario VALUES('25654948911', '1999-07-19', 'Ersin Monteiro', 'LIMPEZA', 'J', null); 
--limpeza precisa de superior

INSERT INTO funcionario VALUES('8232038201', '1998-06-05', 'Clour Much', 'LIMPEZA', 'S','07232774001');
--cpf invalido (10 caracteres)

INSERT INTO funcionario VALUES('52249084001', '2000-09-30', 'Enwoa Sousa', 'LIMPEZA', 'L', '5622108900');
--nivel (senior, pleno, jr) invalido

INSERT INTO funcionario VALUES('91373526056', '1970-05-25', 'Gioki Yamashiro', 'LIMPEZA', 's', '07232774001');
-- nivel invalido

INSERT INTO funcionario VALUES('82857910083', '1988-11-17', 'Hilda Silva', 'LIMPEZA', 'A', '82857914083');
-- nivel invalido

--Questão 9 Fim -- 

-- Questão 10 --

INSERT INTO funcionario VALUES ('32323232955', '1993-01-11', 'Ewor', 'LIMPEZA', 'J', '26216065041');
INSERT INTO funcionario VALUES('32323232911', '1988-08-09', 'Socorro Jesus', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO funcionario VALUES('98765432111', '1988-08-09', 'MARIO', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO funcionario VALUES('98765432122', '1988-08-1', 'LUIGI', 'SUP_LIMPEZA', 'S', NULL);


ALTER TABLE tarefas ADD CONSTRAINT fk_func FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE CASCADE;


--DELETE FROM funcionario WHERE cpf = '12345678911'; funcionou

ALTER TABLE tarefas DROP CONSTRAINT fk_func;
ALTER TABLE tarefas ADD CONSTRAINT fk_func FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE RESTRICT;

--DELETE FROM funcionario WHERE cpf = '07232774001';
-- DETAIL:  Key (cpf)=(07232774001) is still referenced from table "funcionario".

-- DELETE FROM funcionario WHERE cpf = '32323232955';
-- DETAIL:  Key (cpf)=(32323232955) is still referenced from table "tarefas".

-- Questão 10 fim --

-- Questao 11 --

ALTER TABLE tarefas ALTER COLUMN func_resp_cpf DROP NOT NULL;

ALTER TABLE tarefas DROP CONSTRAINT check_stat_pec;
ALTER TABLE tarefas ADD CONSTRAINT func_idnull CHECK (((status = 'C' OR status = 'E') AND func_resp_cpf IS NOT NULL) OR status = 'P') ;


ALTER TABLE tarefas DROP CONSTRAINT fk_func;
ALTER TABLE tarefas ADD CONSTRAINT fk_func FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE SET NULL;

--INSERT INTO funcionario VALUES ('11111111111', '1975-04-12', 'alguem aleatorio', 'SUP_LIMPEZA', 'S', NULL);
--INSERT INTO tarefas VALUES(126546547, 'trancar portas 3o andar', '11111111111', 0, 'E');
DELETE FROM funcionario WHERE cpf = '11111111111';
--DELETE FROM funcionario WHERE cpf = '11111111111';
--CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas"
-- SET "func_resp_cpf" = NULL WHERE $1::pg_catalog.text OPERATOR(pg_catalog.=) "func_resp_cpf"::pg_catalog.text"
