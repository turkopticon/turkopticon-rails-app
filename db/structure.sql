--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.5
-- Dumped by pg_dump version 9.5.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = ON;
SET check_function_bodies = FALSE;
SET client_min_messages = WARNING;
SET row_security = OFF;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = FALSE;

--
-- Name: ab_tests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ab_tests (
  id         INTEGER                     NOT NULL,
  name       CHARACTER VARYING,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: ab_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ab_tests_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: ab_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ab_tests_id_seq OWNED BY ab_tests.id;


--
-- Name: ab_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ab_variants (
  id         INTEGER                     NOT NULL,
  name       CHARACTER VARYING,
  data       JSONB DEFAULT '{
    "sample": 0,
    "conversions": {
      "total": 0,
      "unique": 0
    },
    "distribution": {}
  }' :: JSONB                            NOT NULL,
  test_id    INTEGER,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: ab_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ab_variants_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: ab_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ab_variants_id_seq OWNED BY ab_variants.id;


--
-- Name: aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE aliases (
  id           INTEGER NOT NULL,
  requester_id INTEGER,
  formerly     INTEGER,
  created_at   TIMESTAMP WITHOUT TIME ZONE,
  updated_at   TIMESTAMP WITHOUT TIME ZONE
);


--
-- Name: aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE aliases_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE aliases_id_seq OWNED BY aliases.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
  key        CHARACTER VARYING(255)      NOT NULL,
  value      CHARACTER VARYING(255),
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
  id         INTEGER                     NOT NULL,
  body       TEXT,
  review_id  INTEGER,
  person_id  INTEGER,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE flags (
  id         INTEGER                                                   NOT NULL,
  reason     CHARACTER VARYING,
  context    TEXT,
  person_id  INTEGER,
  review_id  INTEGER,
  created_at TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  open       BOOLEAN DEFAULT TRUE                                      NOT NULL,
  tags       CHARACTER VARYING [] DEFAULT '{}' :: CHARACTER VARYING [] NOT NULL,
  activity   JSONB DEFAULT '[]' :: JSONB                               NOT NULL
);


--
-- Name: flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE flags_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE flags_id_seq OWNED BY flags.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE follows (
  id          INTEGER NOT NULL,
  person_id   INTEGER,
  follow_type CHARACTER VARYING(255),
  follow_id   INTEGER,
  created_at  TIMESTAMP WITHOUT TIME ZONE,
  updated_at  TIMESTAMP WITHOUT TIME ZONE
);


--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE follows_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE follows_id_seq OWNED BY follows.id;


--
-- Name: forum_person_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forum_person_info (
  id                       INTEGER NOT NULL,
  person_id                INTEGER,
  karma                    NUMERIC(5, 2),
  mail_forum_notifications CHARACTER VARYING(255),
  created_at               TIMESTAMP WITHOUT TIME ZONE,
  updated_at               TIMESTAMP WITHOUT TIME ZONE
);


--
-- Name: forum_person_info_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forum_person_info_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: forum_person_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forum_person_info_id_seq OWNED BY forum_person_info.id;


--
-- Name: forum_post_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forum_post_versions (
  id         INTEGER NOT NULL,
  post_id    INTEGER,
  ip         CHARACTER VARYING(255),
  title      TEXT,
  body       TEXT,
  next       INTEGER,
  created_at TIMESTAMP WITHOUT TIME ZONE,
  updated_at TIMESTAMP WITHOUT TIME ZONE,
  person_id  INTEGER
);


--
-- Name: forum_post_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forum_post_versions_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: forum_post_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forum_post_versions_id_seq OWNED BY forum_post_versions.id;


--
-- Name: forum_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forum_posts (
  id                      INTEGER NOT NULL,
  person_id               INTEGER,
  parent_id               INTEGER,
  slug                    CHARACTER VARYING(255),
  sticky                  SMALLINT,
  score                   NUMERIC(5, 2),
  replies                 INTEGER,
  views                   INTEGER,
  last_reply_display_name CHARACTER VARYING(255),
  last_reply_person_id    CHARACTER VARYING(255),
  last_reply_id           INTEGER,
  last_reply_at           TIMESTAMP WITHOUT TIME ZONE,
  created_at              TIMESTAMP WITHOUT TIME ZONE,
  updated_at              TIMESTAMP WITHOUT TIME ZONE,
  thread_head             INTEGER,
  deleted                 SMALLINT,
  initial_score           NUMERIC(5, 2)
);


--
-- Name: forum_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forum_posts_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: forum_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forum_posts_id_seq OWNED BY forum_posts.id;


--
-- Name: hits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hits (
  id           INTEGER                     NOT NULL,
  title        CHARACTER VARYING(255),
  reward       NUMERIC(6, 2),
  requester_id INTEGER,
  created_at   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at   TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: hits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hits_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: hits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hits_id_seq OWNED BY hits.id;


--
-- Name: ignores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ignores (
  id         INTEGER NOT NULL,
  person_id  INTEGER,
  report_id  INTEGER,
  created_at TIMESTAMP WITHOUT TIME ZONE,
  updated_at TIMESTAMP WITHOUT TIME ZONE
);


--
-- Name: ignores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ignores_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: ignores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ignores_id_seq OWNED BY ignores.id;


--
-- Name: legacy_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE legacy_comments (
  id              INTEGER NOT NULL,
  report_id       INTEGER,
  person_id       INTEGER,
  body            TEXT,
  created_at      TIMESTAMP WITHOUT TIME ZONE,
  updated_at      TIMESTAMP WITHOUT TIME ZONE,
  notes           TEXT,
  displayed_notes TEXT
);


--
-- Name: legacy_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE legacy_comments_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: legacy_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE legacy_comments_id_seq OWNED BY legacy_comments.id;


--
-- Name: legacy_flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE legacy_flags (
  id              INTEGER NOT NULL,
  report_id       INTEGER,
  person_id       INTEGER,
  comment         TEXT,
  created_at      TIMESTAMP WITHOUT TIME ZONE,
  updated_at      TIMESTAMP WITHOUT TIME ZONE,
  displayed_notes TEXT
);


--
-- Name: legacy_flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE legacy_flags_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: legacy_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE legacy_flags_id_seq OWNED BY legacy_flags.id;


--
-- Name: legacy_requesters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE legacy_requesters (
  id                           INTEGER NOT NULL,
  amzn_requester_id            CHARACTER VARYING(255),
  amzn_requester_name          CHARACTER VARYING(255),
  created_at                   TIMESTAMP WITHOUT TIME ZONE,
  updated_at                   TIMESTAMP WITHOUT TIME ZONE,
  ava                          NUMERIC(3, 2),
  nrs                          INTEGER,
  av_comm                      NUMERIC(3, 2),
  av_pay                       NUMERIC(3, 2),
  av_fair                      NUMERIC(3, 2),
  av_fast                      NUMERIC(3, 2),
  tos_flags                    INTEGER,
  old_name                     CHARACTER VARYING(255),
  all_rejected                 INTEGER,
  some_rejected                INTEGER,
  all_approved_or_pending      INTEGER,
  all_pending_or_didnt_do_hits INTEGER
);


--
-- Name: legacy_requesters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE legacy_requesters_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: legacy_requesters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE legacy_requesters_id_seq OWNED BY legacy_requesters.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications (
  id         INTEGER NOT NULL,
  person_id  INTEGER,
  title      TEXT,
  body       TEXT,
  read       SMALLINT,
  read_at    TIMESTAMP WITHOUT TIME ZONE,
  created_at TIMESTAMP WITHOUT TIME ZONE,
  updated_at TIMESTAMP WITHOUT TIME ZONE
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE people (
  id                         INTEGER NOT NULL,
  email                      CHARACTER VARYING(255),
  hashed_password            CHARACTER VARYING(255),
  salt                       CHARACTER VARYING(255),
  email_verified             SMALLINT,
  created_at                 TIMESTAMP WITHOUT TIME ZONE,
  updated_at                 TIMESTAMP WITHOUT TIME ZONE,
  is_admin                   SMALLINT,
  display_name               CHARACTER VARYING(255),
  is_moderator               SMALLINT,
  is_closed                  SMALLINT,
  closed_at                  TIMESTAMP WITHOUT TIME ZONE,
  can_comment                SMALLINT,
  commenting_requested       SMALLINT,
  commenting_requested_at    TIMESTAMP WITHOUT TIME ZONE,
  commenting_request_ignored SMALLINT,
  commenting_enabled_by      INTEGER,
  commenting_enabled_at      TIMESTAMP WITHOUT TIME ZONE,
  commenting_disabled_by     INTEGER,
  commenting_disabled_at     TIMESTAMP WITHOUT TIME ZONE,
  confirmation_token         CHARACTER VARYING,
  time_unit                  CHARACTER VARYING(3) DEFAULT 'hr' :: CHARACTER VARYING
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE posts (
  id         INTEGER NOT NULL,
  person_id  INTEGER,
  parent_id  INTEGER,
  title      TEXT,
  body       TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE,
  updated_at TIMESTAMP WITHOUT TIME ZONE,
  slug       CHARACTER VARYING(255),
  is_sticky  SMALLINT
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reports (
  id                  INTEGER NOT NULL,
  person_id           INTEGER,
  requester_id        INTEGER,
  hit_id              CHARACTER VARYING(255),
  description         TEXT,
  created_at          TIMESTAMP WITHOUT TIME ZONE,
  updated_at          TIMESTAMP WITHOUT TIME ZONE,
  how_many_hits       CHARACTER VARYING(255),
  fair                INTEGER,
  fast                INTEGER,
  pay                 INTEGER,
  comm                INTEGER,
  is_flagged          SMALLINT,
  is_hidden           SMALLINT,
  tos_viol            SMALLINT,
  amzn_requester_id   CHARACTER VARYING(255),
  displayed_notes     TEXT,
  amzn_requester_name CHARACTER VARYING(255),
  flag_count          INTEGER,
  comment_count       INTEGER,
  ip                  CHARACTER VARYING(255),
  ignore_count        INTEGER DEFAULT 0,
  hit_names           TEXT,
  dont_censor         SMALLINT,
  rejected            CHARACTER VARYING(255)
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reports_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reports_id_seq OWNED BY reports.id;


--
-- Name: reputation_statements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reputation_statements (
  id         INTEGER NOT NULL,
  person_id  INTEGER,
  post_id    INTEGER,
  statement  CHARACTER VARYING(255),
  effect     NUMERIC(3, 2),
  created_at TIMESTAMP WITHOUT TIME ZONE,
  updated_at TIMESTAMP WITHOUT TIME ZONE,
  ip         CHARACTER VARYING(255)
);


--
-- Name: reputation_statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reputation_statements_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: reputation_statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reputation_statements_id_seq OWNED BY reputation_statements.id;


--
-- Name: requesters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE requesters (
  id         INTEGER                     NOT NULL,
  rname      CHARACTER VARYING(255),
  rid        CHARACTER VARYING(255),
  aliases    TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: requesters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE requesters_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: requesters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE requesters_id_seq OWNED BY requesters.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reviews (
  id                INTEGER                     NOT NULL,
  tos               SMALLINT,
  tos_context       TEXT,
  broken            SMALLINT,
  broken_context    TEXT,
  reward            NUMERIC(6, 2),
  "time"            INTEGER,
  comm              CHARACTER VARYING(255),
  time_pending      INTEGER,
  rejected          CHARACTER VARYING(255),
  recommend         CHARACTER VARYING(255),
  recommend_context TEXT,
  context           TEXT,
  valid_review      SMALLINT DEFAULT 1          NOT NULL,
  hit_id            INTEGER,
  person_id         INTEGER,
  created_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  ip                INET
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reviews_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reviews_id_seq OWNED BY reviews.id;


--
-- Name: rules_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rules_versions (
  id                  INTEGER NOT NULL,
  parent_id           INTEGER,
  is_current          SMALLINT,
  edited_by_person_id INTEGER,
  created_at          TIMESTAMP WITHOUT TIME ZONE,
  updated_at          TIMESTAMP WITHOUT TIME ZONE,
  body                TEXT
);


--
-- Name: rules_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rules_versions_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: rules_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rules_versions_id_seq OWNED BY rules_versions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
  version CHARACTER VARYING(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ab_tests
  ALTER COLUMN id SET DEFAULT nextval('ab_tests_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ab_variants
  ALTER COLUMN id SET DEFAULT nextval('ab_variants_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY aliases
  ALTER COLUMN id SET DEFAULT nextval('aliases_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
  ALTER COLUMN id SET DEFAULT nextval('comments_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY flags
  ALTER COLUMN id SET DEFAULT nextval('flags_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY follows
  ALTER COLUMN id SET DEFAULT nextval('follows_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forum_person_info
  ALTER COLUMN id SET DEFAULT nextval('forum_person_info_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forum_post_versions
  ALTER COLUMN id SET DEFAULT nextval('forum_post_versions_id_seq' :: REGCLASS);

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forum_posts
  ALTER COLUMN id SET DEFAULT nextval('forum_posts_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hits
  ALTER COLUMN id SET DEFAULT nextval('hits_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ignores
  ALTER COLUMN id SET DEFAULT nextval('ignores_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY legacy_comments
  ALTER COLUMN id SET DEFAULT nextval('legacy_comments_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY legacy_flags
  ALTER COLUMN id SET DEFAULT nextval('legacy_flags_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY legacy_requesters
  ALTER COLUMN id SET DEFAULT nextval('legacy_requesters_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
  ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people
  ALTER COLUMN id SET DEFAULT nextval('people_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
  ALTER COLUMN id SET DEFAULT nextval('posts_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports
  ALTER COLUMN id SET DEFAULT nextval('reports_id_seq' :: REGCLASS);

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reputation_statements
  ALTER COLUMN id SET DEFAULT nextval('reputation_statements_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY requesters
  ALTER COLUMN id SET DEFAULT nextval('requesters_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews
  ALTER COLUMN id SET DEFAULT nextval('reviews_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rules_versions
  ALTER COLUMN id SET DEFAULT nextval('rules_versions_id_seq' :: REGCLASS);


--
-- Name: ab_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ab_tests
    ADD CONSTRAINT ab_tests_pkey PRIMARY KEY (id);


--
-- Name: ab_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ab_variants
    ADD CONSTRAINT ab_variants_pkey PRIMARY KEY (id);


--
-- Name: aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY aliases
    ADD CONSTRAINT aliases_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY flags
    ADD CONSTRAINT flags_pkey PRIMARY KEY (id);


--
-- Name: follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: forum_person_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forum_person_info
    ADD CONSTRAINT forum_person_info_pkey PRIMARY KEY (id);


--
-- Name: forum_post_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forum_post_versions
    ADD CONSTRAINT forum_post_versions_pkey PRIMARY KEY (id);


--
-- Name: forum_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forum_posts
    ADD CONSTRAINT forum_posts_pkey PRIMARY KEY (id);


--
-- Name: hits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hits
    ADD CONSTRAINT hits_pkey PRIMARY KEY (id);


--
-- Name: ignores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ignores
    ADD CONSTRAINT ignores_pkey PRIMARY KEY (id);


--
-- Name: legacy_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY legacy_comments
    ADD CONSTRAINT legacy_comments_pkey PRIMARY KEY (id);


--
-- Name: legacy_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY legacy_flags
    ADD CONSTRAINT legacy_flags_pkey PRIMARY KEY (id);


--
-- Name: legacy_requesters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY legacy_requesters
    ADD CONSTRAINT legacy_requesters_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: reputation_statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reputation_statements
    ADD CONSTRAINT reputation_statements_pkey PRIMARY KEY (id);


--
-- Name: requesters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY requesters
    ADD CONSTRAINT requesters_pkey PRIMARY KEY (id);


--
-- Name: reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: rules_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rules_versions
    ADD CONSTRAINT rules_versions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_ab_tests_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ab_tests_on_name
  ON ab_tests USING GIN (name);


--
-- Name: index_ab_variants_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ab_variants_on_name
  ON ab_variants USING GIN (name);

--
-- Name: index_ab_variants_on_test_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ab_variants_on_test_id
  ON ab_variants USING BTREE (test_id);


--
-- Name: index_flags_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flags_on_person_id
  ON flags USING BTREE (person_id);


--
-- Name: index_flags_on_review_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flags_on_review_id
  ON flags USING BTREE (review_id);


--
-- Name: index_flags_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flags_on_tags
  ON flags USING GIN (tags);


--
-- Name: index_people_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_confirmation_token
  ON people USING BTREE (confirmation_token);


--
-- Name: index_reviews_on_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_ip
  ON reviews USING BTREE (ip);


--
-- Name: public_comments_person_id0_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX public_comments_person_id0_idx
  ON comments USING BTREE (person_id);


--
-- Name: public_comments_review_id1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX public_comments_review_id1_idx
  ON comments USING BTREE (review_id);


--
-- Name: public_hits_requester_id0_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX public_hits_requester_id0_idx
  ON hits USING BTREE (requester_id);


--
-- Name: public_hits_title1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX public_hits_title1_idx
  ON hits USING BTREE (title);


--
-- Name: public_requesters_rid0_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX public_requesters_rid0_idx
  ON requesters USING BTREE (rid);


--
-- Name: public_requesters_rname1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX public_requesters_rname1_idx
  ON requesters USING BTREE (rname);


--
-- Name: public_reviews_hit_id0_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX public_reviews_hit_id0_idx
  ON reviews USING BTREE (hit_id);


--
-- Name: public_reviews_person_id1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX public_reviews_person_id1_idx
  ON reviews USING BTREE (person_id);


--
-- Name: comments_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
  ADD CONSTRAINT comments_person_id_fkey FOREIGN KEY (person_id) REFERENCES people (id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: comments_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
  ADD CONSTRAINT comments_review_id_fkey FOREIGN KEY (review_id) REFERENCES reviews (id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fk_rails_05ab74abbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY flags
  ADD CONSTRAINT fk_rails_05ab74abbd FOREIGN KEY (person_id) REFERENCES people (id);


--
-- Name: fk_rails_3fc4766dfa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ab_variants
  ADD CONSTRAINT fk_rails_3fc4766dfa FOREIGN KEY (test_id) REFERENCES ab_tests (id);


--
-- Name: fk_rails_c3ef19e5b1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY flags
  ADD CONSTRAINT fk_rails_c3ef19e5b1 FOREIGN KEY (review_id) REFERENCES reviews (id);


--
-- Name: hits_requester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hits
  ADD CONSTRAINT hits_requester_id_fkey FOREIGN KEY (requester_id) REFERENCES requesters (id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: reviews_hit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews
  ADD CONSTRAINT reviews_hit_id_fkey FOREIGN KEY (hit_id) REFERENCES hits (id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: reviews_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews
  ADD CONSTRAINT reviews_person_id_fkey FOREIGN KEY (person_id) REFERENCES people (id) ON UPDATE RESTRICT ON DELETE RESTRICT;

--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version)
VALUES ('20081109050154'), ('20081109050712'), ('20081109051730'), ('20090107000255'), ('20090113025056'),
  ('20090122051441'), ('20090122051712'), ('20090122052257'), ('20091221013334'), ('20100115233128'),
  ('20100519181406'), ('20111008230458'), ('20111009200858'), ('20111009203912'), ('20120428181518'),
  ('20120708233235'), ('20120729100940'), ('20130405155513'), ('20130604141843'), ('20130612152007'),
  ('20131230165343'), ('20140220231231'), ('20140220234912'), ('20140227223516'), ('20140310175041'),
  ('20140610175616'), ('20140705233200'), ('20140710064828'), ('20140724025105'), ('20140724185244'),
  ('20140724185824'), ('20140724231205'), ('20140725013807'), ('20140807181412'), ('20140808032240'),
  ('20140821190125'), ('20141028232025'), ('20150116221723'), ('20150629184231'), ('20151016075641'),
  ('20151016075745'), ('20151016075830'), ('20151016075850'), ('20151016075923'), ('20151016075941'),
  ('20151018071823'), ('20151019090844'), ('20151019104911'), ('20151019120829'), ('20160318012759'),
  ('20160402221950'), ('20160405220940'), ('20160405223656'), ('20160423213025'), ('20160501145056'),
  ('20161030060407'), ('20161030072001'), ('20161030072723'), ('20161030075457'), ('20161030082820'),
  ('20161030083039'), ('20161119160536'), ('20161225103246'), ('20170125102921'), ('20170125103407'),
  ('20170127204507'), ('20170202193532'), ('20170203220801'), ('20170207064846'), ('20170216121604'),
  ('20170216121845');


