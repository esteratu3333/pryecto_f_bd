<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>pagina principal profesor</title>
    <link Rel = >
</head>
<body>
    <?php
    require 'conexion_postgresql.php';
    //consulta
    session_start();
    $cedula = $_SESSION['cedula_profesor'];

    $query8 = "SELECT * from profesor_materia, materias where profesor_materia.id_materia=materias.id_materia and cedula= $1";
    pg_prepare($conexion, "profesor_da_materia", $query8);
    $CONSULTA = pg_execute($conexion, "profesor_da_materia", array($cedula));
    
    
    ?>

        <div class = "borde_botones"id="nav_enlaces">

            <button class = "boton1" id = "id_boton1" type="button">ingresar notas</button>
            <button class = "boton3" id = "id_boton2" type="button">borrar notas</button>

        </div>

    <div id="formulario1" class="form-container" style = "display: none">
        <form method = "post" action = "ingresar_notas.php">
        <select name="id_materia">
            <?php
            pg_result_seek($CONSULTA, 0); 
            while($obj=pg_fetch_object($CONSULTA)){
            ?>
            <option value="<?php echo $obj->id_materia?>"><?php echo $obj->nombre_materia ?></option>
            <?php } ?>
            

        </select>

        <select name="anio">
            <option value="2023">2023</option>
            <option value="2024">2024</option>
            <option value="2025">2025</option>
        </select>

        <select name="semestre">
            <option value="1">1</option>
            <option value="2">2</option>
        </select>

        <input type="submit" value="Enviar">

        </form>
        
        
    </div>






    <div id="formulario2" class="form-container" style = "display: none">
        <form method = "post" action = "borrar_notas.php">
        <select name="id_materia">
            <?php
            pg_result_seek($CONSULTA, 0); 
            while($obj1=pg_fetch_object($CONSULTA)){
            ?>
            <option value="<?php echo $obj1->id_materia?>"><?php echo $obj1->nombre_materia ?></option>
            <?php } ?>
        </select>

        <select name="anio">
            <option value="2023">2023</option>
            <option value="2024">2024</option>
            <option value="2025">2025</option>
        </select>

        <select name="semestre">
            <option value="1">1</option>
            <option value="2">2</option>
        </select>

        <input type="submit" value="Enviar">
        </form>
    </div>

<script src="ingrese_profesor.js"></script>
</body>
</html>