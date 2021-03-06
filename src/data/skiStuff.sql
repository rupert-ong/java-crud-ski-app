PGDMP     8    *                t           skistuff    9.5.3    9.5.3     M           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            N           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            O           1262    16394    skistuff    DATABASE     �   CREATE DATABASE skistuff WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE skistuff;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            P           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6            Q           0    0    public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    6                        3079    12355    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            R           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1259    16409    employee    TABLE     �   CREATE TABLE employee (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    department character varying(50) NOT NULL
);
    DROP TABLE public.employee;
       public         rupert    false    6            �            1259    16407    employee_id_seq    SEQUENCE     q   CREATE SEQUENCE employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.employee_id_seq;
       public       rupert    false    6    184            S           0    0    employee_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE employee_id_seq OWNED BY employee.id;
            public       rupert    false    183            �            1259    16417    salary    TABLE     _   CREATE TABLE salary (
    id integer NOT NULL,
    salary numeric(10,2),
    emp_id integer
);
    DROP TABLE public.salary;
       public         rupert    false    6            �            1259    16415    salary_id_seq    SEQUENCE     o   CREATE SEQUENCE salary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.salary_id_seq;
       public       rupert    false    6    186            T           0    0    salary_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE salary_id_seq OWNED BY salary.id;
            public       rupert    false    185            �            1259    16397    skisetc    TABLE     �   CREATE TABLE skisetc (
    id integer NOT NULL,
    product character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    price numeric(10,2)
);
    DROP TABLE public.skisetc;
       public         rupert    false    6            �            1259    16395    skisetc_id_seq    SEQUENCE     p   CREATE SEQUENCE skisetc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.skisetc_id_seq;
       public       rupert    false    6    182            U           0    0    skisetc_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE skisetc_id_seq OWNED BY skisetc.id;
            public       rupert    false    181            �           2604    16412    id    DEFAULT     \   ALTER TABLE ONLY employee ALTER COLUMN id SET DEFAULT nextval('employee_id_seq'::regclass);
 :   ALTER TABLE public.employee ALTER COLUMN id DROP DEFAULT;
       public       rupert    false    184    183    184            �           2604    16420    id    DEFAULT     X   ALTER TABLE ONLY salary ALTER COLUMN id SET DEFAULT nextval('salary_id_seq'::regclass);
 8   ALTER TABLE public.salary ALTER COLUMN id DROP DEFAULT;
       public       rupert    false    186    185    186            �           2604    16400    id    DEFAULT     Z   ALTER TABLE ONLY skisetc ALTER COLUMN id SET DEFAULT nextval('skisetc_id_seq'::regclass);
 9   ALTER TABLE public.skisetc ALTER COLUMN id DROP DEFAULT;
       public       rupert    false    181    182    182            H          0    16409    employee 
   TABLE DATA               1   COPY employee (id, name, department) FROM stdin;
    public       rupert    false    184          V           0    0    employee_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('employee_id_seq', 3, true);
            public       rupert    false    183            J          0    16417    salary 
   TABLE DATA               -   COPY salary (id, salary, emp_id) FROM stdin;
    public       rupert    false    186   j       W           0    0    salary_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('salary_id_seq', 3, true);
            public       rupert    false    185            F          0    16397    skisetc 
   TABLE DATA               8   COPY skisetc (id, product, category, price) FROM stdin;
    public       rupert    false    182   �       X           0    0    skisetc_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('skisetc_id_seq', 48, true);
            public       rupert    false    181            �           2606    16414    employee_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_pkey;
       public         rupert    false    184    184            �           2606    16422    salary_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY salary
    ADD CONSTRAINT salary_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.salary DROP CONSTRAINT salary_pkey;
       public         rupert    false    186    186            �           2606    16402    skisetc_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY skisetc
    ADD CONSTRAINT skisetc_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.skisetc DROP CONSTRAINT skisetc_pkey;
       public         rupert    false    182    182            �           2606    16423    salary_emp_id_fkey    FK CONSTRAINT     l   ALTER TABLE ONLY salary
    ADD CONSTRAINT salary_emp_id_fkey FOREIGN KEY (emp_id) REFERENCES employee(id);
 C   ALTER TABLE ONLY public.salary DROP CONSTRAINT salary_emp_id_fkey;
       public       rupert    false    184    186    1999            H   I   x�3���OU.��OO�tLN�/�+��K�2�t.-ʩ�ɸe�%�%�rs�$���R��J3KrS�J�b���� 8�      J   1   x��9 0���;�y
��q��$(]=�bB�r�,�Ə�������      F   �  x�u��n� E���,��6��i��3�ʎ�,fC����Q�~LܴM�.l��<@��� ��H�Խ���ƹ�X%�Z`v!��T���#�樓�����w@h�f��X=QE�gB���v��]ɯ	�y"�Y�R�;��O��.x����4Y�Gԛ��6t{�=�0�q�I�'+��t�a01|:
{geVU��x��{y�����*�*�kL�h�;8�_	B<\LEw�����ZdL`R�y?���IQma��֨xWÄH��^(<+g��pәb:�����=�˟P�+�����͢���vc�_.�L��T16mM/C+�M�g%U�jw��κAɃ�h��(����a�:���s�i����z���+
J��
��/����u	�6滥H������j�;}6=?o�T���Q��<�q��y�XVr��I	�����Yl������0�����     