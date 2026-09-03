
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: e_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_attachments (
    f_id text NOT NULL,
    f_ticket_id text,
    f_conversation_item_id text
);


--
-- Name: e_attachments_chunk; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_attachments_chunk (
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding public.vector(128) NOT NULL,
    tsv_simple tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, chunk_text)) STORED,
    tsv_lang tsvector GENERATED ALWAYS AS (
CASE chunk_language
    WHEN 'it'::text THEN to_tsvector('italian'::regconfig, chunk_text)
    WHEN 'en'::text THEN to_tsvector('english'::regconfig, chunk_text)
    ELSE to_tsvector('simple'::regconfig, chunk_text)
END) STORED,
    f_ticket_id text
)
PARTITION BY LIST (field_name);


--
-- Name: e_attachments_chunk_f_content; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_attachments_chunk_f_content (
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding public.vector(128) NOT NULL,
    tsv_simple tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, chunk_text)) STORED,
    tsv_lang tsvector GENERATED ALWAYS AS (
CASE chunk_language
    WHEN 'it'::text THEN to_tsvector('italian'::regconfig, chunk_text)
    WHEN 'en'::text THEN to_tsvector('english'::regconfig, chunk_text)
    ELSE to_tsvector('simple'::regconfig, chunk_text)
END) STORED,
    f_ticket_id text
);


--
-- Name: e_attachments_chunk_staging; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_attachments_chunk_staging (
    staging_id bigint NOT NULL,
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding real[] NOT NULL
);


--
-- Name: e_attachments_chunk_staging_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.e_attachments_chunk_staging_staging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: e_attachments_chunk_staging_staging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.e_attachments_chunk_staging_staging_id_seq OWNED BY public.e_attachments_chunk_staging.staging_id;


--
-- Name: e_attachments_field; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_attachments_field (
    field_name text NOT NULL,
    logical_name text NOT NULL
);


--
-- Name: e_attachments_staging; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_attachments_staging (
    staging_id bigint NOT NULL,
    f_id text NOT NULL,
    f_ticket_id text,
    f_conversation_item_id text
);


--
-- Name: e_attachments_staging_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.e_attachments_staging_staging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: e_attachments_staging_staging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.e_attachments_staging_staging_id_seq OWNED BY public.e_attachments_staging.staging_id;


--
-- Name: e_conversation_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_conversation_item (
    f_id text NOT NULL,
    f_entity_id text NOT NULL,
    f_account_id text,
    f_contact_id text,
    f_ticket_id text NOT NULL,
    f_site_visible boolean NOT NULL,
    f_entity text NOT NULL,
    f_user_id text NOT NULL
);


--
-- Name: e_conversation_item_chunk; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_conversation_item_chunk (
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding public.vector(128) NOT NULL,
    tsv_simple tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, chunk_text)) STORED,
    tsv_lang tsvector GENERATED ALWAYS AS (
CASE chunk_language
    WHEN 'it'::text THEN to_tsvector('italian'::regconfig, chunk_text)
    WHEN 'en'::text THEN to_tsvector('english'::regconfig, chunk_text)
    ELSE to_tsvector('simple'::regconfig, chunk_text)
END) STORED,
    f_account_id text
)
PARTITION BY LIST (field_name);


--
-- Name: e_conversation_item_chunk_f_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_conversation_item_chunk_f_message (
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding public.vector(128) NOT NULL,
    tsv_simple tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, chunk_text)) STORED,
    tsv_lang tsvector GENERATED ALWAYS AS (
CASE chunk_language
    WHEN 'it'::text THEN to_tsvector('italian'::regconfig, chunk_text)
    WHEN 'en'::text THEN to_tsvector('english'::regconfig, chunk_text)
    ELSE to_tsvector('simple'::regconfig, chunk_text)
END) STORED,
    f_account_id text
);


--
-- Name: e_conversation_item_chunk_staging; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_conversation_item_chunk_staging (
    staging_id bigint NOT NULL,
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding real[] NOT NULL
);


--
-- Name: e_conversation_item_chunk_staging_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.e_conversation_item_chunk_staging_staging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: e_conversation_item_chunk_staging_staging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.e_conversation_item_chunk_staging_staging_id_seq OWNED BY public.e_conversation_item_chunk_staging.staging_id;


--
-- Name: e_conversation_item_field; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_conversation_item_field (
    field_name text NOT NULL,
    logical_name text NOT NULL
);


--
-- Name: e_conversation_item_staging; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_conversation_item_staging (
    staging_id bigint NOT NULL,
    f_id text NOT NULL,
    f_entity_id text NOT NULL,
    f_account_id text,
    f_contact_id text,
    f_ticket_id text NOT NULL,
    f_site_visible boolean NOT NULL,
    f_entity text NOT NULL,
    f_user_id text NOT NULL
);


--
-- Name: e_conversation_item_staging_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.e_conversation_item_staging_staging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: e_conversation_item_staging_staging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.e_conversation_item_staging_staging_id_seq OWNED BY public.e_conversation_item_staging.staging_id;


--
-- Name: e_ticket; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_ticket (
    f_id text NOT NULL,
    f_entity_id text NOT NULL,
    f_code text,
    f_service_id text,
    f_object_type_id text,
    f_account_id text,
    f_contact_id text,
    f_assigned_user_id text,
    f_owner_user_id text,
    f_closure_date timestamp with time zone,
    f_last_change timestamp with time zone NOT NULL,
    f_entity text,
    f_creation_date timestamp with time zone NOT NULL,
    f_ticket_status_id text NOT NULL,
    f_ticket_status_type bigint NOT NULL,
    f_urgency_id text,
    f_impact_id text,
    f_ticket_priority_id text NOT NULL,
    f_ticket_source_id text,
    f_assigned_user_group_id text,
    f_assigned_user_or_group_id text,
    f_owner_user_group_id text
);


--
-- Name: e_ticket_chunk; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_ticket_chunk (
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding public.vector(128) NOT NULL,
    tsv_simple tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, chunk_text)) STORED,
    tsv_lang tsvector GENERATED ALWAYS AS (
CASE chunk_language
    WHEN 'it'::text THEN to_tsvector('italian'::regconfig, chunk_text)
    WHEN 'en'::text THEN to_tsvector('english'::regconfig, chunk_text)
    ELSE to_tsvector('simple'::regconfig, chunk_text)
END) STORED,
    f_last_change timestamp with time zone,
    f_closure_date timestamp with time zone
)
PARTITION BY LIST (field_name);


--
-- Name: e_ticket_chunk_f_problem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_ticket_chunk_f_problem (
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding public.vector(128) NOT NULL,
    tsv_simple tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, chunk_text)) STORED,
    tsv_lang tsvector GENERATED ALWAYS AS (
CASE chunk_language
    WHEN 'it'::text THEN to_tsvector('italian'::regconfig, chunk_text)
    WHEN 'en'::text THEN to_tsvector('english'::regconfig, chunk_text)
    ELSE to_tsvector('simple'::regconfig, chunk_text)
END) STORED,
    f_last_change timestamp with time zone,
    f_closure_date timestamp with time zone
);


--
-- Name: e_ticket_chunk_f_solution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_ticket_chunk_f_solution (
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding public.vector(128) NOT NULL,
    tsv_simple tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, chunk_text)) STORED,
    tsv_lang tsvector GENERATED ALWAYS AS (
CASE chunk_language
    WHEN 'it'::text THEN to_tsvector('italian'::regconfig, chunk_text)
    WHEN 'en'::text THEN to_tsvector('english'::regconfig, chunk_text)
    ELSE to_tsvector('simple'::regconfig, chunk_text)
END) STORED,
    f_last_change timestamp with time zone,
    f_closure_date timestamp with time zone
);


--
-- Name: e_ticket_chunk_f_subject; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_ticket_chunk_f_subject (
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding public.vector(128) NOT NULL,
    tsv_simple tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, chunk_text)) STORED,
    tsv_lang tsvector GENERATED ALWAYS AS (
CASE chunk_language
    WHEN 'it'::text THEN to_tsvector('italian'::regconfig, chunk_text)
    WHEN 'en'::text THEN to_tsvector('english'::regconfig, chunk_text)
    ELSE to_tsvector('simple'::regconfig, chunk_text)
END) STORED,
    f_last_change timestamp with time zone,
    f_closure_date timestamp with time zone
);


--
-- Name: e_ticket_chunk_staging; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_ticket_chunk_staging (
    staging_id bigint NOT NULL,
    f_id text NOT NULL,
    field_name text NOT NULL,
    chunk_counter integer NOT NULL,
    chunk_text text NOT NULL,
    chunk_language text NOT NULL,
    embedding real[] NOT NULL
);


--
-- Name: e_ticket_chunk_staging_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.e_ticket_chunk_staging_staging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: e_ticket_chunk_staging_staging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.e_ticket_chunk_staging_staging_id_seq OWNED BY public.e_ticket_chunk_staging.staging_id;


--
-- Name: e_ticket_field; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_ticket_field (
    field_name text NOT NULL,
    logical_name text NOT NULL
);


--
-- Name: e_ticket_staging; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_ticket_staging (
    staging_id bigint NOT NULL,
    f_id text NOT NULL,
    f_entity_id text NOT NULL,
    f_code text,
    f_service_id text,
    f_object_type_id text,
    f_account_id text,
    f_contact_id text,
    f_assigned_user_id text,
    f_owner_user_id text,
    f_closure_date timestamp with time zone,
    f_last_change timestamp with time zone NOT NULL,
    f_entity text,
    f_creation_date timestamp with time zone NOT NULL,
    f_ticket_status_id text NOT NULL,
    f_ticket_status_type bigint NOT NULL,
    f_urgency_id text,
    f_impact_id text,
    f_ticket_priority_id text NOT NULL,
    f_ticket_source_id text,
    f_assigned_user_group_id text,
    f_assigned_user_or_group_id text,
    f_owner_user_group_id text
);


--
-- Name: e_ticket_staging_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.e_ticket_staging_staging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: e_ticket_staging_staging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.e_ticket_staging_staging_id_seq OWNED BY public.e_ticket_staging.staging_id;


--
-- Name: ingestion_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ingestion_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ingestion_sessions_status_check CHECK ((status = ANY (ARRAY['open'::text, 'closed'::text, 'finalized'::text])))
);


--
-- Name: ingestion_streams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ingestion_streams (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ingestion_streams_status_check CHECK ((status = ANY (ARRAY['open'::text, 'closed'::text])))
);


--
-- Name: language; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.language (
    code text NOT NULL,
    name text NOT NULL
);


--
-- Name: e_attachments_chunk_f_content; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments_chunk ATTACH PARTITION public.e_attachments_chunk_f_content FOR VALUES IN ('f_content');


--
-- Name: e_conversation_item_chunk_f_message; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item_chunk ATTACH PARTITION public.e_conversation_item_chunk_f_message FOR VALUES IN ('f_message');


--
-- Name: e_ticket_chunk_f_problem; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_chunk ATTACH PARTITION public.e_ticket_chunk_f_problem FOR VALUES IN ('f_problem');


--
-- Name: e_ticket_chunk_f_solution; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_chunk ATTACH PARTITION public.e_ticket_chunk_f_solution FOR VALUES IN ('f_solution');


--
-- Name: e_ticket_chunk_f_subject; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_chunk ATTACH PARTITION public.e_ticket_chunk_f_subject FOR VALUES IN ('f_subject');


--
-- Name: e_attachments_chunk_staging staging_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments_chunk_staging ALTER COLUMN staging_id SET DEFAULT nextval('public.e_attachments_chunk_staging_staging_id_seq'::regclass);


--
-- Name: e_attachments_staging staging_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments_staging ALTER COLUMN staging_id SET DEFAULT nextval('public.e_attachments_staging_staging_id_seq'::regclass);


--
-- Name: e_conversation_item_chunk_staging staging_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item_chunk_staging ALTER COLUMN staging_id SET DEFAULT nextval('public.e_conversation_item_chunk_staging_staging_id_seq'::regclass);


--
-- Name: e_conversation_item_staging staging_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item_staging ALTER COLUMN staging_id SET DEFAULT nextval('public.e_conversation_item_staging_staging_id_seq'::regclass);


--
-- Name: e_ticket_chunk_staging staging_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_chunk_staging ALTER COLUMN staging_id SET DEFAULT nextval('public.e_ticket_chunk_staging_staging_id_seq'::regclass);


--
-- Name: e_ticket_staging staging_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_staging ALTER COLUMN staging_id SET DEFAULT nextval('public.e_ticket_staging_staging_id_seq'::regclass);


--
-- Name: e_attachments_chunk e_attachments_chunk_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments_chunk
    ADD CONSTRAINT e_attachments_chunk_pkey PRIMARY KEY (f_id, field_name, chunk_counter);


--
-- Name: e_attachments_chunk_f_content e_attachments_chunk_f_content_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments_chunk_f_content
    ADD CONSTRAINT e_attachments_chunk_f_content_pkey PRIMARY KEY (f_id, field_name, chunk_counter);


--
-- Name: e_attachments_chunk_staging e_attachments_chunk_staging_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments_chunk_staging
    ADD CONSTRAINT e_attachments_chunk_staging_pkey PRIMARY KEY (staging_id);


--
-- Name: e_attachments_field e_attachments_field_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments_field
    ADD CONSTRAINT e_attachments_field_pkey PRIMARY KEY (field_name);


--
-- Name: e_attachments e_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments
    ADD CONSTRAINT e_attachments_pkey PRIMARY KEY (f_id);


--
-- Name: e_attachments_staging e_attachments_staging_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments_staging
    ADD CONSTRAINT e_attachments_staging_pkey PRIMARY KEY (staging_id);


--
-- Name: e_conversation_item_chunk e_conversation_item_chunk_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item_chunk
    ADD CONSTRAINT e_conversation_item_chunk_pkey PRIMARY KEY (f_id, field_name, chunk_counter);


--
-- Name: e_conversation_item_chunk_f_message e_conversation_item_chunk_f_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item_chunk_f_message
    ADD CONSTRAINT e_conversation_item_chunk_f_message_pkey PRIMARY KEY (f_id, field_name, chunk_counter);


--
-- Name: e_conversation_item_chunk_staging e_conversation_item_chunk_staging_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item_chunk_staging
    ADD CONSTRAINT e_conversation_item_chunk_staging_pkey PRIMARY KEY (staging_id);


--
-- Name: e_conversation_item_field e_conversation_item_field_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item_field
    ADD CONSTRAINT e_conversation_item_field_pkey PRIMARY KEY (field_name);


--
-- Name: e_conversation_item e_conversation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item
    ADD CONSTRAINT e_conversation_item_pkey PRIMARY KEY (f_id);


--
-- Name: e_conversation_item_staging e_conversation_item_staging_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item_staging
    ADD CONSTRAINT e_conversation_item_staging_pkey PRIMARY KEY (staging_id);


--
-- Name: e_ticket_chunk e_ticket_chunk_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_chunk
    ADD CONSTRAINT e_ticket_chunk_pkey PRIMARY KEY (f_id, field_name, chunk_counter);


--
-- Name: e_ticket_chunk_f_problem e_ticket_chunk_f_problem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_chunk_f_problem
    ADD CONSTRAINT e_ticket_chunk_f_problem_pkey PRIMARY KEY (f_id, field_name, chunk_counter);


--
-- Name: e_ticket_chunk_f_solution e_ticket_chunk_f_solution_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_chunk_f_solution
    ADD CONSTRAINT e_ticket_chunk_f_solution_pkey PRIMARY KEY (f_id, field_name, chunk_counter);


--
-- Name: e_ticket_chunk_f_subject e_ticket_chunk_f_subject_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_chunk_f_subject
    ADD CONSTRAINT e_ticket_chunk_f_subject_pkey PRIMARY KEY (f_id, field_name, chunk_counter);


--
-- Name: e_ticket_chunk_staging e_ticket_chunk_staging_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_chunk_staging
    ADD CONSTRAINT e_ticket_chunk_staging_pkey PRIMARY KEY (staging_id);


--
-- Name: e_ticket_field e_ticket_field_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_field
    ADD CONSTRAINT e_ticket_field_pkey PRIMARY KEY (field_name);


--
-- Name: e_ticket e_ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket
    ADD CONSTRAINT e_ticket_pkey PRIMARY KEY (f_id);


--
-- Name: e_ticket_staging e_ticket_staging_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_ticket_staging
    ADD CONSTRAINT e_ticket_staging_pkey PRIMARY KEY (staging_id);


--
-- Name: ingestion_sessions ingestion_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingestion_sessions
    ADD CONSTRAINT ingestion_sessions_pkey PRIMARY KEY (id);


--
-- Name: ingestion_streams ingestion_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingestion_streams
    ADD CONSTRAINT ingestion_streams_pkey PRIMARY KEY (id);


--
-- Name: language language_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (code);


--
-- Name: ix_e_attachments_chunk_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_chunk_embedding ON ONLY public.e_attachments_chunk USING hnsw (((public.binary_quantize((embedding)::public.vector))::bit(128)) public.bit_hamming_ops);


--
-- Name: e_attachments_chunk_f_content_binary_quantize_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_attachments_chunk_f_content_binary_quantize_idx ON public.e_attachments_chunk_f_content USING hnsw (((public.binary_quantize((embedding)::public.vector))::bit(128)) public.bit_hamming_ops);


--
-- Name: ix_e_attachments_chunk_tsv_lang_it; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_chunk_tsv_lang_it ON ONLY public.e_attachments_chunk USING gin (tsv_lang) WHERE (chunk_language = 'it'::text);


--
-- Name: e_attachments_chunk_f_content_tsv_lang_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_attachments_chunk_f_content_tsv_lang_idx ON public.e_attachments_chunk_f_content USING gin (tsv_lang) WHERE (chunk_language = 'it'::text);


--
-- Name: ix_e_attachments_chunk_tsv_lang_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_chunk_tsv_lang_en ON ONLY public.e_attachments_chunk USING gin (tsv_lang) WHERE (chunk_language = 'en'::text);


--
-- Name: e_attachments_chunk_f_content_tsv_lang_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_attachments_chunk_f_content_tsv_lang_idx1 ON public.e_attachments_chunk_f_content USING gin (tsv_lang) WHERE (chunk_language = 'en'::text);


--
-- Name: ix_e_attachments_chunk_tsv_simple; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_chunk_tsv_simple ON ONLY public.e_attachments_chunk USING gin (tsv_simple);


--
-- Name: e_attachments_chunk_f_content_tsv_simple_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_attachments_chunk_f_content_tsv_simple_idx ON public.e_attachments_chunk_f_content USING gin (tsv_simple);


--
-- Name: ix_e_attachments_chunk_tsv_simple_arr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_chunk_tsv_simple_arr ON ONLY public.e_attachments_chunk USING gin (tsvector_to_array(tsv_simple));


--
-- Name: e_attachments_chunk_f_content_tsvector_to_array_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_attachments_chunk_f_content_tsvector_to_array_idx ON public.e_attachments_chunk_f_content USING gin (tsvector_to_array(tsv_simple));


--
-- Name: ix_e_attachments_chunk_tsv_lang_arr_it; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_chunk_tsv_lang_arr_it ON ONLY public.e_attachments_chunk USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'it'::text);


--
-- Name: e_attachments_chunk_f_content_tsvector_to_array_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_attachments_chunk_f_content_tsvector_to_array_idx1 ON public.e_attachments_chunk_f_content USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'it'::text);


--
-- Name: ix_e_attachments_chunk_tsv_lang_arr_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_chunk_tsv_lang_arr_en ON ONLY public.e_attachments_chunk USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'en'::text);


--
-- Name: e_attachments_chunk_f_content_tsvector_to_array_idx2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_attachments_chunk_f_content_tsvector_to_array_idx2 ON public.e_attachments_chunk_f_content USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'en'::text);


--
-- Name: ix_e_conversation_item_chunk_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_conversation_item_chunk_embedding ON ONLY public.e_conversation_item_chunk USING hnsw (((public.binary_quantize((embedding)::public.vector))::bit(128)) public.bit_hamming_ops);


--
-- Name: e_conversation_item_chunk_f_message_binary_quantize_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_conversation_item_chunk_f_message_binary_quantize_idx ON public.e_conversation_item_chunk_f_message USING hnsw (((public.binary_quantize((embedding)::public.vector))::bit(128)) public.bit_hamming_ops);


--
-- Name: ix_e_conversation_item_chunk_tsv_lang_it; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_conversation_item_chunk_tsv_lang_it ON ONLY public.e_conversation_item_chunk USING gin (tsv_lang) WHERE (chunk_language = 'it'::text);


--
-- Name: e_conversation_item_chunk_f_message_tsv_lang_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_conversation_item_chunk_f_message_tsv_lang_idx ON public.e_conversation_item_chunk_f_message USING gin (tsv_lang) WHERE (chunk_language = 'it'::text);


--
-- Name: ix_e_conversation_item_chunk_tsv_lang_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_conversation_item_chunk_tsv_lang_en ON ONLY public.e_conversation_item_chunk USING gin (tsv_lang) WHERE (chunk_language = 'en'::text);


--
-- Name: e_conversation_item_chunk_f_message_tsv_lang_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_conversation_item_chunk_f_message_tsv_lang_idx1 ON public.e_conversation_item_chunk_f_message USING gin (tsv_lang) WHERE (chunk_language = 'en'::text);


--
-- Name: ix_e_conversation_item_chunk_tsv_simple; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_conversation_item_chunk_tsv_simple ON ONLY public.e_conversation_item_chunk USING gin (tsv_simple);


--
-- Name: e_conversation_item_chunk_f_message_tsv_simple_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_conversation_item_chunk_f_message_tsv_simple_idx ON public.e_conversation_item_chunk_f_message USING gin (tsv_simple);


--
-- Name: ix_e_conversation_item_chunk_tsv_simple_arr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_conversation_item_chunk_tsv_simple_arr ON ONLY public.e_conversation_item_chunk USING gin (tsvector_to_array(tsv_simple));


--
-- Name: e_conversation_item_chunk_f_message_tsvector_to_array_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_conversation_item_chunk_f_message_tsvector_to_array_idx ON public.e_conversation_item_chunk_f_message USING gin (tsvector_to_array(tsv_simple));


--
-- Name: ix_e_conversation_item_chunk_tsv_lang_arr_it; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_conversation_item_chunk_tsv_lang_arr_it ON ONLY public.e_conversation_item_chunk USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'it'::text);


--
-- Name: e_conversation_item_chunk_f_message_tsvector_to_array_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_conversation_item_chunk_f_message_tsvector_to_array_idx1 ON public.e_conversation_item_chunk_f_message USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'it'::text);


--
-- Name: ix_e_conversation_item_chunk_tsv_lang_arr_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_conversation_item_chunk_tsv_lang_arr_en ON ONLY public.e_conversation_item_chunk USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'en'::text);


--
-- Name: e_conversation_item_chunk_f_message_tsvector_to_array_idx2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_conversation_item_chunk_f_message_tsvector_to_array_idx2 ON public.e_conversation_item_chunk_f_message USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'en'::text);


--
-- Name: ix_e_ticket_chunk_embedding; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_ticket_chunk_embedding ON ONLY public.e_ticket_chunk USING hnsw (((public.binary_quantize((embedding)::public.vector))::bit(128)) public.bit_hamming_ops);


--
-- Name: e_ticket_chunk_f_problem_binary_quantize_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_problem_binary_quantize_idx ON public.e_ticket_chunk_f_problem USING hnsw (((public.binary_quantize((embedding)::public.vector))::bit(128)) public.bit_hamming_ops);


--
-- Name: ix_e_ticket_chunk_tsv_lang_it; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_ticket_chunk_tsv_lang_it ON ONLY public.e_ticket_chunk USING gin (tsv_lang) WHERE (chunk_language = 'it'::text);


--
-- Name: e_ticket_chunk_f_problem_tsv_lang_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_problem_tsv_lang_idx ON public.e_ticket_chunk_f_problem USING gin (tsv_lang) WHERE (chunk_language = 'it'::text);


--
-- Name: ix_e_ticket_chunk_tsv_lang_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_ticket_chunk_tsv_lang_en ON ONLY public.e_ticket_chunk USING gin (tsv_lang) WHERE (chunk_language = 'en'::text);


--
-- Name: e_ticket_chunk_f_problem_tsv_lang_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_problem_tsv_lang_idx1 ON public.e_ticket_chunk_f_problem USING gin (tsv_lang) WHERE (chunk_language = 'en'::text);


--
-- Name: ix_e_ticket_chunk_tsv_simple; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_ticket_chunk_tsv_simple ON ONLY public.e_ticket_chunk USING gin (tsv_simple);


--
-- Name: e_ticket_chunk_f_problem_tsv_simple_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_problem_tsv_simple_idx ON public.e_ticket_chunk_f_problem USING gin (tsv_simple);


--
-- Name: ix_e_ticket_chunk_tsv_simple_arr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_ticket_chunk_tsv_simple_arr ON ONLY public.e_ticket_chunk USING gin (tsvector_to_array(tsv_simple));


--
-- Name: e_ticket_chunk_f_problem_tsvector_to_array_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_problem_tsvector_to_array_idx ON public.e_ticket_chunk_f_problem USING gin (tsvector_to_array(tsv_simple));


--
-- Name: ix_e_ticket_chunk_tsv_lang_arr_it; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_ticket_chunk_tsv_lang_arr_it ON ONLY public.e_ticket_chunk USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'it'::text);


--
-- Name: e_ticket_chunk_f_problem_tsvector_to_array_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_problem_tsvector_to_array_idx1 ON public.e_ticket_chunk_f_problem USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'it'::text);


--
-- Name: ix_e_ticket_chunk_tsv_lang_arr_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_ticket_chunk_tsv_lang_arr_en ON ONLY public.e_ticket_chunk USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'en'::text);


--
-- Name: e_ticket_chunk_f_problem_tsvector_to_array_idx2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_problem_tsvector_to_array_idx2 ON public.e_ticket_chunk_f_problem USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'en'::text);


--
-- Name: e_ticket_chunk_f_solution_binary_quantize_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_solution_binary_quantize_idx ON public.e_ticket_chunk_f_solution USING hnsw (((public.binary_quantize((embedding)::public.vector))::bit(128)) public.bit_hamming_ops);


--
-- Name: e_ticket_chunk_f_solution_tsv_lang_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_solution_tsv_lang_idx ON public.e_ticket_chunk_f_solution USING gin (tsv_lang) WHERE (chunk_language = 'it'::text);


--
-- Name: e_ticket_chunk_f_solution_tsv_lang_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_solution_tsv_lang_idx1 ON public.e_ticket_chunk_f_solution USING gin (tsv_lang) WHERE (chunk_language = 'en'::text);


--
-- Name: e_ticket_chunk_f_solution_tsv_simple_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_solution_tsv_simple_idx ON public.e_ticket_chunk_f_solution USING gin (tsv_simple);


--
-- Name: e_ticket_chunk_f_solution_tsvector_to_array_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_solution_tsvector_to_array_idx ON public.e_ticket_chunk_f_solution USING gin (tsvector_to_array(tsv_simple));


--
-- Name: e_ticket_chunk_f_solution_tsvector_to_array_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_solution_tsvector_to_array_idx1 ON public.e_ticket_chunk_f_solution USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'it'::text);


--
-- Name: e_ticket_chunk_f_solution_tsvector_to_array_idx2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_solution_tsvector_to_array_idx2 ON public.e_ticket_chunk_f_solution USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'en'::text);


--
-- Name: e_ticket_chunk_f_subject_binary_quantize_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_subject_binary_quantize_idx ON public.e_ticket_chunk_f_subject USING hnsw (((public.binary_quantize((embedding)::public.vector))::bit(128)) public.bit_hamming_ops);


--
-- Name: e_ticket_chunk_f_subject_tsv_lang_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_subject_tsv_lang_idx ON public.e_ticket_chunk_f_subject USING gin (tsv_lang) WHERE (chunk_language = 'it'::text);


--
-- Name: e_ticket_chunk_f_subject_tsv_lang_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_subject_tsv_lang_idx1 ON public.e_ticket_chunk_f_subject USING gin (tsv_lang) WHERE (chunk_language = 'en'::text);


--
-- Name: e_ticket_chunk_f_subject_tsv_simple_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_subject_tsv_simple_idx ON public.e_ticket_chunk_f_subject USING gin (tsv_simple);


--
-- Name: e_ticket_chunk_f_subject_tsvector_to_array_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_subject_tsvector_to_array_idx ON public.e_ticket_chunk_f_subject USING gin (tsvector_to_array(tsv_simple));


--
-- Name: e_ticket_chunk_f_subject_tsvector_to_array_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_subject_tsvector_to_array_idx1 ON public.e_ticket_chunk_f_subject USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'it'::text);


--
-- Name: e_ticket_chunk_f_subject_tsvector_to_array_idx2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX e_ticket_chunk_f_subject_tsvector_to_array_idx2 ON public.e_ticket_chunk_f_subject USING gin (tsvector_to_array(tsv_lang)) WHERE (chunk_language = 'en'::text);


--
-- Name: ix_e_attachments_chunk_staging_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_chunk_staging_identifier ON public.e_attachments_chunk_staging USING btree (f_id);


--
-- Name: ix_e_attachments_staging_f_conversation_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_staging_f_conversation_item_id ON public.e_attachments_staging USING btree (f_conversation_item_id);


--
-- Name: ix_e_attachments_staging_f_ticket_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_attachments_staging_f_ticket_id ON public.e_attachments_staging USING btree (f_ticket_id);


--
-- Name: ix_e_conversation_item_chunk_staging_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_conversation_item_chunk_staging_identifier ON public.e_conversation_item_chunk_staging USING btree (f_id);


--
-- Name: ix_e_conversation_item_staging_f_ticket_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_conversation_item_staging_f_ticket_id ON public.e_conversation_item_staging USING btree (f_ticket_id);


--
-- Name: ix_e_ticket_chunk_staging_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_e_ticket_chunk_staging_identifier ON public.e_ticket_chunk_staging USING btree (f_id);


--
-- Name: ix_ingestion_sessions_single_open; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_ingestion_sessions_single_open ON public.ingestion_sessions USING btree (status) WHERE (status = 'open'::text);


--
-- Name: ix_ingestion_streams_session_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_ingestion_streams_session_status ON public.ingestion_streams USING btree (session_id, status);


--
-- Name: e_attachments_chunk_f_content_binary_quantize_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_attachments_chunk_embedding ATTACH PARTITION public.e_attachments_chunk_f_content_binary_quantize_idx;


--
-- Name: e_attachments_chunk_f_content_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.e_attachments_chunk_pkey ATTACH PARTITION public.e_attachments_chunk_f_content_pkey;


--
-- Name: e_attachments_chunk_f_content_tsv_lang_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_attachments_chunk_tsv_lang_it ATTACH PARTITION public.e_attachments_chunk_f_content_tsv_lang_idx;


--
-- Name: e_attachments_chunk_f_content_tsv_lang_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_attachments_chunk_tsv_lang_en ATTACH PARTITION public.e_attachments_chunk_f_content_tsv_lang_idx1;


--
-- Name: e_attachments_chunk_f_content_tsv_simple_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_attachments_chunk_tsv_simple ATTACH PARTITION public.e_attachments_chunk_f_content_tsv_simple_idx;


--
-- Name: e_attachments_chunk_f_content_tsvector_to_array_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_attachments_chunk_tsv_simple_arr ATTACH PARTITION public.e_attachments_chunk_f_content_tsvector_to_array_idx;


--
-- Name: e_attachments_chunk_f_content_tsvector_to_array_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_attachments_chunk_tsv_lang_arr_it ATTACH PARTITION public.e_attachments_chunk_f_content_tsvector_to_array_idx1;


--
-- Name: e_attachments_chunk_f_content_tsvector_to_array_idx2; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_attachments_chunk_tsv_lang_arr_en ATTACH PARTITION public.e_attachments_chunk_f_content_tsvector_to_array_idx2;


--
-- Name: e_conversation_item_chunk_f_message_binary_quantize_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_conversation_item_chunk_embedding ATTACH PARTITION public.e_conversation_item_chunk_f_message_binary_quantize_idx;


--
-- Name: e_conversation_item_chunk_f_message_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.e_conversation_item_chunk_pkey ATTACH PARTITION public.e_conversation_item_chunk_f_message_pkey;


--
-- Name: e_conversation_item_chunk_f_message_tsv_lang_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_conversation_item_chunk_tsv_lang_it ATTACH PARTITION public.e_conversation_item_chunk_f_message_tsv_lang_idx;


--
-- Name: e_conversation_item_chunk_f_message_tsv_lang_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_conversation_item_chunk_tsv_lang_en ATTACH PARTITION public.e_conversation_item_chunk_f_message_tsv_lang_idx1;


--
-- Name: e_conversation_item_chunk_f_message_tsv_simple_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_conversation_item_chunk_tsv_simple ATTACH PARTITION public.e_conversation_item_chunk_f_message_tsv_simple_idx;


--
-- Name: e_conversation_item_chunk_f_message_tsvector_to_array_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_conversation_item_chunk_tsv_simple_arr ATTACH PARTITION public.e_conversation_item_chunk_f_message_tsvector_to_array_idx;


--
-- Name: e_conversation_item_chunk_f_message_tsvector_to_array_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_conversation_item_chunk_tsv_lang_arr_it ATTACH PARTITION public.e_conversation_item_chunk_f_message_tsvector_to_array_idx1;


--
-- Name: e_conversation_item_chunk_f_message_tsvector_to_array_idx2; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_conversation_item_chunk_tsv_lang_arr_en ATTACH PARTITION public.e_conversation_item_chunk_f_message_tsvector_to_array_idx2;


--
-- Name: e_ticket_chunk_f_problem_binary_quantize_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_embedding ATTACH PARTITION public.e_ticket_chunk_f_problem_binary_quantize_idx;


--
-- Name: e_ticket_chunk_f_problem_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.e_ticket_chunk_pkey ATTACH PARTITION public.e_ticket_chunk_f_problem_pkey;


--
-- Name: e_ticket_chunk_f_problem_tsv_lang_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_it ATTACH PARTITION public.e_ticket_chunk_f_problem_tsv_lang_idx;


--
-- Name: e_ticket_chunk_f_problem_tsv_lang_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_en ATTACH PARTITION public.e_ticket_chunk_f_problem_tsv_lang_idx1;


--
-- Name: e_ticket_chunk_f_problem_tsv_simple_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_simple ATTACH PARTITION public.e_ticket_chunk_f_problem_tsv_simple_idx;


--
-- Name: e_ticket_chunk_f_problem_tsvector_to_array_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_simple_arr ATTACH PARTITION public.e_ticket_chunk_f_problem_tsvector_to_array_idx;


--
-- Name: e_ticket_chunk_f_problem_tsvector_to_array_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_arr_it ATTACH PARTITION public.e_ticket_chunk_f_problem_tsvector_to_array_idx1;


--
-- Name: e_ticket_chunk_f_problem_tsvector_to_array_idx2; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_arr_en ATTACH PARTITION public.e_ticket_chunk_f_problem_tsvector_to_array_idx2;


--
-- Name: e_ticket_chunk_f_solution_binary_quantize_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_embedding ATTACH PARTITION public.e_ticket_chunk_f_solution_binary_quantize_idx;


--
-- Name: e_ticket_chunk_f_solution_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.e_ticket_chunk_pkey ATTACH PARTITION public.e_ticket_chunk_f_solution_pkey;


--
-- Name: e_ticket_chunk_f_solution_tsv_lang_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_it ATTACH PARTITION public.e_ticket_chunk_f_solution_tsv_lang_idx;


--
-- Name: e_ticket_chunk_f_solution_tsv_lang_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_en ATTACH PARTITION public.e_ticket_chunk_f_solution_tsv_lang_idx1;


--
-- Name: e_ticket_chunk_f_solution_tsv_simple_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_simple ATTACH PARTITION public.e_ticket_chunk_f_solution_tsv_simple_idx;


--
-- Name: e_ticket_chunk_f_solution_tsvector_to_array_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_simple_arr ATTACH PARTITION public.e_ticket_chunk_f_solution_tsvector_to_array_idx;


--
-- Name: e_ticket_chunk_f_solution_tsvector_to_array_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_arr_it ATTACH PARTITION public.e_ticket_chunk_f_solution_tsvector_to_array_idx1;


--
-- Name: e_ticket_chunk_f_solution_tsvector_to_array_idx2; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_arr_en ATTACH PARTITION public.e_ticket_chunk_f_solution_tsvector_to_array_idx2;


--
-- Name: e_ticket_chunk_f_subject_binary_quantize_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_embedding ATTACH PARTITION public.e_ticket_chunk_f_subject_binary_quantize_idx;


--
-- Name: e_ticket_chunk_f_subject_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.e_ticket_chunk_pkey ATTACH PARTITION public.e_ticket_chunk_f_subject_pkey;


--
-- Name: e_ticket_chunk_f_subject_tsv_lang_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_it ATTACH PARTITION public.e_ticket_chunk_f_subject_tsv_lang_idx;


--
-- Name: e_ticket_chunk_f_subject_tsv_lang_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_en ATTACH PARTITION public.e_ticket_chunk_f_subject_tsv_lang_idx1;


--
-- Name: e_ticket_chunk_f_subject_tsv_simple_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_simple ATTACH PARTITION public.e_ticket_chunk_f_subject_tsv_simple_idx;


--
-- Name: e_ticket_chunk_f_subject_tsvector_to_array_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_simple_arr ATTACH PARTITION public.e_ticket_chunk_f_subject_tsvector_to_array_idx;


--
-- Name: e_ticket_chunk_f_subject_tsvector_to_array_idx1; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_arr_it ATTACH PARTITION public.e_ticket_chunk_f_subject_tsvector_to_array_idx1;


--
-- Name: e_ticket_chunk_f_subject_tsvector_to_array_idx2; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ix_e_ticket_chunk_tsv_lang_arr_en ATTACH PARTITION public.e_ticket_chunk_f_subject_tsvector_to_array_idx2;


--
-- Name: e_attachments_chunk e_attachments_chunk_chunk_language_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.e_attachments_chunk
    ADD CONSTRAINT e_attachments_chunk_chunk_language_fkey FOREIGN KEY (chunk_language) REFERENCES public.language(code);


--
-- Name: e_attachments_chunk e_attachments_chunk_field_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.e_attachments_chunk
    ADD CONSTRAINT e_attachments_chunk_field_name_fkey FOREIGN KEY (field_name) REFERENCES public.e_attachments_field(field_name);


--
-- Name: e_conversation_item_chunk e_conversation_item_chunk_chunk_language_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.e_conversation_item_chunk
    ADD CONSTRAINT e_conversation_item_chunk_chunk_language_fkey FOREIGN KEY (chunk_language) REFERENCES public.language(code);


--
-- Name: e_conversation_item_chunk e_conversation_item_chunk_field_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.e_conversation_item_chunk
    ADD CONSTRAINT e_conversation_item_chunk_field_name_fkey FOREIGN KEY (field_name) REFERENCES public.e_conversation_item_field(field_name);


--
-- Name: e_ticket_chunk e_ticket_chunk_chunk_language_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.e_ticket_chunk
    ADD CONSTRAINT e_ticket_chunk_chunk_language_fkey FOREIGN KEY (chunk_language) REFERENCES public.language(code);


--
-- Name: e_ticket_chunk e_ticket_chunk_field_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.e_ticket_chunk
    ADD CONSTRAINT e_ticket_chunk_field_name_fkey FOREIGN KEY (field_name) REFERENCES public.e_ticket_field(field_name);


--
-- Name: e_attachments fk_e_attachments_f_conversation_item_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments
    ADD CONSTRAINT fk_e_attachments_f_conversation_item_id FOREIGN KEY (f_conversation_item_id) REFERENCES public.e_conversation_item(f_id);


--
-- Name: e_attachments fk_e_attachments_f_ticket_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_attachments
    ADD CONSTRAINT fk_e_attachments_f_ticket_id FOREIGN KEY (f_ticket_id) REFERENCES public.e_ticket(f_id);


--
-- Name: e_conversation_item fk_e_conversation_item_f_ticket_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_conversation_item
    ADD CONSTRAINT fk_e_conversation_item_f_ticket_id FOREIGN KEY (f_ticket_id) REFERENCES public.e_ticket(f_id);


--
-- Name: ingestion_streams ingestion_streams_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingestion_streams
    ADD CONSTRAINT ingestion_streams_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.ingestion_sessions(id);


--
-- PostgreSQL database dump complete
--

\unrestrict yUGCLHbWJIOEqL50OxifrKe8fthN3QNjwWOMYghVVaQeffM0m5MJLHSB7ue8OEi

