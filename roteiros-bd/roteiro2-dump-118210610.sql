-- Comentarios 

-- questao 1 --
-- Criacao de uma tabela tarefa com os campos codigo_tarefa(INTEGER),
-- descricao(TEXT), cpf_funcionario (VARCHAR(11)), categoria(INTEGER),
-- estado_tarefa CHAR(1)

-- questao 2 --
-- modifiquei o tipo de codigo_tarefa para big int para realizar a insercao requerida

-- questao 3 --
-- Mudei tipo de categoria para que diminua a faixa de  valores

-- questao 4 --
-- deletei tuplas que possuam pelo menos um atributo NULL
-- adicionei a constraint para nao aceitar null nos campos
-- renomeei os campos da tabela tarefa

-- questao 5 --
-- adicionei uma chave primaria para poder impedir tarefas com o mesmo codigo

-- questao 6 --

-- A -- adicionei uma constraint check para garantir o tamanho do cpf ser 11

-- B -- modifiquei os status das tarefas para serem P (pendente), E (executando) ou C (concluida),
--      antes A, R ou F.

-- questao 7 -- 
-- onde a prioridade era maior que 5, atualizei para que fosse 5
-- defini uma constraint para a prioridade ficar numa faixa de 0 a 5

-- questao 8 --
-- Criei uma tabela funcionario com os campos:
-- cpf (varchar(11)), data_nasc tipo data sem poder ser nulo, nome tipo texto,
-- funcao VARCHAR(11) nao nulável,- nivel CHAR(1) nao nulo e superior_cpf VARCHAR(11).
-- defini constraint para o nível poder ser J, P ou S apenas
-- também defini constraint para a funcao do funcionario ser LIMPEZA ou SUP_LIMPEZA
-- outra constraint para caso o funcionario seja de limpeza, o superior nao pode ser null

-- questao 9 -- 
-- fiz as inserções e fiz 10 inserções que colidem com as constraints.

-- questão 10 -- 
-- tentei deletar valores e obtive
--DELETE FROM funcionario WHERE cpf = '07232774001';
-- DETAIL:  Key (cpf)=(07232774001) is still referenced from table "funcionario".

-- DELETE FROM funcionario WHERE cpf = '32323232955';
-- DETAIL:  Key (cpf)=(32323232955) is still referenced from table "tarefas".

-- criei uma chave estrangeira de tarefa para funcionario com delete em cascata

-- questao 11 --
-- adicionei a constraint para o func_resp_cpf poder ser null apenas se o status for P ou C
-- adicionei on delete set null
-- obtive
-- ERROR:  new row for relation "tarefas" violates check constraint "func_idnull"
-- DETAIL:  Failing row contains (2147483647, limpar janelas da sala 203, null, 1, C).
-- CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1::pg_catalog.text OPERATOR(pg_catalog.=) "func_resp_cpf"::pg_catalog.text"




--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.24
-- Dumped by pg_dump version 9.5.24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.funcionario DROP CONSTRAINT fk_funcionario;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT fk_func;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT pk_tarefas;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.funcionario (
    cpf character varying(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(120) NOT NULL,
    funcao character varying(11) NOT NULL,
    nivel character(1) NOT NULL,
    superior_cpf character varying(11),
    CONSTRAINT check_cpf CHECK ((length((cpf)::text) = 11)),
    CONSTRAINT check_func CHECK ((((funcao)::text = 'LIMPEZA'::text) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT check_rol CHECK (((nivel = 'J'::bpchar) OR (nivel = 'P'::bpchar) OR (nivel = 'S'::bpchar))),
    CONSTRAINT check_sup CHECK (((((funcao)::text = 'LIMPEZA'::text) AND (superior_cpf IS NOT NULL)) OR (((funcao)::text = 'SUP_LIMPEZA'::text) AND (superior_cpf IS NULL))))
);


ALTER TABLE public.funcionario OWNER TO eduardoands;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao text NOT NULL,
    func_resp_cpf character varying(11),
    prioridade smallint NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT checa_tamanho_cpf CHECK ((length((func_resp_cpf)::text) = 11)),
    CONSTRAINT check_prior CHECK (((prioridade >= 0) AND (prioridade <= 5))),
    CONSTRAINT func_idnull CHECK (((((status = 'C'::bpchar) OR (status = 'E'::bpchar)) AND (func_resp_cpf IS NOT NULL)) OR (status = 'P'::bpchar)))
);


ALTER TABLE public.tarefas OWNER TO eduardoands;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: eduardoands
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('07393368005', '1999-05-19', 'Pedro Too', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('26216065041', '2002-06-19', 'Marie Burkhardt', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('56221089000', '2005-03-21', 'Akai Ferreira', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('07232774001', '1988-08-09', 'Socorro Jesus', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('23149951046', '1995-09-30', 'Alex Stuff', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('25654948911', '1999-07-19', 'Ersin Monteiro', 'LIMPEZA', 'J', '07393368005');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('82325382010', '1998-06-05', 'Clour Much', 'LIMPEZA', 'S', '26216065041');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('52247084001', '2000-09-30', 'Enwoa Sousa', 'LIMPEZA', 'P', '56221089000');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('91373226056', '1970-05-25', 'Gioki Yamashiro', 'LIMPEZA', 'J', '07232774001');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('82857914083', '1988-11-17', 'Hilda Silva', 'LIMPEZA', 'S', '23149951046');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955', '1993-01-11', 'Ewor', 'LIMPEZA', 'J', '26216065041');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232911', '1988-08-09', 'Socorro Jesus', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '1988-08-09', 'MARIO', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '1988-08-01', 'LUIGI', 'SUP_LIMPEZA', 'S', NULL);


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: eduardoands
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483651, 'limpar portas do 1o andar', '32323232911', 5, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483652, 'limpar portas do 2o andar', '32323232911', 5, 'P');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: pk_tarefas; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT pk_tarefas PRIMARY KEY (id);


--
-- Name: fk_func; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT fk_func FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- Name: fk_funcionario; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT fk_funcionario FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf);


--
-- PostgreSQL database dump complete
--

