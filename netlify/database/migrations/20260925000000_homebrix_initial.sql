--
-- PostgreSQL database dump
--


-- Dumped from database version 17.11
-- Dumped by pg_dump version 17.11

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
-- Name: AlertFrequency; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AlertFrequency" AS ENUM (
    'instant',
    'daily',
    'weekly',
    'off'
);


--
-- Name: BlogStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."BlogStatus" AS ENUM (
    'draft',
    'published',
    'archived'
);


--
-- Name: BoostPlan; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."BoostPlan" AS ENUM (
    'featured',
    'premium',
    'spotlight'
);


--
-- Name: BoostStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."BoostStatus" AS ENUM (
    'pending',
    'active',
    'expired',
    'failed'
);


--
-- Name: ConstructionStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ConstructionStatus" AS ENUM (
    'new_launch',
    'under_construction',
    'ready_to_move'
);


--
-- Name: JobApplicationStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."JobApplicationStatus" AS ENUM (
    'new',
    'reviewing',
    'shortlisted',
    'rejected',
    'hired'
);


--
-- Name: JobStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."JobStatus" AS ENUM (
    'draft',
    'open',
    'closed'
);


--
-- Name: LandmarkCategory; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."LandmarkCategory" AS ENUM (
    'railway_station',
    'metro_station',
    'bus_stop',
    'bus_depot',
    'highway',
    'airport',
    'expressway',
    'school',
    'college_university',
    'university',
    'coaching',
    'hospital',
    'clinic',
    'pharmacy',
    'mall',
    'market',
    'supermarket',
    'wholesale_market',
    'restaurant',
    'hotel',
    'cinema',
    'resort',
    'it_park',
    'sez',
    'business_park',
    'office_hub',
    'park',
    'garden',
    'sports_complex',
    'stadium',
    'temple',
    'mosque',
    'church',
    'gurudwara',
    'bank',
    'locality',
    'colony',
    'sector',
    'nagar',
    'other'
);


--
-- Name: LaunchStage; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."LaunchStage" AS ENUM (
    'pre_launch',
    'newly_launched',
    'under_construction',
    'nearing_possession',
    'possession_started',
    'completed'
);


--
-- Name: LeadSource; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."LeadSource" AS ENUM (
    'organic',
    'paid',
    'chatbot',
    'whatsapp',
    'referral',
    'direct',
    'social'
);


--
-- Name: LeadStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."LeadStatus" AS ENUM (
    'new',
    'assigned',
    'contacted',
    'interested',
    'visit_scheduled',
    'visited',
    'negotiating',
    'converted',
    'lost',
    'invalid',
    'duplicate'
);


--
-- Name: LeadType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."LeadType" AS ENUM (
    'contact_form',
    'brochure',
    'site_visit',
    'callback',
    'chatbot',
    'whatsapp',
    'call'
);


--
-- Name: MediaType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."MediaType" AS ENUM (
    'photo',
    'video',
    'floor_plan',
    'brochure',
    'site_plan',
    'construction_photo',
    'document'
);


--
-- Name: PlaceSource; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PlaceSource" AS ENUM (
    'builder',
    'rera',
    'manual',
    'osm'
);


--
-- Name: ProjectStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ProjectStatus" AS ENUM (
    'active',
    'sold_out',
    'on_hold',
    'archived'
);


--
-- Name: TravelMode; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."TravelMode" AS ENUM (
    'walk',
    'drive',
    'auto',
    'train',
    'metro',
    'bus'
);


--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserRole" AS ENUM (
    'buyer',
    'cms_editor',
    'cms_admin',
    'super_admin'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: blog_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_posts (
    id text NOT NULL,
    title character varying(300) NOT NULL,
    slug character varying(300) NOT NULL,
    category character varying(100),
    content jsonb NOT NULL,
    excerpt text,
    thumbnail_url text,
    author_id text,
    status public."BlogStatus" DEFAULT 'draft'::public."BlogStatus" NOT NULL,
    published_at timestamp(3) without time zone,
    meta_title character varying(160),
    meta_desc character varying(320),
    og_image_url text,
    tags text[],
    view_count integer DEFAULT 0 NOT NULL,
    reading_time integer,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: builders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.builders (
    id text NOT NULL,
    name character varying(200) NOT NULL,
    slug character varying(200) NOT NULL,
    logo_url text,
    cover_url text,
    established_year integer,
    headquarters character varying(200),
    description text,
    rera_ids jsonb,
    total_delivered integer DEFAULT 0 NOT NULL,
    under_construction integer DEFAULT 0 NOT NULL,
    delivery_rate_pct numeric(5,2),
    trust_score numeric(3,2),
    verified boolean DEFAULT false NOT NULL,
    featured boolean DEFAULT false NOT NULL,
    meta_title character varying(160),
    meta_desc character varying(320),
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: chatbot_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chatbot_sessions (
    id text NOT NULL,
    session_id character varying(100) NOT NULL,
    user_id text,
    messages jsonb DEFAULT '[]'::jsonb NOT NULL,
    intent character varying(50),
    collected_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    lead_captured boolean DEFAULT false NOT NULL,
    lead_id text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    state_id integer NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL,
    lat numeric(10,8),
    lng numeric(11,8),
    is_active boolean DEFAULT true NOT NULL,
    is_metro boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- Name: construction_updates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.construction_updates (
    id text NOT NULL,
    project_id text NOT NULL,
    update_date date NOT NULL,
    title character varying(200),
    description text,
    completion_pct integer,
    created_by text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: job_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_applications (
    id text NOT NULL,
    job_slug character varying(100) NOT NULL,
    job_title character varying(200) NOT NULL,
    name character varying(150) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    resume_url text NOT NULL,
    cover_letter text,
    status public."JobApplicationStatus" DEFAULT 'new'::public."JobApplicationStatus" NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id text NOT NULL,
    slug character varying(150) NOT NULL,
    title character varying(200) NOT NULL,
    department character varying(100) NOT NULL,
    location character varying(150) NOT NULL,
    type character varying(50) NOT NULL,
    description text NOT NULL,
    requirements text[],
    status public."JobStatus" DEFAULT 'open'::public."JobStatus" NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: leads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leads (
    id text NOT NULL,
    project_id text,
    builder_id text,
    name character varying(150),
    phone character varying(20) NOT NULL,
    email character varying(255),
    message text,
    budget_min bigint,
    budget_max bigint,
    bhk_interest integer[],
    timeline character varying(50),
    lead_type public."LeadType" NOT NULL,
    source public."LeadSource" NOT NULL,
    utm_source character varying(100),
    utm_medium character varying(100),
    utm_campaign character varying(100),
    utm_content character varying(100),
    page_url text,
    status public."LeadStatus" DEFAULT 'new'::public."LeadStatus" NOT NULL,
    assigned_to text,
    notes text,
    follow_up_at timestamp(3) without time zone,
    converted_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: listing_boosts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.listing_boosts (
    id text NOT NULL,
    project_id text,
    builder_id text,
    plan public."BoostPlan" NOT NULL,
    amount integer NOT NULL,
    razorpay_order_id character varying(100),
    razorpay_payment_id character varying(100),
    status public."BoostStatus" NOT NULL,
    starts_at timestamp(3) without time zone,
    expires_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: localities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.localities (
    id integer NOT NULL,
    city_id integer NOT NULL,
    name character varying(150) NOT NULL,
    slug character varying(150) NOT NULL,
    lat numeric(10,8),
    lng numeric(11,8),
    avg_price_sqft integer,
    project_count integer DEFAULT 0 NOT NULL,
    is_popular boolean DEFAULT false NOT NULL,
    region_id integer
);


--
-- Name: localities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.localities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: localities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.localities_id_seq OWNED BY public.localities.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media (
    id text NOT NULL,
    project_id text NOT NULL,
    url text NOT NULL,
    thumb_url text,
    media_type public."MediaType" NOT NULL,
    caption character varying(300),
    room_tag character varying(50),
    is_primary boolean DEFAULT false NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.places (
    id text NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    seo_slug character varying(300) NOT NULL,
    category public."LandmarkCategory" NOT NULL,
    city_id integer,
    locality_id integer,
    lat numeric(10,8),
    lng numeric(11,8),
    address text,
    photo_url text,
    rating numeric(3,1),
    review_count integer,
    importance_score integer DEFAULT 50 NOT NULL,
    create_seo_page boolean DEFAULT false NOT NULL,
    seo_priority integer DEFAULT 0 NOT NULL,
    source public."PlaceSource" DEFAULT 'manual'::public."PlaceSource" NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: price_trends; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_trends (
    id integer NOT NULL,
    city_id integer,
    locality_id integer,
    period_start date NOT NULL,
    period_end date NOT NULL,
    avg_price_sqft integer,
    median_price bigint,
    project_count integer,
    yoy_change_pct numeric(5,2),
    qoq_change_pct numeric(5,2),
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: price_trends_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.price_trends_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: price_trends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.price_trends_id_seq OWNED BY public.price_trends.id;


--
-- Name: project_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_configs (
    id text NOT NULL,
    project_id text NOT NULL,
    bhk integer NOT NULL,
    bedrooms integer,
    bathrooms integer,
    area_carpet_min integer,
    area_carpet_max integer,
    area_builtup_min integer,
    area_builtup_max integer,
    price_min bigint,
    price_max bigint,
    floor_plan_url text,
    is_available boolean DEFAULT true NOT NULL,
    display_order integer DEFAULT 0 NOT NULL
);


--
-- Name: project_faqs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_faqs (
    id text NOT NULL,
    project_id text NOT NULL,
    question text NOT NULL,
    answer text NOT NULL,
    display_order integer DEFAULT 0 NOT NULL
);


--
-- Name: project_landmarks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_landmarks (
    id text NOT NULL,
    project_id text NOT NULL,
    category public."LandmarkCategory" NOT NULL,
    name character varying(200) NOT NULL,
    travel_minutes integer,
    display_order integer DEFAULT 0 NOT NULL,
    place_id text,
    distance_m integer,
    distance_label character varying(30),
    travel_mode public."TravelMode" DEFAULT 'drive'::public."TravelMode" NOT NULL,
    lat numeric(10,8),
    lng numeric(11,8),
    show_on_map boolean DEFAULT true NOT NULL,
    is_featured boolean DEFAULT false NOT NULL,
    source public."PlaceSource" DEFAULT 'manual'::public."PlaceSource" NOT NULL
);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id text NOT NULL,
    name character varying(200) NOT NULL,
    slug character varying(200) NOT NULL,
    builder_id text NOT NULL,
    city_id integer NOT NULL,
    locality_id integer,
    lat numeric(10,8),
    lng numeric(11,8),
    address text,
    rera_number character varying(100),
    rera_state character varying(50),
    rera_verified boolean DEFAULT false NOT NULL,
    rera_verified_at timestamp(3) without time zone,
    price_min bigint,
    price_max bigint,
    price_per_sqft_min integer,
    price_per_sqft_max integer,
    area_min_sqft integer,
    area_max_sqft integer,
    total_units integer,
    total_towers integer,
    total_floors integer,
    launch_date date,
    possession_date date,
    construction_pct integer DEFAULT 0 NOT NULL,
    construction_status public."ConstructionStatus" NOT NULL,
    project_status public."ProjectStatus" DEFAULT 'active'::public."ProjectStatus" NOT NULL,
    description text,
    highlights text[],
    amenities jsonb,
    payment_plans jsonb,
    meta_title character varying(160),
    meta_desc character varying(320),
    og_image_url text,
    published boolean DEFAULT false NOT NULL,
    featured boolean DEFAULT false NOT NULL,
    new_launch_badge boolean DEFAULT false NOT NULL,
    hot_deal_badge boolean DEFAULT false NOT NULL,
    rera_badge boolean DEFAULT false NOT NULL,
    view_count integer DEFAULT 0 NOT NULL,
    lead_count integer DEFAULT 0 NOT NULL,
    shortlist_count integer DEFAULT 0 NOT NULL,
    created_by text,
    published_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    launch_stage public."LaunchStage",
    bhk_types integer[] NOT NULL
);


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    city_id integer NOT NULL,
    name character varying(150) NOT NULL,
    slug character varying(150) NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id text NOT NULL,
    project_id text,
    builder_id text,
    user_id text,
    rating_overall numeric(2,1) NOT NULL,
    rating_location numeric(2,1),
    rating_amenities numeric(2,1),
    rating_value numeric(2,1),
    rating_builder numeric(2,1),
    title character varying(200),
    body text,
    verified_buyer boolean DEFAULT false NOT NULL,
    helpful_count integer DEFAULT 0 NOT NULL,
    published boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: saved_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saved_projects (
    id text NOT NULL,
    user_id text NOT NULL,
    project_id text NOT NULL,
    notes text,
    visited boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: saved_searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saved_searches (
    id text NOT NULL,
    user_id text NOT NULL,
    name character varying(200),
    filters jsonb NOT NULL,
    alert_frequency public."AlertFrequency" DEFAULT 'daily'::public."AlertFrequency" NOT NULL,
    alert_channels text[],
    last_notified_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.states (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL,
    stamp_duty jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.states_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.states_id_seq OWNED BY public.states.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    name character varying(150),
    email character varying(255),
    phone character varying(20),
    role public."UserRole" DEFAULT 'buyer'::public."UserRole" NOT NULL,
    avatar_url text,
    verified boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_seen_at timestamp(3) without time zone
);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: localities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.localities ALTER COLUMN id SET DEFAULT nextval('public.localities_id_seq'::regclass);


--
-- Name: price_trends id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_trends ALTER COLUMN id SET DEFAULT nextval('public.price_trends_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states ALTER COLUMN id SET DEFAULT nextval('public.states_id_seq'::regclass);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public._prisma_migrations VALUES ('a2073e8e-3182-4ef7-bc97-642908f598e5', 'f3ab2ed779597022a047fca28a91e72fe69842e8f6e028f7eedc4034e64c3dbb', '2026-08-27 08:23:24.171692+00', '20260827082324_init', NULL, NULL, '2026-08-27 08:23:24.125872+00', 1);
INSERT INTO public._prisma_migrations VALUES ('826f4c98-d994-479f-a630-4b60651d664b', 'dfe94260af4fd9ead77b455ad44f9f0c15f19573e4e8cf2d43867861422938a1', '2026-08-27 13:00:28.484999+00', '20260827130028_add_regions', NULL, NULL, '2026-08-27 13:00:28.479219+00', 1);
INSERT INTO public._prisma_migrations VALUES ('bbb6b309-ac3f-4e8b-86c4-b5d325eb8cb7', '707476c77e01b3bbcb57a0b2be5c9f393a4ebc30c75807ea1cae07df55c73904', '2026-08-27 17:44:52.090709+00', '20260827174452_add_project_faqs_landmarks', NULL, NULL, '2026-08-27 17:44:52.082709+00', 1);
INSERT INTO public._prisma_migrations VALUES ('c92de4fb-c26d-4d7e-9e2a-6a80e0e3572d', 'd787952919654b4c3000bb56375e7d570098813edebeb242d245a5f3fef30c47', '2026-08-29 04:37:19.173515+00', '20260829043719_add_job_applications', NULL, NULL, '2026-08-29 04:37:19.168862+00', 1);
INSERT INTO public._prisma_migrations VALUES ('fe986f3c-a996-4244-a7ea-bcb9da3ee1b6', '4b4529b28609d44840835787fbe82a635b9f798ed0eb629e7fec214609cac8fb', '2026-08-29 06:36:55.294296+00', '20260829063655_add_jobs', NULL, NULL, '2026-08-29 06:36:55.289932+00', 1);
INSERT INTO public._prisma_migrations VALUES ('69b0f4ec-a4eb-4aa4-b816-940a342c882a', 'ccf7b9252949f6936553acab3fa744b5a091b8929eda36f307ca4f8c86a2fbab', '2026-09-20 04:43:13.279687+00', '20260920_phase1_places_landmarks_launch_stage', '', NULL, '2026-09-20 04:43:13.279687+00', 0);


--
-- Data for Name: blog_posts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.blog_posts VALUES ('e20b7cdf-6532-4b3d-9576-29fd1dda08d7', 'RERA Explained: What Every Home Buyer Must Check Before Booking', 'rera-explained-what-to-check-before-booking', 'Legal & RERA', '{"blocks": [{"text": "Why RERA Matters", "type": "heading"}, {"text": "The Real Estate (Regulation and Development) Act, 2016 requires every project above 500 sqm or 8 units to be registered with the state RERA authority before it can be marketed or sold. Registration forces builders to disclose project timelines, land title, and approvals publicly.", "type": "paragraph"}, {"text": "What to Verify", "type": "heading"}, {"text": "Always cross-check the RERA number on the state RERA portal — not just the number the builder shows you. Confirm the promised possession date matches what''s listed on the portal, and check for any past complaints against the project or builder.", "type": "paragraph"}, {"text": "If a project isn''t RERA-registered and it should be, that''s a serious red flag. Walk away or demand registration before booking.", "type": "paragraph"}]}', 'RERA registration protects buyers from delays and fraud. Here''s exactly what to verify before you pay a booking amount.', NULL, 'seed-editor', 'published', '2026-08-27 09:11:03.144', NULL, NULL, NULL, '{RERA,buying-guide,legal}', 0, 6, '2026-08-27 09:11:03.144', '2026-08-29 06:38:24.801');
INSERT INTO public.blog_posts VALUES ('7d8dd567-ec72-4e28-b4c1-28d4b0b33220', 'Under Construction vs Ready to Move: Which Should You Buy?', 'under-construction-vs-ready-to-move', 'Buying Guide', '{"blocks": [{"text": "The Price Gap", "type": "heading"}, {"text": "Under-construction projects are typically priced 10-20% lower than comparable ready-to-move properties, since buyers absorb construction and delivery risk in exchange for the discount.", "type": "paragraph"}, {"text": "GST Matters", "type": "heading"}, {"text": "Under-construction homes attract GST (typically 1% for affordable housing, 5% for others), while ready-to-move properties with a completion certificate are GST-exempt. Factor this into your total cost comparison.", "type": "paragraph"}, {"text": "If you can verify the builder''s track record and the project is RERA-registered with a realistic timeline, under-construction can offer real savings. If certainty matters more than price, ready-to-move removes the guesswork.", "type": "paragraph"}]}', 'Under-construction homes are cheaper but riskier. Ready-to-move properties cost more but remove uncertainty. Here''s how to decide.', NULL, 'seed-editor', 'published', '2026-08-27 09:11:03.145', NULL, NULL, NULL, '{buying-guide,under-construction}', 0, 5, '2026-08-27 09:11:03.146', '2026-08-29 06:38:24.802');
INSERT INTO public.blog_posts VALUES ('9be034eb-0103-4265-b31f-ba0b5fb9ac20', 'Thane Real Estate Market Report — Q2 2026', 'thane-real-estate-market-report-q2-2026', 'Market Reports', '{"blocks": [{"text": "Thane''s residential market recorded steady price appreciation through Q2 2026, driven by improving metro connectivity and a wave of new launches along the Ghodbunder Road corridor.", "type": "paragraph"}, {"text": "Key Numbers", "type": "heading"}, {"text": "Average price per sqft in Ghodbunder Road rose to approximately ₹13,800, up from ₹12,900 a year earlier. Dombivli remains the more affordable entry point for 2 BHK buyers, averaging ₹9,800/sqft.", "type": "paragraph"}, {"text": "Builders including Lodha, Godrej, and Prestige have all announced new launches in the corridor, suggesting continued supply growth to match demand.", "type": "paragraph"}]}', 'Thane''s Ghodbunder Road and Dombivli corridors continue to see strong demand. Here''s what the numbers show this quarter.', NULL, 'seed-editor', 'published', '2026-08-27 09:11:03.146', NULL, NULL, NULL, '{market-report,thane}', 0, 4, '2026-08-27 09:11:03.147', '2026-08-29 06:38:24.804');
INSERT INTO public.blog_posts VALUES ('80acca48-594e-42e0-8aa3-dbae551ff560', 'How Much Home Loan Can You Actually Afford?', 'how-much-home-loan-can-you-afford', 'Home Loans', '{"blocks": [{"text": "Most lenders use a Fixed Obligation to Income Ratio (FOIR) of 40-50%, meaning your total EMIs — including the new home loan — shouldn''t exceed half your monthly income.", "type": "paragraph"}, {"text": "Bank Maximum vs Your Comfortable Maximum", "type": "heading"}, {"text": "Just because a bank approves a ₹80 lakh loan doesn''t mean you should take it. Factor in other goals — retirement savings, children''s education, emergency funds — before committing to the maximum EMI a bank will offer.", "type": "paragraph"}, {"text": "Use an eligibility calculator to see the bank''s number, then work backward from a monthly payment you''re actually comfortable with.", "type": "paragraph"}]}', 'Banks approve loans based on your income, but that doesn''t mean you should borrow the maximum. Here''s how to think about it.', NULL, 'seed-editor', 'published', '2026-08-27 09:11:03.147', NULL, NULL, NULL, '{home-loans,affordability}', 0, 5, '2026-08-27 09:11:03.148', '2026-08-29 06:38:24.805');
INSERT INTO public.blog_posts VALUES ('69464aae-3f55-463a-b1cf-5e95d52f65ae', '5 Localities in Bangalore Poised for Price Growth in 2026', '5-localities-in-bangalore-poised-for-price-growth-in-2026', 'Investment Tips', '{"blocks": [{"text": "Bangalore''s growth corridors continue to shift as metro lines extend and IT parks expand beyond the traditional core. Whitefield and Sarjapur Road remain strong, but a few emerging pockets are worth watching.", "type": "paragraph"}, {"text": "What''s Driving Demand", "type": "heading"}, {"text": "Upcoming metro connectivity, proximity to IT/ITES campuses, and a healthy pipeline of new project launches from established builders are the three consistent signals across the localities showing the strongest price momentum.", "type": "paragraph"}, {"text": "As always, verify RERA status and builder track record before treating any locality trend as a guarantee — market forecasts are directional, not certain.", "type": "paragraph"}]}', 'Infrastructure upgrades and IT expansion are driving demand in specific Bangalore micro-markets. Here''s where to look.', NULL, 'seed-editor', 'published', '2026-08-29 07:00:21.396', NULL, NULL, NULL, '{investment,bangalore,city-guides}', 0, 1, '2026-08-27 09:11:03.149', '2026-08-29 07:00:21.397');


--
-- Data for Name: builders; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.builders VALUES ('72901f71-c492-4dbe-b56b-909d58437666', 'Lodha Group', 'lodha-group', NULL, NULL, 1980, 'Mumbai, Maharashtra', 'One of India''s leading real estate developers, known for large-scale integrated townships and luxury residences.', NULL, 48, 12, 87.00, 4.40, true, true, NULL, NULL, '2026-08-27 08:25:04.313', '2026-08-27 08:25:04.313');
INSERT INTO public.builders VALUES ('7dcc52ca-8088-4be6-8114-fe68cdf277e0', 'Godrej Properties', 'godrej-properties', NULL, NULL, 1990, 'Mumbai, Maharashtra', NULL, NULL, 62, 18, 91.00, 4.50, true, true, NULL, NULL, '2026-08-27 08:25:04.315', '2026-08-27 08:25:04.315');
INSERT INTO public.builders VALUES ('6c05239e-a2e4-412d-9f77-76ed42ecccd0', 'DLF Limited', 'dlf-limited', NULL, NULL, 1946, 'New Delhi', NULL, NULL, 154, 9, 89.00, 4.30, true, true, NULL, NULL, '2026-08-27 08:25:04.317', '2026-08-27 08:25:04.317');
INSERT INTO public.builders VALUES ('611f60c3-d61f-464b-b7ec-24861952cbea', 'Prestige Group', 'prestige-group', NULL, NULL, 1986, 'Bangalore, Karnataka', NULL, NULL, 289, 24, 88.00, 4.40, true, true, NULL, NULL, '2026-08-27 08:25:04.32', '2026-08-27 08:25:04.32');
INSERT INTO public.builders VALUES ('a5c584d2-0528-405e-94ca-7bb657fccd98', 'Sobha Limited', 'sobha-limited', NULL, NULL, 1995, 'Bangalore, Karnataka', NULL, NULL, 173, 15, 92.00, 4.60, true, false, NULL, NULL, '2026-08-27 08:25:04.322', '2026-08-27 08:25:04.322');
INSERT INTO public.builders VALUES ('6e995a6a-eede-43b1-aa06-6f010464d3ca', 'Brigade Group', 'brigade-group', NULL, NULL, 1986, 'Bangalore, Karnataka', NULL, NULL, 90, 11, 90.00, 4.30, true, false, NULL, NULL, '2026-08-27 08:25:04.324', '2026-08-27 08:25:04.324');


--
-- Data for Name: chatbot_sessions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.cities VALUES (1, 1, 'Mumbai', 'mumbai', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (2, 1, 'Thane', 'thane', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (3, 1, 'Pune', 'pune', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (4, 2, 'Bangalore', 'bangalore', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (5, 3, 'Hyderabad', 'hyderabad', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (6, 4, 'Chennai', 'chennai', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (7, 5, 'Delhi', 'delhi', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (8, 7, 'Noida', 'noida', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (9, 6, 'Gurgaon', 'gurgaon', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (10, 8, 'Kolkata', 'kolkata', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (11, 9, 'Ahmedabad', 'ahmedabad', NULL, NULL, true, true, 0);
INSERT INTO public.cities VALUES (12, 1, 'Navi Mumbai', 'navi-mumbai', NULL, NULL, true, true, 0);


--
-- Data for Name: construction_updates; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.construction_updates VALUES ('e13dff4c-72ff-4012-a833-84e4efd7d0be', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.596');
INSERT INTO public.construction_updates VALUES ('44cd0b7b-80cb-4723-b511-3f9786d2f552', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.596');
INSERT INTO public.construction_updates VALUES ('848c43a3-9313-4d37-9bee-d644cce3433b', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.596');
INSERT INTO public.construction_updates VALUES ('9237bb54-7396-4e72-8d0c-ca6eda7cef4e', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.596');
INSERT INTO public.construction_updates VALUES ('0bac7bc3-7af6-43d5-821c-0f21f8e216ec', '56618a36-9c91-4eda-a791-139f4af0bad9', '2025-12-14', 'Foundation work completed', NULL, 10, NULL, '2026-08-27 12:56:22.606');
INSERT INTO public.construction_updates VALUES ('745c4f48-dac4-41e3-b756-4f6fd6a4292e', '56618a36-9c91-4eda-a791-139f4af0bad9', '2026-03-14', 'Structural work in progress', NULL, 24, NULL, '2026-08-27 12:56:22.606');
INSERT INTO public.construction_updates VALUES ('f3a162a0-3c16-4f76-9fd8-439b65225d2c', '56618a36-9c91-4eda-a791-139f4af0bad9', '2026-06-14', 'Brickwork and plastering', NULL, 39, NULL, '2026-08-27 12:56:22.606');
INSERT INTO public.construction_updates VALUES ('7aebaa8c-d278-4c95-a979-ff99b2a0a438', '56618a36-9c91-4eda-a791-139f4af0bad9', '2026-08-14', 'Finishing work underway', NULL, 49, NULL, '2026-08-27 12:56:22.606');
INSERT INTO public.construction_updates VALUES ('520b6877-07e5-46df-8720-162bb137e241', '5be2e843-8490-47fb-96fa-89b50a6341f1', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.611');
INSERT INTO public.construction_updates VALUES ('b70b1d38-e8dc-4eff-8b84-11daa04cc977', '5be2e843-8490-47fb-96fa-89b50a6341f1', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.611');
INSERT INTO public.construction_updates VALUES ('12daf3b5-eff0-4e2a-895b-dc3e0d0141b5', '5be2e843-8490-47fb-96fa-89b50a6341f1', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.611');
INSERT INTO public.construction_updates VALUES ('294519ae-2be7-4ca9-a935-cd83b16c853b', '5be2e843-8490-47fb-96fa-89b50a6341f1', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.611');
INSERT INTO public.construction_updates VALUES ('9fe42089-2cd3-4dbb-a3bf-ca3511bfdf05', '7a197c1d-be5d-43a1-a1f4-fc7524e98672', '2025-12-14', 'Foundation work completed', NULL, 12, NULL, '2026-08-27 12:56:22.62');
INSERT INTO public.construction_updates VALUES ('fc9b5cc6-2444-4e5d-ac9d-2ca2581c271b', '7a197c1d-be5d-43a1-a1f4-fc7524e98672', '2026-03-14', 'Structural work in progress', NULL, 27, NULL, '2026-08-27 12:56:22.62');
INSERT INTO public.construction_updates VALUES ('d6bac27c-0bd4-4477-921a-c010981336cd', '7a197c1d-be5d-43a1-a1f4-fc7524e98672', '2026-06-14', 'Brickwork and plastering', NULL, 42, NULL, '2026-08-27 12:56:22.62');
INSERT INTO public.construction_updates VALUES ('2a5de243-ef1a-4b7d-af01-621c8779f35d', '7a197c1d-be5d-43a1-a1f4-fc7524e98672', '2026-08-14', 'Finishing work underway', NULL, 52, NULL, '2026-08-27 12:56:22.62');
INSERT INTO public.construction_updates VALUES ('619fae37-1801-4481-a018-0d81bd983bc3', 'ad4891db-d75f-4ae0-a70f-bf59b8a2196b', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.625');
INSERT INTO public.construction_updates VALUES ('a3b1558d-359d-4cf1-be55-e5e594c5bdf0', 'ad4891db-d75f-4ae0-a70f-bf59b8a2196b', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.625');
INSERT INTO public.construction_updates VALUES ('e633c476-706d-4e5b-b79d-f7aaa55dfb85', 'ad4891db-d75f-4ae0-a70f-bf59b8a2196b', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.625');
INSERT INTO public.construction_updates VALUES ('6873fb7f-b794-41bf-9cfe-bdf7f935e2d6', 'ad4891db-d75f-4ae0-a70f-bf59b8a2196b', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.625');
INSERT INTO public.construction_updates VALUES ('7f8dcbf0-d7ed-46d0-8b0d-20049b00e8a0', '3678e00a-e158-4eed-bb5a-46c8d71aca6b', '2025-12-14', 'Foundation work completed', NULL, 15, NULL, '2026-08-27 12:56:22.631');
INSERT INTO public.construction_updates VALUES ('09eeea89-39a2-4e09-bb7f-ffc5f2c79ee1', '3678e00a-e158-4eed-bb5a-46c8d71aca6b', '2026-03-14', 'Structural work in progress', NULL, 30, NULL, '2026-08-27 12:56:22.631');
INSERT INTO public.construction_updates VALUES ('257c0b64-2c93-45b3-8fb2-65d7f3423173', '3678e00a-e158-4eed-bb5a-46c8d71aca6b', '2026-06-14', 'Brickwork and plastering', NULL, 45, NULL, '2026-08-27 12:56:22.631');
INSERT INTO public.construction_updates VALUES ('e7534cd9-db75-4821-82c3-471e70cd1125', '3678e00a-e158-4eed-bb5a-46c8d71aca6b', '2026-08-14', 'Finishing work underway', NULL, 55, NULL, '2026-08-27 12:56:22.631');
INSERT INTO public.construction_updates VALUES ('93804c02-3ffe-4e5f-bf9b-106c5eac19a8', '8655dc97-340e-40b7-8c73-782ccedb8cac', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.635');
INSERT INTO public.construction_updates VALUES ('1ecbef10-5f41-41f4-a6b9-f2711aeb567f', '8655dc97-340e-40b7-8c73-782ccedb8cac', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.635');
INSERT INTO public.construction_updates VALUES ('b9820d05-36e3-431d-a2e4-1d1474334a52', '8655dc97-340e-40b7-8c73-782ccedb8cac', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.635');
INSERT INTO public.construction_updates VALUES ('c7b2d2e8-8e36-432b-a5ca-619959bd5830', '8655dc97-340e-40b7-8c73-782ccedb8cac', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.635');
INSERT INTO public.construction_updates VALUES ('1670083f-8be4-4292-8546-151c3a980c30', 'cd0148b0-f341-41b5-928b-e295fa442625', '2025-12-14', 'Foundation work completed', NULL, 18, NULL, '2026-08-27 12:56:22.642');
INSERT INTO public.construction_updates VALUES ('7ece67e9-a567-461c-9649-2bb6e0a6a76c', 'cd0148b0-f341-41b5-928b-e295fa442625', '2026-03-14', 'Structural work in progress', NULL, 33, NULL, '2026-08-27 12:56:22.642');
INSERT INTO public.construction_updates VALUES ('513129c0-0351-467f-b500-483698165869', 'cd0148b0-f341-41b5-928b-e295fa442625', '2026-06-14', 'Brickwork and plastering', NULL, 48, NULL, '2026-08-27 12:56:22.642');
INSERT INTO public.construction_updates VALUES ('1e421b4f-3f62-48b4-83aa-33761cd714f5', 'cd0148b0-f341-41b5-928b-e295fa442625', '2026-08-14', 'Finishing work underway', NULL, 58, NULL, '2026-08-27 12:56:22.642');
INSERT INTO public.construction_updates VALUES ('eb79d2c2-8984-465c-a2c3-5f598833aa59', '91353136-fbdf-4531-bec5-9f705c92762e', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.645');
INSERT INTO public.construction_updates VALUES ('3fbbb9a9-d0d1-4fdf-b6c2-495e67fc2919', '91353136-fbdf-4531-bec5-9f705c92762e', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.645');
INSERT INTO public.construction_updates VALUES ('3290bf37-3087-4092-a0bd-30393abbcb58', '91353136-fbdf-4531-bec5-9f705c92762e', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.645');
INSERT INTO public.construction_updates VALUES ('7cdee3e2-4bd4-4cf5-af67-6d5deb3bc413', '91353136-fbdf-4531-bec5-9f705c92762e', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.645');
INSERT INTO public.construction_updates VALUES ('419140dc-97d4-4b0f-b531-86184f4cbe87', '6c3a4a7f-af00-4aac-82a5-663c1e041d7f', '2025-12-14', 'Foundation work completed', NULL, 21, NULL, '2026-08-27 12:56:22.65');
INSERT INTO public.construction_updates VALUES ('094066f5-9424-4b9b-b4eb-8a47be760c3c', '6c3a4a7f-af00-4aac-82a5-663c1e041d7f', '2026-03-14', 'Structural work in progress', NULL, 36, NULL, '2026-08-27 12:56:22.65');
INSERT INTO public.construction_updates VALUES ('19772016-e008-4124-9907-05a19a1cc865', '6c3a4a7f-af00-4aac-82a5-663c1e041d7f', '2026-06-14', 'Brickwork and plastering', NULL, 51, NULL, '2026-08-27 12:56:22.65');
INSERT INTO public.construction_updates VALUES ('50f6d639-7bc6-464a-8b8a-488be8d27ea2', '6c3a4a7f-af00-4aac-82a5-663c1e041d7f', '2026-08-14', 'Finishing work underway', NULL, 61, NULL, '2026-08-27 12:56:22.65');
INSERT INTO public.construction_updates VALUES ('83a3f554-b3ab-41d8-992e-e126c120d701', 'df27a43e-a829-4dc9-94f9-0effb25deae1', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.653');
INSERT INTO public.construction_updates VALUES ('6108dcae-4660-49a9-befb-ddd2a57e3fe8', 'df27a43e-a829-4dc9-94f9-0effb25deae1', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.653');
INSERT INTO public.construction_updates VALUES ('eda6930b-8050-4b22-ac57-facfed4f737a', 'df27a43e-a829-4dc9-94f9-0effb25deae1', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.653');
INSERT INTO public.construction_updates VALUES ('8dcb7b7a-a7c7-4fbc-8a23-2fbbe82f86e7', 'df27a43e-a829-4dc9-94f9-0effb25deae1', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.653');
INSERT INTO public.construction_updates VALUES ('88dd31e2-4adb-4709-9881-46a786dc0fb2', 'bb3b93a7-2f00-4fb7-b337-c9d15254590f', '2025-12-14', 'Foundation work completed', NULL, 24, NULL, '2026-08-27 12:56:22.661');
INSERT INTO public.construction_updates VALUES ('2d0512b7-11ae-4948-a630-d26d6e1402b2', 'bb3b93a7-2f00-4fb7-b337-c9d15254590f', '2026-03-14', 'Structural work in progress', NULL, 39, NULL, '2026-08-27 12:56:22.661');
INSERT INTO public.construction_updates VALUES ('1a2204c7-3bcc-4a83-b08b-3ec3e9f5de92', 'bb3b93a7-2f00-4fb7-b337-c9d15254590f', '2026-06-14', 'Brickwork and plastering', NULL, 54, NULL, '2026-08-27 12:56:22.661');
INSERT INTO public.construction_updates VALUES ('678a10d2-4a5e-4bfc-ab88-9185d3a23ec3', 'bb3b93a7-2f00-4fb7-b337-c9d15254590f', '2026-08-14', 'Finishing work underway', NULL, 64, NULL, '2026-08-27 12:56:22.661');
INSERT INTO public.construction_updates VALUES ('b657a28c-4748-441a-89ec-1d1b403c9b97', 'c9df9707-366c-4355-8f09-ee5a22782620', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.664');
INSERT INTO public.construction_updates VALUES ('c47c5501-818c-4649-99bd-6abaf7d2b9b7', 'c9df9707-366c-4355-8f09-ee5a22782620', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.664');
INSERT INTO public.construction_updates VALUES ('93fb577e-4654-4887-8083-470345b1da01', 'c9df9707-366c-4355-8f09-ee5a22782620', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.664');
INSERT INTO public.construction_updates VALUES ('73deb2c8-078c-4963-979e-8ec1a4768803', 'c9df9707-366c-4355-8f09-ee5a22782620', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.664');
INSERT INTO public.construction_updates VALUES ('6c1dc4ee-8370-4e78-96d6-9e44aab102e4', '22fc0e18-fa8c-49ae-8704-0cf540e9512e', '2025-12-14', 'Foundation work completed', NULL, 27, NULL, '2026-08-27 12:56:22.67');
INSERT INTO public.construction_updates VALUES ('4111dfce-dc55-44c6-aa88-ffc96f5f2eea', '22fc0e18-fa8c-49ae-8704-0cf540e9512e', '2026-03-14', 'Structural work in progress', NULL, 42, NULL, '2026-08-27 12:56:22.67');
INSERT INTO public.construction_updates VALUES ('2d8ee697-5a02-4a6b-ab7d-10ddbbfd83b5', '22fc0e18-fa8c-49ae-8704-0cf540e9512e', '2026-06-14', 'Brickwork and plastering', NULL, 57, NULL, '2026-08-27 12:56:22.67');
INSERT INTO public.construction_updates VALUES ('8c5d9329-c78d-48e0-9e09-02c0af02afbc', '22fc0e18-fa8c-49ae-8704-0cf540e9512e', '2026-08-14', 'Finishing work underway', NULL, 67, NULL, '2026-08-27 12:56:22.67');
INSERT INTO public.construction_updates VALUES ('b45012ff-a382-4a91-824f-581340416027', 'a6c96f8f-6b72-476f-8728-d61191e56719', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.673');
INSERT INTO public.construction_updates VALUES ('69a573be-04ab-4511-a4fb-f2e6b1be8758', 'a6c96f8f-6b72-476f-8728-d61191e56719', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.673');
INSERT INTO public.construction_updates VALUES ('7daa7468-cdcb-40ae-93e4-d5a9342d859c', 'a6c96f8f-6b72-476f-8728-d61191e56719', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.673');
INSERT INTO public.construction_updates VALUES ('b860a47d-5a87-4015-a155-282bf27753a9', 'a6c96f8f-6b72-476f-8728-d61191e56719', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.673');
INSERT INTO public.construction_updates VALUES ('6e0805c2-1a36-4866-b1c0-8655199d4205', '7acee28a-a2b5-4fa8-bb49-026d2092a59e', '2025-12-14', 'Foundation work completed', NULL, 30, NULL, '2026-08-27 12:56:22.68');
INSERT INTO public.construction_updates VALUES ('af399426-4615-48e5-a98d-51f99a1da984', '7acee28a-a2b5-4fa8-bb49-026d2092a59e', '2026-03-14', 'Structural work in progress', NULL, 45, NULL, '2026-08-27 12:56:22.68');
INSERT INTO public.construction_updates VALUES ('f765c563-46c5-4148-b565-b22fabb3162b', '7acee28a-a2b5-4fa8-bb49-026d2092a59e', '2026-06-14', 'Brickwork and plastering', NULL, 60, NULL, '2026-08-27 12:56:22.68');
INSERT INTO public.construction_updates VALUES ('9ffc1feb-8ae8-4efa-b50b-da1cd023dc9e', '7acee28a-a2b5-4fa8-bb49-026d2092a59e', '2026-08-14', 'Finishing work underway', NULL, 70, NULL, '2026-08-27 12:56:22.68');
INSERT INTO public.construction_updates VALUES ('6a6517d7-e8b1-4dba-8555-adccec19b29e', '71f2aa94-8364-489c-b55a-334b870fe1e1', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.684');
INSERT INTO public.construction_updates VALUES ('44c60ccb-7c59-4bdc-b66e-155a07c71cb6', '71f2aa94-8364-489c-b55a-334b870fe1e1', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.684');
INSERT INTO public.construction_updates VALUES ('03a9819f-c494-4e10-a358-b82a6bfc63bd', '71f2aa94-8364-489c-b55a-334b870fe1e1', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.684');
INSERT INTO public.construction_updates VALUES ('47982d61-e8dc-45f0-a2c1-68022799e044', '71f2aa94-8364-489c-b55a-334b870fe1e1', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.684');
INSERT INTO public.construction_updates VALUES ('ce242074-a472-4176-8897-1e9c87d21752', '2993189b-9541-42f7-b75d-b4077f035cb0', '2025-12-14', 'Foundation work completed', NULL, 33, NULL, '2026-08-27 12:56:22.69');
INSERT INTO public.construction_updates VALUES ('3bbc2aea-7ab3-4d5e-966a-1f6c5601643b', '2993189b-9541-42f7-b75d-b4077f035cb0', '2026-03-14', 'Structural work in progress', NULL, 48, NULL, '2026-08-27 12:56:22.69');
INSERT INTO public.construction_updates VALUES ('2398ee40-9564-4fef-ad17-3fd51cf6ecf0', '2993189b-9541-42f7-b75d-b4077f035cb0', '2026-06-14', 'Brickwork and plastering', NULL, 63, NULL, '2026-08-27 12:56:22.69');
INSERT INTO public.construction_updates VALUES ('a4e13d69-d46e-4ef4-85c6-0cb29f745c11', '2993189b-9541-42f7-b75d-b4077f035cb0', '2026-08-14', 'Finishing work underway', NULL, 73, NULL, '2026-08-27 12:56:22.69');
INSERT INTO public.construction_updates VALUES ('c30d5da1-bf8e-4ed0-b6ca-b943472b6df0', '2d0fb463-8bbd-40d8-a10c-3e7441102c1e', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 12:56:22.693');
INSERT INTO public.construction_updates VALUES ('284f90ba-1ca6-4c5d-bf68-7fecfecea3fd', '2d0fb463-8bbd-40d8-a10c-3e7441102c1e', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 12:56:22.693');
INSERT INTO public.construction_updates VALUES ('7fc23463-0c4a-44f0-8b28-7c027854f83d', '2d0fb463-8bbd-40d8-a10c-3e7441102c1e', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 12:56:22.693');
INSERT INTO public.construction_updates VALUES ('37177745-2468-450c-8dcf-554b53565ccf', '2d0fb463-8bbd-40d8-a10c-3e7441102c1e', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 12:56:22.693');
INSERT INTO public.construction_updates VALUES ('88995505-3d86-49b3-8082-d2e632c31519', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.821');
INSERT INTO public.construction_updates VALUES ('d4be84fd-678a-40bc-bd56-5a1709da2352', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.821');
INSERT INTO public.construction_updates VALUES ('3dc415e3-5071-45c1-8d9d-f03bfcb83d47', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.821');
INSERT INTO public.construction_updates VALUES ('3361a1d9-4097-484f-8670-9e1eb902aea4', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', '2025-12-14', 'Foundation work completed', NULL, 30, NULL, '2026-08-27 13:02:22.828');
INSERT INTO public.construction_updates VALUES ('bf0c9e63-382d-4f3d-a2fc-ffb69ccd806c', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', '2026-03-14', 'Structural work in progress', NULL, 45, NULL, '2026-08-27 13:02:22.828');
INSERT INTO public.construction_updates VALUES ('82b3cb44-ae58-42e7-97c0-fe902cbe3573', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', '2026-06-14', 'Brickwork and plastering', NULL, 60, NULL, '2026-08-27 13:02:22.828');
INSERT INTO public.construction_updates VALUES ('aa7e7de6-9e3b-4b7f-8041-f9a6e3010da0', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', '2026-08-14', 'Finishing work underway', NULL, 70, NULL, '2026-08-27 13:02:22.828');
INSERT INTO public.construction_updates VALUES ('086933be-2398-47e0-9896-84a776b869c3', 'b51e5f2e-9914-43d6-8388-65054f711f30', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.831');
INSERT INTO public.construction_updates VALUES ('c0116d82-6189-41b1-889c-81287ffa39a9', 'b51e5f2e-9914-43d6-8388-65054f711f30', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.831');
INSERT INTO public.construction_updates VALUES ('a05a6542-1308-42fe-9fc1-aa2ec2fc7d65', 'b51e5f2e-9914-43d6-8388-65054f711f30', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.831');
INSERT INTO public.construction_updates VALUES ('61c4f850-f337-4903-bf90-d2fc280de114', 'b51e5f2e-9914-43d6-8388-65054f711f30', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.831');
INSERT INTO public.construction_updates VALUES ('0c5bd288-f1ee-4fdf-bbf5-26e4f54dcf88', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', '2025-12-14', 'Foundation work completed', NULL, 33, NULL, '2026-08-27 13:02:22.836');
INSERT INTO public.construction_updates VALUES ('dac09f1c-51d2-4b45-a9d7-3a0c8105f7ed', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', '2026-03-14', 'Structural work in progress', NULL, 48, NULL, '2026-08-27 13:02:22.836');
INSERT INTO public.construction_updates VALUES ('24c2b913-aa90-45ea-ae76-3d88daba55c4', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', '2026-06-14', 'Brickwork and plastering', NULL, 63, NULL, '2026-08-27 13:02:22.836');
INSERT INTO public.construction_updates VALUES ('3f5734d4-8f66-43e4-b796-668d738e742c', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', '2026-08-14', 'Finishing work underway', NULL, 73, NULL, '2026-08-27 13:02:22.836');
INSERT INTO public.construction_updates VALUES ('7ddd0a35-0227-4d9c-891f-bf694e2c9fd0', '7650bd3b-845f-4ca5-938d-d1e233240b61', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.84');
INSERT INTO public.construction_updates VALUES ('6f74e452-7e72-46c2-a283-dc89caabedbc', '7650bd3b-845f-4ca5-938d-d1e233240b61', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.84');
INSERT INTO public.construction_updates VALUES ('5aab8e60-8653-4b20-a999-902b1317a7d5', '7650bd3b-845f-4ca5-938d-d1e233240b61', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.84');
INSERT INTO public.construction_updates VALUES ('2d27db30-12dd-4e74-b123-003d86ac4c9f', '7650bd3b-845f-4ca5-938d-d1e233240b61', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.84');
INSERT INTO public.construction_updates VALUES ('297ccb9e-f657-4f37-bb1c-cc8aab89bbf7', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', '2025-12-14', 'Foundation work completed', NULL, 36, NULL, '2026-08-27 13:02:22.846');
INSERT INTO public.construction_updates VALUES ('b00978bd-faad-4a6b-b38b-f470eab85c90', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', '2026-03-14', 'Structural work in progress', NULL, 51, NULL, '2026-08-27 13:02:22.846');
INSERT INTO public.construction_updates VALUES ('302453f1-362e-4be3-a521-36e35f338587', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', '2026-06-14', 'Brickwork and plastering', NULL, 66, NULL, '2026-08-27 13:02:22.846');
INSERT INTO public.construction_updates VALUES ('b66d1427-fe1a-44dd-ac50-d2de64b97695', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', '2026-08-14', 'Finishing work underway', NULL, 76, NULL, '2026-08-27 13:02:22.846');
INSERT INTO public.construction_updates VALUES ('9eb2e1c5-a3eb-4b82-849f-a45001b8fb5d', 'd0271af1-4898-4863-89ee-b7f4ae50718b', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.849');
INSERT INTO public.construction_updates VALUES ('b4c6ab69-ce36-4a1f-9149-2261e61bd67e', 'd0271af1-4898-4863-89ee-b7f4ae50718b', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.849');
INSERT INTO public.construction_updates VALUES ('6d453eb7-5fb9-43b4-8170-e84faf51ef88', 'd0271af1-4898-4863-89ee-b7f4ae50718b', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.849');
INSERT INTO public.construction_updates VALUES ('33e8321a-8f80-43d4-8b5e-bcebf30a9d1a', 'd0271af1-4898-4863-89ee-b7f4ae50718b', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.849');
INSERT INTO public.construction_updates VALUES ('6e3171cd-b792-475a-9cb7-ba7606664ca8', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', '2025-12-14', 'Foundation work completed', NULL, 39, NULL, '2026-08-27 13:02:22.854');
INSERT INTO public.construction_updates VALUES ('119c7188-ab5e-4d45-ac9a-269e7d707c6c', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', '2026-03-14', 'Structural work in progress', NULL, 54, NULL, '2026-08-27 13:02:22.854');
INSERT INTO public.construction_updates VALUES ('e66f0f1c-587b-4188-a188-193edb05babd', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', '2026-06-14', 'Brickwork and plastering', NULL, 69, NULL, '2026-08-27 13:02:22.854');
INSERT INTO public.construction_updates VALUES ('a5a3e0f4-8bcc-46f0-9d5b-5256a4f2ab5c', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', '2026-08-14', 'Finishing work underway', NULL, 79, NULL, '2026-08-27 13:02:22.854');
INSERT INTO public.construction_updates VALUES ('4d1ece1f-7d35-4b62-9c9d-fd566398ea24', 'c04c6e65-f054-4267-a246-b3cca1efac98', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.856');
INSERT INTO public.construction_updates VALUES ('006227c0-402a-4a71-b21b-52997b67c47a', 'c04c6e65-f054-4267-a246-b3cca1efac98', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.856');
INSERT INTO public.construction_updates VALUES ('319dfdaa-2255-4d0e-b398-a9c51c8ccee8', 'c04c6e65-f054-4267-a246-b3cca1efac98', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.856');
INSERT INTO public.construction_updates VALUES ('00d31046-e85c-4ba7-a0a3-40b2ee46a67c', 'acfc42a9-2060-4408-ac25-16a6a719b844', '2025-12-14', 'Foundation work completed', NULL, 10, NULL, '2026-08-27 08:49:58.917');
INSERT INTO public.construction_updates VALUES ('272121db-01a9-49a5-b3ab-66df4b42c1c8', 'acfc42a9-2060-4408-ac25-16a6a719b844', '2026-03-14', 'Structural work in progress', NULL, 21, NULL, '2026-08-27 08:49:58.917');
INSERT INTO public.construction_updates VALUES ('45179de9-0da9-4f62-8ae6-8dfb54d5183f', 'acfc42a9-2060-4408-ac25-16a6a719b844', '2026-06-14', 'Brickwork and plastering', NULL, 36, NULL, '2026-08-27 08:49:58.917');
INSERT INTO public.construction_updates VALUES ('e9905c5f-b8b8-4952-9f0c-5c633141450f', 'acfc42a9-2060-4408-ac25-16a6a719b844', '2026-08-14', 'Finishing work underway', NULL, 46, NULL, '2026-08-27 08:49:58.917');
INSERT INTO public.construction_updates VALUES ('8fb5472d-a8ff-4e52-89dd-8e9cbd4fa0e5', '11623247-dca1-4b47-b290-b7d53f19241b', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 08:49:58.922');
INSERT INTO public.construction_updates VALUES ('9c84e24d-70fb-4afa-a2b7-28e5ededa7eb', '11623247-dca1-4b47-b290-b7d53f19241b', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 08:49:58.922');
INSERT INTO public.construction_updates VALUES ('ec2f38bd-146c-42f0-9ed2-12779560d13d', '11623247-dca1-4b47-b290-b7d53f19241b', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 08:49:58.922');
INSERT INTO public.construction_updates VALUES ('92d6889a-d125-458e-8e38-e55d02eefc94', '11623247-dca1-4b47-b290-b7d53f19241b', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 08:49:58.922');
INSERT INTO public.construction_updates VALUES ('185e1b9a-7cd8-4768-8882-4271f9911b40', '8f1e7d41-2fee-48f0-8059-1b6fbf82d50a', '2025-12-14', 'Foundation work completed', NULL, 10, NULL, '2026-08-27 08:49:58.933');
INSERT INTO public.construction_updates VALUES ('21ff2881-33b3-44ee-b784-bd38db8405e6', '8f1e7d41-2fee-48f0-8059-1b6fbf82d50a', '2026-03-14', 'Structural work in progress', NULL, 24, NULL, '2026-08-27 08:49:58.933');
INSERT INTO public.construction_updates VALUES ('689d00d2-24cb-4d11-9e49-35752288fda7', '8f1e7d41-2fee-48f0-8059-1b6fbf82d50a', '2026-06-14', 'Brickwork and plastering', NULL, 39, NULL, '2026-08-27 08:49:58.933');
INSERT INTO public.construction_updates VALUES ('18897c57-101e-4dc8-96fd-382732d26a3e', '8f1e7d41-2fee-48f0-8059-1b6fbf82d50a', '2026-08-14', 'Finishing work underway', NULL, 49, NULL, '2026-08-27 08:49:58.933');
INSERT INTO public.construction_updates VALUES ('ae3b6ef0-350f-4600-97a2-ac40cd54e416', 'd06f4375-b054-4c98-98ab-7eed73453bfc', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 08:49:58.937');
INSERT INTO public.construction_updates VALUES ('f4c063c1-ca73-4862-9829-7bd79c0f50cd', 'd06f4375-b054-4c98-98ab-7eed73453bfc', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 08:49:58.937');
INSERT INTO public.construction_updates VALUES ('e39a5814-e4b2-4d88-930a-2c5c1052c1d3', 'd06f4375-b054-4c98-98ab-7eed73453bfc', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 08:49:58.937');
INSERT INTO public.construction_updates VALUES ('0d07d8a3-eb97-44b2-a505-7340b2d30692', 'd06f4375-b054-4c98-98ab-7eed73453bfc', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 08:49:58.937');
INSERT INTO public.construction_updates VALUES ('38f5b7b7-b7d1-49b5-aa49-ba2a9aea5079', 'cb9eaa1a-e68f-4fd4-b892-f6b245d12d00', '2025-12-14', 'Foundation work completed', NULL, 12, NULL, '2026-08-27 08:49:58.944');
INSERT INTO public.construction_updates VALUES ('300dfac4-0bb8-4f33-8da7-c1c71038c983', 'cb9eaa1a-e68f-4fd4-b892-f6b245d12d00', '2026-03-14', 'Structural work in progress', NULL, 27, NULL, '2026-08-27 08:49:58.944');
INSERT INTO public.construction_updates VALUES ('0be444eb-2f45-4dbf-a178-5b06da2d009f', 'cb9eaa1a-e68f-4fd4-b892-f6b245d12d00', '2026-06-14', 'Brickwork and plastering', NULL, 42, NULL, '2026-08-27 08:49:58.944');
INSERT INTO public.construction_updates VALUES ('14c4fc32-8cca-40db-9b42-f7f6c077cc1d', 'cb9eaa1a-e68f-4fd4-b892-f6b245d12d00', '2026-08-14', 'Finishing work underway', NULL, 52, NULL, '2026-08-27 08:49:58.944');
INSERT INTO public.construction_updates VALUES ('b6d63ee6-0c9a-40d9-8ced-5692063a1e42', '757cb567-26c9-4e7b-b6f2-6304699856f1', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 08:49:58.948');
INSERT INTO public.construction_updates VALUES ('5f94144c-05b8-4e67-8760-e14ce42c41aa', '757cb567-26c9-4e7b-b6f2-6304699856f1', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 08:49:58.948');
INSERT INTO public.construction_updates VALUES ('85fad95a-50f8-4043-833e-7901abe35da1', '757cb567-26c9-4e7b-b6f2-6304699856f1', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 08:49:58.948');
INSERT INTO public.construction_updates VALUES ('ea83336b-02bc-4ac1-8b4d-a1b64b6dd853', '757cb567-26c9-4e7b-b6f2-6304699856f1', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 08:49:58.948');
INSERT INTO public.construction_updates VALUES ('d9da44b6-d3a4-4e52-a82f-a118d7319004', '96b01e7f-7477-4b03-bf64-58b13e4ba558', '2025-12-14', 'Foundation work completed', NULL, 15, NULL, '2026-08-27 08:49:58.956');
INSERT INTO public.construction_updates VALUES ('37de462e-20df-4fda-8e16-ae1e69600842', '96b01e7f-7477-4b03-bf64-58b13e4ba558', '2026-03-14', 'Structural work in progress', NULL, 30, NULL, '2026-08-27 08:49:58.956');
INSERT INTO public.construction_updates VALUES ('a4402c83-12f4-4586-bcb7-f14c87327d60', '96b01e7f-7477-4b03-bf64-58b13e4ba558', '2026-06-14', 'Brickwork and plastering', NULL, 45, NULL, '2026-08-27 08:49:58.956');
INSERT INTO public.construction_updates VALUES ('f8e96134-7d4d-490d-a248-11f893bebeca', '96b01e7f-7477-4b03-bf64-58b13e4ba558', '2026-08-14', 'Finishing work underway', NULL, 55, NULL, '2026-08-27 08:49:58.956');
INSERT INTO public.construction_updates VALUES ('c258a754-3aee-4901-a56d-a5de6eb786e9', '1448e541-3683-46d3-a150-460c45498116', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 08:49:58.96');
INSERT INTO public.construction_updates VALUES ('65c65058-ace0-4f4c-9d3e-4b34c93fefc7', '1448e541-3683-46d3-a150-460c45498116', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 08:49:58.96');
INSERT INTO public.construction_updates VALUES ('d2db7eb1-7d2e-4ecd-be78-8f33a036ae22', '1448e541-3683-46d3-a150-460c45498116', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 08:49:58.96');
INSERT INTO public.construction_updates VALUES ('c670138b-511d-4619-aed7-1dba5aa37fc6', '1448e541-3683-46d3-a150-460c45498116', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 08:49:58.96');
INSERT INTO public.construction_updates VALUES ('a77f802a-3df4-4922-acdf-06bcebfb4b37', '7ad80e2a-7937-4695-b5fc-0c02faed85ed', '2025-12-14', 'Foundation work completed', NULL, 18, NULL, '2026-08-27 08:49:58.967');
INSERT INTO public.construction_updates VALUES ('ba0c8896-dd44-41ab-bc28-658e5f9e2e9a', '7ad80e2a-7937-4695-b5fc-0c02faed85ed', '2026-03-14', 'Structural work in progress', NULL, 33, NULL, '2026-08-27 08:49:58.967');
INSERT INTO public.construction_updates VALUES ('9a1558cd-216a-4165-9668-5263578ed41c', '7ad80e2a-7937-4695-b5fc-0c02faed85ed', '2026-06-14', 'Brickwork and plastering', NULL, 48, NULL, '2026-08-27 08:49:58.967');
INSERT INTO public.construction_updates VALUES ('b08335c1-7c84-4bad-9d3b-320fb02ab1d9', '7ad80e2a-7937-4695-b5fc-0c02faed85ed', '2026-08-14', 'Finishing work underway', NULL, 58, NULL, '2026-08-27 08:49:58.967');
INSERT INTO public.construction_updates VALUES ('53d74576-77aa-4d21-9f53-62ad3999f1e4', '5e020c7d-7616-4586-8c1f-b92871600782', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 08:49:58.97');
INSERT INTO public.construction_updates VALUES ('b39d085e-757a-4d92-8791-dd0f67d23034', '5e020c7d-7616-4586-8c1f-b92871600782', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 08:49:58.97');
INSERT INTO public.construction_updates VALUES ('035078e6-868d-4a13-9fe1-14a1f27f50e1', '5e020c7d-7616-4586-8c1f-b92871600782', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 08:49:58.97');
INSERT INTO public.construction_updates VALUES ('4010c5fa-64bc-4865-a2c0-0453ebd3c5af', '5e020c7d-7616-4586-8c1f-b92871600782', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 08:49:58.97');
INSERT INTO public.construction_updates VALUES ('66f8cdf2-5721-407c-8da0-6209340d552b', 'a58ef461-7bdb-440d-8ecc-59eb6ddfd2aa', '2025-12-14', 'Foundation work completed', NULL, 21, NULL, '2026-08-27 08:49:58.979');
INSERT INTO public.construction_updates VALUES ('0b29825f-1403-47af-91da-b41767833daf', 'a58ef461-7bdb-440d-8ecc-59eb6ddfd2aa', '2026-03-14', 'Structural work in progress', NULL, 36, NULL, '2026-08-27 08:49:58.979');
INSERT INTO public.construction_updates VALUES ('ecc718f2-bca8-480a-a6fe-927bb4e0ee28', 'a58ef461-7bdb-440d-8ecc-59eb6ddfd2aa', '2026-06-14', 'Brickwork and plastering', NULL, 51, NULL, '2026-08-27 08:49:58.979');
INSERT INTO public.construction_updates VALUES ('1eac838d-e30d-490c-a156-734dd178c068', 'a58ef461-7bdb-440d-8ecc-59eb6ddfd2aa', '2026-08-14', 'Finishing work underway', NULL, 61, NULL, '2026-08-27 08:49:58.979');
INSERT INTO public.construction_updates VALUES ('46ff91d3-972c-460b-9e2d-156fd13a4a4d', 'bd5b1472-8414-4bd4-980c-8c027fff0667', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 08:49:58.983');
INSERT INTO public.construction_updates VALUES ('e1898960-a5f5-496a-932d-c5b7bc43507a', 'bd5b1472-8414-4bd4-980c-8c027fff0667', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 08:49:58.983');
INSERT INTO public.construction_updates VALUES ('c589967b-5aa0-4183-a8fc-5399683c3a03', 'bd5b1472-8414-4bd4-980c-8c027fff0667', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 08:49:58.983');
INSERT INTO public.construction_updates VALUES ('1cd4b666-b0b9-4f30-a676-abf1c3e4088e', 'bd5b1472-8414-4bd4-980c-8c027fff0667', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 08:49:58.983');
INSERT INTO public.construction_updates VALUES ('283c2541-8e3a-4e35-ae1d-c213b6f1b01e', '418c70cc-d6ee-4f5f-be24-01a6650bb17a', '2025-12-14', 'Foundation work completed', NULL, 24, NULL, '2026-08-27 08:49:58.988');
INSERT INTO public.construction_updates VALUES ('3281bd8c-dac0-4a0b-a95e-b2c4413a776e', '418c70cc-d6ee-4f5f-be24-01a6650bb17a', '2026-03-14', 'Structural work in progress', NULL, 39, NULL, '2026-08-27 08:49:58.988');
INSERT INTO public.construction_updates VALUES ('66fd3345-2b70-4bd4-89c4-33dd03ad90c5', '418c70cc-d6ee-4f5f-be24-01a6650bb17a', '2026-06-14', 'Brickwork and plastering', NULL, 54, NULL, '2026-08-27 08:49:58.988');
INSERT INTO public.construction_updates VALUES ('661fcb03-34c2-4316-96b2-7a560f9ad96b', '418c70cc-d6ee-4f5f-be24-01a6650bb17a', '2026-08-14', 'Finishing work underway', NULL, 64, NULL, '2026-08-27 08:49:58.988');
INSERT INTO public.construction_updates VALUES ('6e520e6b-169d-4cb8-962f-a9a9bb21af92', '68148e8f-62d7-4bf4-9b96-ab684d43b51c', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 08:49:58.992');
INSERT INTO public.construction_updates VALUES ('e52bac37-343e-453c-97a9-aaf0385313bc', '68148e8f-62d7-4bf4-9b96-ab684d43b51c', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 08:49:58.992');
INSERT INTO public.construction_updates VALUES ('9bae4cba-14bd-439b-8e51-ff61442a4446', '68148e8f-62d7-4bf4-9b96-ab684d43b51c', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 08:49:58.992');
INSERT INTO public.construction_updates VALUES ('0619ed00-a9cc-4e8c-8a33-bad889af81da', '68148e8f-62d7-4bf4-9b96-ab684d43b51c', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 08:49:58.992');
INSERT INTO public.construction_updates VALUES ('5e0cb9ad-6313-4969-9cbf-65c347ffa666', 'ce867446-632d-463c-9550-ee082072994a', '2025-12-14', 'Foundation work completed', NULL, 10, NULL, '2026-08-27 13:02:22.758');
INSERT INTO public.construction_updates VALUES ('80065127-f981-4dc8-922c-1baef5e61728', 'ce867446-632d-463c-9550-ee082072994a', '2026-03-14', 'Structural work in progress', NULL, 24, NULL, '2026-08-27 13:02:22.758');
INSERT INTO public.construction_updates VALUES ('72c937f1-f54b-41ff-83c4-4bc85c7af002', 'ce867446-632d-463c-9550-ee082072994a', '2026-06-14', 'Brickwork and plastering', NULL, 39, NULL, '2026-08-27 13:02:22.758');
INSERT INTO public.construction_updates VALUES ('4ab0247d-76c5-41a9-a548-57b05b9ede14', 'ce867446-632d-463c-9550-ee082072994a', '2026-08-14', 'Finishing work underway', NULL, 49, NULL, '2026-08-27 13:02:22.758');
INSERT INTO public.construction_updates VALUES ('b7d726bc-d51b-4250-b9e7-fe7e02d99f1f', '765af9dd-61f8-4c7a-80e8-7974f7b83136', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.762');
INSERT INTO public.construction_updates VALUES ('2d25375c-a8f3-423f-9bf2-81c2e221681d', '765af9dd-61f8-4c7a-80e8-7974f7b83136', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.762');
INSERT INTO public.construction_updates VALUES ('d69954ac-f33e-4bf9-938a-b0258cbe6627', '765af9dd-61f8-4c7a-80e8-7974f7b83136', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.762');
INSERT INTO public.construction_updates VALUES ('ee311477-3354-41ba-b307-9912e15572e8', '765af9dd-61f8-4c7a-80e8-7974f7b83136', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.762');
INSERT INTO public.construction_updates VALUES ('086068db-20b3-46f2-afbd-4cafddc6b0a9', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', '2025-12-14', 'Foundation work completed', NULL, 12, NULL, '2026-08-27 13:02:22.77');
INSERT INTO public.construction_updates VALUES ('4bf2598e-93e9-4ff5-8cca-afe4bb130bda', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', '2026-03-14', 'Structural work in progress', NULL, 27, NULL, '2026-08-27 13:02:22.77');
INSERT INTO public.construction_updates VALUES ('e04b105b-68f7-4adb-9bd1-e2247b4ced35', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', '2026-06-14', 'Brickwork and plastering', NULL, 42, NULL, '2026-08-27 13:02:22.77');
INSERT INTO public.construction_updates VALUES ('43eba026-2d0a-4f3f-839c-9aa971b62d46', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', '2026-08-14', 'Finishing work underway', NULL, 52, NULL, '2026-08-27 13:02:22.77');
INSERT INTO public.construction_updates VALUES ('32c8107d-cc04-4dea-8969-1ef775ac2b56', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.775');
INSERT INTO public.construction_updates VALUES ('c417c13d-1cb0-4bc9-8b89-3479cd6ea904', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.775');
INSERT INTO public.construction_updates VALUES ('48b27d70-a4ef-4a6e-ba22-f246702325f8', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.775');
INSERT INTO public.construction_updates VALUES ('c44120d8-8fec-469b-9192-887b015e9fab', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.775');
INSERT INTO public.construction_updates VALUES ('a236ac7a-1fc6-48ec-b1ed-947f75fc513d', '3f256a22-dbf2-4858-b219-8a887459d13f', '2025-12-14', 'Foundation work completed', NULL, 15, NULL, '2026-08-27 13:02:22.781');
INSERT INTO public.construction_updates VALUES ('94792848-56b1-49df-8e20-ee19f0b812e1', '3f256a22-dbf2-4858-b219-8a887459d13f', '2026-03-14', 'Structural work in progress', NULL, 30, NULL, '2026-08-27 13:02:22.781');
INSERT INTO public.construction_updates VALUES ('f9b8ae5f-7c84-4d47-85bb-6d2bdb4bac8a', '3f256a22-dbf2-4858-b219-8a887459d13f', '2026-06-14', 'Brickwork and plastering', NULL, 45, NULL, '2026-08-27 13:02:22.781');
INSERT INTO public.construction_updates VALUES ('de083fff-6f2e-4175-902b-c8915aff9fc4', '3f256a22-dbf2-4858-b219-8a887459d13f', '2026-08-14', 'Finishing work underway', NULL, 55, NULL, '2026-08-27 13:02:22.781');
INSERT INTO public.construction_updates VALUES ('c206521a-42b6-44c1-9b56-c51811742b92', '8943fdc0-0495-452d-a818-a7518c7bacc2', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.784');
INSERT INTO public.construction_updates VALUES ('b088e6bd-e3d7-476e-aec3-593b7f9a09d6', '8943fdc0-0495-452d-a818-a7518c7bacc2', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.784');
INSERT INTO public.construction_updates VALUES ('2e644a33-01ab-4e6f-90e8-f70c49788b60', '8943fdc0-0495-452d-a818-a7518c7bacc2', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.784');
INSERT INTO public.construction_updates VALUES ('887336c6-1e42-4a94-ac57-f624ce180648', '8943fdc0-0495-452d-a818-a7518c7bacc2', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.784');
INSERT INTO public.construction_updates VALUES ('2e8b609f-5551-4c3c-8f30-69d569e18d13', '5dbf5457-69eb-49c3-8298-582f50cdd642', '2025-12-14', 'Foundation work completed', NULL, 18, NULL, '2026-08-27 13:02:22.791');
INSERT INTO public.construction_updates VALUES ('1298e934-55d6-42ad-a3a4-4d462b55acf2', '5dbf5457-69eb-49c3-8298-582f50cdd642', '2026-03-14', 'Structural work in progress', NULL, 33, NULL, '2026-08-27 13:02:22.791');
INSERT INTO public.construction_updates VALUES ('a71d991f-90e7-4cda-ad6b-1927d0e4a0b9', '5dbf5457-69eb-49c3-8298-582f50cdd642', '2026-06-14', 'Brickwork and plastering', NULL, 48, NULL, '2026-08-27 13:02:22.791');
INSERT INTO public.construction_updates VALUES ('0651c0b7-b563-49b6-99e6-9fec7d024d86', '5dbf5457-69eb-49c3-8298-582f50cdd642', '2026-08-14', 'Finishing work underway', NULL, 58, NULL, '2026-08-27 13:02:22.791');
INSERT INTO public.construction_updates VALUES ('f757680d-a359-410c-8874-fe12fce6cc62', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.794');
INSERT INTO public.construction_updates VALUES ('cc0dd97b-3343-469f-a118-885f04500d23', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.794');
INSERT INTO public.construction_updates VALUES ('b44bf713-fbb5-4f0a-933a-075c250881ea', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.794');
INSERT INTO public.construction_updates VALUES ('b5ad5f67-e8f7-4366-9dda-0471e42429e0', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.794');
INSERT INTO public.construction_updates VALUES ('e7fadab5-e0e5-4157-8822-40704c18cbcc', '6291ab92-3882-4932-91c3-ce8a06921842', '2025-12-14', 'Foundation work completed', NULL, 21, NULL, '2026-08-27 13:02:22.801');
INSERT INTO public.construction_updates VALUES ('b5102f5d-7aa4-4bd7-bb16-24d61e74e8a4', '6291ab92-3882-4932-91c3-ce8a06921842', '2026-03-14', 'Structural work in progress', NULL, 36, NULL, '2026-08-27 13:02:22.801');
INSERT INTO public.construction_updates VALUES ('e077acb7-93c4-41bd-8e25-6069bced2b91', '6291ab92-3882-4932-91c3-ce8a06921842', '2026-06-14', 'Brickwork and plastering', NULL, 51, NULL, '2026-08-27 13:02:22.801');
INSERT INTO public.construction_updates VALUES ('599b49a1-dd37-4f4d-90a3-d4a3bbb6d73f', '6291ab92-3882-4932-91c3-ce8a06921842', '2026-08-14', 'Finishing work underway', NULL, 61, NULL, '2026-08-27 13:02:22.801');
INSERT INTO public.construction_updates VALUES ('5fbf0ed5-1956-43ed-8abc-6adeaed3ba0f', '495847cf-06f6-49bc-8a68-7df5c0504838', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.804');
INSERT INTO public.construction_updates VALUES ('59798134-ef83-4635-92c0-ca5550e45ac3', '495847cf-06f6-49bc-8a68-7df5c0504838', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.804');
INSERT INTO public.construction_updates VALUES ('a3318f4c-82fc-4322-bacd-3d6f8f31f2ed', '495847cf-06f6-49bc-8a68-7df5c0504838', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.804');
INSERT INTO public.construction_updates VALUES ('8d6f9110-17a4-495a-8a6d-9a9e3cf0120b', '495847cf-06f6-49bc-8a68-7df5c0504838', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.804');
INSERT INTO public.construction_updates VALUES ('4e4e6f56-ab33-45bf-91e8-c032e4d9bb12', '0286edf1-6735-45e6-9ebc-d55e20c6f084', '2025-12-14', 'Foundation work completed', NULL, 24, NULL, '2026-08-27 13:02:22.81');
INSERT INTO public.construction_updates VALUES ('2f249993-f6ab-448b-9eed-91aff3c08d2f', '0286edf1-6735-45e6-9ebc-d55e20c6f084', '2026-03-14', 'Structural work in progress', NULL, 39, NULL, '2026-08-27 13:02:22.81');
INSERT INTO public.construction_updates VALUES ('e8bb156a-485d-4ed0-a5b0-83dfb34bec29', '0286edf1-6735-45e6-9ebc-d55e20c6f084', '2026-06-14', 'Brickwork and plastering', NULL, 54, NULL, '2026-08-27 13:02:22.81');
INSERT INTO public.construction_updates VALUES ('0af8e33b-f156-401b-a65a-9c814fc2753c', '0286edf1-6735-45e6-9ebc-d55e20c6f084', '2026-08-14', 'Finishing work underway', NULL, 64, NULL, '2026-08-27 13:02:22.81');
INSERT INTO public.construction_updates VALUES ('b637cd03-d22a-447f-8904-e6ca4fa65d80', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.812');
INSERT INTO public.construction_updates VALUES ('a2e3b1a9-83d0-4a23-a766-7938a52e025f', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.812');
INSERT INTO public.construction_updates VALUES ('79879d47-c409-4da7-9782-f3ef435fb799', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.812');
INSERT INTO public.construction_updates VALUES ('9ecf134f-e77c-437a-84d6-0fb0c64f025a', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.812');
INSERT INTO public.construction_updates VALUES ('674e0b4b-88f3-4733-8006-6d4001cdf5aa', '0f36f844-1667-4355-bd12-a2d530396858', '2025-12-14', 'Foundation work completed', NULL, 27, NULL, '2026-08-27 13:02:22.818');
INSERT INTO public.construction_updates VALUES ('324478ca-0943-4fe4-970c-19c792c53b52', '0f36f844-1667-4355-bd12-a2d530396858', '2026-03-14', 'Structural work in progress', NULL, 42, NULL, '2026-08-27 13:02:22.818');
INSERT INTO public.construction_updates VALUES ('9d02908c-94c9-453e-bea8-67320174976c', '0f36f844-1667-4355-bd12-a2d530396858', '2026-06-14', 'Brickwork and plastering', NULL, 57, NULL, '2026-08-27 13:02:22.818');
INSERT INTO public.construction_updates VALUES ('4134d02c-2f57-4490-8a13-36f9c71e0827', '0f36f844-1667-4355-bd12-a2d530396858', '2026-08-14', 'Finishing work underway', NULL, 67, NULL, '2026-08-27 13:02:22.818');
INSERT INTO public.construction_updates VALUES ('09cd9542-8211-4fac-876b-a05b389e8f8c', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.821');
INSERT INTO public.construction_updates VALUES ('f420cbf8-e9c1-4304-bd65-e8a321020e5b', 'c04c6e65-f054-4267-a246-b3cca1efac98', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.856');
INSERT INTO public.construction_updates VALUES ('18e3be93-1e8b-4620-8718-91166cf6be99', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', '2025-12-14', 'Foundation work completed', NULL, 42, NULL, '2026-08-27 13:02:22.864');
INSERT INTO public.construction_updates VALUES ('2da8feb0-8fea-4e21-8121-531f7b9d8f3e', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', '2026-03-14', 'Structural work in progress', NULL, 57, NULL, '2026-08-27 13:02:22.864');
INSERT INTO public.construction_updates VALUES ('eb033141-09d8-41a5-a6c8-1c0b0cf444ac', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', '2026-06-14', 'Brickwork and plastering', NULL, 72, NULL, '2026-08-27 13:02:22.864');
INSERT INTO public.construction_updates VALUES ('0a018b38-7644-4054-9dca-af004c749106', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', '2026-08-14', 'Finishing work underway', NULL, 82, NULL, '2026-08-27 13:02:22.864');
INSERT INTO public.construction_updates VALUES ('450077f9-abb6-4d84-972d-5e2716318929', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.867');
INSERT INTO public.construction_updates VALUES ('deb8f7f5-54c0-438e-bf96-c1aece71c4ea', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.867');
INSERT INTO public.construction_updates VALUES ('970c9f33-0ba5-4181-b4a7-6fd4fe941c8c', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.867');
INSERT INTO public.construction_updates VALUES ('a789f426-7c93-4531-b13d-e6c31f47ab23', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.867');
INSERT INTO public.construction_updates VALUES ('2c01ca25-8283-4dcf-831d-e51bcb9b17b6', 'aaf948fe-4305-4ac2-9b43-97078e915814', '2025-12-14', 'Foundation work completed', NULL, 10, NULL, '2026-08-27 13:02:22.872');
INSERT INTO public.construction_updates VALUES ('58ab31e2-a37f-4a6b-872a-d5b1612f7193', 'aaf948fe-4305-4ac2-9b43-97078e915814', '2026-03-14', 'Structural work in progress', NULL, 20, NULL, '2026-08-27 13:02:22.872');
INSERT INTO public.construction_updates VALUES ('532a18c4-b442-4a12-88b1-770a956ac936', 'aaf948fe-4305-4ac2-9b43-97078e915814', '2026-06-14', 'Brickwork and plastering', NULL, 35, NULL, '2026-08-27 13:02:22.872');
INSERT INTO public.construction_updates VALUES ('01a4721c-a2b4-4a91-9e4b-7e60e670e140', 'aaf948fe-4305-4ac2-9b43-97078e915814', '2026-08-14', 'Finishing work underway', NULL, 45, NULL, '2026-08-27 13:02:22.872');
INSERT INTO public.construction_updates VALUES ('b88c4eb4-fa80-49f7-9481-819526583555', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.875');
INSERT INTO public.construction_updates VALUES ('e2d96780-0eaa-4250-abb0-ec28f0657105', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.875');
INSERT INTO public.construction_updates VALUES ('40e2a38b-644d-4131-9ebe-0d72e7cb6883', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.875');
INSERT INTO public.construction_updates VALUES ('e3bca1d8-f6d7-435b-947a-d093118363f4', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.875');
INSERT INTO public.construction_updates VALUES ('0c57ada0-1fa6-48c4-9a55-01cb57354116', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', '2025-12-14', 'Foundation work completed', NULL, 10, NULL, '2026-08-27 13:02:22.881');
INSERT INTO public.construction_updates VALUES ('6c8e20b6-1ad7-4607-8027-48e2195245b7', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', '2026-03-14', 'Structural work in progress', NULL, 23, NULL, '2026-08-27 13:02:22.881');
INSERT INTO public.construction_updates VALUES ('601a04cf-27fc-45ad-9929-8541a1dee6f0', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', '2026-06-14', 'Brickwork and plastering', NULL, 38, NULL, '2026-08-27 13:02:22.881');
INSERT INTO public.construction_updates VALUES ('f56ace53-1580-4195-a2d6-f88c04398741', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', '2026-08-14', 'Finishing work underway', NULL, 48, NULL, '2026-08-27 13:02:22.881');
INSERT INTO public.construction_updates VALUES ('0e7b716f-08aa-490d-8ba1-31b54eb7f7a5', '76e72c33-512d-4e20-a183-2ee0ed536dcd', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.885');
INSERT INTO public.construction_updates VALUES ('4fcebb51-f22a-470d-a590-e0c1c5e66bff', '76e72c33-512d-4e20-a183-2ee0ed536dcd', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.885');
INSERT INTO public.construction_updates VALUES ('b937a417-3d67-4483-a6ba-1171c248b358', '76e72c33-512d-4e20-a183-2ee0ed536dcd', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.885');
INSERT INTO public.construction_updates VALUES ('3780e7ed-b9f6-4689-bc46-158e9ed6d25e', '76e72c33-512d-4e20-a183-2ee0ed536dcd', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.885');
INSERT INTO public.construction_updates VALUES ('e4395435-9b79-4798-8e80-caa171a44e37', '36504c39-4314-4f21-b4d7-936d85d35aaa', '2025-12-14', 'Foundation work completed', NULL, 11, NULL, '2026-08-27 13:02:22.891');
INSERT INTO public.construction_updates VALUES ('693f917b-53a1-4982-bdcd-5044e2d99c85', '36504c39-4314-4f21-b4d7-936d85d35aaa', '2026-03-14', 'Structural work in progress', NULL, 26, NULL, '2026-08-27 13:02:22.891');
INSERT INTO public.construction_updates VALUES ('a1144d82-80db-4ede-aa39-66b5d724bee2', '36504c39-4314-4f21-b4d7-936d85d35aaa', '2026-06-14', 'Brickwork and plastering', NULL, 41, NULL, '2026-08-27 13:02:22.891');
INSERT INTO public.construction_updates VALUES ('df8addf2-3629-4299-89aa-5250c5a7f141', '36504c39-4314-4f21-b4d7-936d85d35aaa', '2026-08-14', 'Finishing work underway', NULL, 51, NULL, '2026-08-27 13:02:22.891');
INSERT INTO public.construction_updates VALUES ('b19b752e-ce24-428d-8326-15192ef87cad', '7d6d013f-d5a4-4efe-bb88-c16401163509', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.894');
INSERT INTO public.construction_updates VALUES ('a8ec8b23-26b2-4852-8c72-c5912ae4583c', '7d6d013f-d5a4-4efe-bb88-c16401163509', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.894');
INSERT INTO public.construction_updates VALUES ('d64d097e-ebf7-4854-ad42-1f53c4b94764', '7d6d013f-d5a4-4efe-bb88-c16401163509', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.894');
INSERT INTO public.construction_updates VALUES ('b2368fdf-ce00-4974-9770-fe06d0ba84e9', '7d6d013f-d5a4-4efe-bb88-c16401163509', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.894');
INSERT INTO public.construction_updates VALUES ('157025b7-6ca5-4b05-8eda-1f054cde9193', 'af03d123-d596-452c-a94b-66254df1f732', '2025-12-14', 'Foundation work completed', NULL, 14, NULL, '2026-08-27 13:02:22.9');
INSERT INTO public.construction_updates VALUES ('6828390f-5843-40c2-8c10-961113e5e180', 'af03d123-d596-452c-a94b-66254df1f732', '2026-03-14', 'Structural work in progress', NULL, 29, NULL, '2026-08-27 13:02:22.9');
INSERT INTO public.construction_updates VALUES ('7ae67fe1-d60b-4111-acd2-68aae7a53231', 'af03d123-d596-452c-a94b-66254df1f732', '2026-06-14', 'Brickwork and plastering', NULL, 44, NULL, '2026-08-27 13:02:22.9');
INSERT INTO public.construction_updates VALUES ('0b9cdd77-a387-40fb-8296-23415b929656', 'af03d123-d596-452c-a94b-66254df1f732', '2026-08-14', 'Finishing work underway', NULL, 54, NULL, '2026-08-27 13:02:22.9');
INSERT INTO public.construction_updates VALUES ('1bf5bd1f-27fb-4e2a-bcee-21a9f23c8b20', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.903');
INSERT INTO public.construction_updates VALUES ('ed827f3e-1620-4602-bdd7-2b304ed2fecb', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.903');
INSERT INTO public.construction_updates VALUES ('5c208e59-72a6-4294-a69c-f8945fa74d12', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.903');
INSERT INTO public.construction_updates VALUES ('681731ea-75fe-4990-ac3c-254a0d3fc687', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.903');
INSERT INTO public.construction_updates VALUES ('c8977b4a-31f8-4662-b5e1-eec1f5a46a6d', '5825f125-7948-495d-80a1-b25e3721d8ca', '2025-12-14', 'Foundation work completed', NULL, 17, NULL, '2026-08-27 13:02:22.909');
INSERT INTO public.construction_updates VALUES ('81c1995e-3eab-4e82-9359-fe242cbb9a3c', '5825f125-7948-495d-80a1-b25e3721d8ca', '2026-03-14', 'Structural work in progress', NULL, 32, NULL, '2026-08-27 13:02:22.909');
INSERT INTO public.construction_updates VALUES ('44c790a8-ef24-48f0-936c-2e9ef91e485a', '5825f125-7948-495d-80a1-b25e3721d8ca', '2026-06-14', 'Brickwork and plastering', NULL, 47, NULL, '2026-08-27 13:02:22.909');
INSERT INTO public.construction_updates VALUES ('4436fd30-1f52-4add-b787-aa9d087ac1ca', '5825f125-7948-495d-80a1-b25e3721d8ca', '2026-08-14', 'Finishing work underway', NULL, 57, NULL, '2026-08-27 13:02:22.909');
INSERT INTO public.construction_updates VALUES ('e3de32dc-9238-4f4c-8ffd-3ad33a08c423', 'dc30889f-15b7-4653-8e76-3ca949d84e92', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.913');
INSERT INTO public.construction_updates VALUES ('2a958e35-0fa5-42c6-a84a-d905faa23049', 'dc30889f-15b7-4653-8e76-3ca949d84e92', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.913');
INSERT INTO public.construction_updates VALUES ('14a9325c-9748-42d1-9bc6-bc6b14aa8bbb', 'dc30889f-15b7-4653-8e76-3ca949d84e92', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.913');
INSERT INTO public.construction_updates VALUES ('3e25df84-7e16-45d8-90e6-76038ad96ba3', 'dc30889f-15b7-4653-8e76-3ca949d84e92', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.913');
INSERT INTO public.construction_updates VALUES ('3b75b1b0-9250-45df-bf63-dc19f1474406', '94a54418-365a-4cec-80d8-180f774fa135', '2025-12-14', 'Foundation work completed', NULL, 20, NULL, '2026-08-27 13:02:22.918');
INSERT INTO public.construction_updates VALUES ('df38384b-d29a-4777-90b6-9897ba55d91b', '94a54418-365a-4cec-80d8-180f774fa135', '2026-03-14', 'Structural work in progress', NULL, 35, NULL, '2026-08-27 13:02:22.918');
INSERT INTO public.construction_updates VALUES ('accf883f-7d62-4c8f-91e6-431b3abb2f04', '94a54418-365a-4cec-80d8-180f774fa135', '2026-06-14', 'Brickwork and plastering', NULL, 50, NULL, '2026-08-27 13:02:22.918');
INSERT INTO public.construction_updates VALUES ('5dfd71aa-9759-42e1-b63d-a83a9dfe2d8c', '94a54418-365a-4cec-80d8-180f774fa135', '2026-08-14', 'Finishing work underway', NULL, 60, NULL, '2026-08-27 13:02:22.918');
INSERT INTO public.construction_updates VALUES ('921fdc3e-2b9d-4e8c-a987-3e577f015492', '02266bb6-c3e8-4667-a465-34a7463f6216', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.921');
INSERT INTO public.construction_updates VALUES ('3f9a3a83-e26d-4719-9d76-ff12d9b3b519', '02266bb6-c3e8-4667-a465-34a7463f6216', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.921');
INSERT INTO public.construction_updates VALUES ('71dc89ce-6d64-4dda-8306-9cecae0a1b5c', '02266bb6-c3e8-4667-a465-34a7463f6216', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.921');
INSERT INTO public.construction_updates VALUES ('989186af-941e-4035-b3bf-83bd87ce0980', '02266bb6-c3e8-4667-a465-34a7463f6216', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.921');
INSERT INTO public.construction_updates VALUES ('158a17f6-8018-4117-b3df-b3c8804d96e0', '918731c6-604e-4795-9dd4-65bb2b0ff316', '2025-12-14', 'Foundation work completed', NULL, 23, NULL, '2026-08-27 13:02:22.926');
INSERT INTO public.construction_updates VALUES ('05006c67-e2cf-4c55-ac8f-93410903dcbb', '918731c6-604e-4795-9dd4-65bb2b0ff316', '2026-03-14', 'Structural work in progress', NULL, 38, NULL, '2026-08-27 13:02:22.926');
INSERT INTO public.construction_updates VALUES ('0a4bf52b-e164-4103-ac03-d77176a6dcc0', '918731c6-604e-4795-9dd4-65bb2b0ff316', '2026-06-14', 'Brickwork and plastering', NULL, 53, NULL, '2026-08-27 13:02:22.926');
INSERT INTO public.construction_updates VALUES ('44b3edbc-64f7-4277-a8ae-e281da464866', '918731c6-604e-4795-9dd4-65bb2b0ff316', '2026-08-14', 'Finishing work underway', NULL, 63, NULL, '2026-08-27 13:02:22.926');
INSERT INTO public.construction_updates VALUES ('a42c4463-aa71-40ba-84f4-5327d1b565e0', '27b10fb2-a0fe-44a9-a53b-dda50090286a', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.929');
INSERT INTO public.construction_updates VALUES ('06292f7a-aa98-414f-9768-a7d07242ae94', '27b10fb2-a0fe-44a9-a53b-dda50090286a', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.929');
INSERT INTO public.construction_updates VALUES ('c0317f81-a0bb-4eea-8d42-d080a5e1fb36', '27b10fb2-a0fe-44a9-a53b-dda50090286a', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.929');
INSERT INTO public.construction_updates VALUES ('5588899f-1c49-46f7-9886-6a8547297089', '27b10fb2-a0fe-44a9-a53b-dda50090286a', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.929');
INSERT INTO public.construction_updates VALUES ('c6312334-1e12-459f-b2b9-38e37966d90d', 'e29504df-f994-4081-ab30-8880cb31295c', '2025-12-14', 'Foundation work completed', NULL, 26, NULL, '2026-08-27 13:02:22.934');
INSERT INTO public.construction_updates VALUES ('7dd2f37f-8037-4d27-9e25-d73b610e2bab', 'e29504df-f994-4081-ab30-8880cb31295c', '2026-03-14', 'Structural work in progress', NULL, 41, NULL, '2026-08-27 13:02:22.934');
INSERT INTO public.construction_updates VALUES ('5e33907e-e427-4b4d-b2f4-d9bd11941df3', 'e29504df-f994-4081-ab30-8880cb31295c', '2026-06-14', 'Brickwork and plastering', NULL, 56, NULL, '2026-08-27 13:02:22.934');
INSERT INTO public.construction_updates VALUES ('94abaf6e-8427-45cf-82cb-deac8a0d6f88', 'e29504df-f994-4081-ab30-8880cb31295c', '2026-08-14', 'Finishing work underway', NULL, 66, NULL, '2026-08-27 13:02:22.934');
INSERT INTO public.construction_updates VALUES ('198fc85b-1539-4a67-bfa1-9fc73327b906', '8549718e-a328-4d01-8daf-b658a61e80af', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.937');
INSERT INTO public.construction_updates VALUES ('021361a3-1827-43af-816f-9764cc0c193c', '8549718e-a328-4d01-8daf-b658a61e80af', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.937');
INSERT INTO public.construction_updates VALUES ('20efe503-8fd8-4c5f-aaef-65690c17c77d', '8549718e-a328-4d01-8daf-b658a61e80af', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.937');
INSERT INTO public.construction_updates VALUES ('f9622605-e8fd-4869-92e2-29cfa477996f', '8549718e-a328-4d01-8daf-b658a61e80af', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.937');
INSERT INTO public.construction_updates VALUES ('4b72d727-3361-49fb-b59f-d1169f247cd0', '7b309de3-440f-4a16-a9b9-2e510e121ef9', '2025-12-14', 'Foundation work completed', NULL, 29, NULL, '2026-08-27 13:02:22.942');
INSERT INTO public.construction_updates VALUES ('36968413-39dd-474e-96a1-cd623685e73b', '7b309de3-440f-4a16-a9b9-2e510e121ef9', '2026-03-14', 'Structural work in progress', NULL, 44, NULL, '2026-08-27 13:02:22.942');
INSERT INTO public.construction_updates VALUES ('508b224d-8892-4853-a2bb-1b4ab517719f', '7b309de3-440f-4a16-a9b9-2e510e121ef9', '2026-06-14', 'Brickwork and plastering', NULL, 59, NULL, '2026-08-27 13:02:22.942');
INSERT INTO public.construction_updates VALUES ('ea37183c-9fb4-46c1-a278-2d852d4bb81c', '7b309de3-440f-4a16-a9b9-2e510e121ef9', '2026-08-14', 'Finishing work underway', NULL, 69, NULL, '2026-08-27 13:02:22.942');
INSERT INTO public.construction_updates VALUES ('55224bb6-3db4-405c-a571-f440fdd0d54a', '9a630559-9351-43d0-a3af-ae555b62688b', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.945');
INSERT INTO public.construction_updates VALUES ('5b5fb13f-4c6b-47c4-9c78-e7b5e8738cda', '9a630559-9351-43d0-a3af-ae555b62688b', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.945');
INSERT INTO public.construction_updates VALUES ('8e6c759f-4dc4-4f29-b5a9-5492a458a6f6', '9a630559-9351-43d0-a3af-ae555b62688b', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.945');
INSERT INTO public.construction_updates VALUES ('cba349b7-a72f-46c9-83c9-e0544696c6ba', '9a630559-9351-43d0-a3af-ae555b62688b', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.945');
INSERT INTO public.construction_updates VALUES ('fce46596-4352-4f00-a763-b02650502dc7', '65241983-adad-4ac9-a586-27339d9b64f9', '2025-12-14', 'Foundation work completed', NULL, 32, NULL, '2026-08-27 13:02:22.95');
INSERT INTO public.construction_updates VALUES ('3a7c6526-1425-45b9-8252-6c25a30809ec', '65241983-adad-4ac9-a586-27339d9b64f9', '2026-03-14', 'Structural work in progress', NULL, 47, NULL, '2026-08-27 13:02:22.95');
INSERT INTO public.construction_updates VALUES ('45f4cf36-f45a-4795-8424-3b0e81b9fac1', '65241983-adad-4ac9-a586-27339d9b64f9', '2026-06-14', 'Brickwork and plastering', NULL, 62, NULL, '2026-08-27 13:02:22.95');
INSERT INTO public.construction_updates VALUES ('e536e6e1-333c-46df-84ec-de94c5f10ff3', '65241983-adad-4ac9-a586-27339d9b64f9', '2026-08-14', 'Finishing work underway', NULL, 72, NULL, '2026-08-27 13:02:22.95');
INSERT INTO public.construction_updates VALUES ('dda049ba-6550-4507-9641-e105d5ccc705', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.952');
INSERT INTO public.construction_updates VALUES ('060ed7b9-dd2f-42b1-b3a7-38c5b81dc32f', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.952');
INSERT INTO public.construction_updates VALUES ('8a69bf79-0c9a-44c6-97a4-4a8e3bf2c52f', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.952');
INSERT INTO public.construction_updates VALUES ('0710e0c0-5ef2-4e3c-9698-c9196b0b5cbd', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.952');
INSERT INTO public.construction_updates VALUES ('4a1e0684-0368-4a82-ab04-22113775f7b1', '852cb9a1-21fa-482b-b702-99c45c39f992', '2025-12-14', 'Foundation work completed', NULL, 35, NULL, '2026-08-27 13:02:22.957');
INSERT INTO public.construction_updates VALUES ('2ff53c71-0335-4c57-8382-19342ff805c2', '852cb9a1-21fa-482b-b702-99c45c39f992', '2026-03-14', 'Structural work in progress', NULL, 50, NULL, '2026-08-27 13:02:22.957');
INSERT INTO public.construction_updates VALUES ('e0532bc8-e97e-4466-b7e6-23566a8f608d', '852cb9a1-21fa-482b-b702-99c45c39f992', '2026-06-14', 'Brickwork and plastering', NULL, 65, NULL, '2026-08-27 13:02:22.957');
INSERT INTO public.construction_updates VALUES ('1d82b050-6baa-4eec-ba27-36de9ddf7084', '852cb9a1-21fa-482b-b702-99c45c39f992', '2026-08-14', 'Finishing work underway', NULL, 75, NULL, '2026-08-27 13:02:22.957');
INSERT INTO public.construction_updates VALUES ('31a58b9b-4612-42f0-ab10-b18337e3755d', 'd4777543-b2f7-485f-a799-c9e259adf3a3', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.96');
INSERT INTO public.construction_updates VALUES ('1ee8e8aa-b3f4-4ae5-bd29-23f3aae26e6b', 'd4777543-b2f7-485f-a799-c9e259adf3a3', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.96');
INSERT INTO public.construction_updates VALUES ('1159bcd1-f655-4fa3-8358-23e6780a35b3', 'd4777543-b2f7-485f-a799-c9e259adf3a3', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.96');
INSERT INTO public.construction_updates VALUES ('baf6880c-a4eb-413c-a17e-cfb827b71282', 'd4777543-b2f7-485f-a799-c9e259adf3a3', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.96');
INSERT INTO public.construction_updates VALUES ('40ce809e-e125-4ab5-9de6-1f4df8174a5f', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', '2025-12-14', 'Foundation work completed', NULL, 38, NULL, '2026-08-27 13:02:22.964');
INSERT INTO public.construction_updates VALUES ('304674a2-6750-4523-a02c-76b2eca2170f', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', '2026-03-14', 'Structural work in progress', NULL, 53, NULL, '2026-08-27 13:02:22.964');
INSERT INTO public.construction_updates VALUES ('8e52116b-19f7-447e-96b0-eebe3d44ca30', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', '2026-06-14', 'Brickwork and plastering', NULL, 68, NULL, '2026-08-27 13:02:22.964');
INSERT INTO public.construction_updates VALUES ('8f9b226f-d3bd-47df-bf3b-36fdb9fc0511', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', '2026-08-14', 'Finishing work underway', NULL, 78, NULL, '2026-08-27 13:02:22.964');
INSERT INTO public.construction_updates VALUES ('3fe91287-d941-4a69-8036-f5f33a25ec3d', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.967');
INSERT INTO public.construction_updates VALUES ('9fad8c6a-5a39-4d95-b782-2cb0d217ee3c', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.967');
INSERT INTO public.construction_updates VALUES ('1e7da583-c60c-4415-a226-1a25a8e1b2e5', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.967');
INSERT INTO public.construction_updates VALUES ('7d2e9f0e-7420-4174-ae15-5791cfde7508', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.967');
INSERT INTO public.construction_updates VALUES ('f5fc5425-7e0d-4e06-bdc1-8542b6d89b92', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', '2025-12-14', 'Foundation work completed', NULL, 41, NULL, '2026-08-27 13:02:22.971');
INSERT INTO public.construction_updates VALUES ('b78ce93c-57fd-4258-a8d4-fbfeb4a63a0f', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', '2026-03-14', 'Structural work in progress', NULL, 56, NULL, '2026-08-27 13:02:22.971');
INSERT INTO public.construction_updates VALUES ('59bc56bc-b55f-4637-be63-de76a9b0e62d', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', '2026-06-14', 'Brickwork and plastering', NULL, 71, NULL, '2026-08-27 13:02:22.971');
INSERT INTO public.construction_updates VALUES ('25a34ded-a119-484e-9ff8-73100b819820', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', '2026-08-14', 'Finishing work underway', NULL, 81, NULL, '2026-08-27 13:02:22.971');
INSERT INTO public.construction_updates VALUES ('18fafadd-5c67-480a-ae20-14d860d4c86f', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', '2025-12-14', 'Foundation work completed', NULL, 60, NULL, '2026-08-27 13:02:22.974');
INSERT INTO public.construction_updates VALUES ('002b5a74-5343-4609-9243-0325e7137929', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', '2026-03-14', 'Structural work in progress', NULL, 75, NULL, '2026-08-27 13:02:22.974');
INSERT INTO public.construction_updates VALUES ('91e3e35a-6b01-4226-bad2-cf4b76446d41', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', '2026-06-14', 'Brickwork and plastering', NULL, 90, NULL, '2026-08-27 13:02:22.974');
INSERT INTO public.construction_updates VALUES ('3e1e79af-0c9a-4b66-b7c9-6c7c5c362aaf', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', '2026-08-14', 'Finishing work underway', NULL, 100, NULL, '2026-08-27 13:02:22.974');


--
-- Data for Name: job_applications; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.jobs VALUES ('1984f624-2314-4b18-8b0f-1828cb27af16', 'frontend-engineer-mumbai', 'Frontend Engineer', 'Engineering', 'Mumbai (Hybrid)', 'Full-time', 'Work directly on the buyer-facing site — project pages, search, calculators, the lead funnel. We''re a small team, so you''ll ship end-to-end features, not just components.', '{"Solid React/Next.js experience, comfortable with TypeScript","Care about performance and SEO — this is a search-driven product","Can work independently with minimal hand-holding"}', 'open', '2026-08-29 06:38:24.808', '2026-08-29 06:38:24.808');
INSERT INTO public.jobs VALUES ('faf0218b-9d92-407b-9cc8-5b7e3809e278', 'content-writer-remote', 'Real Estate Content Writer', 'Marketing', 'Remote', 'Full-time', 'Write locality guides, project descriptions, and buyer-education articles for Mumbai, Navi Mumbai and Thane. You''ll work closely with the SEO and sales teams to know what buyers are actually asking.', '{"Excellent written English, comfortable with real estate/finance terminology","Some SEO writing experience preferred","Based in India, familiar with the Mumbai/Navi Mumbai/Thane property market"}', 'open', '2026-08-29 06:38:24.809', '2026-08-29 06:38:24.809');
INSERT INTO public.jobs VALUES ('6c2d9773-f8f8-4ddb-85e0-a3313cd6421a', 'customer-success-thane', 'Customer Success Associate', 'Operations', 'Thane', 'Full-time', 'First point of contact for buyers reaching out through the site — qualify leads, schedule site visits, and coordinate between buyers and builder sales teams until a visit happens.', '{"Fluent in Hindi, Marathi and English","Comfortable on the phone all day — this is a high-volume, high-follow-up role","Prior experience in real estate, BPO, or telesales is a plus"}', 'open', '2026-08-29 06:38:24.81', '2026-08-29 06:38:24.81');
INSERT INTO public.jobs VALUES ('fa4020ce-c772-4758-a680-9d520d5249e7', 'sales-manager-navi-mumbai', 'Sales Manager', 'Sales', 'Navi Mumbai', 'Full-time', 'Own builder and buyer relationships across our Navi Mumbai launches. You''ll run site visits, negotiate with builders on inventory and pricing, and close deals with home buyers sourced through the platform.', '{"3+ years in real estate sales, ideally new-launch or under-construction projects","Comfortable with day-to-day site visits across Navi Mumbai","Strong follow-up discipline — most deals close on the third or fourth touchpoint"}', 'open', '2026-08-29 06:38:24.807', '2026-08-29 07:04:05.987');


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.leads VALUES ('d683f70a-b30a-4430-b338-dc3571d42528', NULL, NULL, 'Priya Verma', '9123456780', NULL, NULL, NULL, NULL, NULL, NULL, 'callback', 'direct', NULL, NULL, NULL, NULL, '/contact-us', 'contacted', NULL, NULL, NULL, NULL, '2026-08-27 09:18:29.692', '2026-08-27 09:27:46.944');


--
-- Data for Name: listing_boosts; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: localities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.localities VALUES (303, 1, 'Santacruz', 'santacruz', NULL, NULL, 28900, 0, false, 1);
INSERT INTO public.localities VALUES (304, 1, 'Bandra', 'bandra', NULL, NULL, 42000, 0, true, 1);
INSERT INTO public.localities VALUES (312, 1, 'Kanjurmarg', 'kanjurmarg', NULL, NULL, 18900, 0, false, 2);
INSERT INTO public.localities VALUES (313, 1, 'Bhandup', 'bhandup', NULL, NULL, 17400, 0, false, 2);
INSERT INTO public.localities VALUES (321, 1, 'Lower Parel', 'lower-parel', NULL, NULL, 45000, 0, true, 3);
INSERT INTO public.localities VALUES (322, 1, 'Prabhadevi', 'prabhadevi', NULL, NULL, 52000, 0, false, 3);
INSERT INTO public.localities VALUES (330, 2, 'Majiwada', 'majiwada', NULL, NULL, 14500, 0, true, 5);
INSERT INTO public.localities VALUES (331, 2, 'Kolshet', 'kolshet', NULL, NULL, 13900, 0, false, 5);
INSERT INTO public.localities VALUES (271, 2, 'Shilphata', 'shilphata', NULL, NULL, 8200, 0, true, NULL);
INSERT INTO public.localities VALUES (15, 6, 'OMR', 'omr', NULL, NULL, 7200, 0, true, NULL);
INSERT INTO public.localities VALUES (16, 6, 'Porur', 'porur', NULL, NULL, 6800, 0, false, NULL);
INSERT INTO public.localities VALUES (24, 11, 'SG Highway', 'sg-highway', NULL, NULL, 6800, 0, true, NULL);
INSERT INTO public.localities VALUES (290, 12, 'Vashi', 'vashi', NULL, NULL, 16500, 0, true, 8);
INSERT INTO public.localities VALUES (294, 12, 'Airoli', 'airoli', NULL, NULL, 13600, 0, true, 10);
INSERT INTO public.localities VALUES (295, 12, 'Ghansoli', 'ghansoli', NULL, NULL, 12400, 0, true, 10);
INSERT INTO public.localities VALUES (1, 1, 'Andheri West', 'andheri-west', NULL, NULL, 24500, 0, true, 1);
INSERT INTO public.localities VALUES (297, 1, 'Borivali', 'borivali', NULL, NULL, 19500, 0, true, 1);
INSERT INTO public.localities VALUES (298, 1, 'Goregaon', 'goregaon', NULL, NULL, 20200, 0, false, 1);
INSERT INTO public.localities VALUES (299, 1, 'Kandivali', 'kandivali', NULL, NULL, 18800, 0, false, 1);
INSERT INTO public.localities VALUES (300, 1, 'Malad', 'malad', NULL, NULL, 18200, 0, false, 1);
INSERT INTO public.localities VALUES (301, 1, 'Jogeshwari', 'jogeshwari', NULL, NULL, 19800, 0, false, 1);
INSERT INTO public.localities VALUES (302, 1, 'Vile Parle', 'vile-parle', NULL, NULL, 27500, 0, false, 1);
INSERT INTO public.localities VALUES (305, 1, 'Dahisar', 'dahisar', NULL, NULL, 16800, 0, false, 1);
INSERT INTO public.localities VALUES (306, 1, 'Mira Road', 'mira-road', NULL, NULL, 12800, 0, false, 1);
INSERT INTO public.localities VALUES (2, 1, 'Powai', 'powai', NULL, NULL, 21800, 0, true, 2);
INSERT INTO public.localities VALUES (3, 1, 'Chembur', 'chembur', NULL, NULL, 19200, 0, true, 2);
INSERT INTO public.localities VALUES (309, 1, 'Mulund', 'mulund', NULL, NULL, 20500, 0, false, 2);
INSERT INTO public.localities VALUES (310, 1, 'Vikhroli', 'vikhroli', NULL, NULL, 19600, 0, false, 2);
INSERT INTO public.localities VALUES (311, 1, 'Ghatkopar', 'ghatkopar', NULL, NULL, 21200, 0, false, 2);
INSERT INTO public.localities VALUES (314, 1, 'Worli', 'worli', NULL, NULL, 55000, 0, true, 3);
INSERT INTO public.localities VALUES (315, 1, 'Mahalaxmi', 'mahalaxmi', NULL, NULL, 48000, 0, false, 3);
INSERT INTO public.localities VALUES (316, 1, 'Byculla', 'byculla', NULL, NULL, 32000, 0, false, 3);
INSERT INTO public.localities VALUES (323, 1, 'Mahim', 'mahim', NULL, NULL, 39500, 0, false, 3);
INSERT INTO public.localities VALUES (332, 2, 'Pokhran 1', 'pokhran-1', NULL, NULL, 15200, 0, false, 5);
INSERT INTO public.localities VALUES (333, 2, 'Pokhran 2', 'pokhran-2', NULL, NULL, 14800, 0, false, 5);
INSERT INTO public.localities VALUES (334, 2, 'Manpada', 'manpada', NULL, NULL, 15600, 0, true, 7);
INSERT INTO public.localities VALUES (335, 2, 'Bhayandarpada', 'bhayandarpada', NULL, NULL, 13200, 0, false, 7);
INSERT INTO public.localities VALUES (336, 2, 'Waghbil', 'waghbil', NULL, NULL, 12600, 0, false, 7);
INSERT INTO public.localities VALUES (5, 2, 'Dombivli', 'dombivli', NULL, NULL, 9800, 0, true, NULL);
INSERT INTO public.localities VALUES (6, 2, 'Kalyan', 'kalyan', NULL, NULL, 8600, 0, false, NULL);
INSERT INTO public.localities VALUES (7, 3, 'Hinjewadi', 'hinjewadi', NULL, NULL, 8200, 0, true, NULL);
INSERT INTO public.localities VALUES (8, 3, 'Undri', 'undri', NULL, NULL, 6900, 0, false, NULL);
INSERT INTO public.localities VALUES (9, 3, 'Wagholi', 'wagholi', NULL, NULL, 6100, 0, false, NULL);
INSERT INTO public.localities VALUES (10, 4, 'Whitefield', 'whitefield', NULL, NULL, 9800, 0, true, NULL);
INSERT INTO public.localities VALUES (11, 4, 'Sarjapur Road', 'sarjapur-road', NULL, NULL, 8600, 0, true, NULL);
INSERT INTO public.localities VALUES (12, 4, 'Electronic City', 'electronic-city', NULL, NULL, 6900, 0, false, NULL);
INSERT INTO public.localities VALUES (13, 5, 'Gachibowli', 'gachibowli', NULL, NULL, 8900, 0, true, NULL);
INSERT INTO public.localities VALUES (14, 5, 'Kokapet', 'kokapet', NULL, NULL, 9600, 0, false, NULL);
INSERT INTO public.localities VALUES (17, 7, 'Dwarka', 'dwarka', NULL, NULL, 12500, 0, true, NULL);
INSERT INTO public.localities VALUES (18, 8, 'Sector 150', 'sector-150', NULL, NULL, 9800, 0, true, NULL);
INSERT INTO public.localities VALUES (19, 8, 'Noida Extension', 'noida-extension', NULL, NULL, 6200, 0, false, NULL);
INSERT INTO public.localities VALUES (20, 9, 'Sector 63', 'sector-63', NULL, NULL, 14200, 0, true, NULL);
INSERT INTO public.localities VALUES (21, 9, 'Sector 57', 'sector-57', NULL, NULL, 15800, 0, false, NULL);
INSERT INTO public.localities VALUES (22, 9, 'Dwarka Expressway', 'dwarka-expressway', NULL, NULL, 9600, 0, true, NULL);
INSERT INTO public.localities VALUES (23, 10, 'New Town', 'new-town', NULL, NULL, 7600, 0, true, NULL);
INSERT INTO public.localities VALUES (359, 12, 'Sanpada', 'sanpada', NULL, NULL, 15800, 0, false, 8);
INSERT INTO public.localities VALUES (291, 12, 'Nerul', 'nerul', NULL, NULL, 15200, 0, true, 8);
INSERT INTO public.localities VALUES (292, 12, 'Belapur', 'belapur', NULL, NULL, 14800, 0, true, 8);
INSERT INTO public.localities VALUES (293, 12, 'Palm Beach Road', 'palm-beach-road', NULL, NULL, 18900, 0, true, 8);
INSERT INTO public.localities VALUES (363, 12, 'Kharghar', 'kharghar', NULL, NULL, 11800, 0, true, 9);
INSERT INTO public.localities VALUES (364, 12, 'Taloja', 'taloja', NULL, NULL, 7200, 0, false, 9);
INSERT INTO public.localities VALUES (365, 12, 'Upper Kharghar', 'upper-kharghar', NULL, NULL, 10500, 0, false, 9);
INSERT INTO public.localities VALUES (368, 12, 'Digha', 'digha', NULL, NULL, 9800, 0, false, 10);
INSERT INTO public.localities VALUES (369, 12, 'Rasayani', 'rasayani', NULL, NULL, 5400, 0, false, 10);
INSERT INTO public.localities VALUES (370, 12, 'Panvel', 'panvel', NULL, NULL, 8600, 0, true, 11);
INSERT INTO public.localities VALUES (371, 12, 'Kalamboli', 'kalamboli', NULL, NULL, 7800, 0, false, 11);
INSERT INTO public.localities VALUES (372, 12, 'Palaspe', 'palaspe', NULL, NULL, 6900, 0, false, 11);
INSERT INTO public.localities VALUES (373, 12, 'Shedung', 'shedung', NULL, NULL, 6200, 0, false, 11);
INSERT INTO public.localities VALUES (374, 12, 'Juinagar', 'juinagar', NULL, NULL, 15400, 0, false, 11);
INSERT INTO public.localities VALUES (317, 1, 'Sewri', 'sewri', NULL, NULL, 29500, 0, false, 3);
INSERT INTO public.localities VALUES (318, 1, 'Parel', 'parel', NULL, NULL, 38000, 0, false, 3);
INSERT INTO public.localities VALUES (319, 1, 'Dadar', 'dadar', NULL, NULL, 40500, 0, false, 3);
INSERT INTO public.localities VALUES (320, 1, 'Lalbaug', 'lalbaug', NULL, NULL, 34000, 0, false, 3);
INSERT INTO public.localities VALUES (324, 1, 'Sion', 'sion', NULL, NULL, 26500, 0, false, 4);
INSERT INTO public.localities VALUES (325, 1, 'Wadala', 'wadala', NULL, NULL, 27800, 0, false, 4);
INSERT INTO public.localities VALUES (326, 1, 'Matunga', 'matunga', NULL, NULL, 33500, 0, false, 4);
INSERT INTO public.localities VALUES (4, 2, 'Ghodbunder Road', 'ghodbunder-road', NULL, NULL, 13800, 0, true, 6);
INSERT INTO public.localities VALUES (328, 2, 'Kasarvadavali', 'kasarvadavali', NULL, NULL, 12200, 0, false, 6);
INSERT INTO public.localities VALUES (329, 2, 'Balkum', 'balkum', NULL, NULL, 12800, 0, false, 6);


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: price_trends; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: project_configs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.project_configs VALUES ('c0d63274-bc67-4a28-a26c-0c6a8a36e106', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('99c0952e-c142-4ef5-84e0-83f5b544bb4a', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('3bacd60d-f8a7-42ea-be05-c09331c9e521', '859c919f-5c2e-49da-8e03-d37f49ddfbf9', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('9cdb513a-07d0-40b5-b95d-b5f21a487b82', '859c919f-5c2e-49da-8e03-d37f49ddfbf9', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('aaa6f0ba-2f48-4bb0-9168-1124ba497954', '56618a36-9c91-4eda-a791-139f4af0bad9', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('dd7cd315-9e9d-4f4f-a4d4-209bae3f4746', '56618a36-9c91-4eda-a791-139f4af0bad9', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('60b84dbd-c344-443a-a3ec-25e280a304e5', '5be2e843-8490-47fb-96fa-89b50a6341f1', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('86f98814-e633-45b5-bb87-ead94d8c1a22', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('63ee28cc-c4c8-412e-a578-1daf27504eba', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 10000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('5b5bfe9c-e6b6-46e4-8e7e-3e742847cf40', 'acfc42a9-2060-4408-ac25-16a6a719b844', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('cea2617f-a379-468e-b427-64b06cbaaa4e', 'acfc42a9-2060-4408-ac25-16a6a719b844', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 12000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('62b42fb6-dfd2-4c7b-a75d-11a360caa141', '11623247-dca1-4b47-b290-b7d53f19241b', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('f45eb46d-303f-4ccc-b0ec-7a8b08ac5591', '11623247-dca1-4b47-b290-b7d53f19241b', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('59ccd7d5-1714-4fbd-8cd0-e45b1c4dafc6', 'eb895d11-47b3-4a49-9d05-a2aa8fda3fa0', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('35e71c98-f9ce-4188-b830-7f1d6f43078c', 'eb895d11-47b3-4a49-9d05-a2aa8fda3fa0', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('6062fc2c-6f06-45e8-82ff-9bdd039be6dc', '8f1e7d41-2fee-48f0-8059-1b6fbf82d50a', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('35f33cc1-5304-42f1-91f2-59ad0ed3c789', '8f1e7d41-2fee-48f0-8059-1b6fbf82d50a', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('7441f878-ee19-462d-b3c8-e693bf59d150', 'd06f4375-b054-4c98-98ab-7eed73453bfc', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('0cedc93c-7225-496f-ba46-bbaacd878d7e', 'd06f4375-b054-4c98-98ab-7eed73453bfc', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('99c098d5-da85-47a0-8f2b-7b14ef29df7c', '957a2da1-07d3-4757-b35e-62b0793540e8', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('c5795c7c-9556-4e32-baa2-3b6a75b9aa7d', '957a2da1-07d3-4757-b35e-62b0793540e8', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('0516792c-3d57-4e65-827f-16a05878402f', 'cb9eaa1a-e68f-4fd4-b892-f6b245d12d00', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('0569f658-83ea-4caa-9f63-f75cccaa8277', 'cb9eaa1a-e68f-4fd4-b892-f6b245d12d00', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 24000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('f208dbc5-6345-45a2-a7b9-a648cf971c90', '757cb567-26c9-4e7b-b6f2-6304699856f1', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('44149614-dd2a-49bd-927f-79a8d566f816', '757cb567-26c9-4e7b-b6f2-6304699856f1', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('82922c6e-e0a1-4d89-b5aa-8b78867c2362', '93e1a907-ec07-4e94-ab17-e9d8d83ea14f', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('6b859a01-4911-4f7a-bfff-25cbba643c24', '93e1a907-ec07-4e94-ab17-e9d8d83ea14f', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('08459000-a3ec-4aa3-9331-58762eec27a7', '96b01e7f-7477-4b03-bf64-58b13e4ba558', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('6bac7bf6-851a-4746-97dc-2f5d071d71b6', '96b01e7f-7477-4b03-bf64-58b13e4ba558', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 12000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('382bfdda-1931-452a-b6c6-a026f6864bfe', '1448e541-3683-46d3-a150-460c45498116', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('d6c00938-da60-4c12-816c-30c41ee03a94', '1448e541-3683-46d3-a150-460c45498116', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('d690f3cb-1012-4f2a-8953-a9b3ea93e432', '61a2b029-7d0b-4af3-bf07-e468bd75d4d3', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('9bc8bc9a-5231-4633-b0b3-e2fc3325dff2', '61a2b029-7d0b-4af3-bf07-e468bd75d4d3', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('e2a87790-6780-48fc-86c7-b8a3e5c1f8ec', '7ad80e2a-7937-4695-b5fc-0c02faed85ed', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('fb232cda-27f2-416a-9c88-e17dc812c5be', '7ad80e2a-7937-4695-b5fc-0c02faed85ed', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('39bc5ef4-2b5a-4a34-a521-9879a6bbd36d', '5e020c7d-7616-4586-8c1f-b92871600782', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('13a2cfee-5b34-41a6-844f-b6b8a79712ce', '5e020c7d-7616-4586-8c1f-b92871600782', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('e7de0dab-4453-402e-8ad3-7d79f695c11b', '91a93bef-e03b-46df-92c2-f2dc19e6d2d0', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('a4c2538f-1fa5-4998-9030-294e99923938', '91a93bef-e03b-46df-92c2-f2dc19e6d2d0', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('fee3cf37-de00-4362-8744-f3c1c848e9d4', 'a58ef461-7bdb-440d-8ecc-59eb6ddfd2aa', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('4c28e9cf-537b-419b-b3c9-5251f2236a92', 'a58ef461-7bdb-440d-8ecc-59eb6ddfd2aa', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('d799de38-c7e5-468c-aa8d-53ab21354350', 'bd5b1472-8414-4bd4-980c-8c027fff0667', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('1fa8f2a2-4396-4ad3-a768-20c5dc21aa31', 'bd5b1472-8414-4bd4-980c-8c027fff0667', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('3ae7ccff-6f9d-40c7-8042-a8482db5b714', '3d27c999-6beb-42ca-a450-b96b827e9abe', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('a4aabe6e-59de-4793-9f20-44efc8ff43e4', '3d27c999-6beb-42ca-a450-b96b827e9abe', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('7584b0d6-20b3-49d0-a69d-198ad9430c51', '418c70cc-d6ee-4f5f-be24-01a6650bb17a', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('a3292527-c337-470e-9a13-41d4793dcef0', '418c70cc-d6ee-4f5f-be24-01a6650bb17a', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('cf8d959e-9dff-4ae6-a25b-a6aeae8aad65', '68148e8f-62d7-4bf4-9b96-ab684d43b51c', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('ced82664-5cc0-493c-b1c3-c655b356ee63', '68148e8f-62d7-4bf4-9b96-ab684d43b51c', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('545c42e2-5725-41a4-aff0-76292cebfa48', '62996084-afe8-4498-9bdf-7b9fc4ff470e', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('a9f35472-f1c2-491d-b8c1-2e62b7ee1cb4', '62996084-afe8-4498-9bdf-7b9fc4ff470e', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('4ccc666d-40bc-4d0d-846f-8409fa80fd60', '5be2e843-8490-47fb-96fa-89b50a6341f1', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('ea85ee61-5923-4b71-a0c2-ebfb679ce42b', 'a021e29e-d944-4907-9a24-540efbf1036a', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('18792e1d-150e-4c40-a88f-48f7c11b085d', 'a021e29e-d944-4907-9a24-540efbf1036a', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('eefcf2e8-8f95-40fe-a648-11f31c3b7dcf', '7a197c1d-be5d-43a1-a1f4-fc7524e98672', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('60f29010-c673-4a47-a7b0-114de2111dbf', '7a197c1d-be5d-43a1-a1f4-fc7524e98672', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 24000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('35621a67-08ad-4bb6-91ca-15266895f59a', 'ad4891db-d75f-4ae0-a70f-bf59b8a2196b', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('18a23c8c-e007-4a0c-92e0-602683705be5', 'ad4891db-d75f-4ae0-a70f-bf59b8a2196b', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('a3d86143-98a5-47ae-a9b8-b46748a7bbdc', 'e4336ebe-993b-416b-b6dc-5254c6e05e2b', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('8d6b38d2-d179-4112-a4dd-4994b32661aa', 'e4336ebe-993b-416b-b6dc-5254c6e05e2b', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('128fe987-72f6-4af7-8c26-3da06ea0ef53', '3678e00a-e158-4eed-bb5a-46c8d71aca6b', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('1286e37c-d9d3-469c-8d61-4c96dd36df0d', '3678e00a-e158-4eed-bb5a-46c8d71aca6b', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 12000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('37149fff-f68e-47ae-876d-9dd64900d797', '8655dc97-340e-40b7-8c73-782ccedb8cac', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('afb938ea-9e3c-489e-b396-5cd5c34063fc', '8655dc97-340e-40b7-8c73-782ccedb8cac', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('c241639c-3551-4dab-9b1a-4da149238cdf', 'e400fe2e-57d1-45b4-a31c-6d09ed05b8cd', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('c7b3c043-0c06-4f27-8a70-dc5147e11fd6', 'e400fe2e-57d1-45b4-a31c-6d09ed05b8cd', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('354bce8d-3ff2-4576-abea-b775863671ce', 'cd0148b0-f341-41b5-928b-e295fa442625', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('9816b491-28a9-406b-92c4-8da21141ba56', 'cd0148b0-f341-41b5-928b-e295fa442625', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('2017946b-2154-4a8a-9819-8f210b1f61ec', '91353136-fbdf-4531-bec5-9f705c92762e', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('b16fe00a-b71a-4b81-8bb9-ece9cd375fb3', '91353136-fbdf-4531-bec5-9f705c92762e', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('6cfedb90-a956-4ed4-a60b-9aaeff79b538', 'd6e6a9f6-99a4-4d4e-b45a-85bfffc28fa8', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('2a0e0901-4d22-43c6-b4a6-2678557fa17b', 'd6e6a9f6-99a4-4d4e-b45a-85bfffc28fa8', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('6da6395a-7c77-42d8-8bb9-6039a36e7de1', '6c3a4a7f-af00-4aac-82a5-663c1e041d7f', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('c15950da-cc56-413e-ac71-66d39b921fb9', '6c3a4a7f-af00-4aac-82a5-663c1e041d7f', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('e6f01e18-b400-4de1-a066-5310ef4fb6ac', 'df27a43e-a829-4dc9-94f9-0effb25deae1', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('61da3e57-b53d-4fe4-9d58-582a0e125eb5', 'df27a43e-a829-4dc9-94f9-0effb25deae1', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('577daac8-4255-468f-bbd2-5e68f35e7f82', '6bd6a5f5-c266-4fbc-8717-6aa80a4feaa7', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('40c8acbe-9742-4563-a61d-52e1c8fc957e', '6bd6a5f5-c266-4fbc-8717-6aa80a4feaa7', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('ca451b43-7276-4819-85ee-f43ea3704e56', 'bb3b93a7-2f00-4fb7-b337-c9d15254590f', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('b5d5a49c-6487-46ed-b951-b119c322c8e5', 'bb3b93a7-2f00-4fb7-b337-c9d15254590f', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('d3d3ec66-1f3c-4ea8-a10b-664e9c735952', 'c9df9707-366c-4355-8f09-ee5a22782620', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('3688e93f-1e23-4977-8cb4-f16f4cef0800', 'c9df9707-366c-4355-8f09-ee5a22782620', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('975e0cab-557f-4c8a-8e68-e891454613a7', '5d7e11c2-b984-498a-bcd4-eb4ae7144cb5', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('9d0e3696-a365-4345-9391-69c7e1bcf8dc', '5d7e11c2-b984-498a-bcd4-eb4ae7144cb5', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('cabd29a4-2648-4d23-9aa2-50dbd3bafd3e', '22fc0e18-fa8c-49ae-8704-0cf540e9512e', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('07f61a67-872e-4218-aa1b-4c07ba2ae71f', '22fc0e18-fa8c-49ae-8704-0cf540e9512e', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('6565c1bb-faaf-4d2c-b36f-fa8ec8caf195', 'a6c96f8f-6b72-476f-8728-d61191e56719', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('c567ae5e-9e21-4e53-ad76-4559082d2b2a', 'a6c96f8f-6b72-476f-8728-d61191e56719', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('b81a11fb-346e-48f9-8d0e-ea9f264db33b', '99593072-9d3e-4aa8-b967-2849d7355fec', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('5a5fa24f-161d-4177-8a6f-dec205e47d98', '99593072-9d3e-4aa8-b967-2849d7355fec', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('78a35c79-6734-4010-b760-c51c16ca3a3a', '7acee28a-a2b5-4fa8-bb49-026d2092a59e', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('d7925f83-918a-42ea-a454-d13bfa95f843', '7acee28a-a2b5-4fa8-bb49-026d2092a59e', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('7ccdc654-04c2-4810-8b10-5ac98456184e', '71f2aa94-8364-489c-b55a-334b870fe1e1', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('f335e4bf-7b92-4c3a-9ed6-20808ace613a', '71f2aa94-8364-489c-b55a-334b870fe1e1', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('93c3aaa7-7d68-4627-8cf0-6d5ddf9cbbe9', '13e03c46-58a9-45c4-8154-d2d6af04ff19', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('c3032536-0eef-4ddc-ac28-6473826eb37f', '13e03c46-58a9-45c4-8154-d2d6af04ff19', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('4bef0150-6f1a-45f7-98eb-54218b107c05', '2993189b-9541-42f7-b75d-b4077f035cb0', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('7c4e0953-8eaa-4fb7-b48d-b84797cfee0f', '2993189b-9541-42f7-b75d-b4077f035cb0', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('4684c16e-9ad7-488f-9436-111d2874a42e', '2d0fb463-8bbd-40d8-a10c-3e7441102c1e', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('595c84fd-6acf-4718-b7cc-7c7a63f5f436', '2d0fb463-8bbd-40d8-a10c-3e7441102c1e', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 24000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('3fad1f2e-adfb-440a-886e-56395553ae3e', '47ea527d-3282-436a-965e-b341315759de', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('1ee4b00e-53a2-44ab-8607-2528ef67d76f', '47ea527d-3282-436a-965e-b341315759de', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('9fa18ade-c8df-4c6a-bac9-8b3bdf7855e8', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('bdf730ab-aeb5-47de-99fe-76a518974d79', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('2df00460-4f21-4525-8dfb-9d79543910c8', 'ce867446-632d-463c-9550-ee082072994a', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('1f29f324-7424-47d1-8317-1e7fe5d997fd', 'ce867446-632d-463c-9550-ee082072994a', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('7af91b85-1dfd-47a3-b78d-26b90b79477f', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('dc44f353-da89-4c6b-acaf-8042179093c3', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('ee44e11f-de32-4829-a98d-ef741403c854', '81a105f0-f609-4ae2-8696-b938f99047b7', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('1acfccf7-315a-4556-9343-01768030f6f3', '81a105f0-f609-4ae2-8696-b938f99047b7', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('3e8e01d9-bd20-4594-bf1a-cccaac459f18', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('1227af47-6b74-4c63-aef8-5d50fb1c62b9', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 24000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('da9e5e13-62c4-43e1-acf3-cb2bc6f1803d', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('d2c6940d-3835-4b5b-9e21-0822927e460c', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('3bbd7bd4-9ea0-4d86-af79-4d55e6d1b042', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('98c492a7-243d-4b9d-bcc1-94b9e4c4b412', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('c834ba6f-415e-404e-ae66-cd3a8d43202c', '3f256a22-dbf2-4858-b219-8a887459d13f', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('4e12d942-d31d-4b6c-b799-aad59ab8081b', '3f256a22-dbf2-4858-b219-8a887459d13f', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 12000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('272c52b3-2eda-404a-90d8-d8f6725efcfd', '8943fdc0-0495-452d-a818-a7518c7bacc2', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('544046ad-3e3f-456d-a9f1-ce752b9a6d87', '8943fdc0-0495-452d-a818-a7518c7bacc2', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('3b9c89e2-cfdf-4e12-8eed-2c2925aff80e', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('f8a09d02-978e-4486-a7e3-71b65560c668', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('297b3d09-c39b-486b-a0c3-71362f6719fc', '5dbf5457-69eb-49c3-8298-582f50cdd642', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('aa2604bd-e0bd-47b6-ad55-3d08c800dd56', '5dbf5457-69eb-49c3-8298-582f50cdd642', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('b4e818ff-ed17-49ea-9ae8-df16b6a3bffa', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('da6cb112-a32d-4db7-b5cb-9540567271ef', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('2dd7884b-7cf9-4b77-ad81-d1426611ca17', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('ac9d9ef2-0b4d-4efc-bc81-816b2b5d9410', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('436c3e38-979a-4031-9b17-9625f4a62f3b', '6291ab92-3882-4932-91c3-ce8a06921842', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('9e5bb247-0cc9-447c-a19b-f9727796f8fc', '6291ab92-3882-4932-91c3-ce8a06921842', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('eed7a9fc-3046-47cb-be1c-6b153303aa3f', '495847cf-06f6-49bc-8a68-7df5c0504838', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('4eea04d8-371a-4285-9543-b1f7bc23ebaf', '495847cf-06f6-49bc-8a68-7df5c0504838', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('3b8b9eab-5dbc-47c4-b270-e0720b5a66ab', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('902addf5-609d-4e41-b926-d872ad0a2724', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('b822cc1a-3226-4c4d-acc6-daa5b3ad5f1a', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('02f16d14-669b-4786-8c3a-b0b3d238e8ff', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('c808877e-7763-4369-8a93-6a414fe85bfe', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('ba0171d2-394c-4055-b257-28059a86fab4', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('313b0120-2c25-4ff7-a27d-8d2ec8609fad', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('efcc8cde-a74e-426e-8d1a-a95103cf20ba', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('81d68aae-775c-48a8-a847-4bea17c386c1', '0f36f844-1667-4355-bd12-a2d530396858', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('e580abbc-41fa-48cc-88ad-f0ca709c22a1', '0f36f844-1667-4355-bd12-a2d530396858', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('bcce6c20-0629-4eb3-9f64-9d1dfd5d9af7', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('e2112314-a5e2-49bb-9e06-0d9febe21bd8', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('fb9d0c06-bcc1-4732-98f8-f44356147926', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('a11e07ac-4373-4d73-bb77-abda1c8af020', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('c35d29ed-ce48-4cbc-8ecf-31153c6a1856', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('fcdb13d1-d257-4b2b-9023-fe2cbc8ac768', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('40b42a08-a31c-4ec1-a3de-1f3c8ff3fe50', 'b51e5f2e-9914-43d6-8388-65054f711f30', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('6c9b14e5-df7b-4e4e-b037-4f2638306cc6', 'b51e5f2e-9914-43d6-8388-65054f711f30', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('865fd10a-35d3-40f6-a13b-ad1cf5793773', '3888eca5-9184-4a80-917b-a64b68849477', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('cf6d9a30-432b-4c97-a3b7-b59cd70bc2d3', '3888eca5-9184-4a80-917b-a64b68849477', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('83e2c384-8a69-4f9d-a966-95ec7f89b3c8', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('3208dc8c-1f93-4040-85f0-b4d29b4e1b12', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('2e2022e4-1107-4730-82d8-2dd9f9166983', '7650bd3b-845f-4ca5-938d-d1e233240b61', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('22782bf6-0195-4d12-b261-58640ac78c29', '7650bd3b-845f-4ca5-938d-d1e233240b61', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 24000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('3d9e9b78-8c18-4113-8768-d930f8cc72f0', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('60d9a480-4ad8-4902-963f-554c8b4ea2de', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('c4ce1f54-4029-4253-b8a7-1e55a9f7839f', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('f520d2ac-e00a-4162-8c17-a3b988a7f951', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('324c7d23-e62f-450c-9a83-141aafc3149c', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('f19d5673-d296-466a-ae77-cab649e14c33', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 12000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('d6bd7c0b-f175-4361-8e3d-d33af37d6be9', '238f874e-fa56-4761-bf3a-7ee59df55416', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('f1e56255-05db-4267-b6bd-e81cc457ae58', '238f874e-fa56-4761-bf3a-7ee59df55416', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('759873d4-7337-4bd0-8934-2276de8b749a', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('e80d4406-c4cf-4524-bdbc-c06b3dd5c36f', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('0fd05939-55d9-48e7-a47f-3d7dd836c5a4', 'c04c6e65-f054-4267-a246-b3cca1efac98', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('510a6a97-06e3-42cc-b4c2-43047c9a5347', 'c04c6e65-f054-4267-a246-b3cca1efac98', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('fe12f88b-f884-4b2f-83ed-3848dc62a998', '1636441c-a228-4fcc-99f4-1f86d90db245', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('b5021a1c-7fa4-4f24-8109-5b0600761fb9', '1636441c-a228-4fcc-99f4-1f86d90db245', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('0be11335-260a-4d3f-a16d-f6d373af79ab', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('d68ee000-8550-4f56-91db-e488dbd864b5', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('043bce85-dd70-4c76-85ac-e3feb1272a4c', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('f46c8ed4-8db6-48c0-9378-25e0783ca0ba', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 24000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('29ea1dd5-12d1-4c3c-b7e8-4c83f453c840', '62d91186-46da-4bb7-bacc-fd182c860357', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('88e5ae3e-0d27-43e0-8ccd-cecf0ea8614a', '62d91186-46da-4bb7-bacc-fd182c860357', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 26000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('8927aa49-bc5a-4866-9e92-91544f46c894', 'aaf948fe-4305-4ac2-9b43-97078e915814', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('5a23115f-b029-4d80-8091-86e7b6224c6d', 'aaf948fe-4305-4ac2-9b43-97078e915814', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 10000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('4edf02ef-20c2-46bd-b5a6-2444cfb93feb', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('b7d14dfc-f2e0-4027-84fd-c64f5182277c', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 12000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('ddd46164-f349-4ba0-b05d-182d06040714', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('bd2202e8-8e85-47c6-9d84-e26ee2e23d39', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('a5dd80ce-e917-4638-b835-bfe2f0396f75', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('2bc911d1-77de-4063-adf6-2b2e773ec1df', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('bfba006e-223d-424e-8aa3-7070e8a1b13f', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('bcd6555e-ff65-42a7-b87c-7889968c8cc4', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('d6c8164d-cc02-40c1-b5e6-8de9c08ccc86', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('e8a5681b-45dc-4b99-8972-8ad5edcf87ed', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('07de7f50-9be7-45b0-8473-890a5d479ea9', '36504c39-4314-4f21-b4d7-936d85d35aaa', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('e9c7efd7-66cf-4825-8706-c6f83d2196c4', '36504c39-4314-4f21-b4d7-936d85d35aaa', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('af6baf3e-0475-466e-997f-e2c805ab1721', '7d6d013f-d5a4-4efe-bb88-c16401163509', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('69095c2a-69d9-4b61-98a0-0ab7befa516f', '7d6d013f-d5a4-4efe-bb88-c16401163509', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 24000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('7c2e15b4-acee-475c-aac9-c1788733cebc', '93b30971-37da-4bd2-9335-dd7191ff38d4', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('56551c70-70e4-4aea-937f-32bdf474f032', '93b30971-37da-4bd2-9335-dd7191ff38d4', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('aa68097c-fd82-458f-ae12-c63bbe36fe30', 'af03d123-d596-452c-a94b-66254df1f732', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('935e1f8c-9993-468f-b20d-ee0826e25db4', 'af03d123-d596-452c-a94b-66254df1f732', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('5a5f7036-0287-4567-9fea-ca783582c487', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('a0209fdc-e7bc-4cd3-812e-f805917efd3f', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 12000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('3e721f6f-f307-44f0-aa4e-383bbc680190', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('08e03719-d8a5-4a68-aa2d-5640f26dd39d', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('67699d2c-d7ae-4425-b681-7a1f6c8c0de7', '5825f125-7948-495d-80a1-b25e3721d8ca', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('7fc834eb-7dab-4eae-bf94-c93a46c15d19', '5825f125-7948-495d-80a1-b25e3721d8ca', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('d38e8358-6acc-41c0-b74e-d75ef82826db', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('91a36db3-bff1-43a1-95ad-0cdb6932c8d1', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('c88576e1-b9be-4eec-85ae-838e601aa0a4', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('e014db38-493e-4171-b914-20a11fa1d6ff', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('f85efe8e-72b0-46b5-8df8-1316e06aea7b', '94a54418-365a-4cec-80d8-180f774fa135', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('dd13ee39-f541-452f-884f-ea8197e2da2e', '94a54418-365a-4cec-80d8-180f774fa135', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('73f36dc0-ff11-4c7f-a843-9d41898ceef8', '02266bb6-c3e8-4667-a465-34a7463f6216', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('654f74d5-e822-4d70-ad2f-98eba68f5207', '02266bb6-c3e8-4667-a465-34a7463f6216', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('9bcd376f-1120-4c0b-984c-e62ca35a926a', 'a91fff91-304b-4029-b1b3-796f03432262', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('e59d8467-ad32-4b98-8c77-23fe22e192c2', 'a91fff91-304b-4029-b1b3-796f03432262', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('1fb6a858-315f-4d63-abe3-7a42ecd778db', '918731c6-604e-4795-9dd4-65bb2b0ff316', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('b473234b-9600-4a30-adeb-af22850ba0e8', '918731c6-604e-4795-9dd4-65bb2b0ff316', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('23d5d43f-205f-43e9-839a-f342034cd45d', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('da78c02e-4cce-41ef-8fab-5fb370b405f5', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('d38b4675-1c03-4924-974d-12ff60f6d012', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('1ceca661-96a9-4e6f-bcc1-7c22cac97d9a', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('0772288e-5eea-4ad0-900b-d6b5c0077e0b', 'e29504df-f994-4081-ab30-8880cb31295c', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('81021549-c2c6-461d-b623-c84c49405e94', 'e29504df-f994-4081-ab30-8880cb31295c', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('8d80d33c-2d0e-4caa-94c7-2572d5b12177', '8549718e-a328-4d01-8daf-b658a61e80af', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('f558e760-679d-45c5-a617-7b6237fe4661', '8549718e-a328-4d01-8daf-b658a61e80af', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('f6b26f21-7eaf-4584-9ffa-990b14d7759e', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('570f53b0-5a1d-4645-8d0a-d5927a64dda4', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('fe6cc52e-b46d-4f66-8743-29e05040cfb2', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('d6a285b5-82d2-494e-800b-a5e98b20fbca', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('07259309-d37d-43ee-80ec-bfd4c48b0777', '9a630559-9351-43d0-a3af-ae555b62688b', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('82e6ab39-69a7-44f9-acd8-21ae536c5756', '9a630559-9351-43d0-a3af-ae555b62688b', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('e9f4d91b-172a-4bf4-a404-092bcc3be62e', '6f1cce3d-300c-4a05-b009-603767907351', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('dabf1ce3-6dec-4b7b-b5dc-2362540626f7', '6f1cce3d-300c-4a05-b009-603767907351', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('6b9bdf86-d173-4aed-b0c7-d51905f1e15d', '65241983-adad-4ac9-a586-27339d9b64f9', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('642ead39-38bb-44fc-a718-541a872ffe99', '65241983-adad-4ac9-a586-27339d9b64f9', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('ed99b210-bf0a-4405-a867-086a4941a63d', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('485af63a-718b-4f06-914a-65b0053bce68', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('66336669-af2a-4a9e-a919-3247094db81d', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('7006d99a-96cf-44cc-ba31-b41503fac4ed', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 24000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('758491ce-bb6d-4c2a-a754-c76162f1a3c3', '852cb9a1-21fa-482b-b702-99c45c39f992', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('80434659-8056-440b-bc71-290495f11785', '852cb9a1-21fa-482b-b702-99c45c39f992', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('631085fa-acc9-436e-b734-23ba99943a18', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 2, 2, 2, 650, 850, NULL, NULL, 11000000, 13000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('5f6f1534-8c54-4a55-adc8-4716326f9b40', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 3, 3, 2, 1050, 1250, NULL, NULL, 13000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('eeba0afc-528b-423c-abb5-7e439063b520', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 2, 2, 2, 650, 850, NULL, NULL, 4000000, 6000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('7b4c5420-bee9-402d-a38e-4c9c2f9b686c', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 3, 3, 2, 1050, 1250, NULL, NULL, 6000000, 12000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('774e6b57-1bd9-4eb7-ad6f-d620cd2e4b51', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 2, 2, 2, 650, 850, NULL, NULL, 5000000, 7000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('4844d7b8-71ad-42d4-a134-a67929080d7b', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 3, 3, 2, 1050, 1250, NULL, NULL, 7000000, 14000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('bf288ead-0b12-435b-a5ff-b12a8fc25229', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 2, 2, 2, 650, 850, NULL, NULL, 6000000, 8000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('2c06d11b-9d3a-47fb-8f3a-3ef75233bbca', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 3, 3, 2, 1050, 1250, NULL, NULL, 8000000, 16000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('9c0d6b7a-3b70-4f2c-bf2e-97797940b29c', '3c87d633-0068-42c4-8a43-b391183f2fe8', 2, 2, 2, 650, 850, NULL, NULL, 7000000, 9000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('edcd0270-c789-46e1-9401-301eca3c44e6', '3c87d633-0068-42c4-8a43-b391183f2fe8', 3, 3, 2, 1050, 1250, NULL, NULL, 9000000, 18000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('d58654d5-2d3c-407e-a1e9-5061c5f360cc', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 2, 2, 2, 650, 850, NULL, NULL, 8000000, 10000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('8ce50be1-a5b2-4173-b448-6ff8a1f9fd1a', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 3, 3, 2, 1050, 1250, NULL, NULL, 10000000, 20000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('17e988f5-c4d7-4cbe-8909-d85a77651e06', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 2, 2, 2, 650, 850, NULL, NULL, 9000000, 11000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('b3ca2345-206f-4b70-9256-fe803454d138', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 3, 3, 2, 1050, 1250, NULL, NULL, 11000000, 22000000, NULL, true, 1);
INSERT INTO public.project_configs VALUES ('f8ab314f-53ea-42d5-84ec-bfd694cc0f20', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 2, 2, 2, 650, 850, NULL, NULL, 10000000, 12000000, NULL, true, 0);
INSERT INTO public.project_configs VALUES ('36e193f5-fc27-4acd-b2d3-583430a3a50e', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 3, 3, 2, 1050, 1250, NULL, NULL, 12000000, 24000000, NULL, true, 1);


--
-- Data for Name: project_faqs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.project_faqs VALUES ('fae33bee-51e4-4e8e-9442-d8b1bff4fb3f', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 'What unique architectural feature does Brigade Palava City boast in the Mumbai skyline?', 'Brigade Palava City is designed with 2 towers rising to 12 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('78dc99f8-0113-43d3-ac77-1a9767c40ce5', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 'How beneficial is Brigade Palava City''s connectivity to the rest of Mumbai?', 'Located in Andheri West, Brigade Palava City offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('b45488cb-c019-48b1-b2c8-544e8a7d4bfb', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('641aba02-69f3-45bd-8c95-123defa4e124', 'acfc42a9-2060-4408-ac25-16a6a719b844', 'What unique architectural feature does DLF Greens Enclave boast in the Mumbai skyline?', 'DLF Greens Enclave is designed with 3 towers rising to 13 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('617bd554-9aaf-4047-acc3-1cfc0b83b7e1', 'acfc42a9-2060-4408-ac25-16a6a719b844', 'How beneficial is DLF Greens Enclave''s connectivity to the rest of Mumbai?', 'Located in Powai, DLF Greens Enclave offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('0050bc3e-6673-4557-92d5-6380b49dd160', 'acfc42a9-2060-4408-ac25-16a6a719b844', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('a7d3cb5f-3814-4f7e-a655-115add29bede', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 'What unique architectural feature does Godrej The Arbour boast in the Mumbai skyline?', 'Godrej The Arbour is designed with 4 towers rising to 14 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('9e813e39-9897-458e-b033-f1baf21a2761', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 'How beneficial is Godrej The Arbour''s connectivity to the rest of Mumbai?', 'Located in Chembur, Godrej The Arbour offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('4b00c8f1-7d11-4465-bc6c-b8dc759e2b95', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('a10284b9-ad15-4ba5-b6b9-a1056e6dd88b', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 'What unique architectural feature does Lodha City Heights boast in the Mumbai skyline?', 'Lodha City Heights is designed with 5 towers rising to 15 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('2e0f621f-340e-40ec-854a-055fa5c69689', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 'How beneficial is Lodha City Heights''s connectivity to the rest of Mumbai?', 'Located in Borivali, Lodha City Heights offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('532e9d75-0465-4992-bf15-96ecf89952d9', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('52ef268f-cb0f-4a75-a7aa-55c68d048759', 'ce867446-632d-463c-9550-ee082072994a', 'What unique architectural feature does Prestige Emerald Bay boast in the Mumbai skyline?', 'Prestige Emerald Bay is designed with 6 towers rising to 16 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('326853e2-a1c5-45ee-a804-a473fb517932', 'ce867446-632d-463c-9550-ee082072994a', 'How beneficial is Prestige Emerald Bay''s connectivity to the rest of Mumbai?', 'Located in Goregaon, Prestige Emerald Bay offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('cb8f04d6-c781-49b7-8dfe-5adc1f709626', 'ce867446-632d-463c-9550-ee082072994a', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('25089a85-d7ee-4326-b4f6-54ec2f446c83', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 'What unique architectural feature does Sobha Skyline Residences boast in the Mumbai skyline?', 'Sobha Skyline Residences is designed with 7 towers rising to 17 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('3ff28955-1ef3-449f-8460-78a0bcd55ada', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 'How beneficial is Sobha Skyline Residences''s connectivity to the rest of Mumbai?', 'Located in Kandivali, Sobha Skyline Residences offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('537446f0-a56a-4262-99dd-3a6298c5bca9', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('e345d56f-764b-4cc8-a0a0-346b95fcd2f8', '81a105f0-f609-4ae2-8696-b938f99047b7', 'What unique architectural feature does Brigade Meadows Phase 2 boast in the Mumbai skyline?', 'Brigade Meadows Phase 2 is designed with 2 towers rising to 18 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('fe5bf1bd-53e2-4b4b-bfcd-811c6b41609c', '81a105f0-f609-4ae2-8696-b938f99047b7', 'How beneficial is Brigade Meadows Phase 2''s connectivity to the rest of Mumbai?', 'Located in Malad, Brigade Meadows Phase 2 offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('cd2c962d-f48e-48b3-be94-63d234a11546', '81a105f0-f609-4ae2-8696-b938f99047b7', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('5dcb88dd-2179-4eb0-aa7b-2dac0c594dfb', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 'What unique architectural feature does DLF Horizon Towers boast in the Mumbai skyline?', 'DLF Horizon Towers is designed with 3 towers rising to 19 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('0a8bae65-8b70-4369-9f93-6d3a36ecc431', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 'How beneficial is DLF Horizon Towers''s connectivity to the rest of Mumbai?', 'Located in Jogeshwari, DLF Horizon Towers offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('4420f396-7c1e-4fad-86d6-a837e036ff0f', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('6a47a789-99bd-49fc-ab7a-ae73d3ab3209', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 'What unique architectural feature does Godrej Serenity Park boast in the Mumbai skyline?', 'Godrej Serenity Park is designed with 4 towers rising to 20 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('7695c2c3-9458-4360-994f-3e5d96707228', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 'How beneficial is Godrej Serenity Park''s connectivity to the rest of Mumbai?', 'Located in Vile Parle, Godrej Serenity Park offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('35052411-b379-479f-b076-ecaef0686e7d', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('3fe9e363-1922-4a3f-9e8d-1df5635ed3d5', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 'What unique architectural feature does Lodha Urban Vista boast in the Mumbai skyline?', 'Lodha Urban Vista is designed with 5 towers rising to 21 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('585171cc-a0f1-4ab7-b815-cb96171c010b', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 'How beneficial is Lodha Urban Vista''s connectivity to the rest of Mumbai?', 'Located in Santacruz, Lodha Urban Vista offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('d24f67c1-d4b1-4498-8f13-eee27d11a2ba', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('2875f71b-391c-4abc-82f4-a46a98c306bc', '3f256a22-dbf2-4858-b219-8a887459d13f', 'What unique architectural feature does Prestige Palava City boast in the Mumbai skyline?', 'Prestige Palava City is designed with 6 towers rising to 22 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('01d2e789-05ba-4d87-87e6-c82b05176c5e', '3f256a22-dbf2-4858-b219-8a887459d13f', 'How beneficial is Prestige Palava City''s connectivity to the rest of Mumbai?', 'Located in Bandra, Prestige Palava City offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('447454df-7f6b-4472-ae9d-948abc2fd837', '3f256a22-dbf2-4858-b219-8a887459d13f', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('a92951da-b930-4243-9128-ad9f9042bbcb', '8943fdc0-0495-452d-a818-a7518c7bacc2', 'What unique architectural feature does Sobha Greens Enclave boast in the Mumbai skyline?', 'Sobha Greens Enclave is designed with 7 towers rising to 23 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('c7789f4c-bf0a-4a59-a80e-0560d937bbef', '8943fdc0-0495-452d-a818-a7518c7bacc2', 'How beneficial is Sobha Greens Enclave''s connectivity to the rest of Mumbai?', 'Located in Dahisar, Sobha Greens Enclave offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('9aae3fe7-8550-4ba2-8ec0-e224a7feccc5', '8943fdc0-0495-452d-a818-a7518c7bacc2', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('d1f97784-8087-468b-8c7c-09de5b80e526', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 'What unique architectural feature does Brigade The Arbour boast in the Mumbai skyline?', 'Brigade The Arbour is designed with 2 towers rising to 24 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('050af561-6c15-41c6-b8cf-df5914648944', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 'How beneficial is Brigade The Arbour''s connectivity to the rest of Mumbai?', 'Located in Mira Road, Brigade The Arbour offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('77a171be-2069-4c32-9149-51306ee91975', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('4cb5b9be-7bf8-4ae1-a381-ed5a5f782058', '5dbf5457-69eb-49c3-8298-582f50cdd642', 'What unique architectural feature does DLF City Heights boast in the Mumbai skyline?', 'DLF City Heights is designed with 3 towers rising to 25 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('67079053-c4cc-4102-9675-e77d4b84b66b', '5dbf5457-69eb-49c3-8298-582f50cdd642', 'How beneficial is DLF City Heights''s connectivity to the rest of Mumbai?', 'Located in Mulund, DLF City Heights offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('21e23459-5b7e-40b5-9927-66888dc7a4ef', '5dbf5457-69eb-49c3-8298-582f50cdd642', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('bb479918-84a7-4557-9fb3-1b3ec011e8a6', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 'What unique architectural feature does Godrej Emerald Bay boast in the Mumbai skyline?', 'Godrej Emerald Bay is designed with 4 towers rising to 26 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('dba7c183-9366-497c-b3b2-bf4bcb147552', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 'How beneficial is Godrej Emerald Bay''s connectivity to the rest of Mumbai?', 'Located in Vikhroli, Godrej Emerald Bay offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('2df6d81a-f5cd-4a93-a7d8-8bf738c50900', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('e453a6e1-6cc5-43c4-b387-938584460fd7', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 'What unique architectural feature does Lodha Skyline Residences boast in the Mumbai skyline?', 'Lodha Skyline Residences is designed with 5 towers rising to 27 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('8fac479c-c642-4a52-add6-b6ccf43e0479', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 'How beneficial is Lodha Skyline Residences''s connectivity to the rest of Mumbai?', 'Located in Ghatkopar, Lodha Skyline Residences offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('8cf0e10d-a326-4919-a62b-833f82ffa83d', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('330f1796-1cdd-44d8-b526-b927fa6cdd46', '6291ab92-3882-4932-91c3-ce8a06921842', 'What unique architectural feature does Prestige Meadows Phase 2 boast in the Mumbai skyline?', 'Prestige Meadows Phase 2 is designed with 6 towers rising to 28 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('f9068636-75e3-4311-9a2b-a25acc604257', '6291ab92-3882-4932-91c3-ce8a06921842', 'How beneficial is Prestige Meadows Phase 2''s connectivity to the rest of Mumbai?', 'Located in Kanjurmarg, Prestige Meadows Phase 2 offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('d1ed6794-a9a1-4e3c-a55b-93cf8530b221', '6291ab92-3882-4932-91c3-ce8a06921842', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('ba521d06-7125-4d93-b528-975165b530fe', '495847cf-06f6-49bc-8a68-7df5c0504838', 'What unique architectural feature does Sobha Horizon Towers boast in the Mumbai skyline?', 'Sobha Horizon Towers is designed with 7 towers rising to 29 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('769052c3-4a6e-46be-b620-616b184afb63', '495847cf-06f6-49bc-8a68-7df5c0504838', 'How beneficial is Sobha Horizon Towers''s connectivity to the rest of Mumbai?', 'Located in Bhandup, Sobha Horizon Towers offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('c0126b23-4c98-4085-8fc2-77b143468ddf', '495847cf-06f6-49bc-8a68-7df5c0504838', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('917da507-6a50-4992-8b00-0eb48f93ebdb', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 'What unique architectural feature does Brigade Serenity Park boast in the Mumbai skyline?', 'Brigade Serenity Park is designed with 2 towers rising to 30 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('ec32a759-a5c9-4b1a-8f5d-07f1eca24dde', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 'How beneficial is Brigade Serenity Park''s connectivity to the rest of Mumbai?', 'Located in Worli, Brigade Serenity Park offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('d37960f7-dcd5-4d13-b97c-b90ce3790c69', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('ddd07d5a-fc14-4808-ae5a-87bf945fd685', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 'What unique architectural feature does DLF Urban Vista boast in the Mumbai skyline?', 'DLF Urban Vista is designed with 3 towers rising to 31 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('6d0a8dff-a396-4259-b940-1eaea8b9386f', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 'How beneficial is DLF Urban Vista''s connectivity to the rest of Mumbai?', 'Located in Mahalaxmi, DLF Urban Vista offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('fb9642f3-7c9c-4b8a-b950-947b5b79ee8f', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('7194ab7f-204e-4734-9ff6-039e19e29e38', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 'What unique architectural feature does Godrej Palava City boast in the Mumbai skyline?', 'Godrej Palava City is designed with 4 towers rising to 12 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('583c5b39-aa5d-4457-a4df-ed456cc63a84', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 'How beneficial is Godrej Palava City''s connectivity to the rest of Mumbai?', 'Located in Byculla, Godrej Palava City offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('ccb59487-6177-4c6a-8790-c44c89726106', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('97dc61b8-d892-4ff5-9d1b-abecbdd844da', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 'What unique architectural feature does Lodha Greens Enclave boast in the Mumbai skyline?', 'Lodha Greens Enclave is designed with 5 towers rising to 13 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('2bcb9659-0ddb-41d2-ae8c-f83081a9e011', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 'How beneficial is Lodha Greens Enclave''s connectivity to the rest of Mumbai?', 'Located in Sewri, Lodha Greens Enclave offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('9dbec827-aee2-4625-84de-ad31abbfdaa5', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('29705cbd-4de3-4db2-8be6-1f93e7561c9a', '0f36f844-1667-4355-bd12-a2d530396858', 'What unique architectural feature does Prestige The Arbour boast in the Mumbai skyline?', 'Prestige The Arbour is designed with 6 towers rising to 14 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('cf14c02c-8748-4f27-81c2-f3759647dc86', '0f36f844-1667-4355-bd12-a2d530396858', 'How beneficial is Prestige The Arbour''s connectivity to the rest of Mumbai?', 'Located in Parel, Prestige The Arbour offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('23e2c6b4-2730-4e45-ba2f-eb531041a7ac', '0f36f844-1667-4355-bd12-a2d530396858', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('140fd41b-68de-4e3c-84a8-e6c0d477766f', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 'What unique architectural feature does Sobha City Heights boast in the Mumbai skyline?', 'Sobha City Heights is designed with 7 towers rising to 15 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('a062426b-0983-4c4e-9d89-0c6e4ed9519e', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 'How beneficial is Sobha City Heights''s connectivity to the rest of Mumbai?', 'Located in Dadar, Sobha City Heights offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('b18a7f84-fe72-4a1f-9e0d-8b00acfe8665', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('60af11d7-c6fc-4389-9268-f34526f4a498', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 'What unique architectural feature does Brigade Emerald Bay boast in the Mumbai skyline?', 'Brigade Emerald Bay is designed with 2 towers rising to 16 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('fa3b3ae0-1068-4670-8d11-e730009bdf7c', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 'How beneficial is Brigade Emerald Bay''s connectivity to the rest of Mumbai?', 'Located in Lalbaug, Brigade Emerald Bay offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('392e861f-7a9e-44cb-97bf-af02c982de3d', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('b0a5d648-b4c9-46c4-8e6c-6dfe36dc5c94', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 'What unique architectural feature does DLF Skyline Residences boast in the Mumbai skyline?', 'DLF Skyline Residences is designed with 3 towers rising to 17 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('bce7efb9-81c2-4bac-93b0-a87081421a3c', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 'How beneficial is DLF Skyline Residences''s connectivity to the rest of Mumbai?', 'Located in Lower Parel, DLF Skyline Residences offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('4a0a3427-fbcd-4078-a871-6576ed672e69', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('cd379124-d82c-4a10-a397-6f8933f78ebb', 'b51e5f2e-9914-43d6-8388-65054f711f30', 'What unique architectural feature does Godrej Meadows Phase 2 boast in the Mumbai skyline?', 'Godrej Meadows Phase 2 is designed with 4 towers rising to 18 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('2bedaf72-8ac5-47bd-9863-dc582977aa94', 'b51e5f2e-9914-43d6-8388-65054f711f30', 'How beneficial is Godrej Meadows Phase 2''s connectivity to the rest of Mumbai?', 'Located in Prabhadevi, Godrej Meadows Phase 2 offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('3831ad84-5efc-423b-a198-b1e61a633ade', 'b51e5f2e-9914-43d6-8388-65054f711f30', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('b740bdda-7f4b-4cee-9d97-49acee27dbd9', '3888eca5-9184-4a80-917b-a64b68849477', 'What unique architectural feature does Lodha Horizon Towers boast in the Mumbai skyline?', 'Lodha Horizon Towers is designed with 5 towers rising to 19 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('cbb4e378-ceb0-4f43-9732-1b82c22437fe', '3888eca5-9184-4a80-917b-a64b68849477', 'How beneficial is Lodha Horizon Towers''s connectivity to the rest of Mumbai?', 'Located in Mahim, Lodha Horizon Towers offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('f8c5a6dd-cff0-4544-8aa3-50e6c5de8307', '3888eca5-9184-4a80-917b-a64b68849477', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('f9458983-1a88-4550-bd57-369b9391f2a6', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 'What unique architectural feature does Prestige Serenity Park boast in the Mumbai skyline?', 'Prestige Serenity Park is designed with 6 towers rising to 20 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('e21e9bf5-c435-4f6c-8780-85180d3c76d4', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 'How beneficial is Prestige Serenity Park''s connectivity to the rest of Mumbai?', 'Located in Sion, Prestige Serenity Park offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('c7ca14cb-a703-4a97-b9ee-a8e675fd155f', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('491fd966-9963-47f4-a91a-c7180bbe62e3', '7650bd3b-845f-4ca5-938d-d1e233240b61', 'What unique architectural feature does Sobha Urban Vista boast in the Mumbai skyline?', 'Sobha Urban Vista is designed with 7 towers rising to 21 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('61047269-96e5-4a11-9fe4-4ae00eae1e38', '7650bd3b-845f-4ca5-938d-d1e233240b61', 'How beneficial is Sobha Urban Vista''s connectivity to the rest of Mumbai?', 'Located in Wadala, Sobha Urban Vista offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('6ec53618-eb8e-44e8-b4f7-0d024356cb65', '7650bd3b-845f-4ca5-938d-d1e233240b61', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('1958f754-78b3-4b49-86d0-db2700b0a12e', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 'What unique architectural feature does Brigade Palava City boast in the Mumbai skyline?', 'Brigade Palava City is designed with 2 towers rising to 22 floors, giving it a distinctive silhouette and panoramic views across Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('d44fa9cc-24b4-48fb-b669-1f29b8631517', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 'How beneficial is Brigade Palava City''s connectivity to the rest of Mumbai?', 'Located in Matunga, Brigade Palava City offers convenient access to key business districts, railway stations, and arterial roads across Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('a9cdffb1-c9c4-4e2f-bd19-4eb7c3a86cce', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('3e600a35-fc5c-4e66-a5a7-2301f24af1fc', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 'What unique architectural feature does DLF Greens Enclave boast in the Thane skyline?', 'DLF Greens Enclave is designed with 3 towers rising to 23 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('3ab80756-6620-4c39-90b3-0a0cf17b8dcc', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 'How beneficial is DLF Greens Enclave''s connectivity to the rest of Thane?', 'Located in Ghodbunder Road, DLF Greens Enclave offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('8cdafbda-9e38-432f-9ee6-ee825d5b040e', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('af3786a9-5d3f-4b98-8887-923f2c91a6b6', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 'What unique architectural feature does Godrej The Arbour boast in the Thane skyline?', 'Godrej The Arbour is designed with 4 towers rising to 24 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('e76d5b5b-d37a-4253-8077-942dc1fe756f', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 'How beneficial is Godrej The Arbour''s connectivity to the rest of Thane?', 'Located in Dombivli, Godrej The Arbour offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('1b66c52d-276b-4cb9-acd9-50540140dbc4', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('4115c266-5a62-4c98-bc9d-d187add27a1e', '238f874e-fa56-4761-bf3a-7ee59df55416', 'What unique architectural feature does Lodha City Heights boast in the Thane skyline?', 'Lodha City Heights is designed with 5 towers rising to 25 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('91b0c831-1eaa-4043-9819-3d3e18829cc2', '238f874e-fa56-4761-bf3a-7ee59df55416', 'How beneficial is Lodha City Heights''s connectivity to the rest of Thane?', 'Located in Kalyan, Lodha City Heights offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('a5495d9a-4283-44a9-b932-37519519b8d1', '238f874e-fa56-4761-bf3a-7ee59df55416', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('a830f75e-7dae-44fc-804e-9d52ade68ad8', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 'What unique architectural feature does Prestige Emerald Bay boast in the Thane skyline?', 'Prestige Emerald Bay is designed with 6 towers rising to 26 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('f447c469-288b-40ff-91ac-6fa23cc516f1', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 'How beneficial is Prestige Emerald Bay''s connectivity to the rest of Thane?', 'Located in Shilphata, Prestige Emerald Bay offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('349eb249-dd21-4119-852a-ade45f69907d', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('7d2a191b-432b-433e-b71b-41ed92ce8f70', 'c04c6e65-f054-4267-a246-b3cca1efac98', 'What unique architectural feature does Sobha Skyline Residences boast in the Thane skyline?', 'Sobha Skyline Residences is designed with 7 towers rising to 27 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('2e1a9a8c-abdb-47ec-921b-6eaf69455762', 'c04c6e65-f054-4267-a246-b3cca1efac98', 'How beneficial is Sobha Skyline Residences''s connectivity to the rest of Thane?', 'Located in Kasarvadavali, Sobha Skyline Residences offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('94c89c76-d199-4643-ad13-fa466daeb850', 'c04c6e65-f054-4267-a246-b3cca1efac98', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('27be860a-eef1-4528-a648-9ad8deb5ed83', '1636441c-a228-4fcc-99f4-1f86d90db245', 'What unique architectural feature does Brigade Meadows Phase 2 boast in the Thane skyline?', 'Brigade Meadows Phase 2 is designed with 2 towers rising to 28 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('a6426d70-7ca6-4259-8c52-0a6ef732ea7d', '1636441c-a228-4fcc-99f4-1f86d90db245', 'How beneficial is Brigade Meadows Phase 2''s connectivity to the rest of Thane?', 'Located in Balkum, Brigade Meadows Phase 2 offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('a4143212-3e8e-4ef3-b0e8-059507dc5bfa', '1636441c-a228-4fcc-99f4-1f86d90db245', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('8f4c7328-60f7-45f4-bb1e-a96b778f47a5', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 'What unique architectural feature does DLF Horizon Towers boast in the Thane skyline?', 'DLF Horizon Towers is designed with 3 towers rising to 29 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('66391d4f-a92f-413b-bc1f-ab9fabbd96c1', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 'How beneficial is DLF Horizon Towers''s connectivity to the rest of Thane?', 'Located in Majiwada, DLF Horizon Towers offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('91451135-c234-4916-981e-14d8afd4e176', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('1f8a0b58-1343-4761-9eef-48c4dfc4b4f2', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 'What unique architectural feature does Godrej Serenity Park boast in the Thane skyline?', 'Godrej Serenity Park is designed with 4 towers rising to 30 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('190ca3ee-7bc9-4965-bd61-4d1fc9bb9808', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 'How beneficial is Godrej Serenity Park''s connectivity to the rest of Thane?', 'Located in Kolshet, Godrej Serenity Park offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('c924c30b-f947-4eda-89a5-1a314ec463dc', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('edb0bb7c-52bb-4512-812b-1cf983e94dc7', '62d91186-46da-4bb7-bacc-fd182c860357', 'What unique architectural feature does Lodha Urban Vista boast in the Thane skyline?', 'Lodha Urban Vista is designed with 5 towers rising to 31 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('0728b2df-d655-44ea-9f65-98b35a6449fc', '62d91186-46da-4bb7-bacc-fd182c860357', 'How beneficial is Lodha Urban Vista''s connectivity to the rest of Thane?', 'Located in Pokhran 1, Lodha Urban Vista offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('87500bf4-a39c-4b58-9d87-4e60ee1127d4', '62d91186-46da-4bb7-bacc-fd182c860357', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('c3f04ee3-3cc3-4cc5-bd9b-70d06b2e4cf6', 'aaf948fe-4305-4ac2-9b43-97078e915814', 'What unique architectural feature does Prestige Palava City boast in the Thane skyline?', 'Prestige Palava City is designed with 6 towers rising to 12 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('e48c201c-6852-4f10-b92f-efb83fdbcbff', 'aaf948fe-4305-4ac2-9b43-97078e915814', 'How beneficial is Prestige Palava City''s connectivity to the rest of Thane?', 'Located in Pokhran 2, Prestige Palava City offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('09d11704-ee29-4c96-a320-c96c712d03b0', 'aaf948fe-4305-4ac2-9b43-97078e915814', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('8dabe784-38b3-46af-b016-644d6091f162', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 'What unique architectural feature does Sobha Greens Enclave boast in the Thane skyline?', 'Sobha Greens Enclave is designed with 7 towers rising to 13 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('9668a16d-454b-46b7-bcc0-3a890a3c1b36', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 'How beneficial is Sobha Greens Enclave''s connectivity to the rest of Thane?', 'Located in Manpada, Sobha Greens Enclave offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('7b05254e-173b-4658-aa03-7e423585966e', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('753132ba-0ed4-404f-bfe8-07b32c15c2d2', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 'What unique architectural feature does Brigade The Arbour boast in the Thane skyline?', 'Brigade The Arbour is designed with 2 towers rising to 14 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('956d3c9f-e102-443b-b847-921c18ec6a66', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 'How beneficial is Brigade The Arbour''s connectivity to the rest of Thane?', 'Located in Bhayandarpada, Brigade The Arbour offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('887b8e97-5fc6-4db4-9bc8-f510941ac720', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('0feb4ce0-6258-4607-8a78-279e960d29d4', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 'What unique architectural feature does DLF City Heights boast in the Thane skyline?', 'DLF City Heights is designed with 3 towers rising to 15 floors, giving it a distinctive silhouette and panoramic views across Thane.', 0);
INSERT INTO public.project_faqs VALUES ('e992d789-c06c-4290-a2fc-3b366e625d4e', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 'How beneficial is DLF City Heights''s connectivity to the rest of Thane?', 'Located in Waghbil, DLF City Heights offers convenient access to key business districts, railway stations, and arterial roads across Thane, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('a8503433-48cf-41c1-975a-7611f25d6c56', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('b82211fd-506f-4650-8d52-fa721a1e9c79', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 'What unique architectural feature does Godrej Emerald Bay boast in the Pune skyline?', 'Godrej Emerald Bay is designed with 4 towers rising to 16 floors, giving it a distinctive silhouette and panoramic views across Pune.', 0);
INSERT INTO public.project_faqs VALUES ('e1b70cd4-9d19-49ee-8853-126b0d7868b9', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 'How beneficial is Godrej Emerald Bay''s connectivity to the rest of Pune?', 'Located in Hinjewadi, Godrej Emerald Bay offers convenient access to key business districts, railway stations, and arterial roads across Pune, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('d6d3a325-afec-48e0-9fd0-4ec5dfc699a3', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('2fccd548-b3b5-4b80-a772-d24a1141bf8d', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 'What unique architectural feature does Lodha Skyline Residences boast in the Pune skyline?', 'Lodha Skyline Residences is designed with 5 towers rising to 17 floors, giving it a distinctive silhouette and panoramic views across Pune.', 0);
INSERT INTO public.project_faqs VALUES ('53a5180f-93b5-471c-a64c-6c47c863e22a', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 'How beneficial is Lodha Skyline Residences''s connectivity to the rest of Pune?', 'Located in Undri, Lodha Skyline Residences offers convenient access to key business districts, railway stations, and arterial roads across Pune, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('72c75f83-00e8-4c52-bcb0-c1393257a135', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('26a349ff-0aef-4f33-a814-74c5ff95a3b3', '36504c39-4314-4f21-b4d7-936d85d35aaa', 'What unique architectural feature does Prestige Meadows Phase 2 boast in the Bangalore skyline?', 'Prestige Meadows Phase 2 is designed with 6 towers rising to 18 floors, giving it a distinctive silhouette and panoramic views across Bangalore.', 0);
INSERT INTO public.project_faqs VALUES ('13a4ec59-1145-4500-bd62-9266a9b9b8d3', '36504c39-4314-4f21-b4d7-936d85d35aaa', 'How beneficial is Prestige Meadows Phase 2''s connectivity to the rest of Bangalore?', 'Located in Whitefield, Prestige Meadows Phase 2 offers convenient access to key business districts, railway stations, and arterial roads across Bangalore, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('e55c4f6f-c435-4107-ad99-ff2c73ee812b', '36504c39-4314-4f21-b4d7-936d85d35aaa', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('8ed0af46-bf3c-4293-996e-8c4b258aa265', '7d6d013f-d5a4-4efe-bb88-c16401163509', 'What unique architectural feature does Sobha Horizon Towers boast in the Bangalore skyline?', 'Sobha Horizon Towers is designed with 7 towers rising to 19 floors, giving it a distinctive silhouette and panoramic views across Bangalore.', 0);
INSERT INTO public.project_faqs VALUES ('ba88b4a8-6661-4e14-a739-194c300320b9', '7d6d013f-d5a4-4efe-bb88-c16401163509', 'How beneficial is Sobha Horizon Towers''s connectivity to the rest of Bangalore?', 'Located in Sarjapur Road, Sobha Horizon Towers offers convenient access to key business districts, railway stations, and arterial roads across Bangalore, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('31d49c35-24b7-484c-88b0-2e17174d423b', '7d6d013f-d5a4-4efe-bb88-c16401163509', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('d4b7092e-e7c6-4524-a94a-4be34a8b334e', '93b30971-37da-4bd2-9335-dd7191ff38d4', 'What unique architectural feature does Brigade Serenity Park boast in the Hyderabad skyline?', 'Brigade Serenity Park is designed with 2 towers rising to 20 floors, giving it a distinctive silhouette and panoramic views across Hyderabad.', 0);
INSERT INTO public.project_faqs VALUES ('8c71bea5-39b5-455b-9f59-046155220e1c', '93b30971-37da-4bd2-9335-dd7191ff38d4', 'How beneficial is Brigade Serenity Park''s connectivity to the rest of Hyderabad?', 'Located in Gachibowli, Brigade Serenity Park offers convenient access to key business districts, railway stations, and arterial roads across Hyderabad, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('4a113d09-8dd1-4f4b-838c-8d0372a1ab64', '93b30971-37da-4bd2-9335-dd7191ff38d4', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('41680eff-bece-4564-b105-5336aeb05b89', 'af03d123-d596-452c-a94b-66254df1f732', 'What unique architectural feature does DLF Urban Vista boast in the Hyderabad skyline?', 'DLF Urban Vista is designed with 3 towers rising to 21 floors, giving it a distinctive silhouette and panoramic views across Hyderabad.', 0);
INSERT INTO public.project_faqs VALUES ('f5f6404c-91ad-4b5b-a8cb-684142a56d99', 'af03d123-d596-452c-a94b-66254df1f732', 'How beneficial is DLF Urban Vista''s connectivity to the rest of Hyderabad?', 'Located in Kokapet, DLF Urban Vista offers convenient access to key business districts, railway stations, and arterial roads across Hyderabad, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('563cc445-ea8c-406f-907c-a0bd0590cd54', 'af03d123-d596-452c-a94b-66254df1f732', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('d07b33ad-ded2-4c43-8089-0e32b57fc8c0', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 'What unique architectural feature does Godrej Palava City boast in the Chennai skyline?', 'Godrej Palava City is designed with 4 towers rising to 22 floors, giving it a distinctive silhouette and panoramic views across Chennai.', 0);
INSERT INTO public.project_faqs VALUES ('c6747c46-d46b-46a2-b414-9363918818fd', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 'How beneficial is Godrej Palava City''s connectivity to the rest of Chennai?', 'Located in OMR, Godrej Palava City offers convenient access to key business districts, railway stations, and arterial roads across Chennai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('c1335c63-084d-41b5-9fce-f9b189a80a6e', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('5cd1e8ad-8a9a-4f7b-adb1-df1e171d0d7e', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 'What unique architectural feature does Lodha Greens Enclave boast in the Chennai skyline?', 'Lodha Greens Enclave is designed with 5 towers rising to 23 floors, giving it a distinctive silhouette and panoramic views across Chennai.', 0);
INSERT INTO public.project_faqs VALUES ('8316d866-5344-46b0-8526-8647a92e45d3', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 'How beneficial is Lodha Greens Enclave''s connectivity to the rest of Chennai?', 'Located in Porur, Lodha Greens Enclave offers convenient access to key business districts, railway stations, and arterial roads across Chennai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('6a27f318-1768-4b4d-b4b2-7999e37b53c6', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('337c65cf-a9db-4b01-a0c8-61faf6d39a03', '5825f125-7948-495d-80a1-b25e3721d8ca', 'What unique architectural feature does Prestige The Arbour boast in the Delhi skyline?', 'Prestige The Arbour is designed with 6 towers rising to 24 floors, giving it a distinctive silhouette and panoramic views across Delhi.', 0);
INSERT INTO public.project_faqs VALUES ('e9d7b5d0-1df5-464f-8755-1ef39466cfac', '5825f125-7948-495d-80a1-b25e3721d8ca', 'How beneficial is Prestige The Arbour''s connectivity to the rest of Delhi?', 'Located in Dwarka, Prestige The Arbour offers convenient access to key business districts, railway stations, and arterial roads across Delhi, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('6d98c976-9070-4c03-b132-49bf056d9685', '5825f125-7948-495d-80a1-b25e3721d8ca', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('cc101088-0624-4bf7-a1ac-8033070ba276', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 'What unique architectural feature does Sobha City Heights boast in the Delhi skyline?', 'Sobha City Heights is designed with 7 towers rising to 25 floors, giving it a distinctive silhouette and panoramic views across Delhi.', 0);
INSERT INTO public.project_faqs VALUES ('d81a023c-c818-4f40-a28a-9643c08c6e96', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 'How beneficial is Sobha City Heights''s connectivity to the rest of Delhi?', 'Located in Dwarka, Sobha City Heights offers convenient access to key business districts, railway stations, and arterial roads across Delhi, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('7baecf93-6da7-4bbc-a579-e44ee77c0fad', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('b3ec8c17-d3dc-43e7-968f-6b52d26263d5', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 'What unique architectural feature does Brigade Emerald Bay boast in the Noida skyline?', 'Brigade Emerald Bay is designed with 2 towers rising to 26 floors, giving it a distinctive silhouette and panoramic views across Noida.', 0);
INSERT INTO public.project_faqs VALUES ('6334ea03-39b5-4bc5-b108-f0da4db3f502', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 'How beneficial is Brigade Emerald Bay''s connectivity to the rest of Noida?', 'Located in Sector 150, Brigade Emerald Bay offers convenient access to key business districts, railway stations, and arterial roads across Noida, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('0ec10173-37d5-481a-9785-accf0b245aa4', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('1dafbd80-e1e3-439c-aa37-cfdecd0d524b', '94a54418-365a-4cec-80d8-180f774fa135', 'What unique architectural feature does DLF Skyline Residences boast in the Noida skyline?', 'DLF Skyline Residences is designed with 3 towers rising to 27 floors, giving it a distinctive silhouette and panoramic views across Noida.', 0);
INSERT INTO public.project_faqs VALUES ('1432fec2-c04b-48cf-9fbc-085348ab6a48', '94a54418-365a-4cec-80d8-180f774fa135', 'How beneficial is DLF Skyline Residences''s connectivity to the rest of Noida?', 'Located in Noida Extension, DLF Skyline Residences offers convenient access to key business districts, railway stations, and arterial roads across Noida, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('2ffd8d11-f644-4a3d-a351-892616e71fb0', '94a54418-365a-4cec-80d8-180f774fa135', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('722f3cfd-db5a-47e8-a807-92911e17d834', '02266bb6-c3e8-4667-a465-34a7463f6216', 'What unique architectural feature does Godrej Meadows Phase 2 boast in the Gurgaon skyline?', 'Godrej Meadows Phase 2 is designed with 4 towers rising to 28 floors, giving it a distinctive silhouette and panoramic views across Gurgaon.', 0);
INSERT INTO public.project_faqs VALUES ('1923d077-48e8-45e3-86bb-8597b720feaa', '02266bb6-c3e8-4667-a465-34a7463f6216', 'How beneficial is Godrej Meadows Phase 2''s connectivity to the rest of Gurgaon?', 'Located in Sector 63, Godrej Meadows Phase 2 offers convenient access to key business districts, railway stations, and arterial roads across Gurgaon, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('229fbc2e-9b4d-4997-9a2e-fb7293ffb5b5', '02266bb6-c3e8-4667-a465-34a7463f6216', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('a2f976de-f7fc-4028-8120-d5d63a89527b', 'a91fff91-304b-4029-b1b3-796f03432262', 'What unique architectural feature does Lodha Horizon Towers boast in the Gurgaon skyline?', 'Lodha Horizon Towers is designed with 5 towers rising to 29 floors, giving it a distinctive silhouette and panoramic views across Gurgaon.', 0);
INSERT INTO public.project_faqs VALUES ('e9ec4561-64e6-4576-b0aa-fa1666efe143', 'a91fff91-304b-4029-b1b3-796f03432262', 'How beneficial is Lodha Horizon Towers''s connectivity to the rest of Gurgaon?', 'Located in Sector 57, Lodha Horizon Towers offers convenient access to key business districts, railway stations, and arterial roads across Gurgaon, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('11da637f-5a9a-459c-8383-2e4c9036e014', 'a91fff91-304b-4029-b1b3-796f03432262', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('836048bc-57c8-41f3-bf16-988ae21b668f', '918731c6-604e-4795-9dd4-65bb2b0ff316', 'What unique architectural feature does Prestige Serenity Park boast in the Kolkata skyline?', 'Prestige Serenity Park is designed with 6 towers rising to 30 floors, giving it a distinctive silhouette and panoramic views across Kolkata.', 0);
INSERT INTO public.project_faqs VALUES ('2aa0ef42-6dc0-42cd-ab40-422f59abd65a', '918731c6-604e-4795-9dd4-65bb2b0ff316', 'How beneficial is Prestige Serenity Park''s connectivity to the rest of Kolkata?', 'Located in New Town, Prestige Serenity Park offers convenient access to key business districts, railway stations, and arterial roads across Kolkata, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('fad5bc8e-e604-4c98-86b5-93906ca5ebc5', '918731c6-604e-4795-9dd4-65bb2b0ff316', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('bf0a89a0-cba9-4d0b-ad76-6a451659acc0', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 'What unique architectural feature does Sobha Urban Vista boast in the Kolkata skyline?', 'Sobha Urban Vista is designed with 7 towers rising to 31 floors, giving it a distinctive silhouette and panoramic views across Kolkata.', 0);
INSERT INTO public.project_faqs VALUES ('13e45974-fecb-4d96-b3e0-ce5a517c2290', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 'How beneficial is Sobha Urban Vista''s connectivity to the rest of Kolkata?', 'Located in New Town, Sobha Urban Vista offers convenient access to key business districts, railway stations, and arterial roads across Kolkata, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('7f0aa00e-164d-4cea-83a8-3f262296d3ea', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('ccb74d47-5ccb-4ebf-b6c4-0e7629fa39e6', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 'What unique architectural feature does Brigade Palava City boast in the Ahmedabad skyline?', 'Brigade Palava City is designed with 2 towers rising to 12 floors, giving it a distinctive silhouette and panoramic views across Ahmedabad.', 0);
INSERT INTO public.project_faqs VALUES ('5e43816f-69ea-4452-8417-25c97c31f4b5', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 'How beneficial is Brigade Palava City''s connectivity to the rest of Ahmedabad?', 'Located in SG Highway, Brigade Palava City offers convenient access to key business districts, railway stations, and arterial roads across Ahmedabad, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('42e88529-b8af-4d74-ac10-04b0b01edb92', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('1729c9be-83c7-4661-9072-2dc4524977a1', 'e29504df-f994-4081-ab30-8880cb31295c', 'What unique architectural feature does DLF Greens Enclave boast in the Ahmedabad skyline?', 'DLF Greens Enclave is designed with 3 towers rising to 13 floors, giving it a distinctive silhouette and panoramic views across Ahmedabad.', 0);
INSERT INTO public.project_faqs VALUES ('2798fb24-47a0-4ec6-8296-9c58e6726838', 'e29504df-f994-4081-ab30-8880cb31295c', 'How beneficial is DLF Greens Enclave''s connectivity to the rest of Ahmedabad?', 'Located in SG Highway, DLF Greens Enclave offers convenient access to key business districts, railway stations, and arterial roads across Ahmedabad, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('fa1608fa-d2e2-40d8-87e7-8e1b1de2029b', 'e29504df-f994-4081-ab30-8880cb31295c', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('f4ff8a75-d34c-41c6-b6dc-9b0405149dc4', '8549718e-a328-4d01-8daf-b658a61e80af', 'What unique architectural feature does Godrej The Arbour boast in the Navi Mumbai skyline?', 'Godrej The Arbour is designed with 4 towers rising to 14 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('d5c32b7b-4bc8-4380-90c8-014ba2a12927', '8549718e-a328-4d01-8daf-b658a61e80af', 'How beneficial is Godrej The Arbour''s connectivity to the rest of Navi Mumbai?', 'Located in Vashi, Godrej The Arbour offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('3c9e5b8a-649d-40d5-98e1-592508a3d79d', '8549718e-a328-4d01-8daf-b658a61e80af', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('2bf57835-5cb2-4ff5-bcb0-e81a35271f15', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 'What unique architectural feature does Lodha City Heights boast in the Navi Mumbai skyline?', 'Lodha City Heights is designed with 5 towers rising to 15 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('a078861f-a6bc-478d-8e66-82c13566db25', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 'How beneficial is Lodha City Heights''s connectivity to the rest of Navi Mumbai?', 'Located in Nerul, Lodha City Heights offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('9e0a96bf-b114-46a7-a222-39e357765399', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('2f651f23-93e2-406f-9c14-8ac914bb55f1', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 'What unique architectural feature does Prestige Emerald Bay boast in the Navi Mumbai skyline?', 'Prestige Emerald Bay is designed with 6 towers rising to 16 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('d8d8ecb9-d8c9-4f9c-9733-d9668f4962dc', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 'How beneficial is Prestige Emerald Bay''s connectivity to the rest of Navi Mumbai?', 'Located in Belapur, Prestige Emerald Bay offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('ca78b643-c49a-400c-8e14-ce1a0a72594a', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('d73793f6-03b5-4161-ade4-d4b05e084856', '9a630559-9351-43d0-a3af-ae555b62688b', 'What unique architectural feature does Sobha Skyline Residences boast in the Navi Mumbai skyline?', 'Sobha Skyline Residences is designed with 7 towers rising to 17 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('cb7c8486-b471-43ac-8571-207e69e19f40', '9a630559-9351-43d0-a3af-ae555b62688b', 'How beneficial is Sobha Skyline Residences''s connectivity to the rest of Navi Mumbai?', 'Located in Palm Beach Road, Sobha Skyline Residences offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('8f5e73c1-6326-431c-9918-0db0598353d7', '9a630559-9351-43d0-a3af-ae555b62688b', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('c5732a4d-ea0a-47c7-a9e5-2d4671598b01', '6f1cce3d-300c-4a05-b009-603767907351', 'What unique architectural feature does Brigade Meadows Phase 2 boast in the Navi Mumbai skyline?', 'Brigade Meadows Phase 2 is designed with 2 towers rising to 18 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('ed4e3662-e3a5-4ca5-8520-8fb70b2c6625', '6f1cce3d-300c-4a05-b009-603767907351', 'How beneficial is Brigade Meadows Phase 2''s connectivity to the rest of Navi Mumbai?', 'Located in Airoli, Brigade Meadows Phase 2 offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('18a5d1cf-128d-4edd-8946-4a98a2d5854f', '6f1cce3d-300c-4a05-b009-603767907351', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('0d80ce68-9b1a-4029-9e0f-3f0dfdd3096c', '65241983-adad-4ac9-a586-27339d9b64f9', 'What unique architectural feature does DLF Horizon Towers boast in the Navi Mumbai skyline?', 'DLF Horizon Towers is designed with 3 towers rising to 19 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('2c9f34ee-8dc5-46d3-8235-e1f18e1faee1', '65241983-adad-4ac9-a586-27339d9b64f9', 'How beneficial is DLF Horizon Towers''s connectivity to the rest of Navi Mumbai?', 'Located in Ghansoli, DLF Horizon Towers offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('7927a808-1192-4e19-8ae2-46ab6dc97795', '65241983-adad-4ac9-a586-27339d9b64f9', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('cca2a8c3-5320-43ef-b8a3-456b8eb51c7c', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 'What unique architectural feature does Godrej Serenity Park boast in the Navi Mumbai skyline?', 'Godrej Serenity Park is designed with 4 towers rising to 20 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('5ae87723-265b-44a7-94e8-4df27e22fa5c', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 'How beneficial is Godrej Serenity Park''s connectivity to the rest of Navi Mumbai?', 'Located in Sanpada, Godrej Serenity Park offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('c28ab85e-ad59-4217-82b5-6237d19c4964', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('9788bb3a-d0ec-4a28-9683-b0e40e2f1664', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 'What unique architectural feature does Lodha Urban Vista boast in the Navi Mumbai skyline?', 'Lodha Urban Vista is designed with 5 towers rising to 21 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('f4ccd1e1-8895-4e79-bc16-83705a74f977', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 'How beneficial is Lodha Urban Vista''s connectivity to the rest of Navi Mumbai?', 'Located in Kharghar, Lodha Urban Vista offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('dc3a0445-77ba-40d2-a6a8-3dfc7206b7b9', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('4fb6dc18-869d-4619-b79c-f7081f504577', '852cb9a1-21fa-482b-b702-99c45c39f992', 'What unique architectural feature does Prestige Palava City boast in the Navi Mumbai skyline?', 'Prestige Palava City is designed with 6 towers rising to 22 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('012ee58d-6ae9-4348-83a7-0e2963ccb819', '852cb9a1-21fa-482b-b702-99c45c39f992', 'How beneficial is Prestige Palava City''s connectivity to the rest of Navi Mumbai?', 'Located in Taloja, Prestige Palava City offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('610166d5-697a-4e55-9bbe-6849ff7afe68', '852cb9a1-21fa-482b-b702-99c45c39f992', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('5952a97f-4074-4716-8e5b-870ac935571d', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 'What unique architectural feature does Sobha Greens Enclave boast in the Navi Mumbai skyline?', 'Sobha Greens Enclave is designed with 7 towers rising to 23 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('ea92e178-5ce7-42f3-9dc7-183c1468d463', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 'How beneficial is Sobha Greens Enclave''s connectivity to the rest of Navi Mumbai?', 'Located in Upper Kharghar, Sobha Greens Enclave offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('26e2a116-b5ee-4e12-ad42-4de02dd4ee2e', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('b22457c2-7470-4fd5-9cb4-b5e8c023b50d', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 'What unique architectural feature does Brigade The Arbour boast in the Navi Mumbai skyline?', 'Brigade The Arbour is designed with 2 towers rising to 24 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('55e1183f-d166-469e-a50d-ffd02224c28c', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 'How beneficial is Brigade The Arbour''s connectivity to the rest of Navi Mumbai?', 'Located in Digha, Brigade The Arbour offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('2d65810c-ab7e-4ba9-91fc-aecd6b910166', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('eb3cb703-394c-4cf9-bc1b-e83e3b514a7b', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 'What unique architectural feature does DLF City Heights boast in the Navi Mumbai skyline?', 'DLF City Heights is designed with 3 towers rising to 25 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('33df4902-a492-4067-8aee-fc18b5dd74fb', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 'How beneficial is DLF City Heights''s connectivity to the rest of Navi Mumbai?', 'Located in Rasayani, DLF City Heights offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('181ff542-0997-47fc-a2c2-678d42da296d', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('2738fce6-54f6-4ab3-8221-4e04bfedee19', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 'What unique architectural feature does Godrej Emerald Bay boast in the Navi Mumbai skyline?', 'Godrej Emerald Bay is designed with 4 towers rising to 26 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('9cacb306-e40f-4a72-9488-dcbbd5312009', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 'How beneficial is Godrej Emerald Bay''s connectivity to the rest of Navi Mumbai?', 'Located in Panvel, Godrej Emerald Bay offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('87c2778a-e6f6-4617-add5-dec3c420cd22', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('39ab72f5-636c-4b7e-8fbd-1886b8a6a0ce', '3c87d633-0068-42c4-8a43-b391183f2fe8', 'What unique architectural feature does Lodha Skyline Residences boast in the Navi Mumbai skyline?', 'Lodha Skyline Residences is designed with 5 towers rising to 27 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('0d26b12e-c032-4042-99a3-584c113a754f', '3c87d633-0068-42c4-8a43-b391183f2fe8', 'How beneficial is Lodha Skyline Residences''s connectivity to the rest of Navi Mumbai?', 'Located in Kalamboli, Lodha Skyline Residences offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('3e967cd7-b7c5-422b-85fa-cd33ae21ab32', '3c87d633-0068-42c4-8a43-b391183f2fe8', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('b007cc2e-4eba-478e-87ee-172ddd663881', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 'What unique architectural feature does Prestige Meadows Phase 2 boast in the Navi Mumbai skyline?', 'Prestige Meadows Phase 2 is designed with 6 towers rising to 28 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('ce4e8bdf-71e5-4039-a276-c3f657cfb0cd', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 'How beneficial is Prestige Meadows Phase 2''s connectivity to the rest of Navi Mumbai?', 'Located in Palaspe, Prestige Meadows Phase 2 offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('08119e55-4bba-42e9-a2ee-cfdcc6b662b2', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('dbc8dc65-3278-450d-8d15-0d0eadca87f9', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 'What unique architectural feature does Sobha Horizon Towers boast in the Navi Mumbai skyline?', 'Sobha Horizon Towers is designed with 7 towers rising to 29 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('abd5df1b-fb90-475d-bc6d-7919e02bdb12', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 'How beneficial is Sobha Horizon Towers''s connectivity to the rest of Navi Mumbai?', 'Located in Shedung, Sobha Horizon Towers offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('b38bda70-65d0-4ca6-a581-b44721c7860a', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);
INSERT INTO public.project_faqs VALUES ('738fee65-88ee-4691-a866-3744ffea5e6e', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 'What unique architectural feature does Brigade Serenity Park boast in the Navi Mumbai skyline?', 'Brigade Serenity Park is designed with 2 towers rising to 30 floors, giving it a distinctive silhouette and panoramic views across Navi Mumbai.', 0);
INSERT INTO public.project_faqs VALUES ('abfb36b1-ec88-48ba-98df-9961e7495fc0', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 'How beneficial is Brigade Serenity Park''s connectivity to the rest of Navi Mumbai?', 'Located in Juinagar, Brigade Serenity Park offers convenient access to key business districts, railway stations, and arterial roads across Navi Mumbai, making everyday commutes easier for residents.', 1);
INSERT INTO public.project_faqs VALUES ('d39f8f86-2cb4-4300-bbf8-48c2a744e52d', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 'What are the key luxury and recreational amenities available to residents?', 'Residents have access to a swimming pool, a fully-equipped gym, a clubhouse, 24/7 security, dedicated parking, power backup, a landscaped garden, a children''s play area, designed for a comfortable, modern lifestyle.', 2);


--
-- Data for Name: project_landmarks; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.project_landmarks VALUES ('fd3d9fad-d0b1-437c-9557-ea760c1a5f9c', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 'school', 'DAV Public School', 25, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('624d2d56-70fd-496a-bf39-c1fe30e1b4b9', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 'school', 'Ryan International School', 5, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c327d71a-5463-4204-89f4-5435e7cb25c9', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 'hospital', 'Fortis Hospital', 18, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e656f576-6339-4f9c-bced-d3361856699f', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 'college_university', 'St. Xavier''s College', 16, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7a2d08e4-d969-445b-a8c9-20f8e78588a3', 'acfc42a9-2060-4408-ac25-16a6a719b844', 'school', 'Vibgyor High School', 19, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('07b1e928-9d7f-4c01-85ff-1a31e3cd6f25', 'acfc42a9-2060-4408-ac25-16a6a719b844', 'school', 'Euro School', 20, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('67e860d0-f3bd-4716-b66e-b873c12e89cf', 'acfc42a9-2060-4408-ac25-16a6a719b844', 'hospital', 'Fortis Hospital', 5, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('aec492c6-8826-4ac0-8d55-998091029295', 'acfc42a9-2060-4408-ac25-16a6a719b844', 'college_university', 'St. Xavier''s College', 19, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('43186f1f-02ad-47e9-a543-bb66201b94ec', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 'school', 'Podar International School', 23, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('dc7e86e4-8ef5-4da6-95c0-268d0f3b5e03', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 'school', 'Vibgyor High School', 24, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('72bdcc4c-3ae0-4343-b73f-5dfb77f6daae', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 'hospital', 'Fortis Hospital', 20, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e5e493f0-3b5b-4408-b000-85dd3573ad4a', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 'college_university', 'Mumbai University Sub-Campus', 21, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('81ad321a-d9a1-4cfc-b000-5d3c1c406f9b', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 'school', 'Vibgyor High School', 25, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d5d49267-c9b0-4c39-97a6-feb57e227bab', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 'school', 'Euro School', 5, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('1fc5319a-5f94-4cda-bd89-084f82b79f33', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 'hospital', 'Apollo Hospital', 9, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e075ec3a-a67b-485a-9af1-da3a6d7d667e', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 'college_university', 'D.Y. Patil University', 8, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('41161b3c-2bbb-4656-b3ef-360797faad31', 'ce867446-632d-463c-9550-ee082072994a', 'school', 'DAV Public School', 6, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d7e3adf3-8ec6-4b2c-8af5-bd30c37b12d5', 'ce867446-632d-463c-9550-ee082072994a', 'school', 'Ryan International School', 7, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('fd3f99cc-c789-413d-9fb6-fcef56cd1f1a', 'ce867446-632d-463c-9550-ee082072994a', 'hospital', 'Apollo Hospital', 14, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b88d1f9d-0fbb-4f30-b8a3-f80b7bf71e3c', 'ce867446-632d-463c-9550-ee082072994a', 'college_university', 'K.J. Somaiya College', 18, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('dd43cbaa-a5ec-4746-a275-96b814bc8e8d', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 'school', 'Ryan International School', 24, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('1f3d4ab9-85ab-48c1-8dff-2ae09fab94c7', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 'school', 'Podar International School', 25, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('aff089b4-0d1f-41d0-a86e-74ab316c7609', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 'hospital', 'Global Hospital', 6, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e924c2b5-4c84-472c-a2d5-1c4126c82028', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 'college_university', 'NMIMS Campus', 6, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c3749cba-a77c-4fd1-ac84-c4ed3b9693ba', '81a105f0-f609-4ae2-8696-b938f99047b7', 'school', 'Vibgyor High School', 13, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b8e2f5df-4d22-47c0-bbdd-62c0e95250ac', '81a105f0-f609-4ae2-8696-b938f99047b7', 'school', 'Euro School', 14, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('331a2e38-d287-4465-8b70-d3ad87ecff72', '81a105f0-f609-4ae2-8696-b938f99047b7', 'hospital', 'Fortis Hospital', 16, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a6c6dd46-089d-4f71-a033-384cf8f958a1', '81a105f0-f609-4ae2-8696-b938f99047b7', 'college_university', 'St. Xavier''s College', 6, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('80eb2ea4-7a02-431a-9582-472ca5dd959c', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 'school', 'Ryan International School', 13, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d13ac717-a743-4694-b637-44358d803df5', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 'school', 'Podar International School', 14, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('35ad6a5a-b70b-4d28-9984-c3604aab7dbc', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 'hospital', 'Wockhardt Hospital', 15, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cfc72e5c-ad58-48bd-9d03-8763dc596506', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 'college_university', 'Mumbai University Sub-Campus', 7, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('68fd7198-d288-4644-9a86-0173d7bfc36b', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 'school', 'Euro School', 13, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('beb2f99a-8ade-4894-980b-dc2ef5f0366d', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 'school', 'DAV Public School', 14, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('23ae4e52-6d48-4fe3-b8c2-8c55516a9483', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 'hospital', 'Fortis Hospital', 18, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8048adc7-7204-4b9c-9626-f85dbac1a875', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 'college_university', 'K.J. Somaiya College', 23, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('88a25b23-f74a-443d-a917-120717972167', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 'school', 'Euro School', 9, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('0b7021aa-b393-40b2-acad-7c996df14b97', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 'school', 'DAV Public School', 10, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('867e1202-5e7a-48bb-b93d-40774dbdaeb9', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 'hospital', 'Fortis Hospital', 13, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('18fbc7bd-bbfa-4f71-b512-4dd5b62325e5', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 'college_university', 'D.Y. Patil University', 13, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4f4beeed-0024-4192-9d26-578e98a609f4', '3f256a22-dbf2-4858-b219-8a887459d13f', 'school', 'Podar International School', 6, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('38adc86d-7749-45cf-ae55-9c3b148ba728', '3f256a22-dbf2-4858-b219-8a887459d13f', 'school', 'Vibgyor High School', 7, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b640c398-31e2-4d4b-b716-06c48190b2a0', '3f256a22-dbf2-4858-b219-8a887459d13f', 'hospital', 'Apollo Hospital', 8, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('05addffa-a864-4dbe-bf87-fa854387387f', '3f256a22-dbf2-4858-b219-8a887459d13f', 'college_university', 'NMIMS Campus', 17, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('73e03f13-de67-4603-9aae-bd140238d1ca', '8943fdc0-0495-452d-a818-a7518c7bacc2', 'school', 'Vibgyor High School', 22, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4b4adb6d-9779-4101-99dc-e20fb7d10431', '8943fdc0-0495-452d-a818-a7518c7bacc2', 'school', 'Euro School', 23, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('58821aca-b228-426b-9198-2989d1218d81', '8943fdc0-0495-452d-a818-a7518c7bacc2', 'hospital', 'Apollo Hospital', 5, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('98ed2d8b-d04e-40bc-8e0c-2503b8a8e887', '8943fdc0-0495-452d-a818-a7518c7bacc2', 'college_university', 'St. Xavier''s College', 10, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8e51a74a-6d6d-497e-a4c8-9e210afdc62c', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 'school', 'Ryan International School', 6, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8d5a5300-86ce-4a1b-8ef5-ed264a13e79f', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 'school', 'Podar International School', 7, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4ac5e53e-f44d-41f5-b563-11556f425c1c', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 'hospital', 'Criticare Hospital', 11, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4433579a-6614-48c6-bd50-f2b5928b3b00', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 'college_university', 'K.J. Somaiya College', 14, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('59c3a753-30ea-4da6-9f20-6adab4a82002', '5dbf5457-69eb-49c3-8298-582f50cdd642', 'school', 'Ryan International School', 19, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cb02248f-09df-4000-9b78-f6136b0dec68', '5dbf5457-69eb-49c3-8298-582f50cdd642', 'school', 'Podar International School', 20, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7e523faa-d27b-4181-9c6e-58ffca20cd3f', '5dbf5457-69eb-49c3-8298-582f50cdd642', 'hospital', 'Criticare Hospital', 18, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('935ffd79-1ce1-452b-8d8e-7d3333feb878', '5dbf5457-69eb-49c3-8298-582f50cdd642', 'college_university', 'D.Y. Patil University', 25, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f2a251da-317f-4219-a39a-808fcb11f872', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 'school', 'DAV Public School', 16, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('bf7337a4-2401-4084-bfa0-9da96bea3b9f', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 'school', 'Ryan International School', 17, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('85f86b97-114b-48a9-a75d-a453940bd457', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 'hospital', 'Global Hospital', 15, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5c868ced-e738-4077-871e-19308e1787f0', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 'college_university', 'Mumbai University Sub-Campus', 23, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('72b61053-c531-4a72-ba88-62e4fcad0fa5', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 'school', 'Vibgyor High School', 16, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cf0bafb0-453c-4cbd-8b41-7d5dd9772ffa', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 'school', 'Euro School', 17, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('58dad474-ddd9-4640-b798-878d16d7ea3f', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 'hospital', 'Apollo Hospital', 15, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ac1a1366-e6bf-47c5-918c-89216e470c3b', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 'college_university', 'NMIMS Campus', 11, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e1db9411-8f4d-4792-bcc7-9771680c4c20', '6291ab92-3882-4932-91c3-ce8a06921842', 'school', 'Vibgyor High School', 18, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7d1b0a4f-f629-4cdd-bbdb-9e8a5619e341', '6291ab92-3882-4932-91c3-ce8a06921842', 'school', 'Euro School', 19, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('85aeb365-100b-459e-8fae-a6097efcd4c1', '6291ab92-3882-4932-91c3-ce8a06921842', 'hospital', 'Fortis Hospital', 6, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('9423c3c0-9f65-412a-bee2-15f854c438c0', '6291ab92-3882-4932-91c3-ce8a06921842', 'college_university', 'NMIMS Campus', 17, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('76f1dffa-4d55-432d-8f02-4de5e7ac1fab', '495847cf-06f6-49bc-8a68-7df5c0504838', 'school', 'Vibgyor High School', 22, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('bc0c78e5-5f25-40a6-a0b4-e34fc85061dd', '495847cf-06f6-49bc-8a68-7df5c0504838', 'school', 'Euro School', 23, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7c079e47-3ca4-41fe-a2f5-993c57a0747c', '495847cf-06f6-49bc-8a68-7df5c0504838', 'hospital', 'Wockhardt Hospital', 8, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3da353f1-0a29-4c10-9b4b-66be426f48dd', '495847cf-06f6-49bc-8a68-7df5c0504838', 'college_university', 'D.Y. Patil University', 25, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6367fe56-2960-4821-a6b6-78319150988a', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 'school', 'Vibgyor High School', 15, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b2fb2b98-f468-4a38-945b-c687e8691241', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 'school', 'Euro School', 16, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b0e71d49-2962-4712-8731-e85705e5bdb6', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 'hospital', 'Global Hospital', 7, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('61df6afe-eb36-4115-870b-efd757a8cd85', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 'college_university', 'NMIMS Campus', 7, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5a31c319-47b6-43eb-86a8-3bda15f753c9', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 'school', 'Euro School', 9, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ef735b91-4d54-49a1-9cc4-9d7a7e598551', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 'school', 'DAV Public School', 10, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4aa67543-2daa-4d80-947d-a5299d420aed', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 'hospital', 'Fortis Hospital', 5, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('44d4f35c-aad3-4a0d-8474-acc5f61571a1', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 'college_university', 'St. Xavier''s College', 18, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d7db6bc8-83f5-49be-a0e1-1b5cf3502bf2', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 'school', 'Euro School', 24, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('87663aae-5fd2-4186-a2aa-ad5aef523278', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 'school', 'DAV Public School', 25, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6b9353a7-fd39-43de-abed-3c31e36b1b5d', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 'hospital', 'Fortis Hospital', 19, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c63150d1-b709-470e-aabf-6996722a090a', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 'college_university', 'K.J. Somaiya College', 10, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('01a9b88a-d974-48a0-a22a-54502e1b8c64', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 'school', 'Podar International School', 15, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a08d5356-14ae-4f88-9d79-45999e8c8d09', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 'school', 'Vibgyor High School', 16, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5f178788-3282-48e5-8546-3dd3a3ad1529', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 'hospital', 'Wockhardt Hospital', 24, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6c5988b3-4630-40df-860f-e0e99310c0fc', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 'college_university', 'NMIMS Campus', 24, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f4630231-2a2e-492b-9ddd-a7a60a4151e2', '0f36f844-1667-4355-bd12-a2d530396858', 'school', 'Podar International School', 19, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c757364f-2a2f-4be1-9617-e31dbcddc50c', '0f36f844-1667-4355-bd12-a2d530396858', 'school', 'Vibgyor High School', 20, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('20ce89da-c207-4082-8852-f9e27cf5f1ab', '0f36f844-1667-4355-bd12-a2d530396858', 'hospital', 'Fortis Hospital', 5, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a2cc31de-82c8-4a82-9091-a1aeb657c6ac', '0f36f844-1667-4355-bd12-a2d530396858', 'college_university', 'Mumbai University Sub-Campus', 25, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ff6d7c6c-5274-4668-aea2-97adbae72b23', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 'school', 'Ryan International School', 7, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('05058d38-98ee-4ec4-abef-c0d0baed6997', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 'school', 'Podar International School', 8, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('effc6bf8-c2e7-4078-84f7-7edc88a8b151', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 'hospital', 'Fortis Hospital', 23, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e26bf2cc-cff1-48bf-9aae-89715aab65e6', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 'college_university', 'NMIMS Campus', 19, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a3aa9d1e-feaa-4730-832f-1af37aa25f9d', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 'school', 'Vibgyor High School', 11, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ea87d2db-6537-4bf2-8ead-543833a4aeff', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 'school', 'Euro School', 12, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d3a1d5b6-c7a8-40b7-af10-580e6b2add73', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 'hospital', 'Criticare Hospital', 19, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('21ddf940-26bf-495a-89fd-838c091f1688', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 'college_university', 'K.J. Somaiya College', 11, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4937d16f-cabc-45e9-aec6-8fc34fd897ad', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 'school', 'DAV Public School', 22, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3e31a549-24c9-4c2c-a0f3-6aa76e355adb', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 'school', 'Ryan International School', 23, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('eefd6d30-51ae-46f2-8ff4-83fd4ec13c19', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 'hospital', 'Criticare Hospital', 16, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('737ad009-d78c-448d-bc40-b749e7add0fa', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 'college_university', 'St. Xavier''s College', 12, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a7e35eff-dc77-4907-805a-273fde6353a9', 'b51e5f2e-9914-43d6-8388-65054f711f30', 'school', 'Ryan International School', 14, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3bb81559-0b94-4a5c-8c6a-c16903e3402e', 'b51e5f2e-9914-43d6-8388-65054f711f30', 'school', 'Podar International School', 15, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b3a0c012-2759-4531-a6e5-6873dc077fa1', 'b51e5f2e-9914-43d6-8388-65054f711f30', 'hospital', 'Apollo Hospital', 23, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b03640d2-9724-4b6a-99ef-cd05d7bea94a', 'b51e5f2e-9914-43d6-8388-65054f711f30', 'college_university', 'St. Xavier''s College', 18, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('99d9fc9e-a8c9-4542-bd01-077c59489092', '3888eca5-9184-4a80-917b-a64b68849477', 'school', 'Podar International School', 19, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c6f8ad56-5999-4d25-8831-03c6505ef15b', '3888eca5-9184-4a80-917b-a64b68849477', 'school', 'Vibgyor High School', 20, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b679c2e4-39ef-4f00-b9d4-c724f247cd9c', '3888eca5-9184-4a80-917b-a64b68849477', 'hospital', 'Fortis Hospital', 7, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('89c1d92e-08a1-4cdb-a431-3d260235cc44', '3888eca5-9184-4a80-917b-a64b68849477', 'college_university', 'NMIMS Campus', 19, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('fe510580-4447-4ff5-8229-c1424c437ba7', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 'school', 'Vibgyor High School', 10, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b800aa29-0708-4216-8a9d-a40d7a7179ed', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 'school', 'Euro School', 11, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('099946ec-cc26-49b0-883e-4bdc32fb7380', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 'hospital', 'Apollo Hospital', 15, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5d17a02c-2831-491d-a329-fe086ed9d6c8', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 'college_university', 'K.J. Somaiya College', 18, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('288522b1-8cc0-454c-a1fa-67902fc9e892', '7650bd3b-845f-4ca5-938d-d1e233240b61', 'school', 'Euro School', 16, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('95a06010-b071-464d-bb6b-33fb86fa6cf0', '7650bd3b-845f-4ca5-938d-d1e233240b61', 'school', 'DAV Public School', 17, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3b242ddc-5889-4736-a9b8-c8307505e48c', '7650bd3b-845f-4ca5-938d-d1e233240b61', 'hospital', 'Criticare Hospital', 17, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8bc0d256-c388-4b25-adac-76c48a548387', '7650bd3b-845f-4ca5-938d-d1e233240b61', 'college_university', 'Mumbai University Sub-Campus', 12, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8a7c7d97-72ee-4f9a-91fd-540daf3b5653', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 'school', 'Podar International School', 20, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('66ca00f5-c28d-4298-9aca-65a1810985da', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 'school', 'Vibgyor High School', 21, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('153f641e-4e4d-4905-a172-39a6b851f235', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 'hospital', 'Wockhardt Hospital', 14, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('897d5317-dd2d-418d-9579-7d6f1eb1aa26', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 'college_university', 'D.Y. Patil University', 5, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('bbc1261d-e87e-480c-b05d-75f8b92537de', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 'school', 'Vibgyor High School', 23, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('dfe07f96-2999-4e7b-bb94-db9876e53a7b', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 'school', 'Euro School', 24, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4cdf145c-18f1-4051-bd33-040d999ac864', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 'hospital', 'Apollo Hospital', 17, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('68c876c3-a0d3-496a-8966-4b0c69284a76', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 'college_university', 'K.J. Somaiya College', 14, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ed752d47-468c-4a15-a0d0-b5650a41aed3', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 'school', 'Vibgyor High School', 15, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('698fac97-48d5-47ff-86e2-6884921763ee', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 'school', 'Euro School', 16, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5dff7cf7-3374-42a0-b6d9-f66453d4bc23', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 'hospital', 'Apollo Hospital', 14, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('49b61b14-d28e-4fcb-9807-7f4fd8ca4453', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 'college_university', 'NMIMS Campus', 9, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('384b5188-9855-44f5-b0bd-a4cd75ada492', '238f874e-fa56-4761-bf3a-7ee59df55416', 'school', 'Podar International School', 14, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cf73d304-5039-45cc-b66c-cf588092dbc0', '238f874e-fa56-4761-bf3a-7ee59df55416', 'school', 'Vibgyor High School', 15, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('70f66003-7616-4610-bed3-3126989d1e83', '238f874e-fa56-4761-bf3a-7ee59df55416', 'hospital', 'Apollo Hospital', 11, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5802883f-20cf-413b-8377-d19585ddb706', '238f874e-fa56-4761-bf3a-7ee59df55416', 'college_university', 'NMIMS Campus', 8, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('74320a52-22b4-41e7-b249-24c690f79f11', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 'school', 'Vibgyor High School', 12, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('807dad1a-13f1-415b-87bc-a9cfb33ba3b1', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 'school', 'Euro School', 13, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('81e4a0f9-5a9c-4621-a128-64a2b4ce562a', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 'hospital', 'Criticare Hospital', 24, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5fd31043-02ef-4867-a851-dae44e7f82f4', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 'college_university', 'Mumbai University Sub-Campus', 15, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e862fcec-80d2-42a6-8547-e88d8747754a', 'c04c6e65-f054-4267-a246-b3cca1efac98', 'school', 'Euro School', 16, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('12374bd0-18b4-4889-9aa1-9c235ffbfcff', 'c04c6e65-f054-4267-a246-b3cca1efac98', 'school', 'DAV Public School', 17, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a5586ef5-2011-48a6-a0b0-06503edf3d8a', 'c04c6e65-f054-4267-a246-b3cca1efac98', 'hospital', 'Apollo Hospital', 17, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e0e1f72e-14e8-4447-bbe4-b4465ae61b06', 'c04c6e65-f054-4267-a246-b3cca1efac98', 'college_university', 'NMIMS Campus', 7, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('009ee7c4-d2af-4248-9b83-4a53faec824d', '1636441c-a228-4fcc-99f4-1f86d90db245', 'school', 'Ryan International School', 6, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5091d655-d1c3-4991-9442-3d33b2b34c4b', '1636441c-a228-4fcc-99f4-1f86d90db245', 'school', 'Podar International School', 7, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5e0100f6-531f-458a-bafd-d13a412a3416', '1636441c-a228-4fcc-99f4-1f86d90db245', 'hospital', 'Apollo Hospital', 19, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e144e5e2-8cb6-44a1-b318-407961bc0524', '1636441c-a228-4fcc-99f4-1f86d90db245', 'college_university', 'K.J. Somaiya College', 23, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('92e7efe3-dd35-40cb-96dc-fa9f55720b99', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 'school', 'Euro School', 15, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3d360a78-4466-46bd-aece-c1f31f130bae', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 'school', 'DAV Public School', 16, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('26ea1801-a8f3-491e-8a9c-e48c030cae4a', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 'hospital', 'Fortis Hospital', 12, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('85cbadf4-df6c-491c-b0d2-d1ca4c6704bb', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 'college_university', 'St. Xavier''s College', 14, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ff1e8aec-a30c-4868-b9b8-af4b99760942', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 'school', 'Podar International School', 22, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('014a60ea-9843-4552-9d38-bf0649284538', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 'school', 'Vibgyor High School', 23, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('15f41352-31b1-4a93-8744-53adc846d2e2', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 'hospital', 'Fortis Hospital', 5, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('1fafb8ad-0c3c-439b-828f-fba10c3e3d85', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 'college_university', 'Mumbai University Sub-Campus', 7, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('356f7eb7-aa54-4158-bcd3-0765fac6f935', '62d91186-46da-4bb7-bacc-fd182c860357', 'school', 'Ryan International School', 18, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a6da1dbf-3a4a-4a21-96f0-138b6f93ec53', '62d91186-46da-4bb7-bacc-fd182c860357', 'school', 'Podar International School', 19, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('752653c2-9532-4041-8a0c-d2c96ad75b6b', '62d91186-46da-4bb7-bacc-fd182c860357', 'hospital', 'Wockhardt Hospital', 13, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('27a100ce-57f1-4d01-bcff-e104ce931519', '62d91186-46da-4bb7-bacc-fd182c860357', 'college_university', 'St. Xavier''s College', 21, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('66262372-574e-47e8-b7a0-86744dab8259', 'aaf948fe-4305-4ac2-9b43-97078e915814', 'school', 'Podar International School', 10, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e19704ea-eb87-4e3b-be3c-7d9aaa49d23b', 'aaf948fe-4305-4ac2-9b43-97078e915814', 'school', 'Vibgyor High School', 11, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4297dd5a-1da4-43de-9e9c-e14170147a22', 'aaf948fe-4305-4ac2-9b43-97078e915814', 'hospital', 'Criticare Hospital', 16, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('06dc7bde-e837-4f5f-b165-5a0de3898c58', 'aaf948fe-4305-4ac2-9b43-97078e915814', 'college_university', 'St. Xavier''s College', 10, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6e6c249f-556d-40aa-ac98-0a848749dcce', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 'school', 'Euro School', 8, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('075ce7e4-8260-40e3-a836-a729f0eeaa58', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 'school', 'DAV Public School', 9, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e5207586-36c4-441a-b457-8dc45389b677', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 'hospital', 'Global Hospital', 13, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('87949b79-0d41-4a8b-a0a4-a1e39853e530', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 'college_university', 'St. Xavier''s College', 21, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4d9215b8-be5f-4a01-b555-adddde15b66e', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 'school', 'Vibgyor High School', 11, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('2f4ae437-86d5-48ec-bdc3-7a8b9b82b320', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 'school', 'Euro School', 12, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b6a27c62-4fa1-4e3a-bf84-0d0e707f4669', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 'hospital', 'Wockhardt Hospital', 5, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e1aef391-5f74-4561-b785-c0c7c3470c2f', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 'college_university', 'St. Xavier''s College', 6, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8d760974-0d13-4f5a-9b06-bb395b7a1bab', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 'school', 'DAV Public School', 11, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6891cf9d-6590-4120-ae35-d1e65c1cfbba', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 'school', 'Ryan International School', 12, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('0ad25526-ebd9-4513-8464-e0fb817cd71a', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 'hospital', 'Fortis Hospital', 7, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('da7b0e26-eec6-423f-98d4-e4cbff3db8ff', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 'college_university', 'D.Y. Patil University', 16, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5685b305-22c6-4860-84f7-fdb69affa1dc', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 'school', 'DAV Public School', 13, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('fd64bc45-e52b-4a8f-a128-ebcae03d976a', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 'school', 'Ryan International School', 14, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('be7c51ff-e148-4988-86a6-18fb85388441', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 'hospital', 'Criticare Hospital', 24, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('316646ad-de7a-45e0-914c-ece310e1606e', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 'college_university', 'NMIMS Campus', 16, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('15514645-b3b9-44a6-8320-52f6fd00a2f5', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 'school', 'Ryan International School', 15, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f837afbf-7eaf-4686-91f7-00f620d2d5b7', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 'school', 'Podar International School', 16, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f7996786-f2f6-48a7-a1f2-418300646092', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 'hospital', 'Global Hospital', 15, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f3ca267d-4162-4f51-976d-823dcc405fe7', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 'college_university', 'D.Y. Patil University', 6, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('76450903-09d4-4d9d-8d08-9b7e5dd98267', '36504c39-4314-4f21-b4d7-936d85d35aaa', 'school', 'Podar International School', 25, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6c08514c-2651-41de-b195-08acd0e35437', '36504c39-4314-4f21-b4d7-936d85d35aaa', 'school', 'Vibgyor High School', 5, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c247fbda-45de-47ab-9ac5-ee6ffd500ec0', '36504c39-4314-4f21-b4d7-936d85d35aaa', 'hospital', 'Fortis Hospital', 6, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('305f24d6-7ca6-44a6-9444-e8609a2c746d', '36504c39-4314-4f21-b4d7-936d85d35aaa', 'college_university', 'NMIMS Campus', 21, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('69305e8f-eeec-4471-864b-2c2daff56808', '7d6d013f-d5a4-4efe-bb88-c16401163509', 'school', 'DAV Public School', 15, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('35f988d7-2783-459a-896d-8f932944e404', '7d6d013f-d5a4-4efe-bb88-c16401163509', 'school', 'Ryan International School', 16, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('90bf1c2e-8b19-4b62-97d6-3dd2c2a1e436', '7d6d013f-d5a4-4efe-bb88-c16401163509', 'hospital', 'Criticare Hospital', 20, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a70bad4e-025b-40a2-86d2-2f19d4089668', '7d6d013f-d5a4-4efe-bb88-c16401163509', 'college_university', 'NMIMS Campus', 15, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8db6eaa1-41c0-4139-8349-e275ab76d8f5', '93b30971-37da-4bd2-9335-dd7191ff38d4', 'school', 'Euro School', 6, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('41a29c1d-ea7a-4a43-902e-f8f40e77bcb5', '93b30971-37da-4bd2-9335-dd7191ff38d4', 'school', 'DAV Public School', 7, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('bb5eee21-962c-41a5-bb40-8a4da0f54f0f', '93b30971-37da-4bd2-9335-dd7191ff38d4', 'hospital', 'Criticare Hospital', 12, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('06f8b760-4ba4-4dee-971d-ec4925b36189', '93b30971-37da-4bd2-9335-dd7191ff38d4', 'college_university', 'K.J. Somaiya College', 15, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('0181bf26-2780-4886-9c11-6f32ff8be857', 'af03d123-d596-452c-a94b-66254df1f732', 'school', 'Euro School', 22, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('0d301767-4d49-4139-9d92-6b7b55feccd9', 'af03d123-d596-452c-a94b-66254df1f732', 'school', 'DAV Public School', 23, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('2a7fc5f8-888f-4cfe-8122-2a920015fa82', 'af03d123-d596-452c-a94b-66254df1f732', 'hospital', 'Criticare Hospital', 15, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cd5c17c4-cfe3-4d51-98c1-4d8a4879b95a', 'af03d123-d596-452c-a94b-66254df1f732', 'college_university', 'Mumbai University Sub-Campus', 11, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('fb7c4f0f-d13f-46d9-b971-ddee29e81c83', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 'school', 'Podar International School', 16, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c25616da-0920-4f3b-b1be-a4b0516e8a19', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 'school', 'Vibgyor High School', 17, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6a3cc7d5-f3a8-46b9-8e99-f04aa81204fd', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 'hospital', 'Criticare Hospital', 18, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b2ed4440-dcea-4937-b80e-bcb22dd0f37d', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 'college_university', 'St. Xavier''s College', 12, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('bf000ea2-9f8f-4f1c-90a7-3a5d6fe92b2e', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 'school', 'Ryan International School', 11, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f02a6a21-05b7-4c3c-bbfa-97e28ccbe48a', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 'school', 'Podar International School', 12, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4c247569-3048-4228-96ee-2f2648c5093b', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 'hospital', 'Apollo Hospital', 13, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e4a3652c-1c3e-419f-ae44-dc0130858c2b', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 'college_university', 'D.Y. Patil University', 16, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6de4e95b-a105-44a3-896c-e5167b7e63f8', '5825f125-7948-495d-80a1-b25e3721d8ca', 'school', 'Euro School', 20, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('bc0c6782-d5d0-46a4-80c3-92df6c08d580', '5825f125-7948-495d-80a1-b25e3721d8ca', 'school', 'DAV Public School', 21, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('52bdb0bb-f3e4-4fa9-be9c-299531b774ea', '5825f125-7948-495d-80a1-b25e3721d8ca', 'hospital', 'Global Hospital', 6, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8ed4ea1c-c924-464c-b703-7c2e7b05f0f7', '5825f125-7948-495d-80a1-b25e3721d8ca', 'college_university', 'NMIMS Campus', 10, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7361798b-af9a-4083-8ff1-e961ae480119', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 'school', 'Euro School', 25, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ed17f386-fb92-4758-81e8-14a844efa9d0', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 'school', 'DAV Public School', 5, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6d382ac7-9730-4f99-b932-efc8824a6d2e', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 'hospital', 'Criticare Hospital', 6, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('386a28cb-18f6-4207-88e3-30fde4d61c4c', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 'college_university', 'D.Y. Patil University', 10, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('08e7c858-108d-47e3-859a-1bbae958d0f8', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 'school', 'Ryan International School', 23, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('97c2bab6-a81f-4855-9c50-e72492621ad5', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 'school', 'Podar International School', 24, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cd111484-b547-4e66-8c04-e17d598c0add', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 'hospital', 'Apollo Hospital', 25, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('17e441fb-3e96-41af-b9c9-524dbf30dc78', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 'college_university', 'NMIMS Campus', 22, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('697da3e9-f64f-4bd3-889a-5547ef53ed0e', '94a54418-365a-4cec-80d8-180f774fa135', 'school', 'DAV Public School', 25, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ca388e57-77ac-4d1a-ab7e-c83bc1d6302d', '94a54418-365a-4cec-80d8-180f774fa135', 'school', 'Ryan International School', 5, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('89fa1810-2f25-4d49-9c7b-40f25705ec7d', '94a54418-365a-4cec-80d8-180f774fa135', 'hospital', 'Fortis Hospital', 7, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('bd35ddf4-673a-47a1-b32a-f337e5f5c55f', '94a54418-365a-4cec-80d8-180f774fa135', 'college_university', 'St. Xavier''s College', 21, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a43a2d59-dd5d-4e27-a886-4901d1aebc52', '02266bb6-c3e8-4667-a465-34a7463f6216', 'school', 'Podar International School', 17, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('720dacfe-73ff-49d0-8e80-d8ae2149c61d', '02266bb6-c3e8-4667-a465-34a7463f6216', 'school', 'Vibgyor High School', 18, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('fea4c09d-f468-416c-93e7-02bad06eda65', '02266bb6-c3e8-4667-a465-34a7463f6216', 'hospital', 'Global Hospital', 12, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('add8886b-e6a1-46ab-a0f6-41874b216b38', '02266bb6-c3e8-4667-a465-34a7463f6216', 'college_university', 'D.Y. Patil University', 24, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('87366826-4f4a-4f93-a885-493c84dd8eb6', 'a91fff91-304b-4029-b1b3-796f03432262', 'school', 'Ryan International School', 24, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('90024079-89b6-48b6-ba4a-212955ca0e4e', 'a91fff91-304b-4029-b1b3-796f03432262', 'school', 'Podar International School', 25, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('1a019f5a-6946-4921-b9e2-12314e0021a7', 'a91fff91-304b-4029-b1b3-796f03432262', 'hospital', 'Criticare Hospital', 25, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e47d050e-d8cf-4432-9e58-c2e3dbf9d594', 'a91fff91-304b-4029-b1b3-796f03432262', 'college_university', 'K.J. Somaiya College', 20, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('2f2dd1de-443c-4522-a17a-ee863c1a0309', '918731c6-604e-4795-9dd4-65bb2b0ff316', 'school', 'Vibgyor High School', 13, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6fbcb67c-346a-4c77-bbbe-035d1244b3f3', '918731c6-604e-4795-9dd4-65bb2b0ff316', 'school', 'Euro School', 14, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('92408e11-33b8-4520-9e72-1353383d4195', '918731c6-604e-4795-9dd4-65bb2b0ff316', 'hospital', 'Wockhardt Hospital', 6, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('9c2b7e9f-00ed-4e30-aea5-a51e662878c1', '918731c6-604e-4795-9dd4-65bb2b0ff316', 'college_university', 'NMIMS Campus', 25, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7a9e0f52-bf47-4d71-9aa5-875ace8c43e2', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 'school', 'DAV Public School', 14, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d9f90532-c407-4026-99ee-9bd52a9cbb02', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 'school', 'Ryan International School', 15, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ef476b59-ad81-4aee-9e7b-a9b3a7359c0a', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 'hospital', 'Criticare Hospital', 8, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('15be31b5-0f0e-4ffc-8156-03e04c6c88ac', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 'college_university', 'D.Y. Patil University', 13, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('19e7f7f0-ad0e-4672-bcce-58677086cb5d', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 'school', 'Podar International School', 24, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('227fe9c0-c34d-430c-8be3-2d8eae0f7ca7', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 'school', 'Vibgyor High School', 25, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('54c25a28-1bdf-440c-b107-5bd79e4c5f32', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 'hospital', 'Fortis Hospital', 11, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3b992ce7-b9db-4a60-abde-2442888f5327', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 'college_university', 'Mumbai University Sub-Campus', 9, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c7bdd685-e735-4d39-b47c-f09c190902f8', 'e29504df-f994-4081-ab30-8880cb31295c', 'school', 'Podar International School', 10, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('1a9be910-c41f-491a-817c-107f287a2dae', 'e29504df-f994-4081-ab30-8880cb31295c', 'school', 'Vibgyor High School', 11, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('72b193ab-6f01-4871-a1d2-4d301021f138', 'e29504df-f994-4081-ab30-8880cb31295c', 'hospital', 'Apollo Hospital', 11, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ee5b01b5-864a-4b5a-b4e1-e15b8ee99eb7', 'e29504df-f994-4081-ab30-8880cb31295c', 'college_university', 'Mumbai University Sub-Campus', 12, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('766fdec9-3f86-4d1e-a372-f7e917e20082', '8549718e-a328-4d01-8daf-b658a61e80af', 'school', 'Podar International School', 14, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('0204c199-3765-4ff5-aa55-fca73423ed38', '8549718e-a328-4d01-8daf-b658a61e80af', 'school', 'Vibgyor High School', 15, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('18c1006c-c55a-45b8-969b-5a24e1e632f7', '8549718e-a328-4d01-8daf-b658a61e80af', 'hospital', 'Apollo Hospital', 5, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ea1315e3-feb3-4976-927a-5ac34014193c', '8549718e-a328-4d01-8daf-b658a61e80af', 'college_university', 'D.Y. Patil University', 24, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('9f664aac-7ebe-4669-814b-f24748444e17', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 'school', 'Ryan International School', 18, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('74213319-3daf-47a0-8bd3-607f229cc949', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 'school', 'Podar International School', 19, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c173fc91-b4e3-4c55-a008-01ea9d7d7cb0', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 'hospital', 'Global Hospital', 25, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('23603ea9-7e15-45bf-a64c-9b5e077c4728', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 'college_university', 'NMIMS Campus', 22, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('adf0b3ca-ff84-42c3-99df-55345c355caf', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 'school', 'Ryan International School', 19, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('43c83b00-2511-42da-95a0-8bbe0178ce31', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 'school', 'Podar International School', 20, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4a315be3-5ad8-4571-966d-137f5fe7cfe1', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 'hospital', 'Fortis Hospital', 25, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e519b6f9-c84d-4e9f-9056-091a45a7e372', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 'college_university', 'K.J. Somaiya College', 16, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cb6f25a4-37c5-499d-9015-b58508e97a96', '9a630559-9351-43d0-a3af-ae555b62688b', 'school', 'DAV Public School', 16, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ed18270c-2e9d-4bd8-b5e7-0804b53ed009', '9a630559-9351-43d0-a3af-ae555b62688b', 'school', 'Ryan International School', 17, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c9070490-bb01-4750-9c9e-4f70e1ff1f2f', '9a630559-9351-43d0-a3af-ae555b62688b', 'hospital', 'Criticare Hospital', 17, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b5ed1fd7-8f07-4085-b239-d04d57aab021', '9a630559-9351-43d0-a3af-ae555b62688b', 'college_university', 'NMIMS Campus', 6, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c860d47e-280e-4633-8b7b-77574227edcb', '6f1cce3d-300c-4a05-b009-603767907351', 'school', 'Vibgyor High School', 23, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f2f9be96-5e2a-4af7-9853-b05e8a7a2234', '6f1cce3d-300c-4a05-b009-603767907351', 'school', 'Euro School', 24, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('1f63d364-f1f1-431b-b8a7-1787c99cd86d', '6f1cce3d-300c-4a05-b009-603767907351', 'hospital', 'Wockhardt Hospital', 6, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('66960108-5631-4bc0-a948-559eb12f5d2b', '6f1cce3d-300c-4a05-b009-603767907351', 'college_university', 'D.Y. Patil University', 25, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('9a6422bb-5aec-4174-8bb7-e1894657ad6a', '65241983-adad-4ac9-a586-27339d9b64f9', 'school', 'DAV Public School', 20, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ccdb95e5-6f47-411e-82da-f688a5776348', '65241983-adad-4ac9-a586-27339d9b64f9', 'school', 'Ryan International School', 21, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('0f02ef88-f8c5-49a4-8543-a9842db042e5', '65241983-adad-4ac9-a586-27339d9b64f9', 'hospital', 'Criticare Hospital', 5, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ed29a118-a773-48b0-93df-5761c9abd6d1', '65241983-adad-4ac9-a586-27339d9b64f9', 'college_university', 'NMIMS Campus', 9, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('40bd00cd-3f19-4995-8b79-651f8366f3e4', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 'school', 'Euro School', 25, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('94c6579f-690c-4913-8425-24794bb15deb', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 'school', 'DAV Public School', 5, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('debf6235-ae5b-4f33-b0dd-b1ab0cfeb18d', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 'hospital', 'Global Hospital', 18, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('44f31e89-3876-4765-989a-e75c500741c5', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 'college_university', 'K.J. Somaiya College', 6, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6212b185-6db3-4521-9359-464874893771', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 'school', 'Ryan International School', 21, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('095c2aea-44fa-4a83-8ea2-74cbba15eb3c', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 'school', 'Podar International School', 22, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f965cffd-d80a-4530-9bd7-9cd45f8a1c47', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 'hospital', 'Global Hospital', 25, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cd639b22-9484-49c0-b72d-2c9fddc5d1fb', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 'college_university', 'D.Y. Patil University', 15, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('58728d3d-5529-4ec9-8fdf-7cd7f8a6129a', '852cb9a1-21fa-482b-b702-99c45c39f992', 'school', 'DAV Public School', 21, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('374586af-4614-4284-adfd-9c82df7f0b6f', '852cb9a1-21fa-482b-b702-99c45c39f992', 'school', 'Ryan International School', 22, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c5968f5a-b6a0-4068-943a-017e84d8f23d', '852cb9a1-21fa-482b-b702-99c45c39f992', 'hospital', 'Wockhardt Hospital', 23, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('761fa99b-65c3-4a1b-a958-5130b6d302f9', '852cb9a1-21fa-482b-b702-99c45c39f992', 'college_university', 'NMIMS Campus', 13, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('38ae795c-2730-459f-8fe3-c13f956a067f', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 'school', 'Vibgyor High School', 21, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7fa628a8-703d-4b38-9a38-52207001c627', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 'school', 'Euro School', 22, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f3c11d96-918f-4da0-8700-c13201a6a217', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 'hospital', 'Fortis Hospital', 16, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5ada35d1-823b-4246-bc54-282409200111', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 'college_university', 'D.Y. Patil University', 8, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('9ab33dd6-e6b3-40dc-99c3-6236c07be698', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 'school', 'Vibgyor High School', 23, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6670a32d-3094-4092-903c-231f304b3f02', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 'school', 'Euro School', 24, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d2037f1c-c658-42fa-9243-de7d6fcf29c5', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 'hospital', 'Fortis Hospital', 7, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('74605065-a570-4e7b-8c70-a8c3d6149c3e', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 'college_university', 'St. Xavier''s College', 16, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4d36a4fc-fc64-4090-ab14-e8c1414336be', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 'school', 'Ryan International School', 15, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('eccf62c1-28a4-4d25-ae4a-44e877b0f9f2', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 'school', 'Podar International School', 16, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('fdc48cbb-6092-4f25-aa99-67eeb717f15d', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 'hospital', 'Apollo Hospital', 19, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d452afe6-8fa8-4e29-b679-bfde38d58b07', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 'college_university', 'Mumbai University Sub-Campus', 14, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3b20191a-4f7d-4248-bd11-edcde8b4e98b', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 'school', 'DAV Public School', 9, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6dfe717e-210e-4bd5-b266-6a40d9705422', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 'school', 'Ryan International School', 10, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('9c4e2e03-c556-45ee-a1a3-25324b4d2162', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 'hospital', 'Wockhardt Hospital', 12, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('541d7911-70d1-4ddf-94ba-501450861cb0', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 'college_university', 'NMIMS Campus', 12, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e1d6f2b7-488e-4ebf-9378-7e96ae26bf82', '3c87d633-0068-42c4-8a43-b391183f2fe8', 'school', 'Vibgyor High School', 23, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('822ac006-2a64-4f1d-b284-7b348aad5f36', '3c87d633-0068-42c4-8a43-b391183f2fe8', 'school', 'Euro School', 24, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('26365de3-1462-4dc0-a18d-9f087d6e0eca', '3c87d633-0068-42c4-8a43-b391183f2fe8', 'hospital', 'Criticare Hospital', 20, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('999cea5f-c8d9-4695-af8d-cfc2e1a99465', '3c87d633-0068-42c4-8a43-b391183f2fe8', 'college_university', 'K.J. Somaiya College', 12, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c4576b50-0239-40f3-a240-b992cb9c40f8', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 'school', 'Ryan International School', 13, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('0a2e8b39-b3b2-4cd5-9088-c3e29c849357', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 'school', 'Podar International School', 14, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d35a0ad6-fa48-4471-bd4f-f05cb309e02f', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 'hospital', 'Criticare Hospital', 19, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a03915aa-71c7-42b8-a9bb-64babc9e5292', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 'college_university', 'K.J. Somaiya College', 21, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f7bd0f0a-ca39-466e-8ad4-d7e141b33d2f', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 'school', 'DAV Public School', 19, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('973181c1-a597-47b4-93d7-f446620d2441', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 'school', 'Ryan International School', 20, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('95b5a265-46a1-4883-83e8-883ccb5090be', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 'hospital', 'Apollo Hospital', 16, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c83eec7b-d5c7-4dbe-bdde-2302e50ec675', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 'college_university', 'K.J. Somaiya College', 14, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3a1e528c-8a89-48dd-9134-b6f7935feceb', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 'school', 'Euro School', 14, 0, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6225835f-9ab4-46d7-b657-ed0d11832c83', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 'school', 'DAV Public School', 15, 1, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('81409a19-7547-473a-b9c6-f7fc02446bef', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 'hospital', 'Criticare Hospital', 22, 2, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8e9a3dc1-5d0f-4a4e-9c4c-6ef6b804b6be', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 'college_university', 'Mumbai University Sub-Campus', 24, 4, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d67b83e2-febf-4aaa-8444-2c04abf87316', 'c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 'hospital', 'City Centre Mall', 7, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c16e94df-f54e-4662-bb43-d262578f1295', 'acfc42a9-2060-4408-ac25-16a6a719b844', 'hospital', 'City Centre Mall', 15, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c38f2c42-e4fd-445c-995c-ce6f52b4e603', 'f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 'hospital', 'Inorbit Mall', 13, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cfcb9ce1-92ca-4868-aebe-4ac8398a29c8', '30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 'hospital', 'Central Plaza', 19, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('5ae44dea-d299-4f1d-a27d-afbfdc54220d', 'ce867446-632d-463c-9550-ee082072994a', 'hospital', 'Central Plaza', 24, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8a10ea9f-7fed-45f2-9a7d-60d2fd33848f', '765af9dd-61f8-4c7a-80e8-7974f7b83136', 'hospital', 'R Mall', 16, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c97c7f5a-6fc5-49e3-9a34-3ea78f4b90d9', '81a105f0-f609-4ae2-8696-b938f99047b7', 'hospital', 'City Centre Mall', 5, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('2cb0906d-bd32-4294-ac86-708a0b727548', '245e2436-81f5-49c6-aa0b-c5717f67c9ae', 'hospital', 'Metro Junction Mall', 25, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('244b12c6-8aa4-4a33-9bc5-65d0d8e87163', '56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 'hospital', 'City Centre Mall', 7, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f17d0757-d577-47bc-b679-f73438ae9558', 'ea489613-9992-4f49-bca0-ea5e3c92ab40', 'hospital', 'City Centre Mall', 23, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('895b5823-46a5-4743-a351-8a9c6e74c25c', '3f256a22-dbf2-4858-b219-8a887459d13f', 'hospital', 'Central Plaza', 18, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cb8015bc-9346-4c90-86ef-c56d48f6bfef', '8943fdc0-0495-452d-a818-a7518c7bacc2', 'hospital', 'Central Plaza', 15, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('fdb31722-3b69-4186-ba0e-cc43cad5a42f', 'e29d2c6e-8808-4863-bdff-533fe8f0d78f', 'hospital', 'Inorbit Mall', 21, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7908f1f4-82dd-43ef-b42d-ca198e0eb17e', '5dbf5457-69eb-49c3-8298-582f50cdd642', 'hospital', 'Inorbit Mall', 7, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e8e7346a-d7e3-45ce-98dd-6001cafb2093', '5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 'hospital', 'R Mall', 25, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7e090415-8c2a-4595-88ed-10969065bc6b', 'd3bec0d8-acde-4f1e-8e04-f31a3b007c30', 'hospital', 'Central Plaza', 25, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b4df8842-cac9-4c74-aa0f-6eaaa8091c41', '6291ab92-3882-4932-91c3-ce8a06921842', 'hospital', 'City Centre Mall', 16, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('90c06568-3170-44f4-8f53-66364133652b', '495847cf-06f6-49bc-8a68-7df5c0504838', 'hospital', 'Metro Junction Mall', 18, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('4c911dd3-1e47-4beb-9d42-77dcd8507916', '2097ba54-f560-4cfd-84d0-4a9e90574e51', 'hospital', 'R Mall', 17, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('17ccd393-38de-4987-9033-92c738fe7a05', '0286edf1-6735-45e6-9ebc-d55e20c6f084', 'hospital', 'Inorbit Mall', 19, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('78124581-8b44-436e-825d-46c86f28cd05', '7baab7f8-d634-4f7f-a4ae-ae65481385ba', 'hospital', 'Inorbit Mall', 12, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f5c3aa8d-4b2f-498a-aa3e-4eb1a10fac5d', 'dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 'hospital', 'Metro Junction Mall', 13, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('24235194-5957-455b-add7-17a7d91da5f9', '0f36f844-1667-4355-bd12-a2d530396858', 'hospital', 'Inorbit Mall', 19, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a0015a1b-a86f-405b-a8de-382f3a4fab6e', 'a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 'hospital', 'City Centre Mall', 12, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d4cc2a23-8921-4492-8982-b42bf33e3a57', 'cc595bd9-3206-40dd-b7c0-93617c3cd572', 'hospital', 'Inorbit Mall', 8, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('37edb0d0-8909-4c86-b54e-424fc1f05674', 'd3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 'hospital', 'Inorbit Mall', 5, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8a95e3d5-9f4c-4d99-a362-62583958f19b', 'b51e5f2e-9914-43d6-8388-65054f711f30', 'hospital', 'Central Plaza', 12, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('9fe4552f-673e-4254-a2db-71081060eadc', '3888eca5-9184-4a80-917b-a64b68849477', 'hospital', 'City Centre Mall', 17, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('fb168a76-71ec-440f-bef0-105e8b9d1134', '0fce91f5-bd22-44ae-98f7-9b94e06d42de', 'hospital', 'City Centre Mall', 8, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7fb6b062-9791-4ba2-8a9d-bc5e7708ed34', '7650bd3b-845f-4ca5-938d-d1e233240b61', 'hospital', 'Inorbit Mall', 6, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f58d31a5-530d-4f19-9cd0-edd37e0afcad', 'b0002b62-8cf4-4ced-913c-c7cfffd732c6', 'hospital', 'Metro Junction Mall', 24, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b2f4c597-4bd1-477d-9ba1-98669a3498c6', 'c0c2ee2a-a008-41e1-9f23-a265c8fda447', 'hospital', 'Central Plaza', 6, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('32233382-2c33-46b2-adf2-7e7a92103391', 'd0271af1-4898-4863-89ee-b7f4ae50718b', 'hospital', 'Central Plaza', 24, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7cc0feef-d11c-4e9f-81c2-338312b427c8', '238f874e-fa56-4761-bf3a-7ee59df55416', 'hospital', 'Central Plaza', 21, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('fe5a7261-d032-43be-b977-0329de8ec3d5', '2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 'hospital', 'Inorbit Mall', 13, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('733bffaf-5665-4dc2-887d-b15ee3c5625e', 'c04c6e65-f054-4267-a246-b3cca1efac98', 'hospital', 'Central Plaza', 6, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('80a80c22-84d7-4f29-89a5-97b0c3197724', '1636441c-a228-4fcc-99f4-1f86d90db245', 'hospital', 'Central Plaza', 8, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c7a89ea6-37bf-4c3d-945f-ac7baaf572b1', 'a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 'hospital', 'City Centre Mall', 22, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a044fd53-99e5-4aba-a288-7cbcb53df847', 'e94eb671-59e2-4526-9eb1-3fc317295f6d', 'hospital', 'City Centre Mall', 15, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d1fc1b15-cb4c-4d1c-a08d-9a2c3449ac78', '62d91186-46da-4bb7-bacc-fd182c860357', 'hospital', 'Metro Junction Mall', 23, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('7ebcf8dc-c181-4fc5-a15d-d5071c03c467', 'aaf948fe-4305-4ac2-9b43-97078e915814', 'hospital', 'Metro Junction Mall', 9, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('688fe142-a321-4a58-b045-c85e3d1a917e', 'f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 'hospital', 'R Mall', 23, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('af0163a9-399f-49ae-bf99-f008b5e3b1ae', 'df4f61d0-722a-40e8-8339-3cfc83c3b641', 'hospital', 'Metro Junction Mall', 15, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3c463ed0-06a6-44b8-9fbb-1755e0630734', 'fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 'hospital', 'City Centre Mall', 17, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('39b24f84-ba75-48e2-89cc-90486e8a10ea', '76e72c33-512d-4e20-a183-2ee0ed536dcd', 'hospital', 'Inorbit Mall', 13, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('9abc113e-171b-4bd8-aba3-a5aceb57bc14', '3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 'hospital', 'R Mall', 25, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('148ad1e2-42d4-4284-82b7-0e1dad4ef3fb', '36504c39-4314-4f21-b4d7-936d85d35aaa', 'hospital', 'City Centre Mall', 16, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('0cfefec3-e685-454b-a048-fb3dcd7f12dd', '7d6d013f-d5a4-4efe-bb88-c16401163509', 'hospital', 'Inorbit Mall', 9, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a83a2a1b-1a93-4015-9fe9-f1c5458451e1', '93b30971-37da-4bd2-9335-dd7191ff38d4', 'hospital', 'Inorbit Mall', 22, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('1afe8fa8-3d59-4861-96f8-d8d8f7277f8c', 'af03d123-d596-452c-a94b-66254df1f732', 'hospital', 'Inorbit Mall', 25, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a3a6fa93-a1d2-4703-89c0-2b00a6b44d04', '1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 'hospital', 'Inorbit Mall', 7, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('cd066471-22a6-44fc-a52e-658df67e970c', '03f480ac-1b73-45cb-8051-675dc34d6fd8', 'hospital', 'City Centre Mall', 6, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('8b8cf9a3-18bf-4207-90ed-9f948b904ed6', '5825f125-7948-495d-80a1-b25e3721d8ca', 'hospital', 'R Mall', 16, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('ab1d986a-f276-4c84-92a2-3cd75499b3b7', 'dc30889f-15b7-4653-8e76-3ca949d84e92', 'hospital', 'Inorbit Mall', 16, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('f1333f44-a285-45dc-9f1f-b3345e36107d', '1bf15e50-97fe-4f5e-905e-a308fbb5612c', 'hospital', 'Central Plaza', 14, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('189e6bf7-1641-40e9-80ab-7e0d9ee2ed7e', '94a54418-365a-4cec-80d8-180f774fa135', 'hospital', 'City Centre Mall', 17, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('b897c14f-3be4-4758-9fc5-d1b60829bc5d', '02266bb6-c3e8-4667-a465-34a7463f6216', 'hospital', 'R Mall', 22, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('89d787aa-c4fb-4257-9385-ccfd6f03731e', 'a91fff91-304b-4029-b1b3-796f03432262', 'hospital', 'Inorbit Mall', 14, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('423f7d9e-c4dc-44c6-b9ca-ba9d59ff683a', '918731c6-604e-4795-9dd4-65bb2b0ff316', 'hospital', 'Metro Junction Mall', 16, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('3bbd2fa5-4a2b-4e9c-bd29-82d3fcf55a86', '27b10fb2-a0fe-44a9-a53b-dda50090286a', 'hospital', 'Inorbit Mall', 18, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('784307d3-6f25-4774-89ae-3dd06f2b72f8', 'a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 'hospital', 'City Centre Mall', 21, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('95cd39d5-d993-4cb2-bbd6-7fb298f46616', 'e29504df-f994-4081-ab30-8880cb31295c', 'hospital', 'Central Plaza', 21, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('de0ce31b-d51b-4bec-9266-6b60b1c25b55', '8549718e-a328-4d01-8daf-b658a61e80af', 'hospital', 'Central Plaza', 15, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('33264a1d-acf1-45a2-8937-7acfd636fb83', 'c3a0b903-39c9-416b-ac8f-4890cffb4be3', 'hospital', 'R Mall', 14, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('a2d49600-9198-45ed-b3ca-5ff7ea53f97c', '7b309de3-440f-4a16-a9b9-2e510e121ef9', 'hospital', 'City Centre Mall', 14, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('775c213e-2751-474c-b05e-e862d74d25ba', '9a630559-9351-43d0-a3af-ae555b62688b', 'hospital', 'Inorbit Mall', 6, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('23978df6-d65d-4eac-b7b2-89650c2c722f', '6f1cce3d-300c-4a05-b009-603767907351', 'hospital', 'Metro Junction Mall', 16, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('e0b560a8-2128-4ae1-8c1c-f98dfbc39fec', '65241983-adad-4ac9-a586-27339d9b64f9', 'hospital', 'Inorbit Mall', 15, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d20c3c92-2bf7-4503-8407-247d6f868991', 'decd9141-2a0f-44d8-a9ab-331affe2ae57', 'hospital', 'R Mall', 7, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c5451c02-a504-4c90-b88a-4746433ae6a5', 'da7bad20-a9b5-47ba-82f4-52f5657f42ce', 'hospital', 'R Mall', 14, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('d66cb78d-7882-4586-8fcd-58cfc93cebae', '852cb9a1-21fa-482b-b702-99c45c39f992', 'hospital', 'Metro Junction Mall', 12, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c3f06d41-a74e-41bf-9e57-b0d5d16a0f7d', 'd4777543-b2f7-485f-a799-c9e259adf3a3', 'hospital', 'City Centre Mall', 5, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('1b1b1c88-8e45-4a57-8f0f-aa38ad9d37a7', 'f761d1dd-27c3-4243-afcc-951cf01aa49c', 'hospital', 'City Centre Mall', 17, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('44e88bca-841b-4bc8-a9c5-412fd3c3f48a', '716b770e-0fa8-4c9f-9b97-dfb931ecef02', 'hospital', 'Central Plaza', 8, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('c9786ebb-45ec-4825-b9e6-8bafd40cca98', 'c004020a-ca6a-418b-a4ac-2946d0bba8c8', 'hospital', 'Metro Junction Mall', 22, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('6cefd14f-31e5-4937-a942-6c460e1d3799', '3c87d633-0068-42c4-8a43-b391183f2fe8', 'hospital', 'Inorbit Mall', 9, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('2662ee66-b166-4675-8048-cea5e0d56571', '7aea3127-5c6d-4875-9b4c-27a81e6819ce', 'hospital', 'Inorbit Mall', 8, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('9811dbdd-21c2-42e0-aa0d-4d66152b872d', '68aab6f3-a9df-487d-8934-bf1b93d73bbc', 'hospital', 'Central Plaza', 5, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');
INSERT INTO public.project_landmarks VALUES ('22adeb21-cebd-42bb-a484-711cbf0939a2', '0fcd9fae-3cf0-4d51-8489-726510541c4d', 'hospital', 'Inorbit Mall', 11, 3, NULL, NULL, NULL, 'drive', NULL, NULL, true, false, 'manual');


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.projects VALUES ('d6e6a9f6-99a4-4d4e-b45a-85bfffc28fa8', 'Lodha Skyline Residences', 'lodha-skyline-residences-dwarka', '72901f71-c492-4dbe-b56b-909d58437666', 7, 17, NULL, NULL, 'Dwarka, Delhi', 'P772901F', NULL, true, NULL, 11000000, 22000000, 12000, 14000, 650, 1400, 755, 5, 27, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha Skyline Residences by Lodha Group offers modern residences in Dwarka, Delhi with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.645', '2026-08-27 12:56:22.646', '2026-09-20 04:58:18.458', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('418c70cc-d6ee-4f5f-be24-01a6650bb17a', 'DLF Urban Vista', 'dlf-urban-vista-new-town', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 10, 23, NULL, NULL, 'New Town, Kolkata', 'P106C0523', NULL, true, NULL, 7000000, 22000000, 7100, 9100, 650, 1400, 903, 3, 31, '2024-07-31', '2027-07-31', 64, 'under_construction', 'active', 'DLF Urban Vista by DLF Limited offers modern residences in New Town, Kolkata with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.465', '2026-08-27 08:49:58.986', '2026-09-20 04:58:18.463', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('bb3b93a7-2f00-4fb7-b337-c9d15254590f', 'DLF Urban Vista', 'dlf-urban-vista-sector-63', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 9, 20, NULL, NULL, 'Sector 63, Gurgaon', 'P96C0523', NULL, true, NULL, 7000000, 22000000, 13700, 15700, 650, 1400, 903, 3, 31, '2024-07-31', '2027-07-31', 64, 'under_construction', 'active', 'DLF Urban Vista by DLF Limited offers modern residences in Sector 63, Gurgaon with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.658', '2026-08-27 12:56:22.658', '2026-09-20 04:58:18.466', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('757cb567-26c9-4e7b-b6f2-6304699856f1', 'Godrej Serenity Park', 'godrej-serenity-park-gachibowli', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 5, 13, NULL, NULL, 'Gachibowli, Hyderabad', 'P57DCC52', NULL, true, NULL, 4000000, 18000000, 8400, 10400, 650, 1400, 496, 4, 20, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej Serenity Park by Godrej Properties offers modern residences in Gachibowli, Hyderabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.438', '2026-08-27 08:49:58.946', '2026-09-20 04:58:18.468', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('5d7e11c2-b984-498a-bcd4-eb4ae7144cb5', 'Lodha Greens Enclave', 'lodha-greens-enclave-new-town', '72901f71-c492-4dbe-b56b-909d58437666', 10, 23, NULL, NULL, 'New Town, Kolkata', 'P1072901F', NULL, true, NULL, 9000000, 16000000, 7100, 9100, 650, 1400, 977, 5, 13, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha Greens Enclave by Lodha Group offers modern residences in New Town, Kolkata with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.664', '2026-08-27 12:56:22.665', '2026-09-20 04:58:18.471', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('cb9eaa1a-e68f-4fd4-b892-f6b245d12d00', 'DLF Horizon Towers', 'dlf-horizon-towers-sarjapur-road', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 4, 11, NULL, NULL, 'Sarjapur Road, Bangalore', 'P46C0523', NULL, true, NULL, 11000000, 24000000, 8100, 10100, 650, 1400, 459, 3, 19, '2024-07-31', '2027-07-31', 52, 'under_construction', 'active', 'DLF Horizon Towers by DLF Limited offers modern residences in Sarjapur Road, Bangalore with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 12000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 21600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3600000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3600000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 9600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.436', '2026-08-27 08:49:58.942', '2026-09-20 04:58:18.474', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('a6c96f8f-6b72-476f-8728-d61191e56719', 'Sobha City Heights', 'sobha-city-heights-sg-highway', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 11, 24, NULL, NULL, 'SG Highway, Ahmedabad', 'P11A5C584', NULL, true, NULL, 11000000, 20000000, 6300, 8300, 650, 1400, 1051, 7, 15, '2024-11-30', '2027-11-30', 100, 'ready_to_move', 'active', 'Sobha City Heights by Sobha Limited offers modern residences in SG Highway, Ahmedabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.671', '2026-08-27 12:56:22.671', '2026-09-20 04:58:18.477', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('62996084-afe8-4498-9bdf-7b9fc4ff470e', 'Lodha Greens Enclave', 'lodha-greens-enclave', '72901f71-c492-4dbe-b56b-909d58437666', 11, 24, NULL, NULL, 'SG Highway, Ahmedabad', 'P1172901F', NULL, true, NULL, 9000000, 16000000, 6300, 8300, 650, 1400, 500, 5, 13, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha Greens Enclave by Lodha Group offers modern residences in SG Highway, Ahmedabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.469', '2026-08-27 08:49:58.993', '2026-09-20 04:58:18.479', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('7a197c1d-be5d-43a1-a1f4-fc7524e98672', 'DLF Horizon Towers', 'dlf-horizon-towers-hinjewadi', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 3, 7, NULL, NULL, 'Hinjewadi, Pune', 'P36C0523', NULL, true, NULL, 11000000, 24000000, 7700, 9700, 650, 1400, 459, 3, 19, '2024-07-31', '2027-07-31', 52, 'under_construction', 'active', 'DLF Horizon Towers by DLF Limited offers modern residences in Hinjewadi, Pune with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 12000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 21600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3600000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3600000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 9600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.616', '2026-08-27 12:56:22.617', '2026-09-20 04:58:18.427', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('2993189b-9541-42f7-b75d-b4077f035cb0', 'Prestige Serenity Park', 'prestige-serenity-park-palm-beach-road', '611f60c3-d61f-464b-b7ec-24861952cbea', 12, 293, NULL, NULL, 'Palm Beach Road, Navi Mumbai', 'P12611F60', NULL, true, NULL, 8000000, 22000000, 18400, 20400, 650, 1400, 1236, 6, 20, '2024-04-30', '2027-04-30', 73, 'under_construction', 'active', 'Prestige Serenity Park by Prestige Group offers modern residences in Palm Beach Road, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.687', '2026-08-27 12:56:22.687', '2026-09-20 04:58:18.483', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('a3483ccb-3981-48ce-8bca-2c53d7ab20b6', 'Sobha City Heights', 'sobha-city-heights-dadar', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 1, 319, NULL, NULL, 'Dadar, Mumbai', 'P1A5C584', NULL, true, NULL, 11000000, 20000000, 40000, 42000, 650, 1400, 1051, 7, 15, '2024-11-30', '2027-11-30', 100, 'ready_to_move', 'active', 'Sobha City Heights by Sobha Limited offers modern residences in Dadar, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.678', '2026-08-27 13:02:22.818', '2026-09-20 04:58:18.519', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('62d91186-46da-4bb7-bacc-fd182c860357', 'Lodha Urban Vista', 'lodha-urban-vista-pokhran-1', '72901f71-c492-4dbe-b56b-909d58437666', 2, 332, NULL, NULL, 'Pokhran 1, Thane', 'P272901F', NULL, true, NULL, 11000000, 26000000, 14700, 16700, 650, 1400, 1643, 5, 31, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha Urban Vista by Lodha Group offers modern residences in Pokhran 1, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 5200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 13000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 23400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3900000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3900000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 5200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 10400000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.711', '2026-08-27 13:02:22.867', '2026-09-20 04:58:18.523', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('94a54418-365a-4cec-80d8-180f774fa135', 'DLF Skyline Residences', 'dlf-skyline-residences-noida-extension', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 8, 19, NULL, NULL, 'Noida Extension, Noida', 'P86C0523', NULL, true, NULL, 11000000, 22000000, 5700, 7700, 650, 1400, 2235, 3, 27, '2024-07-31', '2027-07-31', 60, 'under_construction', 'active', 'DLF Skyline Residences by DLF Limited offers modern residences in Noida Extension, Noida with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.751', '2026-08-27 13:02:22.916', '2026-09-20 04:58:18.526', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('d4777543-b2f7-485f-a799-c9e259adf3a3', 'Sobha Greens Enclave', 'sobha-greens-enclave-upper-kharghar', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 12, 365, NULL, NULL, 'Upper Kharghar, Navi Mumbai', 'P12A5C584', NULL, true, NULL, 11000000, 18000000, 10000, 12000, 650, 1400, 2827, 7, 23, '2024-11-30', '2027-11-30', 100, 'ready_to_move', 'active', 'Sobha Greens Enclave by Sobha Limited offers modern residences in Upper Kharghar, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.783', '2026-08-27 13:02:22.958', '2026-09-20 04:58:18.529', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('245e2436-81f5-49c6-aa0b-c5717f67c9ae', 'DLF Horizon Towers', 'dlf-horizon-towers-jogeshwari', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 1, 301, NULL, NULL, 'Jogeshwari, Mumbai', 'P16C0523', NULL, true, NULL, 11000000, 24000000, 19300, 21300, 650, 1400, 459, 3, 19, '2024-07-31', '2027-07-31', 52, 'under_construction', 'active', 'DLF Horizon Towers by DLF Limited offers modern residences in Jogeshwari, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 12000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 21600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3600000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3600000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 9600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.638', '2026-08-27 13:02:22.767', '2026-09-20 04:58:18.532', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('0f36f844-1667-4355-bd12-a2d530396858', 'Prestige The Arbour', 'prestige-the-arbour-parel', '611f60c3-d61f-464b-b7ec-24861952cbea', 1, 318, NULL, NULL, 'Parel, Mumbai', 'P1611F60', NULL, true, NULL, 10000000, 18000000, 37500, 39500, 650, 1400, 1014, 6, 14, '2024-10-31', '2027-10-31', 67, 'under_construction', 'active', 'Prestige The Arbour by Prestige Group offers modern residences in Parel, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.676', '2026-08-27 13:02:22.815', '2026-09-20 04:58:18.535', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('b51e5f2e-9914-43d6-8388-65054f711f30', 'Godrej Meadows Phase 2', 'godrej-meadows-phase-2-prabhadevi', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 1, 322, NULL, NULL, 'Prabhadevi, Mumbai', 'P17DCC52', NULL, true, NULL, 6000000, 18000000, 51500, 53500, 650, 1400, 1162, 4, 18, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej Meadows Phase 2 by Godrej Properties offers modern residences in Prabhadevi, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.685', '2026-08-27 13:02:22.829', '2026-09-20 04:58:18.538', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('3dcfa8cf-74db-4167-b227-6ab422c2b3ab', 'Lodha Skyline Residences', 'lodha-skyline-residences-undri', '72901f71-c492-4dbe-b56b-909d58437666', 3, 8, NULL, NULL, 'Undri, Pune', 'P372901F', NULL, true, NULL, 9000000, 20000000, 6400, 8400, 650, 1400, 1865, 5, 17, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha Skyline Residences by Lodha Group offers modern residences in Undri, Pune with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.724', '2026-08-27 13:02:22.886', '2026-09-20 04:58:18.541', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('1bf15e50-97fe-4f5e-905e-a308fbb5612c', 'Brigade Emerald Bay', 'brigade-emerald-bay-sector-150', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 8, 18, NULL, NULL, 'Sector 150, Noida', 'P86E995A', NULL, true, NULL, 10000000, 20000000, 9300, 11300, 650, 1400, 2198, 2, 26, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Emerald Bay by Brigade Group offers modern residences in Sector 150, Noida with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.748', '2026-08-27 13:02:22.913', '2026-09-20 04:58:18.544', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('918731c6-604e-4795-9dd4-65bb2b0ff316', 'Prestige Serenity Park', 'prestige-serenity-park-new-town', '611f60c3-d61f-464b-b7ec-24861952cbea', 10, 23, NULL, NULL, 'New Town, Kolkata', 'P10611F60', NULL, true, NULL, 6000000, 20000000, 7100, 9100, 650, 1400, 2346, 6, 30, '2024-10-31', '2027-10-31', 63, 'under_construction', 'active', 'Prestige Serenity Park by Prestige Group offers modern residences in New Town, Kolkata with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.757', '2026-08-27 13:02:22.924', '2026-09-20 04:58:18.548', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('bd5b1472-8414-4bd4-980c-8c027fff0667', 'Sobha Horizon Towers', 'sobha-horizon-towers-sector-57', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 9, 21, NULL, NULL, 'Sector 57, Gurgaon', 'P9A5C584', NULL, true, NULL, 5000000, 18000000, 15300, 17300, 650, 1400, 829, 7, 29, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Horizon Towers by Sobha Limited offers modern residences in Sector 57, Gurgaon with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.461', '2026-08-27 08:49:58.98', '2026-09-20 04:58:18.431', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('859c919f-5c2e-49da-8e03-d37f49ddfbf9', 'Lodha City Heights', 'lodha-city-heights-ghodbunder-road', '72901f71-c492-4dbe-b56b-909d58437666', 2, 4, NULL, NULL, 'Ghodbunder Road, Thane', 'P272901F', NULL, true, NULL, 7000000, 16000000, 13300, 15300, 650, 1400, 311, 5, 15, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha City Heights by Lodha Group offers modern residences in Ghodbunder Road, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.597', '2026-08-27 12:56:22.599', '2026-09-20 04:58:18.433', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('eb895d11-47b3-4a49-9d05-a2aa8fda3fa0', 'Lodha City Heights', 'lodha-city-heights-dombivli', '72901f71-c492-4dbe-b56b-909d58437666', 2, 5, NULL, NULL, 'Dombivli, Thane', 'P272901F', NULL, true, NULL, 7000000, 16000000, 9300, 11300, 650, 1400, 311, 5, 15, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha City Heights by Lodha Group offers modern residences in Dombivli, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.422', '2026-08-27 08:49:58.924', '2026-09-20 04:58:18.435', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('56618a36-9c91-4eda-a791-139f4af0bad9', 'Prestige Emerald Bay', 'prestige-emerald-bay-dombivli', '611f60c3-d61f-464b-b7ec-24861952cbea', 2, 5, NULL, NULL, 'Dombivli, Thane', 'P2611F60', NULL, true, NULL, 8000000, 18000000, 9300, 11300, 650, 1400, 348, 6, 16, '2024-04-30', '2027-04-30', 49, 'under_construction', 'active', 'Prestige Emerald Bay by Prestige Group offers modern residences in Dombivli, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.602', '2026-08-27 12:56:22.603', '2026-09-20 04:58:18.437', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('5be2e843-8490-47fb-96fa-89b50a6341f1', 'Sobha Skyline Residences', 'sobha-skyline-residences-kalyan', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 2, 6, NULL, NULL, 'Kalyan, Thane', 'P2A5C584', NULL, true, NULL, 9000000, 20000000, 8100, 10100, 650, 1400, 385, 7, 17, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Skyline Residences by Sobha Limited offers modern residences in Kalyan, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.607', '2026-08-27 12:56:22.608', '2026-09-20 04:58:18.439', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('a021e29e-d944-4907-9a24-540efbf1036a', 'Brigade Meadows Phase 2', 'brigade-meadows-phase-2-shilphata', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 2, 271, NULL, NULL, 'Shilphata, Thane', 'P26E995A', NULL, true, NULL, 10000000, 22000000, 7700, 9700, 650, 1400, 422, 2, 18, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Meadows Phase 2 by Brigade Group offers modern residences in Shilphata, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.612', '2026-08-27 12:56:22.613', '2026-09-20 04:58:18.443', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('1448e541-3683-46d3-a150-460c45498116', 'Sobha Greens Enclave', 'sobha-greens-enclave-porur', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 6, 16, NULL, NULL, 'Porur, Chennai', 'P6A5C584', NULL, true, NULL, 7000000, 14000000, 6300, 8300, 650, 1400, 607, 7, 23, '2024-11-30', '2027-11-30', 100, 'ready_to_move', 'active', 'Sobha Greens Enclave by Sobha Limited offers modern residences in Porur, Chennai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.448', '2026-08-27 08:49:58.957', '2026-09-20 04:58:18.445', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('ad4891db-d75f-4ae0-a70f-bf59b8a2196b', 'Godrej Serenity Park', 'godrej-serenity-park-undri', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 3, 8, NULL, NULL, 'Undri, Pune', 'P37DCC52', NULL, true, NULL, 4000000, 18000000, 6400, 8400, 650, 1400, 496, 4, 20, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej Serenity Park by Godrej Properties offers modern residences in Undri, Pune with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.62', '2026-08-27 12:56:22.622', '2026-09-20 04:58:18.447', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('e4336ebe-993b-416b-b6dc-5254c6e05e2b', 'Lodha Urban Vista', 'lodha-urban-vista-whitefield', '72901f71-c492-4dbe-b56b-909d58437666', 4, 10, NULL, NULL, 'Whitefield, Bangalore', 'P472901F', NULL, true, NULL, 5000000, 20000000, 9300, 11300, 650, 1400, 533, 5, 21, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha Urban Vista by Lodha Group offers modern residences in Whitefield, Bangalore with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.625', '2026-08-27 12:56:22.625', '2026-09-20 04:58:18.448', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('3678e00a-e158-4eed-bb5a-46c8d71aca6b', 'Prestige Palava City', 'prestige-palava-city-sarjapur-road', '611f60c3-d61f-464b-b7ec-24861952cbea', 4, 11, NULL, NULL, 'Sarjapur Road, Bangalore', 'P4611F60', NULL, true, NULL, 6000000, 12000000, 8100, 10100, 650, 1400, 570, 6, 22, '2024-10-31', '2027-10-31', 55, 'under_construction', 'active', 'Prestige Palava City by Prestige Group offers modern residences in Sarjapur Road, Bangalore with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 6000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 10800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1800000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1800000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.628', '2026-08-27 12:56:22.628', '2026-09-20 04:58:18.45', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('8655dc97-340e-40b7-8c73-782ccedb8cac', 'Sobha Greens Enclave', 'sobha-greens-enclave-gachibowli', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 5, 13, NULL, NULL, 'Gachibowli, Hyderabad', 'P5A5C584', NULL, true, NULL, 7000000, 14000000, 8400, 10400, 650, 1400, 607, 7, 23, '2024-11-30', '2027-11-30', 100, 'ready_to_move', 'active', 'Sobha Greens Enclave by Sobha Limited offers modern residences in Gachibowli, Hyderabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.631', '2026-08-27 12:56:22.632', '2026-09-20 04:58:18.451', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('e400fe2e-57d1-45b4-a31c-6d09ed05b8cd', 'Brigade The Arbour', 'brigade-the-arbour-kokapet', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 5, 14, NULL, NULL, 'Kokapet, Hyderabad', 'P56E995A', NULL, true, NULL, 8000000, 16000000, 9100, 11100, 650, 1400, 644, 2, 24, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade The Arbour by Brigade Group offers modern residences in Kokapet, Hyderabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.635', '2026-08-27 12:56:22.637', '2026-09-20 04:58:18.453', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('11623247-dca1-4b47-b290-b7d53f19241b', 'Godrej The Arbour', 'godrej-the-arbour-ghodbunder-road', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 2, 4, NULL, NULL, 'Ghodbunder Road, Thane', 'P27DCC52', NULL, true, NULL, 6000000, 14000000, 13300, 15300, 650, 1400, 274, 4, 14, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej The Arbour by Godrej Properties offers modern residences in Ghodbunder Road, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.418', '2026-08-27 08:49:58.919', '2026-09-20 04:58:18.454', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('cd0148b0-f341-41b5-928b-e295fa442625', 'DLF City Heights', 'dlf-city-heights-omr', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 6, 15, NULL, NULL, 'OMR, Chennai', 'P66C0523', NULL, true, NULL, 9000000, 18000000, 6700, 8700, 650, 1400, 681, 3, 25, '2024-01-31', '2027-01-31', 58, 'under_construction', 'active', 'DLF City Heights by DLF Limited offers modern residences in OMR, Chennai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.639', '2026-08-27 12:56:22.639', '2026-09-20 04:58:18.455', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('91353136-fbdf-4531-bec5-9f705c92762e', 'Godrej Emerald Bay', 'godrej-emerald-bay-porur', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 6, 16, NULL, NULL, 'Porur, Chennai', 'P67DCC52', NULL, true, NULL, 10000000, 20000000, 6300, 8300, 650, 1400, 718, 4, 26, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej Emerald Bay by Godrej Properties offers modern residences in Porur, Chennai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.642', '2026-08-27 12:56:22.643', '2026-09-20 04:58:18.456', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('93e1a907-ec07-4e94-ab17-e9d8d83ea14f', 'Lodha Urban Vista', 'lodha-urban-vista-kokapet', '72901f71-c492-4dbe-b56b-909d58437666', 5, 14, NULL, NULL, 'Kokapet, Hyderabad', 'P572901F', NULL, true, NULL, 5000000, 20000000, 9100, 11100, 650, 1400, 533, 5, 21, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha Urban Vista by Lodha Group offers modern residences in Kokapet, Hyderabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.441', '2026-08-27 08:49:58.95', '2026-09-20 04:58:18.461', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('6c3a4a7f-af00-4aac-82a5-663c1e041d7f', 'Prestige Meadows Phase 2', 'prestige-meadows-phase-2-dwarka', '611f60c3-d61f-464b-b7ec-24861952cbea', 7, 17, NULL, NULL, 'Dwarka, Delhi', 'P7611F60', NULL, true, NULL, 4000000, 16000000, 12000, 14000, 650, 1400, 792, 6, 28, '2024-04-30', '2027-04-30', 61, 'under_construction', 'active', 'Prestige Meadows Phase 2 by Prestige Group offers modern residences in Dwarka, Delhi with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.648', '2026-08-27 12:56:22.648', '2026-09-20 04:58:18.462', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('df27a43e-a829-4dc9-94f9-0effb25deae1', 'Sobha Horizon Towers', 'sobha-horizon-towers-sector-150', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 8, 18, NULL, NULL, 'Sector 150, Noida', 'P8A5C584', NULL, true, NULL, 5000000, 18000000, 9300, 11300, 650, 1400, 829, 7, 29, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Horizon Towers by Sobha Limited offers modern residences in Sector 150, Noida with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.65', '2026-08-27 12:56:22.651', '2026-09-20 04:58:18.464', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('6bd6a5f5-c266-4fbc-8717-6aa80a4feaa7', 'Brigade Serenity Park', 'brigade-serenity-park-noida-extension', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 8, 19, NULL, NULL, 'Noida Extension, Noida', 'P86E995A', NULL, true, NULL, 6000000, 20000000, 5700, 7700, 650, 1400, 866, 2, 30, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Serenity Park by Brigade Group offers modern residences in Noida Extension, Noida with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.654', '2026-08-27 12:56:22.655', '2026-09-20 04:58:18.465', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('c9df9707-366c-4355-8f09-ee5a22782620', 'Godrej Palava City', 'godrej-palava-city-sector-57', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 9, 21, NULL, NULL, 'Sector 57, Gurgaon', 'P97DCC52', NULL, true, NULL, 8000000, 14000000, 15300, 17300, 650, 1400, 940, 4, 12, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej Palava City by Godrej Properties offers modern residences in Sector 57, Gurgaon with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.661', '2026-08-27 12:56:22.661', '2026-09-20 04:58:18.467', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('8f1e7d41-2fee-48f0-8059-1b6fbf82d50a', 'Prestige Emerald Bay', 'prestige-emerald-bay-hinjewadi', '611f60c3-d61f-464b-b7ec-24861952cbea', 3, 7, NULL, NULL, 'Hinjewadi, Pune', 'P3611F60', NULL, true, NULL, 8000000, 18000000, 7700, 9700, 650, 1400, 348, 6, 16, '2024-04-30', '2027-04-30', 49, 'under_construction', 'active', 'Prestige Emerald Bay by Prestige Group offers modern residences in Hinjewadi, Pune with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.425', '2026-08-27 08:49:58.93', '2026-09-20 04:58:18.467', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('61a2b029-7d0b-4af3-bf07-e468bd75d4d3', 'Brigade The Arbour', 'brigade-the-arbour-dwarka', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 7, 17, NULL, NULL, 'Dwarka, Delhi', 'P76E995A', NULL, true, NULL, 8000000, 16000000, 12000, 14000, 650, 1400, 644, 2, 24, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade The Arbour by Brigade Group offers modern residences in Dwarka, Delhi with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.449', '2026-08-27 08:49:58.962', '2026-09-20 04:58:18.469', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('91a93bef-e03b-46df-92c2-f2dc19e6d2d0', 'Lodha Skyline Residences', 'lodha-skyline-residences-noida-extension', '72901f71-c492-4dbe-b56b-909d58437666', 8, 19, NULL, NULL, 'Noida Extension, Noida', 'P872901F', NULL, true, NULL, 11000000, 22000000, 5700, 7700, 650, 1400, 755, 5, 27, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha Skyline Residences by Lodha Group offers modern residences in Noida Extension, Noida with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.456', '2026-08-27 08:49:58.972', '2026-09-20 04:58:18.47', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('22fc0e18-fa8c-49ae-8704-0cf540e9512e', 'Prestige The Arbour', 'prestige-the-arbour-new-town', '611f60c3-d61f-464b-b7ec-24861952cbea', 10, 23, NULL, NULL, 'New Town, Kolkata', 'P10611F60', NULL, true, NULL, 10000000, 18000000, 7100, 9100, 650, 1400, 1014, 6, 14, '2024-10-31', '2027-10-31', 67, 'under_construction', 'active', 'Prestige The Arbour by Prestige Group offers modern residences in New Town, Kolkata with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.667', '2026-08-27 12:56:22.667', '2026-09-20 04:58:18.472', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('d06f4375-b054-4c98-98ab-7eed73453bfc', 'Sobha Skyline Residences', 'sobha-skyline-residences-undri', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 3, 8, NULL, NULL, 'Undri, Pune', 'P3A5C584', NULL, true, NULL, 9000000, 20000000, 6400, 8400, 650, 1400, 385, 7, 17, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Skyline Residences by Sobha Limited offers modern residences in Undri, Pune with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.429', '2026-08-27 08:49:58.935', '2026-09-20 04:58:18.473', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('7ad80e2a-7937-4695-b5fc-0c02faed85ed', 'DLF City Heights', 'dlf-city-heights-dwarka', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 7, 17, NULL, NULL, 'Dwarka, Delhi', 'P76C0523', NULL, true, NULL, 9000000, 18000000, 12000, 14000, 650, 1400, 681, 3, 25, '2024-01-31', '2027-01-31', 58, 'under_construction', 'active', 'DLF City Heights by DLF Limited offers modern residences in Dwarka, Delhi with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.452', '2026-08-27 08:49:58.964', '2026-09-20 04:58:18.475', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('a58ef461-7bdb-440d-8ecc-59eb6ddfd2aa', 'Prestige Meadows Phase 2', 'prestige-meadows-phase-2-sector-63', '611f60c3-d61f-464b-b7ec-24861952cbea', 9, 20, NULL, NULL, 'Sector 63, Gurgaon', 'P9611F60', NULL, true, NULL, 4000000, 16000000, 13700, 15700, 650, 1400, 792, 6, 28, '2024-04-30', '2027-04-30', 61, 'under_construction', 'active', 'Prestige Meadows Phase 2 by Prestige Group offers modern residences in Sector 63, Gurgaon with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.459', '2026-08-27 08:49:58.975', '2026-09-20 04:58:18.476', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('99593072-9d3e-4aa8-b967-2849d7355fec', 'Brigade Emerald Bay', 'brigade-emerald-bay-sg-highway', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 11, 24, NULL, NULL, 'SG Highway, Ahmedabad', 'P116E995A', NULL, true, NULL, 4000000, 14000000, 6300, 8300, 650, 1400, 1088, 2, 16, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade Emerald Bay by Brigade Group offers modern residences in SG Highway, Ahmedabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.674', '2026-08-27 12:56:22.675', '2026-09-20 04:58:18.478', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('7acee28a-a2b5-4fa8-bb49-026d2092a59e', 'DLF Skyline Residences', 'dlf-skyline-residences-vashi', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 12, 290, NULL, NULL, 'Vashi, Navi Mumbai', 'P126C0523', NULL, true, NULL, 5000000, 16000000, 16000, 18000, 650, 1400, 1125, 3, 17, '2024-01-31', '2027-01-31', 70, 'under_construction', 'active', 'DLF Skyline Residences by DLF Limited offers modern residences in Vashi, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.678', '2026-08-27 12:56:22.678', '2026-09-20 04:58:18.478', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('71f2aa94-8364-489c-b55a-334b870fe1e1', 'Godrej Meadows Phase 2', 'godrej-meadows-phase-2-nerul', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 12, 291, NULL, NULL, 'Nerul, Navi Mumbai', 'P127DCC52', NULL, true, NULL, 6000000, 18000000, 14700, 16700, 650, 1400, 1162, 4, 18, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej Meadows Phase 2 by Godrej Properties offers modern residences in Nerul, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.681', '2026-08-27 12:56:22.681', '2026-09-20 04:58:18.48', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('13e03c46-58a9-45c4-8154-d2d6af04ff19', 'Lodha Horizon Towers', 'lodha-horizon-towers-belapur', '72901f71-c492-4dbe-b56b-909d58437666', 12, 292, NULL, NULL, 'Belapur, Navi Mumbai', 'P1272901F', NULL, true, NULL, 7000000, 20000000, 14300, 16300, 650, 1400, 1199, 5, 19, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha Horizon Towers by Lodha Group offers modern residences in Belapur, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.684', '2026-08-27 12:56:22.685', '2026-09-20 04:58:18.481', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('2d0fb463-8bbd-40d8-a10c-3e7441102c1e', 'Sobha Urban Vista', 'sobha-urban-vista-airoli', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 12, 294, NULL, NULL, 'Airoli, Navi Mumbai', 'P12A5C584', NULL, true, NULL, 9000000, 24000000, 13100, 15100, 650, 1400, 1273, 7, 21, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Urban Vista by Sobha Limited offers modern residences in Airoli, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 12000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 21600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3600000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3600000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 9600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.69', '2026-08-27 12:56:22.691', '2026-09-20 04:58:18.484', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('47ea527d-3282-436a-965e-b341315759de', 'Brigade Palava City', 'brigade-palava-city-ghansoli', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 12, 295, NULL, NULL, 'Ghansoli, Navi Mumbai', 'P126E995A', NULL, true, NULL, 10000000, 16000000, 11900, 13900, 650, 1400, 1310, 2, 22, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Palava City by Brigade Group offers modern residences in Ghansoli, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 12:56:22.694', '2026-08-27 12:56:22.694', '2026-09-20 04:58:18.485', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('238f874e-fa56-4761-bf3a-7ee59df55416', 'Lodha City Heights', 'lodha-city-heights-kalyan', '72901f71-c492-4dbe-b56b-909d58437666', 2, 6, NULL, NULL, 'Kalyan, Thane', 'P272901F', NULL, true, NULL, 5000000, 14000000, 8100, 10100, 650, 1400, 1421, 5, 25, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha City Heights by Lodha Group offers modern residences in Kalyan, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.699', '2026-08-27 13:02:22.849', '2026-09-20 04:58:18.486', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('30380ba9-eab6-4a9f-9b3a-3814e8a91adb', 'Lodha City Heights', 'lodha-city-heights-borivali', '72901f71-c492-4dbe-b56b-909d58437666', 1, 297, NULL, NULL, 'Borivali, Mumbai', 'P172901F', NULL, true, NULL, 7000000, 16000000, 19000, 21000, 650, 1400, 311, 5, 15, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha City Heights by Lodha Group offers modern residences in Borivali, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.623', '2026-08-27 13:02:22.749', '2026-09-20 04:58:18.487', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('f78c8e9a-4f2d-44b4-8270-f56cfe752aeb', 'Sobha Greens Enclave', 'sobha-greens-enclave-manpada', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 2, 334, NULL, NULL, 'Manpada, Thane', 'P2A5C584', NULL, true, NULL, 5000000, 12000000, 15100, 17100, 650, 1400, 1717, 7, 13, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Greens Enclave by Sobha Limited offers modern residences in Manpada, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 6000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 10800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1800000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1800000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.716', '2026-08-27 13:02:22.872', '2026-09-20 04:58:18.488', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('af03d123-d596-452c-a94b-66254df1f732', 'DLF Urban Vista', 'dlf-urban-vista-kokapet', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 5, 14, NULL, NULL, 'Kokapet, Hyderabad', 'P56C0523', NULL, true, NULL, 5000000, 20000000, 9100, 11100, 650, 1400, 2013, 3, 21, '2024-01-31', '2027-01-31', 54, 'under_construction', 'active', 'DLF Urban Vista by DLF Limited offers modern residences in Kokapet, Hyderabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.734', '2026-08-27 13:02:22.898', '2026-09-20 04:58:18.489', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('81a105f0-f609-4ae2-8696-b938f99047b7', 'Brigade Meadows Phase 2', 'brigade-meadows-phase-2-malad', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 1, 300, NULL, NULL, 'Malad, Mumbai', 'P16E995A', NULL, true, NULL, 10000000, 22000000, 17700, 19700, 650, 1400, 422, 2, 18, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Meadows Phase 2 by Brigade Group offers modern residences in Malad, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.634', '2026-08-27 13:02:22.764', '2026-09-20 04:58:18.489', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('a91fff91-304b-4029-b1b3-796f03432262', 'Lodha Horizon Towers', 'lodha-horizon-towers-sector-57', '72901f71-c492-4dbe-b56b-909d58437666', 9, 21, NULL, NULL, 'Sector 57, Gurgaon', 'P972901F', NULL, true, NULL, 5000000, 18000000, 15300, 17300, 650, 1400, 2309, 5, 29, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha Horizon Towers by Lodha Group offers modern residences in Sector 57, Gurgaon with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.755', '2026-08-27 13:02:22.921', '2026-09-20 04:58:18.49', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('9a630559-9351-43d0-a3af-ae555b62688b', 'Sobha Skyline Residences', 'sobha-skyline-residences-palm-beach-road', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 12, 293, NULL, NULL, 'Palm Beach Road, Navi Mumbai', 'P12A5C584', NULL, true, NULL, 5000000, 16000000, 18400, 20400, 650, 1400, 2605, 7, 17, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Skyline Residences by Sobha Limited offers modern residences in Palm Beach Road, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.771', '2026-08-27 13:02:22.943', '2026-09-20 04:58:18.491', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('56b051bd-07f1-4ef1-a7b5-4fac40fc76df', 'Godrej Serenity Park', 'godrej-serenity-park-vile-parle', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 1, 302, NULL, NULL, 'Vile Parle, Mumbai', 'P17DCC52', NULL, true, NULL, 4000000, 18000000, 27000, 29000, 650, 1400, 496, 4, 20, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej Serenity Park by Godrej Properties offers modern residences in Vile Parle, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.641', '2026-08-27 13:02:22.772', '2026-09-20 04:58:18.492', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('957a2da1-07d3-4757-b35e-62b0793540e8', 'Brigade Meadows Phase 2', 'brigade-meadows-phase-2-whitefield', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 4, 10, NULL, NULL, 'Whitefield, Bangalore', 'P46E995A', NULL, true, NULL, 10000000, 22000000, 9300, 11300, 650, 1400, 422, 2, 18, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Meadows Phase 2 by Brigade Group offers modern residences in Whitefield, Bangalore with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.433', '2026-08-27 08:49:58.939', '2026-09-20 04:58:18.493', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('f5cf1b00-1680-4d6b-b8af-e20af2882c8e', 'Godrej The Arbour', 'godrej-the-arbour-chembur', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 1, 3, NULL, NULL, 'Chembur, Mumbai', 'P17DCC52', NULL, true, NULL, 6000000, 14000000, 18700, 20700, 650, 1400, 274, 4, 14, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej The Arbour by Godrej Properties offers modern residences in Chembur, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.619', '2026-08-27 12:56:22.591', '2026-09-20 04:58:18.493', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('8943fdc0-0495-452d-a818-a7518c7bacc2', 'Sobha Greens Enclave', 'sobha-greens-enclave-dahisar', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 1, 305, NULL, NULL, 'Dahisar, Mumbai', 'P1A5C584', NULL, true, NULL, 7000000, 14000000, 16300, 18300, 650, 1400, 607, 7, 23, '2024-11-30', '2027-11-30', 100, 'ready_to_move', 'active', 'Sobha Greens Enclave by Sobha Limited offers modern residences in Dahisar, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.649', '2026-08-27 13:02:22.782', '2026-09-20 04:58:18.494', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('96b01e7f-7477-4b03-bf64-58b13e4ba558', 'Prestige Palava City', 'prestige-palava-city-omr', '611f60c3-d61f-464b-b7ec-24861952cbea', 6, 15, NULL, NULL, 'OMR, Chennai', 'P6611F60', NULL, true, NULL, 6000000, 12000000, 6700, 8700, 650, 1400, 570, 6, 22, '2024-10-31', '2027-10-31', 55, 'under_construction', 'active', 'Prestige Palava City by Prestige Group offers modern residences in OMR, Chennai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 6000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 10800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1800000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1800000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.444', '2026-08-27 08:49:58.953', '2026-09-20 04:58:18.495', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('5dbf5457-69eb-49c3-8298-582f50cdd642', 'DLF City Heights', 'dlf-city-heights-mulund', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 1, 309, NULL, NULL, 'Mulund, Mumbai', 'P16C0523', NULL, true, NULL, 9000000, 18000000, 20000, 22000, 650, 1400, 681, 3, 25, '2024-01-31', '2027-01-31', 58, 'under_construction', 'active', 'DLF City Heights by DLF Limited offers modern residences in Mulund, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.655', '2026-08-27 13:02:22.789', '2026-09-20 04:58:18.496', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('5eeee399-4d0f-4755-a9c6-351eca6ed7cd', 'Godrej Emerald Bay', 'godrej-emerald-bay-vikhroli', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 1, 310, NULL, NULL, 'Vikhroli, Mumbai', 'P17DCC52', NULL, true, NULL, 10000000, 20000000, 19100, 21100, 650, 1400, 718, 4, 26, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej Emerald Bay by Godrej Properties offers modern residences in Vikhroli, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.657', '2026-08-27 13:02:22.792', '2026-09-20 04:58:18.496', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('5e020c7d-7616-4586-8c1f-b92871600782', 'Godrej Emerald Bay', 'godrej-emerald-bay-sector-150', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 8, 18, NULL, NULL, 'Sector 150, Noida', 'P87DCC52', NULL, true, NULL, 10000000, 20000000, 9300, 11300, 650, 1400, 718, 4, 26, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej Emerald Bay by Godrej Properties offers modern residences in Sector 150, Noida with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.454', '2026-08-27 08:49:58.968', '2026-09-20 04:58:18.498', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('495847cf-06f6-49bc-8a68-7df5c0504838', 'Sobha Horizon Towers', 'sobha-horizon-towers-bhandup', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 1, 313, NULL, NULL, 'Bhandup, Mumbai', 'P1A5C584', NULL, true, NULL, 5000000, 18000000, 16900, 18900, 650, 1400, 829, 7, 29, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Horizon Towers by Sobha Limited offers modern residences in Bhandup, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.664', '2026-08-27 13:02:22.801', '2026-09-20 04:58:18.498', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('3d27c999-6beb-42ca-a450-b96b827e9abe', 'Brigade Serenity Park', 'brigade-serenity-park-new-town', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 10, 23, NULL, NULL, 'New Town, Kolkata', 'P106E995A', NULL, true, NULL, 6000000, 20000000, 7100, 9100, 650, 1400, 866, 2, 30, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Serenity Park by Brigade Group offers modern residences in New Town, Kolkata with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.463', '2026-08-27 08:49:58.984', '2026-09-20 04:58:18.499', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('7baab7f8-d634-4f7f-a4ae-ae65481385ba', 'Godrej Palava City', 'godrej-palava-city-byculla', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 1, 316, NULL, NULL, 'Byculla, Mumbai', 'P17DCC52', NULL, true, NULL, 8000000, 14000000, 31500, 33500, 650, 1400, 940, 4, 12, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej Palava City by Godrej Properties offers modern residences in Byculla, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.671', '2026-08-27 13:02:22.81', '2026-09-20 04:58:18.5', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('68148e8f-62d7-4bf4-9b96-ab684d43b51c', 'Godrej Palava City', 'godrej-palava-city-sg-highway', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 11, 24, NULL, NULL, 'SG Highway, Ahmedabad', 'P117DCC52', NULL, true, NULL, 8000000, 14000000, 6300, 8300, 650, 1400, 940, 4, 12, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej Palava City by Godrej Properties offers modern residences in SG Highway, Ahmedabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "garden": true, "parking": true, "clubhouse": true, "play_area": true, "power_backup": true, "security_247": true, "swimming_pool": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-27 09:25:48.467', '2026-08-27 08:49:58.989', '2026-09-20 04:58:18.501', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('cc595bd9-3206-40dd-b7c0-93617c3cd572', 'Brigade Emerald Bay', 'brigade-emerald-bay-lalbaug', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 1, 320, NULL, NULL, 'Lalbaug, Mumbai', 'P16E995A', NULL, true, NULL, 4000000, 14000000, 33500, 35500, 650, 1400, 1088, 2, 16, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade Emerald Bay by Brigade Group offers modern residences in Lalbaug, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.68', '2026-08-27 13:02:22.822', '2026-09-20 04:58:18.502', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('d3fbfc65-3926-4f3e-a073-e20fc9c8ea26', 'DLF Skyline Residences', 'dlf-skyline-residences-lower-parel', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 1, 321, NULL, NULL, 'Lower Parel, Mumbai', 'P16C0523', NULL, true, NULL, 5000000, 16000000, 44500, 46500, 650, 1400, 1125, 3, 17, '2024-01-31', '2027-01-31', 70, 'under_construction', 'active', 'DLF Skyline Residences by DLF Limited offers modern residences in Lower Parel, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.683', '2026-08-27 13:02:22.824', '2026-09-20 04:58:18.503', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('0fce91f5-bd22-44ae-98f7-9b94e06d42de', 'Prestige Serenity Park', 'prestige-serenity-park-sion', '611f60c3-d61f-464b-b7ec-24861952cbea', 1, 324, NULL, NULL, 'Sion, Mumbai', 'P1611F60', NULL, true, NULL, 8000000, 22000000, 26000, 28000, 650, 1400, 1236, 6, 20, '2024-04-30', '2027-04-30', 73, 'under_construction', 'active', 'Prestige Serenity Park by Prestige Group offers modern residences in Sion, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.688', '2026-08-27 13:02:22.834', '2026-09-20 04:58:18.503', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('d0271af1-4898-4863-89ee-b7f4ae50718b', 'Godrej The Arbour', 'godrej-the-arbour-dombivli', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 2, 5, NULL, NULL, 'Dombivli, Thane', 'P27DCC52', NULL, true, NULL, 4000000, 12000000, 9300, 11300, 650, 1400, 1384, 4, 24, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej The Arbour by Godrej Properties offers modern residences in Dombivli, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 6000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 10800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1800000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1800000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4800000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.697', '2026-08-27 13:02:22.846', '2026-09-20 04:58:18.504', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('1636441c-a228-4fcc-99f4-1f86d90db245', 'Brigade Meadows Phase 2', 'brigade-meadows-phase-2-balkum', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 2, 329, NULL, NULL, 'Balkum, Thane', 'P26E995A', NULL, true, NULL, 8000000, 20000000, 12300, 14300, 650, 1400, 1532, 2, 28, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade Meadows Phase 2 by Brigade Group offers modern residences in Balkum, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.705', '2026-08-27 13:02:22.859', '2026-09-20 04:58:18.505', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('aaf948fe-4305-4ac2-9b43-97078e915814', 'Prestige Palava City', 'prestige-palava-city-pokhran-2', '611f60c3-d61f-464b-b7ec-24861952cbea', 2, 333, NULL, NULL, 'Pokhran 2, Thane', 'P2611F60', NULL, true, NULL, 4000000, 10000000, 14300, 16300, 650, 1400, 1680, 6, 12, '2024-04-30', '2027-04-30', 45, 'under_construction', 'active', 'Prestige Palava City by Prestige Group offers modern residences in Pokhran 2, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 5000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 9000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1500000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1500000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4000000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.713', '2026-08-27 13:02:22.87', '2026-09-20 04:58:18.506', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('76e72c33-512d-4e20-a183-2ee0ed536dcd', 'Godrej Emerald Bay', 'godrej-emerald-bay-hinjewadi', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 3, 7, NULL, NULL, 'Hinjewadi, Pune', 'P37DCC52', NULL, true, NULL, 8000000, 18000000, 7700, 9700, 650, 1400, 1828, 4, 16, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej Emerald Bay by Godrej Properties offers modern residences in Hinjewadi, Pune with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.722', '2026-08-27 13:02:22.882', '2026-09-20 04:58:18.507', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('93b30971-37da-4bd2-9335-dd7191ff38d4', 'Brigade Serenity Park', 'brigade-serenity-park-gachibowli', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 5, 13, NULL, NULL, 'Gachibowli, Hyderabad', 'P56E995A', NULL, true, NULL, 4000000, 18000000, 8400, 10400, 650, 1400, 1976, 2, 20, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade Serenity Park by Brigade Group offers modern residences in Gachibowli, Hyderabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.73', '2026-08-27 13:02:22.895', '2026-09-20 04:58:18.507', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('5825f125-7948-495d-80a1-b25e3721d8ca', 'Prestige The Arbour', 'prestige-the-arbour-dwarka', '611f60c3-d61f-464b-b7ec-24861952cbea', 7, 17, NULL, NULL, 'Dwarka, Delhi', 'P7611F60', NULL, true, NULL, 8000000, 16000000, 12000, 14000, 650, 1400, 2124, 6, 24, '2024-04-30', '2027-04-30', 57, 'under_construction', 'active', 'Prestige The Arbour by Prestige Group offers modern residences in Dwarka, Delhi with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.74', '2026-08-27 13:02:22.907', '2026-09-20 04:58:18.508', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('02266bb6-c3e8-4667-a465-34a7463f6216', 'Godrej Meadows Phase 2', 'godrej-meadows-phase-2-sector-63', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 9, 20, NULL, NULL, 'Sector 63, Gurgaon', 'P97DCC52', NULL, true, NULL, 4000000, 16000000, 13700, 15700, 650, 1400, 2272, 4, 28, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej Meadows Phase 2 by Godrej Properties offers modern residences in Sector 63, Gurgaon with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.753', '2026-08-27 13:02:22.918', '2026-09-20 04:58:18.509', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('a9a84786-016d-4fbf-8b20-c1e9c89d7f93', 'Brigade Palava City', 'brigade-palava-city-sg-highway', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 11, 24, NULL, NULL, 'SG Highway, Ahmedabad', 'P116E995A', NULL, true, NULL, 8000000, 14000000, 6300, 8300, 650, 1400, 2420, 2, 12, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade Palava City by Brigade Group offers modern residences in SG Highway, Ahmedabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.761', '2026-08-27 13:02:22.929', '2026-09-20 04:58:18.51', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('7b309de3-440f-4a16-a9b9-2e510e121ef9', 'Prestige Emerald Bay', 'prestige-emerald-bay-belapur', '611f60c3-d61f-464b-b7ec-24861952cbea', 12, 292, NULL, NULL, 'Belapur, Navi Mumbai', 'P12611F60', NULL, true, NULL, 4000000, 14000000, 14300, 16300, 650, 1400, 2568, 6, 16, '2024-04-30', '2027-04-30', 69, 'under_construction', 'active', 'Prestige Emerald Bay by Prestige Group offers modern residences in Belapur, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.769', '2026-08-27 13:02:22.94', '2026-09-20 04:58:18.511', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('decd9141-2a0f-44d8-a9ab-331affe2ae57', 'Godrej Serenity Park', 'godrej-serenity-park-sanpada', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 12, 359, NULL, NULL, 'Sanpada, Navi Mumbai', 'P127DCC52', NULL, true, NULL, 8000000, 22000000, 15300, 17300, 650, 1400, 2716, 4, 20, '2024-08-31', '2027-08-31', 100, 'ready_to_move', 'active', 'Godrej Serenity Park by Godrej Properties offers modern residences in Sanpada, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.777', '2026-08-27 13:02:22.95', '2026-09-20 04:58:18.511', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('f761d1dd-27c3-4243-afcc-951cf01aa49c', 'Brigade The Arbour', 'brigade-the-arbour-digha', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 12, 368, NULL, NULL, 'Digha, Navi Mumbai', 'P126E995A', NULL, true, NULL, 4000000, 12000000, 9300, 11300, 650, 1400, 2864, 2, 24, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade The Arbour by Brigade Group offers modern residences in Digha, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 6000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 10800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1800000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1800000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4800000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.785', '2026-08-27 13:02:22.96', '2026-09-20 04:58:18.512', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('7aea3127-5c6d-4875-9b4c-27a81e6819ce', 'Prestige Meadows Phase 2', 'prestige-meadows-phase-2-palaspe', '611f60c3-d61f-464b-b7ec-24861952cbea', 12, 372, NULL, NULL, 'Palaspe, Navi Mumbai', 'P12611F60', NULL, true, NULL, 8000000, 20000000, 6400, 8400, 650, 1400, 3012, 6, 28, '2024-04-30', '2027-04-30', 81, 'under_construction', 'active', 'Prestige Meadows Phase 2 by Prestige Group offers modern residences in Palaspe, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.793', '2026-08-27 13:02:22.969', '2026-09-20 04:58:18.513', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('acfc42a9-2060-4408-ac25-16a6a719b844', 'DLF Greens Enclave', 'dlf-greens-enclave-powai', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 1, 2, NULL, NULL, 'Powai, Mumbai', 'P16C0523', NULL, true, NULL, 5000000, 12000000, 21300, 23300, 650, 1400, 237, 3, 13, '2024-01-31', '2027-01-31', 46, 'under_construction', 'active', 'DLF Greens Enclave by DLF Limited offers modern residences in Powai, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 6000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 10800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1800000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1800000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.615', '2026-08-27 08:49:58.913', '2026-09-20 04:58:18.514', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('ce867446-632d-463c-9550-ee082072994a', 'Prestige Emerald Bay', 'prestige-emerald-bay-goregaon', '611f60c3-d61f-464b-b7ec-24861952cbea', 1, 298, NULL, NULL, 'Goregaon, Mumbai', 'P1611F60', NULL, true, NULL, 8000000, 18000000, 19700, 21700, 650, 1400, 348, 6, 16, '2024-04-30', '2027-04-30', 49, 'under_construction', 'active', 'Prestige Emerald Bay by Prestige Group offers modern residences in Goregaon, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.627', '2026-08-27 13:02:22.755', '2026-09-20 04:58:18.515', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('ea489613-9992-4f49-bca0-ea5e3c92ab40', 'Lodha Urban Vista', 'lodha-urban-vista-santacruz', '72901f71-c492-4dbe-b56b-909d58437666', 1, 303, NULL, NULL, 'Santacruz, Mumbai', 'P172901F', NULL, true, NULL, 5000000, 20000000, 28400, 30400, 650, 1400, 533, 5, 21, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha Urban Vista by Lodha Group offers modern residences in Santacruz, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.644', '2026-08-27 13:02:22.776', '2026-09-20 04:58:18.515', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('e29d2c6e-8808-4863-bdff-533fe8f0d78f', 'Brigade The Arbour', 'brigade-the-arbour-mira-road', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 1, 306, NULL, NULL, 'Mira Road, Mumbai', 'P16E995A', NULL, true, NULL, 8000000, 16000000, 12300, 14300, 650, 1400, 644, 2, 24, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade The Arbour by Brigade Group offers modern residences in Mira Road, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.652', '2026-08-27 13:02:22.785', '2026-09-20 04:58:18.516', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('d3bec0d8-acde-4f1e-8e04-f31a3b007c30', 'Lodha Skyline Residences', 'lodha-skyline-residences-ghatkopar', '72901f71-c492-4dbe-b56b-909d58437666', 1, 311, NULL, NULL, 'Ghatkopar, Mumbai', 'P172901F', NULL, true, NULL, 11000000, 22000000, 20700, 22700, 650, 1400, 755, 5, 27, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha Skyline Residences by Lodha Group offers modern residences in Ghatkopar, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.659', '2026-08-27 13:02:22.795', '2026-09-20 04:58:18.517', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('2097ba54-f560-4cfd-84d0-4a9e90574e51', 'Brigade Serenity Park', 'brigade-serenity-park-worli', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 1, 314, NULL, NULL, 'Worli, Mumbai', 'P16E995A', NULL, true, NULL, 6000000, 20000000, 54500, 56500, 650, 1400, 866, 2, 30, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Serenity Park by Brigade Group offers modern residences in Worli, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.666', '2026-08-27 13:02:22.805', '2026-09-20 04:58:18.518', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('dbd341b8-2c7d-41b7-af7e-4c6ed8ecbd49', 'Lodha Greens Enclave', 'lodha-greens-enclave-sewri', '72901f71-c492-4dbe-b56b-909d58437666', 1, 317, NULL, NULL, 'Sewri, Mumbai', 'P172901F', NULL, true, NULL, 9000000, 16000000, 29000, 31000, 650, 1400, 977, 5, 13, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha Greens Enclave by Lodha Group offers modern residences in Sewri, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.673', '2026-08-27 13:02:22.813', '2026-09-20 04:58:18.519', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('3888eca5-9184-4a80-917b-a64b68849477', 'Lodha Horizon Towers', 'lodha-horizon-towers-mahim', '72901f71-c492-4dbe-b56b-909d58437666', 1, 323, NULL, NULL, 'Mahim, Mumbai', 'P172901F', NULL, true, NULL, 7000000, 20000000, 39000, 41000, 650, 1400, 1199, 5, 19, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha Horizon Towers by Lodha Group offers modern residences in Mahim, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.687', '2026-08-27 13:02:22.832', '2026-09-20 04:58:18.52', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('c0c2ee2a-a008-41e1-9f23-a265c8fda447', 'DLF Greens Enclave', 'dlf-greens-enclave-ghodbunder-road', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 2, 4, NULL, NULL, 'Ghodbunder Road, Thane', 'P26C0523', NULL, true, NULL, 11000000, 18000000, 13300, 15300, 650, 1400, 1347, 3, 23, '2024-07-31', '2027-07-31', 76, 'under_construction', 'active', 'DLF Greens Enclave by DLF Limited offers modern residences in Ghodbunder Road, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.694', '2026-08-27 13:02:22.843', '2026-09-20 04:58:18.521', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('c04c6e65-f054-4267-a246-b3cca1efac98', 'Sobha Skyline Residences', 'sobha-skyline-residences-kasarvadavali', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 2, 328, NULL, NULL, 'Kasarvadavali, Thane', 'P2A5C584', NULL, true, NULL, 7000000, 18000000, 11700, 13700, 650, 1400, 1495, 7, 27, '2024-11-30', '2027-11-30', 100, 'ready_to_move', 'active', 'Sobha Skyline Residences by Sobha Limited offers modern residences in Kasarvadavali, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.703', '2026-08-27 13:02:22.854', '2026-09-20 04:58:18.522', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('fd26debe-8fe6-4ed5-b55f-0f8d3b439b04', 'DLF City Heights', 'dlf-city-heights-waghbil', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 2, 336, NULL, NULL, 'Waghbil, Thane', 'P26C0523', NULL, true, NULL, 7000000, 16000000, 12100, 14100, 650, 1400, 1791, 3, 15, '2024-07-31', '2027-07-31', 48, 'under_construction', 'active', 'DLF City Heights by DLF Limited offers modern residences in Waghbil, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.72', '2026-08-27 13:02:22.879', '2026-09-20 04:58:18.523', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('7d6d013f-d5a4-4efe-bb88-c16401163509', 'Sobha Horizon Towers', 'sobha-horizon-towers-sarjapur-road', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 4, 11, NULL, NULL, 'Sarjapur Road, Bangalore', 'P4A5C584', NULL, true, NULL, 11000000, 24000000, 8100, 10100, 650, 1400, 1939, 7, 19, '2024-11-30', '2027-11-30', 100, 'ready_to_move', 'active', 'Sobha Horizon Towers by Sobha Limited offers modern residences in Sarjapur Road, Bangalore with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 12000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 21600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3600000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3600000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 9600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.728', '2026-08-27 13:02:22.892', '2026-09-20 04:58:18.524', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('03f480ac-1b73-45cb-8051-675dc34d6fd8', 'Lodha Greens Enclave', 'lodha-greens-enclave-porur', '72901f71-c492-4dbe-b56b-909d58437666', 6, 16, NULL, NULL, 'Porur, Chennai', 'P672901F', NULL, true, NULL, 7000000, 14000000, 6300, 8300, 650, 1400, 2087, 5, 23, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha Greens Enclave by Lodha Group offers modern residences in Porur, Chennai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.738', '2026-08-27 13:02:22.904', '2026-09-20 04:58:18.525', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('27b10fb2-a0fe-44a9-a53b-dda50090286a', 'Sobha Urban Vista', 'sobha-urban-vista-new-town', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 10, 23, NULL, NULL, 'New Town, Kolkata', 'P10A5C584', NULL, true, NULL, 7000000, 22000000, 7100, 9100, 650, 1400, 2383, 7, 31, '2024-11-30', '2027-11-30', 100, 'ready_to_move', 'active', 'Sobha Urban Vista by Sobha Limited offers modern residences in New Town, Kolkata with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.759', '2026-08-27 13:02:22.926', '2026-09-20 04:58:18.527', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('c3a0b903-39c9-416b-ac8f-4890cffb4be3', 'Lodha City Heights', 'lodha-city-heights-nerul', '72901f71-c492-4dbe-b56b-909d58437666', 12, 291, NULL, NULL, 'Nerul, Navi Mumbai', 'P1272901F', NULL, true, NULL, 11000000, 20000000, 14700, 16700, 650, 1400, 2531, 5, 15, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha City Heights by Lodha Group offers modern residences in Nerul, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.767', '2026-08-27 13:02:22.937', '2026-09-20 04:58:18.527', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('65241983-adad-4ac9-a586-27339d9b64f9', 'DLF Horizon Towers', 'dlf-horizon-towers-ghansoli', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 12, 295, NULL, NULL, 'Ghansoli, Navi Mumbai', 'P126C0523', NULL, true, NULL, 7000000, 20000000, 11900, 13900, 650, 1400, 2679, 3, 19, '2024-07-31', '2027-07-31', 72, 'under_construction', 'active', 'DLF Horizon Towers by DLF Limited offers modern residences in Ghansoli, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.775', '2026-08-27 13:02:22.947', '2026-09-20 04:58:18.528', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('3c87d633-0068-42c4-8a43-b391183f2fe8', 'Lodha Skyline Residences', 'lodha-skyline-residences-kalamboli', '72901f71-c492-4dbe-b56b-909d58437666', 12, 371, NULL, NULL, 'Kalamboli, Navi Mumbai', 'P1272901F', NULL, true, NULL, 7000000, 18000000, 7300, 9300, 650, 1400, 2975, 5, 27, '2024-03-31', '2027-03-31', 5, 'new_launch', 'active', 'Lodha Skyline Residences by Lodha Group offers modern residences in Kalamboli, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.791', '2026-08-27 13:02:22.967', '2026-09-20 04:58:18.529', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('c5c4cb67-8e9e-4edc-b80e-11c5ea0359e6', 'Brigade Palava City', 'brigade-palava-city-andheri-west', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 1, 1, NULL, NULL, 'Andheri West, Mumbai', 'P16E995A', NULL, true, NULL, 4000000, 10000000, 24000, 26000, 650, 1400, 200, 2, 12, '2023-12-31', '2026-12-31', 5, 'new_launch', 'active', 'Brigade Palava City by Brigade Group offers modern residences in Andheri West, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 5000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 9000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1500000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1500000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4000000}]}', NULL, NULL, NULL, true, true, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.606', '2026-08-27 08:49:58.902', '2026-09-20 04:58:18.53', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('68aab6f3-a9df-487d-8934-bf1b93d73bbc', 'Sobha Horizon Towers', 'sobha-horizon-towers-shedung', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 12, 373, NULL, NULL, 'Shedung, Navi Mumbai', 'P12A5C584', NULL, true, NULL, 9000000, 22000000, 5700, 7700, 650, 1400, 3049, 7, 29, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Horizon Towers by Sobha Limited offers modern residences in Shedung, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.794', '2026-08-27 13:02:22.972', '2026-09-20 04:58:18.531', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('3f256a22-dbf2-4858-b219-8a887459d13f', 'Prestige Palava City', 'prestige-palava-city-bandra', '611f60c3-d61f-464b-b7ec-24861952cbea', 1, 304, NULL, NULL, 'Bandra, Mumbai', 'P1611F60', NULL, true, NULL, 6000000, 12000000, 41500, 43500, 650, 1400, 570, 6, 22, '2024-10-31', '2027-10-31', 55, 'under_construction', 'active', 'Prestige Palava City by Prestige Group offers modern residences in Bandra, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 6000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 10800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1800000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1800000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.647', '2026-08-27 13:02:22.778', '2026-09-20 04:58:18.532', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('765af9dd-61f8-4c7a-80e8-7974f7b83136', 'Sobha Skyline Residences', 'sobha-skyline-residences-kandivali', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 1, 299, NULL, NULL, 'Kandivali, Mumbai', 'P1A5C584', NULL, true, NULL, 9000000, 20000000, 18300, 20300, 650, 1400, 385, 7, 17, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Skyline Residences by Sobha Limited offers modern residences in Kandivali, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4000000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 10000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6000000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 18000000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2000000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2000000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3000000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3000000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4000000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8000000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.631', '2026-08-27 13:02:22.759', '2026-09-20 04:58:18.533', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('0286edf1-6735-45e6-9ebc-d55e20c6f084', 'DLF Urban Vista', 'dlf-urban-vista-mahalaxmi', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 1, 315, NULL, NULL, 'Mahalaxmi, Mumbai', 'P16C0523', NULL, true, NULL, 7000000, 22000000, 47500, 49500, 650, 1400, 903, 3, 31, '2024-07-31', '2027-07-31', 64, 'under_construction', 'active', 'DLF Urban Vista by DLF Limited offers modern residences in Mahalaxmi, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.668', '2026-08-27 13:02:22.807', '2026-09-20 04:58:18.534', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('6291ab92-3882-4932-91c3-ce8a06921842', 'Prestige Meadows Phase 2', 'prestige-meadows-phase-2-kanjurmarg', '611f60c3-d61f-464b-b7ec-24861952cbea', 1, 312, NULL, NULL, 'Kanjurmarg, Mumbai', 'P1611F60', NULL, true, NULL, 4000000, 16000000, 18400, 20400, 650, 1400, 792, 6, 28, '2024-04-30', '2027-04-30', 61, 'under_construction', 'active', 'Prestige Meadows Phase 2 by Prestige Group offers modern residences in Kanjurmarg, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, true, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.661', '2026-08-27 13:02:22.797', '2026-09-20 04:58:18.536', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('7650bd3b-845f-4ca5-938d-d1e233240b61', 'Sobha Urban Vista', 'sobha-urban-vista-wadala', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 1, 325, NULL, NULL, 'Wadala, Mumbai', 'P1A5C584', NULL, true, NULL, 9000000, 24000000, 27300, 29300, 650, 1400, 1273, 7, 21, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha Urban Vista by Sobha Limited offers modern residences in Wadala, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 12000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 21600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3600000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3600000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 9600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.69', '2026-08-27 13:02:22.837', '2026-09-20 04:58:18.537', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('b0002b62-8cf4-4ced-913c-c7cfffd732c6', 'Brigade Palava City', 'brigade-palava-city-matunga', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 1, 326, NULL, NULL, 'Matunga, Mumbai', 'P16E995A', NULL, true, NULL, 10000000, 16000000, 33000, 35000, 650, 1400, 1310, 2, 22, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Palava City by Brigade Group offers modern residences in Matunga, Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.692', '2026-08-27 13:02:22.841', '2026-09-20 04:58:18.538', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('a27c4e82-f002-4047-9715-f8a5bc8ea7a2', 'DLF Horizon Towers', 'dlf-horizon-towers-majiwada', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 2, 330, NULL, NULL, 'Majiwada, Thane', 'P26C0523', NULL, true, NULL, 9000000, 22000000, 14000, 16000, 650, 1400, 1569, 3, 29, '2024-01-31', '2027-01-31', 82, 'under_construction', 'active', 'DLF Horizon Towers by DLF Limited offers modern residences in Majiwada, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.708', '2026-08-27 13:02:22.861', '2026-09-20 04:58:18.539', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('e94eb671-59e2-4526-9eb1-3fc317295f6d', 'Godrej Serenity Park', 'godrej-serenity-park-kolshet', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 2, 331, NULL, NULL, 'Kolshet, Thane', 'P27DCC52', NULL, true, NULL, 10000000, 24000000, 13400, 15400, 650, 1400, 1606, 4, 30, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej Serenity Park by Godrej Properties offers modern residences in Kolshet, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 12000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 21600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3600000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3600000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 9600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.71', '2026-08-27 13:02:22.864', '2026-09-20 04:58:18.54', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('2319f488-23ab-4c3e-ad7e-e1397b1e8f6e', 'Prestige Emerald Bay', 'prestige-emerald-bay-shilphata', '611f60c3-d61f-464b-b7ec-24861952cbea', 2, 271, NULL, NULL, 'Shilphata, Thane', 'P2611F60', NULL, true, NULL, 6000000, 16000000, 7700, 9700, 650, 1400, 1458, 6, 26, '2024-10-31', '2027-10-31', 79, 'under_construction', 'active', 'Prestige Emerald Bay by Prestige Group offers modern residences in Shilphata, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.701', '2026-08-27 13:02:22.852', '2026-09-20 04:58:18.541', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('36504c39-4314-4f21-b4d7-936d85d35aaa', 'Prestige Meadows Phase 2', 'prestige-meadows-phase-2-whitefield', '611f60c3-d61f-464b-b7ec-24861952cbea', 4, 10, NULL, NULL, 'Whitefield, Bangalore', 'P4611F60', NULL, true, NULL, 10000000, 22000000, 9300, 11300, 650, 1400, 1902, 6, 18, '2024-10-31', '2027-10-31', 51, 'under_construction', 'active', 'Prestige Meadows Phase 2 by Prestige Group offers modern residences in Whitefield, Bangalore with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 11000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 6600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 19800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3300000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3300000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 8800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.726', '2026-08-27 13:02:22.888', '2026-09-20 04:58:18.542', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('df4f61d0-722a-40e8-8339-3cfc83c3b641', 'Brigade The Arbour', 'brigade-the-arbour-bhayandarpada', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 2, 335, NULL, NULL, 'Bhayandarpada, Thane', 'P26E995A', NULL, true, NULL, 6000000, 14000000, 12700, 14700, 650, 1400, 1754, 2, 14, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade The Arbour by Brigade Group offers modern residences in Bhayandarpada, Thane with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.718', '2026-08-27 13:02:22.877', '2026-09-20 04:58:18.543', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('dc30889f-15b7-4653-8e76-3ca949d84e92', 'Sobha City Heights', 'sobha-city-heights-dwarka', 'a5c584d2-0528-405e-94ca-7bb657fccd98', 7, 17, NULL, NULL, 'Dwarka, Delhi', 'P7A5C584', NULL, true, NULL, 9000000, 18000000, 12000, 14000, 650, 1400, 2161, 7, 25, '2024-05-31', '2027-05-31', 100, 'ready_to_move', 'active', 'Sobha City Heights by Sobha Limited offers modern residences in Dwarka, Delhi with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.745', '2026-08-27 13:02:22.911', '2026-09-20 04:58:18.544', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('1fc333a4-c8e5-4eae-abfe-4ca8ca333614', 'Godrej Palava City', 'godrej-palava-city-omr', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 6, 15, NULL, NULL, 'OMR, Chennai', 'P67DCC52', NULL, true, NULL, 6000000, 12000000, 6700, 8700, 650, 1400, 2050, 4, 22, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej Palava City by Godrej Properties offers modern residences in OMR, Chennai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2400000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 6000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 3600000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 10800000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1200000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1200000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 1800000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 1800000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2400000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 4800000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.736', '2026-08-27 13:02:22.901', '2026-09-20 04:58:18.545', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('e29504df-f994-4081-ab30-8880cb31295c', 'DLF Greens Enclave', 'dlf-greens-enclave-sg-highway', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 11, 24, NULL, NULL, 'SG Highway, Ahmedabad', 'P116C0523', NULL, true, NULL, 9000000, 16000000, 6300, 8300, 650, 1400, 2457, 3, 13, '2024-01-31', '2027-01-31', 66, 'under_construction', 'active', 'DLF Greens Enclave by DLF Limited offers modern residences in SG Highway, Ahmedabad with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.763', '2026-08-27 13:02:22.931', '2026-09-20 04:58:18.546', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('8549718e-a328-4d01-8daf-b658a61e80af', 'Godrej The Arbour', 'godrej-the-arbour-vashi', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 12, 290, NULL, NULL, 'Vashi, Navi Mumbai', 'P127DCC52', NULL, true, NULL, 10000000, 18000000, 16000, 18000, 650, 1400, 2494, 4, 14, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej The Arbour by Godrej Properties offers modern residences in Vashi, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.765', '2026-08-27 13:02:22.935', '2026-09-20 04:58:18.547', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('da7bad20-a9b5-47ba-82f4-52f5657f42ce', 'Lodha Urban Vista', 'lodha-urban-vista-kharghar', '72901f71-c492-4dbe-b56b-909d58437666', 12, 363, NULL, NULL, 'Kharghar, Navi Mumbai', 'P1272901F', NULL, true, NULL, 9000000, 24000000, 11300, 13300, 650, 1400, 2753, 5, 21, '2024-09-30', '2027-09-30', 5, 'new_launch', 'active', 'Lodha Urban Vista by Lodha Group offers modern residences in Kharghar, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 12000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 21600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3600000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3600000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 9600000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.779', '2026-08-27 13:02:22.953', '2026-09-20 04:58:18.549', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('852cb9a1-21fa-482b-b702-99c45c39f992', 'Prestige Palava City', 'prestige-palava-city-taloja', '611f60c3-d61f-464b-b7ec-24861952cbea', 12, 364, NULL, NULL, 'Taloja, Navi Mumbai', 'P12611F60', NULL, true, NULL, 10000000, 16000000, 6700, 8700, 650, 1400, 2790, 6, 22, '2024-10-31', '2027-10-31', 75, 'under_construction', 'active', 'Prestige Palava City by Prestige Group offers modern residences in Taloja, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.781', '2026-08-27 13:02:22.954', '2026-09-20 04:58:18.549', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('6f1cce3d-300c-4a05-b009-603767907351', 'Brigade Meadows Phase 2', 'brigade-meadows-phase-2-airoli', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 12, 294, NULL, NULL, 'Airoli, Navi Mumbai', 'P126E995A', NULL, true, NULL, 6000000, 18000000, 13100, 15100, 650, 1400, 2642, 2, 18, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Meadows Phase 2 by Brigade Group offers modern residences in Airoli, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3600000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 9000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 5400000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 16200000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1800000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1800000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2700000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2700000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3600000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 7200000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.773', '2026-08-27 13:02:22.945', '2026-09-20 04:58:18.55', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('c004020a-ca6a-418b-a4ac-2946d0bba8c8', 'Godrej Emerald Bay', 'godrej-emerald-bay-panvel', '7dcc52ca-8088-4be6-8114-fe68cdf277e0', 12, 370, NULL, NULL, 'Panvel, Navi Mumbai', 'P127DCC52', NULL, true, NULL, 6000000, 16000000, 8100, 10100, 650, 1400, 2938, 4, 26, '2024-02-29', '2027-02-28', 100, 'ready_to_move', 'active', 'Godrej Emerald Bay by Godrej Properties offers modern residences in Panvel, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 3200000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 8000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4800000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 14400000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1600000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1600000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2400000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2400000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 3200000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 6400000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.789', '2026-08-27 13:02:22.965', '2026-09-20 04:58:18.551', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('0fcd9fae-3cf0-4d51-8489-726510541c4d', 'Brigade Serenity Park', 'brigade-serenity-park', '6e995a6a-eede-43b1-aa06-6f010464d3ca', 12, 374, NULL, NULL, 'Juinagar, Navi Mumbai', 'P126E995A', NULL, true, NULL, 10000000, 24000000, 14900, 16900, 650, 1400, 3086, 2, 30, '2024-06-30', '2027-06-30', 5, 'new_launch', 'active', 'Brigade Serenity Park by Brigade Group offers modern residences in Juinagar, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": true, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": true, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 4800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 12000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 7200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 21600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 2400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 2400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 3600000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 3600000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 4800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 9600000}]}', NULL, NULL, NULL, true, false, true, false, true, 0, 2, 0, NULL, '2026-08-29 06:38:24.797', '2026-08-27 13:02:22.975', '2026-09-20 04:58:18.551', NULL, '{2,3}');
INSERT INTO public.projects VALUES ('716b770e-0fa8-4c9f-9b97-dfb931ecef02', 'DLF City Heights', 'dlf-city-heights-rasayani', '6c05239e-a2e4-412d-9f77-76ed42ecccd0', 12, 369, NULL, NULL, 'Rasayani, Navi Mumbai', 'P126C0523', NULL, true, NULL, 5000000, 14000000, 4900, 6900, 650, 1400, 2901, 3, 25, '2024-01-31', '2027-01-31', 78, 'under_construction', 'active', 'DLF City Heights by DLF Limited offers modern residences in Rasayani, Navi Mumbai with premium amenities and excellent connectivity.', '{"RERA Registered","Prime Location","Modern Amenities"}', '{"gym": true, "lift": true, "garden": true, "parking": true, "intercom": true, "clubhouse": true, "play_area": true, "yoga_deck": true, "ev_charging": false, "fire_safety": true, "indoor_games": true, "power_backup": true, "security_247": true, "jogging_track": true, "swimming_pool": true, "community_hall": false, "senior_citizen_area": true, "rainwater_harvesting": true}', '{"flexi": [{"due": "Now", "pct": 20, "label": "Booking", "amount": 2800000}, {"due": "Milestone based", "pct": 50, "label": "During Construction", "amount": 7000000}, {"due": "On possession", "pct": 30, "label": "On Possession", "amount": 4200000}], "down_payment": [{"due": "Within 30 days", "pct": 90, "label": "Booking + Down Payment", "amount": 12600000}, {"due": "On possession", "pct": 10, "label": "On Possession", "amount": 1400000}], "construction_linked": [{"due": "Now", "pct": 10, "label": "Booking", "amount": 1400000}, {"due": "3 months", "pct": 15, "label": "On Foundation", "amount": 2100000}, {"due": "9 months", "pct": 15, "label": "On Slab 5", "amount": 2100000}, {"due": "15 months", "pct": 20, "label": "On Slab 10", "amount": 2800000}, {"due": "On possession", "pct": 40, "label": "On Possession", "amount": 5600000}]}', NULL, NULL, NULL, true, false, false, false, true, 0, 0, 0, NULL, '2026-08-29 06:38:24.787', '2026-08-27 13:02:22.962', '2026-09-20 04:58:18.552', NULL, '{2,3}');


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.regions VALUES (1, 1, 'Western Mumbai', 'western-mumbai', 0);
INSERT INTO public.regions VALUES (2, 1, 'Harbour', 'harbour', 0);
INSERT INTO public.regions VALUES (3, 1, 'South Mumbai', 'south-mumbai', 0);
INSERT INTO public.regions VALUES (4, 1, 'Central Mumbai', 'central-mumbai', 0);
INSERT INTO public.regions VALUES (5, 2, 'Majiwada–Kolshet Corridor', 'majiwada-kolshet-corridor', 0);
INSERT INTO public.regions VALUES (6, 2, 'Ghodbunder Extension', 'ghodbunder-extension', 0);
INSERT INTO public.regions VALUES (7, 2, 'Hiranandani–Manpada Zone', 'hiranandani-manpada-zone', 0);
INSERT INTO public.regions VALUES (8, 12, 'Palm Beach', 'palm-beach', 0);
INSERT INTO public.regions VALUES (9, 12, 'Kharghar', 'kharghar', 0);
INSERT INTO public.regions VALUES (10, 12, 'Digha-Turbhe', 'digha-turbhe', 0);
INSERT INTO public.regions VALUES (11, 12, 'Panvel', 'panvel', 0);


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: saved_projects; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: saved_searches; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.states VALUES (1, 'Maharashtra', 'maharashtra', '{"stampDutyPct": 6, "registrationPct": 1}', '2026-08-27 08:25:04.248');
INSERT INTO public.states VALUES (2, 'Karnataka', 'karnataka', '{"stampDutyPct": 5, "registrationPct": 1}', '2026-08-27 08:25:04.254');
INSERT INTO public.states VALUES (3, 'Telangana', 'telangana', '{"stampDutyPct": 5.5, "registrationPct": 0.5}', '2026-08-27 08:25:04.256');
INSERT INTO public.states VALUES (4, 'Tamil Nadu', 'tamil-nadu', '{"stampDutyPct": 7, "registrationPct": 1}', '2026-08-27 08:25:04.259');
INSERT INTO public.states VALUES (5, 'Delhi', 'delhi', '{"stampDutyPct": 6, "registrationPct": 1}', '2026-08-27 08:25:04.261');
INSERT INTO public.states VALUES (6, 'Haryana', 'haryana', '{"stampDutyPct": 7, "registrationPct": 1}', '2026-08-27 08:25:04.263');
INSERT INTO public.states VALUES (7, 'Uttar Pradesh', 'uttar-pradesh', '{"stampDutyPct": 7, "registrationPct": 1}', '2026-08-27 08:25:04.265');
INSERT INTO public.states VALUES (8, 'West Bengal', 'west-bengal', '{"stampDutyPct": 6, "registrationPct": 1}', '2026-08-27 08:25:04.267');
INSERT INTO public.states VALUES (9, 'Gujarat', 'gujarat', '{"stampDutyPct": 4.9, "registrationPct": 1}', '2026-08-27 08:25:04.27');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES ('seed-editor', 'PropVista Editorial', NULL, NULL, 'cms_editor', NULL, false, '2026-08-27 09:11:03.142', NULL);


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cities_id_seq', 12, true);


--
-- Name: localities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.localities_id_seq', 690, true);


--
-- Name: price_trends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.price_trends_id_seq', 1, false);


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.regions_id_seq', 55, true);


--
-- Name: states_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.states_id_seq', 90, true);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: blog_posts blog_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_pkey PRIMARY KEY (id);


--
-- Name: builders builders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.builders
    ADD CONSTRAINT builders_pkey PRIMARY KEY (id);


--
-- Name: chatbot_sessions chatbot_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chatbot_sessions
    ADD CONSTRAINT chatbot_sessions_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: construction_updates construction_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.construction_updates
    ADD CONSTRAINT construction_updates_pkey PRIMARY KEY (id);


--
-- Name: job_applications job_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: listing_boosts listing_boosts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listing_boosts
    ADD CONSTRAINT listing_boosts_pkey PRIMARY KEY (id);


--
-- Name: localities localities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.localities
    ADD CONSTRAINT localities_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: places places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: price_trends price_trends_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_trends
    ADD CONSTRAINT price_trends_pkey PRIMARY KEY (id);


--
-- Name: project_configs project_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_configs
    ADD CONSTRAINT project_configs_pkey PRIMARY KEY (id);


--
-- Name: project_faqs project_faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_faqs
    ADD CONSTRAINT project_faqs_pkey PRIMARY KEY (id);


--
-- Name: project_landmarks project_landmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_landmarks
    ADD CONSTRAINT project_landmarks_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: saved_projects saved_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_projects
    ADD CONSTRAINT saved_projects_pkey PRIMARY KEY (id);


--
-- Name: saved_searches saved_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_searches
    ADD CONSTRAINT saved_searches_pkey PRIMARY KEY (id);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: blog_posts_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX blog_posts_slug_key ON public.blog_posts USING btree (slug);


--
-- Name: builders_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX builders_slug_key ON public.builders USING btree (slug);


--
-- Name: chatbot_sessions_session_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX chatbot_sessions_session_id_key ON public.chatbot_sessions USING btree (session_id);


--
-- Name: cities_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cities_slug_key ON public.cities USING btree (slug);


--
-- Name: cities_state_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cities_state_id_idx ON public.cities USING btree (state_id);


--
-- Name: construction_updates_project_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX construction_updates_project_id_idx ON public.construction_updates USING btree (project_id);


--
-- Name: job_applications_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX job_applications_created_at_idx ON public.job_applications USING btree (created_at DESC);


--
-- Name: job_applications_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX job_applications_status_idx ON public.job_applications USING btree (status);


--
-- Name: jobs_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX jobs_slug_key ON public.jobs USING btree (slug);


--
-- Name: jobs_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jobs_status_idx ON public.jobs USING btree (status);


--
-- Name: leads_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX leads_created_at_idx ON public.leads USING btree (created_at DESC);


--
-- Name: leads_phone_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX leads_phone_idx ON public.leads USING btree (phone);


--
-- Name: leads_project_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX leads_project_id_idx ON public.leads USING btree (project_id);


--
-- Name: leads_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX leads_status_idx ON public.leads USING btree (status);


--
-- Name: localities_city_id_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX localities_city_id_slug_key ON public.localities USING btree (city_id, slug);


--
-- Name: media_project_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX media_project_id_idx ON public.media USING btree (project_id);


--
-- Name: places_category_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX places_category_idx ON public.places USING btree (category);


--
-- Name: places_city_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX places_city_id_idx ON public.places USING btree (city_id);


--
-- Name: places_seo_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX places_seo_slug_key ON public.places USING btree (seo_slug);


--
-- Name: places_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX places_slug_key ON public.places USING btree (slug);


--
-- Name: project_configs_project_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX project_configs_project_id_idx ON public.project_configs USING btree (project_id);


--
-- Name: project_faqs_project_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX project_faqs_project_id_idx ON public.project_faqs USING btree (project_id);


--
-- Name: project_landmarks_place_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX project_landmarks_place_id_idx ON public.project_landmarks USING btree (place_id);


--
-- Name: project_landmarks_project_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX project_landmarks_project_id_idx ON public.project_landmarks USING btree (project_id);


--
-- Name: projects_city_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX projects_city_id_idx ON public.projects USING btree (city_id);


--
-- Name: projects_city_id_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_city_id_slug_key ON public.projects USING btree (city_id, slug);


--
-- Name: projects_construction_status_project_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX projects_construction_status_project_status_idx ON public.projects USING btree (construction_status, project_status);


--
-- Name: projects_locality_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX projects_locality_id_idx ON public.projects USING btree (locality_id);


--
-- Name: projects_possession_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX projects_possession_date_idx ON public.projects USING btree (possession_date);


--
-- Name: projects_price_min_price_max_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX projects_price_min_price_max_idx ON public.projects USING btree (price_min, price_max);


--
-- Name: projects_published_featured_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX projects_published_featured_idx ON public.projects USING btree (published, featured);


--
-- Name: regions_city_id_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX regions_city_id_slug_key ON public.regions USING btree (city_id, slug);


--
-- Name: saved_projects_user_id_project_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX saved_projects_user_id_project_id_key ON public.saved_projects USING btree (user_id, project_id);


--
-- Name: states_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX states_slug_key ON public.states USING btree (slug);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: blog_posts blog_posts_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: chatbot_sessions chatbot_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chatbot_sessions
    ADD CONSTRAINT chatbot_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cities cities_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_state_id_fkey FOREIGN KEY (state_id) REFERENCES public.states(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: construction_updates construction_updates_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.construction_updates
    ADD CONSTRAINT construction_updates_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: leads leads_builder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_builder_id_fkey FOREIGN KEY (builder_id) REFERENCES public.builders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: leads leads_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: listing_boosts listing_boosts_builder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listing_boosts
    ADD CONSTRAINT listing_boosts_builder_id_fkey FOREIGN KEY (builder_id) REFERENCES public.builders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: listing_boosts listing_boosts_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listing_boosts
    ADD CONSTRAINT listing_boosts_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: localities localities_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.localities
    ADD CONSTRAINT localities_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: localities localities_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.localities
    ADD CONSTRAINT localities_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: media media_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: places places_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: places places_locality_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_locality_id_fkey FOREIGN KEY (locality_id) REFERENCES public.localities(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: price_trends price_trends_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_trends
    ADD CONSTRAINT price_trends_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: price_trends price_trends_locality_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_trends
    ADD CONSTRAINT price_trends_locality_id_fkey FOREIGN KEY (locality_id) REFERENCES public.localities(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: project_configs project_configs_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_configs
    ADD CONSTRAINT project_configs_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: project_faqs project_faqs_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_faqs
    ADD CONSTRAINT project_faqs_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: project_landmarks project_landmarks_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_landmarks
    ADD CONSTRAINT project_landmarks_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.places(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: project_landmarks project_landmarks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_landmarks
    ADD CONSTRAINT project_landmarks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: projects projects_builder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_builder_id_fkey FOREIGN KEY (builder_id) REFERENCES public.builders(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: projects projects_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: projects projects_locality_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_locality_id_fkey FOREIGN KEY (locality_id) REFERENCES public.localities(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: regions regions_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: reviews reviews_builder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_builder_id_fkey FOREIGN KEY (builder_id) REFERENCES public.builders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reviews reviews_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reviews reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: saved_projects saved_projects_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_projects
    ADD CONSTRAINT saved_projects_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: saved_projects saved_projects_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_projects
    ADD CONSTRAINT saved_projects_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: saved_searches saved_searches_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_searches
    ADD CONSTRAINT saved_searches_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


