<?php
require 'conexion_postgresql.php';
session_start();

$usuario = $_POST['user'];
$clave = $_POST['pass'];

// Preparar la consulta segura
$query = "SELECT * from datos_estudiante($1, $2) as record(cedula int, nombre varchar(100), correo varchar(100), fecha_nacimiento date, celular varchar(15), contrasena varchar(100))";
pg_prepare($conexion, "consulta_login", $query);

$query2 = "SELECT * from datos_profesor($1, $2) as record(cedula int, nombre varchar(100), correo varchar(100), fecha_nacimiento date, celular varchar(15), salario decimal, contrasena varchar(100))";
pg_prepare($conexion, "consulta_login_profe", $query2);

$query3 = "SELECT * from datos_administrador($1, $2) as record(id_administrador int, nombre varchar(100), correo varchar(100), contraseña varchar(100))";
pg_prepare($conexion, "consulta_login_administrador", $query3);

// Ejecutar la consulta con parámetros
$resultado = pg_execute($conexion, "consulta_login", array($usuario, $clave));
$resultado2 = pg_execute($conexion, "consulta_login_profe", array($usuario, $clave));
$resultado3 = pg_execute($conexion, "consulta_login_administrador", array($usuario, $clave));

// Verificar si se encontró el usuario
if (pg_num_rows($resultado) > 0) {
    $fila = pg_fetch_assoc($resultado);
    $cedula_estudiante = $fila['cedula'];
    $_SESSION['cedula'] = $cedula_estudiante;
    
    header("Location: ingrese.php");
    exit();
} 
elseif (pg_num_rows($resultado2) > 0) {
    $fila = pg_fetch_assoc($resultado2);
    $cedula_profesor = $fila['cedula'];
    $_SESSION['cedula_profesor'] = $cedula_profesor;

    header("Location: ingrese_profesor.php");
    exit();
}
elseif (pg_num_rows($resultado3) > 0) {
    $fila = pg_fetch_assoc($resultado3);
    $nombre_administrador = $fila['nombre'];
    $_SESSION['nombre_administrador'] = $nombre_administrador;

    header("Location: ingrese_administrador.php");
    exit();
}
else 
{
    header("location: login.php");
}
?>