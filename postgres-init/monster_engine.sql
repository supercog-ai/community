--
-- PostgreSQL database dump
--

-- Dumped from database version 14.13 (Homebrew)
-- Dumped by pg_dump version 14.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: monster_engine; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE monster_engine WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C';


\connect monster_engine

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: agents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agents (
    id character varying NOT NULL,
    name character varying NOT NULL,
    user_id character varying,
    tenant_id character varying,
    description character varying,
    system_prompt character varying,
    model character varying,
    input_mode character varying NOT NULL,
    trigger character varying NOT NULL,
    welcome_message character varying,
    tools character varying,
    trigger_arg character varying,
    agent_slug character varying,
    temperature double precision,
    max_agent_time integer,
    memories_json character varying,
    implicit_tools character varying,
    max_chat_length integer,
    state character varying
);


--
-- Name: compressedhistorymessage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compressedhistorymessage (
    id integer NOT NULL,
    compressed_id character varying NOT NULL,
    original_content character varying NOT NULL,
    compressed_content character varying NOT NULL,
    message_type character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    tokens_original integer NOT NULL,
    tokens_compressed integer NOT NULL,
    compression_ratio double precision NOT NULL,
    compression_algorithm character varying NOT NULL
);


--
-- Name: compressedhistorymessage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compressedhistorymessage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compressedhistorymessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compressedhistorymessage_id_seq OWNED BY public.compressedhistorymessage.id;


--
-- Name: credentials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credentials (
    id character varying NOT NULL,
    name character varying NOT NULL,
    user_id character varying,
    tenant_id character varying NOT NULL,
    scope character varying NOT NULL,
    tool_factory_id character varying NOT NULL,
    secrets_json character varying
);


--
-- Name: emailmsgsprocessed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.emailmsgsprocessed (
    uid character varying NOT NULL,
    from_field character varying NOT NULL,
    to_field character varying NOT NULL,
    subject_field character varying NOT NULL,
    processed integer,
    agent_id character varying NOT NULL
);


--
-- Name: run; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.run (
    tenant_id character varying NOT NULL,
    user_id character varying NOT NULL,
    id uuid NOT NULL,
    input character varying,
    input_mode character varying NOT NULL,
    turn_limit integer NOT NULL,
    timeout integer NOT NULL,
    result_channel character varying,
    logs_channel character varying,
    status character varying NOT NULL,
    chatengine_id uuid,
    created_at timestamp without time zone NOT NULL,
    last_interaction timestamp without time zone NOT NULL,
    agent_id character varying NOT NULL,
    input_tokens integer DEFAULT 0,
    output_tokens integer DEFAULT 0,
    model character varying DEFAULT ''::character varying
);


--
-- Name: run_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.run_logs (
    id integer NOT NULL,
    run_id character varying NOT NULL,
    agent_id character varying,
    user_id character varying,
    scope character varying,
    created_at timestamp without time zone,
    content character varying NOT NULL,
    type character varying NOT NULL,
    role character varying NOT NULL,
    lc_run_id character varying,
    version integer DEFAULT 2
);


--
-- Name: run_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.run_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: run_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.run_logs_id_seq OWNED BY public.run_logs.id;


--
-- Name: compressedhistorymessage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compressedhistorymessage ALTER COLUMN id SET DEFAULT nextval('public.compressedhistorymessage_id_seq'::regclass);


--
-- Name: run_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.run_logs ALTER COLUMN id SET DEFAULT nextval('public.run_logs_id_seq'::regclass);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


--
-- Name: compressedhistorymessage compressedhistorymessage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compressedhistorymessage
    ADD CONSTRAINT compressedhistorymessage_pkey PRIMARY KEY (id);


--
-- Name: credentials credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_pkey PRIMARY KEY (id);


--
-- Name: emailmsgsprocessed emailmsgsprocessed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emailmsgsprocessed
    ADD CONSTRAINT emailmsgsprocessed_pkey PRIMARY KEY (uid);


--
-- Name: run_logs run_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.run_logs
    ADD CONSTRAINT run_logs_pkey PRIMARY KEY (id);


--
-- Name: run run_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.run
    ADD CONSTRAINT run_pkey PRIMARY KEY (id);


--
-- Name: ix_compressedhistorymessage_compressed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_compressedhistorymessage_compressed_id ON public.compressedhistorymessage USING btree (compressed_id);


--
-- Name: run run_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.run
    ADD CONSTRAINT run_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agents(id);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.13 (Homebrew)
-- Dumped by pg_dump version 14.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alembic_version (version_num) FROM stdin;
05d22de16718
\.


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- PostgreSQL database dump complete
--

