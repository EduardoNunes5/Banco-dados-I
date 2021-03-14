CREATE TYPE tipo_funcionario AS ENUM('Farmaceutico', 'Vendedor',
'Entregador', 'Caixa', 'Administrador');
CREATE TYPE estados_nordeste AS ENUM ('Alagoas', 'Bahia', 'Ceará', 'Maranhão', 'Paraíba', 'Pernambuco', 'Piauí', 'Rio Grande do Norte', 'Sergipe'); 

CREATE TABLE endereco(
    id SERIAL PRIMARY KEY,
    estado estados_nordeste NOT NULL,
    cidade TEXT NOT NULL,
    bairro TEXT NOT NULL UNIQUE
);

CREATE TABLE funcionario(
    cpf CHAR(11) PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE farmacia(
    id SERIAL PRIMARY KEY,
    endereco_fk INTEGER,
    nome VARCHAR(20) NOT NULL,
    CONSTRAINT endereco_fk FOREIGN KEY (endereco_fk) REFERENCES endereco(id)    
);

-- QUESTAO 1 --
ALTER TABLE farmacia ADD COLUMN tipo VARCHAR(6) NOT NULL,
ADD CONSTRAINT checa_tipo CHECK (tipo = 'SEDE' or tipo = 'FILIAL');
-- QUESTAO 2 --
ALTER TABLE funcionario ADD COLUMN tipo tipo_funcionario NOT NULL;
-- QUESTAO 3, 5 --
ALTER TABLE funcionario ADD COLUMN farmacia_fk INTEGER NOT NULL;
ALTER TABLE funcionario ADD CONSTRAINT farmacia_fk FOREIGN KEY (farmacia_fk) REFERENCES farmacia(id);

-- QUESTAO 4 --
ALTER TABLE farmacia ADD COLUMN gerente_fk VARCHAR(11);
ALTER TABLE farmacia ADD CONSTRAINT gerente_fk FOREIGN KEY (gerente_fk) REFERENCES funcionario(cpf);


-- QUESTAO 6 --
CREATE TABLE cliente(
    nome TEXT NOT NULL,
    cpf CHAR(11) PRIMARY KEY,
    data_nascimento DATE
);


CREATE TABLE endereco_cliente(
    id SERIAL,
    cliente_fk CHAR(11) NOT NULL REFERENCES cliente(cpf),
    rua TEXT NOT NULL,
    numero INTEGER,
    cep BIGINT,
    primary key (id, cliente_fk)
);

-- QUESTAO 7 --
CREATE TYPE tipo_endereco AS ENUM ('Residência', 'Trabalho', 'Outro');
ALTER TABLE endereco_cliente ADD COLUMN tipo tipo_endereco NOT NULL;

-- QUESTAO 8 --

CREATE TABLE medicamento(
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    receitado BOOLEAN NOT NULL,
    preco NUMERIC NOT NULL,
    bula TEXT
);

-- QUESTAO 9 e 10--
CREATE TABLE entrega(
    id SERIAL PRIMARY KEY,
    cpf_cliente CHAR(11) NOT NULL,
    endereco_fk INTEGER NOT NULL,
    FOREIGN KEY (endereco_fk, cpf_cliente) REFERENCES endereco_cliente(id, cliente_fk)
);

CREATE TABLE venda(
    id SERIAL PRIMARY KEY,
    cliente_fk CHAR(11) REFERENCES cliente(cpf),
    medicamento_fk INTEGER NOT NULL REFERENCES medicamento(id),
    funcionario_fk CHAR(11) NOT NULL REFERENCES funcionario(cpf)
);

-- QUESTAO 11 --

ALTER TABLE venda DROP CONSTRAINT venda_funcionario_fk_fkey,
ADD CONSTRAINT funcionario_fk FOREIGN KEY (funcionario_fk) REFERENCES funcionario(cpf) ON DELETE RESTRICT;

-- QUESTAO 12 --
ALTER TABLE venda DROP CONSTRAINT venda_medicamento_fk_fkey,
ADD CONSTRAINT medicamento_fk FOREIGN KEY (medicamento_fk) REFERENCES medicamento(id) ON DELETE RESTRICT;

-- QUESTAO 13 --

ALTER TABLE cliente ADD CONSTRAINT checa_maioridade check(AGE(data_nascimento) > '18 years');


-- QUESTAO 14 --
-- DECLARADA NA CRIACAO DA TABELA FARMACIA COM UNIQUE

-- QUESTAO 15 --
ALTER TABLE farmacia ADD CONSTRAINT sede_unica EXCLUDE USING gist(tipo with=) WHERE (tipo='SEDE');

-- QUESTAO 16 --
-- REMOVENDO FOREIGN KEYS DEPENDENTES  DE FUNCIONARIO PARA ADICIONAR UMA COLUNA REDUNDANTE E TRANSFROMA-LA EM PRIMARY KEY
ALTER TABLE venda DROP CONSTRAINT funcionario_fk,
ADD COLUMN tipo_fun tipo_funcionario NOT NULL;
ALTER TABLE farmacia DROP CONSTRAINT gerente_fk,
ADD COLUMN tipo_fun tipo_funcionario;
ALTER TABLE funcionario DROP CONSTRAINT funcionario_pkey,
ADD CONSTRAINT funcionario_pk PRIMARY KEY (cpf, tipo);

-- ATUALIZANDO NOVAS FOREIGN KEYS APONTANDO PARA FUNCIONARIO, TIPO E CPF
ALTER TABLE venda ADD CONSTRAINT funcionario_fk FOREIGN KEY (funcionario_fk, tipo_fun) REFERENCES funcionario(cpf, tipo) ON DELETE RESTRICT;
ALTER TABLE farmacia ADD CONSTRAINT gerente_fk FOREIGN KEY (gerente_fk, tipo_fun) REFERENCES funcionario(cpf, tipo) ON DELETE RESTRICT;

ALTER TABLE farmacia ADD CONSTRAINT tipo_gerente CHECK(tipo_fun in('Administrador', 'Farmaceutico'));

-- QUESTAO 17 --
-- REMOVENDO FK DEPENDEDENTE DE MEDICAMENTO PARA FAZER VERIFICAR SE ELE E RECEITADO ATRAVES DE UMA NOVA PRIMARY KEY.
ALTER TABLE VENDA drop constraint medicamento_fk; 

ALTER TABLE medicamento DROP CONSTRAINT medicamento_pkey,
ADD PRIMARY KEY (id, receitado);


ALTER TABLE venda ADD COLUMN receitado BOOLEAN NOT NULL,
ADD CONSTRAINT medicamento_fk FOREIGN KEY (medicamento_fk, receitado) REFERENCES medicamento(id, receitado),
ADD CONSTRAINT checa_venda_receitada CHECK ((receitado = TRUE AND funcionario_fk IS NOT NULL) OR (receitado = FALSE));


-- QUESTAO 18 --

ALTER TABLE venda ADD CONSTRAINT checa_vendedor CHECK(tipo_fun = 'Vendedor');

-- QUESTAO 19 -- 
-- FOI DECLARADA NA CRIACAO DA TABELA DE ENDERECO;



