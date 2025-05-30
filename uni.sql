PGDMP  9    5                 }            universidad_nueva_y_diferente    17.4    17.4 D    -           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            .           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            /           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            0           1262    16688    universidad_nueva_y_diferente    DATABASE     �   CREATE DATABASE universidad_nueva_y_diferente WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'es-MX';
 -   DROP DATABASE universidad_nueva_y_diferente;
                     postgres    false            �            1255    24939 >   contador_notas_por_materia(integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.contador_notas_por_materia(cedulaaa integer, id_materiaaa integer, anioaa integer, semestreaa integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $_$
declare
tabla record;
   begin
    for tabla in
	            SELECT COUNT(*) as contador FROM notas_semestre2 WHERE cedula = $1 AND id_materia = $2 AND anio = $3 AND semestre = $4
	loop
	 return next tabla;
	end loop;

 END;
 $_$;
 }   DROP FUNCTION public.contador_notas_por_materia(cedulaaa integer, id_materiaaa integer, anioaa integer, semestreaa integer);
       public               postgres    false            �            1255    24930 9   datos_administrador(character varying, character varying)    FUNCTION     `  CREATE FUNCTION public.datos_administrador(correoo character varying, contrasenaa character varying) RETURNS SETOF record
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
       public               postgres    false            �            1255    25123 (   fn_renumerar_notas_despues_de_eliminar()    FUNCTION     �  CREATE FUNCTION public.fn_renumerar_notas_despues_de_eliminar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE notas_semestre2 AS ns_actualizada
    SET nota_por_materia = sub.new_nota_por_materia
    FROM (
        SELECT
            id,
            cedula,
            id_materia,
            anio,
            semestre,
            ROW_NUMBER() OVER (
                PARTITION BY cedula, id_materia, anio, semestre
                -- Ordena lógicamente y usa 'id' como desempate final
                ORDER BY actividad ASC, nota ASC, porcentaje ASC, id ASC
            ) AS new_nota_por_materia
        FROM
            notas_semestre2
        WHERE
            cedula = OLD.cedula AND
            id_materia = OLD.id_materia AND
            anio = OLD.anio AND
            semestre = OLD.semestre
    ) AS sub
    WHERE
        ns_actualizada.id = sub.id;

    RETURN OLD;
END;
$$;
 ?   DROP FUNCTION public.fn_renumerar_notas_despues_de_eliminar();
       public               postgres    false            �            1255    24921 m   insertarestudiante(integer, character varying, character varying, date, character varying, character varying) 	   PROCEDURE     C  CREATE PROCEDURE public.insertarestudiante(IN integer, IN character varying, IN character varying, IN date, IN character varying, IN character varying)
    LANGUAGE sql
    AS $_$
   INSERT INTO public.estudiante(
	   cedula, nombre, correo, fecha_nacimiento, celular, contrasena)
	   VALUES ($1, $2, $3, $4, $5, $6);
$_$;
 �   DROP PROCEDURE public.insertarestudiante(IN integer, IN character varying, IN character varying, IN date, IN character varying, IN character varying);
       public               postgres    false            �            1255    25125 -   notas_por_materias(integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.notas_por_materias(p_id_materia integer, p_anio integer, p_semestre integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $_$
DECLARE
    tabla record; -- Declara una variable de tipo RECORD para almacenar cada fila del resultado.
BEGIN
    FOR tabla IN
        SELECT
            e.cedula,
            e.nombre,
            ns.id_materia,
            ns.actividad,
            ns.nota,
            ns.porcentaje,
            ns.nota_por_materia,
            ns.id -- Aseguramos que el ID se incluya en la salida de la función.
        FROM
            notas_semestre2 ns -- Alias 'ns' para notas_semestre2
        INNER JOIN
            estudiante e ON e.cedula = ns.cedula -- Alias 'e' para tu tabla de estudiantes.
                                                -- ¡CRÍTICO! Asegúrate de que 'estudiante' sea el nombre EXACTO
                                                -- de tu tabla de estudiantes (respeta mayúsculas/minúsculas o usa comillas dobles si es necesario, ej. "Estudiante").
        WHERE
            ns.id_materia = p_id_materia AND ns.anio = p_anio AND ns.semestre = p_semestre
            -- Puedes usar $1, $2, $3 aquí si prefieres, aunque los nombres de parámetros son más legibles.
        ORDER BY
            e.cedula, ns.nota_por_materia
    LOOP
        RETURN NEXT tabla; -- Devuelve la fila actual de la variable RECORD.
    END LOOP;
    RETURN; -- Indica el fin de la función.
END;
$_$;
 c   DROP FUNCTION public.notas_por_materias(p_id_materia integer, p_anio integer, p_semestre integer);
       public               postgres    false            �            1255    25127 -   notas_por_semestre(integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.notas_por_semestre(f integer, b integer, p integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $_$
declare
tabla record;
   begin
    for tabla in

				  SELECT
                      ns.id_materia,
                      m.nombre_materia,
                      m.creditos,
                      ns.actividad,       -- Descripción de la actividad (ej. '1', '2', '3')
                      ns.nota,            -- Nota obtenida en la actividad
                      ns.porcentaje       -- Porcentaje de la actividad
                  FROM
                      notas_semestre2 ns
                  JOIN
                      materias m ON ns.id_materia = m.id_materia
                  WHERE
                      ns.cedula = $1 AND ns.anio = $2 AND ns.semestre = $3
                  ORDER BY
                      ns.id_materia ASC, ns.actividad ASC

	loop
	   return next tabla;
	end loop;
  END;

  $_$;
 J   DROP FUNCTION public.notas_por_semestre(f integer, b integer, p integer);
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
       public         heap r       postgres    false            �            1259    24947    notas_semestre2    TABLE     �  CREATE TABLE public.notas_semestre2 (
    cedula integer NOT NULL,
    id_materia integer NOT NULL,
    anio integer NOT NULL,
    semestre integer NOT NULL,
    actividad character varying(200),
    nota numeric(5,2),
    porcentaje numeric(5,2),
    nota_por_materia integer NOT NULL,
    id integer NOT NULL,
    CONSTRAINT notas_semestre2_porcentaje_check CHECK (((porcentaje >= (0)::numeric) AND (porcentaje <= (100)::numeric)))
);
 #   DROP TABLE public.notas_semestre2;
       public         heap r       postgres    false            �            1259    24959    notas_semestre2_id_seq    SEQUENCE     �   CREATE SEQUENCE public.notas_semestre2_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.notas_semestre2_id_seq;
       public               postgres    false    229            1           0    0    notas_semestre2_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.notas_semestre2_id_seq OWNED BY public.notas_semestre2.id;
          public               postgres    false    230            �            1259    16898    notas_semestre2_old    TABLE     �  CREATE TABLE public.notas_semestre2_old (
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
    CONSTRAINT notas_semestre2_porcentaje_check CHECK (((porcentaje >= (0)::numeric) AND (porcentaje <= (100)::numeric))),
    CONSTRAINT notas_semestre2_semestre_check CHECK (((semestre >= 1) AND (semestre <= 2)))
);
 '   DROP TABLE public.notas_semestre2_old;
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
       public         heap r       postgres    false            Y           2604    24960    notas_semestre2 id    DEFAULT     x   ALTER TABLE ONLY public.notas_semestre2 ALTER COLUMN id SET DEFAULT nextval('public.notas_semestre2_id_seq'::regclass);
 A   ALTER TABLE public.notas_semestre2 ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    230    229            '          0    16872    administrador 
   TABLE DATA           U   COPY public.administrador (id_administrador, nombre, correo, contrasena) FROM stdin;
    public               postgres    false    227   �q                 0    16705 
   estudiante 
   TABLE DATA           c   COPY public.estudiante (cedula, nombre, correo, fecha_nacimiento, celular, contrasena) FROM stdin;
    public               postgres    false    217   Dr                  0    16730    facultad 
   TABLE DATA           @   COPY public.facultad (id_facultad, nombre_facultad) FROM stdin;
    public               postgres    false    220   ��       $          0    16792    facultad_estudiante 
   TABLE DATA           B   COPY public.facultad_estudiante (cedula, id_facultad) FROM stdin;
    public               postgres    false    224   :�       !          0    16747    facultad_materia 
   TABLE DATA           C   COPY public.facultad_materia (id_facultad, id_materia) FROM stdin;
    public               postgres    false    221   �       "          0    16762    facultad_profesor 
   TABLE DATA           @   COPY public.facultad_profesor (id_facultad, cedula) FROM stdin;
    public               postgres    false    222   �                 0    16721    materias 
   TABLE DATA           H   COPY public.materias (id_materia, nombre_materia, creditos) FROM stdin;
    public               postgres    false    219   >�       )          0    24947    notas_semestre2 
   TABLE DATA           �   COPY public.notas_semestre2 (cedula, id_materia, anio, semestre, actividad, nota, porcentaje, nota_por_materia, id) FROM stdin;
    public               postgres    false    229   ��       (          0    16898    notas_semestre2_old 
   TABLE DATA           �   COPY public.notas_semestre2_old (cedula, id_materia, actividad, nota_por_materia, semestre, anio, nota, porcentaje) FROM stdin;
    public               postgres    false    228   /�       &          0    16857    prerequisitos 
   TABLE DATA           E   COPY public.prerequisitos (id_materia, id_prerrequisito) FROM stdin;
    public               postgres    false    226   �                0    16714    profesor 
   TABLE DATA           j   COPY public.profesor (cedula, nombre, correo, fecha_nacimiento, celular, salario, contrasena) FROM stdin;
    public               postgres    false    218   C      #          0    16777    profesor_materia 
   TABLE DATA           >   COPY public.profesor_materia (cedula, id_materia) FROM stdin;
    public               postgres    false    223   1      %          0    16842 
   tiempo_dia 
   TABLE DATA           ~   COPY public.tiempo_dia (dia, hora_comienzo, minuto_comienzo, segundo_comienzo, hora_fin, minuto_fin, segundo_fin) FROM stdin;
    public               postgres    false    225   (      2           0    0    notas_semestre2_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.notas_semestre2_id_seq', 3601, true);
          public               postgres    false    230            h           2606    16709    estudiante estudiante_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.estudiante
    ADD CONSTRAINT estudiante_pkey PRIMARY KEY (cedula);
 D   ALTER TABLE ONLY public.estudiante DROP CONSTRAINT estudiante_pkey;
       public                 postgres    false    217            v           2606    16796 ,   facultad_estudiante facultad_estudiante_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.facultad_estudiante
    ADD CONSTRAINT facultad_estudiante_pkey PRIMARY KEY (cedula, id_facultad);
 V   ALTER TABLE ONLY public.facultad_estudiante DROP CONSTRAINT facultad_estudiante_pkey;
       public                 postgres    false    224    224            p           2606    16751 &   facultad_materia facultad_materia_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.facultad_materia
    ADD CONSTRAINT facultad_materia_pkey PRIMARY KEY (id_facultad, id_materia);
 P   ALTER TABLE ONLY public.facultad_materia DROP CONSTRAINT facultad_materia_pkey;
       public                 postgres    false    221    221            n           2606    16734    facultad facultad_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.facultad
    ADD CONSTRAINT facultad_pkey PRIMARY KEY (id_facultad);
 @   ALTER TABLE ONLY public.facultad DROP CONSTRAINT facultad_pkey;
       public                 postgres    false    220            r           2606    16766 (   facultad_profesor facultad_profesor_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.facultad_profesor
    ADD CONSTRAINT facultad_profesor_pkey PRIMARY KEY (id_facultad, cedula);
 R   ALTER TABLE ONLY public.facultad_profesor DROP CONSTRAINT facultad_profesor_pkey;
       public                 postgres    false    222    222            l           2606    16725    materias materias_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.materias
    ADD CONSTRAINT materias_pkey PRIMARY KEY (id_materia);
 @   ALTER TABLE ONLY public.materias DROP CONSTRAINT materias_pkey;
       public                 postgres    false    219            c           2606    24946 :   notas_semestre2_old notas_semestre2_nota_por_materia_check    CHECK CONSTRAINT     �   ALTER TABLE public.notas_semestre2_old
    ADD CONSTRAINT notas_semestre2_nota_por_materia_check CHECK ((nota_por_materia > 0)) NOT VALID;
 _   ALTER TABLE public.notas_semestre2_old DROP CONSTRAINT notas_semestre2_nota_por_materia_check;
       public               postgres    false    228    228            z           2606    16909 (   notas_semestre2_old notas_semestre2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.notas_semestre2_old
    ADD CONSTRAINT notas_semestre2_pkey PRIMARY KEY (nota_por_materia, cedula, id_materia, semestre, anio);
 R   ALTER TABLE ONLY public.notas_semestre2_old DROP CONSTRAINT notas_semestre2_pkey;
       public                 postgres    false    228    228    228    228    228            |           2606    25122 %   notas_semestre2 notas_semestre2_pkey1 
   CONSTRAINT     �   ALTER TABLE ONLY public.notas_semestre2
    ADD CONSTRAINT notas_semestre2_pkey1 PRIMARY KEY (cedula, id_materia, anio, semestre, id);
 O   ALTER TABLE ONLY public.notas_semestre2 DROP CONSTRAINT notas_semestre2_pkey1;
       public                 postgres    false    229    229    229    229    229            x           2606    16861     prerequisitos prerequisitos_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.prerequisitos
    ADD CONSTRAINT prerequisitos_pkey PRIMARY KEY (id_materia, id_prerrequisito);
 J   ALTER TABLE ONLY public.prerequisitos DROP CONSTRAINT prerequisitos_pkey;
       public                 postgres    false    226    226            t           2606    16781 &   profesor_materia profesor_materia_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.profesor_materia
    ADD CONSTRAINT profesor_materia_pkey PRIMARY KEY (cedula, id_materia);
 P   ALTER TABLE ONLY public.profesor_materia DROP CONSTRAINT profesor_materia_pkey;
       public                 postgres    false    223    223            j           2606    16720    profesor profesor_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.profesor
    ADD CONSTRAINT profesor_pkey PRIMARY KEY (cedula);
 @   ALTER TABLE ONLY public.profesor DROP CONSTRAINT profesor_pkey;
       public                 postgres    false    218            ~           2606    24966 %   notas_semestre2 uq_notas_semestre2_id 
   CONSTRAINT     ^   ALTER TABLE ONLY public.notas_semestre2
    ADD CONSTRAINT uq_notas_semestre2_id UNIQUE (id);
 O   ALTER TABLE ONLY public.notas_semestre2 DROP CONSTRAINT uq_notas_semestre2_id;
       public                 postgres    false    229            �           2620    25124 0   notas_semestre2 trg_after_delete_notas_semestre2    TRIGGER     �   CREATE TRIGGER trg_after_delete_notas_semestre2 AFTER DELETE ON public.notas_semestre2 FOR EACH ROW EXECUTE FUNCTION public.fn_renumerar_notas_despues_de_eliminar();
 I   DROP TRIGGER trg_after_delete_notas_semestre2 ON public.notas_semestre2;
       public               postgres    false    229    247            �           2606    16797 3   facultad_estudiante facultad_estudiante_cedula_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_estudiante
    ADD CONSTRAINT facultad_estudiante_cedula_fkey FOREIGN KEY (cedula) REFERENCES public.estudiante(cedula);
 ]   ALTER TABLE ONLY public.facultad_estudiante DROP CONSTRAINT facultad_estudiante_cedula_fkey;
       public               postgres    false    224    217    4712            �           2606    16802 8   facultad_estudiante facultad_estudiante_id_facultad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_estudiante
    ADD CONSTRAINT facultad_estudiante_id_facultad_fkey FOREIGN KEY (id_facultad) REFERENCES public.facultad(id_facultad);
 b   ALTER TABLE ONLY public.facultad_estudiante DROP CONSTRAINT facultad_estudiante_id_facultad_fkey;
       public               postgres    false    220    4718    224                       2606    16752 2   facultad_materia facultad_materia_id_facultad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_materia
    ADD CONSTRAINT facultad_materia_id_facultad_fkey FOREIGN KEY (id_facultad) REFERENCES public.facultad(id_facultad);
 \   ALTER TABLE ONLY public.facultad_materia DROP CONSTRAINT facultad_materia_id_facultad_fkey;
       public               postgres    false    4718    221    220            �           2606    16757 1   facultad_materia facultad_materia_id_materia_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_materia
    ADD CONSTRAINT facultad_materia_id_materia_fkey FOREIGN KEY (id_materia) REFERENCES public.materias(id_materia);
 [   ALTER TABLE ONLY public.facultad_materia DROP CONSTRAINT facultad_materia_id_materia_fkey;
       public               postgres    false    221    219    4716            �           2606    16772 /   facultad_profesor facultad_profesor_cedula_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_profesor
    ADD CONSTRAINT facultad_profesor_cedula_fkey FOREIGN KEY (cedula) REFERENCES public.profesor(cedula);
 Y   ALTER TABLE ONLY public.facultad_profesor DROP CONSTRAINT facultad_profesor_cedula_fkey;
       public               postgres    false    218    4714    222            �           2606    16767 4   facultad_profesor facultad_profesor_id_facultad_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.facultad_profesor
    ADD CONSTRAINT facultad_profesor_id_facultad_fkey FOREIGN KEY (id_facultad) REFERENCES public.facultad(id_facultad);
 ^   ALTER TABLE ONLY public.facultad_profesor DROP CONSTRAINT facultad_profesor_id_facultad_fkey;
       public               postgres    false    220    4718    222            �           2606    16910 /   notas_semestre2_old notas_semestre2_cedula_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_semestre2_old
    ADD CONSTRAINT notas_semestre2_cedula_fkey FOREIGN KEY (cedula) REFERENCES public.estudiante(cedula);
 Y   ALTER TABLE ONLY public.notas_semestre2_old DROP CONSTRAINT notas_semestre2_cedula_fkey;
       public               postgres    false    4712    217    228            �           2606    16915 3   notas_semestre2_old notas_semestre2_id_materia_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.notas_semestre2_old
    ADD CONSTRAINT notas_semestre2_id_materia_fkey FOREIGN KEY (id_materia) REFERENCES public.materias(id_materia);
 ]   ALTER TABLE ONLY public.notas_semestre2_old DROP CONSTRAINT notas_semestre2_id_materia_fkey;
       public               postgres    false    219    228    4716            �           2606    16862 +   prerequisitos prerequisitos_id_materia_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prerequisitos
    ADD CONSTRAINT prerequisitos_id_materia_fkey FOREIGN KEY (id_materia) REFERENCES public.materias(id_materia);
 U   ALTER TABLE ONLY public.prerequisitos DROP CONSTRAINT prerequisitos_id_materia_fkey;
       public               postgres    false    226    4716    219            �           2606    16867 1   prerequisitos prerequisitos_id_prerrequisito_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prerequisitos
    ADD CONSTRAINT prerequisitos_id_prerrequisito_fkey FOREIGN KEY (id_prerrequisito) REFERENCES public.materias(id_materia);
 [   ALTER TABLE ONLY public.prerequisitos DROP CONSTRAINT prerequisitos_id_prerrequisito_fkey;
       public               postgres    false    219    226    4716            �           2606    16782 -   profesor_materia profesor_materia_cedula_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.profesor_materia
    ADD CONSTRAINT profesor_materia_cedula_fkey FOREIGN KEY (cedula) REFERENCES public.profesor(cedula);
 W   ALTER TABLE ONLY public.profesor_materia DROP CONSTRAINT profesor_materia_cedula_fkey;
       public               postgres    false    4714    218    223            �           2606    16787 1   profesor_materia profesor_materia_id_materia_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.profesor_materia
    ADD CONSTRAINT profesor_materia_id_materia_fkey FOREIGN KEY (id_materia) REFERENCES public.materias(id_materia);
 [   ALTER TABLE ONLY public.profesor_materia DROP CONSTRAINT profesor_materia_id_materia_fkey;
       public               postgres    false    219    223    4716            '   :   x�340060331�LI,�L��z��ŉ���9�z�����ŕ9���y\1z\\\ ڮV         `  x�uZMs�8=#��@(����$�q���r�N�a�.�pHI5�-?%�r��uo�c��A�3&�J��2H4�_�א�鏊�x7l��t���{o����������l�[+Wn#TU�E�/�	~W'E������ި��Q�j�����W�q��Z^M������s��6�o�\;��g��"N�ć"��$�`"�w�ݹˮwX��g��sC��k��"���VJi��VM�Yg����� Lg�L��E\,T��MK�i`�L\��uCtc���X�G������E\-�a�ВYX4Wv���j�F7f�����$lrcV������h�:I�WI�T�
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
���Xm���!�'`cY�7B�_��͛��ƀ�          v   x�3400�tI-JM���2400���KO��L-:�6Q�3/-�(����D���s~^IbJ)X6����1�cJnf^fqIQbr���y
)�
��E�ŉ� &h���f&�p��qqq ��/b      $   �   x�U��m�0D�s\L`��(����ȇ�=,�n3���k��4�\f��,�M��T5TUC�P5TUC�P5U�G5ޜf��Ls�e�ɸMU�*T��P�BU�
UK�zT��i���4�Y�1���T��RU�JU�*U��T�U�GoN3�e���2��dݦ�RU�JU�*U��T����<���4�\f��,�M�m�jU��U��VժZU���_�|_��)� �      !   �   x�5�ۑ�0D�o9�-	=r�������),h��轷�����Da�ą�� /țo=�0T2�,�i�1
�
����Y���D�<_��4�?�?����>-�xH�HN�-ɚ�NoMoM�eK�\��XuȜ�䈹�x�������U�i�)Z�*&Ũ�졝���y�����{���i      "   L   x�Uλ�  �:&� �d�9"@�r׽�LU/ד���d��h�F>d'Ǣ'hJ���d���WY�� '�*�-"�f3�         6  x�mT�r�F�_1��X�k�p��J[EJ,RUN���𔁙�tI�C�B��	�1w7@�K)�~���{ݩ��_�*�VD�d/���_��P��߶��S�FP�(�Rܪ ]�5�Jy��F�J�S����A��wO(V��٣:�Vתy���Ҿr08O6�j(.K҅���z{�+YC+��A��%,���g�3�=��cU���H5G�I���!w�QS+i1���pwi9{Y�]�Xi;b�	�֝6���~��Wv���a ד�\�L�l�Lf��QS�l1W�l~��������Ӕ4�&�uwv��4'��^�m�;bM�:0�z�eh���ҔĞ�U��&y\)t%�,���u ����i���J<�<����g���Z�C�g1���"S���������Q�9`�ζ(���(����E�� ��Y�j���Jn]�']�XP�(p}硉�����v�'� ���B�`N���ʗ�':�b�ɓ|%�k��4�ɏ�QFy�]�������PE��������7L�M�-]R],L���Ez�c��N�c�E&nl3.���H����X�%�\�jf��n�/r+�=��[��5[�������%6�W��tL%7��X���O���/���:3鎩+xy��sΚ'e�J|�~�{<<�g��Ī�\F���e�7��������"ו5���0u�|$�yt| �:��/�4�\�ĝwhRu�g�� �[e�I�*�~�2���`�\���쟺�6/��y$���AQ�uDև�/S�x�X�T�g����v�!\}���?VO�}g��&I�?�+�      )      x���K�49s��q��)�j$7�+�D�h �h��o�/�3�<�FU������������r�*�ԯ�����+������0�HS��4��=LI0��Kc_���6���e�5�)_S����i_9=�wX��W>6���LKV%*_�I���K���>uC�]wl�	Ԁ�_��D��$�7KԾJy��R%��[�����+]�]g��!Ѯ���[�W�-n��j��|�"�ޝT��Wm�]W�D�.�x�Z���7��mS�����{�t7�a-+c_���o����U�*Q�jM��պD���7$�u�����K�uK��ՓD��g��W/�����W�-���,إ֨�]�]g��!Ѯ���[��p���Ǘ�βDe�%�_V%j_��κD������s��w܆D�nJ��D�k���Y"�����g��u�JT�F��~�.Ѯ����v�dd���%�>�Lկ�%j_�<�wݬ��<����fޫ�.Ѯ3�vݐh����-��k�/��AG)+K�P�D{8�����nu�vo���Kk��D�nJ��D�}�C}ƃ����A:6z��rT>˩J�c�&��/H]*4�CE�
����ydS�qI�i��H��M����!�J�i�l���Џ{����hR�qH���PѸ�¤~l��Q�E�%K�K�j7�*����=ԧ�t��xl�E��{R�qJ��%�$=ԧ�f�vc�m�����j�Y�Z�ڍ�I��.���qH�F���{��cP�uI��JI��زT��[y�Oc�R�FP��3��G�L�M�ѤB�
��qI�iL��}k����ԛڍ4��NV��go�i�]*4�>f��W��!�Th\R�,hz�O�e�v����_�*�n�&��.���qH�F���G��%
7.�v�HRa&�R���Q*NgW�v��m����8]*4�ThR�q>T4.�p�>�=�>�}���4���t�v#ͱ7�c��P�F�do
�ƪ��qr;�,{Sh�R�qI�c��P�ƕ���~����_���U�ڍ�I��yu��h�C*4��>�P<?�%>(I*�d����>�aR�
���������aI]*�K�
�C*4·��%�������ϖ���Xr�
矋T8#Q�����=ԧ1w���~|�h�ġ
�B\
�Zh��O����-�2��_�B�M�{�j�D{S(����!y����m�~7.�p�=I�sJY*LH��v�j7�cۏ�:ױv��hR�qH���PѸ��u�c��^ǖ�ڍ�H���U��gk�il]*4�krǉ�҆Th�R�qI������4�,�n��v��c���DN����v!ͳ�i�� ��E�Pu�P�� ��3�fٛ��%I��/i���]h�>�V�ڍ�۝��?�֥B�I��!�CE�j7�c���'����ڍ�H���T�q���4�.y��լt|Vǐ
�S*4.�p7Tz�O��R���۾��D��J�g�j7�.���qH��������T�Y��v#Ͳ7��%Ͳ7�i���ⶶ*�n�Yv�9+���S-4��M*4��8*�T�w���|g �ߖ�Te�"UݪJնj���/u���۞���XӐ
�S*4.�vcN�i�Y�ݘy�ӷ6��c�U�ݘ�T�1w��h�C*4����ˏ��j^R�N�$�n,Y��X�C}K�j7�D��q䘪jL�W�F�
�C*4·��%�n��*������D{U�1&ګ�-�U��X�C}k�
�Ƕ�3����Z�Th�R�qI����C}[�j7�c��gK4>Ω�J�[�j7�.���qH��c������iK��ؓT��g�vc/7�W�vc�mO{��x��.M*4��8*�T��?�}�+���c̵W�c����s�U�Ƙk�A}c��*4�NG��ω����8�B�j7��P�Ƒ�ڍ����S9uT�v�hR��ѥB�=T4�����8:�Tx�$I�g�j7��P��Y�ڍ��}�	���g�
�&�Th��K�ݸx��՞�A���T�q���P�j7��P��եBcl��V��Pc��*4N�и��SR�>��\{U�Ua�S&�v��k��lդ�[u��h�C*4�>��L�%�n�I�ݘ�T�1����ݪT�1�;w�ߎ��Th4��8�B�|�h\R�>����'�ί���ڍ�H�K�j7��P��ҥBcl���b૝�qH��)�T�������Hs�M�F�k�y���94���n����v#͵7�F{�hR�����M|��%�AMR�Ɩ�ڍ�<ԧ�U�vc;�}��֥B�I��!�CE�j7v��Ƿ�?�=K�{�
W�vco�i�]*4�8�u�[���
�S*4.���tz�O�e�v#͵���?��Uk/h�T{A;���B��Q��P7	�펼%���v M�7�Gy�O�R���۝�O��S:�Th4��8�B�|�h\R��~�����q�J�Y��8�T�qV�v�l�i�]*4�7SW��R�qJ��%�n\�>�+K�i����|�J�M�F�hoj7�D{Sh����!'+>o��G�ho
�HRխ�Tm��Pߍ=U�l�c����T�S�
�&�Th��K�ݘy�w�љ՞�T�1��B�*�n���>��K�F��t����q�C*4N�и��[S�C}K�j7��tt�>�R�ڍ�I�K�
��P�8�Bcl{�[��;��i���H���>�f�O���h���Ӑ�ǳ��fٛB�I��!
�CE�
o���~{GoY��؊T��U�vck�il]*4򶧳Y���hC*4N�и�ڍ==ԧ�g�vc�m�}����q�U��؛T��w��h�C*4�>���s��/��.�$�n�,�n��P�F�R�F�f�A/G#��7�F�
�C*4·��%�n��v�w
p#M�7�i��)�T�J�G{�O��R����|6���cH��)�TxsZz�O��R��������>�T�q6�v��R��*�Th�mOO'ת�\R�ƕ�ڍ+K�Wy�O�R��ul{>��� �K�F�
�C*4·��%���~�-�CU�����VE��U��m���h��)4�8����!�Th\R�Ɯ�Ә�T�1["����M�ݘ�T�1O�и��X�TxV��q��� +E*���J���M*�]��&�m�Dg9�L�и�«7�T����4�"�n�!s�yK������)�v#M�7�F�
�㡢qJ��Ŋ���ҔyS���̛ڍ4e�ޡZ��ؚT��۾і�}N3��8�B�
��>�=I�;o{�2��9��vc�R��ޤڍ�?T4�Th�mL`��Th\R�FKR�F��i�"������C��w0kR�F�R�ѤB�x�h�R����W�}Vcʼ��S�U�Ƙ2�j7Ɣ���S�U�Ƙ2�����b�2�
�C*4N�и��8�T�q۞?�|�:�Tx?u�j7�&�n����ѤB���h�G�
�K*��;I�W~�O�*R��ul���"�3V��T�qu��hR�q<T4N�����8[��q�$U�*KU�*R�m����GjR�V����I�ɉ�
�B�
�o��'/��u1_n�h�����7���z����\zC�.�;�:Su��3���yJ��%�,I�]X�C}K�
����^�3��Ҥڍ�K�F�
�㡢qJ�F���߆H��FMR�ƚ�ڍ�H�k}�OcmR���۾��ō&�Th�R�q=ԧ�%�vc̲�|�-81F��ߦ�
��doh���E�)��A��6(��&�ثBߒ
|#I�{~�Ob/R���۽��:��I�{�
�&�CE�
���k\w=���%�v�e�v���WT�C}�I���}�����L*4��8�B�z�O�HR���۞��;Ί�Q�ڍ�J�G�j7��P�hR�1�}���㏣b/�K�H#��>�`�O����S	�וw�4�^Ю����Pg
�n�Q�M�P�[<.����J
������(��V��O�j
���[��y�a�I��!�T(\��8S�ʶ:>�%�=�LE*�=�*��ةIն��&y��D��čS*4.��G��T�1��4�"�n�ٵ�$�P�f�څ4�^M!�;����!����4�^Ю����v�����V��SW�B���/�V�p�I�    �!�T(\�I�I��Xy�{#���"�n�U��X�T�����F�
�Ƕ_u�K�
�K��ؒT����4�"��o��)��5�ٚT��u��hR�q<T4N��۾�ρ�������v!ͭ�il���GS�/�ɣ���vͬ�+Vi���zA�
�n*��uG�:K
�:�->h�y��(��?Y�u��u��(�L!���?Sq�}�6B�R]3)��F��O�(
���[�{/�܏1G�j��.M*����)y���Y���9�T�qf�v�,R�o�և�4�&�n�Iվ���t&�B(
!p*��uG�<�T/h�Ѥj����h�F՛�}4����a��v���&y��g��Ѭ)�T�k�$U�*?�w�JE*�-_��5�:�>�R��lեB�I���P�8�B#o��}VWNR�Ɯ�ڍ�H�s}�OcnR���۞�Og�I��!�Th\�i,I��HS��qam��zA���U�HS��>�Z��3�P7�xk��Rͬ7��%��v�j��P��Z�ڍ����U��㹡U�T��v��hR�q<T4N������LU��>�ՒT��e�vc+R�/�ׇ�4�&�nl��k&ş�fR�qH��)�C}{�j7�c�ǔ|�۶z�j7�*�n�M����CE�I������r�t��zA(\
�@�]/h����}�hv��]G�������S����vͮ�:Su㎢n*�:����4�H
����u�(��F��O�h
���[��5'h�0��7�B��
��>�3I�'o��
?/�,R��Y�ڍ�I�g�h4������=�x{��S*4.�v�JR�ƕ�Ӹ�T�����g��sΘ��i~���H��M�ѤB�x�h�R�q��|!$+`Y�
V$k`���;�h�ر�f�~��d^:$��)����Ҝ$Ci�U��>ݙKs���J���$Ci�F�&���*T���Q:%��%JK��%?X��"J��q�Q���$Ci�y�I����tJ楟U�������!Ō{S����3�M�2f��*"cƽ)4ƌ��+�`>?�1�^�W�<sJ���"�%�P�x���qi+���U�Pښd(m����$�R^�z��)��.�Pړd(������PڏU�}4��7�Pڻd^j�y�x0*��y)������kI2�Z��V$C���Rk��4&�������(|S�9��̩�W�����o
�1�L�w;�b �)4�D|Sh�����8�]Q�)卼�oW�7��y��3I�Ι,Bg���W������2�d(�]2/5ɼt<�Nɼ�W��o��i%�P��d(]E2���`Q��d(]�
��:of�y��K�d^��S�S�/��Iy�{��s\�ܪ(U��R�)ՠ�]Q�)千T�<Nm5��ƥc@�)4�|Wј�Rh̼���8�?�|ܬI���%�L��;ǃQ��Ky�J�q���jI2��,JK���>X��&J˱
�����K�d^:%���`QZ�d(��
t��<ZȵH��Z%Cim�����R��Kc�W��>��2���K)dҀ|Q������H�/
�4W�c�+mՔB#��卦�7���Ʃ�7�?�j?*=I�ʞ%Cf/�������$Ci���}�y��M2/�y��K׃E�%�Pj�
���|f>[��V%C�5�Pj����$�R^��~��+jS2/]��t$�P:�E�(���������?�٪)�N��/�3M)�wE�S)o\����b�p|Qh�����H��E�qֻ��ٔB��mO;�z�o�I�C2Ϝ�y�z�]I2�.^:�Ώ�*��tU�P��d(]����$��cm�v�NɼtI��#JJ�5��`�Ғ�dƫP�o��u���d�K�&�����)���*t:;x�����B'���L��/
�4�RI��E���c~��<�Wh8�(oJy�T��]EcIJ���K���R�d�,U2d�&:K0
5ɼ�W�. �Zn6%��%Jk��5?X��"J+��1��R�d(�]2/5ɼt<�Nɼ�WḬv�Z��-K��V$Ci���I�R���_�x,)���C)ϜJy庫������Hӱ�KR��H��E��f�B#������M)o�m����J�S)o\J�ђRh�|W�hE)4o�?=�Y�bM2TZ��3M2�F�S2/�����}���$JG���H��Q,JG���W��U=��+�$��!��Nɼt=X��$Ji2��՟kM�QM��N��/
�4_*i2��(Ҕ��A��x[�/��Rh����и�]E�*J�q�燬�u\M)4���7�R�8��R����x�
+kJ��,Y+�5��`�К�d�+�}@�l�&��ɼtJ����4'�P�yj\=�!�\$Ci���47�P���Q�I楱
���=.?B�R޹�B&���J���������H�䓁�n��D|c�����<�$���`:%�R^���j<�՚$Ci͒���PZ�Eim����*�K癄ZM2/�y��K׃EiK�����-�sM[���J���$Ci�F�&���*���|mS2/]���'�P��Ei/���&����v�ui2�(t�d|Q�iJy�+��Jy�"U��ʱץ���PI��!���C���Pk���xhP=�O�f�y��K�d^�,JG���W�fb|ꤎ"JG���I����JM2/�U8�u�)��.�P:�d(����t�P:�U���I���%�R��KǃQ��K?��]q�qpS�M�3��BfL�7�ʘ����)���SrKt��|x�Ɣ|S�8��Ʃ�7���4���2(�����ޡ��d�JV��d�?��d^�+@�ϧ�Z��y��9I�Ҝ,Js���W�8D�C���d(�]2/5ɼt<�Nɼ�X�;	��J��%K��R$Ci���I�Ҙ�[�
u�!��L)�Jy�T�+�]Ed�7�Ƙ�����1"�cB�)4ƀ|Sh����є�F���oGiG��+�d�lI2t��`ڊd(m�m��C�֚d(m]2/5ɼt<�Nɼ���-��t�z��=K��^$Ci���I��~|b$O�/K7ɼtH�S2/]��$Ci�ȍ���#�M�3&�Bf�7�ʘ�+�4��q�jq�^�n1_�W.ɐ��s���Q$C��hF�c9G���K�&�����)���p���f��3K��Y$C���I��ɫ@����$��!��Nɼt=X��$J�B�m?>��H��U%C�j��t��R��Kc�׏{�(t*�K���iJ������iH�(���J��p��ӌ|c�K�&�w���)���
�8�r>��s��9K��\$Ci���I��̫�m�r��d^:$��)����Ғ$Ci9�	qI�<_�K���J���$Ci�F�&�����Q}/S2/]���&�PZ�Ei-���f���O_S��/
�4+_�g�R^9�"�R޸H}�]��4)�*iR�1dҤ|c�l��"�5�P�x?�t싚I�C2/��y�z�(�I2�v^����{/���W�Pڛd(�����$���P?�<�����K�d(�$J-?X�Z��ƫp��|`�&J�K�&�����)���*t>���{J�򍡔��C)��7�R���(�y��PJ�r�����[4:��7�C2/��y�z�(�I2�N^���;��,��tV�P:�d(�����$�R^�Η��}y��+I�ҕ,JW���W�W��k��d(]]2/5ɼt<�Nɼ�W�v\�K^,%�
X����X}�O��&���*|���?_#a44_�w�<s*��"��B#����GҼ|c��y�ƐI��3��P��Ky�R�(��y��%I�Ғ,JK���W��)�v�ii���tɼ�$���`T:%�R^������)�V�d(�Y2��"Jk}�(�M2��c�!��<�U��K�d^:%���`Qڒd(��������hh�(t��|QȤ���PI�/E���7R%N������7�K2dҼ|c����"��P�y�Ko�r�&J{��KM2/F�S2/�U��x��&�%�PjY2�Z��V,J�I�R�U�kf&��ɼtJ����t$�P:xz���/�Q$C騒�t4�P:��Q�I楱
��Aԟ���#Ѽ|c^�$C)��7�R���(�y��PJ���C��ܑѼ|c(�y�    Ƽ�$���`T:%�R^�Ə��ޕ$C�ʒ�t�P��E�j��t�*�	��.2[&��ɼtJ���>�#%��W����t�"Y��U�&Y�F�&���*��Q:%��%Js��9?X��"Jij^�'��N��/�3M)�wE�S)o\��O��7m��o�4/�2i^�1t��`Z�d(-�4Н�ˍb�y��K�d^�,Jk���X�E���Q�d(�U2��&Jk0*5ɼ�W�8��G��K�d(mI2���`Qڊd(m�
�s>��$Ci�y�I����tJ楟U�;���,و���PS�4��+CiL����4��+CiL�`���9������K�d^:%���`QjI2�ڱ
q+����"J�J�Rk�����Q�I楼
ߞ��g��=�)��.�P:�d(���t�P:x:_�9�G���K�&�����)���*|_��} 8�d(�Y2��"Jg}�(�M2����33����o�;�R�9���uW�M�1�����c�����1/_2c^�2t��`j�y)� ݈�~�NɼtI��y�$Y��)��Hf`�
�?C��q�LM��%�R��KǃQ��Kyz\T�Q��d(�Y2��"Js}�(�M2�f^�9��M�l�y��K�d^�,JK��15os{z��|S茙���#�M�2&�ߊ"M)o��/2��q*�K)4ư|Sh�������Xy����<36k���K�&�w���)���
��*gfK���e�Pڊd(m����5�PڎU����d^:$��)����Ҟ$Ci?�B�®c7ԋd(�U2��&J{0*5ɼ4V����Q:%��%JiR�1�Ҥ��E)M�7�R��+��z>2iR�1�Ҥ|c^j�y�x0*��y)��r9oO�#I�ґ%C�(��t����$C��U8>��(5ɼtH�S2/]�3I��ɫ@����H��Y%C�l��t��R��Ky�R�Q���y��+I�ҕ,JW��4/7~���{Ҽ|c(�y�Ƽ�$���`T:%��E����_��E���,Y+�5��`�ҕ�dƫ@��,5ɼtH�S2/]�9I��|��#>\�H��\%Cin��4��R��K�U������d^�$CiI������R$Ci�U8n{�=�*M2��.���d^:�J�d^���[C�i��|c(����PJ�󍡔f��,Jiv�1�����pǚ��|c^:$��)����Җ$Ci�U��q�ׅW+���U�Pښd(m����$�R^��޴ڔ�K�d(�I2���`Qڋd(��
�iã�7�Pڻd^j�y�x0*��y�
qx|�ǻ,I�R˒�Ԋd(��`QjM2����O}�/SY4:_�w�<s*��"���B#M�����ES󍡒��C&M�7����BM2/��>��Ɣ�K�d(�I2���`Q:�d(��
߯[)?_��f���K�&�����)���*�|+]I2��,JW���>X��&Jױ
�v��^w�d^:$��)����.-)%ɰ���y��e���[��������A#�E�&M̿E�R�8H���8��ƥiX�(4�|Wј�R����=�OCo�$ÿ�]2�4ɼs<�Nɼ�W�N����$��E�̿;E��O�?X��&�/�������$�9$��)����Қ$Ci=�B��:��٬H���J�Y�d(�����$��X�I��۹��A���s)���/
�4%�RIC�E�_Ҍ<��$����PI3�y�I���(tJ楼%n���'��/{���H��^,J{���W�%N|�s3��K�d^:%���`QjI2��ݰ}\٬H�R���Ԛd(��`Tj�y�
�3�)��.�P:�d(���t�PJ����3����Ҡ|Q�9��<Ӕ��qW9���E���q(O3򍡒f�C&��7��Y,Bg���W�{��+/��d^:$��)����ҕ$C��U�W��7+��tU�P��d(]����$����y=�uה�K�d�)(%�p�:����T$��t�B(��/95�
X��KM2/F�S2/���:^@w<�]r�W�Ҙ���1._Jc^��1/_Jc^�����f&��ɼtJ�����$�PZx���?ִ�PZ�d(-M2���`Tj�y�
�g�Q:%��%Jk��5?X��"J+�±��_�\�d(�]2/5ɼt<�Nɼ�W�Zz>w�[��-K��V$Ci���I�Ҙ�-�Y��`0��|S�9��̩�W�����o
�1/[�������͊d��y�ʐ�򕡳��P��Kyj\^,�1C��y���$C���R+���xZ\�:�۬I�R�y�I����tJ楼
���z\��#I�ґ%C�(��t����$C�8�E��:�t�d^:$��)����ҙ$CiL�V�� �R�7�Θ�o
�12�*cb��(Ҕ��A��c�㈜�y��1/_:W~�]E2�.^�Ʒ����$C��y�I����tJ楼
���d%%�
X����X}�OiIM2�őx����(5ɼtH�S2/]�9I��|�x�u�i.��4W�P��d(�����$��X�ʇ�ۜ6��y��4/�Ji^�͢���C)���sh��/���C)��7�&�����)���*Ћ�Ο�R�d(�Y2��"Jk}�(�M2�V^��>��/7mf�y��K�d^�,J[���W���s�)�H��V%Cik�����R��Ky��4�X�6%��%J{��=?X��"Jijn���lՔB'��噦�W���ȩ�7.R�@wDҼ|c��y�ƐI����E�5�Pj�-ny��Kj&��ɼtJ����t$�P:�U�SL�\�Q$C騒�t4�P:��Q�I楼
����f�ͦd^�$C�L��t���Y$C��U���?�٬I���%�R��KǃQ��Kc����?���O/M�7�R��o�45�Jij�͢���C)M��Ϩ���|L145ߘ�ɼtJ���>�5%��W�Űs��T$+`U�
�$k`����$�R^����y���d^�$CiN��4���\$Ci>V!�p�ye��&Js��KM2/F�S2/�U�~���+�$�PZ�d(-E2���`QZ�d(������8�Rij�1/�y��K׃E)M�7�R�����k��)M�7�R��o�45�Jk0*5ɼ�W�U��ףtJ�K2��$J[~�(mE2�6^:h<�T��I���%�R��KǃQ��K�U�����I2��,J{���>X��&J;�B��~Lm��d^:$��)����RK���fg~���+���N��/
�48_*in��(Ҕ��A�ƋV�{>+M�7�K2d��|c���"t�P:x�Tp9KG���K�&�����)���*��2W�L��tf�P:�d(����t6�P:�oB\����&��ɼtJ����t%�P��}Q�·
�*��tU�P��d(]����$��X���8��R���ƼtI�����|c,?ا���|cV��K�����|c�K�&�����)���*�����Ϫ�$Js���H��\,Js���W�7�R��K�d^:%���`QZ�d(-�*���c�V�d(-U2��&JK0*5ɼ�W�{Ǖ>w�ʔ�K�d(�I2���`QZ�d(��y���8�o45�Jij�1/5ɼt<�Nɼt����sڍ��C)M�7�R��o��>X��&J�B�W���f�y��K�d^�,J{���W��hgi/���W�Pڛd(�����$��cbTo�L��y���$C���R+���x:?�y쑬I�R�y�I����tJ楟U�#�<������P��4f�+Ci�����4f�+Ci�Λ����4f�+��!��Nɼt=X��$J'�4���,��tV�P:�d(�����$��c�F��:E�S2/]��t%�P��E�*��t�c���^[M2��.���d^:�J�d^z��LOI��%�`E�V�S�S���b������Lo�����s(�S)�\w�16�cj���?�=��+CeL�W�̘����?��d^�+p\.G��K�d(-I2���`QZ�d(-�*�ũ�=l�4�PZ�d^j�y�x0*��y��M��C��v�I2��,Jk���>X��&J+�=��cgTM2/�y��K׃EiK��4��Qh�u1=��Bg��7���o
�11�ViJ    y� �}P���1/_�W.ɐ�򕡳���^$Ci���%����7�Pڻd^j�y�x0*��y�
��:���$C�e�PjE2�Z}�(�&J��&�9�_�f�y��K�d^�,JG���W��\��tE2��*JG���?��d^�P���3t*�K)dҰ|Q��Y���H�/
�4)��c�K�򍡒&��L��;ǃQ��Ky�B�y֨�$JW���H��U,JW���W�.K�8�_&��ɼtJ���>���dv|*-=�K�T$+`U�
�$k`����$��c_K_~�NɼtI�Ҝ$Ci���H�R���p�/F�򍡔���R��KǃQ��K��,uޛm4/�Ji^�1�Ҽ|c(-����4�PZ�U���(5ɼtH�S2/]�5I��ʫ��b�_玬�PZ�d(�M2���`Tj�y)���z�NɼtI�Җ$Ci���H��ƫ��p��Ook���uɼ�$���`T:%��X�Nǌ�MFC�E��f�B&���J���������H�r�:�|��y�ƼrH�S2�\��$C��
���<?fV$C�U�PjM2�Z0*5ɼ�W�^�s�;2��y��#I�ґ,JG���W�8�wB�h��ttɼ�$���`T:%��c-=�k6�d(�Y2��"Jg}�(�M2���l_�o�G�)�C)ϜJy庫������H󲝯�:"i^�1TҼ|cȤy��й��Q�I楼��,��y�l��HI���S:R���x����/�HM��%�R��KǃQ��K�oB��ȑ�d(�Y2��"Js}�(�M2�f^:5z���$��!��Nɼt=X��$Ji^>����4/�Ji^�1�Ҽ|c(�y�7�R��K3~_:J�d^�$C)��7�Қ,Jk���W�n=�h:j���K�&�����)���*�m��]d�%�Pڲd(mE2���`Qښd(m�
4�����L2/�y��K׃EiO����*Ћλ=G/���W�Pڛd(�����$��X��U��S��o�K�d(����PJS�o�45�Jij�N�Ӛ��|c(���Ƽ�$���`T:%�R^��]����c$�P:�d(E2���`Q:�d(�
� j�Qj�y��K�d^�,Jg���W�x��|�Y$C鬒�t6�P:��Q�I��*���y�NɼtI�ҕ$C����H�R��<u�hv�1���|c^j�y�x0*��y�b�_g�O'��7V��d�H���}Jgj�������Qj�y��K�d^�,Js���W����_�g.��4W�P��d(�����$�R^��[yg��y��%I�Ғ,JK���W���ml�4�PZ�d^j�y�x0*��y�gf�+T�c"3F�BgL�7���o
�17�Vc�M�1�����H�#�$��!�gNɼs=X��$J���$]���H��V%Cik�����R��Ky�~���>�mJ�K2��$J{~�(�E2�v^�:�@��M2��.���d^:�J�d^ʫp�&���iI2�Z��V$C���Rk��4���穯�{�14ߔw�<s*��"2�Bc��[��{���f��W�ʘ���1/_:G0
5ɼ�X���x�X�1%��%Jg��3?X��"J'�B�G2���$C��y�I����tJ楼
�N��%]I2��,JW���>X��&J����t-��K�d^:%���`�ҕ�d�P�b�|�����M��T�jJ5�~WiJy� w������o��Rh�1��И�]Ec.J�1�R�+7�P��d�i�y�x0
��y)�@����\%I�Ғ%Ci)�������$Ci�U��Տ/g1ɼtH�S2/]�5I��z|�V�cMk���J���$Ci�F�&���*��=֯[T��K)dҘ|Q��)���H�/
�4#�/�/����F��/�M)owE�S)o�m�wG_͞�Bc�J������]EcoJ���?vSvD�d^9$��)�w��PK���x� ��*��H�R���Ԛd(��`Tj�y)���|²)��.�P:�d(���t�PJ�q�*���y�z�p|Q����<Ӕ��qW9���E���OU/��o�4�2i.�1t��`:�d(��������k�d^:$��)����ҕ$C��U�?t^%\�H��U%C�j��t��R��Ky��l��A���d^�$ۿ�)%�X~���͊dƫ��3��|�fM��%�R��KǃQ��Kc>Ow�<.����B'���L��/
�4�RI��E�����}�T~<R��)�C)o�Jy㺫h,I)4����	��R$Ce��!�4��Y��Q�I楼���q�NɼtI�Қ$Ci���H��ʫ`.��<��Y���K�&�����)��߄����jI2��,J[���>X��&Ji>>�pU>��4 ߘ�ɼtJ�������C)M�v^xZ\Jc򍡔��C)�7����JM2/�U�q���ͦd^�$C�%�Pj���Ԋd(5^����Țd(�.���d^:�J�d^ʫ@'B�cݚF��#K��Q$C���I����@/Kl?JM2/�y��K׃E�L�����AW��?a�UQ
�4-_2iX�(TҬ�KQ�)千�؎Ʃ�7.��Hc�E�q廊�U�B��mO7���7t5�P��d�i�y�x0
��y)�@�Sg|��S���e�*X��������$30^��b�&��ɼtJ����4'�P��oB��qQ�E2��*Js���?��d^�0����'鷚Jy�R
�4+_*iV��"�F�B#M�ǟ�:�&ڬI�J��o�3M2�F�S2/��X�{�\�d(�Y2��"Jk}�(�M2��c���c_TM2/�y��K׃EiK����*t�Y���s+���U�Pښd(m����$�R^:���,�fS2/]���'�P��Ei/���&���G�|*%Ӡ|Q�9��<Ӕ��qW9���E*���Oj����H�E���B�ջ�FkJ��x����B�I�C2Ϝ�y�z�I2�^���E2��*JG���?��d^ʫ@/xo�wLɼtI�ҙ$C����H��y|&m���o6�P:�d^j�y�x0*��y�gV��������o
�1%�2cJ�)TƔ�[Ed�7�Ƙ�W�K�?�rcF�2��y��;׃}BKJ�� �\�<�RR���U�*X�����R��Ky�V��x��)��.�P��d(����4�P�y�K3�Ks���K�&�����)���*/�9ִ$�PZ�d(-E2���`QZ�d(�Iye:�ϯi�7�C)ϜJy庫��!���3�Vt��y�B���P3�!3f�+Cg�F�&���
��S2/]���%�P��Ei+����*��j�fM2��.���d^:�J�d^ʫ@����J�'�Pڳd(�E2���`Qڛd(��
�k���d^:$��)����RK��4f�U��f��X�Y�����M!3f�Be�ʿE�R�8H�y���_��o��Rh�1���8�]E�(J�q�7\��;�Rh])o4��q�5N�������B�ߔ�$C�̒!s��9�E�l��t�
����_���$��!��Nɼt=X��$Jױ�������"JW���I����JM2/�U����s���ш|Q޹�ڙ��jP��>����2�J�?��Xi8��Օ�FS��]Q�T��m�iS�w��$*s���H��\,Bs���W���������d^:$��)����Ғ$Ci�U��tށ\K���J���$Ci�F�&��߄j���m6%��%Jk��5?X��"Ji:nt���*��N��/�3M)�wE�S)o\��O>�4_i*�(4�P|Qhl����5��؎mϗ���m3ɼrH�S2�\�=I���+@����k/���W�Pڛd(�����$�R^�s���}J�K2�Z���,J�H�R;V!N��sM�I�R�y�I����tJ楱
�+�r�bSi2�(t�d|QȤ���PI��/�4_i2����ʏG��2��q(�S)o\w�3)���۞n,�B�"*g���I����BM2/���d�?\�sJ�K2��$JW~�(]E2�.^���・�d(]]2/5ɼt<�Nɼ�X�8�p���$+`Y�
V$k`��>�-5�,V����y;F�����s(�S)�\w�4_i:��s��� �  C%M�7�L��o��?��d^z� ��(��y��%I�Ғ,JK���W�	�(-M2��.���d^:�J�d^z����W��$Ci͒���PZ�Eim����*|��-d�(5ɼtH�S2/]�-I�R��?�l��YM��N��/
�4%_*iJ��(Ҕ��A*����O��Jy�R
�4 _{��h�E)4v��ty����7�Pٻd�i�y�x0
��y)���ı��$C�e�PjE2�Z}�(�&J�X~��8$2��K�d^:%���`Q:�d(�7!n�;��n�H��Q%C�h��t��R��Kc�߅��Щ�w.��IS�E����_*"iH�(4Ҍ<����{���F��/�M)owE�S)o�mw�����Rh\Y)4��W��h\M)4.��q�)�-S��R�8���uW�ƞ�R�۞n`8���T$+`U�
�$k`��(�$����_���S2/]��4'�P��Ei.������}T�k��4_:i*�(�4��r�EN��q��)����@|Qh�y���H��E��Ի��ҔBc�m?>���є�ơ�7N��q�U4֤+o���_G>��PY�dȬM2t��`j�y)���b�q�NɼtI�Җ$Ci���H��ƫ����g�zk���uɼ�$���`T:%���U����ǒ~��B�g�*d~��B�g���a������sJ�U��є�ơ�7N��q�U4ZR
��۞��x4ZQ
�V�B�5��h���є�F���>�az���y��#I�Α,BG���W�u�8�M2��.���d^:�J�d^ʫ@����$Jg���H��Y,Jg��1������������߿?�7�<	������s�lq�|�����9�������_��_�Mfʤ�������_9��o��_������      (      x�}�;��8��e��)#ހ��B�3�h��u̹ɨ����SBZe��A ^ y�r?�������yջ������S~�B�u���Q�?S���m��?��Z@-�TVg���/f�y��:д��Y|&U��x�zCۦj�Գ�z��i�����O������v�2�Wϓ�=W�V~^Z�s��n���6Q7���V�q���Dm��:�qɬ���G���iVM�Mm������ȟw|��Dc��#Q��:�2�6����}��ݠVm[��i�u�aR?�?Ee�Pu��QٜE%s޺	����{K[tAyލ���t���V��5����ww��5�ݡ�*��K�x$�qx1n~ܣ�~�Y${���-=/o�O�jM�G��s�帏+����w�]Q)��Z�¾�9�gޅ&=R�y+G�Nf�Qe�����j�:��"���d��W��.4�󐶍�H�N�nڅ*j��vΑ6>���JW{�Y=E��P���}N�?*G��*-իg��^�<Ԝ�-�1dt3���YMQ}�Q�Ĭ�MdMC�B=V�My��T�x�^�i˶^�m�>�4鸾.�4�JD�H���R�Z�.oV����h�ެV��8�γ:jE�r��Y��p�7?�eU���z���v�:oQ��t�/s������Q�5����r�8iw����&*[͸��:�G���y�J�����r�&��BuI	?�*� ?���6�U�ӧ/.�niK�t��r�U���zh��mxs���~�NJz���Āk�����ʥ�bu��HǓ�tX��$�X��.ļ���*���|��e��mR͇��Wθ���a��:�:���ӔoB�L
�Z>�}�uR�dn]Uܠ���/�/.�L���z�R�N��*��f�n2�!*��*�:��_�϶�CV3Y�����
�ҳؔ��ޔύ�̭|s�V.�K<,~)���..��=y�B��O;
��1?*�!�۟��|O��既�{q����V�ӫ���*�i�a�i�۬n� �j�Q��qg�`�m��8�}T.�6�ߴ�N�ʜ�ȹ���Н�Ee���Ӝ�g61��a�CI�T�p�����\4~T���no����-���5�i])���)j��٬r6�,J%TXŌ(M7��K�z���e���}&�r�<�ctK���Y@s�G���d��v̅���Q+;�c�/.��T)q����ȓUN�2j㫘%����E��:�ؔ����fc�v����J�㼬1g5�^����qk9��>��􌓒)����ٱE�VV��Q�,Ƨ�N��X�<.�~z����k�V^*��ʪl}a�S��y/��|G{0p�5;}Ԏ.�R��Y^�UV���ȸ>P}����U^e;:E~���f���Yb-��Mx�
s�k������j?4�b����tx�|W-��y�\?*W����&*�r�r��Y�^�U��弇�k���%�ݿ"j��ј?Ql���?*��`����%*߯WQ�8�Y�;c~����i���>���K�Q��SE��#��s�[/��?b�OmnV�u�Q�q��{�!ꤶ�6��\���3�h:�Ϊ�Pcuzc�͆#��j9���cߏ�G���|�sX��!j�/hܡ�pX��[��"u�*�>D�㵪|�YMN'\�΀\��4�k1��K��7��:n?���J�X�Tb�xp|yѺ�MQe��ۏ��\�]��r#]Y������7�]���g
�b�[�
U��b���9[��\�v����C�x�ti�/�qo��-)T�@T�yJ�\�h[�Vt�z��e�EߨvV;�dik��#�i�s4f=��o�iRUb�dQ��U��q�*cIϜĆL�ב�m\�ɜ?)��f��+��U�`����o�?��-�	����#�NS�1�M�/�o�o�����e�_˜G,s�wz������z�H[.@I���z��S�������*m���pN�	bΜ��2�W��;E�R
~���(�3_�є��-��|�Ym\tUVߔȸ�E�J\ �<1��XvX�rn6��=wW<g��j�R�]7�$�����J��Ca��g�n��-�m�h��7���|Dl�`W�x$�|x+=��s������j�_6H��'�!=��iS��aU����oz�Y�U��r�P�c�]�\����B���9c|��%����;B�ج���vz��Z�a([C�����f�H[�ذ�**׿���\i��΋�q��i��2���oT��Ş�y�����/�jqx������^��<���,ɸ��֩�����F{}����)����~�ʉyʸ���+V������¬ö��:z�%=˜�r����h�XV��g�߾����߿K����O�iMr�^։*�ɓ����QiE��UZ���ҩm�aS�����������b���W�"�Ɇf�1Z��"�]<,�J�������o�.N�4��3�d�N5�]��U����|�.m�Dr��Q��YZơ6�X��?��"���~��[��x@�8�}�y����Y�<�3�N�m~z�o<��Ŧ����k����,R��:���3*Ϙ�VxK6[�W��G���3_)MV��qɰ.h���\/�s�[�}�i_�M�Ge�h,���z^o麨�!}au����:��c�֢HT�S�S�sٿ>������J�o�u
��W[�14�ʁ��o��*n��u�G�SG���)�Fnw����������*Y��O[�[ѶԔ&şm�Q�OnMDv��*e'������n�\����"%��z{����,������2��(�E劧�:����/I�̋_�.�}�Y�n������+UQ)MH���D2)Qd��⏈�|�\Y�rX��~9[��U
2���~�����\ӛ���K;~dkZ����ON�t��Q�]�rp�^j���"r,P��g��kj��R���G�B�����SّZ�?��ԟ�rj�����k���M���gRp���m���RϪ��� ��3�S.<�Gun�`�˫�Is֞�+m+?/-s�9���ܶ����O'���f�q{_{��X`\2��=?%4�??��Y5Q7��o#l#��u���	��B�]�A��mTi{��ni�A�ڶ��Ӹ��,¤���*�������,*�����MجV��[ڢ��nt�W���d����'���J#���;�X%{���2/�͏{4�`�@�O؜����M�1�@�@Rж�q%�bv�]Q)��Z�¾�9#P,�Mz���V����*P,�AKe�(���b'��h���w�震�m�G�v�8(؅*j��vΑ6
��u.T��b�7�����5*?����7@-�Vi!_=CM�2��Ʈm��!�����j�ꋜ �8�l��깰zh�hʋ��rǋ'��D�ZL���K���뫶 ��dT$U�/�m}��Փ�����uJ9�7���)*Ϊ�N���#eVdV��O�5]�\�q?0.�ب7�8GVɠ�q�̹��šY��b����@�-���6����l4�j��>X�����`\�ieXX�.�$0.� �ߝ��\}0.|��K�[�R)!󄇴�~��{a�ڼ�j�ܞ߬�U�:)��b�f�EF`\ xvV+����E�#O��aq��8c!j����f�*�W[���2��6��Cr`\L��<Pu�tV�.0.��IaE�G����zX%s����}}q�}q�dJܔ���wU	_7�u�YQ9UW��)m�B��\δ[���j+�J�bS��{S>s�2������I?�|+..��=y�B�g���@^k�bb���9��-Ee���`\`�i�����*�i�a�i�۬n� �j�Q��qg�`�m��8�=S=�o�o�~eN��u�\�LF�b��ޢ��H[�i��3����0ġ����o�,�s�x�"m���ym�����.���ƅ����lV9�v�*�bF�����J=�D�2JT�>�E���1�����,������GO+�Xk�\�mQ�(����:>S��ń����JMV9�ʨ�/j����?0.�{0.�n;_�6Vi�@{0.�T:�e�9�I���L�H�KTg�b��q1�-0.0neu����b<��     S^���C�ń���@HV�sbeU����)~�ؼ<�!ڃ�{��)0.&�����}諵ʪ\�������Y�U��#�Q$0.�l�����%&�R-܄�Q�0׿)����C�.V��*M����7��ٛ�@����:��au𹭉ʯ�E���hV��Wb�A�|9�������\rt����:Fc���De7�v~q�D���**G6�tg��㼁q�(��/}F��>~�.�L
�2l�|>�Č��ilT~�w��j�:�-���2ģq��0�Ϊ�*>�X�ޘ�E=oGU�������G���| tX��!j�hܡ�pX��[��"u�*�>D�㵪|�YMN'\�΀\���T���=L�OK���Oj�3/��3_^�.~STY���c,6W~�`\Lv��Oa���}u뙂�X��"�B��X��pΖ�:נ("�G:޴]��i������s\
��<�g.~��+:o=��2ϢoT;��o2����㜳�1��00.&��*1a�(��ªD�q���gNbC&��H�6.�d��/�a���+��U�`����o�?��-�	���%0.�ԛ����5,���g��#�|�-|},s��i������̹H[.@I���z��S���������*m��RqN�	bΜ��2�W��;E�R
�Ŝ>�b������X`\L�S+�Ŝ��"m%.��7}-آ���n�����MW�r)���Ŝ�֭�Uږ�
�d�<�u��nQo�G�h��Y4�#b����#Q�]�<�˽U5vV;�*B�v>a�|L�����%�}Ӌ��*��4�k�"�S��Z���z���#0.&���9B�ج�gU]�2ek�UV�,i˟"vV�@����Z�̕w^��C�N+uX�Q��|�ڥ-�,�3���}	U��+Ձqq{/IN�w��d��w����rOvh���z�|���zk�D��<e��m���_
�EINoa�a���n�ϒ�e�h9��q�\�o,����o�\�����q100.�$��e��r�<Y��"*�����J�ҔS:��1lj��q�u�J�������*_)��'����Se��.i%�G�+1Y�fQ��dAO�/>L�T�޵;Z�z	��X����d�
Zơ6�X��?��"�����,fh<�u��>�<S_^ܬ�c�c'�6�q1e�������=�q��|���T�E�RU��/T�bj�-<�%�-��+����꙯�&�|׸dX����t�������>������&����;������z^o麨�!}au������R��Z���s�踊�N��_�p||��CS�x���`\�����l�D�*m)�IS�.�&�.�VE)��b�60.�ږ�Ҥ��M1�~�ɭ��2X����Б�w���k\|PX�$�Vo���s���?R�\Z�����\�TV'�x���%��y�+�%���;K����`u�{�**�	i���H&�!�lu_��`���+��A���/g둼�JAFB���o�Z���kzS<y)b�Ïl�AK;-�qɯ�}�/3����&���*�-^)"�E�|m�������`\���%���w��Z@M1.N�~��~��qi��<���_�N0.�w����`\��6�����)�����	ƥ�:��<i�	�ƕ������ǜ�&��m��ڦ�9����'��j`���j�nj�`\�m����y��9O4v��q�J0.`U���	ƥ�F#i[���x�����X���`\`���=��MH0.-��b\ �%�6;Y�qi��&����&ء�*�X�qq�qx1R��Y���O��\�q�eN0.�4�I!��@��bv�]���,������B���	�v��*{�`\�������������`\���{�`\L��B��q;���eV�e��=�A-PD����D�H��Z`����Z`!P�IUj�Y%�S��Ź�d�KA-&L>��!��b?IA-жI[����|li<J@-�.P�I7E�Q
j1}�Z v'�gt��F
j�Ȟ�Z�A��U
j�I@-�VfEf��ZL�V%��SNԛN)��H��2���7�f5P�1��-P�nj1uu�Z�mj1a!@-`�	���j��M@-�&U&U�A�?�,7���i���Z`�7���7���d?-�_�.���Z��׎�c@-n�N�j�y�ZL����ʅ�������ޠ����VV'���q^|�e��mR͇� ����s��p�Ϊ?��:N@-��	�����j�;ljq�/.-P4M@-0��b�� �8�?hpzxP�9c��,T�Z��K��Bjj����ߛ�2��@-&���o��RPXFg.�@^k�bJA-�d����+���{�Z@M@-&����j1��jSM@-nƝ�"����U.�ޠ�o	��M@-���L
jq{7�A�-�tj1)&@-`�oP�Vj���Z�)5@-Ύ絽[΋��7��M@-P(%�x�7��΢TBoP�)g��:�ZO6Q����Oj��	�"_j��+�|�K@-&÷��_j1uy�Z�,�g����[c�*��+����ʨ�/jP�<.c�ZL	��Z�Ej�Z �5Vi�3P4M@-�f�sVKA-�b	P$��b�L�Z�Q<@-&��ƭ���K@-n1�_?�� ����j1�>@-�U�XY���Z �$���v(��3f�ZL�	P����Зg�U��O@-&P��7��1���H�Z��L}��Z�]�Z�Q�0���J_��;���oPĢ*M����7�)�,#���&��U�_ȋZ9�%�����y/djq����%�s[�蹉�n��Z�8@-�P����60��PD��bJ�Q��qE���Q�j1�<@-3ޠ�`��㤠(2P����b.FF���Z��Ϊ�PcuzcP!��U-��b�}j�MH@-&O��1#��"?@-&V����J�EjjSO@-�b	�6��znpLA-���/^��|Zu�~R��MA-�`��1�@�YY���c,6��b�c�Z̩rlά)���LA=��%�g��svj1��8�{)���K[~5��ZLRP�9.�����Ŕ�Ɯm@-�h�EߨvV;�d�A-�\�b�s4fj1QnV�		�V9������UFj��J@-�&�x��;�Xm\�$�s7�آ�)=��J����%@-�ԛ���)��ԮS�c
j'J@-"P�ɻj1Wzj�9'�Ȏ	�����{�&��~2@-�J��E��sBj��(�����ʝ	�Ŕ�j1�� ��z;@-�(�Sd���
j1g� ���H[�	�bYj1�s�i��`g��b�J�b�D����{��Z̬֭���Z���Q�j1a0@-�`W�x��ZL]�
{~
j�8�Y�����b��_�$��Tj1U�jz�Y�UN@-&�.I�)�0�����)��� �8G����YUעC��E���7	�ń����q�k������3њ\K��5�8/�\���s�]��~
j�쬶��^�\
jq�l�E���l��z�|�LA-显�&���l��P�)`%9j1�u�>+��[�}�)��&�x��b|����c����NT�NN@-��`:���6��r @-�"�bn+�+QI���`c��E���b�mPē��M@-�	��YT�8Y���� 	��x��xh5��qj�|��Z�*P����wȋI��Rjq34$�-���H@-��	��Z	�Ŕ�[Ύ)�ō����@-&%��7����bj�-��~��Z�-o��2P��P��Z`�;��Vv~����b�0����y�����	�Ŕ.j1����(z�Z�c�Ta�MA-�qj11�o�u
���bN�r��@-��s���oP��7�RM�]ܭ��R.@-&��Ÿm�Z`)ޠhJ���63PD�&";Hj�)%�����k\|    ��Z��P��A-gP��Z`kP��Nj�qP����$r�ůHP�9"���6���Y�2P���bN�g]�ޠ*���|�Z`�ޠ؜�₁܇��������\ӛ�������Z�K@-��a�o�eF���D��Z��+ߠS~����F�jj�y!����w��Z@MA-N�~����j鿑<���^1@-�w�P���Z��`
P��)������	���:��<i�	�ƕ���7��7�@�&ꆶ)�zN@-��	��%�س�������&�g#l#��u��]d�Z��P�Fj�M@-�7%���7�(��<0��*���&�X��n��Z`�	�����_PK�g�Z\���d��������Z`���c)��Y���HA-f!�b<!@-`s	��9��P$��mP�مRt5PĲ��J@-�Mz�&���Ϊ�Qj�J@-�����B�_P8hj��P�Qj1q0@-�	�ō�9G���e��=�A-PD����D�H��Z`����Z`!P�IUj�Y%�S��Ź�d�KA-&L>��!��b?IA-жI[����|li<J@-�.P�I7E�Q
j1}�Z v'�gt��F
j�Ȟ�Z�A��U
j�I@-�6��+$�S�U�F)�Ŕ��S
j�'�q�̹��M�Y��b���@�����ZL]�h��ZLXP�zj�|�Z�iP�Ij1Y���ܜ�~��j
j�aߠ(ޠS����~��{j1N_;n���U�:�7���j1eD�Z xvV+�oP<��Sz�Z�?P���Z �&������.��o�j>$��d� ��� ��tV�!-@-�qj�N@-�&���oP��a3P�s�}qi��Z�ij�	'�S<��9�A���{�Z�;@-f��b�_ڭ�pg�RPl���ޔO�	�Ÿ�j1駕o�}�ԕ�Z�2:�hp)��Zc�P
j1'� �����^�Ŝ��jj11�5�poP�)P�jjq3�l)����r��@|K@-�oj1G�6�dRP�ۻ�"mɧ3P�I1jK}�Z��Pd��bN�jqv<���r^\\�A-�mj�B)���A- v�z�ZL9����z���e���}P4M@-�P����G'������/���<@-`����T;j1�/@-�RoP<�����&���� ������� �@tk���g�h��Z��D笖�ZL��H�	��ę ���x�ZLxP���Z��4@-n1�_?����~/��P�ɪrNL@-��A-jP���;��Z�3@-&�����}�˳�� ��@�PߠX��b�"jqf3�]Dj17tjqF��\ӷ+}����A-�P���7�)���U�v7������B^���/��Xu�=_�{x!3P��%G�/���� �@�MTv��b�j1�@�Z̅א��)��8o�Z 
&�S�����(R]&���oP���j�����'�@���ZL��s12G��=wVŇ��s�Z�I@-��]T�PlBj1yjt�	���j1�j�	������Z��Plj1�����ZL�?^_�$�s9�7��㦠s_0����u��br�Xl���d� ��S�؜YSP�z
j�J@-����b��qx�RP�A���j:����s\
P���	P�)3�9ۀZL�<��Q��v��x�Z����8�,h��b�ܬP�rj�IIǍ���+��Z@M@-�@	�v��ڸBI@-�n&@-�E	�Rzj1��j1�K�ZL�7;��SP��]�d��N��Z D&��w�b���sN@-��9@-�7��+4Q���jU�6�-✜2P�F	��\��W�L@-�P�9}����j1G� ��"3@-�VP�9#�%���� �@,K@-�rn6�����l��Z�UI�Z̙h�z]��Z`�P��պuP�٣U4J�A-&���*�P���Wa�OA-;�����ZL�\�⋔��J@-�j^M/�:���	����%�5��&����0��@��c��8��Z�a([C�(�@�K@-&��-���_k=�0�7�Ŝ���Z"��;�5��.m���bN�kq�OA-`���v��K�KA-.�-���b�M�Z\ϛ�)�����Ĝ�Z���R`j1�$g@-�����g%�s�o7�@��O��Z�o?���bLr�^։*��	��\�BG���&�S��Xd�Z�m�~%*i;�l�򕢈|�y�Z̽��o6�曀Z`%P���vq�����P�����j@-0��� ��U$�S��=��"�����,fh<H@-.ZL}y��Z�1P�P�)㷜SP�wq��ZLJP�oP�9���Լ[x)��6�8[�\�e�p	��M@-�ȝU+�?m
j�j1w�j��A����uQ�C��bJ� ��R��Z�A-�1M��禠�8���p�7�:��cj1��S9�f�s�P��PD�7�B����&�.�VE)���b�6@-�oP4�I�g��"I�$���PXjjq�5.�H@-�|(y��3	��M@-��	��d� ���	�Bcc�K9��W�	�����t��Ź�,�`��Dj1'�.QoP�[^E�A-�LoPlNjq�@�CSP��jq�z��M�\��ej�N@-P�%����ܷ�2�K[n��K�r��oP�)��2�w�j5����P��ݻ�j-�����?��������H��ZF~����{	�zN@-�wP��)����	�e�:Pjy�P���ZF���w��mP�����='�����Y�ـZ`V	��&�g#l#��u��݀Z��P�Fj�M@-�7%���7�(��<0��*���&�X��n��Z`�	�e���_P��g�Z\���d�e������Z`�P���S	��Y���HA-f!�b<!@-`s	��9��P$��mP�مRt5PĲ��J@-�	�����Y�=J@-`W	��x~�ZFZ��jM@-�sj�=J@-&�v!��q;���b��t��7��`j����Z`�P�	��M@-��	�2��T��Uj1eL�Z�N6��b��j��)/���mP�����|li<J@-�.P�I7E�Q
j1}�Z v'�gt��F
j�Ȟ�Z�A��U
j�I@-�6��+$�S�U�F)�Ŕ��S
j�'�q�̹��M�Y��b���@�����ZL]�h��ZLXP��`��kj��M@-�&	��d���rsZ���oj�aߠ(ޠS�����b�}O@-��k��1���]'�����A-��P��j�B�j��y�Z`JoP�Gj�~P$���q^|�e��mR͇� ����s��p�Ϊ?��:N@-��	�����j�;ljq�/.-P4M@-0��b�� �8�?hp�b��j1�s��n-�;�����Z`����|�L@-��P�I?�|+����YE�KA-��ޠ�o	�Ŝ�▢�{e�srP��U��)��7�Ŕ��L5��w����vV��z�Z �%��7��#Rd2)����PI@-�oP�I1jK}�Z��Pd��*e����x^ۻ弸�~�Z���b�B)���A- v�z�ZL9����z2����A-&�����2�������ZL�oG��b�� ��Y�:>�S��ń� ��J�A-�2j㋚�b���bJ��b.R��-�@8x�Z�ij17��Z
j1K�Z �&�g�b��j1�-@-�uR�Z��4@-n1�_?����~/��P��	�67�����k� �8/x@-�C	�Ŝ1�bbM�ZL݇�<K@-�P�	Tj�j1oW�b�"jqf3�]Dj17tjqF��\ӷ+}���j?4���(�8�|���Z�]u�Z`wP�*��    �o�oNA-.VtOj1�"��咣���Z�me�Z���bj� ��p�ZL)�s�5�m`
j1����	�Ŕ>�|{�>�T�	�żx@-&��b��blT~��E�uR[Rg��bnFF�YuVŇP�1� �@��Z`뻨���؄��|ⓀZL�P�)��bb�|P�	�L}���kU����ZL=78��S��/	��\���Mj�)���<8��h]��(���=�kj1�1@-�T96g���{����Z�K� �8{<��3P��?���KA-�]����b�r�Z�q)@-�F'@-�̘7�lj1E�,�F����&cH[k�j1�9���(7�Ą����Z`R�q�*#��J��cj�J@-�C	��\�ͦ,	��(�@JO@-��@-�~	P�)�f�r
j1��옂Z����O�	���� ��+� ��K� ���� ��cܜz���Z�{�0ؿjjq�<9'd��*$@-�*d�rgj1�`�Z��#@-��P�9����j1�B�Z�!@-�(	���D�bYj1�s�i��`g��b�J�b�D����{��Z̬֭���Z���Q�j1a0@-�`W�x��ZL]�
{~
j�8�Y�����b��_�$��hU��2���k��	����%�5��&����0��@��c��8��Z�%�آ��.��0�^��	���js}�Z̙hM�%RP���_S�`��{NA-�Ļ��b^�����$����b�LA-&�������Z�1}mM�	����+&�S�.Jr�b\��}Vj1�N��qSP�M@-�D	����j10@-�$��e��r���Z���.נuL@-�5R�ZL9�c�j1��������b�j'z�Z��z�Z̽��o6�曀Z`%P���vq�x�Z̭��|�IA-�z	P�X���LA-`	���jq�;��M�_K��Y��x��Z\����"��c&��Z$@-���rvLA-n��e|j1)9@-��A-��S�n9ॠ��!m���͕\j1w�j1�j�E��[�}�iSP�oP���P�Oj1�k�f�OA-�t	P�)�ϭE��Ӥ
{n
j��P��	�|�S8>f�s:?�oj1� ���� �@D�Z ĽA-��h���nU��rj1�<@-�m�K��@S����Z�5��� �U�N)�,5�8�_$�s>��rPę��&����b�S�Z�˻ �@hL@-&��y�+��b�Hgi�M@-��xG��iB�v�'z�Z D�A-.Tly���2�A-�9	���MA-0�7���빦7�s�	�<:�@��Z��r��ˌ.m9��j/��}�W�A-��
P��w��F���D�?*���m�ʎ�Z@�I���,�S��f�_c,�h��?$>��{EVoh�T��zV�@�?�P����r�)�x 8�s��\^=O���\h\i[�yi�{�n&X�M�m�8�ϸp��j���q�Kf5�秄&��'�0�&ꦶC��mc�m��;��y��?�T蹫�>���*mor�-m7�U��vw]�@�E���Ye�Pu��QٜE%s޺	����{K[tAyލ���t���V��5���Wi�>��w���c/��X��Ÿ�q�Fl��	j������	j1��H
ږ�>�d�Z�.���!*�^�Rط9g�v�IσTz��Q��Y��8h��a�b<?@-P�d�]h:�!m푴�>�v������s$�� �/+]��f�P��B��9����*-իg��^�<Ԝ�-�1dt3�3�Ba՗1jq.�o"��;��z.��!��b?����Iq��S������x����,@-&�IF�K�
h���Ym�\k���{�ZX���:��ii�yNfE��1���D\�U�7��b
�z�ш�\�,��˜˟_��xP,�p��"N���j����ʖA3����(���*�O���O+��BuI	�b1Y��vܜ��b��Xm\��Җ��'<�����e�����-V������ܭb�II�|���0c-�ᱳZ��[�.z�xҔ�����QӅxP,�67�TC���K�a�I5��b�b�X̅E�X�:��(�xʤ����_�X@=���uUq�o�������x\2%nJ�	K�;�ª���պ�,�������ꔶ~��b.Xڭog�R�g�)i��)�q�[����Ť�V��MR�MҞ<O!��sR�X �5V1�������bqKQٽ8�>(s6��U���Z��Y��A"2�"�v?��V���$�q{P,�zP,ߴ�N�ʜ�ȹ���Н�Ee���Ӝ�g61��a�CɃbߺY�%�1P,�(g����-���5�i])���)j��٬r6�,J%TXŌ(M7��K�z���e���}&�r�<�ctK���Y@sӃb��,V�u֎��ۢrQ"je�u|P,��	�	}�b����r��Q_�,Q��}�XL	��X�Ui�X �5Vi�@{P,�T:�e�9�I��OL�(H�KTg�b��b1�-P,0neu����b<�o0W<��C�ń�@�@HV�sbeU����)~�ؼ<(�!ڃ�{��)P,&�����}��ʪ\���@���Y�U��#�Q$P,�l��m��%&�R-܄�Q�0׿)�����C�.V�;�*M����w��ٛ�@����9��au𹭉ʯ�E���hV��Wb�A�|9����A��\rt����:Fc��De7�v~��D���**G6�tg��(㼁b�(��/}F��N}�.�L
�2l�|>Č��ilT~�w���i�:�-���2ģq��0�Ϊ�*>�X�ޘ�b^������}�b�M��G<�U��v�r����U	�U�.R'�b�CT>^�����t������M�XL�?淤=&oBQu�~R�Ǖ��x�Ĝ����u��b��c����b�c�X̩rlά|��fG�3u���E���U����-Ku�A;PD��!�t�i���ϸ��b1I9P,�(s�(Sf�s�^3�[�5�̳���j盌!m����8�,h�z:��r�JL�,ʡ��*C:n\e,陓ؐI�:Ҹ��9���kqء�j�
�fU.X�m���[��O�h��n���~	�)�f�r�/�o�o�����e�_˜G,s�w�b���s.ҖPR'n����{�&��B2P,�J��6��s��3�)���6�U�|�NQ����b1��@��z;P,�((Sd���
�b1g�@���H[��'�����_��æѵ�����l�U�\
⸁b1g�u�u���{��*,�jݺ�[����*%oVM��ج����HT��Vz&��roU����οl���OCz&Ӧ<�ê|=I{��"��ʫ,M�ڡH��T�$�Vm+!���r��	t�bq��16����YUעC��E���7G��ǆ�U9P���փbs�ǝ����JVeTi+ߨvi�=��L-���A_B����Eu�X��K���]��%w��:���ܓ�h���7>�2���/Q91O�x[����vQ��[�u�6��[Gﳤg�3Zξy\>��j=����WՁb1���XL�1��zY'�\'OV�_D�uq�WiU�rJ��5�M-2P,�r����\6V�JQD>�Ќ��X̽��o6����]��JLV�YT�8Y���� �E:հw펇V�^�3��o"9Y����q��,Vg�;�Ť��k�@�8�h'��<�ԗ7��Gz��ɵM�XL���(6�xd��e<_��%�@g��T�a��@���w�Ob�f������(u�z�+��*�5.��m��2���}.+�?���ΈzP,�3P,�?���[�.*H_X��28P,��>�E������\��:���+�S���)_m9�Д+^>�=(s���D�*m)�IS�.�&�.�VE)(��b�6P,�ږ�Ҥ��M1�~�ɭ��2X����Б�w���k\|PX�$�Vo���s���?R�\Z�����\�TV'� ���%��y�+�%���;K����`u�{�**�	i���H&�!�lu_ w   ��`���+��A���/g둼�JAFB���o�Z���W-/S<y)b�Ïl�AK;-�bɯ�}�/3����&���*�-^)"����}������������\�߹}��?�����?�_4~q      &   i   x���1�P�i�������q�~B��PQj����a$B�YU��������pΝY3�/�-f\m�
�?�_nT�ϗc�,]c��/z��=���|$�5�         �  x�mU�n�F<��b�Jb�$E�&�n��cXFA�YZ+,(���B�|J�9���c���0)�\����f��
���ޑ\�vc$�ȭ���.�s�/���N$U�"�EI.�De��(+�s�b��.m7�0Otz��
Z\�kl'o�� ���ۍ9���cx"P䑚EZC j�,τ.!�+q�'�{�~�O�y�q��b��d��:g:A�l:�*J�u� ��EΟZ�3`#}&���7�>�[���8��`�d�kz�$J*Ч=ՉHU�T<|��H���}�����X�%~9��>�؄���i���ޫD]��T�Uρ��3��kXO���ʕ�[� ���׳e�$Q�����]]�~vp�ӧ�8_��dS#=�Qc:yS�V��8u�-�$�gO��YP�l�y��
����k�K�3|k�?�����y���U��`�Ι�nq�u������6���	�p�Al��N�+l6�t
J����av&:�j�rċ��@Y��ܖ����x<��G�@6��$*�[���x���EPߞ�*�	t��%��Ŋ��@��E�ƚ�O�	�]/�;
h��v_��ʫ��Cu���p�L�ԩ�����2��3�U?��5$���=5��u{<�Mo�=:�8^{x��*i��FR����3@&xw:jd��>��CfS�$ϛGrV����1:]F�MK
nrꟁ&��P�m9/*r�gG8��wna��=[F�ӗ�S�Q���_Br
�w�?7qx;|Y#�r����7��}4�]O�s�WM��Y�V�!z�:��\C!nh���s�q�:�tDQ��GU�)�j>)�Q�1��@4�~��w��i��f��i�j��7��#��)�D�y-��iH�ge6JT��`��|o�$Cq���s�'�D�
4�G��	������S�V��f����	��^gh���G�|ِ&�ϛ��~8-f'�'''��1<      #   �   x�U�K�� Eѱ���{����)��o2zG&��=*:�(T��0Q#`�]L	tub�$6�g�x �l/pUY�-��0���^S&�%��ײ��,�b���l�$���=R��}η2��7S�X@���d�I*P�=�	`c_D}5	|�2� z�d��l ����˕( ���yJ ���e�U7���9'����e[r��f�6�r^��у}r�������y�!g�      %   �   x�]ͻ�@D�x���>���YrB�u�X�J�r`�sβ�񹽬ϫg����G�,ҋ�s/�V��h��'�m�7��L:I'�$����LF&�d��A2HZ&-�F�HI#i$5��I%�$���T��Pk��M�     