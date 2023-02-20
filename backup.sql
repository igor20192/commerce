--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)

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
-- Name: all_name(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.all_name()
    LANGUAGE sql
    AS $$
SELECT name ,bid FROM auctions_auction AS a INNER JOIN auctions_bid AS ab ON a.price_id = ab.id;
$$;


ALTER PROCEDURE public.all_name() OWNER TO postgres;

--
-- Name: get_name(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.get_name(value character varying)
    LANGUAGE sql
    AS $$
SELECT name FROM auctions_auction WHERE name LIKE '%value';
$$;


ALTER PROCEDURE public.get_name(value character varying) OWNER TO postgres;

--
-- Name: insert_auction(); Type: FUNCTION; Schema: public; Owner: igor
--

CREATE FUNCTION public.insert_auction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO auctions_log VALUES (NEW.author_auct, CONCAT ('item added', NEW.product_name), CURRENT_TIMESTAMP);
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_auction() OWNER TO igor;

--
-- Name: koty(character varying); Type: FUNCTION; Schema: public; Owner: igor
--

CREATE FUNCTION public.koty(arg character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare
	get_name auctions_auction.name%type;
begin
	select name into get_name from auctions_auction where name like '%'|| arg||'%';
	return get_name;
	if not found then
		raise 'Not found';
	end if;
end;
$$;


ALTER FUNCTION public.koty(arg character varying) OWNER TO igor;

--
-- Name: log_bid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_bid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO auctions_log(name, description, data) VALUES (OLD.author_bid, CONCAT('update bid', OLD.bid,'>',NEW.bid),current_timestamp);

RETURN NEW;
END;

$$;


ALTER FUNCTION public.log_bid() OWNER TO postgres;

--
-- Name: update_bid(numeric, integer); Type: PROCEDURE; Schema: public; Owner: igor
--

CREATE PROCEDURE public.update_bid(new_bid numeric, auction_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE index integer;
BEGIN
    SELECT ab.id INTO index FROM auctions_auction a INNER JOIN auctions_bid ab ON
	a.price_id = ab.id WHERE a.id = auction_id;
	UPDATE auctions_bid SET bid = new_bid WHERE id = index;
	commit;
END;$$;


ALTER PROCEDURE public.update_bid(new_bid numeric, auction_id integer) OWNER TO igor;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auctions_auction; Type: TABLE; Schema: public; Owner: auctions_user
--

CREATE TABLE public.auctions_auction (
    id bigint NOT NULL,
    categor_id bigint,
    product_name text,
    description text,
    image text,
    author_auct text,
    active boolean,
    price_id bigint,
    name text,
    brief_descrip text,
    image1 text,
    image2 text,
    paid boolean,
    image3 text
);


ALTER TABLE public.auctions_auction OWNER TO auctions_user;

--
-- Name: auctions_auction_commet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auctions_auction_commet (
    id bigint NOT NULL,
    auction_id bigint,
    comments_id bigint
);


ALTER TABLE public.auctions_auction_commet OWNER TO postgres;

--
-- Name: auctions_auction_commet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auctions_auction_commet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_auction_commet_id_seq OWNER TO postgres;

--
-- Name: auctions_auction_commet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auctions_auction_commet_id_seq OWNED BY public.auctions_auction_commet.id;


--
-- Name: auctions_auction_id_seq; Type: SEQUENCE; Schema: public; Owner: auctions_user
--

CREATE SEQUENCE public.auctions_auction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_auction_id_seq OWNER TO auctions_user;

--
-- Name: auctions_auction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: auctions_user
--

ALTER SEQUENCE public.auctions_auction_id_seq OWNED BY public.auctions_auction.id;


--
-- Name: auctions_bid; Type: TABLE; Schema: public; Owner: auctions_user
--

CREATE TABLE public.auctions_bid (
    id bigint NOT NULL,
    author_bid text,
    date_bid timestamp with time zone,
    bid numeric
);


ALTER TABLE public.auctions_bid OWNER TO auctions_user;

--
-- Name: auctions_bid_id_seq; Type: SEQUENCE; Schema: public; Owner: auctions_user
--

CREATE SEQUENCE public.auctions_bid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_bid_id_seq OWNER TO auctions_user;

--
-- Name: auctions_bid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: auctions_user
--

ALTER SEQUENCE public.auctions_bid_id_seq OWNED BY public.auctions_bid.id;


--
-- Name: auctions_category; Type: TABLE; Schema: public; Owner: auctions_user
--

CREATE TABLE public.auctions_category (
    id bigint NOT NULL,
    name text
);


ALTER TABLE public.auctions_category OWNER TO auctions_user;

--
-- Name: auctions_category_id_seq; Type: SEQUENCE; Schema: public; Owner: auctions_user
--

CREATE SEQUENCE public.auctions_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_category_id_seq OWNER TO auctions_user;

--
-- Name: auctions_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: auctions_user
--

ALTER SEQUENCE public.auctions_category_id_seq OWNED BY public.auctions_category.id;


--
-- Name: auctions_comments; Type: TABLE; Schema: public; Owner: auctions_user
--

CREATE TABLE public.auctions_comments (
    id bigint NOT NULL,
    auction_name text,
    comments text,
    author_comments text,
    date_comm timestamp with time zone
);


ALTER TABLE public.auctions_comments OWNER TO auctions_user;

--
-- Name: auctions_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: auctions_user
--

CREATE SEQUENCE public.auctions_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_comments_id_seq OWNER TO auctions_user;

--
-- Name: auctions_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: auctions_user
--

ALTER SEQUENCE public.auctions_comments_id_seq OWNED BY public.auctions_comments.id;


--
-- Name: auctions_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auctions_log (
    name character varying,
    description character varying,
    data text NOT NULL
);


ALTER TABLE public.auctions_log OWNER TO postgres;

--
-- Name: auctions_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auctions_transaction (
    id bigint NOT NULL,
    payment_date timestamp with time zone,
    receiver_email text,
    test_ipn bigint,
    auth_amount numeric,
    mc_currency text,
    address_country text,
    address_city text,
    address_name text,
    address_street text,
    address_zip text,
    first_name text,
    last_name text,
    payer_email text,
    item_name text,
    txn_id text,
    contact_phone text
);


ALTER TABLE public.auctions_transaction OWNER TO postgres;

--
-- Name: auctions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auctions_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_transaction_id_seq OWNER TO postgres;

--
-- Name: auctions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auctions_transaction_id_seq OWNED BY public.auctions_transaction.id;


--
-- Name: auctions_user; Type: TABLE; Schema: public; Owner: auctions_user
--

CREATE TABLE public.auctions_user (
    id bigint NOT NULL,
    password text,
    last_login timestamp with time zone,
    is_superuser boolean,
    username text,
    first_name text,
    last_name text,
    email text,
    is_staff boolean,
    is_active boolean,
    date_joined timestamp with time zone
);


ALTER TABLE public.auctions_user OWNER TO auctions_user;

--
-- Name: auctions_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auctions_user_groups (
    id bigint NOT NULL,
    user_id bigint,
    group_id bigint
);


ALTER TABLE public.auctions_user_groups OWNER TO postgres;

--
-- Name: auctions_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auctions_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_user_groups_id_seq OWNER TO postgres;

--
-- Name: auctions_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auctions_user_groups_id_seq OWNED BY public.auctions_user_groups.id;


--
-- Name: auctions_user_id_seq; Type: SEQUENCE; Schema: public; Owner: auctions_user
--

CREATE SEQUENCE public.auctions_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_user_id_seq OWNER TO auctions_user;

--
-- Name: auctions_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: auctions_user
--

ALTER SEQUENCE public.auctions_user_id_seq OWNED BY public.auctions_user.id;


--
-- Name: auctions_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auctions_user_user_permissions (
    id bigint NOT NULL,
    user_id bigint,
    permission_id bigint
);


ALTER TABLE public.auctions_user_user_permissions OWNER TO postgres;

--
-- Name: auctions_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auctions_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: auctions_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auctions_user_user_permissions_id_seq OWNED BY public.auctions_user_user_permissions.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id bigint NOT NULL,
    name text
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id bigint,
    permission_id bigint
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id bigint NOT NULL,
    content_type_id bigint,
    codename text,
    name text
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id bigint NOT NULL,
    object_id text,
    object_repr text,
    action_flag smallint,
    change_message text,
    content_type_id bigint,
    user_id bigint,
    action_time timestamp with time zone
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id bigint NOT NULL,
    app_label text,
    model text
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: auctions_user
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app text,
    name text,
    applied timestamp with time zone
);


ALTER TABLE public.django_migrations OWNER TO auctions_user;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: auctions_user
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO auctions_user;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: auctions_user
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key text NOT NULL,
    session_data text,
    expire_date timestamp with time zone
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: paypal_ipn; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paypal_ipn (
    id bigint NOT NULL,
    business text,
    charset text,
    custom text,
    notify_version numeric,
    parent_txn_id text,
    receiver_email text,
    receiver_id text,
    residence_country text,
    test_ipn boolean,
    txn_id text,
    txn_type text,
    verify_sign text,
    address_country text,
    address_city text,
    address_country_code text,
    address_name text,
    address_state text,
    address_status text,
    address_street text,
    address_zip text,
    contact_phone text,
    first_name text,
    last_name text,
    payer_business_name text,
    payer_email text,
    payer_id text,
    auth_amount numeric,
    auth_exp text,
    auth_id text,
    auth_status text,
    exchange_rate numeric,
    invoice text,
    item_name text,
    item_number text,
    mc_currency text,
    mc_fee numeric,
    mc_gross numeric,
    mc_handling numeric,
    mc_shipping numeric,
    memo text,
    num_cart_items bigint,
    option_name1 text,
    option_name2 text,
    payer_status text,
    payment_date timestamp with time zone,
    payment_gross numeric,
    payment_status text,
    payment_type text,
    pending_reason text,
    protection_eligibility text,
    quantity bigint,
    reason_code text,
    remaining_settle numeric,
    settle_amount numeric,
    settle_currency text,
    shipping numeric,
    shipping_method text,
    tax numeric,
    transaction_entity text,
    auction_buyer_id text,
    auction_closing_date timestamp with time zone,
    auction_multi_item bigint,
    for_auction numeric,
    amount numeric,
    amount_per_cycle numeric,
    initial_payment_amount numeric,
    next_payment_date timestamp with time zone,
    outstanding_balance numeric,
    payment_cycle text,
    period_type text,
    product_name text,
    product_type text,
    profile_status text,
    recurring_payment_id text,
    rp_invoice_id text,
    time_created timestamp with time zone,
    amount1 numeric,
    amount2 numeric,
    amount3 numeric,
    mc_amount1 numeric,
    mc_amount2 numeric,
    mc_amount3 numeric,
    password text,
    period1 text,
    period2 text,
    period3 text,
    reattempt text,
    recur_times bigint,
    recurring text,
    retry_at timestamp with time zone,
    subscr_date timestamp with time zone,
    subscr_effective timestamp with time zone,
    subscr_id text,
    username text,
    case_creation_date timestamp with time zone,
    case_id text,
    case_type text,
    receipt_id text,
    currency_code text,
    handling_amount numeric,
    transaction_subject text,
    ipaddress text,
    flag boolean,
    flag_code text,
    flag_info text,
    query text,
    response text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    from_view text,
    mp_id text,
    option_selection1 text,
    option_selection2 text
);


ALTER TABLE public.paypal_ipn OWNER TO postgres;

--
-- Name: paypal_ipn_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paypal_ipn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paypal_ipn_id_seq OWNER TO postgres;

--
-- Name: paypal_ipn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paypal_ipn_id_seq OWNED BY public.paypal_ipn.id;


--
-- Name: tests; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.tests AS
 SELECT a.id,
    a.name,
    ab.author_bid,
    ab.bid
   FROM (public.auctions_auction a
     JOIN public.auctions_bid ab ON ((a.price_id = ab.id)));


ALTER TABLE public.tests OWNER TO postgres;

--
-- Name: auctions_auction id; Type: DEFAULT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_auction ALTER COLUMN id SET DEFAULT nextval('public.auctions_auction_id_seq'::regclass);


--
-- Name: auctions_auction_commet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_auction_commet ALTER COLUMN id SET DEFAULT nextval('public.auctions_auction_commet_id_seq'::regclass);


--
-- Name: auctions_bid id; Type: DEFAULT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_bid ALTER COLUMN id SET DEFAULT nextval('public.auctions_bid_id_seq'::regclass);


--
-- Name: auctions_category id; Type: DEFAULT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_category ALTER COLUMN id SET DEFAULT nextval('public.auctions_category_id_seq'::regclass);


--
-- Name: auctions_comments id; Type: DEFAULT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_comments ALTER COLUMN id SET DEFAULT nextval('public.auctions_comments_id_seq'::regclass);


--
-- Name: auctions_transaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_transaction ALTER COLUMN id SET DEFAULT nextval('public.auctions_transaction_id_seq'::regclass);


--
-- Name: auctions_user id; Type: DEFAULT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_user ALTER COLUMN id SET DEFAULT nextval('public.auctions_user_id_seq'::regclass);


--
-- Name: auctions_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auctions_user_groups_id_seq'::regclass);


--
-- Name: auctions_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auctions_user_user_permissions_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: paypal_ipn id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paypal_ipn ALTER COLUMN id SET DEFAULT nextval('public.paypal_ipn_id_seq'::regclass);


--
-- Data for Name: auctions_auction; Type: TABLE DATA; Schema: public; Owner: auctions_user
--

COPY public.auctions_auction (id, categor_id, product_name, description, image, author_auct, active, price_id, name, brief_descrip, image1, image2, paid, image3) FROM stdin;
1	4	Samsung Galaxy A03 4/64 GB	Дисплей\r\nДіагональ екрану\t6,5"\r\nРозширення екрану\t720х1600\r\nМатриця\tPLS\r\nБезрамковий екран\tє\r\nІнші хар-ки екрану\tспіввідношення сторін: 20:9; 270 ppi\r\nПлатформа\r\nОпераційна система\tAndroid 11\r\nКількість ядер\t8 шт.\r\nПроцесор (модель)\t1,6 ГГц\r\nПам'ять\r\nОперативна пам'ять\t4 ГБ\r\nВнутрішня пам'ять\t64 ГБ\r\nПідтримка карт пам'яті\tє\r\nОб'єм карти пам'яті\tдо 1 ТБ\r\nПоєднаний слот SIM-карти і карти пам'яті\tнемає\r\nОсновна камера\r\nРоздільна здатність камери\t48 + 2 Мп\r\nХар-ки камери\tПодвійна:\r\n48 Мп, f/1,8 (ширококутний), автофокус.\r\n2 Мп, f/2,4, сенсор глибини.\r\n\r\nОсобливості:\r\nLED спалах, панорама.\r\n\r\nЗапис відео:\r\n1920×1080 (30 кадр./с).\r\nСелфі-камера\r\nРоздільна здатність фронтальної камери\t5 Мп\r\nХар-ки фронтальної камери\tОдинарна:\r\n5 Мп, f/2,2 (ширококутний).\r\nМережі\r\nСтандарт передачі даних\t4G\r\nЧастоти зв'язку\t2G GSM: 850/900/1800 МГц; 3G UMTS: B1(2100), B5(850), B8(900); 4G FDD LTE: B1(2100), B3(1800), B5(850), B7(2600), B8(900), B20(800), B28(700), B38(2600), B40(2300), B41 (2500)\r\nКількість SIM-карт\t2 SIM\r\nТип SIM-карт\tnano-SIM (12,3х8,8 мм)\r\nІнтернет\t2G, 3G, 4G\r\nІнтерфейси\r\nWi-Fi\tє\r\nСтандарт Wi-Fi\t5 (802.11ac)\r\nBluetooth\tє\r\nСтандарт Bluetooth\tBluetooth 5.0\r\nGPS\tє\r\nNFC\tнемає\r\nMini-jack 3.5 мм\tє\r\nНаявність USB\tє\r\nUSB\tmicro-USB\r\nХар-ки USB\tmicro-USB 2.0\r\nДодаткові датчики\tдатчик освітлення\r\nБатарея\r\nЄмність батареї\t5000 мАч\r\nФізичні характеристики\r\nМатеріал задньої панелі\tпластик\r\nСтупінь захисту корпусу\tнемає\r\nколір\tBlack\r\nГабарити (ШхВхТ)\t75,9x164,2x9,1 мм\r\nВага\t196 г\r\nКомплектація\tсмартфон, зарядний пристрій, кабель для синхронізації, скріпка для вилучення СІМ-карти, документація\r\nДодатково\r\nВеликий дисплей для великих можливостей\r\nРозшир межі доступного з 6,5-дюймовим екраном з V-подібним вирізом. Завдяки технології HD+ дисплей Galaxy A03 демонструє чітку та чисту картинку.\r\n\r\nКласичний дизайн\r\nGalaxy A03 поєднує класичний витриманий стиль та зручність використання. Оригінальна текстура корпусу має підвищену стійкість до подряпин і забезпечує надійний хват в руці.\r\n\r\nДивися на світ під різним кутом з подвійною камерою\r\nЗнімайте яскраві та красиві фотографії на основну 48-мегапіксельну камеру Galaxy A03. Додаткова 2 МП камера із датчиком глибини допоможе сфокусуватися на головному.\r\n\r\nКамера з датчиком глибини\r\nСпеціальна камера з глибиною різкості, що настроюється, дозволить сфокусуватися на головному об'єкті (люди, тварини, улюблена страва) і отримати приголомшливий знімок з регульованим ефектом розмиття.\r\n\r\nФронтальна камера для стильних селфі\r\nРоби яскраві селфі знімки з ефектом боці на фронтальну 5 МП камеру. Менше фону, більше за тебе.\r\n\r\nЗвук у новому вимірі з Dolby Atmos\r\nПідключи навушники та насолоджуйся ефектом об'ємного звучання. Технологія Dolby Atmos забезпечить повне занурення та відчуття присутності у самому центрі того, що відбувається.\r\n\r\nЕнергія, щоб рухатися вперед\r\nПотужний акумулятор ємністю 5000 мАг дозволяє грати, виходити в прямий ефір та обмінюватися файлами, не замислюючись про заряд батареї.	mobilnyy_telefon_samsung_a035f_galaxy_a03_4_64gb_red_sm-a035fzrgsek_1323_1696.webp	alexia mell	f	1	Смартфон Samsung	Мобільний телефон Samsung A035F Galaxy A03 4/64GB Red (SM-A035FZKGSEK)			f	
40	4	VU+ DUO 4K SE FBC S\\S2\\SX2	Vu+ DUO 4K SE – новейший спутниковый ресивер Ultra HD 4K под брендом Vu+, немного уступающий по возможностям Vu+ Ultimo 4K. Ресивер DUO 4K SE имеет 1 кардридер и 2 слота CI, поддерживает UHD 4K и HEVC/H.265. Использование программного обеспечения на базе операционной системы Linux предоставляет неограниченные возможности ресиверу. \r\nПроизводитель гарантирует поддержку технологий HDR10 (High Dynamic Range) вместе с HLG (Hybrid Log-Gamma). Благодаря множеству доступных приложений и программного обеспечения с открытым исходным кодом разнообразие и возможности VU+ Duo 4K SE могут быть расширены «без ограничений»\r\n\r\nКлючевые особенности VU+ Duo 4K SE:\r\nВысокопроизводительный процессор Quad Core 1.5 ГГц.\r\nHDMI вход и HDMI выход.\r\nОЗУ: 3ГБ LPDDR4, флеш: 4ГБ eMMC.\r\n2x USB 3.0 (задняя панель) и 1x USB 2.0 (лицевая часть).\r\n3.5” LCD дисплей с Mini TV.\r\nДвойное перекодирование.\r\nСъемный карман для 2.5” HDD.\r\nТехнологии HDR10/HLG.\r\nИнтерфейс 2x Common Interface (CI) и 1x картридер.\r\nVu+ DUO 4K SE входит в семейство ресиверов Ultra HD. В итоге под брендом Vu+ можно купить четыре устройства:\r\nVu+ DUO 4K SE поддерживает новейшие видеоформаты, но в то же время оставляет полную свободу для пользователя, свободу настроек, организацию списка каналов, запись (также HEVC/UHD) и использование любых карт и модулей CAM. Он имеет один кардридер и два слота CI/CI+. Что немаловажно, в случае сокетов CAM - производитель заявляет, что они смогут работать одновременно и независимо расшифровывать потоки, что пока не было возможным.\r\n\r\nБлагодаря наличию двух слотов для новых тюнеров FBC можно создать приемник с очень продвинутыми возможностями, он может одновременно принимать несколько услуг до 16 различных транспондеров/мультиплексов. Базово ресивер комплектуется одним тюнером FBC DVB-S/S2/S2X с двумя сигнальными входами, которые могут передавать сигнал от восьми разных транспондеров. В зависимости от способа подключения они могут даже иметь разные диапазоны и полярности - с преобразователем Unicable II / dCSS. Второй тюнер можно приобрести, как дополнительную опцию. Есть спутниковые тюнера FBC DVB-S/S2/S2X и кабельные тюнера FBC DVB-C (в двух версиях), а также, MTSIF Dual DVB-T/T2 для сигнала эфирного ТВ.\r\n\r\nВозможные комбинации тюнеров:\r\nСлот A: FBC DVB-S2X, FBC DVB-C V1 / V2 lub Dual T2 / C (MTISF)\r\nСлот B: FBC DVB-S2X, FBC DVB-C V2 lub Dual T2 / C (MTISF)\r\nОбратите внимание, что тюнер FBC DVB-C версии V1 можно разместить только в слоте A.\r\n\r\nОтличительной особенностью Vu + DUO 4K SE от конкурентов является чрезвычайно мощный процессор. Vu + Duo 4K - был первый спутниковый ресивер под Linux, тактовая частота процессора которого превышала волшебные 2 ГГц. Тактовая частота процессора Vu+ Duo 4K составляла 2,1 ГГц. Это процессор на архитектуре ARM от производителя Broadcom. В ревизии SE тактовая частота процессора 1,5 ГГц, но ресивер не кажется более медлительным.\r\n\r\nКроме того, пользователю предоставляется 4 ГБ флэш-памяти eMMC (такая же, как в Vu + Ultimo 4K) и 3 ГБ оперативной памяти типа LPDDR4.\r\n\r\nПоддерживаемые форматы видео:\r\nРазрешение видео: 576p, 720p, 1080i, 1080p, 2160p.\r\nДекодирование видео: H.264/MPEG-4 AVC MVC, H.265/HEVC MP.\r\nОснащение VU+ Duo 4K SE UHDTV\r\nФронтальная панель:\r\n3.5" LCD-цветной дисплей.\r\n1x USB 2.0 разъем.\r\n2x CI-слота.\r\n1x картридер.\r\n5x сенсорных клавиш (Вкл./Выкл., CH+/-, VOL +/-)\r\nТыльная сторона:слот под 2x Plug&Play Dual FBC DVB-S2x тюнер и FBC DVB-C/T2 тюнер.\r\n1x Plug&Play Dual FBC DVB-S2x тюнер и 1x FBC DVB-C/T2 тюнер.\r\nцифровой видео/аудио выход HDMI 2.0.\r\nвидео/аудио вход HDMI 2.0.\r\nоптический цифровой аудио выход SPDIF.\r\nслот под HDD 2.5".\r\n2 разъема USB 3.0.\r\nгигабитный Ethernet порт.\r\nсервисный разъем RS-232.\r\nСреди других важных особенностей, помимо уже упомянутых двух слотов для сменных тюнеров FBC, одного кардридера и двух слотов для модулей CAM CI/CI +, стоит также отметить современный цветной ЖК-дисплей 3,5 с функцией Mini TV. Он чуть меньше по размеру, чем в Ultimo 4K – там дисплей 4". Также отметим наличие 3 портов USB, в том числе два в версии 3.0 и один 2.0, входа и выхода HDMI 2.0, встроенной поддержки гигабитного Ethernet, беспроводного Wi-Fi и Bluetooth, а также программная поддержка HbbTV.\r\nВ спутниковом ресивере предусмотрена возможность подключения жесткого диска 2,5" в корпус путем установки его в специальный выдвижной карман. Такое решение делает простой и быстрой установку жесткого диска.\r\nПитание ресивера:\r\nНапряжение сети: 100-240В/50-60 Гц/1.5А.\r\nВыход: 12В/5.0А.\r\nПотребляемая мощность: \r\n- В рабочем состоянии: 15Вт, \r\n- Спящий режим: 0.5Вт.	media/Vu_DUO_4K_SE_k4sfncb.jpg	alexia mell	f	58	Спутниковый ресивер Vu+ DUO 4K SE	Vu+ DUO 4K SE – новейший спутниковый ресивер Ultra HD 4K	media/Vu_DUO_4K_SE1_4QCGu1l.jpg	media/Vu_DUO_4K_SE2_zciUJdt.jpg	t	not_photo3.jpeg
14	1	Сонячна міні станція для зарядки телефонів Sanlarix MINI 50W	Сонячна станція MINI в комплекті з сонячною батареєю 50W та 2-ма окремими світильники призначена для внутрішнього і зовнішнього використання\r\n\r\nЗа допомогою цієї системи можна освітлити приміщення, дачі, вагончики, кемпінг де відсутня електроенергія. Сонячна батарея монтується ззовні і має 5 метрів кабелю до зарядного блоку. Лампи освітлення з'єднюються з блоком окремим штекерами і мають окремі виключателі. Кожна лампочка є автономною, ви можете включити всього 1 з 2-ох лампочок.\r\n\r\nПанель заряджає акумулятор за 2 години.\r\n\r\nДана станція зможе зарядити до 10 телефонів від повного заряду.\r\n\r\nВи можете заряджати будь які прилади які підключаються через USB.\r\n\r\nТака установка є найнеобхіднішим рішенням для підтримання зв'язку та автономного освітлення при наявній ситуації в нашій державі!\r\n\r\nДана станція виготовляється в Україні і на відміну від китайських аналогів є надійною та ефективною!\r\n\r\nВона може заряджати 4 пристої одночасно.\r\n\r\nПри виборі такого присторою звертайте увагу на потужність сонячної панелі. Для ефективної зарядки телефонів, павербанків, рацій і дронів сонячна панель повинна бути не меншою ніж 20W. Китайські аналалоги мають від 6 - 12W, що дозволяє заряджати 1 телефон від сонячної погоди за 6 - 8 годин.\r\n\r\nТакож варто звернути увагу, що це не просто сонячна панель, яка заряджає пристої на пряму. Від цієї станції можна заряджатись вночі, або користуватись резервним освітленням.\r\n\r\nХарактеристики:\r\n\r\nСонячна панель 50W (67х54см)\r\n\r\nЗарядний блок 23х13х10см\r\n\r\nКабель від сонячної панелі до блоку 5 метрів\r\n\r\nАкумулятор 108Wh\r\n\r\nРозетка на автоприкурювач 12V\r\n\r\nЛампочки 2шт по 7W 480lm\r\n\r\nКабелі до ламп освітлення 2 шт по 5 та 3 метрів\r\n\r\nВиходи USB 2шт 2A, 2шт 1А\r\n\r\nВироблено в Україні. Гарантія 1 рік на весь комплект.	media/292605758.jpg	alexia mell	t	26	Сонячна міні станція	Сонячна станція MINI в комплекті з сонячною батареєю 50W та 2-ма окремими світильники призначена для внутрішнього і зовнішнього використання	media/not_photo1.jpeg	media/not_photo2.jpeg	f	media/not_photo3.jpeg
2	1	SC 2 EasyFix 15120500	Пароочиститель SC 2 EasyFix Premium очищает практически все твердые поверхности в доме без применения химических средств. Пароочиститель Керхер удаляет стойкие загрязнения, известняковые отложения и жировые пятна. Тщательная очистка паровым очистителем Kärcher убивает 99,99% всех известных бытовых бактерий на твердых поверхностях в доме. Новая насадка для пола EasyFix снабжена застежкой-липучкой, позволяющей закреплять микроволоконные салфетки, не наклоняясь к полу – достаточно просто прижать насадку к салфетке. После окончания работы салфетка удаляется без контакта с грязью – надо лишь наступить на ее язычок и приподнять насадку.	d1.jpg	alexia mell	f	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	Пароочиститель SC 2 EasyFix – компактный пароочиститель начального уровня, обладающий в то же время			f	
7	4	Dreambox DM900 Ultra HD	Характеристики Dreambox DM900 Ultra HD\r\nРазмеры вес цвет:\t270 х 187 х 60 (Ш х Г х В) 3 кг\r\nГарантия мес:\t12\r\nДисплей:\t3" TFT OLED цветной.\r\nРодительский контроль:\tесть\r\nВстроенный модуль условного доступа:\t1-х\r\nСлот для модуля условного доступа:\t1-х\r\nВнешние интерфейсы:\t1-Х USB 3.0/Ethernet 1GB /HDMI 2.0/HDMI In, Service MicroUSB/ S/PDIF\r\nRF-модулятор:\tнет\r\nПоддержка протоколов DiSEqC:\t1.0,1.1, 1.2, 1.3, 1.4 USALS\r\nEPG электронный путеводитель программ:\tесть\r\nФункция PVR и TimeShift:\tесть\r\nВоспроизведение мультимедиа файлов:\tJPG, BMP, GIF, MP3, OGG, WAV, FLAC, 3GP, MP4, MOV, MPG, TS, M2TS, DAT, VOB, WMA, AVI, MKV\r\nПоддержка USB Wi-Fi адаптера:\tUSB Wi-Fi адаптер\r\nПроцессор:\tBroadcom BCM7252, 10.500 DMIPS Dual-Core Prozessor\r\nСтандарты цифрового ТВ:\tDVB-S / DVB-S2 -2х\r\nОперативная память:\t2 Гб\r\nФлэш-память:\t4 Гб\r\nОперационная система:\tLinux открытая оболочка Enigma2\r\nРежимы отображения:\t2160р-1080p-1080i-720p-576p-480p-576i-480i\r\nДополнительно:\tблок питания Внешний 12V/5A, HDD Возможно установить 2.5".	5880a47d4770b.jpeg	alexia mell	t	15	Спутниковый UHDTV ресивер	Linux открытая оболочка Enigma2			f	
10	4	VU + ZERO 4K	Характеристики VU + ZERO 4K\r\nРазмеры вес цвет:\t135 x 105 x 45 mm/черный\r\nГарантия мес:\t24\r\nДисплей:\tнет\r\nРодительский контроль:\tесть\r\nВстроенный модуль условного доступа:\t1x Smart Card\r\nСлот для модуля условного доступа:\t1х (CI + Программно)\r\nВнешние интерфейсы:\t1-Х USB 2.0/HDMI 2.0/Ethernet 10/100 Mbit / RS-232/ Вход ИК приемника\r\nRF-модулятор:\tнет\r\nПоддержка протоколов DiSEqC:\t1.0, 1.1, 1.2, USALS\r\nEPG электронный путеводитель программ:\tесть\r\nФункция PVR и TimeShift:\tесть\r\nВоспроизведение мультимедиа файлов:\tH.264, AC3, LPCM, LC-AAC, AAC, MP3, XVID, DivX, PG, BMP, GIF, MP3, OGG, WAV, FLAC, 3GP, MP4, MOV, MPG, TS, M2TS, DAT, VOB, WMA, AVI, MKV\r\nПоддержка USB Wi-Fi адаптера:\tесть\r\nПроцессор:\tDual Core 7000DMIPS\r\nСтандарты цифрового ТВ:\t1x DVB-S2X\r\nОперативная память:\t1GB DDR4\r\nФлэш-память:\t4GB EMMC\r\nОперационная система:\tLinux Enigma2\r\nРежимы отображения:\t3840- 2160p-1080p-1080i-720p-576p-480p-576i-480i	5a5f0c34d61ce_mRjaeip.jpeg	alexia mell	t	21	Спутниковый UHDTV ресивер Vu zero 4k	Linux Enigma2			f	
30	4	4K телевизор Samsung SmartTV 42"107см+Bluetooth UHDTV,LED IPTV(С	Телевизор Samsung  - это не только средство для просмотра ТВ-программ, но и целый развлекательный комплекс. Он может послужить в качестве монитора для игровых приставок или, к примеру, просмотра фотографий. Это устройство полностью изменит ваше представление о просмотре различного контента! \r\n\r\nЦените качественное изображение и чистый звук? Smart Телевизор Samsung 42 дюйма c реалистичной цветопередачей порадует вас яркой и детализированной картинкой!\r\n\r\nУвидьте мир таким, какой он есть!\r\nВстроенный тюнер DVB-T2 позволит проводить свободные вечера от работы за просмотром каналов цифрового телевещания. На коммуникационной панели находятся такие современные интерфейсы как USB, HDMI, антенный вход (RF), аудиовыход для наушников и прочие.\r\n\r\nЕще одним преимуществом этого телевизора является технология ConnectShare Movie с помощью которой вы можете просто подключить USB-накопитель или внешний жесткий диск к телевизору и наслаждаться просмотром фильмов и фотографий или прослушиванием музыки. \r\n\r\nТехнология Samsung Wide Color Enhancer Plus использует разработанный специалистами Samsung алгоритм обработки цвета, благодаря которому качество изображения существенно улучшается. При этом становятся различимыми даже такие цветовые оттенки, которые на обычных телевизорах просто не воспроизводятся.\r\n\r\nТелевизор Samsung это самостоятельная и умная техника которая скрасит Ваши будни яркими красками!!\r\n\r\nДанный телевизор оснащен технологией Smart TV + Т2 и имеет высокое качество картинки, а сборка сделана на высоком уровне. Также на задней панели выведены все возможные, и необходимые слоты, и разъемы.	media/samsung.webp	alexia mell	t	43	4K телевизор Samsung SmartTV 42"107см+Bluetooth	Телевизор Samsung  - это не только средство для просмотра ТВ-программ, но и целый развлекательный комплекс. Он может послужить в качестве монитора для игровых приставок или, к примеру, просмотра фотографий. Это устройство полностью изменит ваше предс	media/samsung1.webp	media/samsung2.webp	f	media/samsung3.webp
43	2	Трусики-стрінги Victorias Secret 815663738 XS Червоні	Один з найпопулярніших різновидів жіночої спідньої білизни — це стринги. Вони зручні, практичні та максимально непомітні під одягом. Крім того, жінка в них має сексуальний і жаданою. Тому в багатьох готових комплектах еротичної білизни є такий предмет жіночого гардероба, як трусики-стринги.\n\nСтринги: особливості та переваги\nСтринги — відкрита сексуальна білизна, що складається з невеликого трикутника спереду та вузької смужки ззаду. Такий фасон білизни ідеально підкреслює всі принади жіночого тіла. До інших переваг стрингів треба зарахувати:\n\nщільно прилягають до тіла, тому можна носити з будь-яким вбранням, зокрема й обтислим;\nвиготовлені з якісних, приємних на дотик і повітропроникних матеріалів;\nпрактично не відчуваються під час носіння, не викликають відчуття дискомфорту;\nулітку в таких трусиках не буде жарко.\nАле, попри всі переваги, така білизна має і свої вади:\n\nнеправильно дібраний розмір призводить до натирання і подразнення;\nстринги не підтримують сідниці, а отже, їхня форма під одягом буде мати менш привабливий вигляд;\nрегулярне використання відкритої білизни може стати причиною виникнення різних інфекцій.\nТому носити мінітруси рекомендується тільки в особливих випадках і не більш ніж 7—9 годин на день.\n\nЯка модель підійде саме вам\nПерш ніж купити стринги, рекомендуємо ознайомитися з усім асортиментом спідньої білизни, представленим в продажу на сайті ROZETKA:\n\nG-подібні: є два невеликих шматочки тканини трикутної форми, розташованих спереду та ззаду, які скріплені між собою тонкими мотузками;\nТ-подібні: по суті, це міністринги, які складаються з невеликого трикутника, розташованого спереду, і трьох мотузочок ззаду, що перетинаються між собою;\nV-подібні: ідентичні моделі G, але тільки трикутні вставки в таких стрингах складаються з мотузок, а не шматка тканини;\nС-подібні: революційна модель трусиків, які не мають бічних мотузок; а тримається така білизна завдяки жорсткому каркасу.\nЄ також і бразильський варіант стрингів, у якому задня трикутна вставка прикриває основну частину сідниць. А називаються такі труси чикибоксери.\n\nПоради та рекомендації\nЩоб вибрана вами модель підійшла за всіма параметрами, під час купування стрингів рекомендуємо враховувати такі нюанси:\n\nвіддавайте перевагу білизні з натуральних повітропроникних матеріалів;\nдля повсякденного використання підійдуть бавовняні вироби, для активного відпочинку — спеціальні спортивні моделі з трикотажу, а для особливих випадків — мереживні, атласні, ажурні або прозорі в сіточку;\nдівчатам із чутливою шкірою найкраще носити безшовні трусики, а з невеликим животиком — стягувальні моделі з високою посадкою.\nводночас труси мають бути дібрані чітко за розміром. В іншому разі вони будуть впиватися в шкіру, порушуючи в такий спосіб кровообіг. На сайті ROZETKA представлена красива жіноча білизна як стандартних (S, M, L), так і великих розмірів (XL, 2XL, 3XL) від відомих виробників (Мілавіца, Атлантик, H&M, Calvin Klein, Victorias Secret, Donella та ін.). Тому кожна покупниця зможе дібрати собі модель за розміром.\n\nЩо стосується колірної палітри та зовнішнього оформлення, то й тут виробники не стоять на місці. Крім однотонних трусів (червоні, чорні, білі, сині, бежеві), на сайті ROZETKA можна замовити стильну леопардову білизну, а також стринги в смужку, карту, горошок, з бантиком або зі стразами.	media/redstrings.webp	alexia mell	t	89	Трусики-стрінги Victorias	Один з найпопулярніших різновидів жіночої спідньої білизни — це стринги. Вони зручні, практичні та максимально непомітні під одягом. Крім того, жінка в них має сексуальний і жаданою. Тому в багатьох готових комплектах еротичної білизни є такий предмет жіночого гардероба, як трусики-стринги.	media/redstrings1.webp	media/redstrings2.webp	\N	media/redstrings3.webp
12	1	Набор электроинструментов, 41х33х11 см TV-magazin однотонные чёр	Дрель ударная 1100 Вт. Предназначена для бурения отверстий от 1,5 до 13 мм в древесине, металле, бетоне, пластмассах и др. Инструмент также используется для легкой фрезерной и шлифовальной обработки древесины, металла, композиционных пластмасс с помощью фрез и шлифовальных насадок. Электрический лобзик 950 Вт. Лобзиковая пила используется для распиливания поверхностей из дерева, тонкого стального листа, алюминия, композиционного многослаойного пластика, а также мягких и тонких строительных материалов. Максимальная толщина материалов: сталь - 6 мм, алюминий - 15 мм, древесина/пластмасса - 55 мм. Угловая шлифовальная машина 1200 Вт. УШМ используется для сухой поперечной распиловки и сухой шлифовки металла и камня. Максимальный диаметр диска - 115 мм. Не допускается использование инструмента при работе с водой. Обратите внимание: набор инструментов предназначен только для домашнего пользования и не должен быть использован в промышленном производстве. Дрель: напряжение: 220-230 В (50 Гц). Мощность: 1100 Вт. Число оборотов: 0-2500 об./мин.. Диаметр сверла: от 1,5 до 13 мм. Вес: 1,2 кг. \r\nЛобзик: напряжение: 220-230 В (50 Гц). Мощность: 950 Вт. Число оборотов: 0-3000 об./мин.. Макс. глубина пропила: 55 мм. Вес: 1,2 кг. \r\nУШМ: напряжение: 220-230 В (50 Гц). Мощность: 1200 Вт. Число оборотов: 11000 об./мин.. Диаметр диска: 115 мм. Диаметр шпинделя: 22 мм. Вес: 1 кг. \r\nУпаковка: пластиковый кейс. Размеры в упаковке: 41х33х11 см. Вес в упаковке: 5 кг. Комплектация: дрель ударная, электролобзик, УШМ, запасные угольные щетки - 3 шт.. Для дрели: опорная ручка, ключ, линейка, сверла - 9 шт., биты - 6 шт., удлинитель, шлифовальные камни - 4 шт.. Для УШМ: опорная ручка, ключ, кожух, шлифовальный диск 115 мм; Для лобзика: шестигранник 3 мм и пилка 55 мм по металлу, рулетка 2 м, канцелярский нож, перчатки хозяйственные; кейс, 3 инструкции на русском языке.	92edc9319b64fd8e3f725abfb4861e52.png	alexia mell	t	23	Набор электроинструментов	Дрель ударная 1100 Вт. Предназначена для бурения отверстий от 1,5 до 13 мм в древесине, металле, бетоне, пластмассах и др. Инструмент			f	
4	2	Legend Essential 2 CQ9356 034 Чорний	Виробник: Nike\r\nСпорт: Тренування / Фітнес\r\nКолір: Чорний\r\nКолір зазначений виробником: Black/Racer Blue/Obsidian\r\nВид застібки: На шнурках\r\nВид носка: Круглий\r\nТип каблука: Плаский\r\nІнше: Шнурівки з тканини\r\nМОДЕЛЬ І РОЗМІР\r\nТовщина підошви: 3 cm\r\nЗагальна висота взуття: 11 cm\r\nВага взуття (найменший розмір): 216 g	nike-vzuttia-legend-essential-2-cq9356-034-chornii.webp	alexia mell	t	4	Спортивне взуття Nike	Взуття Legend Essential 2 CQ9356 034 Чорний			f	
11	4	VU + UNO 4K SE 1X DUAL FBC-S/S2/S2X	Характеристики VU + UNO 4K SE 1X DUAL FBC-S/S2/S2X\r\nРазмеры вес цвет:\tчерный\r\nГарантия мес:\t24\r\nДисплей:\t2.4" LCD for MiniTV\r\nРодительский контроль:\tесть\r\nВстроенный модуль условного доступа:\t1х\r\nСлот для модуля условного доступа:\t1x\r\nВнешние интерфейсы:\t2-Х USB 3.0 /Ethernet 1GB /HDMI in 2.0 /HDMI out 2.0/ S/PDIF/RS-232/ATA-SATA\r\nRF-модулятор:\tнет\r\nПоддержка протоколов DiSEqC:\t1.0 1.1 1.2 1.3 и USALS\r\nEPG электронный путеводитель программ:\tесть\r\nФункция PVR и TimeShift:\tесть\r\nВоспроизведение мультимедиа файлов:\tH.264, H.265.AC3, LPCM, LC-AAC, AAC, MP3, XVID, DivX, PG, BMP, GIF, MP3, OGG, WAV, FLAC, 3GP, MP4, MOV, MPG, TS, M2TS, DAT, VOB, WMA, AVI, MKV\r\nПоддержка USB Wi-Fi адаптера:\tесть\r\nПроцессор:\tDual Core 1.7GHz\r\nСтандарты цифрового ТВ:\t1x Advanced Pluggable Tuner System for Dual DVB-S2/S2X или FBC DVB-C, или Dual DVB-T2\r\nОперативная память:\t4GB eMMC\r\nФлэш-память:\t2GB DDR4\r\nОперационная система:\tLinux Enigma2\r\nРежимы отображения:\t2160р HD 4K-1080p-1080i-720p-576p-480p-576i-480i	VU_uno_se_4k.jpeg	alexia mell	t	22	VU + UNO 4K	Внешние интерфейсы: 2-Х USB 3.0 /Ethernet 1GB /HDMI in 2.0 /HDMI out 2.0/ S/PDIF/RS-232/ATA-SATA	media/vu1.jpeg	media/vu2.jpeg	f	media/vu3.png
3	4	AX 4k-box-hd61-combo	Комбинированный ресивер AX 4K-BOX HD61 Combo (DVB-S2X+DVBT2/C) - новинка 2020 года, идущая на смену AX 4K-BOX HD51. Новый комбо-ресивер оснащен гибридным тюнером DVB-S2 / DVB-S2X / DVB-C / DVB-T2 HEVC H.265. Новый продукт AX Technology из семейства 4K основан на операционной системе Linux Enigma2. Опция Multiboot позволяет загружать 4 независимых дистрибутива Linux. AX 4K-BOX HD61 COMBO дает возможность приема всех видов телевидения: спутникового, кабельного и эфирного в новейшем стандарте T2 H.265. Ключевое преимущество новой модели - 1x универсальный картридер и 2 входа для модулей CI +. Передняя панель выполнена из пластика с лаковой поверхностью, в левой части расположена кнопка STANDBY. Она имеет светодиодную подсветку, а рядом расположен 4-х разрядный 7-сегментный светодиодный LED дисплей. В правой части лицевой панели присутствует скрытая открывающаяся панель, под которой расположено два слота Common Interface под CAM модули. Также там виден один слот SmartCard под карты условного доступа. Ресивер поддерживает работу с модулями шифрования CI+, провайдеров XTRA TV CI+ Verimatrix, НТВ+ Viaccess и Триколор DRECrypt. Рядом расположены разъемы для накопителей памяти USB стандарта 2.0 и разъем для чтения карты памяти MicroSD. Тыльная сторона содержит все необходимые разъемы для подключения к антенне, сети Интернет и ТВ. По умолчанию AX 4K-BOX HD61  комплектуется приемной базой в виде встроенного на постоянной основе DVB-S2X спутникового тюнера. Также расположенного над ним съемного Plug&Play эфирного-кабельного тюнера DVB-T/T2/C. Он построен на базе демодулятора Si2168 от компании Silicon Labs.   Основные характеристики AX 4K-BOX HD61 COMBO:  Процессор: Hisilicon HI3798MV200 ARM Cortex A53 Quad core 4x 1.6Ghz Операционная система: Linux 3.x (Enigma2) ОЗУ: 2Гб DDR4 Тюнер: 1 DVB-S2X + 1 DVB-T2/C Флеш-память: 8GB eMMC ОЗУ: 2GB DDR4 RS232: 1 (External IR Sensor) HDMI In: 1 (2.0a) Ethernet: 100 Мбит/с USB: 2x USB 2.0 SPDIF: Optical HDD: HDD (2.5") - до 4 ТБ Поддержка Cl Plus (CI+): Программная Common Interface: 2x Common Interface Картоприемник: 1x Smart Card\r\n\r\nhttps://4tv.in.ua/ax-4k-box-hd61-combo	103391_image.jpg	alexia mell	t	3	Спутниковый ресивер AX 4K-BOX HD61 COMBO	AX 4K-BOX HD61 Combo  https://4tv.in.ua/ax-4k-box-hd61-combo			f	
13	2	Черные демисезонные мужские No Brand Кроссовки	Кроссовки мужские. Черная экокожа.\r\nХарактеристики\r\nАртикул товара\t252265280\r\nПринадлежность\tМужчинам\r\nСезонность\tДемисезон\r\nЦвет\tЧерный\r\nСостав\tЗаменители Кожи И Текстиль\r\nСостав верха\tИскусственная кожа\r\nСтиль\tКэжуал\r\nУзор\tОднотонный\r\nСтрана производства\tКитай\r\nВес в упаковке, кг\t0.7 кг	media/f9f4ba083d9df031899508d7d56c31f0.png	alexia mell	t	24	Черные демисезонные мужские No Brand Кроссовки	Кроссовки мужские. Черная экокожа.			f	
8	3	Keel toys Рыжий котенок 32 см	Оригинальный котёнок от торговой марки Keel Toys станет ребёнку другом и компаньоном во всех играх. Реалистичное исполнение делает его полной копией настоящего животного. Игра с котёнком способствует развитию тактильных навыков, мелкой моторики, воображения и творческих способностей. Котёнок изготовлен из мягкого и пушистого плюша с наполнением из синтепона. Игрушка не теряет форму и сохраняет внешний вид даже при активной эксплуатации. Котёнка можно стирать на деликатном режиме. Размер игрушки составляет 32 см, что позволяет везде брать её с собой. Рекомендованный возраст — от 3-х лет.	cat.jpg	alexia mell	t	16	Мягкая игрушка кот Котя	Мягкая игрушка Keel toys Рыжий котенок 32 см (SC2647)			f	
\.


--
-- Data for Name: auctions_auction_commet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auctions_auction_commet (id, auction_id, comments_id) FROM stdin;
\.


--
-- Data for Name: auctions_bid; Type: TABLE DATA; Schema: public; Owner: auctions_user
--

COPY public.auctions_bid (id, author_bid, date_bid, bid) FROM stdin;
2	igor	2022-11-07 06:58:55.078766+00	6099
3	igor	2022-10-14 05:49:28.696562+00	6102
4	igor2022	2022-10-14 06:02:50.56236+00	2594
5	igor	2022-11-06 10:36:29.916026+00	6
6	igor	2022-11-06 10:41:32.209623+00	1
7	igor	2022-11-06 10:45:49.051372+00	1
8	igor	2022-11-06 10:47:13.107435+00	1
9	igor	2022-11-06 11:17:30.419694+00	2
10	igor	2022-11-06 11:19:43.835983+00	4
12	igor	2022-11-06 12:06:30.853111+00	1
13	igor	2022-11-06 12:52:47.882986+00	7500
14	igor	2022-11-06 12:53:32.829062+00	7500
15	igor	2022-11-06 13:05:37.529427+00	8636
17	igor	2022-11-06 16:27:59.672909+00	4261
18	igor	2022-11-06 16:28:54.015578+00	4261
19	igor	2022-11-06 16:31:36.330619+00	4261
20	igor	2022-11-06 16:33:53.807371+00	4261
21	igor	2022-11-06 16:34:46.23756+00	4261
23	igor2022	2022-11-06 18:27:30.846136+00	2550
24	igor	2022-11-06 18:41:01.538475+00	821
25	Alexa Mell	2022-11-07 09:29:30.376952+00	33
26	igor	2022-11-09 17:46:53.876233+00	8752
27	igor	2022-11-18 16:13:58.659711+00	445
28	igor	2022-11-18 16:33:57.486331+00	9
29	igor	2022-11-18 16:49:30.706588+00	8
30	igor	2022-11-18 17:00:01.764275+00	3
31	igor	2022-11-18 17:07:28.921902+00	1
32	igor	2022-11-18 17:14:49.596938+00	2
33	igor	2022-11-18 17:32:21.291009+00	3
34	igor	2022-11-18 19:55:03.309453+00	0
35	igor	2022-11-19 07:22:08.682954+00	0
36	igor	2022-11-19 07:59:39.154257+00	9
37	igor	2022-11-19 08:37:33.553439+00	9
38	igor	2022-11-19 08:44:17.329203+00	-8
39	igor	2022-11-19 08:58:11.631308+00	1
40	igor	2022-11-19 10:03:05.551549+00	3
41	igor	2022-11-19 10:06:51.332914+00	4
42	igor	2022-11-19 10:07:31.954291+00	4
43	igor	2022-11-19 12:37:56.881728+00	7400
44	igor	2022-11-27 13:00:30.865192+00	3001
45	igor	2022-11-30 14:36:50.076325+00	3
46	igor	2022-11-30 14:42:40.038476+00	100
47	igor	2022-11-30 14:56:53.027215+00	234
48	igor	2022-11-30 15:03:00.748807+00	20
49	igor	2022-12-01 07:59:11.651389+00	0
50	igor	2022-12-01 09:15:59.361766+00	1
51	igor	2022-12-01 09:19:08.809236+00	339
52	igor	2022-12-01 11:57:02.349454+00	77
53	igor	2022-12-01 13:33:59.958437+00	33
54	igor	2022-12-01 13:35:34.315143+00	5
55	igor	2022-12-01 13:45:06.551044+00	55
56	igor	2022-12-01 13:48:57.493153+00	150
57	igor2022	2022-12-01 17:27:18.28019+00	44
58	igor	2022-12-01 17:42:22.071408+00	13800
59	igor	2022-12-04 10:59:13.92856+00	100
60	igor	2022-12-04 12:09:51.948612+00	5
61	igor	2022-12-04 14:30:00.220898+00	1
62	igor	2022-12-04 14:37:50.304996+00	4
63	igor	2022-12-04 14:40:28.662434+00	299
64	igor	2022-12-04 15:31:39.130508+00	233
65	igor	2022-12-04 15:45:27.125481+00	300
66	igor	2022-12-04 15:50:02.381729+00	34
67	igor	2022-12-04 15:55:02.901816+00	388
68	igor	2022-12-04 16:15:42.099867+00	299
69	igor	2022-12-04 16:18:49.408403+00	399
70	igor	2022-12-04 16:27:15.928735+00	208
71	igor	2022-12-04 16:32:23.527988+00	2
72	igor	2022-12-05 07:40:39.034188+00	20
73	igor	2022-12-05 09:37:24.36305+00	37
74	igor	2022-12-05 09:47:32.29703+00	35
75	igor	2022-12-05 09:56:52.247962+00	37
76	igor	2022-12-05 10:02:18.657841+00	37
77	igor	2022-12-05 11:38:28.468894+00	37
78	igor	2022-12-05 11:44:07.405645+00	37
79	igor	2022-12-05 11:49:58.937148+00	38
80	igor	2022-12-05 11:56:20.321253+00	13600
81	igor	2022-12-05 12:04:43.451502+00	100
82	igor	2022-12-05 12:09:05.774526+00	16500
83	igor	2022-12-05 12:22:22.151242+00	5799
84	igor	2022-12-05 13:30:01.062282+00	2
85	igor	2022-12-09 11:46:58.167147+00	150
86	igor	2022-12-12 15:37:00.485223+00	13567
87	igor2022	2022-12-12 15:48:02.56798+00	57999
88	igor	2022-12-12 16:06:12.571345+00	6999
22	igor	2022-11-06 16:50:07.223255+00	7805
11	igor	2022-11-06 12:05:25.942419+00	7800
1	igor	2022-10-15 15:58:19.737469+00	5799
89	alexa mell	2023-01-17 22:39:30.654236+00	441
16	igor2022	2022-11-06 15:48:52.810018+00	870
\.


--
-- Data for Name: auctions_category; Type: TABLE DATA; Schema: public; Owner: auctions_user
--

COPY public.auctions_category (id, name) FROM stdin;
1	For home
2	Fashion
3	Toys
4	Electronics
\.


--
-- Data for Name: auctions_comments; Type: TABLE DATA; Schema: public; Owner: auctions_user
--

COPY public.auctions_comments (id, auction_name, comments, author_comments, date_comm) FROM stdin;
10	Смартфон Samsung	Телефон подарували мамі на ювілей. Для неї у цьому телефоні є все і навіть більше) Освоїла його за 2 дні, зараз користується і дуже задоволена)	igor	2022-10-18 08:39:54.261224+00
11	Смартфон Samsung	Отличный бюджетник. Экран сочный и яркий не смотря не на самое большое разрешение. Работает шустро. Все приложения открывает быстро. Не сложный в обращении. Как за такую цену отличный, даже нормальные игрушки идут. Ребенку или для пожилого супер или для работы, да и не только. Батарею держит отлично.	igor	2022-10-18 10:35:29.655821+00
12	Смартфон Samsung	Конечно после Xiaomi 11 Light 5G NE и 4к камеры и 6/128, этот смартфон Samsung Gaqlaxy A03 4/64 - слабее. Но, что интересно экран PLS у самсунга очень четкий, намного четче Full-HD+ IPS у Xiaomi как просто экран. Я удивился. Звук хотелось бы громче, но и этого достаточно. Но, на период войны пойдет, потом куплю с крутой камерой.	igor2022	2022-10-18 10:50:14.906636+00
13	Смартфон Samsung	Смартфон как смартфон.\r\nБрал в качестве рабочего на две карты.\r\nНеплохая производительность.\r\nЛюблю Самсунги.\r\nХорошая цена.\r\nПо такой цене трудно кроме китайца найти смарт 6,5 дюйма, 6/64.\r\nИ не плохим процессором.	Alexa Mell	2022-10-18 11:07:42.043593+00
14	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	Купил в понедельник этот парогенератор спасибо менеджеру который перезвонил и дал консультацию, у меня была SC 4 , но не хотел за аппарат которым буду пользоваться дома переплачивать в 2 раза , консультацию получил. Аппарат в работе от 4 ничем не отличается только в начале скоростью нагрева в работе недостачи пара нет. Доволен очень спасибо ребятам быстро выписали счет платил по безналу , доставка была вовремя.	igor	2022-10-18 11:34:30.017618+00
15	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	Пользуемся уже более года - отлично подходит для чистки ВСЕГО.\r\nВ буквальном смысле - все что вас окружает в доме (кроме того, что само двигается или цветет ;) ) можно почистить или продезинфицировать!\r\nОбязательно советуем купить насадки для текстиля и для окон - не пожалеете.\r\nИногда не хватает объёма бака (при объёмных уборках) - нужно ждать пока остынет чтобы долить воду, но вроде в старших моделях можно доливать воду в процессе уборки. Если у вас большие площади - учитывайте этот момент.	Alexa Mell	2022-10-18 11:36:46.795756+00
16	Смартфон Samsung	Смартфон как смартфон.	igor2022	2022-11-07 10:51:12.92088+00
17	Сонячна міні станція	Залиште свій відгук про цей товар\r\nНаписати відгук\r\n\r\nФільтри\r\n\r\nВід тих, хто купив цей товар\r\nСкасувати\r\nПродавець: Жорна\r\nРоман\r\nсьогодні\r\n\r\nПродавець:\r\nЖорна\r\nКлассная зарядная станция, выполнена из качественных материалов, компактная, удобная, с удобными тумблерами и выпуклыми наклейками\r\n\r\nПриехала включённой, заряд полный без одной палочки.\r\n\r\nПанель хорошая, с нормальной алюминиевой рамой. Местами заметен силиконовый клей внутри, там где склеена рама с панелью, но на общую картину не влияеет.\r\n\r\nОчень не хватает переходника в комплекте на type-c, либо type-c портов в самой станции\r\n\r\nЗаряжать от солнца пока не пробовал\r\n\r\nВ первый же день эксплуатации отвалился длинный провод для лампочки, не критично но не приятно. Короткий провод работает, длинный больше не работает.\r\n\r\nПереваги:\r\nКачественная, удобная, компактная\r\nНедоліки:\r\nДлинный провод для лампы не работает	igor2022	2022-11-09 17:48:35.775425+00
18	Мягкая игрушка	Котя хороший кот.	igor	2022-11-14 15:41:28.197094+00
19	VU + UNO 4K	Приобрел тюнер в этом магазине тюнер шикарный спасибо сотрудникам магазина за отличное отношение и работу рекомендую всем	igor2022	2022-11-15 06:35:04.032408+00
20	VU + UNO 4K	Тюнером очень довольна картинка прекрасная настроил универсальный пульт очень удобно.	Alexa Mell	2022-11-15 06:39:10.399765+00
21	VU + UNO 4K	Тюнером очень довольна картинка прекрасная настроил универсальный пульт очень удобно.\r\n\r\nNov. 15, 2022, 10:39 a.m.	igor	2022-11-17 15:19:45.185231+00
22	VU + UNO 4K	Enigma2	igor	2022-11-17 18:20:24.442605+00
23	VU + UNO 4K	Хороший тюнер	igor	2022-12-05 07:45:07.278879+00
\.


--
-- Data for Name: auctions_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auctions_log (name, description, data) FROM stdin;
igor2022	update bid877>870	2023-01-17 00:46:07.292532+02
igor	update bid5806>5807	2023-01-17 19:18:57.141751+00
igor	update bid5807>5807	2023-01-17 19:19:31.919636+00
igor	update bid5807>5799	2023-01-17 20:48:41.41991+00
alexa mell	item addedТрусики-стрінги Victorias Secret 815663738 XS Червоні	2023-01-18 00:29:41.66425+02
alexa mell	update bid441>441	2023-01-17 22:39:30.654236+00
igor2022	update bid870>871	2023-02-02 16:11:03.37217+00
igor2022	update bid871>870	2023-02-02 16:16:21.524965+00
igor2022	update bid870>871	2023-02-02 16:39:20.910706+00
igor2022	update bid871>870	2023-02-02 16:39:56.155633+00
igor2022	update bid870>877	2023-02-02 19:35:41.982875+00
igor2022	update bid877>870	2023-02-02 19:35:52.816456+00
\.


--
-- Data for Name: auctions_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auctions_transaction (id, payment_date, receiver_email, test_ipn, auth_amount, mc_currency, address_country, address_city, address_name, address_street, address_zip, first_name, last_name, payer_email, item_name, txn_id, contact_phone) FROM stdin;
1	2022-12-04 16:16:38+00	sb-nel43b22326328@business.example.com	1	299	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	AX 4k-box-hd61-combo	1YC01693UT653435W	
2	2022-12-04 16:19:26+00	sb-nel43b22326328@business.example.com	1	399	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	SC 2 EasyFix 15120500	7BT77872EK4311433	
3	2022-12-04 16:32:59+00	sb-nel43b22326328@business.example.com	1	2	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	home	7TA1659062045571V	
4	2022-12-05 11:50:42+00	sb-nel43b22326328@business.example.com	1	1.04	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	VU + ZERO 4K	47H04902PE6621830	
5	2022-12-05 12:05:38+00	sb-nel43b22326328@business.example.com	1	2.73	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	test	3J980150AG2570102	
6	2022-12-05 12:09:50+00	sb-nel43b22326328@business.example.com	1	451.21	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	VU + UNO 4K SE 1X DUAL FBC-S/S2/S2X	2WL91976D6426015M	
7	2022-12-05 12:24:39+00	sb-nel43b22326328@business.example.com	1	158.58	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	Samsung Galaxy A03 4/64 GB	0DX27282N2490781N	
8	2022-12-05 13:35:18+00	sb-nel43b22326328@business.example.com	1	0.05	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	test	7NL436516Y3973928	
9	2022-12-12 15:48:46+00	sb-nel43b22326328@business.example.com	1	1586.03	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	Samsung Galaxy A03 4/64 GB	1UX11657CX5570544	
10	2022-12-12 16:06:52+00	sb-nel43b22326328@business.example.com	1	191.39	USD	United States	San Jose	John Doe	1 Main St	95131	John	Doe	sb-fxhik16805497@personal.example.com	VU + ZERO 4Ktes	3SU742577D080272S	
\.


--
-- Data for Name: auctions_user; Type: TABLE DATA; Schema: public; Owner: auctions_user
--

COPY public.auctions_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$390000$xpJjGVA7hvPoTCx4bpauIc$PWYf6GG0Xj6UzhNDQOyj22R5Lsz/qtRHpKc8RcbEb74=	2022-12-12 15:47:08.048207+00	f	igor2022			igor.udovenko2012@meta.ua	f	t	2022-10-06 15:33:41.292549+00
3	pbkdf2_sha256$390000$X1yw6k4a1S1bDPjhA6M4ow$hkz5S5iiaHXQu38AsUiYVBoahKptDM5XqUbdSXH49TA=	2022-10-16 16:23:43.69976+00	f	alexa			alexa.mell2012@meta.ua	f	t	2022-10-16 16:23:42.912541+00
4	pbkdf2_sha256$390000$5WhA3oPHEbz6eBoUSJQJTm$xw5p8uwXqwWtGP4N6FtKaXoLPJhfpa9oIBGsUR2XFVo=	2022-11-15 06:37:57.500291+00	f	Alexa Mell			Alexa.Mell@meta.ua	f	t	2022-10-16 17:15:58.587628+00
2	pbkdf2_sha256$390000$wSD5FC1UHyJpNCMnBGdko5$oZfPc+kOdfduDdmhXDeRQWxZOvoqFZWhKS1e7KwjA3k=	2023-02-18 23:19:10.490449+00	t	igor			igor.udovenko2012@meta.ua	t	t	2022-10-08 16:03:25.948964+00
\.


--
-- Data for Name: auctions_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auctions_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auctions_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auctions_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, content_type_id, codename, name) FROM stdin;
1	1	add_user	Can add user
2	1	change_user	Can change user
3	1	delete_user	Can delete user
4	1	view_user	Can view user
5	2	add_logentry	Can add log entry
6	2	change_logentry	Can change log entry
7	2	delete_logentry	Can delete log entry
8	2	view_logentry	Can view log entry
9	3	add_permission	Can add permission
10	3	change_permission	Can change permission
11	3	delete_permission	Can delete permission
12	3	view_permission	Can view permission
13	4	add_group	Can add group
14	4	change_group	Can change group
15	4	delete_group	Can delete group
16	4	view_group	Can view group
17	5	add_contenttype	Can add content type
18	5	change_contenttype	Can change content type
19	5	delete_contenttype	Can delete content type
20	5	view_contenttype	Can view content type
21	6	add_session	Can add session
22	6	change_session	Can change session
23	6	delete_session	Can delete session
24	6	view_session	Can view session
25	7	add_bid	Can add bid
26	7	change_bid	Can change bid
27	7	delete_bid	Can delete bid
28	7	view_bid	Can view bid
29	8	add_auction	Can add auction
30	8	change_auction	Can change auction
31	8	delete_auction	Can delete auction
32	8	view_auction	Can view auction
33	9	add_comments	Can add comments
34	9	change_comments	Can change comments
35	9	delete_comments	Can delete comments
36	9	view_comments	Can view comments
37	10	add_category	Can add category
38	10	change_category	Can change category
39	10	delete_category	Can delete category
40	10	view_category	Can view category
41	11	add_paypalipn	Can add PayPal IPN
42	11	change_paypalipn	Can change PayPal IPN
43	11	delete_paypalipn	Can delete PayPal IPN
44	11	view_paypalipn	Can view PayPal IPN
45	12	add_transaction	Can add transaction
46	12	change_transaction	Can change transaction
47	12	delete_transaction	Can delete transaction
48	12	view_transaction	Can view transaction
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, object_id, object_repr, action_flag, change_message, content_type_id, user_id, action_time) FROM stdin;
1	1	Category object (1)	1	[{"added": {}}]	10	2	2022-10-08 16:15:21.80602+00
2	2	Category object (2)	1	[{"added": {}}]	10	2	2022-10-08 16:16:08.311298+00
3	3	Category object (3)	1	[{"added": {}}]	10	2	2022-10-08 16:16:41.015752+00
4	4	Category object (4)	1	[{"added": {}}]	10	2	2022-10-08 16:17:11.244881+00
5	1	Bid object (1)	1	[{"added": {}}]	7	2	2022-10-08 16:42:15.706897+00
6	1	5799	2	[{"changed": {"fields": ["Author bid"]}}]	7	2	2022-10-08 16:46:57.565497+00
7	1	Auction object (1)	1	[{"added": {}}]	8	2	2022-10-08 16:55:58.485189+00
8	1	Auction object (1)	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-10-08 16:56:37.198611+00
9	1	Samsung Galaxy A03 4/64 GB	2	[{"changed": {"fields": ["Author auct"]}}]	8	2	2022-10-08 17:01:37.854062+00
10	1	5799	2	[{"changed": {"fields": ["Author bid"]}}]	7	2	2022-10-08 17:02:26.519696+00
11	1	Samsung Galaxy A03 4/64 GB	2	[]	8	2	2022-10-08 17:02:33.205148+00
12	1	Samsung Galaxy A03 4/64 GB	2	[{"changed": {"fields": ["Name"]}}]	8	2	2022-10-09 08:04:42.507972+00
13	1	Смартфон Samsung	2	[{"changed": {"fields": ["Brief descrip"]}}]	8	2	2022-10-09 14:09:03.400498+00
14	2	6099	1	[{"added": {}}]	7	2	2022-10-14 05:18:04.942563+00
15	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	1	[{"added": {}}]	8	2	2022-10-14 05:18:35.699729+00
16	3	5292	1	[{"added": {}}]	7	2	2022-10-14 05:49:28.698612+00
17	3	Спутниковый ресивер AX 4K-BOX HD61 COMBO	1	[{"added": {}}]	8	2	2022-10-14 05:49:39.926789+00
18	4	2609	1	[{"added": {}}]	7	2	2022-10-14 06:02:50.567483+00
19	4	Спортивне взуття Nike	1	[{"added": {}}]	8	2	2022-10-14 06:03:01.663737+00
20	1	5799	2	[{"changed": {"fields": ["Bid"]}}]	7	2	2022-10-15 15:58:19.744957+00
21	4	Спортивне взуття Nike	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-10-16 17:40:31.915958+00
22	1	Смартфон Samsung	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-10-17 10:14:28.722753+00
23	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-10-17 10:14:46.276667+00
24	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-10-17 16:43:30.428305+00
25	9	Comments object (9)	3		9	2	2022-10-18 08:39:16.463631+00
26	8	Comments object (8)	3		9	2	2022-10-18 08:39:16.5241+00
27	7	Comments object (7)	3		9	2	2022-10-18 08:39:16.579281+00
28	6	Comments object (6)	3		9	2	2022-10-18 08:39:16.634554+00
29	5	Comments object (5)	3		9	2	2022-10-18 08:39:16.701004+00
30	4	Comments object (4)	3		9	2	2022-10-18 08:39:16.888696+00
31	3	Comments object (3)	3		9	2	2022-10-18 08:39:16.966782+00
32	2	Comments object (2)	3		9	2	2022-10-18 08:39:17.044967+00
33	1	Comments object (1)	3		9	2	2022-10-18 08:39:17.12179+00
34	2	6099	2	[{"changed": {"fields": ["Bid"]}}]	7	2	2022-10-18 11:32:23.428617+00
35	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-10-18 11:32:28.456974+00
36	3	Спутниковый ресивер AX 4K-BOX HD61 COMBO	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-10-26 12:18:38.011146+00
37	4	Спортивне взуття Nike	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-10-26 12:19:04.590029+00
38	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-11-02 11:55:31.283542+00
39	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-11-02 12:11:32.923149+00
40	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-11-02 12:12:38.363137+00
41	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-11-02 12:14:58.533826+00
42	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-11-02 12:16:00.127429+00
43	5	rm_media	3		8	2	2022-11-06 12:39:59.239166+00
44	6	Dreambox DM900 UHD 4K (2x dvb-s2x / 1x dvb-c/t2)	2	[]	8	2	2022-11-06 12:55:59.133237+00
45	6	Dreambox DM900 UHD 4K (2x dvb-s2x / 1x dvb-c/t2)	3		8	2	2022-11-06 12:57:39.284621+00
46	7	Спутниковый UHDTV ресивер	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-11-06 13:08:35.296768+00
47	8	Мягкая игрушка	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-11-06 15:49:44.717791+00
48	9	Спутниковый UHDTV ресивер Vu zero 4r	3		8	2	2022-11-06 16:35:24.874313+00
49	10	Спутниковый UHDTV ресивер Vu zero 4k	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-11-06 16:36:06.919474+00
50	10	Спутниковый UHDTV ресивер Vu zero 4k	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-11-06 16:43:49.667997+00
51	10	Спутниковый UHDTV ресивер Vu zero 4k	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-11-06 16:44:50.228095+00
52	11	VU + UNO 4K	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-11-06 16:52:02.874415+00
53	12	Набор электроинструментов	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-11-06 18:28:20.65132+00
54	2	6099	2	[{"changed": {"fields": ["Bid"]}}]	7	2	2022-11-07 06:58:55.081606+00
55	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-11-07 06:59:01.123748+00
56	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-11-09 17:50:11.645152+00
57	1	For home	2	[{"changed": {"fields": ["Name"]}}]	10	2	2022-11-10 17:54:07.698806+00
58	13	Черные демисезонные мужские No Brand Кроссовки	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-11-11 10:17:21.61591+00
59	13	Черные демисезонные мужские No Brand Кроссовки	2	[{"changed": {"fields": ["Image"]}}]	8	2	2022-11-11 12:39:12.121337+00
60	11	VU + UNO 4K	2	[{"changed": {"fields": ["Image1", "Image2", "Image3"]}}]	8	2	2022-11-11 13:21:40.822697+00
61	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image1", "Image2", "Image3"]}}]	8	2	2022-11-14 13:01:24.28526+00
62	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image2", "Image3"]}}]	8	2	2022-11-14 13:03:46.208201+00
63	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image2", "Image3"]}}]	8	2	2022-11-14 13:04:34.848459+00
64	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image2", "Image3"]}}]	8	2	2022-11-14 13:05:41.343448+00
65	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image1", "Image2", "Image3"]}}]	8	2	2022-11-14 13:19:14.248693+00
66	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image2", "Image3"]}}]	8	2	2022-11-14 13:20:26.875319+00
67	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image2", "Image3"]}}]	8	2	2022-11-14 13:21:46.525308+00
68	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image3"]}}]	8	2	2022-11-14 13:22:12.317199+00
69	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image3"]}}]	8	2	2022-11-14 13:24:13.64592+00
70	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image2"]}}]	8	2	2022-11-14 13:24:51.213795+00
71	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image1", "Image2"]}}]	8	2	2022-11-14 13:31:10.068374+00
72	14	Сонячна міні станція	2	[{"changed": {"fields": ["Image1", "Image2", "Image3"]}}]	8	2	2022-11-14 13:32:17.302958+00
73	15	user1	2	[{"changed": {"fields": ["Image", "Image1"]}}]	8	2	2022-11-18 16:29:48.247785+00
74	15	user1	3		8	2	2022-11-18 16:32:29.073131+00
75	16	test	3		8	2	2022-11-18 16:47:57.595758+00
76	17	rm_media	3		8	2	2022-11-18 16:59:23.805901+00
77	18	test	3		8	2	2022-11-18 17:06:56.600802+00
78	19	tuio	3		8	2	2022-11-18 17:09:12.919389+00
79	20	tttttt	1	[{"added": {}}]	8	2	2022-11-18 17:10:38.890345+00
80	20	tttttt	3		8	2	2022-11-18 17:14:02.914589+00
81	23	realiti	3		8	2	2022-11-18 19:56:45.500932+00
82	22	testw	3		8	2	2022-11-18 19:56:45.598566+00
83	21	test	3		8	2	2022-11-18 19:56:45.676299+00
84	24	test	3		8	2	2022-11-19 07:54:09.397995+00
85	25	test	3		8	2	2022-11-19 08:36:49.90466+00
86	26	test	3		8	2	2022-11-19 08:43:46.30431+00
87	27	test	3		8	2	2022-11-19 08:57:16.6478+00
88	29	test2	3		8	2	2022-11-19 12:40:02.011248+00
89	28	test	3		8	2	2022-11-19 12:40:02.094729+00
90	30	4K телевизор Samsung SmartTV 42"107см+Bluetooth	2	[{"changed": {"fields": ["Image", "Image1", "Image2", "Image3"]}}]	8	2	2022-11-19 12:41:08.042641+00
91	13	Черные демисезонные мужские No Brand Кроссовки	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-11-30 12:37:50.573115+00
92	2	ПАРООЧИСТИТЕЛЬ SC 2 EasyFix	2	[]	8	2	2022-11-30 12:38:09.852561+00
93	35	test5	3		8	2	2022-11-30 15:06:33.435555+00
94	34	test4	3		8	2	2022-11-30 15:06:33.544599+00
95	33	test3	3		8	2	2022-11-30 15:06:33.622121+00
96	32	test2	3		8	2	2022-11-30 15:06:33.699446+00
97	31	test	3		8	2	2022-11-30 15:06:33.776988+00
98	40	Спутниковый ресивер Vu+ DUO 4K SE	2	[{"changed": {"fields": ["Image", "Image1", "Image2"]}}]	8	2	2022-12-01 17:50:47.983596+00
99	40	Спутниковый ресивер Vu+ DUO 4K SE	2	[{"changed": {"fields": ["Image", "Image1", "Image2"]}}]	8	2	2022-12-01 17:53:40.238916+00
100	7	PayPalIPN: 7	2	[{"changed": {"fields": ["Flag"]}}]	11	2	2022-12-04 10:39:31.431381+00
101	10	PayPalIPN: 10	3		11	2	2022-12-04 10:45:57.814976+00
102	9	PayPalIPN: 9	3		11	2	2022-12-04 10:45:57.909062+00
103	8	PayPalIPN: 8	3		11	2	2022-12-04 10:45:57.986205+00
104	7	PayPalIPN: 7	3		11	2	2022-12-04 10:45:58.052812+00
105	6	PayPalIPN: 6	3		11	2	2022-12-04 10:45:58.130317+00
106	5	PayPalIPN: 5	3		11	2	2022-12-04 10:45:58.207834+00
107	4	PayPalIPN: 4	3		11	2	2022-12-04 10:45:58.28527+00
108	3	PayPalIPN: 3	3		11	2	2022-12-04 10:45:58.362627+00
109	2	PayPalIPN: 2	3		11	2	2022-12-04 10:45:58.429047+00
110	1	PayPalIPN: 1	3		11	2	2022-12-04 10:45:58.495477+00
111	46	test14	2	[{"changed": {"fields": ["Active"]}}]	8	2	2022-12-04 15:33:59.770595+00
112	2	test	3		12	2	2022-12-04 15:43:53.031096+00
113	1	test	3		12	2	2022-12-04 15:43:53.104554+00
114	4	VU + ZERO 4K	3		12	2	2022-12-04 16:09:15.707087+00
115	3	dm-900	3		12	2	2022-12-04 16:09:15.770999+00
116	70	test37	3		8	2	2022-12-12 16:09:46.880306+00
117	69	test36	3		8	2	2022-12-12 16:09:46.951521+00
118	68	test35	3		8	2	2022-12-12 16:09:47.014143+00
119	67	auct	3		8	2	2022-12-12 16:09:47.081902+00
120	66	test34	3		8	2	2022-12-12 16:09:47.148336+00
121	65	test33	3		8	2	2022-12-12 16:09:47.214746+00
122	64	test32	3		8	2	2022-12-12 16:09:47.281201+00
123	63	test31	3		8	2	2022-12-12 16:09:47.347775+00
124	62	test30	3		8	2	2022-12-12 16:09:47.39401+00
125	61	test28	3		8	2	2022-12-12 16:09:47.449362+00
126	60	test27	3		8	2	2022-12-12 16:09:47.524689+00
127	59	test26	3		8	2	2022-12-12 16:09:47.659847+00
128	58	test25	3		8	2	2022-12-12 16:09:47.715061+00
129	57	test24	3		8	2	2022-12-12 16:09:47.781636+00
130	56	test23	3		8	2	2022-12-12 16:09:47.836943+00
131	55	test22	3		8	2	2022-12-12 16:09:47.903386+00
132	54	test21	3		8	2	2022-12-12 16:09:47.969895+00
133	53	test20	3		8	2	2022-12-12 16:09:48.036213+00
134	52	test19	3		8	2	2022-12-12 16:09:48.102593+00
135	51	test18	3		8	2	2022-12-12 16:09:48.16959+00
136	50	test17	3		8	2	2022-12-12 16:09:48.235294+00
137	49	test16	3		8	2	2022-12-12 16:09:48.290643+00
138	48	test15	3		8	2	2022-12-12 16:09:48.345987+00
139	47	dm-900	3		8	2	2022-12-12 16:09:48.401525+00
140	46	test14	3		8	2	2022-12-12 16:09:48.456828+00
141	45	test13	3		8	2	2022-12-12 16:09:48.512252+00
142	44	test12	3		8	2	2022-12-12 16:09:48.611944+00
143	43	test11	3		8	2	2022-12-12 16:09:48.667175+00
144	42	test10	3		8	2	2022-12-12 16:09:48.74467+00
145	41	test-test	3		8	2	2022-12-12 16:09:48.811105+00
146	39	new	3		8	2	2022-12-12 16:09:48.877537+00
147	38	test9	3		8	2	2022-12-12 16:09:48.944179+00
148	37	test8	3		8	2	2022-12-12 16:09:49.010367+00
149	36	test7	3		8	2	2022-12-12 16:09:49.07472+00
150	35	realiti	3		8	2	2022-12-12 16:09:49.13216+00
151	34	Sat	3		8	2	2022-12-12 16:09:49.199203+00
152	33	passion	3		8	2	2022-12-12 16:09:49.264911+00
153	32	test6	3		8	2	2022-12-12 16:09:49.331348+00
154	31	test	3		8	2	2022-12-12 16:09:49.386965+00
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	auctions	user
2	admin	logentry
3	auth	permission
4	auth	group
5	contenttypes	contenttype
6	sessions	session
7	auctions	bid
8	auctions	auction
9	auctions	comments
10	auctions	category
11	ipn	paypalipn
12	auctions	transaction
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: auctions_user
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2022-10-06 15:32:48.169023+00
2	contenttypes	0002_remove_content_type_name	2022-10-06 15:32:48.292328+00
3	auth	0001_initial	2022-10-06 15:32:48.576938+00
4	auth	0002_alter_permission_name_max_length	2022-10-06 15:32:48.651133+00
5	auth	0003_alter_user_email_max_length	2022-10-06 15:32:48.761429+00
6	auth	0004_alter_user_username_opts	2022-10-06 15:32:48.833575+00
7	auth	0005_alter_user_last_login_null	2022-10-06 15:32:48.899835+00
8	auth	0006_require_contenttypes_0002	2022-10-06 15:32:48.977134+00
9	auth	0007_alter_validators_add_error_messages	2022-10-06 15:32:49.048842+00
10	auth	0008_alter_user_username_max_length	2022-10-06 15:32:49.124432+00
11	auth	0009_alter_user_last_name_max_length	2022-10-06 15:32:49.21288+00
12	auth	0010_alter_group_name_max_length	2022-10-06 15:32:49.300814+00
13	auth	0011_update_proxy_permissions	2022-10-06 15:32:49.405774+00
14	auth	0012_alter_user_first_name_max_length	2022-10-06 15:32:49.476447+00
15	auctions	0001_initial	2022-10-06 15:32:49.683775+00
16	admin	0001_initial	2022-10-06 15:32:49.873684+00
17	admin	0002_logentry_remove_auto_add	2022-10-06 15:32:49.978103+00
18	admin	0003_logentry_add_action_flag_choices	2022-10-06 15:32:50.106475+00
19	sessions	0001_initial	2022-10-06 15:32:50.275468+00
20	auctions	0002_bid_comments_auction	2022-10-08 15:59:24.330806+00
21	auctions	0003_category_alter_auction_categor	2022-10-08 16:13:09.259241+00
22	auctions	0004_auction_name	2022-10-09 07:32:44.180612+00
23	auctions	0005_auction_brief_descrip_alter_auction_name	2022-10-09 14:07:18.418242+00
24	auctions	0006_rename_big_bid_bid	2022-10-14 12:38:29.394707+00
25	auctions	0007_alter_comments_comments	2022-10-21 11:55:53.724892+00
26	auctions	0008_auction_image1_auction_image2_auction_image3_and_more	2022-11-11 13:06:07.559783+00
27	auctions	0009_alter_auction_image_alter_auction_image1_and_more	2022-11-14 12:55:43.816004+00
28	auctions	0010_alter_auction_image1_alter_auction_image2_and_more	2022-11-14 13:29:28.721367+00
29	ipn	0001_initial	2022-11-27 07:13:52.365289+00
30	ipn	0002_paypalipn_mp_id	2022-11-27 07:13:52.45285+00
31	ipn	0003_auto_20141117_1647	2022-11-27 07:13:52.610998+00
32	ipn	0004_auto_20150612_1826	2022-11-27 07:13:53.462329+00
33	ipn	0005_auto_20151217_0948	2022-11-27 07:13:53.607832+00
34	ipn	0006_auto_20160108_1112	2022-11-27 07:13:53.779553+00
35	ipn	0007_auto_20160219_1135	2022-11-27 07:13:53.88944+00
36	ipn	0008_auto_20181128_1032	2022-11-27 07:13:53.975414+00
37	auctions	0011_auction_paid_alter_auction_active_and_more	2022-12-01 07:55:20.55598+00
38	auctions	0012_transaction	2022-12-04 13:35:22.192292+00
39	auctions	0013_alter_transaction_test_ipn	2022-12-04 13:38:33.445763+00
40	auctions	0014_alter_transaction_item_namex	2022-12-04 13:43:18.116245+00
41	auctions	0015_alter_transaction_address_name	2022-12-04 13:45:21.040359+00
42	auctions	0016_rename_item_namex_transaction_item_name	2022-12-04 14:35:39.045222+00
43	auctions	0017_transaction_txn_id	2022-12-04 16:14:30.43132+00
44	auctions	0018_alter_transaction_contact_phone	2022-12-04 16:25:44.164574+00
45	auctions	0019_alter_transaction_contact_phone	2022-12-04 16:30:51.720113+00
46	auctions	0020_alter_bid_bid	2022-12-05 09:16:10.74902+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
ytcn6rim054rinh72mu2qxa2m8whkqjg	.eJxVjLkOwjAQBX8FuUaRvc7llPRUlICi9dpOAsSWchQI8e_EIQU0U7w3mhercZ7aeh7tUHeGVUyw_e-mke7Wx8Pc0DchoeCnodNJVJLtHZNjMPZx2Ny_QItjG7NCq1KRyR0gFyrjzpFBLgtyGmzOHVdFCVICokFNuiwJM8iVARSaZ7hE--eSpakLnlVndpl5CiJS0koemX4JK9N1tyvN7oT9OPuGXd8ff8tOtw:1oiIkg:0r59EWurWO5OgHsqD6yCQOkH5e9WxJ_z98z_XApr2kg	2022-10-25 14:09:10.366281+00
vtw8c5qzen269yv5yemtqiraiemr6vwh	.eJxVjLkOwjAQBX8FuUaRvc7llPRUlICi9dpOAsSWchQI8e_EIQU0U7w3mhercZ7aeh7tUHeGVUyw_e-mke7Wx8Pc0DchoeCnodNJVJLtHZNjMPZx2Ny_QItjG7NCq1KRyR0gFyrjzpFBLgtyGmzOHVdFCVICokFNuiwJM8iVARSaZ7hE--eSpakLnlVndpl5CiJS0koemX4JK9N1tyvN7oT9OPuGXd8ff8tOtw:1ohxO5:cuNJ_2yZ3RaHDsoiE5NjETVZglGIf8ZBBnRerirhZOY	2022-10-24 15:20:25.030564+00
\.


--
-- Data for Name: paypal_ipn; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paypal_ipn (id, business, charset, custom, notify_version, parent_txn_id, receiver_email, receiver_id, residence_country, test_ipn, txn_id, txn_type, verify_sign, address_country, address_city, address_country_code, address_name, address_state, address_status, address_street, address_zip, contact_phone, first_name, last_name, payer_business_name, payer_email, payer_id, auth_amount, auth_exp, auth_id, auth_status, exchange_rate, invoice, item_name, item_number, mc_currency, mc_fee, mc_gross, mc_handling, mc_shipping, memo, num_cart_items, option_name1, option_name2, payer_status, payment_date, payment_gross, payment_status, payment_type, pending_reason, protection_eligibility, quantity, reason_code, remaining_settle, settle_amount, settle_currency, shipping, shipping_method, tax, transaction_entity, auction_buyer_id, auction_closing_date, auction_multi_item, for_auction, amount, amount_per_cycle, initial_payment_amount, next_payment_date, outstanding_balance, payment_cycle, period_type, product_name, product_type, profile_status, recurring_payment_id, rp_invoice_id, time_created, amount1, amount2, amount3, mc_amount1, mc_amount2, mc_amount3, password, period1, period2, period3, reattempt, recur_times, recurring, retry_at, subscr_date, subscr_effective, subscr_id, username, case_creation_date, case_id, case_type, receipt_id, currency_code, handling_amount, transaction_subject, ipaddress, flag, flag_code, flag_info, query, response, created_at, updated_at, from_view, mp_id, option_selection1, option_selection2) FROM stdin;
11	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	0JH00224J9437623J	web_accept	AnBteddpeBDNU4EjSNQXYfU4tLOaADUkz0Q-3ZP-7EGUkZAl8QKhotBG	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	41	VU + ZERO 4K		USD	4.2	100	0	0		0			verified	2022-12-04 11:00:00+00	100	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=100.00&invoice=41&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=05%3A00%3A00+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=4.20&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AnBteddpeBDNU4EjSNQXYfU4tLOaADUkz0Q-3ZP-7EGUkZAl8QKhotBG&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=0JH00224J9437623J&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=4.20&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+ZERO+4K&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=100.00&ipn_track_id=7ddd6fffc90ee	VERIFIED	2022-12-04 11:00:09.516907+00	2022-12-04 11:00:09.590023+00	\N	\N		
12	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	29V596480X347325E	web_accept	AxoKSLFx.-7QBhQFBSh9dO9BRltGAC2Mffx5bcR5QWx4HoNulK89ACbB	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	42	AX 4k-box-hd61-combo		USD	0.5	5	0	0		0			verified	2022-12-04 12:11:07+00	5	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=5.00&invoice=42&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=06%3A11%3A07+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.50&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AxoKSLFx.-7QBhQFBSh9dO9BRltGAC2Mffx5bcR5QWx4HoNulK89ACbB&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=29V596480X347325E&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.50&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=AX+4k-box-hd61-combo&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=5.00&ipn_track_id=14f8672a64777	VERIFIED	2022-12-04 12:11:25.848552+00	2022-12-04 12:11:25.926312+00	\N	\N		
13	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	6K930165TC141142H	web_accept	AKYujmn95AO5XZnrsrC2GgYx4NsXA.W3bYmig8UbUUKBh6bLsPIlNidY	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	43	Samsung Galaxy A03 4/64 GB		USD	0.34	1	0	0		0			verified	2022-12-04 14:31:23+00	1	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=1.00&invoice=43&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=08%3A31%3A23+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AKYujmn95AO5XZnrsrC2GgYx4NsXA.W3bYmig8UbUUKBh6bLsPIlNidY&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=6K930165TC141142H&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=Samsung+Galaxy+A03+4/64+GB&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.00&ipn_track_id=f72d7aef4bf4e	VERIFIED	2022-12-04 14:31:31.813575+00	2022-12-04 14:31:31.913754+00	\N	\N		
14	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	6K930165TC141142H	web_accept	AKYujmn95AO5XZnrsrC2GgYx4NsXA.W3bYmig8UbUUKBh6bLsPIlNidY	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	43	Samsung Galaxy A03 4/64 GB		USD	0.34	1	0	0		0			verified	2022-12-04 14:31:23+00	1	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (6K930165TC141142H)	mc_gross=1.00&invoice=43&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=08%3A31%3A23+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AKYujmn95AO5XZnrsrC2GgYx4NsXA.W3bYmig8UbUUKBh6bLsPIlNidY&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=6K930165TC141142H&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=Samsung+Galaxy+A03+4/64+GB&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.00&ipn_track_id=f72d7aef4bf4e	VERIFIED	2022-12-04 14:33:35.594197+00	2022-12-04 14:33:35.690737+00	\N	\N		
15	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	9PY29276757555006	web_accept	AKCSFgAIdDyomZChB1p4dFvwcFhOAI9ZOI-0qX4oEbYjbHQb.c238tgw	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	44	test		USD	0.46	4	0	0		0			verified	2022-12-04 14:38:28+00	4	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=4.00&invoice=44&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=08%3A38%3A28+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.46&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AKCSFgAIdDyomZChB1p4dFvwcFhOAI9ZOI-0qX4oEbYjbHQb.c238tgw&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=9PY29276757555006&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.46&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=4.00&ipn_track_id=d35e4b2178805	VERIFIED	2022-12-04 14:38:36.932066+00	2022-12-04 14:38:37.018478+00	\N	\N		
16	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	9PY29276757555006	web_accept	AKCSFgAIdDyomZChB1p4dFvwcFhOAI9ZOI-0qX4oEbYjbHQb.c238tgw	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	44	test		USD	0.46	4	0	0		0			verified	2022-12-04 14:38:28+00	4	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (9PY29276757555006)	mc_gross=4.00&invoice=44&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=08%3A38%3A28+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.46&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AKCSFgAIdDyomZChB1p4dFvwcFhOAI9ZOI-0qX4oEbYjbHQb.c238tgw&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=9PY29276757555006&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.46&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=4.00&ipn_track_id=d35e4b2178805	VERIFIED	2022-12-04 14:41:05.252579+00	2022-12-04 14:41:05.342556+00	\N	\N		
17	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	9ND26340602579000	web_accept	A7IlWDilLLbVuHgo1.IHQvobvYGnA9HrLfdo777O.znlRb8YPG7HzfVb	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	45	test		USD	11.96	299	0	0		0			verified	2022-12-04 14:41:18+00	299	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=299.00&invoice=45&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=08%3A41%3A18+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=11.96&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=A7IlWDilLLbVuHgo1.IHQvobvYGnA9HrLfdo777O.znlRb8YPG7HzfVb&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=9ND26340602579000&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=11.96&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=299.00&ipn_track_id=cd0271b5d5e89	VERIFIED	2022-12-04 14:41:27.361025+00	2022-12-04 14:41:27.446293+00	\N	\N		
18	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	13V715951B085421X	web_accept	AK8OrZtqmkb0x4J46Oecq.OmkeVwABU3.O87PQUDwzHaHfXP-QQMDX7J	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	46	test		USD	9.39	233	0	0		0			verified	2022-12-04 15:35:15+00	233	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=233.00&invoice=46&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=09%3A35%3A15+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=9.39&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AK8OrZtqmkb0x4J46Oecq.OmkeVwABU3.O87PQUDwzHaHfXP-QQMDX7J&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=13V715951B085421X&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=9.39&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=233.00&ipn_track_id=20a6b24e180cd	VERIFIED	2022-12-04 15:35:24.273362+00	2022-12-04 15:35:24.501026+00	\N	\N		
19	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	5HD58790CC108071R	web_accept	AyVDJcm23cEBdcLU19eNjF11Wz.xAlm8XlOoPEdoHvG6AhbStCMDs3U9	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	47	dm-900		USD	12	300	0	0		0			verified	2022-12-04 15:46:00+00	300	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=300.00&invoice=47&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=09%3A46%3A00+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=12.00&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AyVDJcm23cEBdcLU19eNjF11Wz.xAlm8XlOoPEdoHvG6AhbStCMDs3U9&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=5HD58790CC108071R&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=12.00&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=dm-900&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=300.00&ipn_track_id=c99fcfefe846b	VERIFIED	2022-12-04 15:46:08.829222+00	2022-12-04 15:46:08.935945+00	\N	\N		
20	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	9901809667507414Y	web_accept	AEff8wPu.QkJzAUJwwEhfWg7hXtcAupHCmpLhG05mAZZflP0LEFMvQVg	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	48	VU + ZERO 4K		USD	1.63	34	0	0		0			verified	2022-12-04 15:50:36+00	34	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=34.00&invoice=48&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=09%3A50%3A36+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=1.63&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AEff8wPu.QkJzAUJwwEhfWg7hXtcAupHCmpLhG05mAZZflP0LEFMvQVg&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=9901809667507414Y&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=1.63&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+ZERO+4K&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=34.00&ipn_track_id=9826cfab4d42f	VERIFIED	2022-12-04 15:50:46.261096+00	2022-12-04 15:50:46.347102+00	\N	\N		
21	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	6K354058VB869734X	web_accept	Ac2Pzvj5l6nkcvTKl56MxHpjTr2gAMAzzrLmQbQfjMC1FEOCQLKYN8PP	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	49	Samsung Galaxy A03 4/64 GB		USD	15.43	388	0	0		0			verified	2022-12-04 15:55:39+00	388	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=388.00&invoice=49&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=09%3A55%3A39+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=15.43&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=Ac2Pzvj5l6nkcvTKl56MxHpjTr2gAMAzzrLmQbQfjMC1FEOCQLKYN8PP&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=6K354058VB869734X&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=15.43&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=Samsung+Galaxy+A03+4/64+GB&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=388.00&ipn_track_id=9e87ca147fd5a	VERIFIED	2022-12-04 15:55:48.572935+00	2022-12-04 15:55:48.663669+00	\N	\N		
22	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	6K354058VB869734X	web_accept	Ac2Pzvj5l6nkcvTKl56MxHpjTr2gAMAzzrLmQbQfjMC1FEOCQLKYN8PP	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	49	Samsung Galaxy A03 4/64 GB		USD	15.43	388	0	0		0			verified	2022-12-04 15:55:39+00	388	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (6K354058VB869734X)	mc_gross=388.00&invoice=49&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=09%3A55%3A39+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=15.43&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=Ac2Pzvj5l6nkcvTKl56MxHpjTr2gAMAzzrLmQbQfjMC1FEOCQLKYN8PP&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=6K354058VB869734X&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=15.43&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=Samsung+Galaxy+A03+4/64+GB&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=388.00&ipn_track_id=9e87ca147fd5a	VERIFIED	2022-12-04 15:57:52.860409+00	2022-12-04 15:57:53.017531+00	\N	\N		
23	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	1YC01693UT653435W	web_accept	AiYYUhFdSgkftg6I8wVgqbgVHhEyAx9gLOPSx4JMhAyGdaTQKakXXoeE	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	50	AX 4k-box-hd61-combo		USD	11.96	299	0	0		0			verified	2022-12-04 16:16:38+00	299	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=299.00&invoice=50&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=10%3A16%3A38+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=11.96&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AiYYUhFdSgkftg6I8wVgqbgVHhEyAx9gLOPSx4JMhAyGdaTQKakXXoeE&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=1YC01693UT653435W&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=11.96&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=AX+4k-box-hd61-combo&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=299.00&ipn_track_id=c2843c54de235	VERIFIED	2022-12-04 16:16:56.56656+00	2022-12-04 16:16:56.678567+00	\N	\N		
24	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	7BT77872EK4311433	web_accept	AMvtJoIw5aQe1D-A0HqmNPwIBhiWA-0x5ty7rqS2.740s7jlYOZhVgDi	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	51	SC 2 EasyFix 15120500		USD	15.86	399	0	0		0			verified	2022-12-04 16:19:26+00	399	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=399.00&invoice=51&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=10%3A19%3A26+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=15.86&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AMvtJoIw5aQe1D-A0HqmNPwIBhiWA-0x5ty7rqS2.740s7jlYOZhVgDi&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=7BT77872EK4311433&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=15.86&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=SC+2+EasyFix+15120500&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=399.00&ipn_track_id=889aeacfe78d5	VERIFIED	2022-12-04 16:19:33.228754+00	2022-12-04 16:19:33.299454+00	\N	\N		
25	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	6WT75300VA683730R	web_accept	AwrsEWIaqw3RY3uakkOc-IjEBf4AAVOAGMn1qfM9u6U8BLnY07nd7hI3	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	52	VU + ZERO 4K		USD	8.41	208	0	0		0			verified	2022-12-04 16:27:52+00	208	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=208.00&invoice=52&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=10%3A27%3A52+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=8.41&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AwrsEWIaqw3RY3uakkOc-IjEBf4AAVOAGMn1qfM9u6U8BLnY07nd7hI3&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=6WT75300VA683730R&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=8.41&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+ZERO+4K&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=208.00&ipn_track_id=0752cd84140dc	VERIFIED	2022-12-04 16:28:00.622066+00	2022-12-04 16:28:00.735584+00	\N	\N		
26	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	6WT75300VA683730R	web_accept	AwrsEWIaqw3RY3uakkOc-IjEBf4AAVOAGMn1qfM9u6U8BLnY07nd7hI3	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	52	VU + ZERO 4K		USD	8.41	208	0	0		0			verified	2022-12-04 16:27:52+00	208	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (6WT75300VA683730R)	mc_gross=208.00&invoice=52&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=10%3A27%3A52+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=8.41&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AwrsEWIaqw3RY3uakkOc-IjEBf4AAVOAGMn1qfM9u6U8BLnY07nd7hI3&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=6WT75300VA683730R&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=8.41&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+ZERO+4K&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=208.00&ipn_track_id=0752cd84140dc	VERIFIED	2022-12-04 16:30:05.332035+00	2022-12-04 16:30:05.410753+00	\N	\N		
27	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	7TA1659062045571V	web_accept	Ao68DNqlX5gVaPZlGVYk.BmBnaqJAVgnIDnoES49VWDH9iU3Y3S7QULv	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	53	home		USD	0.38	2	0	0		0			verified	2022-12-04 16:32:59+00	2	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=2.00&invoice=53&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=10%3A32%3A59+Dec+04%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.38&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=Ao68DNqlX5gVaPZlGVYk.BmBnaqJAVgnIDnoES49VWDH9iU3Y3S7QULv&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=7TA1659062045571V&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.38&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=home&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=2.00&ipn_track_id=e8f874cc98e54	VERIFIED	2022-12-04 16:33:16.152102+00	2022-12-04 16:33:16.243302+00	\N	\N		
28	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	0YW31167F7877662V	web_accept	AWhbJnsQ6gc5-vO4ltAHikPGWXbsAx3yjFeuCc8XYZ96IXfycM8Itg2Y	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	56	koty		USD	0.34	0.96	0	0		0			verified	2022-12-05 09:48:17+00	0.96	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=0.96&invoice=56&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=03%3A48%3A17+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AWhbJnsQ6gc5-vO4ltAHikPGWXbsAx3yjFeuCc8XYZ96IXfycM8Itg2Y&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=0YW31167F7877662V&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=koty&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=0.96&ipn_track_id=93ebc8d210d34	VERIFIED	2022-12-05 09:48:25.753715+00	2022-12-05 09:48:25.896796+00	\N	\N		
29	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	0YW31167F7877662V	web_accept	AWhbJnsQ6gc5-vO4ltAHikPGWXbsAx3yjFeuCc8XYZ96IXfycM8Itg2Y	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	56	koty		USD	0.34	0.96	0	0		0			verified	2022-12-05 09:48:17+00	0.96	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (0YW31167F7877662V)	mc_gross=0.96&invoice=56&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=03%3A48%3A17+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AWhbJnsQ6gc5-vO4ltAHikPGWXbsAx3yjFeuCc8XYZ96IXfycM8Itg2Y&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=0YW31167F7877662V&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=koty&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=0.96&ipn_track_id=93ebc8d210d34	VERIFIED	2022-12-05 09:52:47.920473+00	2022-12-05 09:52:48.022099+00	\N	\N		
30	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	14F50224J59415033	web_accept	A3P.8CLlbx.NsrHIIZbBBzGMbe4JAz6vnbI10..oQ8lpyFnvzgjsQuPD	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	57	test		USD	0.34	1.01	0	0		0			verified	2022-12-05 09:57:38+00	1.01	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=1.01&invoice=57&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=03%3A57%3A38+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=A3P.8CLlbx.NsrHIIZbBBzGMbe4JAz6vnbI10..oQ8lpyFnvzgjsQuPD&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=14F50224J59415033&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.01&ipn_track_id=4d3a9b520ebc5	VERIFIED	2022-12-05 09:57:55.867685+00	2022-12-05 09:57:55.943644+00	\N	\N		
31	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	14F50224J59415033	web_accept	A3P.8CLlbx.NsrHIIZbBBzGMbe4JAz6vnbI10..oQ8lpyFnvzgjsQuPD	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	57	test		USD	0.34	1.01	0	0		0			verified	2022-12-05 09:57:38+00	1.01	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (14F50224J59415033)	mc_gross=1.01&invoice=57&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=03%3A57%3A38+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=A3P.8CLlbx.NsrHIIZbBBzGMbe4JAz6vnbI10..oQ8lpyFnvzgjsQuPD&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=14F50224J59415033&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.01&ipn_track_id=4d3a9b520ebc5	VERIFIED	2022-12-05 10:01:48.493954+00	2022-12-05 10:01:48.596493+00	\N	\N		
32	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	47193022CP928304G	web_accept	AwAhdgEb0gBt51gCCUt1Y3r2VpWoAGal0Ou3V5Aze3PJHtU6xGDjxIj6	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	58	VU + ZERO 4K		USD	0.34	1.01	0	0		0			verified	2022-12-05 10:03:56+00	1.01	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=1.01&invoice=58&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=04%3A03%3A56+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AwAhdgEb0gBt51gCCUt1Y3r2VpWoAGal0Ou3V5Aze3PJHtU6xGDjxIj6&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=47193022CP928304G&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+ZERO+4K&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.01&ipn_track_id=935df1af8a052	VERIFIED	2022-12-05 10:04:06.133984+00	2022-12-05 10:04:06.400186+00	\N	\N		
33	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	47193022CP928304G	web_accept	AwAhdgEb0gBt51gCCUt1Y3r2VpWoAGal0Ou3V5Aze3PJHtU6xGDjxIj6	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	58	VU + ZERO 4K		USD	0.34	1.01	0	0		0			verified	2022-12-05 10:03:56+00	1.01	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (47193022CP928304G)	mc_gross=1.01&invoice=58&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=04%3A03%3A56+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AwAhdgEb0gBt51gCCUt1Y3r2VpWoAGal0Ou3V5Aze3PJHtU6xGDjxIj6&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=47193022CP928304G&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+ZERO+4K&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.01&ipn_track_id=935df1af8a052	VERIFIED	2022-12-05 10:06:48.427173+00	2022-12-05 10:06:48.532263+00	\N	\N		
34	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	78L35544ED077090U	web_accept	ASouf7c7BPhDW5MIRlAxQjWoCoBnAADOEg4pS9q-gsg4OTbr1DHmTGsP	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	60	test		USD	0.34	1.01	0	0		0			verified	2022-12-05 11:44:48+00	1.01	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=1.01&invoice=60&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=05%3A44%3A48+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=ASouf7c7BPhDW5MIRlAxQjWoCoBnAADOEg4pS9q-gsg4OTbr1DHmTGsP&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=78L35544ED077090U&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.01&ipn_track_id=adf8fa6550c07	VERIFIED	2022-12-05 11:44:56.655884+00	2022-12-05 11:44:56.796455+00	\N	\N		
35	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	78L35544ED077090U	web_accept	ASouf7c7BPhDW5MIRlAxQjWoCoBnAADOEg4pS9q-gsg4OTbr1DHmTGsP	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	60	test		USD	0.34	1.01	0	0		0			verified	2022-12-05 11:44:48+00	1.01	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (78L35544ED077090U)	mc_gross=1.01&invoice=60&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=05%3A44%3A48+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=ASouf7c7BPhDW5MIRlAxQjWoCoBnAADOEg4pS9q-gsg4OTbr1DHmTGsP&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=78L35544ED077090U&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.01&ipn_track_id=adf8fa6550c07	VERIFIED	2022-12-05 11:47:17.354036+00	2022-12-05 11:47:17.466853+00	\N	\N		
36	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	47H04902PE6621830	web_accept	Apy.56ZoMR4rL4fCSVMsK7b59rljAaKwexBP5NYNjxG0o5vV9AUnQ3l7	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	61	VU + ZERO 4K		USD	0.34	1.04	0	0		0			verified	2022-12-05 11:50:42+00	1.04	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=1.04&invoice=61&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=05%3A50%3A42+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=Apy.56ZoMR4rL4fCSVMsK7b59rljAaKwexBP5NYNjxG0o5vV9AUnQ3l7&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=47H04902PE6621830&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+ZERO+4K&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.04&ipn_track_id=e1668e2107b04	VERIFIED	2022-12-05 11:50:55.743197+00	2022-12-05 11:50:55.858742+00	\N	\N		
37	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	47H04902PE6621830	web_accept	Apy.56ZoMR4rL4fCSVMsK7b59rljAaKwexBP5NYNjxG0o5vV9AUnQ3l7	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	61	VU + ZERO 4K		USD	0.34	1.04	0	0		0			verified	2022-12-05 11:50:42+00	1.04	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (47H04902PE6621830)	mc_gross=1.04&invoice=61&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=05%3A50%3A42+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.34&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=Apy.56ZoMR4rL4fCSVMsK7b59rljAaKwexBP5NYNjxG0o5vV9AUnQ3l7&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=47H04902PE6621830&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.34&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+ZERO+4K&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1.04&ipn_track_id=e1668e2107b04	VERIFIED	2022-12-05 11:53:16.223416+00	2022-12-05 11:53:16.320343+00	\N	\N		
38	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	6VT64546YX2414739	web_accept	A--8MSCLabuvN8L.-MHjxC9uypBtAnJvN6anUOj24AMJDlnPAmSPCkC1	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	62	VU + UNO 4K SE 1X DUAL FBC-S/S2/S2X		USD	14.8	371.9	0	0		0			verified	2022-12-05 11:57:12+00	371.9	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=371.90&invoice=62&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=05%3A57%3A12+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=14.80&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=A--8MSCLabuvN8L.-MHjxC9uypBtAnJvN6anUOj24AMJDlnPAmSPCkC1&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=6VT64546YX2414739&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=14.80&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+UNO+4K+SE+1X+DUAL+FBC-S/S2/S2X&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=371.90&ipn_track_id=a373368d5ff4a	VERIFIED	2022-12-05 11:57:22.081363+00	2022-12-05 11:57:22.159886+00	\N	\N		
39	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	6VT64546YX2414739	web_accept	A--8MSCLabuvN8L.-MHjxC9uypBtAnJvN6anUOj24AMJDlnPAmSPCkC1	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	62	VU + UNO 4K SE 1X DUAL FBC-S/S2/S2X		USD	14.8	371.9	0	0		0			verified	2022-12-05 11:57:12+00	371.9	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (6VT64546YX2414739)	mc_gross=371.90&invoice=62&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=05%3A57%3A12+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=14.80&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=A--8MSCLabuvN8L.-MHjxC9uypBtAnJvN6anUOj24AMJDlnPAmSPCkC1&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=6VT64546YX2414739&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=14.80&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+UNO+4K+SE+1X+DUAL+FBC-S/S2/S2X&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=371.90&ipn_track_id=a373368d5ff4a	VERIFIED	2022-12-05 11:59:26.541031+00	2022-12-05 11:59:26.639539+00	\N	\N		
40	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	3J980150AG2570102	web_accept	AJBjrAOFeBi.IDmiOFQfhCvLWSn0AAgJH1KMbgs9lUpod62EROPYNmRP	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	63	test		USD	0.41	2.73	0	0		0			verified	2022-12-05 12:05:38+00	2.73	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=2.73&invoice=63&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=06%3A05%3A38+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.41&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AJBjrAOFeBi.IDmiOFQfhCvLWSn0AAgJH1KMbgs9lUpod62EROPYNmRP&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=3J980150AG2570102&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.41&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=2.73&ipn_track_id=023d57692bc08	VERIFIED	2022-12-05 12:05:55.869878+00	2022-12-05 12:05:55.99348+00	\N	\N		
41	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	3J980150AG2570102	web_accept	AJBjrAOFeBi.IDmiOFQfhCvLWSn0AAgJH1KMbgs9lUpod62EROPYNmRP	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	63	test		USD	0.41	2.73	0	0		0			verified	2022-12-05 12:05:38+00	2.73	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (3J980150AG2570102)	mc_gross=2.73&invoice=63&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=06%3A05%3A38+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.41&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AJBjrAOFeBi.IDmiOFQfhCvLWSn0AAgJH1KMbgs9lUpod62EROPYNmRP&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=3J980150AG2570102&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.41&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=2.73&ipn_track_id=023d57692bc08	VERIFIED	2022-12-05 12:08:05.145021+00	2022-12-05 12:08:05.250133+00	\N	\N		
42	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	2WL91976D6426015M	web_accept	AQSzm4rxY4f6Mxx0OnxH5u7LEgTTAd2hTytrf0VWhdRzZiY-geJ5n7W3	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	64	VU + UNO 4K SE 1X DUAL FBC-S/S2/S2X		USD	17.9	451.21	0	0		0			verified	2022-12-05 12:09:50+00	451.21	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=451.21&invoice=64&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=06%3A09%3A50+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=17.90&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AQSzm4rxY4f6Mxx0OnxH5u7LEgTTAd2hTytrf0VWhdRzZiY-geJ5n7W3&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=2WL91976D6426015M&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=17.90&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+UNO+4K+SE+1X+DUAL+FBC-S/S2/S2X&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=451.21&ipn_track_id=43fb1475e6988	VERIFIED	2022-12-05 12:09:59.883985+00	2022-12-05 12:10:00.004647+00	\N	\N		
43	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	2WL91976D6426015M	web_accept	AQSzm4rxY4f6Mxx0OnxH5u7LEgTTAd2hTytrf0VWhdRzZiY-geJ5n7W3	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	64	VU + UNO 4K SE 1X DUAL FBC-S/S2/S2X		USD	17.9	451.21	0	0		0			verified	2022-12-05 12:09:50+00	451.21	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	t		Duplicate txn_id. (2WL91976D6426015M)	mc_gross=451.21&invoice=64&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=06%3A09%3A50+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=17.90&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AQSzm4rxY4f6Mxx0OnxH5u7LEgTTAd2hTytrf0VWhdRzZiY-geJ5n7W3&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=2WL91976D6426015M&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=17.90&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+UNO+4K+SE+1X+DUAL+FBC-S/S2/S2X&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=451.21&ipn_track_id=43fb1475e6988	VERIFIED	2022-12-05 12:12:19.041002+00	2022-12-05 12:12:19.148396+00	\N	\N		
44	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	0DX27282N2490781N	web_accept	AhuWIDf6E9XBr93W.C89hOsQJQblAi9tsggcynazo6Tbfum4EXEKp8P4	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	65	Samsung Galaxy A03 4/64 GB		USD	6.48	158.58	0	0		0			verified	2022-12-05 12:24:39+00	158.58	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=158.58&invoice=65&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=06%3A24%3A39+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=6.48&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AhuWIDf6E9XBr93W.C89hOsQJQblAi9tsggcynazo6Tbfum4EXEKp8P4&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=0DX27282N2490781N&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=6.48&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=Samsung+Galaxy+A03+4/64+GB&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=158.58&ipn_track_id=58f3029f0aecc	VERIFIED	2022-12-05 12:24:55.735818+00	2022-12-05 12:24:55.81769+00	\N	\N		
45	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	7NL436516Y3973928	web_accept	AodKC2A-IgQsGcS9YIvu4dj2XKNHAKyVo222VTDI5m637kZSxUCTpu-b	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	66	test		USD	0.05	0.05	0	0		0			verified	2022-12-05 13:35:18+00	0.05	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=0.05&invoice=66&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=07%3A35%3A18+Dec+05%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=0.05&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AodKC2A-IgQsGcS9YIvu4dj2XKNHAKyVo222VTDI5m637kZSxUCTpu-b&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=7NL436516Y3973928&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=0.05&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=test&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=0.05&ipn_track_id=59969d6b57b7f	VERIFIED	2022-12-05 13:35:27.918339+00	2022-12-05 13:35:28.04037+00	\N	\N		
46	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	1UX11657CX5570544	web_accept	AUV.LXmvG6huRlK7zJJNK9LGlrS3Ay4kcNbG0vBiadMjS0zY.2APehhE	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	69	Samsung Galaxy A03 4/64 GB		USD	62.16	1586.03	0	0		0			verified	2022-12-12 15:48:46+00	1586.03	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=1586.03&invoice=69&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=09%3A48%3A46+Dec+12%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=62.16&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AUV.LXmvG6huRlK7zJJNK9LGlrS3Ay4kcNbG0vBiadMjS0zY.2APehhE&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=1UX11657CX5570544&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=62.16&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=Samsung+Galaxy+A03+4/64+GB&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=1586.03&ipn_track_id=21db5bbbc21bc	VERIFIED	2022-12-12 15:48:55.364863+00	2022-12-12 15:48:55.468198+00	\N	\N		
47	sb-nel43b22326328@business.example.com	UTF-8	premium_plan	3.9		sb-nel43b22326328@business.example.com	AXC6FZSWEQTAA	US	t	3SU742577D080272S	web_accept	AF67tpBGfXPWvTprqe1PGD9dS6OQATl5fShhPVpgk3P7QZgQHfE-29O7	United States	San Jose	US	John Doe	CA	confirmed	1 Main St	95131		John	Doe		sb-fxhik16805497@personal.example.com	QLB6J7ZDMZ862	0				0	70	VU + ZERO 4Ktes		USD	7.76	191.39	0	0		0			verified	2022-12-12 16:06:52+00	191.39	Completed	instant		Eligible	1		0	0		0	Default	0			\N	0	0	0	0	0	\N	0								\N	0	0	0	0	0	0						0		\N	\N	\N			\N				USD	0		127.0.0.1	f			mc_gross=191.39&invoice=70&protection_eligibility=Eligible&address_status=confirmed&payer_id=QLB6J7ZDMZ862&address_street=1+Main+St&payment_date=10%3A06%3A52+Dec+12%2C+2022+PST&payment_status=Completed&charset=UTF-8&address_zip=95131&first_name=John&mc_fee=7.76&address_country_code=US&address_name=John+Doe&notify_version=3.9&custom=premium_plan&payer_status=verified&business=sb-nel43b22326328%40business.example.com&address_country=United+States&address_city=San+Jose&quantity=1&verify_sign=AF67tpBGfXPWvTprqe1PGD9dS6OQATl5fShhPVpgk3P7QZgQHfE-29O7&payer_email=sb-fxhik16805497%40personal.example.com&txn_id=3SU742577D080272S&payment_type=instant&last_name=Doe&address_state=CA&receiver_email=sb-nel43b22326328%40business.example.com&payment_fee=7.76&shipping_discount=0.00&insurance_amount=0.00&receiver_id=AXC6FZSWEQTAA&txn_type=web_accept&item_name=VU+%2B+ZERO+4Ktes&discount=0.00&mc_currency=USD&item_number=&residence_country=US&test_ipn=1&shipping_method=Default&transaction_subject=&payment_gross=191.39&ipn_track_id=a9d1acd4c1653	VERIFIED	2022-12-12 16:07:00.889262+00	2022-12-12 16:07:00.981518+00	\N	\N		
\.


--
-- Name: auctions_auction_commet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auctions_auction_commet_id_seq', 1, true);


--
-- Name: auctions_auction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: auctions_user
--

SELECT pg_catalog.setval('public.auctions_auction_id_seq', 43, true);


--
-- Name: auctions_bid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: auctions_user
--

SELECT pg_catalog.setval('public.auctions_bid_id_seq', 89, true);


--
-- Name: auctions_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: auctions_user
--

SELECT pg_catalog.setval('public.auctions_category_id_seq', 4, true);


--
-- Name: auctions_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: auctions_user
--

SELECT pg_catalog.setval('public.auctions_comments_id_seq', 23, true);


--
-- Name: auctions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auctions_transaction_id_seq', 10, true);


--
-- Name: auctions_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auctions_user_groups_id_seq', 1, true);


--
-- Name: auctions_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: auctions_user
--

SELECT pg_catalog.setval('public.auctions_user_id_seq', 4, true);


--
-- Name: auctions_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auctions_user_user_permissions_id_seq', 1, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 48, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 154, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 12, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: auctions_user
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 46, true);


--
-- Name: paypal_ipn_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paypal_ipn_id_seq', 47, true);


--
-- Name: django_migrations idx_18702_django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT idx_18702_django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_content_type idx_18711_django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT idx_18711_django_content_type_pkey PRIMARY KEY (id);


--
-- Name: auth_group_permissions idx_18720_auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT idx_18720_auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_permission idx_18726_auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT idx_18726_auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_group idx_18735_auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT idx_18735_auth_group_pkey PRIMARY KEY (id);


--
-- Name: auctions_user idx_18744_auctions_user_pkey; Type: CONSTRAINT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_user
    ADD CONSTRAINT idx_18744_auctions_user_pkey PRIMARY KEY (id);


--
-- Name: auctions_user_groups idx_18753_auctions_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_user_groups
    ADD CONSTRAINT idx_18753_auctions_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auctions_user_user_permissions idx_18759_auctions_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_user_user_permissions
    ADD CONSTRAINT idx_18759_auctions_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log idx_18765_django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT idx_18765_django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_session idx_18772_sqlite_autoindex_django_session_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT idx_18772_sqlite_autoindex_django_session_1 PRIMARY KEY (session_key);


--
-- Name: auctions_comments idx_18780_auctions_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_comments
    ADD CONSTRAINT idx_18780_auctions_comments_pkey PRIMARY KEY (id);


--
-- Name: auctions_auction_commet idx_18789_auctions_auction_commet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_auction_commet
    ADD CONSTRAINT idx_18789_auctions_auction_commet_pkey PRIMARY KEY (id);


--
-- Name: auctions_category idx_18795_auctions_category_pkey; Type: CONSTRAINT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_category
    ADD CONSTRAINT idx_18795_auctions_category_pkey PRIMARY KEY (id);


--
-- Name: paypal_ipn idx_18804_paypal_ipn_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paypal_ipn
    ADD CONSTRAINT idx_18804_paypal_ipn_pkey PRIMARY KEY (id);


--
-- Name: auctions_auction idx_18813_auctions_auction_pkey; Type: CONSTRAINT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_auction
    ADD CONSTRAINT idx_18813_auctions_auction_pkey PRIMARY KEY (id);


--
-- Name: auctions_transaction idx_18822_auctions_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_transaction
    ADD CONSTRAINT idx_18822_auctions_transaction_pkey PRIMARY KEY (id);


--
-- Name: auctions_bid idx_18831_auctions_bid_pkey; Type: CONSTRAINT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_bid
    ADD CONSTRAINT idx_18831_auctions_bid_pkey PRIMARY KEY (id);


--
-- Name: idx_18711_django_content_type_app_label_model_76bd3d3b_uniq; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_18711_django_content_type_app_label_model_76bd3d3b_uniq ON public.django_content_type USING btree (app_label, model);


--
-- Name: idx_18720_auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18720_auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: idx_18720_auth_group_permissions_group_id_permission_id_0cd325b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_18720_auth_group_permissions_group_id_permission_id_0cd325b ON public.auth_group_permissions USING btree (group_id, permission_id);


--
-- Name: idx_18720_auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18720_auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: idx_18726_auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18726_auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: idx_18726_auth_permission_content_type_id_codename_01ab375a_uni; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_18726_auth_permission_content_type_id_codename_01ab375a_uni ON public.auth_permission USING btree (content_type_id, codename);


--
-- Name: idx_18735_sqlite_autoindex_auth_group_1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_18735_sqlite_autoindex_auth_group_1 ON public.auth_group USING btree (name);


--
-- Name: idx_18744_sqlite_autoindex_auctions_user_1; Type: INDEX; Schema: public; Owner: auctions_user
--

CREATE UNIQUE INDEX idx_18744_sqlite_autoindex_auctions_user_1 ON public.auctions_user USING btree (username);


--
-- Name: idx_18753_auctions_user_groups_group_id_beef25ba; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18753_auctions_user_groups_group_id_beef25ba ON public.auctions_user_groups USING btree (group_id);


--
-- Name: idx_18753_auctions_user_groups_user_id_cdaa1ab3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18753_auctions_user_groups_user_id_cdaa1ab3 ON public.auctions_user_groups USING btree (user_id);


--
-- Name: idx_18753_auctions_user_groups_user_id_group_id_1f941809_uniq; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_18753_auctions_user_groups_user_id_group_id_1f941809_uniq ON public.auctions_user_groups USING btree (user_id, group_id);


--
-- Name: idx_18759_auctions_user_user_permissions_permission_id_6cab40d7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18759_auctions_user_user_permissions_permission_id_6cab40d7 ON public.auctions_user_user_permissions USING btree (permission_id);


--
-- Name: idx_18759_auctions_user_user_permissions_user_id_fec24fe0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18759_auctions_user_user_permissions_user_id_fec24fe0 ON public.auctions_user_user_permissions USING btree (user_id);


--
-- Name: idx_18759_auctions_user_user_permissions_user_id_permission_id_; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_18759_auctions_user_user_permissions_user_id_permission_id_ ON public.auctions_user_user_permissions USING btree (user_id, permission_id);


--
-- Name: idx_18765_django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18765_django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: idx_18765_django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18765_django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: idx_18772_django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18772_django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: idx_18789_auctions_auction_commet_auction_id_comments_id_0b4465; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_18789_auctions_auction_commet_auction_id_comments_id_0b4465 ON public.auctions_auction_commet USING btree (auction_id, comments_id);


--
-- Name: idx_18789_auctions_auction_commet_auction_id_d3811b5b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18789_auctions_auction_commet_auction_id_d3811b5b ON public.auctions_auction_commet USING btree (auction_id);


--
-- Name: idx_18789_auctions_auction_commet_comments_id_9aeaa52a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18789_auctions_auction_commet_comments_id_9aeaa52a ON public.auctions_auction_commet USING btree (comments_id);


--
-- Name: idx_18804_paypal_ipn_txn_id_8fa22c44; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_18804_paypal_ipn_txn_id_8fa22c44 ON public.paypal_ipn USING btree (txn_id);


--
-- Name: idx_18813_auctions_auction_categor_id_1db3c86a; Type: INDEX; Schema: public; Owner: auctions_user
--

CREATE INDEX idx_18813_auctions_auction_categor_id_1db3c86a ON public.auctions_auction USING btree (categor_id);


--
-- Name: idx_18813_auctions_auction_price_id_a9eff7c6; Type: INDEX; Schema: public; Owner: auctions_user
--

CREATE INDEX idx_18813_auctions_auction_price_id_a9eff7c6 ON public.auctions_auction USING btree (price_id);


--
-- Name: idx_18813_sqlite_autoindex_auctions_auction_1; Type: INDEX; Schema: public; Owner: auctions_user
--

CREATE UNIQUE INDEX idx_18813_sqlite_autoindex_auctions_auction_1 ON public.auctions_auction USING btree (name);


--
-- Name: auctions_auction add_auction; Type: TRIGGER; Schema: public; Owner: auctions_user
--

CREATE TRIGGER add_auction AFTER INSERT ON public.auctions_auction FOR EACH ROW EXECUTE FUNCTION public.insert_auction();


--
-- Name: auctions_bid my_trigger; Type: TRIGGER; Schema: public; Owner: auctions_user
--

CREATE TRIGGER my_trigger AFTER UPDATE ON public.auctions_bid FOR EACH ROW EXECUTE FUNCTION public.log_bid();


--
-- Name: auctions_auction auctions_auction_categor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_auction
    ADD CONSTRAINT auctions_auction_categor_id_fkey FOREIGN KEY (categor_id) REFERENCES public.auctions_category(id);


--
-- Name: auctions_auction_commet auctions_auction_commet_auction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_auction_commet
    ADD CONSTRAINT auctions_auction_commet_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES public.auctions_auction(id);


--
-- Name: auctions_auction_commet auctions_auction_commet_comments_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_auction_commet
    ADD CONSTRAINT auctions_auction_commet_comments_id_fkey FOREIGN KEY (comments_id) REFERENCES public.auctions_comments(id);


--
-- Name: auctions_auction auctions_auction_price_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: auctions_user
--

ALTER TABLE ONLY public.auctions_auction
    ADD CONSTRAINT auctions_auction_price_id_fkey FOREIGN KEY (price_id) REFERENCES public.auctions_bid(id);


--
-- Name: auctions_user_groups auctions_user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_user_groups
    ADD CONSTRAINT auctions_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.auth_group(id);


--
-- Name: auctions_user_groups auctions_user_groups_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_user_groups
    ADD CONSTRAINT auctions_user_groups_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auctions_user(id);


--
-- Name: auctions_user_user_permissions auctions_user_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_user_user_permissions
    ADD CONSTRAINT auctions_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id);


--
-- Name: auctions_user_user_permissions auctions_user_user_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auctions_user_user_permissions
    ADD CONSTRAINT auctions_user_user_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auctions_user(id);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.auth_group(id);


--
-- Name: auth_group_permissions auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id);


--
-- Name: auth_permission auth_permission_content_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_fkey FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id);


--
-- Name: django_admin_log django_admin_log_content_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_fkey FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id);


--
-- Name: django_admin_log django_admin_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auctions_user(id);


--
-- Name: TABLE auctions_auction; Type: ACL; Schema: public; Owner: auctions_user
--

GRANT ALL ON TABLE public.auctions_auction TO igor;


--
-- Name: TABLE auctions_bid; Type: ACL; Schema: public; Owner: auctions_user
--

GRANT ALL ON TABLE public.auctions_bid TO igor;


--
-- Name: TABLE auctions_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auctions_log TO igor;


--
-- Name: TABLE auctions_user; Type: ACL; Schema: public; Owner: auctions_user
--

GRANT ALL ON TABLE public.auctions_user TO igor;


--
-- PostgreSQL database dump complete
--

