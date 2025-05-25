<?php
$host = "localhost";
$port = "5432";
$dbname = "UND";
$user = "postgres";
$password = "9707";

// Cadena de conexión
$conexion = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password");

// Verifica si hay error
if (!$conexion) {
    echo "❌ Error al conectar a PostgreSQL: " . pg_last_error();
} else {
    echo "✅ Conexión exitosa a PostgreSQL.";
}

?>