--
-- PostgreSQL database dump
--

\restrict XdhttqOpd1plk2vvc1dNw1h8UAO2GfksoYg0ZaIe3zPOhvPUUJbgfbaAFuurdQk

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2025-08-29 19:21:23

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
-- TOC entry 848 (class 1247 OID 16411)
-- Name: event_name_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.event_name_t AS ENUM (
    'signup',
    'page_view',
    'purchase',
    'logout'
);


ALTER TYPE public.event_name_t OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 16429)
-- Name: enforce_batch_limit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.enforce_batch_limit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF (SELECT count(*) FROM new_rows) > 1000 THEN
    RAISE EXCEPTION 'Batch too large: % rows (max 1000)', (SELECT count(*) FROM new_rows);
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.enforce_batch_limit() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16394)
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    event_id integer NOT NULL,
    user_id integer NOT NULL,
    event_name public.event_name_t NOT NULL,
    event_time timestamp without time zone NOT NULL,
    extra_info text,
    CONSTRAINT events_extra_len CHECK (((extra_info IS NULL) OR (length(extra_info) <= 200))),
    CONSTRAINT events_no_future CHECK ((event_time <= (CURRENT_TIMESTAMP)::timestamp without time zone))
);


ALTER TABLE public.events OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16389)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    signup_date date
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 4747 (class 2606 OID 16400)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- TOC entry 4745 (class 2606 OID 16393)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4748 (class 1259 OID 16419)
-- Name: idx_event_name_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_event_name_time ON public.events USING btree (event_name, event_time);


--
-- TOC entry 4749 (class 1259 OID 16406)
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_event_time ON public.events USING btree (event_time);


--
-- TOC entry 4750 (class 1259 OID 16407)
-- Name: idx_user_event_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_event_time ON public.events USING btree (user_id, event_time);


--
-- TOC entry 4752 (class 2620 OID 16430)
-- Name: events trg_events_batch_cap; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_events_batch_cap AFTER INSERT ON public.events REFERENCING NEW TABLE AS new_rows FOR EACH STATEMENT EXECUTE FUNCTION public.enforce_batch_limit();


--
-- TOC entry 4751 (class 2606 OID 16401)
-- Name: events events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


-- Completed on 2025-08-29 19:21:23

--
-- PostgreSQL database dump complete
--

\unrestrict XdhttqOpd1plk2vvc1dNw1h8UAO2GfksoYg0ZaIe3zPOhvPUUJbgfbaAFuurdQk

