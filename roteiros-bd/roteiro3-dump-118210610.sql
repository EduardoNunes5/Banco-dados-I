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

ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_cliente_fk_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT medicamento_fk;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT gerente_fk;
ALTER TABLE ONLY public.venda DROP CONSTRAINT funcionario_fk;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT farmacia_fk;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_endereco_fk_fkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT endereco_fk;
ALTER TABLE ONLY public.endereco_cliente DROP CONSTRAINT endereco_cliente_cliente_fk_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT sede_unica;
ALTER TABLE ONLY public.medicamento DROP CONSTRAINT medicamento_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pk;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_pkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_pkey;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_pkey;
ALTER TABLE ONLY public.endereco_cliente DROP CONSTRAINT endereco_cliente_pkey;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_bairro_key;
ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
ALTER TABLE public.venda ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.medicamento ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.farmacia ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.entrega ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.endereco_cliente ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.endereco ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.venda_id_seq;
DROP TABLE public.venda;
DROP SEQUENCE public.medicamento_id_seq;
DROP TABLE public.medicamento;
DROP TABLE public.funcionario;
DROP SEQUENCE public.farmacia_id_seq;
DROP TABLE public.farmacia;
DROP SEQUENCE public.entrega_id_seq;
DROP TABLE public.entrega;
DROP SEQUENCE public.endereco_id_seq;
DROP SEQUENCE public.endereco_cliente_id_seq;
DROP TABLE public.endereco_cliente;
DROP TABLE public.endereco;
DROP TABLE public.cliente;
DROP TYPE public.tipo_funcionario;
DROP TYPE public.tipo_endereco;
DROP TYPE public.estados_nordeste;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: estados_nordeste; Type: TYPE; Schema: public; Owner: eduardoands
--

CREATE TYPE public.estados_nordeste AS ENUM (
    'Alagoas',
    'Bahia',
    'Ceará',
    'Maranhão',
    'Paraíba',
    'Pernambuco',
    'Piauí',
    'Rio Grande do Norte',
    'Sergipe'
);


ALTER TYPE public.estados_nordeste OWNER TO eduardoands;

--
-- Name: tipo_endereco; Type: TYPE; Schema: public; Owner: eduardoands
--

CREATE TYPE public.tipo_endereco AS ENUM (
    'Residência',
    'Trabalho',
    'Outro'
);


ALTER TYPE public.tipo_endereco OWNER TO eduardoands;

--
-- Name: tipo_funcionario; Type: TYPE; Schema: public; Owner: eduardoands
--

CREATE TYPE public.tipo_funcionario AS ENUM (
    'Farmaceutico',
    'Vendedor',
    'Entregador',
    'Caixa',
    'Administrador'
);


ALTER TYPE public.tipo_funcionario OWNER TO eduardoands;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.cliente (
    nome text NOT NULL,
    cpf character(11) NOT NULL,
    data_nascimento date,
    CONSTRAINT checa_maioridade CHECK ((age((data_nascimento)::timestamp with time zone) > '18 years'::interval))
);


ALTER TABLE public.cliente OWNER TO eduardoands;

--
-- Name: endereco; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.endereco (
    id integer NOT NULL,
    estado public.estados_nordeste NOT NULL,
    cidade text NOT NULL,
    bairro text NOT NULL
);


ALTER TABLE public.endereco OWNER TO eduardoands;

--
-- Name: endereco_cliente; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.endereco_cliente (
    id integer NOT NULL,
    cliente_fk character(11) NOT NULL,
    rua text NOT NULL,
    numero integer,
    cep bigint,
    tipo public.tipo_endereco NOT NULL
);


ALTER TABLE public.endereco_cliente OWNER TO eduardoands;

--
-- Name: endereco_cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: eduardoands
--

CREATE SEQUENCE public.endereco_cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.endereco_cliente_id_seq OWNER TO eduardoands;

--
-- Name: endereco_cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardoands
--

ALTER SEQUENCE public.endereco_cliente_id_seq OWNED BY public.endereco_cliente.id;


--
-- Name: endereco_id_seq; Type: SEQUENCE; Schema: public; Owner: eduardoands
--

CREATE SEQUENCE public.endereco_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.endereco_id_seq OWNER TO eduardoands;

--
-- Name: endereco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardoands
--

ALTER SEQUENCE public.endereco_id_seq OWNED BY public.endereco.id;


--
-- Name: entrega; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.entrega (
    id integer NOT NULL,
    cpf_cliente character(11) NOT NULL,
    endereco_fk integer NOT NULL
);


ALTER TABLE public.entrega OWNER TO eduardoands;

--
-- Name: entrega_id_seq; Type: SEQUENCE; Schema: public; Owner: eduardoands
--

CREATE SEQUENCE public.entrega_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entrega_id_seq OWNER TO eduardoands;

--
-- Name: entrega_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardoands
--

ALTER SEQUENCE public.entrega_id_seq OWNED BY public.entrega.id;


--
-- Name: farmacia; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.farmacia (
    id integer NOT NULL,
    endereco_fk integer,
    nome character varying(20) NOT NULL,
    tipo character varying(6) NOT NULL,
    gerente_fk character varying(11),
    tipo_fun public.tipo_funcionario,
    CONSTRAINT checa_tipo CHECK ((((tipo)::text = 'SEDE'::text) OR ((tipo)::text = 'FILIAL'::text))),
    CONSTRAINT tipo_gerente CHECK ((tipo_fun = ANY (ARRAY['Administrador'::public.tipo_funcionario, 'Farmaceutico'::public.tipo_funcionario])))
);


ALTER TABLE public.farmacia OWNER TO eduardoands;

--
-- Name: farmacia_id_seq; Type: SEQUENCE; Schema: public; Owner: eduardoands
--

CREATE SEQUENCE public.farmacia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farmacia_id_seq OWNER TO eduardoands;

--
-- Name: farmacia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardoands
--

ALTER SEQUENCE public.farmacia_id_seq OWNED BY public.farmacia.id;


--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    nome text NOT NULL,
    tipo public.tipo_funcionario NOT NULL,
    farmacia_fk integer NOT NULL
);


ALTER TABLE public.funcionario OWNER TO eduardoands;

--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.medicamento (
    id integer NOT NULL,
    nome text NOT NULL,
    receitado boolean NOT NULL,
    preco numeric NOT NULL,
    bula text
);


ALTER TABLE public.medicamento OWNER TO eduardoands;

--
-- Name: medicamento_id_seq; Type: SEQUENCE; Schema: public; Owner: eduardoands
--

CREATE SEQUENCE public.medicamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicamento_id_seq OWNER TO eduardoands;

--
-- Name: medicamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardoands
--

ALTER SEQUENCE public.medicamento_id_seq OWNED BY public.medicamento.id;


--
-- Name: venda; Type: TABLE; Schema: public; Owner: eduardoands
--

CREATE TABLE public.venda (
    id integer NOT NULL,
    cliente_fk character(11),
    medicamento_fk integer NOT NULL,
    funcionario_fk character(11) NOT NULL,
    tipo_fun public.tipo_funcionario NOT NULL,
    receitado boolean NOT NULL,
    CONSTRAINT checa_venda_receitada CHECK ((((receitado = true) AND (funcionario_fk IS NOT NULL)) OR (receitado = false))),
    CONSTRAINT checa_vendedor CHECK ((tipo_fun = 'Vendedor'::public.tipo_funcionario))
);


ALTER TABLE public.venda OWNER TO eduardoands;

--
-- Name: venda_id_seq; Type: SEQUENCE; Schema: public; Owner: eduardoands
--

CREATE SEQUENCE public.venda_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.venda_id_seq OWNER TO eduardoands;

--
-- Name: venda_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardoands
--

ALTER SEQUENCE public.venda_id_seq OWNED BY public.venda.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.endereco ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.endereco_cliente ALTER COLUMN id SET DEFAULT nextval('public.endereco_cliente_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.entrega ALTER COLUMN id SET DEFAULT nextval('public.entrega_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.farmacia ALTER COLUMN id SET DEFAULT nextval('public.farmacia_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.medicamento ALTER COLUMN id SET DEFAULT nextval('public.medicamento_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.venda ALTER COLUMN id SET DEFAULT nextval('public.venda_id_seq'::regclass);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: eduardoands
--



--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: eduardoands
--



--
-- Data for Name: endereco_cliente; Type: TABLE DATA; Schema: public; Owner: eduardoands
--



--
-- Name: endereco_cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardoands
--

SELECT pg_catalog.setval('public.endereco_cliente_id_seq', 1, false);


--
-- Name: endereco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardoands
--

SELECT pg_catalog.setval('public.endereco_id_seq', 1, false);


--
-- Data for Name: entrega; Type: TABLE DATA; Schema: public; Owner: eduardoands
--



--
-- Name: entrega_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardoands
--

SELECT pg_catalog.setval('public.entrega_id_seq', 1, false);


--
-- Data for Name: farmacia; Type: TABLE DATA; Schema: public; Owner: eduardoands
--



--
-- Name: farmacia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardoands
--

SELECT pg_catalog.setval('public.farmacia_id_seq', 1, false);


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: eduardoands
--



--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: eduardoands
--



--
-- Name: medicamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardoands
--

SELECT pg_catalog.setval('public.medicamento_id_seq', 1, false);


--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: eduardoands
--



--
-- Name: venda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardoands
--

SELECT pg_catalog.setval('public.venda_id_seq', 1, false);


--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);


--
-- Name: endereco_bairro_key; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_bairro_key UNIQUE (bairro);


--
-- Name: endereco_cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.endereco_cliente
    ADD CONSTRAINT endereco_cliente_pkey PRIMARY KEY (id, cliente_fk);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- Name: entrega_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_pkey PRIMARY KEY (id);


--
-- Name: farmacia_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_pkey PRIMARY KEY (id);


--
-- Name: funcionario_pk; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pk PRIMARY KEY (cpf, tipo);


--
-- Name: medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id, receitado);


--
-- Name: sede_unica; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT sede_unica EXCLUDE USING gist (tipo WITH =) WHERE (((tipo)::text = 'SEDE'::text));


--
-- Name: venda_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id);


--
-- Name: endereco_cliente_cliente_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.endereco_cliente
    ADD CONSTRAINT endereco_cliente_cliente_fk_fkey FOREIGN KEY (cliente_fk) REFERENCES public.cliente(cpf);


--
-- Name: endereco_fk; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT endereco_fk FOREIGN KEY (endereco_fk) REFERENCES public.endereco(id);


--
-- Name: entrega_endereco_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_endereco_fk_fkey FOREIGN KEY (endereco_fk, cpf_cliente) REFERENCES public.endereco_cliente(id, cliente_fk);


--
-- Name: farmacia_fk; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT farmacia_fk FOREIGN KEY (farmacia_fk) REFERENCES public.farmacia(id);


--
-- Name: funcionario_fk; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT funcionario_fk FOREIGN KEY (funcionario_fk, tipo_fun) REFERENCES public.funcionario(cpf, tipo) ON DELETE RESTRICT;


--
-- Name: gerente_fk; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT gerente_fk FOREIGN KEY (gerente_fk, tipo_fun) REFERENCES public.funcionario(cpf, tipo) ON DELETE RESTRICT;


--
-- Name: medicamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT medicamento_fk FOREIGN KEY (medicamento_fk, receitado) REFERENCES public.medicamento(id, receitado);


--
-- Name: venda_cliente_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardoands
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_cliente_fk_fkey FOREIGN KEY (cliente_fk) REFERENCES public.cliente(cpf);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

-- DEVEM FUNCIONAR

INSERT INTO endereco(id, estado, cidade, bairro) VALUES(1,'Paraíba', 'cg', 'ze pinheiro'),
(2,'Paraíba', 'cg', 'malvinas');

-- farmacia pode nao ter um gerente no inicio
INSERT INTO farmacia(id, endereco_fk, nome, tipo) VALUES(1, 1, 'rede pharma', 'SEDE');

INSERT INTO funcionario(cpf, nome, tipo, farmacia_fk) VALUES ('12345678901', 'usuario', 'Vendedor',1),
('12345678902', 'usuario2', 'Entregador',1),
('12345678903', 'usuario3', 'Administrador',1),
('12345678904', 'usuario4', 'Farmaceutico',1);

-Alocando um gerente a farmacia 1
UPDATE farmacia SET gerente_fk = '12345678903', tipo_fun = 'Administrador' WHERE id=1;


INSERT INTO cliente(nome, cpf, data_nascimento) VALUES('cliente', '12345678905', '2002-01-01');
INSERT INTO medicamento(id, nome, receitado, preco, bula) VALUES(1, 'dipimed', FALSE, 3.50, 'um texto de bula');
INSERT INTO venda(id, cliente_fk, medicamento_fk, funcionario_fk, tipo_fun, receitado) VALUES(1,NULL, 1, '12345678901','Vendedor', FALSE);


-- NÃO DEVEM FUNCIONAR

-- ja existe sede
INSERT INTO farmacia VALUES(2, 2, 'rede pharma', 'SEDE', '12345678904', 'Farmaceutico');
-- muito jovem
INSERT INTO cliente VALUES('cliente', '12345678905', '2004-01-01');

-- nao deve funcionar porque espirito santo se encontra fora do nordeste
INSERT INTO endereco VALUES(2, 'Espírito Santo', 'nao sei', '.....');

-- gerente nao eh administrador / farmaceutico
INSERT INTO farmacia VALUES(3,2, 'dias', 'FILIAL', '12345678902', 'Entregador');

-- venda nao pode ser feita por caixa
INSERT INTO venda(id, cliente_fk, medicamento_fk, funcionario_fk, tipo_fun, receitado) VALUES(2,NULL, 1, '12345678902','Caixa', FALSE);

-- colocando um vendedor como gerente não pode pois nao e administrador
UPDATE farmacia SET gerente_fk = '12345678901', tipo_fun = 'Vendedor' WHERE id=1;

-- nao e possivel deletar um funcionario presente em uma venda
DELETE FROM funcionario WHERE cpf = '12345678901';

-- tambem nao e possivel deletar um medicamento presente em uma venda
DELETE FROM medicamento where id = 1;