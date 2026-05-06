--
-- PostgreSQL database dump
--

\restrict 6XHDTON0UCXyhG170eCyUUfiUsa3x8nezwrZTpeb2T9ePJTZbEo0LW4HAdGCMCO

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: integration_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.integration_type AS ENUM (
    'discord'
);


--
-- Name: notify_item_submission_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.notify_item_submission_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
    row RECORD;
    output TEXT;
    
    BEGIN
    -- Checking the Operation Type
    IF (TG_OP = 'DELETE') THEN
      row = OLD;
    ELSE
      row = NEW;
    END IF;

    PERFORM pg_notify('item_updates', row.item_id::text);

    RETURN NULL;
    END;
$$;


--
-- Name: notify_item_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.notify_item_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
    row RECORD;
    output TEXT;
    
    BEGIN
    -- Checking the Operation Type
    IF (TG_OP = 'DELETE') THEN
      row = OLD;
    ELSE
      row = NEW;
    END IF;

    PERFORM pg_notify('item_updates', row.id::text);

    RETURN NULL;
    END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: item_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_events (
    id bigint NOT NULL,
    item_id bigint NOT NULL,
    date timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_events_id_seq OWNED BY public.item_events.id;


--
-- Name: item_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_files (
    id bigint NOT NULL,
    item_id bigint,
    item_submission_id bigint,
    file_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT not_detached CHECK (((item_id IS NULL) <> (item_submission_id IS NULL)))
);


--
-- Name: item_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_files_id_seq OWNED BY public.item_files.id;


--
-- Name: item_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_integrations (
    item_id bigint NOT NULL,
    integration_data jsonb,
    type public.integration_type NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_submissions (
    id bigint NOT NULL,
    item_id bigint NOT NULL,
    submitter_id bigint,
    submitted_digitally boolean DEFAULT false NOT NULL,
    instructions text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    submitter_discord_id text,
    CONSTRAINT submitter_exists CHECK ((NOT ((submitter_id IS NULL) AND (submitter_discord_id IS NULL))))
);


--
-- Name: item_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_submissions_id_seq OWNED BY public.item_submissions.id;


--
-- Name: item_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_tags (
    id bigint NOT NULL,
    item_id bigint NOT NULL,
    team_tag_id bigint NOT NULL,
    accepted boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_tags_id_seq OWNED BY public.item_tags.id;


--
-- Name: item_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_users (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    item_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_users_id_seq OWNED BY public.item_users.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items (
    id bigint NOT NULL,
    team_scav_hunt_id bigint NOT NULL,
    number integer,
    page_number integer,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    list_category_id bigint,
    points_text text,
    points_value numeric,
    digital_submission boolean NOT NULL,
    special_formatting boolean NOT NULL,
    CONSTRAINT list_category_or_page_number CHECK ((NOT ((page_number IS NULL) AND (list_category_id IS NULL))))
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: list_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.list_categories (
    id bigint NOT NULL,
    name text NOT NULL,
    team_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug text NOT NULL,
    color text
);


--
-- Name: list_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.list_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: list_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.list_categories_id_seq OWNED BY public.list_categories.id;


--
-- Name: page_captains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page_captains (
    id bigint NOT NULL,
    team_scav_hunt_id bigint NOT NULL,
    user_id bigint NOT NULL,
    page_number integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: page_captains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.page_captains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_captains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.page_captains_id_seq OWNED BY public.page_captains.id;


--
-- Name: page_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page_integrations (
    page_id bigint NOT NULL,
    integration_data jsonb,
    type public.integration_type NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id bigint NOT NULL,
    team_scav_hunt_id bigint NOT NULL,
    page_number integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: scav_hunts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scav_hunts (
    id bigint NOT NULL,
    start timestamp without time zone,
    "end" timestamp without time zone,
    name text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug text NOT NULL
);


--
-- Name: scav_hunts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scav_hunts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scav_hunts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scav_hunts_id_seq OWNED BY public.scav_hunts.id;


--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_version (
    version integer NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    ip_address text,
    user_agent text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: team_auths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_auths (
    id bigint NOT NULL,
    team_id bigint,
    creator_id bigint NOT NULL,
    created_for_url text,
    key text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    create_account boolean DEFAULT false NOT NULL,
    ui_password boolean DEFAULT false NOT NULL
);


--
-- Name: team_auths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_auths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_auths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_auths_id_seq OWNED BY public.team_auths.id;


--
-- Name: team_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_integrations (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    integration_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: team_integrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_integrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_integrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_integrations_id_seq OWNED BY public.team_integrations.id;


--
-- Name: team_role_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_role_members (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    team_scav_hunt_id bigint NOT NULL,
    team_role_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: team_role_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_role_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_role_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_role_members_id_seq OWNED BY public.team_role_members.id;


--
-- Name: team_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_roles (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    name text NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: team_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_roles_id_seq OWNED BY public.team_roles.id;


--
-- Name: team_scav_hunts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_scav_hunts (
    id bigint NOT NULL,
    name text NOT NULL,
    scav_hunt_id bigint,
    team_id bigint NOT NULL,
    discord_guild_id text,
    discord_items_channel_id text,
    discord_pages_channel_id text,
    discord_items_message_id text,
    discord_pages_message_id text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    digital_submission_link text
);


--
-- Name: team_scav_hunts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_scav_hunts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_scav_hunts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_scav_hunts_id_seq OWNED BY public.team_scav_hunts.id;


--
-- Name: team_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_tags (
    id bigint NOT NULL,
    name text NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    color text,
    team_id bigint NOT NULL,
    team_role_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    requires_approval boolean DEFAULT false NOT NULL,
    pinned integer
);


--
-- Name: team_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_tags_id_seq OWNED BY public.team_tags.id;


--
-- Name: team_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_users (
    id bigint NOT NULL,
    captain boolean DEFAULT false NOT NULL,
    approved boolean,
    team_id bigint,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: team_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_users_id_seq OWNED BY public.team_users.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    affiliation text NOT NULL,
    prefix text,
    virtual boolean NOT NULL,
    uchicago boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name text NOT NULL,
    email_address text NOT NULL,
    password_digest text NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    discord_id text,
    pronouns text,
    about_me text,
    avatar_data jsonb,
    team_contact text,
    emergency_contact text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: item_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_events ALTER COLUMN id SET DEFAULT nextval('public.item_events_id_seq'::regclass);


--
-- Name: item_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_files ALTER COLUMN id SET DEFAULT nextval('public.item_files_id_seq'::regclass);


--
-- Name: item_submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_submissions ALTER COLUMN id SET DEFAULT nextval('public.item_submissions_id_seq'::regclass);


--
-- Name: item_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_tags ALTER COLUMN id SET DEFAULT nextval('public.item_tags_id_seq'::regclass);


--
-- Name: item_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_users ALTER COLUMN id SET DEFAULT nextval('public.item_users_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: list_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.list_categories ALTER COLUMN id SET DEFAULT nextval('public.list_categories_id_seq'::regclass);


--
-- Name: page_captains id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_captains ALTER COLUMN id SET DEFAULT nextval('public.page_captains_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: scav_hunts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scav_hunts ALTER COLUMN id SET DEFAULT nextval('public.scav_hunts_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: team_auths id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_auths ALTER COLUMN id SET DEFAULT nextval('public.team_auths_id_seq'::regclass);


--
-- Name: team_integrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_integrations ALTER COLUMN id SET DEFAULT nextval('public.team_integrations_id_seq'::regclass);


--
-- Name: team_role_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_role_members ALTER COLUMN id SET DEFAULT nextval('public.team_role_members_id_seq'::regclass);


--
-- Name: team_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_roles ALTER COLUMN id SET DEFAULT nextval('public.team_roles_id_seq'::regclass);


--
-- Name: team_scav_hunts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_scav_hunts ALTER COLUMN id SET DEFAULT nextval('public.team_scav_hunts_id_seq'::regclass);


--
-- Name: team_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_tags ALTER COLUMN id SET DEFAULT nextval('public.team_tags_id_seq'::regclass);


--
-- Name: team_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_users ALTER COLUMN id SET DEFAULT nextval('public.team_users_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: item_events item_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_events
    ADD CONSTRAINT item_events_pkey PRIMARY KEY (id);


--
-- Name: item_files item_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_files
    ADD CONSTRAINT item_files_pkey PRIMARY KEY (id);


--
-- Name: item_integrations item_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_integrations
    ADD CONSTRAINT item_integrations_pkey PRIMARY KEY (type, item_id);


--
-- Name: item_submissions item_submissions_item_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_submissions
    ADD CONSTRAINT item_submissions_item_id_key UNIQUE (item_id);


--
-- Name: item_submissions item_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_submissions
    ADD CONSTRAINT item_submissions_pkey PRIMARY KEY (id);


--
-- Name: item_tags item_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_tags
    ADD CONSTRAINT item_tags_pkey PRIMARY KEY (id);


--
-- Name: item_tags item_tags_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_tags
    ADD CONSTRAINT item_tags_unique UNIQUE (item_id, team_tag_id);


--
-- Name: item_users item_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_users
    ADD CONSTRAINT item_users_pkey PRIMARY KEY (id);


--
-- Name: item_users item_users_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_users
    ADD CONSTRAINT item_users_unique UNIQUE (user_id, item_id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: list_categories list_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.list_categories
    ADD CONSTRAINT list_categories_pkey PRIMARY KEY (id);


--
-- Name: list_categories list_categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.list_categories
    ADD CONSTRAINT list_categories_slug_key UNIQUE (slug);


--
-- Name: page_captains page_captains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_captains
    ADD CONSTRAINT page_captains_pkey PRIMARY KEY (id);


--
-- Name: page_integrations page_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_integrations
    ADD CONSTRAINT page_integrations_pkey PRIMARY KEY (type, page_id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: scav_hunts scav_hunts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scav_hunts
    ADD CONSTRAINT scav_hunts_pkey PRIMARY KEY (id);


--
-- Name: scav_hunts scav_hunts_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scav_hunts
    ADD CONSTRAINT scav_hunts_slug_key UNIQUE (slug);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: team_auths team_auths_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_auths
    ADD CONSTRAINT team_auths_key_key UNIQUE (key);


--
-- Name: team_auths team_auths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_auths
    ADD CONSTRAINT team_auths_pkey PRIMARY KEY (id);


--
-- Name: team_integrations team_integrations_integration_data_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_integrations
    ADD CONSTRAINT team_integrations_integration_data_key UNIQUE (integration_data);


--
-- Name: team_integrations team_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_integrations
    ADD CONSTRAINT team_integrations_pkey PRIMARY KEY (id);


--
-- Name: team_role_members team_role_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_role_members
    ADD CONSTRAINT team_role_members_pkey PRIMARY KEY (id);


--
-- Name: team_role_members team_role_members_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_role_members
    ADD CONSTRAINT team_role_members_unique UNIQUE (user_id, team_scav_hunt_id, team_role_id);


--
-- Name: team_roles team_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_roles
    ADD CONSTRAINT team_roles_pkey PRIMARY KEY (id);


--
-- Name: page_captains team_scav_hunt_pages_page_captains_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_captains
    ADD CONSTRAINT team_scav_hunt_pages_page_captains_unique UNIQUE (page_number, user_id, team_scav_hunt_id);


--
-- Name: pages team_scav_hunt_pages_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT team_scav_hunt_pages_unique UNIQUE (team_scav_hunt_id, page_number);


--
-- Name: team_scav_hunts team_scav_hunt_unique_per_scav_per_team; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_scav_hunts
    ADD CONSTRAINT team_scav_hunt_unique_per_scav_per_team UNIQUE (scav_hunt_id, team_id);


--
-- Name: team_scav_hunts team_scav_hunts_discord_items_channel_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_scav_hunts
    ADD CONSTRAINT team_scav_hunts_discord_items_channel_id_key UNIQUE (discord_items_channel_id);


--
-- Name: team_scav_hunts team_scav_hunts_discord_items_message_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_scav_hunts
    ADD CONSTRAINT team_scav_hunts_discord_items_message_id_key UNIQUE (discord_items_message_id);


--
-- Name: team_scav_hunts team_scav_hunts_discord_pages_channel_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_scav_hunts
    ADD CONSTRAINT team_scav_hunts_discord_pages_channel_id_key UNIQUE (discord_pages_channel_id);


--
-- Name: team_scav_hunts team_scav_hunts_discord_pages_message_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_scav_hunts
    ADD CONSTRAINT team_scav_hunts_discord_pages_message_id_key UNIQUE (discord_pages_message_id);


--
-- Name: team_scav_hunts team_scav_hunts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_scav_hunts
    ADD CONSTRAINT team_scav_hunts_pkey PRIMARY KEY (id);


--
-- Name: team_tags team_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_tags
    ADD CONSTRAINT team_tags_pkey PRIMARY KEY (id);


--
-- Name: team_users team_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_users
    ADD CONSTRAINT team_users_pkey PRIMARY KEY (id);


--
-- Name: team_users team_users_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_users
    ADD CONSTRAINT team_users_unique UNIQUE (team_id, user_id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: teams teams_prefix_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_prefix_key UNIQUE (prefix);


--
-- Name: users users_email_address_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_address_key UNIQUE (email_address);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: item_integrations_discord_message_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX item_integrations_discord_message_id_unique ON public.item_integrations USING btree (((integration_data ->> 'message_id'::text))) WHERE (type = 'discord'::public.integration_type);


--
-- Name: item_integrations_discord_thread_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX item_integrations_discord_thread_id_unique ON public.item_integrations USING btree (((integration_data ->> 'thread_id'::text))) WHERE (type = 'discord'::public.integration_type);


--
-- Name: page_integrations_discord_message_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX page_integrations_discord_message_id_unique ON public.page_integrations USING btree (((integration_data ->> 'message_id'::text))) WHERE (type = 'discord'::public.integration_type);


--
-- Name: page_integrations_discord_thread_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX page_integrations_discord_thread_id_unique ON public.page_integrations USING btree (((integration_data ->> 'thread_id'::text))) WHERE (type = 'discord'::public.integration_type);


--
-- Name: team_scav_hunt_list_category_item_number_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX team_scav_hunt_list_category_item_number_unique ON public.items USING btree (team_scav_hunt_id, COALESCE(list_category_id, ('-1'::integer)::bigint), number);


--
-- Name: item_submissions item_submission_update_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER item_submission_update_notify AFTER INSERT OR DELETE OR UPDATE ON public.item_submissions FOR EACH ROW EXECUTE FUNCTION public.notify_item_submission_update();


--
-- Name: items item_update_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER item_update_notify AFTER INSERT OR UPDATE ON public.items FOR EACH ROW EXECUTE FUNCTION public.notify_item_update();


--
-- Name: item_events item_events_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_events
    ADD CONSTRAINT item_events_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: item_files item_files_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_files
    ADD CONSTRAINT item_files_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: item_files item_files_item_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_files
    ADD CONSTRAINT item_files_item_submission_id_fkey FOREIGN KEY (item_submission_id) REFERENCES public.item_submissions(id);


--
-- Name: item_integrations item_integrations_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_integrations
    ADD CONSTRAINT item_integrations_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: item_submissions item_submissions_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_submissions
    ADD CONSTRAINT item_submissions_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: item_submissions item_submissions_submitter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_submissions
    ADD CONSTRAINT item_submissions_submitter_id_fkey FOREIGN KEY (submitter_id) REFERENCES public.users(id);


--
-- Name: item_tags item_tags_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_tags
    ADD CONSTRAINT item_tags_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: item_tags item_tags_team_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_tags
    ADD CONSTRAINT item_tags_team_tag_id_fkey FOREIGN KEY (team_tag_id) REFERENCES public.team_tags(id);


--
-- Name: item_users item_users_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_users
    ADD CONSTRAINT item_users_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: item_users item_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_users
    ADD CONSTRAINT item_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: items items_list_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_list_category_id_fkey FOREIGN KEY (list_category_id) REFERENCES public.list_categories(id);


--
-- Name: items items_team_scav_hunt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_team_scav_hunt_id_fkey FOREIGN KEY (team_scav_hunt_id) REFERENCES public.team_scav_hunts(id);


--
-- Name: list_categories list_categories_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.list_categories
    ADD CONSTRAINT list_categories_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: page_captains page_captains_team_scav_hunt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_captains
    ADD CONSTRAINT page_captains_team_scav_hunt_id_fkey FOREIGN KEY (team_scav_hunt_id) REFERENCES public.team_scav_hunts(id);


--
-- Name: page_captains page_captains_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_captains
    ADD CONSTRAINT page_captains_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: page_integrations page_integrations_page_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_integrations
    ADD CONSTRAINT page_integrations_page_id_fkey FOREIGN KEY (page_id) REFERENCES public.pages(id);


--
-- Name: pages pages_team_scav_hunt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_team_scav_hunt_id_fkey FOREIGN KEY (team_scav_hunt_id) REFERENCES public.team_scav_hunts(id);


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: team_auths team_auths_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_auths
    ADD CONSTRAINT team_auths_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: team_auths team_auths_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_auths
    ADD CONSTRAINT team_auths_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: team_integrations team_integrations_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_integrations
    ADD CONSTRAINT team_integrations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: team_role_members team_role_members_team_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_role_members
    ADD CONSTRAINT team_role_members_team_role_id_fkey FOREIGN KEY (team_role_id) REFERENCES public.team_roles(id);


--
-- Name: team_role_members team_role_members_team_scav_hunt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_role_members
    ADD CONSTRAINT team_role_members_team_scav_hunt_id_fkey FOREIGN KEY (team_scav_hunt_id) REFERENCES public.team_scav_hunts(id);


--
-- Name: team_role_members team_role_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_role_members
    ADD CONSTRAINT team_role_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: team_roles team_roles_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_roles
    ADD CONSTRAINT team_roles_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: team_scav_hunts team_scav_hunts_scav_hunt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_scav_hunts
    ADD CONSTRAINT team_scav_hunts_scav_hunt_id_fkey FOREIGN KEY (scav_hunt_id) REFERENCES public.scav_hunts(id);


--
-- Name: team_scav_hunts team_scav_hunts_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_scav_hunts
    ADD CONSTRAINT team_scav_hunts_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: team_tags team_tags_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_tags
    ADD CONSTRAINT team_tags_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: team_tags team_tags_team_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_tags
    ADD CONSTRAINT team_tags_team_role_id_fkey FOREIGN KEY (team_role_id) REFERENCES public.team_roles(id);


--
-- Name: team_users team_users_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_users
    ADD CONSTRAINT team_users_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: team_users team_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_users
    ADD CONSTRAINT team_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 6XHDTON0UCXyhG170eCyUUfiUsa3x8nezwrZTpeb2T9ePJTZbEo0LW4HAdGCMCO

