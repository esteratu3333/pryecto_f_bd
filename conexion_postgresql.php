<?php
$host = "localhost";
$port = "5432";
$dbname = "universidad_nueva_y_diferente";
$user = "postgres";
$password = "1234";

// Cadena de conexión
$conexion = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password");


?>