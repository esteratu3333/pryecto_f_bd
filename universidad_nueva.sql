PGDMP                      }            universidad_nueva_y_diferente    17.4    17.4 6               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    16688    universidad_nueva_y_diferente    DATABASE     �   CREATE DATABASE universidad_nueva_y_diferente WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'es-MX';
 -   DROP DATABASE universidad_nueva_y_diferente;
                     postgres    false            �            1255    24930 9   datos_administrador(character varying, character varying)    FUNCTION     `  CREATE FUNCTION public.datos_administrador(correoo character varying, contrasenaa character varying) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare
tabla record;
  begin
   for tabla in
               select * from administrador where correo = correoo and contrasena =contrasenaa
   loop
    return next tabla;
    end loop;
  end;

  $$;
 d   DROP FUNCTION public.datos_administrador(correoo character varying, contrasenaa character varying);
       public               postgres    false            �            1255    24928 6   datos_estudiante(character varying, character varying)    FUNCTION     Z  CREATE FUNCTION public.datos_estudiante(correoo character varying, contrasenaa character varying) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare
tabla record;
  begin
   for tabla in
               select * from estudiante where correo = correoo and contrasena =contrasenaa
   loop
    return next tabla;
    end loop;
  end;

  $$;
 a   DROP FUNCTION public.datos_estudiante(correoo character varying, contrasenaa character varying);
       public               postgres    false            �            1255    24929 4   datos_profesor(character varying, character varying)    FUNCTION     V  CREATE FUNCTION public.datos_profesor(correoo character varying, contrasenaa character varying) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare
tabla record;
  begin
   for tabla in
               select * from profesor where correo = correoo and contrasena =contrasenaa
   loop
    return next tabla;
    end loop;
  end;

  $$;
 _   DROP FUNCTION public.datos_profesor(correoo character varying, contrasenaa character varying);
       public               postgres    false            �            1255    24921 m   insertarestudiante(integer, character varying, character varying, date, character varying, character varying) 	   PROCEDURE     C  CREATE PROCEDURE public.insertarestudiante(IN integer, IN character varying, IN character varying, IN date, IN character varying, IN character varying)
    LANGUAGE sql
    AS $_$
   INSERT INTO public.estudiante(
	   cedula, nombre, correo, fecha_nacimiento, celular, contrasena)
	   VALUES ($1, $2, $3, $4, $5, $6);
$_$;
 �   DROP PROCEDURE public.insertarestudiante(IN integer, IN character varying, IN character varying, IN date, IN character varying, IN character varying);
       public               postgres    false            �            1259    16872    administrador    TABLE     �   CREATE TABLE public.administrador (
    id_administrador integer,
    nombre character varying(100),
    correo character varying(100),
    contrasena character varying(100)
);
 !   DROP TABLE public.administrador;
       public         heap r       postgres    false            �            1259    16705 
   estudiante    TABLE     �   CREATE TABLE public.estudiante (
    cedula integer NOT NULL,
    nombre character varying(100),
    correo character varying(100),
    fecha_nacimiento date,
    celular character varying(15),
    contrasena character varying(100)
);
    DROP TABLE public.estudiante;
       public         heap r       postgres    false            �            1259    16730    facultad    TABLE     o   CREATE TABLE public.facultad (
    id_facultad integer NOT NULL,
    nombre_facultad character varying(100)
);
    DROP TABLE public.facultad;
       public         heap r       postgres    false            �            1259    16792    facultad_estudiante    TABLE     k   CREATE TABLE public.facultad_estudiante (
    cedula integer NOT NULL,
    id_facultad integer NOT NULL
);
 '   DROP TABLE public.facultad_estudiante;
       public         heap r       postgres    false            �            1259    16747    facultad_materia    TABLE     l   CREATE TABLE public.facultad_materia (
    id_facultad integer NOT NULL,
    id_materia integer NOT NULL
);
 $   DROP TABLE public.facultad_materia;
       public         heap r       postgres    false            �            1259    16762    facultad_profesor    TABLE     i   CREATE TABLE public.facultad_profesor (
    id_facultad integer NOT NULL,
    cedula integer NOT NULL
);
 %   DROP TABLE public.facultad_profesor;
       public         heap r       postgres    false            �            1259    16721    materias    TABLE     �   CREATE TABLE public.materias (
    id_materia integer NOT NULL,
    nombre_materia character varying(100),
    creditos integer
);
    DROP TABLE public.materias;
       public         heap r       postgres    false            �            1259    16898    notas_semestre2    TABLE     "  CREATE TABLE public.notas_semestre2 (
    cedula integer NOT NULL,
    id_materia integer NOT NULL,
    actividad character varying(200),
    nota_por_materia integer NOT NULL,
    semestre integer NOT NULL,
    anio integer NOT NULL,
    nota numeric,
    porcentaje numeric,
    CONSTRAINT notas_semestre2_anio_check CHECK (((anio >= 2023) AND (anio <= 2100))),
    CONSTRAINT notas_semestre2_nota_check CHECK (((nota >= (0)::numeric) AND (nota <= (5)::numeric))),
    CONSTRAINT notas_semestre2_nota_por_materia_check CHECK (((nota_por_materia >= 1) AND (nota_por_materia <= 6))),
    CONSTRAINT notas_semestre2_porcentaje_check CHECK (((porcentaje >= (0)::numeric) AND (porcentaje <= (100)::numeric))),
    CONSTRAINT notas_semestre2_semestre_check CHECK (((semestre >= 1) AND (semestre <= 2)))
);
 #   DROP TABLE public.notas_semestre2;
       public         heap r       postgres    false            �            1259    16857    prerequisitos    TABLE     n   CREATE TABLE public.prerequisitos (
    id_materia integer NOT NULL,
    id_prerrequisito integer NOT NULL
);
 !   DROP TABLE public.prerequisitos;
       public         heap r       postgres    false            �            1259    16714    profesor    TABLE     �   CREATE TABLE public.profesor (
    cedula integer NOT NULL,
    nombre character varying(100),
    correo character varying(100),
    fecha_nacimiento date,
    celular character varying(15),
    salario numeric,
    contrasena character varying(100)
);
    DROP TABLE public.profesor;
       public         heap r       postgres    false            �            1259    16777    profesor_materia    TABLE     g   CREATE TABLE public.profesor_materia (
    cedula integer NOT NULL,
    id_materia integer NOT NULL
);
 $   DROP TABLE public.profesor_materia;
       public         heap r       postgres    false            �            1259    16842 
   tiempo_dia    TABLE     �  CREATE TABLE public.tiempo_dia (
    dia character(1),
    hora_comienzo smallint,
    minuto_comienzo smallint,
    segundo_comienzo smallint,
    hora_fin smallint,
    minuto_fin smallint,
    segundo_fin smallint,
    CONSTRAINT tiempo_dia_dia_check CHECK ((dia = ANY (ARRAY['M'::bpchar, 'T'::bpchar, 'W'::bpchar, 'H'::bpchar, 'F'::bpchar]))),
    CONSTRAINT tiempo_dia_hora_comienzo_check CHECK (((hora_comienzo >= 0) AND (hora_comienzo <= 23))),
    CONSTRAINT tiempo_dia_hora_fin_check CHECK (((hora_fin >= 0) AND (hora_fin <= 23))),
    CONSTRAINT tiempo_dia_minuto_comienzo_check CHECK (((minuto_comienzo >= 0) AND (minuto_comienzo <= 59))),
    CONSTRAINT tiempo_dia_minuto_fin_check CHECK (((minuto_fin >= 0) AND (minuto_fin <= 59))),
    CONSTRAINT tiempo_dia_segundo_comienzo_check CHECK (((segundo_comienzo >= 0) AND (segundo_comienzo <= 59))),
    CONSTRAINT tiempo_dia_segundo_fin_check CHECK (((segundo_fin >= 0) AND (segundo_fin <= 59)))
);
    DROP TABLE public.tiempo_dia;
       public         heap r       postgres    false                      0    16872    administrador 
   TABLE DATA           U   COPY public.administrador (id_administrador, nombre, correo, contrasena) FROM stdin;
    public               postgres    false    227   Q                 0    16705 
   estudiante 
   TABLE DATA           c   COPY public.estudiante (cedula, nombre, correo, fecha_nacimiento, celular, contrasena) FROM stdin;
    public               postgres    false    217   OQ                 0    16730    facultad 
   TABLE DATA           @   COPY public.facultad (id_facultad, nombre_facultad) FROM stdin;
    public               postgres    false    220   �`                 0    16792    facultad_estudiante 
   TABLE DATA           B   COPY public.facultad_estudiante (cedula, id_facultad) FROM stdin;
    public               postgres    false    224   Ea                 0    16747    facultad_materia 
   TABLE DATA           C   COPY public.facultad_materia (id_facultad, id_materia) FROM stdin;
    public               postgres    false    221   (b                 0    16762    facultad_profesor 
   TABLE DATA           @   COPY public.facultad_profesor (id_facultad, cedula) FROM stdin;
    public               postgres    false    222   �b                 0    16721    materias 
   TABLE DATA           H   COPY public.materias (id_materia, nombre_materia, creditos) FROM stdin;
    public               postgres    false    219   Ic                 0    16898    notas_semestre2 
   TABLE DATA           |   COPY public.notas_semestre2 (cedula, id_materia, actividad, nota_por_materia, semestre, anio, nota, porcentaje) FROM stdin;
    public               postgres    false    228   �f                 0    16857    prerequisitos 
   TABLE DATA           E   COPY public.prerequisitos (id_materia, id_prerrequisito) FROM stdin;
    public               postgres    false    226   5�                 0    16714    profesor 
   TABLE DATA           j   COPY public.profesor (cedula, nombre, correo, fecha_nacimiento, celular, salario, contrasena) FROM stdin;
    public               postgres    false    218   ��                 0    16777    profesor_materia 
   TABLE DATA           >   COPY public.profesor_materia (cedula, id_materia) FROM stdin;
    public               postgres    false    223   ��                 0    16842 
   tiempo_dia 
   TABLE DATA           ~   COPY public.tiempo_dia (dia, hora_comienzo, minuto_comienzo, segundo_comienzo, hora_fin, minuto_fin, segundo_fin) FROM stdin;
    public               postgres    false    225   ��       ]           2606    16709    estudiante estudiante_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.estudiante
    ADD CONSTRAINT estudiante_pkey PRIMARY KEY (cedula);
 D   ALTER TABLE ONLY public.estudiante DROP CONSTRAINT estudiante_pkey;
       public                 postgres    false    217            k           2606    16796 ,   facultad_estudiante facultad_estudiante_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.facultad_estudiante
    ADD CONSTRAINT facultad_estudiante_pkey PRIMARY KEY (cedula, id_facultad);
 V   ALTER TABLE ONLY public.facultad_estudiante DROP CONSTRAINT facultad_estudiante_pkey;
       public                 postgres    false    224    224            e           2606    16751 &   facultad_materia facultad_materia_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.facultad_materia
    ADD CONSTRAINT facultad_materia_pkey PRIMARY KEY (id_facultad, id_materia);
 P   ALTER TABLE ONLY public.facultad_materia DROP CONSTRAINT facultad_materia_pkey;
       public                 postgres    false    221    221            c           2606    16734    facultad facultad_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.facultad
    ADD CONSTRAINT facultad_pkey PRIMARY KEY (id_facultad);
 @   ALTER TABLE ONLY public.facultad DROP CONSTRAINT facultad_pkey;
       public                 postgres    false    220            g           2606    16766 (   facultad_profesor facultad_profesor_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.facultad_profesor
    ADD CONSTRAINT facultad_profesor_pkey PRIMARY KEY (id_facultad, cedula);
 R   ALTER TABLE ONLY public.facultad_profesor DROP CONSTRAINT facultad_profesor_pkey;
       public                 postgres    false    222    222            a           2606    16725    materias materias_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.materias
    ADD CONSTRAINT materias_pkey PRIMARY KEY (id_materia);
 @   ALTER TABLE ONLY public.materias DROP CONSTRAINT materias_pkey;
       public                 postgres    false    219            o           2606    16909 $   notas_semestre2 notas_semestre2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.notas_semestre2
    ADD CONSTRAINT notas_semestre2_pkey PRIMARY KEY (nota_por_materia, cedula, id_materia, semestre, anio);
 N   ALTER TABLE ONLY public.notas_semestre2 DROP CONSTRAINT notas_semestre2_pkey;
       public                 postgres    false    228    228    228    228    228            m           2606    16861     prerequisitos prerequisitos_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.prerequisitos
    ADD CONSTRAINT prerequisitos_pkey PRIMARY KEY (id_materia, id_prerrequisito);
 J   ALTER TABLE ONLY public.prerequisitos DROP CONSTRAINT prerequisitos_pkey;
       public                 postgres    false    226    226            i           2606    16781 &   profesor_materia profesor_materia_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.profesor_materia
    ADD CONSTRAINT profesor_materia_pkey PRIMARY KEY (cedula, id_materia);
 P   ALTER TABLE ONLY public.profesor_materia DROP CONSTRAINT profesor_materia_pkey;
       public                 postgres    false    223    223            _           2606    16720    profesor profesor_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.profesor
    ADD CONSTRAINT profesor_pkey PRIMARY KEY (cedula);
 @   ALTER TABLE ONLY public.profesor DROP CONSTRAINT profesor_pkey;
       public                 postgres    false    218            v           2606    16797 3   facultad_estudiante facultad_estudiante_cedula_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_estudiante
    ADD CONSTRAINT facultad_estudiante_cedula_fkey FOREIGN KEY (cedula) REFERENCES public.estudiante(cedula);
 ]   ALTER TABLE ONLY public.facultad_estudiante DROP CONSTRAINT facultad_estudiante_cedula_fkey;
       public               postgres    false    217    224    4701            w           2606    16802 8   facultad_estudiante facultad_estudiante_id_facultad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_estudiante
    ADD CONSTRAINT facultad_estudiante_id_facultad_fkey FOREIGN KEY (id_facultad) REFERENCES public.facultad(id_facultad);
 b   ALTER TABLE ONLY public.facultad_estudiante DROP CONSTRAINT facultad_estudiante_id_facultad_fkey;
       public               postgres    false    224    220    4707            p           2606    16752 2   facultad_materia facultad_materia_id_facultad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_materia
    ADD CONSTRAINT facultad_materia_id_facultad_fkey FOREIGN KEY (id_facultad) REFERENCES public.facultad(id_facultad);
 \   ALTER TABLE ONLY public.facultad_materia DROP CONSTRAINT facultad_materia_id_facultad_fkey;
       public               postgres    false    4707    220    221            q           2606    16757 1   facultad_materia facultad_materia_id_materia_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_materia
    ADD CONSTRAINT facultad_materia_id_materia_fkey FOREIGN KEY (id_materia) REFERENCES public.materias(id_materia);
 [   ALTER TABLE ONLY public.facultad_materia DROP CONSTRAINT facultad_materia_id_materia_fkey;
       public               postgres    false    4705    219    221            r           2606    16772 /   facultad_profesor facultad_profesor_cedula_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_profesor
    ADD CONSTRAINT facultad_profesor_cedula_fkey FOREIGN KEY (cedula) REFERENCES public.profesor(cedula);
 Y   ALTER TABLE ONLY public.facultad_profesor DROP CONSTRAINT facultad_profesor_cedula_fkey;
       public               postgres    false    222    218    4703            s           2606    16767 4   facultad_profesor facultad_profesor_id_facultad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_profesor
    ADD CONSTRAINT facultad_profesor_id_facultad_fkey FOREIGN KEY (id_facultad) REFERENCES public.facultad(id_facultad);
 ^   ALTER TABLE ONLY public.facultad_profesor DROP CONSTRAINT facultad_profesor_id_facultad_fkey;
       public               postgres    false    4707    222    220            z           2606    16910 +   notas_semestre2 notas_semestre2_cedula_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_semestre2
    ADD CONSTRAINT notas_semestre2_cedula_fkey FOREIGN KEY (cedula) REFERENCES public.estudiante(cedula);
 U   ALTER TABLE ONLY public.notas_semestre2 DROP CONSTRAINT notas_semestre2_cedula_fkey;
       public               postgres    false    4701    228    217            {           2606    16915 /   notas_semestre2 notas_semestre2_id_materia_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_semestre2
    ADD CONSTRAINT notas_semestre2_id_materia_fkey FOREIGN KEY (id_materia) REFERENCES public.materias(id_materia);
 Y   ALTER TABLE ONLY public.notas_semestre2 DROP CONSTRAINT notas_semestre2_id_materia_fkey;
       public               postgres    false    219    4705    228            x           2606    16862 +   prerequisitos prerequisitos_id_materia_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prerequisitos
    ADD CONSTRAINT prerequisitos_id_materia_fkey FOREIGN KEY (id_materia) REFERENCES public.materias(id_materia);
 U   ALTER TABLE ONLY public.prerequisitos DROP CONSTRAINT prerequisitos_id_materia_fkey;
       public               postgres    false    226    219    4705            y           2606    16867 1   prerequisitos prerequisitos_id_prerrequisito_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prerequisitos
    ADD CONSTRAINT prerequisitos_id_prerrequisito_fkey FOREIGN KEY (id_prerrequisito) REFERENCES public.materias(id_materia);
 [   ALTER TABLE ONLY public.prerequisitos DROP CONSTRAINT prerequisitos_id_prerrequisito_fkey;
       public               postgres    false    226    4705    219            t           2606    16782 -   profesor_materia profesor_materia_cedula_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.profesor_materia
    ADD CONSTRAINT profesor_materia_cedula_fkey FOREIGN KEY (cedula) REFERENCES public.profesor(cedula);
 W   ALTER TABLE ONLY public.profesor_materia DROP CONSTRAINT profesor_materia_cedula_fkey;
       public               postgres    false    223    218    4703            u           2606    16787 1   profesor_materia profesor_materia_id_materia_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.profesor_materia
    ADD CONSTRAINT profesor_materia_id_materia_fkey FOREIGN KEY (id_materia) REFERENCES public.materias(id_materia);
 [   ALTER TABLE ONLY public.profesor_materia DROP CONSTRAINT profesor_materia_id_materia_fkey;
       public               postgres    false    223    4705    219               :   x�340060331�LI,�L��z��ŉ���9�z�����ŕ9���y\1z\\\ ڮV         `  x�uZMs�8=#��@(����$�q���r�N�a�.�pHI5�-?%�r��uo�c��A�3&�J��2H4�_�א�鏊�x7l��t���{o����������l�[+Wn#TU�E�/�	~W'E������ި��Q�j�����W�q��Z^M������s��6�o�\;��g��"N�ć"��$�`"�w�ݹˮwX��g��sC��k��"���VJi��VM�Yg����� Lg�L��E\,T��MK�i`�L\��uCtc���X�G������E\-�a�ВYX4Wv���j�F7f�����$lrcV������h�:I�WI�T�
��l�}S�:z0m]��>��d�{Xe����KN�9�R"Ч���}����~�tt�`���3:�8ѓG���!��I�q�}��PR��,Ue�9��h��]���ZǑ������dA�I��ERŹ�$��k!�7fo��,�m�q�֊�{�0y��g�3�	
!��8/Tz��o]�XGg�]Ӛ>�0�i����f�bs����E��L�����R�6}���tȤۯLm��9��Z*N��%����/��?� ��CU:˪�C�ִx��c�{jp��mo����*��U>�u��
C���
��Bu�R���6��EWn�$3������Op"�L����㲊�IQ��ʫ��2�`��ώ
�yv(�3 � ��wd�=[%��|CrN�1Ź�TV��|�w�qJ��Cf�VXoB6K�M�X%\�eV��P���>����߆��l/�a��`2�\�e�[8c��T�ҙ
�\���-ń��7���3�2c}`�=̟�9,|�UEVy�	�x�A2۾9D��O�#Ua_�r��Q|	 D@�B�c��G�_[st������dk]'{2�k!�-��$
D	��냳������1`�(uo�Dw#��p�^T<{绩V���e�+���^z��1��b��\n\�!FWj��y�ơR��|kȬ��_W���"�5����KD��Xxa�NԖ,�-+X�+W/瞤:M�@9 ��Y�j�zw�1PBY*���^�n�$��ց�2q��h��E0{��CF96��篫'~R�U(�9�n�P�lk�������p �{oGKes I3�T�$+�1���*�і�'�b�{]rI.<p3z�ъ�g�W0�Hu��|�νi�xG7�i'�@;`
�l¥��e�!���� �х[a�G��j�#��SUY�m(�_;���zG�X@��?~sq����>� m�7Z>1<���xs��ʙ�HG��fQ_=�Odl�����^:����4����4	Q�D{tm�������v���L'�	�jt�e����I�d>?~���nX����dU�Li'�\{O���agqQe��@�%��E���h�=D�vF<y;�nC������^@rTi� �_������!�Ϣ���6l�6�es����D��i��P�Hrq֛�m��%u�%�[�dE�#�]�`Z�(s��Pz��l��L�}4ύ=hq7�ܒ- �2�jJ�4�C�R
�}�����lI��f�`|t���<@e#VeNb��	��������cK��G�9jĚ}Ҵ����y�|7�P���ʼDݝ<+��V,0]��D���mb�:6���y1fc����@�R�]��7����֡}w�:���g�e�6�Oќ�06�f)t�ȩ����$��z��`�L[G��=(�̷�m��@��E��)����<4��꣤EE4�����"���R" $x�%uQKd���m�����|�Gn-9���8嚄�q���yHM�����E��,`��Qb�����4 �)��
x��;��%�Vk{���Y�'�<�,�ɜԸ&Aaa.p�M��u��R�߻��>�G���l�wXE���R(��������޴khw��n��0o�o�zE�Ӱ#CN���ĵ%EB���M�rw�P�Zo'NEv��}+�uŔ-e͕T:�
��j������a֨�����T��vb?Q�@�<2�us�
�2�j�o�?h+���eݜ:�䂡*S������k����M��5K�o_:��у��=����:��r�_(���&U{6�wރ)�� ����$�<r�=�-,i��]�E,g��
-/���9�rT��%�}�ϼ��We��4z��QX;�5`�kG�
�a��}�^r��y�T�tY��H1s�Ԅ*��,vD�3ټ���C ,��B�*+�Y���H�qk|G4l����`3L��ޫbVb���K`� �D ]��P�a���sڃR'�d���:Ч���)���"L��U��ѐ��CMgi\E��9d��@'g� nЎsF�ɵy�Q������`w��jbB,��H)��B˕8� �=��x�°�Jn<� �-YY�
u�Cӕ\C��~����!;@�x IO���2(PA@pl��=+��HK��ǟ��#�ۍ�`}m�'��<� լB����Ti����@6��~�i�t��KJ8]EPKg�o�1[����V��ni�;9�B�ɪҥV��=Z�5�1�̏��{�I& ΐ�����e��<����4PLy .A�%]|�Y����d�\�c����?28t��tE��q2�#�j֤)<��a�G�7�y5)�"�I�B�&��ޚ���'��"����������8�ג�?]M��.I�Ҩ�UF�{gJ�i���������b�#`�J+�_��Tm4�j_'�Tq4�:�����8@V�4ա�-hdF�j�b3�yo��dd�O;��K���o��(��-uHh�~�����*	������c�lv��"���� ��ݐ���_x��ؖ_H���pg�"�,ש.�2�L����D*��o����l��$�@��x�Z����w�BY7{K��O�
ۛO����T��h���X|�Gt�e�v�����n�潦�c)�5`�H�Б��M�_O����=��F��Z:�y��<���T"ZP+�GT�=ω	�'<�s��"�'�1�����C3��S��]|�1�0�;]�Į����n	`��Ξ\H��u:���	�#U�U�R��vO������tga�ƈ%;>�L�d>UD4�q�R��e�_�e�8ţK�	F�������,e҄�'J��2�L��>�GkITv�f2݅�kIDvk���B�(��2�U�g9�n{���N�8���7��\�G/N�%�B�����U���ge��*2� � �m{������T9�D��~J]�<R;P����f~�Y��Ov���W�c������Ю���K�P�-��A?�]��a��b=�%b������+���D)��q���]�ڱ|��0l�X�N�o��~��x�e�@C50��y��]��x�� ��4��K�09��x'ϩbR|��.������x��B�
Ox�N��C`Z��q`/����h��@G�x�"`��� 6��8&&�L�@]V�C��>ݳҽ%u�q�F����]�@�b�G��e�#��\%�ҡ&�=�|�}�}ko�s!���ǧ�o$� e`D���%�gtOC/0��H�l��7��r��M_Ȓ$-�@��)L�h4��:����e���ܓ�~4/�h(N�xh�u�5�����s��!��UN�nZ���)z�@���lUp^��� ��/<�{d��P� �+�,��qFS�VC����v���ߞ�kPJ՞.RF��2]�zϼY#��UI����*4��i������4�6:�7�-�Q(���1ϪhR��,�Ь
�����7$�;C�Om͔[l�
���Xm���!�'`cY�7B�_��͛��ƀ�         v   x�3400�tI-JM���2400���KO��L-:�6Q�3/-�(����D���s~^IbJ)X6����1�cJnf^fqIQbr���y
)�
��E�ŉ� &h���f&�p��qqq ��/b         �   x�U��m�0D�s\L`��(����ȇ�=,�n3���k��4�\f��,�M��T5TUC�P5TUC�P5U�G5ޜf��Ls�e�ɸMU�*T��P�BU�
UK�zT��i���4�Y�1���T��RU�JU�*U��T�U�GoN3�e���2��dݦ�RU�JU�*U��T����<���4�\f��,�M�m�jU��U��VժZU���_�|_��)� �         �   x�5�ۑ�0D�o9�-	=r�������),h��轷�����Da�ą�� /țo=�0T2�,�i�1
�
����Y���D�<_��4�?�?����>-�xH�HN�-ɚ�NoMoM�eK�\��XuȜ�䈹�x�������U�i�)Z�*&Ũ�졝���y�����{���i         L   x�Uλ�  �:&� �d�9"@�r׽�LU/ד���d��h�F>d'Ǣ'hJ���d���WY�� '�*�-"�f3�         6  x�mT�r�F�_1��X�k�p��J[EJ,RUN���𔁙�tI�C�B��	�1w7@�K)�~���{ݩ��_�*�VD�d/���_��P��߶��S�FP�(�Rܪ ]�5�Jy��F�J�S����A��wO(V��٣:�Vתy���Ҿr08O6�j(.K҅���z{�+YC+��A��%,���g�3�=��cU���H5G�I���!w�QS+i1���pwi9{Y�]�Xi;b�	�֝6���~��Wv���a ד�\�L�l�Lf��QS�l1W�l~��������Ӕ4�&�uwv��4'��^�m�;bM�:0�z�eh���ҔĞ�U��&y\)t%�,���u ����i���J<�<����g���Z�C�g1���"S���������Q�9`�ζ(���(����E�� ��Y�j���Jn]�']�XP�(p}硉�����v�'� ���B�`N���ʗ�':�b�ɓ|%�k��4�ɏ�QFy�]�������PE��������7L�M�-]R],L���Ez�c��N�c�E&nl3.���H����X�%�\�jf��n�/r+�=��[��5[�������%6�W��tL%7��X���O���/���:3鎩+xy��sΚ'e�J|�~�{<<�g��Ī�\F���e�7��������"ו5���0u�|$�yt| �:��/�4�\�ĝwhRu�g�� �[e�I�*�~�2���`�\���쟺�6/��y$���AQ�uDև�/S�x�X�T�g����v�!\}���?VO�}g��&I�?�+�            x�}�Y��ҫ��/�8�{��_Ǎ,yg�#����`D�DJ����\e]��ϫ޵]��~���ʟZH]���>j��u���W�_g�P��*��z����<�zh���Y|&U��x�zCۦj�Գ�z���PmW�)�r�������e.��'�Y{.4�������=�\���)*�m�nh[�wX}���y��h�u�C�Y��g�*��Ӭ����Q�����?��:����G�B�]t^e�mTi{��ni�A�ڶ��Ӹ��,¤~<�ʦ��"=��9�J.(�u6�����������6;٭�j�	',�ww��5��Pc�|�R<�8�7?�ш�m?A�,�=�GmdsҖ��7�m���N蹿�r�Ǖ��T�P����Sx�Ja����3�B�������d'����GC�Mv5E�s�&�⯬d�u.�GM�hH�F;(m���?m7�Q��q;gP*��j�v.c���7��b��S*?������G�(yX��|���������vFd���՗@��H��$�k8�깰zh�hʋ}�rǋ'ŵ�O��hq5!��4�鸾��4�*F�H��R�֗�\[����m�8\Ŕ�Ya�ZX���:���i�TfEf�ѹ��D\�U�d��;xK�I�E�'�q�����ˮ�G�֬~�R�-���6����l4�j>jd�U��l���A�K:��T����M~�Y��ʜ>}q!yK[*4�c��ӯb�}/,�C��XmÛۧm���uR�3��h%�X���ظ��V."��G:�4���&� q�B�t!��8�nV��x��ۛ.��o�j>$̿r>.�63M�A.�Y����|�2eRX/����X��zX%s����}}q�}q�dJܔ���;�ª���պ�,�������ꔶ~�>�^Y�dU���j+�J�bS��{S>��2����[�������o���|h���y
��>�(pr�����o�N�=iښ_����A�����O������9���n��ɃD,d�EF�~Ɲ���I���Q���,r|�~;�+sj|�#�d2bCw��DڒOso��Č�!%mRQ�y�#�s��Q)�sl�i���k{���4�uq�,6.����g��ٴ�(�Pa3�4�lO/U��&*�Q�r��,ʅ����-Şf�M�Os������1~[T.JD�� �����|k,R�ġ��"OV9�ʨ�/j����@/zA�YŦ|�����J���\����T:�e�9�I����XԎ[���G�q�g��L�Ӗ/�h�ώ-��:�o��e1>=w2��*��q1�ӳ��^;ư�R9'VVe���◈�{�G�:ڃ�{���vt��:8�H��⭲*�E����3�>Hݬ�*����(�o6S�cH�h�n�˨V��A�*����и�U� J��=l�M�x��=s��\AV�ۚ��2_��ُfux{%Vtϗ�^H��>җ\rt����:Fc�D���3���&��ίU��|�^E���f���y?�קuޏ:�Ч�/}F���~�.�L
�2l�|>���?�Y���F��yw�o����ڒ�8+sA<GH���:��C����g\4�(������}?*���y�aUb������q�:�aU�o����ɪ����ת�f59�p=78ry�Ӕ�Ť�/I{Lބ�����+1c�R�9����E��7E���o?�bs�wAcˍteQ^1V;��wQ���)���o-B(T����lY�sځ""iq��M{Х-��ƽ�����Q��Q��)=s�m�[�y��y}��Y�|�1��5׏ئu�YИ�t�3,���IU�	�E9�V%bHǍ��%=s2)^G�q1's��8��i�6�PnV�E�v~�e\�8����&��뗏8:MyH�h7�5,���g��#�|�-|},s��i��陿�Җ��"m� %u���1nN�Wh��o/�F��m�;�99'�9s��Xls\�W��K)�Q_�h�|�FS�z�l��]|g�q�UY|S"�6vi+q���ĸ���:���<l]{���x�6]�ʥ ��n^I��u�u���{��*,�jݺ�[����*%oVM��ج����HT��Wz&��roU����ο����OCz&Ӧ<�ê|yI{��"��ʫ,M�ڡH��T�$�Vm+!���r����K�)m�w���Y�����Vյ(�P��nQe�����)bgUT:���Q�Ҡǝ����JVeTi+_�vi�=��L-���A_B����E�Gm��$9yޥ���q߭Sϛ�=١����y��S,c����q���W
,�~)`%9��Y�m�+�u�>Kz�9�����sѾ��֓Ͼ�}s�Q����{˟�Ӛ�~��U��'��APD�uq�WiU�rJ��5�M-����W�������*_)��'���h�*��v�H+�>��JLV�YT�8Y���� �E:հw펇V�^~�򵺴x���G��fi���bu��C^L�迖�oo1C���d������fU�H�;����ٿ��rv�Z�2��2��Q��J��HQ�����Ϩ<czZ9�I,�lq|_�7��W�|�4Y��%�r���?\�s����oe��}u<�7Q�͢�(���y�������/�?��_��[�"Q�YNa�e���r����+�S���)_m9�Д+^>�}T���Y�w�UNU�R����]M�]ܭ��R�.��dQ�?m�nE�RS��)F�/>�5�A����:���s���
��D����r\�vn�8�G*��K˰S���+�����7V�$�3/~E�D��qgi�]�r"�~�TE�4!M;�ɤ8D���?",��re�3�a����l=�wV)�H:Z�-V���sMo���//E�x���9h�b��?9��Y�G�_fti��MT{��#�W�ȱ@A-�A럩}�a�ZH]��
YV�oۧ�#�PR)�?���﷙�������Ϥ�^���6Uk��U-���q��'�S.<�Gun�`�˫�Is֞�+m+?/-s�9���ܶ����O'���f�q{_{�@^`\2��=?%4�??��Y5Q7��o#l#��u���	��B�]􁼀mTi{��ni�A�ڶ��Ӹ��,¤���*�������,*�����MجV��[ڢ��nt�W���d����'���J#����j����T�Gb����=q�m@^�'�lN����&�ŘF@^ )h[����y1�P����Sx�Ja���؅&=R�y+G�Nf�㠥�r�ȋ��B9Rm2 /���V�׹�5}�!m����>J��������3(��y5d;�1]U��C1TD�)�wp����P�������{��PWж\��Έ쿳���( /�}'�dy��z.��!��b����Iq���E��	�ϥ�L��5]@^L�*���ʶ�D��J��ns��*��
����g�yVG�H[Π2+2+����'⊯J&��S�ԛ]�A�����_�\��Ѭ�y1f�@^��q��VW�MT��q5y[�Rff{} /�2,,T�t�c��߯��I�>����ƅ�-m�А�y�CZN��]���Xm�b�on�/��*v����'5Z�3�"# /<;������Ǒ�'M鰸�?H��5]��Iu�Jƫ-��tv~�T�!9 /&k���:�:�����xʤ�^�e@^@=���uUq�o��������\2%nJ�	K��paU���j�dCTN�U�euJ[�Py1W7��r���
�ҳؔ��ޔO��̭|s��b�O+���&��ˇ&iO�����	, /�����o�bNyqKQٽ8�>�XcZ��9~�Jy�cXk�6��<H�B�Zd��g��*�q��=a��C���۩_�S�c9� ������� Җ|��x��&f<8q(y /�[7���\4���H���x^ۻ弸��9��#�`�q�4Em�8�UΦ�E��
����f{z�RO6Q�����dQ.��t�n)�t0hnz /�ѓ�����1~[T.JD�� ����T;y1�/ /�R�UN�2j㋚%�/�S�=�B7���J���\�=�h*��Ɯդ����b	�$�%��3y1G񀼘����:�    o��e1�_N�)/V�~����bB}@^ $��9��*[_X��Dl����������k�bj�>��[eU.����U@^@ݬ�*����(�g6S�cH�h�n�˨V��A�*����и�U� J��=l�M�x��=s}~��{X|nk���|Q+g?����Xu�=_�{x!��{ /.�ݿ"j��ј�=7Q�M��_�.Q�����Ǒ�*�����8o@^ 
��K�Q���E��#��s�[/���1�fuZ���1���NjKj���h!9#���ꬊ5V�7怼@B��Q�r: /�D��Qh�*�V%f����w�#V%�Vi�H����Q�x�*xhV��	�s�3 �7y1U�x}-SE�Ӓ����Z<�Č�K%�Ǘ���U����͕�=����SX�|s�E��z��.����Pu�*{<��e��5h����ő�7�A���j�6 /&)����=O陋m�ߊ�[�5�̳���j盌!m����8�,h�z:ȋ�r�JL�,ʡ��*C:n\e,陓ؐI�:Ҹ��9���;tء�j�
�fU.X�m���[���h��n���~	ȋ)�f�r�/�o�o�����e�_˜G,s�w�b���s.ҖPR'n����{�&���2 /�J��c��s��3�)���6�U�|�NQ���y1�����z; /�(�Sd���
y1g�����H[��'�M_����f��o�����l�U�\
�y1g�u�u���{��*,�jݺ�[����*%oVM��ج����HT��Wz&��roU����ο����OCz&Ӧ<�ê|yI{��"��ʫ,M�ڡH��T�$�Vm+!���r�ȋ	tyq��16����YUעC��E���7G�򧈝U9P����ys�ǝ����JVeTi+_�vi�=��L-���A_B����Eu@^��K���]�k(w��:���ܓ�h���7>�2���/Q91O�x[����vQ��[�u�6��[Gﳤg�3Zξy\>��j=����7�y1��@^Lȋ1��zY'�\'OV����J�(��Ҫ4�Nmk�Zd@^`������b���W�"�Ɇf���TY䷋�EZ	�����JLV�YT�8Y���� �E:հw펇V�^�3��o"9Y����q��,Vg�;�Ť��k���8�h'��<�ԗ7��Gz��ɵM@^L���(6�xd��e<_��%�@g��T�a������w�Ob�f������(u�z�+��*�5.��m��2���}.+�?���Έz /�3 /�?���[�.*H_X��28 /��>�E�����\��:���+�S���)_m9�Д+^>�=�hz�8��^��J[
qҔ�K�	���U�_��ń���,����4)�lS��_|rk"��V);q5t$��/u{�_)���������fq��TD%��a�F�-*W<���?�o�~I"g^��t������t�D�D0X�^��JiB�v�'�Iq�"[�D<X���"g�â����z$�R��t��[�V������_^����#[s��NK@^��r��ˌ.m9��j/��}�W�ȱ@A-�A[�n4 /�&����w	���]g�PSȋS��f�?c|C^�_$O /�ϡ�K�۽�='����Ux~��;����67���?Ҟ'�9����Ҷ���2���o�N /ж���m
y���l~y�qɬ�l /0�&ꦶ	�����ȟw|��Dc� �����Q��M�@^�_4�����y�J /-�y��J /�	��*����m݄������"]yq�n��e����k��ny�j�����g�#����ȋ񄀼��%�X��bL# /���M /fJ��H /���*���.4�y��@^`�;��G	��*���/�#�&���2�?��M /0ny�L /&J��������3h
yq;ع�I!/�o����'���&4Q9J&�7���2'�X��b�\@^`V	�Ŕ@yq�;�$Sȋ	��v�����R��m��x/Z\M���@�[M����$��by���@^��m�8)��By1��rxV)�'��@[��U
y1_�L�B^L)Ro>t��x"�˜˿�#��x /Ƭ��L /��	����y��	�ń�����'���7��6����T�T�Y��*ݜ�~��j
y�aߐ(4ސS����~��{y1N_;n����U�:�7���y1EF@^ xvV+�o�<��SzC^�?��[Ym�Tȋ[�y��M�a�I5��b�f@^�UH@^�:�����8���G'�P���7��w����}_\x&�h�@^`�	���yq�����s>ȋY������vk9�Ym���[/m�7�iy1.�@^L�i�[y�$u�����*\
y���X�8�B^��  /n)*�Wy1������@^LkM#��bJ����@^܌;[E
y�a;�\F�!/����@^��2����n��H[���bRL@^�Rߐ��&���Sj@^��k{���o�t�@^�PJ /�8o���E��ސS���u���l�r%*g��M�D��=WV�4�@^L�oG��b�򀼀Y�O��˷�"UJ)�V�y���Q_�$��y\ƀ��쁼�K؀�@tk���g�h�@^��D笖B^L��H�	��ę����x@^Lx��[Y|��@^�b<��0@y1'��bB}@^ $��9��*[���@�I /���Py1g̀��X�SC��/�*�r��@^L�
��o��cy1G���8���#������8�Za�雙���yy�qߐ�EU��a�o�S�XFy��M /0�&*���r�K /.Vtϗ�^���r���K /�2 /�s��$���p@^L)�s�5�Mb
y1����	�Ŕ>�|{[?�T�	����b�y@^ f�!/��F��I!/Pd$�S���\���2��@ϝU������(B�y;�ZN������@^L�]cFy1E~@^L�C�o�������@^���ly1����B^L�?^_�TQ��$�����B^�}���cy���X���Xl���dǀ��S�؜YSȋz
y�J /����b��qx�R��A���j:�����s\
ȋ��	ȋ)3�9�@^L�<��Q��v��xC^����8�,h��b�ܬ��ry�IIǍ���+�@^@M /�@	�v��ڸBI /�n& /�E	�Rzy1��y1�K@^L�7;��Sȋ�]�d��N�@^ D&��w�b���sN /�ȋ9�ͩ�
MT��e@^@����8'���Qy1W!�;ȋ)�bNy1�v@^�Q, /��ȋ��b�yG���Ĳ�b.��a�H!/.��6)��\��Ŝ�֭�U	��(���Y�[�7���=ZE���b�`@^�����(����x���q����7	��D�U/�HI /0��b����"��ʫ�@^L|]�\S�8`yq���Sȋ	tyq��16ȋ���E��5t�*��oȋ	��u����Z���y1g�5��H!/0jyq^2�\O!/�Ļ���Ym��$����b�L!/&�������B^�1}mM�	����+&�S�.Jr�b\��}Vy1�N��qS��M /�D	����y10 /�$��e��r��@^���.tO!/0ly1�@@^�E���V�W�������*_)��'�7����>��'	��@^`%ȋ��vq�����ȋ����j /0��� ���U$�S��=��"�����,fh<H /.ZL}y�@^�1��ȋ)㷜Sȋwq�A^LJ��oȋ9���Լ[x)��6��8[�\�e�s�6���"wV���>��)��7���a����zK�E��ȋ)]�bJ�skQ�@�4��B^���bb�)������Ŝ�O���A^�; /�:0 /�ߐqo��6�p��[��\@^L8ȋqۀ��R�!/Д&şmf��$MDv��    SJ /`�	��9׸�: ���#��C^ �$�6����&�����&����/I�̋_�&�sD:K�my1Ƴ8�e�H	�Ŝ�Ϻ8D�!/.Tly����2�!/�9	���M!/0�7���빦7�s�	�<:��@�@^��r��ˌ.m9��j/��}�W�!/��
�K�ߍ�����B6 /�o�:����B^�Z��6������"yy���b@^���%��9����=����)������	��9��<i�	�ƕ���7�����B^�muC��='�����Y��@^`VM�Mmȋ����?��:�Ʈ2 /`W	�l#����&�����X���@^z��K�@^�A�,Uy7J /0��������3 /.�mv����rMy��M /�C�U���,��b����y1�����˜@^�i��By��	���B)�	�bYy�Y%�؅&=R��~gU�(���]%����r��d@^zZ��y��	��M /��	��Dɀ��%�7n��B^�v.cR����14��@�I /�	MT��	��M /��	��9���4��Uy1%P@^��N6��bB�y��)/���m��=ދW)��=��V��Ť�"�,����@@^ �'�gt�#N
y���@^�!��U
y�I /�6���+$�S�U�d)�Ŕ"��CW
y�'�q�̹��=�Y��b�ꁼ@����@^LM�h�@^LX��zy�|C^�i��Iy1Y��*ݜ�~��j
y�aߐ(4ސS����~��{y1N_;n����U�:�7���y1EF@^ xvV+�o�<��SzC^�?���@^ �&�����ۛ.��o�j>$��d̀�������tV�/ /�qy�N /�&���o����Ź����L /�4����ȋ)�������? /�|��Py1W7��r���
�	��^�~o�'��b\������ʷ�I�J!/`�U4��y���q(����A@^�RTv��bN�y5���֚F�7�Ŕ��L5���w����vV��zC^ �%��7���#Rd2)����P�����Ť������!/�[	�2Ly1�Ԁ�8;���n9/.�ߐ�6��@��@^�qސ;�R	�!/��	ȋ�xk=�D�2JT�>	��&��|	�z~C^��ȋ���h�@^L]�0\��b�������X�7��VFm|Q�@^�{����쁼�K؀�@tk���g�h�@^��D笖B^L��H�	��ę����x@^Lx���@^��4 /n1�_N����~/���P�ɪrNL /��!/jȋ��;�@^�3 /&�����}苷�� ���@�PߐX��b�"yqf3�=Fy17tyqF��\�73}�{���!/�ȋ��7�)���U�v7�������2_���/���Xu�=_�{x!3ȋ�%G�/����ʀ�@�MTv��b�y1�@@^̅א7�)��8o@^ 
&�S����m�(R]&���oȋ��y����'��@��@^L��s12G��=wVŇ��s@^�I /��]T��lBy1yjt�	���y1�j�	�����@^���ly1����B^L�?^_�$�s9�7��㦐s_0����u��br�Xl���dǀ��S�؜YSȋz
y�J /����b��qx�R��A���j:�����s\
ȋ��	ȋ)3�9�@^L�<��Q��v��xC^����8�,h��b�ܬ��ry�IIǍ���+�@^@M /�@	�v��ڸBI /�n& /�E	�Rzy1��y1�K@^L�7;��Sȋ�]�d��N�@^ D&��w�b���sN /��9 /�7��+4Q���yU�6�㜜2��F	��\��W�L /�ȋ9}����y1G����"3 /�Vȋ9#�%����Ȁ�@,K /�rn6�����l�B^�UI@^̙h�z]�@^`�ȋ�պuȋ٣U4J�!/&���*�ȋ��Wa�O!/;��3�@^L�\�⋔��J /�j^M/�:���	����%�5���&����0���@��c���8��Z�a([C�(��@�K /&��-���_k=�0�7�Ŝ���Z"���;�5��.m���bN�kq�O!/`���v��K�K!/.�-���b�M@^\ϛ�)�����Ĝ@^���R`y1�$g /�����g%�s�o7��@��O�@^�o?���bLr�^։*��	��\�BG���&�S��Xd@^�m�~%*i;�l�򕢈|�yC^̽��o6��@^`%ȋ��vq�����ȋ����j /0��� ���U$�S��=��"�����,fh<H /.ZL}y�@^�1��ȋ)㷜Sȋwq�A^LJ��oȋ9���Լ[x)��6��8[�\�e�p	��M /�ȝU+�?m
y�y1w�y��A����uQ�C��bJ����R��Z�!/�1M��禐�8����p�7�:��cy1��S9�f�s�ȋ��D�7�B����&�.�VE)���b�6 /�o�4�I�g��"I�$�����Xjyq�5.�H /�|(y��3	��M /��	��d�����	�Bcc�K9��W�	�����t�@^́�,�`��Dy1'�.Qoȋ[^E�!/�Lo�lNyq�@�CS���yq�z��M�\��ey�N /P�%����ܷ�2�K[n��K�r��oȋ)��2�w�y5��������ۻ�j-�������������H�@^F~����{	�zN /�ołSN!/�os���s �yҜ��+m+?oy�7��@�&ꆶ)�zN /��	��%�س��������&�g#l#��u��]d@^����Fy�M /�/%���7�(���<0��*����&�X��n�@^`�	�e���?���g@^\���d�e�����@^`��B>�B^�e^��b2 /��6�@^`�ȋ1���@RH /�6���](EW#��@,K /0���Ф�Ajy����%����b<�P�|�)*���m���@^`ȋ��y�=J /n��4����\Ƥ���7�bhy���@^`��%���@^`��,sy1i. /0��bJ���8��l�)�ń��;DS^�c)��6i{�-�&Rȋ{����ȋIUEY
y1����@�O /��6G��Y!���CH9<����@^�myWH /�⫒�Rȋ)E�͇��O��~�s��{D��Ř�y��	�vw�ڸrn��e$���>X�̜A^�i��Iy1Y��*ݜ��y���@^`�7�
�7���s�����e�ȋq��q{�ŭb�I�!/�?oȋ)2����Z��|C^�qސ�����@^���I5���E���tv~�T�!9 /&k��\��\���xy���xty5��@�C^~�� /���Ņgy��	�&�@^L�����@^��< /f��b�nڭ�pg�R�l���ޔO�	�Ÿ�y1駕o�}�ԕB^�2:�hp)��Z0��s2ȋ[���A^̩? /�V)O��PߐS>�0���f��*R��Y�2�y���@^���b�Hm�ɤ��wCDڒOg��b������o%��0�U��)����w�yqq���@���ƅRy��yC^@�,J%􆼘r& /����`\�Q�r�I /�tH��)��\J?����b2|;Z�%�S����񁼘j' /&��V�y���Q_�$��^  /�{ /�6 /������&�s3�9���S���iy1q& /�(���b^E��N����儹 ���2ȋ	�y���*�����b��������%�s�ȋ�5y15t��-��@2H /&P��7��1����H@^��L}��@^�]@^�Q�0���L_��|������@,J /��6�d    ��sW�����������V�~4��ۛB^̕r@^̥�yq����%�s[�蹉�n2X��Z5���R  /��kț��b�7 /ȋ)}F���~�.ȋy%�@^L>�Č7��8ب�8)���!ꤶ�6��)��܌���ꬊ5V�7怼@�@^`뻨���؄��|�@^L�ȋ)��bb�|��	�L}���kU���@^L=78��S���2	��\���Mj�)���<8��h]��(����=�ky1�1 /�T96g���{���B^�K���8{<��3ȋ�?���K!/�]����b�r@^�q) /�F' /�̘7�ly1E�,�F����&cH[k�y1�9����(7�Ą���@^`R�q�*#���J��cy�J /�Cji\�$�s7�آ�)=���J�����% /�ԛ���)��ԮS�c
y'�N>I'��w�b���b.��b.��b�qs꽂�Z���2 /�J��c��sBy1�B�b�B�+w&�S
�Ŝ>�b�퀼��X@^L��S+�Ŝ���@^�Md@^ �%�s97�F
yq�p�I!/�$ /�L�n��J /�G	���jݺ�	����*%ߐ�bv�G	���ū�秐����ο�H /&J�z�EJy1/�V�//ȋۿ&��@^L|]�\S�8`yq���Sȋ	tyq��16ȋ���E��Vx����b��z݂����ys}C^̙hM�%Rȋ��_S�`��{N!/�Ļ��b^�����$����b�L!/&�������B^�1}mM�	����+&�S�.Jr�b\��}Vy1�N��qS��M /�D	����y10 /�$��e��r��@^���.נuL /�5R@^L9�c�y1��������bP8.|�("�lސso��My��&�X���,�]�,�i��g��b�kw<���X���L!/`	���yq�;��M�_K��Y��x�@^\����"���c&��Z$ /���rvL!/n��e|y1)9 /��!/��S�n9ॐ��!m���͕\y1w�y1�y�E��[�}�iS��oȋ�����^o麨�!}y1�K@^L�}n-�ސ�&U�sS�t�@^LL8����1������x3ȋ9`��\�"��!�y��Fnw����ȋ	�y1n�X�7��Ҥ����b��OW�RvJ!/`�	��9׸�: ���#��C^ �$�6����&����b^��Bcc�K9��W�	�����t�@^́�,�`�҄4�|O�@�zC^\���*�y�ezC^`sȋr�B^`Noȋ��sMo���//�xty�
,���W����]�rp�^j���|C^L�����F�j!u�:T(dYݿm�ʎ�Z@�I���,�S��f�?c,�h��?$>��{EVoh�T��zV�@�?�P����N��[<չ�e.��'�Y{.4�������=�7�r�&ꆶ?i��g\��a���븇�%���SB���_�UuS�!j�1�6��_�<�؟ I*���A��F��7�Ԫm[;��.~��"L�	̬�i���A��l΢��9o݄�j����-��<�F�~E��Nv�z��{�	ˀ�4Rk�ݡ�*��K�x$�qx1n~ܣ���xB@^��-=/oB@^�i����帏+����j�J1�ת�m�y�]h�� ���r��dVy1Z*� G؀��/�#�&�2�L��:ޣ�O4�m����Gɀ��UQ��s�R:���`�2��*�p�z(��H1���N����a���3T|/W�
ږK 2��^���K���8��/	¹��B=V�My��U�x��ȋ��Մ���X����. /&UId�Ke[_�rm���F�9�pS�f��jau����<���S�-gP��G�z�q�W%�qVȋ)E�͇.ΠU��{�/s.�~�hVぼ�z /�r�8iw��+�&*[͸��������V)3��>�xZ�K:	ȋ1���W��W���j�B�ThH�<�!-�_�.�^X��6o�چ7���n�NJz��Āk������E�bu��HǓ�tX��$�X��.�y���Y�
�Ֆoo�;�M�����5�b�B�.�Y����@�S&��2,��a�̭��4x������Ņ�)qSROX����nV�&��r��2.�S���
ȋ��i��Ý�VH��Ŧ����|"�en��?��~Z�V�7I]\>4I{�<��O`y���X�8�~�s2ȋ[����A����S@^@�R��֚F���&�����w�
v�&i�C�y1��y����v�W���XG�5�d�(���-*;��%��,�8��CJ����"-1�y1�Ԁ�8;���n9/.�iN��H1Xl\(MQ=�f��igQ*��*fDi�ٞ^�ԓMT.�D��3Y��!�[�=����x�d��}�v̅���Q+;��y1�N@^L����d�S�����f����Ŕ`��\���[c�v���M��q^֘�������T,y�d�D�q& /�(����VV��Q�,���	s���q1�@^L���dU9'VVe���◈�{�y��=�����bbM@^L݇�x����~�q}�
���U^e;:E���f�{�Yb-��Mx�
s�5HQ��`�w��_Ti:��m���޼b����aw���mMT~�/j��G�:������y/$�x��咣�WDm�1s@^��&*��`��k�%*߾WQ�8�Y�;c~ހ���DAU}�3ʷ���HuydRxn�a���y@^ fܬN�`���;�PC�ImIm��� �#$g��tV�U�������:/ /��]T��l�`U>:�J���74�PG8�J��v�:YS���ZU>�Ь&���g@.o�b��1�%�1y�����Z<�Č�K%�Ǘ���U����͕�=���bN�csf�c��/;��)���o-B(T����lY�sځ""iq��M{Х-��ƽȋI�y1ǥ�������2cޘ���i�z��e�EߨvV;�dik�5 /�9gAc��a@^L��Ub�dQ��U��q�*cIϜĆL�ב�m\�ɜ�ߡ�5VW(7�r�"m;�?�2.�G[�uD��K@^L�7;���kX~!~K�|�G67�4,[4��X�<b�Ӽ�s���s��\��:q��7��+4Q���yU�6�㜜Ĝ9O�e,�9���+w���ȋ9}����y1G����"3 /�Vȋ9#�E�J\ �<1�o,;�97�Fמ��+���MW�r)���Ŝ�֭�Uږ�
�d�<�u��nQo�G�h��Y4�#b����#Q�^�<�˽U5vV;�fB�v>a�|L�����%�}Ӌ��*��4�k�"�S��Z���z���# /&���9B�ج��gU]�2ek�UV�,i˟"vV�@����Z�̕w^��C�N+uX�Q��|�ڥ-�,�3���}	U��+�yq{/IN�w鯡d��w����rOvh���z�|���zk�D��<e��m���_
�EINoa�a���n�ϒ�e�h9��q�\�o,����o�\����y10 /�$��e��r�<Y��"*�����J�ҔS:��1lj�y1��������b���W�"�Ɇf��b�m7~��^����Wb��͢��ɂ��_|�,ҩ��kw<�j�����x��" /`��Cmf�:��!/&E�_K��Y��x@�8�}�y����Y�<�3�N�m�b��-gG���{ �..��e/�:����_���Լ[xK6[�W��G���3_)MV��qɰ.h���\/�s�[�}�i_�M�y1w�y��A����uQ�C������y1����(���% /�r- /�q�_)��ͿN���j�9��\9���큼�v@^�u`@^ �WiK!N��wi4�vq�*�K����p��y��жԔ&şm�Q�OnMDv��*e'������n�\����"%��z{����,������2��(�E劧�:�����/I�̋_ �   �.�}�Y�n������+UQ)MH���D2)Qd��⏈�|�\Y�rX��~9[��U
2���~�����jy����K;~dkZ��i	�K~uX�[�ѥ-7Q��V�o�J9����������췲x         i   x���1�P�i�������q�~B��PQj����a$B�YU��������pΝY3�/�-f\m�
�?�_nT�ϗc�,]c��/z��=���|$�5�         �  x�mU�n�F<��b�Jb�$E�&�n��cXFA�YZ+,(���B�|J�9���c���0)�\����f��
���ޑ\�vc$�ȭ���.�s�/���N$U�"�EI.�De��(+�s�b��.m7�0Otz��
Z\�kl'o�� ���ۍ9���cx"P䑚EZC j�,τ.!�+q�'�{�~�O�y�q��b��d��:g:A�l:�*J�u� ��EΟZ�3`#}&���7�>�[���8��`�d�kz�$J*Ч=ՉHU�T<|��H���}�����X�%~9��>�؄���i���ޫD]��T�Uρ��3��kXO���ʕ�[� ���׳e�$Q�����]]�~vp�ӧ�8_��dS#=�Qc:yS�V��8u�-�$�gO��YP�l�y��
����k�K�3|k�?�����y���U��`�Ι�nq�u������6���	�p�Al��N�+l6�t
J����av&:�j�rċ��@Y��ܖ����x<��G�@6��$*�[���x���EPߞ�*�	t��%��Ŋ��@��E�ƚ�O�	�]/�;
h��v_��ʫ��Cu���p�L�ԩ�����2��3�U?��5$���=5��u{<�Mo�=:�8^{x��*i��FR����3@&xw:jd��>��CfS�$ϛGrV����1:]F�MK
nrꟁ&��P�m9/*r�gG8��wna��=[F�ӗ�S�Q���_Br
�w�?7qx;|Y#�r����7��}4�]O�s�WM��Y�V�!z�:��\C!nh���s�q�:�tDQ��GU�)�j>)�Q�1��@4�~��w��i��f��i�j��7��#��)�D�y-��iH�ge6JT��`��|o�$Cq���s�'�D�
4�G��	������S�V��f����	��^gh���G�|ِ&�ϛ��~8-f'�'''��1<         �   x�U�K�� Eѱ���{����)��o2zG&��=*:�(T��0Q#`�]L	tub�$6�g�x �l/pUY�-��0���^S&�%��ײ��,�b���l�$���=R��}η2��7S�X@���d�I*P�=�	`c_D}5	|�2� z�d��l ����˕( ���yJ ���e�U7���9'����e[r��f�6�r^��у}r�������y�!g�         �   x�]ͻ�@D�x���>���YrB�u�X�J�r`�sβ�񹽬ϫg����G�,ҋ�s/�V��h��'�m�7��L:I'�$����LF&�d��A2HZ&-�F�HI#i$5��I%�$���T��Pk��M�     