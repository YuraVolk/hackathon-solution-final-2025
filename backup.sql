PGDMP                      }         
   hakaton_db    17.4 (Debian 17.4-1.pgdg120+2)    17.4 K    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    16384 
   hakaton_db    DATABASE     u   CREATE DATABASE hakaton_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE hakaton_db;
                     postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                     pg_database_owner    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                        pg_database_owner    false    4            �            1259    16389    account    TABLE     �   CREATE TABLE public.account (
    id integer NOT NULL,
    login text NOT NULL,
    password text NOT NULL,
    role_id integer NOT NULL,
    token text NOT NULL,
    mail text
);
    DROP TABLE public.account;
       public         heap r       postgres    false    4            �            1259    16394    account_id_seq    SEQUENCE     �   ALTER TABLE public.account ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    217    4            �            1259    32789    filled_ticket    TABLE     8  CREATE TABLE public.filled_ticket (
    id integer NOT NULL,
    id_user integer NOT NULL,
    date date,
    "time" time without time zone,
    filled_cell jsonb,
    is_win boolean,
    id_ticket integer NOT NULL,
    id_history_operation integer NOT NULL,
    multiplier_numbers jsonb,
    multiplier real
);
 !   DROP TABLE public.filled_ticket;
       public         heap r       postgres    false    4            �            1259    32858    filled_ticket_id_seq    SEQUENCE     �   ALTER TABLE public.filled_ticket ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.filled_ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    225    4            �            1259    32919    game    TABLE     �  CREATE TABLE public.game (
    id integer NOT NULL,
    id_user integer NOT NULL,
    grid jsonb NOT NULL,
    current_number integer,
    skip_count integer DEFAULT 0 NOT NULL,
    current_move_cost numeric(10,2) DEFAULT 5.00 NOT NULL,
    total_bets numeric(10,2) DEFAULT 0.00 NOT NULL,
    total_payouts numeric(10,2) DEFAULT 0.00 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    date_created date DEFAULT CURRENT_DATE NOT NULL,
    time_created time without time zone DEFAULT CURRENT_TIME NOT NULL,
    id_setting_game integer,
    CONSTRAINT game_current_number_check CHECK (((current_number >= 1) AND (current_number <= 9)))
);
    DROP TABLE public.game;
       public         heap r       postgres    false    4            �            1259    32918    game_id_seq    SEQUENCE     �   ALTER TABLE public.game ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.game_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    4    238            �            1259    32782    generated_ticket    TABLE     �   CREATE TABLE public.generated_ticket (
    id integer NOT NULL,
    id_setting_ticket integer NOT NULL,
    date_generated date,
    time_generated time without time zone,
    arr_number jsonb,
    arr_true_number jsonb
);
 $   DROP TABLE public.generated_ticket;
       public         heap r       postgres    false    4            �            1259    32781    generated_ticket_id_seq    SEQUENCE     �   ALTER TABLE public.generated_ticket ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.generated_ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    224    4            �            1259    32822    history_operation    TABLE       CREATE TABLE public.history_operation (
    id integer NOT NULL,
    id_user integer NOT NULL,
    change money NOT NULL,
    type_transaction integer NOT NULL,
    is_succesfull boolean DEFAULT false NOT NULL,
    date date,
    "time" time without time zone
);
 %   DROP TABLE public.history_operation;
       public         heap r       postgres    false    4            �            1259    32857    history_operation_id_seq    SEQUENCE     �   ALTER TABLE public.history_operation ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.history_operation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    227    4            �            1259    16417    role    TABLE     N   CREATE TABLE public.role (
    id integer NOT NULL,
    naim text NOT NULL
);
    DROP TABLE public.role;
       public         heap r       postgres    false    4            �            1259    16422    role_id_seq    SEQUENCE     �   ALTER TABLE public.role ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    4    219            �            1259    32906    setting_game    TABLE     �  CREATE TABLE public.setting_game (
    id integer NOT NULL,
    base_move_cost numeric(10,2) DEFAULT 5.00 NOT NULL,
    initial_skill_cost numeric(10,2) DEFAULT 3.00 NOT NULL,
    payout_row_col numeric(10,2) DEFAULT 15.00 NOT NULL,
    payout_block numeric(10,2) DEFAULT 50.00 NOT NULL,
    payout_complete numeric(10,2) DEFAULT 500.00 NOT NULL,
    initial_filled_cells integer DEFAULT 40 NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);
     DROP TABLE public.setting_game;
       public         heap r       postgres    false    4            �            1259    32905    setting_game_id_seq    SEQUENCE     �   ALTER TABLE public.setting_game ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.setting_game_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    236    4            �            1259    32774    setting_ticket    TABLE       CREATE TABLE public.setting_ticket (
    id integer NOT NULL,
    "time" time without time zone,
    price_ticket money,
    percent_fond numeric,
    is_start boolean,
    count_number_row integer[],
    count_fill_user integer,
    arr_number integer[]
);
 "   DROP TABLE public.setting_ticket;
       public         heap r       postgres    false    4            �            1259    32773    setting_ticket_id_seq    SEQUENCE     �   ALTER TABLE public.setting_ticket ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.setting_ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    4    222            �            1259    32828    type_transaction    TABLE     Z   CREATE TABLE public.type_transaction (
    id integer NOT NULL,
    naim text NOT NULL
);
 $   DROP TABLE public.type_transaction;
       public         heap r       postgres    false    4            �            1259    32855    type_transaction_id_seq    SEQUENCE     �   ALTER TABLE public.type_transaction ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.type_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    228    4            �            1259    32817 	   user_info    TABLE     �   CREATE TABLE public.user_info (
    id integer NOT NULL,
    id_acc integer NOT NULL,
    balance_virtual money NOT NULL,
    balance_real money NOT NULL,
    is_vip boolean DEFAULT false,
    vip_stop_date date,
    category_vip integer
);
    DROP TABLE public.user_info;
       public         heap r       postgres    false    4            �            1259    32856    user_info_id_seq    SEQUENCE     �   ALTER TABLE public.user_info ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    226    4            �            1259    32890    vip_cost    TABLE     �   CREATE TABLE public.vip_cost (
    id integer NOT NULL,
    naim text,
    price money NOT NULL,
    count_day integer NOT NULL,
    category integer
);
    DROP TABLE public.vip_cost;
       public         heap r       postgres    false    4            �            1259    32897    vip_cost_id_seq    SEQUENCE     �   ALTER TABLE public.vip_cost ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.vip_cost_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    4    233            �          0    16389    account 
   TABLE DATA           L   COPY public.account (id, login, password, role_id, token, mail) FROM stdin;
    public               postgres    false    217   (^       �          0    32789    filled_ticket 
   TABLE DATA           �   COPY public.filled_ticket (id, id_user, date, "time", filled_cell, is_win, id_ticket, id_history_operation, multiplier_numbers, multiplier) FROM stdin;
    public               postgres    false    225   �h       �          0    32919    game 
   TABLE DATA           �   COPY public.game (id, id_user, grid, current_number, skip_count, current_move_cost, total_bets, total_payouts, is_active, date_created, time_created, id_setting_game) FROM stdin;
    public               postgres    false    238   �i       �          0    32782    generated_ticket 
   TABLE DATA           ~   COPY public.generated_ticket (id, id_setting_ticket, date_generated, time_generated, arr_number, arr_true_number) FROM stdin;
    public               postgres    false    224   �i       �          0    32822    history_operation 
   TABLE DATA           o   COPY public.history_operation (id, id_user, change, type_transaction, is_succesfull, date, "time") FROM stdin;
    public               postgres    false    227   Vj       �          0    16417    role 
   TABLE DATA           (   COPY public.role (id, naim) FROM stdin;
    public               postgres    false    219   �n       �          0    32906    setting_game 
   TABLE DATA           �   COPY public.setting_game (id, base_move_cost, initial_skill_cost, payout_row_col, payout_block, payout_complete, initial_filled_cells, is_active) FROM stdin;
    public               postgres    false    236   �n       �          0    32774    setting_ticket 
   TABLE DATA           �   COPY public.setting_ticket (id, "time", price_ticket, percent_fond, is_start, count_number_row, count_fill_user, arr_number) FROM stdin;
    public               postgres    false    222   No       �          0    32828    type_transaction 
   TABLE DATA           4   COPY public.type_transaction (id, naim) FROM stdin;
    public               postgres    false    228   �o       �          0    32817 	   user_info 
   TABLE DATA           s   COPY public.user_info (id, id_acc, balance_virtual, balance_real, is_vip, vip_stop_date, category_vip) FROM stdin;
    public               postgres    false    226   |q       �          0    32890    vip_cost 
   TABLE DATA           H   COPY public.vip_cost (id, naim, price, count_day, category) FROM stdin;
    public               postgres    false    233   Dr       �           0    0    account_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.account_id_seq', 364, true);
          public               postgres    false    218            �           0    0    filled_ticket_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.filled_ticket_id_seq', 90, true);
          public               postgres    false    232            �           0    0    game_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.game_id_seq', 8, true);
          public               postgres    false    237            �           0    0    generated_ticket_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.generated_ticket_id_seq', 3705, true);
          public               postgres    false    223            �           0    0    history_operation_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.history_operation_id_seq', 303, true);
          public               postgres    false    231            �           0    0    role_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.role_id_seq', 3, true);
          public               postgres    false    220            �           0    0    setting_game_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.setting_game_id_seq', 4, true);
          public               postgres    false    235            �           0    0    setting_ticket_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.setting_ticket_id_seq', 49, true);
          public               postgres    false    221            �           0    0    type_transaction_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.type_transaction_id_seq', 25, true);
          public               postgres    false    229            �           0    0    user_info_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.user_info_id_seq', 24, true);
          public               postgres    false    230            �           0    0    vip_cost_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.vip_cost_id_seq', 3, true);
          public               postgres    false    234            �           2606    16430    account account_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.account DROP CONSTRAINT account_pkey;
       public                 postgres    false    217            �           2606    32795     filled_ticket filled_ticket_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.filled_ticket
    ADD CONSTRAINT filled_ticket_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.filled_ticket DROP CONSTRAINT filled_ticket_pkey;
       public                 postgres    false    225            �           2606    32933    game game_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.game DROP CONSTRAINT game_pkey;
       public                 postgres    false    238            �           2606    32788 &   generated_ticket generated_ticket_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.generated_ticket
    ADD CONSTRAINT generated_ticket_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.generated_ticket DROP CONSTRAINT generated_ticket_pkey;
       public                 postgres    false    224            �           2606    32827 (   history_operation history_operation_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.history_operation
    ADD CONSTRAINT history_operation_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.history_operation DROP CONSTRAINT history_operation_pkey;
       public                 postgres    false    227            �           2606    16440    role role_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.role DROP CONSTRAINT role_pkey;
       public                 postgres    false    219            �           2606    32917    setting_game setting_game_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.setting_game
    ADD CONSTRAINT setting_game_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.setting_game DROP CONSTRAINT setting_game_pkey;
       public                 postgres    false    236            �           2606    32780 "   setting_ticket setting_ticket_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.setting_ticket
    ADD CONSTRAINT setting_ticket_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.setting_ticket DROP CONSTRAINT setting_ticket_pkey;
       public                 postgres    false    222            �           2606    16442    account token 
   CONSTRAINT     Y   ALTER TABLE ONLY public.account
    ADD CONSTRAINT token UNIQUE (token) INCLUDE (token);
 7   ALTER TABLE ONLY public.account DROP CONSTRAINT token;
       public                 postgres    false    217            �           2606    32834 &   type_transaction type_transaction_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.type_transaction
    ADD CONSTRAINT type_transaction_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.type_transaction DROP CONSTRAINT type_transaction_pkey;
       public                 postgres    false    228            �           2606    16444    account unique_login 
   CONSTRAINT     P   ALTER TABLE ONLY public.account
    ADD CONSTRAINT unique_login UNIQUE (login);
 >   ALTER TABLE ONLY public.account DROP CONSTRAINT unique_login;
       public                 postgres    false    217            �           2606    32865    account unique_mail 
   CONSTRAINT     N   ALTER TABLE ONLY public.account
    ADD CONSTRAINT unique_mail UNIQUE (mail);
 =   ALTER TABLE ONLY public.account DROP CONSTRAINT unique_mail;
       public                 postgres    false    217            �           2606    32945    type_transaction unique_naim 
   CONSTRAINT     W   ALTER TABLE ONLY public.type_transaction
    ADD CONSTRAINT unique_naim UNIQUE (naim);
 F   ALTER TABLE ONLY public.type_transaction DROP CONSTRAINT unique_naim;
       public                 postgres    false    228            �           2606    32821    user_info user_info_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.user_info
    ADD CONSTRAINT user_info_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.user_info DROP CONSTRAINT user_info_pkey;
       public                 postgres    false    226            �           2606    32896    vip_cost vip_cost_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.vip_cost
    ADD CONSTRAINT vip_cost_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.vip_cost DROP CONSTRAINT vip_cost_pkey;
       public                 postgres    false    233            �           2606    32850    user_info accid    FK CONSTRAINT     y   ALTER TABLE ONLY public.user_info
    ADD CONSTRAINT accid FOREIGN KEY (id_acc) REFERENCES public.account(id) NOT VALID;
 9   ALTER TABLE ONLY public.user_info DROP CONSTRAINT accid;
       public               postgres    false    3278    217    226            �           2606    32939    game fk_setting_game    FK CONSTRAINT     �   ALTER TABLE ONLY public.game
    ADD CONSTRAINT fk_setting_game FOREIGN KEY (id_setting_game) REFERENCES public.setting_game(id) ON DELETE SET NULL;
 >   ALTER TABLE ONLY public.game DROP CONSTRAINT fk_setting_game;
       public               postgres    false    3304    236    238            �           2606    32934    game fk_user    FK CONSTRAINT     �   ALTER TABLE ONLY public.game
    ADD CONSTRAINT fk_user FOREIGN KEY (id_user) REFERENCES public.user_info(id) ON DELETE CASCADE;
 6   ALTER TABLE ONLY public.game DROP CONSTRAINT fk_user;
       public               postgres    false    226    238    3294            �           2606    32859 "   filled_ticket id_history_operation    FK CONSTRAINT     �   ALTER TABLE ONLY public.filled_ticket
    ADD CONSTRAINT id_history_operation FOREIGN KEY (id_history_operation) REFERENCES public.history_operation(id) NOT VALID;
 L   ALTER TABLE ONLY public.filled_ticket DROP CONSTRAINT id_history_operation;
       public               postgres    false    3296    227    225            �           2606    32835    history_operation idtransaction    FK CONSTRAINT     �   ALTER TABLE ONLY public.history_operation
    ADD CONSTRAINT idtransaction FOREIGN KEY (type_transaction) REFERENCES public.type_transaction(id) NOT VALID;
 I   ALTER TABLE ONLY public.history_operation DROP CONSTRAINT idtransaction;
       public               postgres    false    228    3298    227            �           2606    32840    history_operation iduser    FK CONSTRAINT     �   ALTER TABLE ONLY public.history_operation
    ADD CONSTRAINT iduser FOREIGN KEY (id_user) REFERENCES public.user_info(id) NOT VALID;
 B   ALTER TABLE ONLY public.history_operation DROP CONSTRAINT iduser;
       public               postgres    false    227    226    3294            �           2606    16477    account roleid    FK CONSTRAINT     v   ALTER TABLE ONLY public.account
    ADD CONSTRAINT roleid FOREIGN KEY (role_id) REFERENCES public.role(id) NOT VALID;
 8   ALTER TABLE ONLY public.account DROP CONSTRAINT roleid;
       public               postgres    false    3286    217    219            �           2606    32953    filled_ticket ticketid    FK CONSTRAINT     �   ALTER TABLE ONLY public.filled_ticket
    ADD CONSTRAINT ticketid FOREIGN KEY (id_ticket) REFERENCES public.setting_ticket(id) NOT VALID;
 @   ALTER TABLE ONLY public.filled_ticket DROP CONSTRAINT ticketid;
       public               postgres    false    225    222    3288            �           2606    32802    generated_ticket ticketsetting    FK CONSTRAINT     �   ALTER TABLE ONLY public.generated_ticket
    ADD CONSTRAINT ticketsetting FOREIGN KEY (id_setting_ticket) REFERENCES public.setting_ticket(id) NOT VALID;
 H   ALTER TABLE ONLY public.generated_ticket DROP CONSTRAINT ticketsetting;
       public               postgres    false    224    222    3288            �           2606    32845    filled_ticket userid    FK CONSTRAINT     �   ALTER TABLE ONLY public.filled_ticket
    ADD CONSTRAINT userid FOREIGN KEY (id_user) REFERENCES public.user_info(id) NOT VALID;
 >   ALTER TABLE ONLY public.filled_ticket DROP CONSTRAINT userid;
       public               postgres    false    3294    226    225            �   �
  x�͘Y��躆���ѧe1#����YI�Y�If��˯���:�h�w��P����F������O(������x;�T�Ĳ��cu���͡��"����UjR�����ŋp�0S3�7WT2��+)�o�cQ��Nj�퀼j�D	] EM�m'T��9|�[h.��� �K{
�U�	��$�SX
�m X�Ϧ̷O�v�����}Fsd����!�᢬'bO/
�r����^9�@�u�� S|�6���8�[�����#�7䇌��9nQ�9G�pj5�� ������A9;�W/�}lܦ\�)��������%*�F�!d-
��H�܎IZ�Md�s��	׺�� W���Alz�l\G�mVr�����E�������QK����m!NW�P%���]�n�$�P��>�z�7�+t�4/���x�_�5��!v����}��膹fF��ґ+��N����(�lh�*�s�/JAd�"�����^I(K�R�[�!�JEhH�F���1���/�/� �J1�@������T4��X�#�)�FL~I��iq�|?ى+�ǶF�%�}�^,�Z#���˫�1'y�;������PVTiw�a`�f>�����<�6ݲ�����c��Je\Z+�0U�sPzx�Bw  � �x��ʲ��w�Gs۝�t��r�N� ����6�Y�<vR�7 �'�&_���l(�D�7��g�Z��"@���S���W�\R�|8Vqo�� �� � `�nRx7��'� j֯)u�د.uB%� ��zhNӶ�Fԥy���E�_�ۍ@��:���5���4*C}��<�B#����H�1Q�)�I �=,� _*��0!��=�\��Y��m#�p5� lSI�2u�|x�U�_���9l�
���aN�]+����⫃'�Wqw��@��5�ܾ	����W�_��`��РD<!]o��݆U��dṗ *t_͸�d�ۢBY^��<ETc+Xף��b:ib�J|���:"�.��R���o"��嚦]�tɆ�Fr�A2�ף����Su,2����y�zN&����� ���-8O�X���j��)*�����(�:-hˍ&�z��4����R�A�q����*Ay� �\��ˁ-��$>T\�eqr q��s����,�6�M�޹0��6(�V�Jn���띬�$<��m�b"�����f?���Fȱ:f���oP��7���2�^��a����L|�d?��Q��% ?�ϕ�h�̻zO�c)���k�L.oOjo�V�hi���v�c{y�v1<n+,�λl�zJ$C
$X���BO��:ƞ%��@6�����LZ!��G�&�����]�t���V�ˈ�{���~u�3L���9����|5dT5�������	�+[V@�T�N�.H�=}�*Ǫ:��L>[�Mq�m���?(���׺^)�Ќޚ�U�{�k����u������I��_�7��=�{/"X(�C0�����<�� ��=~czdqY\���熄���}!^1�=C�'���QR��&�%��r�;&B��ȓ�����x꧸��7#QG��ވf0��C�R� �bUg���H#l	�r_ooZ��k�Zp�EE��p���HY]H��E��5�ͅ�����kζZ�J���M�r�4V��-�t�nt�dڿ��dm"3΀��a)ʵ"�V/M�k����@�Ƞ��u|ߜ�S}���LXZ��z�T��}��끙2HV5����\����gb�G�T~9�}�$���R�T�
��r����ӅsLά!a�8�")�ssJ��r�}t ����6�n�a�qrD�J��0����N��q�q���AVd�OO�&���X�>ԧ�I>L��,q�AS��O�F��ϻ~��>e�(G�A�ޑ��g^���ƴ�w�Y~<-'���Hd����8�g�+ؖ	��%<-	���`vq�o[�����[�4!���0 �� �mU"L��~����u3�?�j�X�4H��CEX�}�$�S���<Ҏ���cg�87�TȄШS�� 7��J	���E���!v[�<���H���r���JZ	�q:=>�w�4�� [�犓�kU�)��*�x�@���;\�AR``#� �����Ч]��0��#��s�51=���*��Z�Iv��J~[&DUٶ��*�`�d�, b�^N�z��ᘁD��vx��[���F���f����و 
�:���!E>G�s�?�FjR�����4m|��1p��ǖ�?4�rd�{.XRf���,�~:y@�:����"-�.�Fs]]�Z���#H7"/.�WQiފ���u�bF��m@l=Q�
P�H�༸�"��=��O�c0{(���h��	B�b��zT��0nb���4�ך�L���e�c*w���4�}��!�ץ���ǂg|���_dЈV4��!�E�Ґ�ͪ�$�Nz2�D�����W�L��B���dM���]�t��������笛��H��|>���#M���m�x�Kn�c���_ci)�%sý�aY��5�0$O��$'�8�,}�(��[��H�S�D�q��^$�5}��C�-G���רg�N�܊�J����tK��$5d�1���0�G׏K�/z����`(g��N_���1��Y>��k����	�}      �   �   x�m�A�0�59E�:@BBz/P�z�?��:����+|�Y��H֬+W�4EI����Ҁ������e�-��)�;ܮ�ـ��*�bg�@İ�E�\�����j[=G.�N����<t�p2s{��b��������e�X�_w{����S�6O�x���x��R���E�������=���^�\n��$�S�]���b�K��n`      �      x������ � �      �   x   x�]���0�7TA�Ď[q������;Zm�`�T?ď*P|h*0��b*L�T�:��Ԙt��������?�dH��|쉔7J
v�}op�ٲ���d!��i��A�/�$e      �   :  x���A��8����ud��(��g�`��ͬj��6�W#`Q����m���ׯ뻵����뫭�h����8޽-���0�u�	�X�����֛�&.ڻ�.`a�u�~�ݿg{��??����@Ϳ�j/�ub����pTtP������� uY
��9jb]�-�{�������u7�wLGM�ch��!�_�=(Nh��VC��V�{P�¡��~7\qh����=(����g�����A�Q�}��3���� e܏�e܃��e�ϻa]Ӹ�w'e܃�|M��O�~�N��k����Ӹ�Ӹ�y2M��CY���u��uϗѲ��l/�>)�>)�O���Iy���{L��ݓ��Iy���û'�ݓ��1чwOʻ�irx�8��i���~Z�O�i���i�'e���qZ�|���=�ۧu?�����V8���۸_w��mܯ|��q������ʉ��=>3yE�~݋�q���6�Aїv��khk��p��v��xi���}��������A�si���.�~�w���cQQ�W�A���K�/��W�h�}Q(�>)�¿I*3�r_���'��)�r���W4�� ����|i��x��=��]�']�Eݸ�xFG7�/��э�e�c�CvmQ�%���Y��ڤ����fUvmQ���ڢ`UvmQ�%��(��][|ɮ-
�%�6)�UȮ-
'��ڤ&�ˮM
��k��{ٵ�&7	ٵE���ڤ:�e�gͅ�ڢ0�k����e�g��ڢ09�k���Ȯ}(���ڢ0_�kʺ�	 ��(��ڇ��yNȮ-
3!��(��ڇ��y�Ȯ-
3!����{̄�ڢ0�kʻ�LȮ���]j�[TvmQp/��(��]���|ɮ-��2�_ٵe܃������!��(ܣ�ڇ2����kʸ�Y=�Q6�Fx�'l{k��a�d��� B�mR^e��r���e��M�*˶(L�,ۢ0;�l�©#˶(ؗe*�}%˶(��l��/Y�I��!˶(Z5�#��l��UY�E��,ۢ`U�mR<�d��uY�<�Lٮ�3a�w۔-)ޣq?8Ô��/�a�v�W�0e��{{����������$�      �   B   x�3�0�{.츰����.6\�p��¾�\F��_�wa�Şہ�&��V�+F��� ��%�      �   L   x�}���0���q�
��X����,�P��wS�X��q]�=����-<�8Y�6;����N�sy�4      �   `   x�u�1�0���H(�P��1ܚ��u5����oA��*m�ZT)�.�.�EN3��᪲K�!�����$H ���������9A�@o_|f��� �      �   �  x��T;N�@���ؒ4��訨8�c�|d�J�@�Ɖ'&�fněݤ�1�#(��ξy3��f]��hMK��%%�R��c��
~��b�m��H�@�(�B8�X�-U���W�/�L�o)c��Ra���8��1���w8G���3�+3I��A��f����]h ��Q�ZR�H��\�	��IM���V��T�(���z��:p�w����H�9���Inׇ_��YS�H��ҐM����9�g�r��ť 9��틆	V�	A�J�@���HY��Nq<m�d�E3�h;z�ͥL����ǀ���V���Wsޞ�C��vFv�� �H@�Z%�7mp�(�C�T�ruq�L^p��-�`�z�#����@;��W� ��aK��ʏME<�g� ��G�#� ����b���P��c�׳W3���O�R�5�v      �   �   x�u�I!��9���"/�s^��+��u$���.0�h�����r��FH,�d�8%	�Ȣ� )Jd��T"�#�u������g��R%�W-��\��65b����z^������9��g����,���רg�������4��<'���=;<��_ܳ#m�'(��6�x)w}      �   X   x�=˱	�0�����%!�8L XXڋ3DQ$;��H�/�w���y��U����٪Vy���Y���߳�Y�.�3��E�}�$\     