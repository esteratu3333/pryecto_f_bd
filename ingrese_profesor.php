<?php
session_start();
$cedula_profesor=$_SESSION['cedula_profesor'];
echo "<h1>bienvenido $cedula_profesor</h1>";
?>