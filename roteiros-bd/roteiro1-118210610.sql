-- roteiro 1 - Eduardo Afonso Nunes da Silva

---------- 2 COMECO ----------
-- placa do automovel simplificada
CREATE TABLE automovel(
    marca VARCHAR(20),
    modelo VARCHAR(15),
    placa VARCHAR(7),
    preco NUMERIC,
    ano SMALLINT
);


CREATE TABLE segurado(
    nome VARCHAR(100),
    cpf VARCHAR(11),
    idade SMALLINT,
    data_nascimento DATE
);

CREATE TABLE perito(
    nome VARCHAR(100),
    cpf VARCHAR(11),
    idade SMALLINT,
    data_nascimento DATE

);

CREATE TABLE oficina(
    nome VARCHAR(20),
    data_criacao DATE
);

CREATE TABLE seguro(
    data_criacao DATE,
    data_expiracao DATE,
    tipo_seguro SMALLINT
);

CREATE TABLE sinistro(
    descricao_ocorrido TEXT,
    local_ocorrido VARCHAR(30),
    data_ocorrida DATE
);

CREATE TABLE pericia(
    descricao TEXT,
    tipo_ocorrencia SMALLINT
);

CREATE TABLE reparo(
    preco NUMERIC,
    descricao TEXT
);

---------------- 2 FIM ----------------

---------------- 3 COMECO -------------

ALTER TABLE automovel ADD COLUMN automovel_pk SERIAL;
ALTER TABLE automovel ADD PRIMARY KEY (automovel_pk);


ALTER TABLE segurado ADD PRIMARY KEY (cpf);
ALTER TABLE perito ADD PRIMARY KEY (cpf);

ALTER TABLE oficina ADD COLUMN oficina_pk SERIAL;
ALTER TABLE oficina ADD PRIMARY KEY (oficina_pk);

ALTER TABLE seguro ADD COLUMN seguro_pk SERIAL;
ALTER TABLE seguro ADD PRIMARY KEY (seguro_pk);

ALTER TABLE sinistro ADD COLUMN sinistro_pk SERIAL;
ALTER TABLE sinistro ADD PRIMARY KEY (sinistro_pk);


ALTER TABLE pericia ADD COLUMN pericia_pk SERIAL;
ALTER TABLE pericia ADD PRIMARY KEY (pericia_pk);

ALTER TABLE reparo ADD COLUMN reparo_pk SERIAL;
ALTER TABLE reparo ADD PRIMARY KEY (reparo_pk);

---------------- 3 FIM -------------



---------------- 4 COMECO ----------

-- considerei o seguro ser ligado a um automovel e a um segurado, assim o automovel pode ser ligado a diferentes segurados

ALTER TABLE seguro ADD COLUMN segurado_fk VARCHAR(11);
ALTER TABLE seguro ADD COLUMN automovel_fk INTEGER;
ALTER TABLE seguro ADD CONSTRAINT segurado_fk FOREIGN KEY (segurado_fk)
REFERENCES segurado(cpf);
ALTER TABLE seguro ADD CONSTRAINT automovel_fk FOREIGN KEY (automovel_fk)
REFERENCES automovel(automovel_pk);

-- nao sei muito bem o que e um sinistro, levei em consideração que precisa de um seguro.
ALTER TABLE sinistro ADD COLUMN seguro_fk SERIAL;
ALTER TABLE sinistro ADD CONSTRAINT seguro_fk FOREIGN KEY (seguro_fk)
REFERENCES seguro (seguro_pk);


-- pericia eh realizada por um perito e em um automovel especifico
ALTER TABLE pericia ADD COLUMN perito_fk VARCHAR(11);
ALTER TABLE pericia ADD CONSTRAINT perito_fk FOREIGN KEY (perito_fk)
REFERENCES perito(cpf);

ALTER TABLE pericia ADD COLUMN automovel_fk INTEGER;
ALTER TABLE pericia ADD CONSTRAINT automovel_fk FOREIGN KEY (automovel_fk)
REFERENCES automovel(automovel_pk);

-- reparo realizado em um automovel e tb em uma oficina

ALTER TABLE reparo ADD COLUMN automovel_fk INTEGER;
ALTER TABLE reparo ADD CONSTRAINT automovel_fk FOREIGN KEY (automovel_fk)
REFERENCES automovel(automovel_pk);

ALTER TABLE reparo ADD COLUMN oficina_fk INTEGER;
ALTER TABLE reparo ADD CONSTRAINT oficina_fk FOREIGN KEY (oficina_fk)
REFERENCES oficina(oficina_pk);

---------------- 4 FIM    ----------

---------------- 5 e 6 COMECO ----------

DROP TABLE IF EXISTS sinistro;
DROP TABLE IF EXISTS seguro;
DROP TABLE IF EXISTS segurado;
DROP TABLE IF EXISTS pericia;
DROP TABLE IF EXISTS perito;
DROP TABLE IF EXISTS reparo;
DROP TABLE IF EXISTS oficina;
DROP TABLE IF EXISTS automovel;

---------------- 5 e 6 fim -------------

---------------- 7 COMECO -------------

CREATE TABLE automovel(
    automovel_pk SERIAL PRIMARY KEY;
    marca VARCHAR(20),
    modelo VARCHAR(15),
    placa VARCHAR(7),
    preco NUMERIC,
    ano SMALLINT
);

CREATE TABLE segurado(
    nome VARCHAR(100),
    cpf VARCHAR(11) PRIMARY KEY,
    idade SMALLINT,
    data_nascimento DATE
);

CREATE TABLE perito(
    nome VARCHAR(100),
    cpf VARCHAR(11) PRIMARY KEY,
    idade SMALLINT,
    data_nascimento DATE
);

CREATE TABLE oficina(
    oficina SERIAL PRIMARY KEY,
    nome VARCHAR(20),
    data_criacao DATE
);

CREATE TABLE seguro(
    seguro_pk SERIAL PRIMARY KEY,
    data_criacao DATE,
    data_expiracao DATE,
    tipo_seguro SMALLINT CONSTRAINT checa_tipo CHECK(tipo_seguro = 1 OR tipo_seguro = 2 OR tipo_seguro = 3),
    segurado_fk VARCHAR(11) NOT NULL REFERENCES segurado(cpf),
    automovel_fk INTEGER NOT NULL REFERENCES automovel(automovel_pk)
);

CREATE TABLE sinistro(
    sinistro_pk SERIAL PRIMARY KEY,
    descricao_ocorrido TEXT,
    local_ocorrido VARCHAR(30),
    data_ocorrida DATE,
    seguro_fk INTEGER NOT NULL REFERENCES seguro(seguro_pk)
);

CREATE TABLE pericia(
    pericia_pk SERIAL PRIMARY KEY,
    perito_fk VARCHAR(11) NOT NULL REFERENCES perito(cpf);
    automovel_fk SERIAL NOT NULL REFERENCES automovel(automovel_pk),
    descricao TEXT
);

CREATE TABLE reparo(
    preco NUMERIC,
    descricao TEXT
);


