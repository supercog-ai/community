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
-- Name: monster_dashboard; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE monster_dashboard WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C';


\connect monster_dashboard

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
    name character varying NOT NULL,
    description character varying,
    system_prompt character varying,
    model character varying,
    input_mode character varying NOT NULL,
    trigger character varying NOT NULL,
    welcome_message character varying,
    id character varying DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id character varying,
    tenant_id character varying DEFAULT 'tenant1'::character varying NOT NULL,
    scope character varying DEFAULT 'shared'::character varying NOT NULL,
    avatar_url character varying,
    avatar_blob bytea DEFAULT '\x'::bytea NOT NULL,
    prompts_json character varying DEFAULT ''::character varying,
    trigger_arg character varying,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    folder_id character varying,
    agent_slug character varying,
    temperature double precision DEFAULT 0.0,
    max_agent_time integer DEFAULT 180,
    memories_json character varying DEFAULT ''::character varying,
    implicit_tools character varying,
    max_chat_length integer,
    state character varying
);


--
-- Name: authsession; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authsession (
    id integer NOT NULL,
    session_id character varying NOT NULL,
    expiration timestamp with time zone DEFAULT now() NOT NULL,
    user_id character varying NOT NULL
);


--
-- Name: authsession_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.authsession_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authsession_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.authsession_id_seq OWNED BY public.authsession.id;


--
-- Name: folders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.folders (
    name character varying NOT NULL,
    scope character varying NOT NULL,
    id character varying NOT NULL,
    user_id character varying,
    tenant_id character varying,
    folder_icon_tag character varying NOT NULL,
    slug character varying NOT NULL,
    parent_folder_id character varying
);


--
-- Name: leads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leads (
    id character varying NOT NULL,
    email character varying NOT NULL,
    request character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: tenant_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tenant_members (
    tenant_id character varying NOT NULL,
    user_id character varying NOT NULL,
    role character varying NOT NULL
);


--
-- Name: tenants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tenants (
    id character varying NOT NULL,
    domain character varying NOT NULL,
    name character varying DEFAULT 'New org'::character varying NOT NULL
);


--
-- Name: tools; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tools (
    id character varying NOT NULL,
    tool_factory_id character varying NOT NULL,
    description character varying,
    agent_id character varying NOT NULL,
    credential_id character varying,
    tool_name character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id character varying NOT NULL,
    gtoken_sub character varying NOT NULL,
    gtoken_email character varying NOT NULL,
    gtoken_json character varying NOT NULL,
    gtoken_info_json character varying NOT NULL,
    tenant_id character varying DEFAULT 'tenant1'::character varying NOT NULL,
    stage character varying DEFAULT 'new'::character varying NOT NULL,
    email character varying,
    name character varying,
    password_hash character varying,
    enabled boolean DEFAULT false NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: users_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.users_view AS
 SELECT users.id,
    users.stage,
    users.gtoken_email,
    users.email,
    users.name
   FROM public.users;


--
-- Name: authsession id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authsession ALTER COLUMN id SET DEFAULT nextval('public.authsession_id_seq'::regclass);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


--
-- Name: authsession authsession_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authsession
    ADD CONSTRAINT authsession_pkey PRIMARY KEY (id);


--
-- Name: folders folders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: tenant_members tenant_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_members
    ADD CONSTRAINT tenant_members_pkey PRIMARY KEY (tenant_id, user_id);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: tools tools_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_authsession_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_authsession_session_id ON public.authsession USING btree (session_id);


--
-- Name: ix_authsession_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_authsession_user_id ON public.authsession USING btree (user_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: agents agents_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES public.folders(id);


--
-- Name: agents agents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: folders folders_parent_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_parent_folder_id_fkey FOREIGN KEY (parent_folder_id) REFERENCES public.folders(id);


--
-- Name: folders folders_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: folders folders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tenant_members tenant_members_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_members
    ADD CONSTRAINT tenant_members_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: tenant_members tenant_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_members
    ADD CONSTRAINT tenant_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tools tools_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE CASCADE;


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
d0ff3be32413
\.


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- PostgreSQL database dump complete
--

