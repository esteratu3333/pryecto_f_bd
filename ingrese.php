<!DOCTYPE html>
<html>

<head>
    <title>principal | estudiante</title>
    <link rel="stylesheet" href="ingrese.css">
    <link rel="stylesheet" href="pagina principal/pagina_principal.css">

</head>

<body>

    <div class="nav_principal" id="nav_principal">

        <div class="nav_titulo" id="nav_titulo">
            <img src="../imagenes/logo.jpeg" alt="logo" class="logo-nav">
            <h2>UNIVERSIDAD NUEVA Y DIFERENTE</h2>
        </div>

        <button class="botonmovil" id="botonmovil">☰</button>

        <ul class="nav_link" id="nav_link">
            <li><button class = "boton1 reset-button-style" id = "id_boton1" type="button">horario</button></li>
            <li><button class = "boton3 reset-button-style" id = "id_boton2" type="button">promedio</button></li>
            <li><button class = "boton4 reset-button-style" id = "id_boton3" type="button">registro de materias</button></li>
            <li><button class = "boton5 reset-button-style" id = "id_boton4" type="button">registro de horario</button></li>
            <li><button class = "boton6 reset-button-style" id = "id_boton5" type="button">cancelacion de materias</button></li>
            <li><button class = "boton7 reset-button-style" id = "id_boton6" type="button">notas por semestre</button></li>
            <button class = "boton8 reset-button-style" id = "id_boton7" type="button">cerrar sesion</button></li>
        </ul>
        

    </div>

   <!--<div id="nav_principal">

        <div class = "borde_botones"id="nav_enlaces">

            <button class = "boton1" id = "id_boton1" type="button">horario</button>
            <button class = "boton3" id = "id_boton2" type="button">promedio</button>
            <button class = "boton4" id = "id_boton3" type="button">registro de materias</button>
            <button class = "boton5" id = "id_boton4" type="button">registro de horario</button>
            <button class = "boton6" id = "id_boton5" type="button">cancelacion de materias</button>
            <button class = "boton7" id = "id_boton6" type="button">notas por semestre</button>
            <button class = "boton8" id = "id_boton7" type="button">cerrar sesion</button>

        </div> 

    </div> -->

    <div class="contenedor-form">

        <div id="formulario1" class="form-container" style = "display: none" >    
        <form action="procesar_formulario.php" method="post">
            <h2>horario</h2>

            <div class="grupoh">
            <div class = "form_group">
            <label for="paises">año</label><br>
            <select id="paises" name="pais_seleccionado">
                <option value="colombia">2023</option>
                <option value="mexico">2024</option>
                <option value="argentina">2025</option>
            </select>
            </div>

            <div class = "form_group">
            <label for="frutas">semestre</label><br>
            <select id="frutas" name="fruta_favorita">
                <option value="manzana">1</option>
                <option value="platano">2</option>
            </select>
            </div>
            </div>
            
    
            <input type="submit" value="Enviar">
        </form>
        </div>

        <div id="formulario2" class="form-container" style = "display: none" >    
        <form action="procesar_formulario.php" method="post">
            <h2>promedio</h2>

            <div class="grupoh">
            <div class = "form_group">
            <label for="paises">año</label><br>
            <select id="paises" name="pais_seleccionado">
                <option value="colombia">2023</option>
                <option value="mexico">2024</option>
                <option value="argentina">2025</option>
            </select>
            </div>

            <div class = "form_group">
            <label for="frutas">semestre</label><br>
            <select id="frutas" name="fruta_favorita">
                <option value="manzana">1</option>
                <option value="platano">2</option>
            </select>
            </div>
            </div>
    
            <input type="submit" value="Enviar">
        </form>
         </div>

        <div id="formulario3" class="form-container" style = "display: none" >    
        <form action="procesar_formulario.php" method="post">
            <h2>registro de materias</h2>

            <div class = "form_group">
            <label for="paises">año</label><br>
            <select id="paises" name="pais_seleccionado">
                <option value="colombia">2023</option>
                <option value="mexico">2024</option>
                <option value="argentina">2025</option>
            </select>
            </div>

            <div class = "form_group">
            <label for="frutas">semestre</label><br>
            <select id="frutas" name="fruta_favorita">
                <option value="manzana">1</option>
                <option value="platano">2</option>
            </select>
            </div>
    
            <input type="submit" value="Enviar">
        </form>
        </div>

        <div id="formulario4" class="form-container" style = "display: none" >    
        <form action="procesar_formulario.php" method="post">
            <h2>registro de horario</h2>

            <div class = "form_group">
            <label for="paises">año</label><br>
            <select id="paises" name="pais_seleccionado">
                <option value="colombia">2023</option>
                <option value="mexico">2024</option>
                <option value="argentina">2025</option>
            </select>
            </div>

            
            <div class = "form_group">
            <label for="frutas">semestre</label><br>
            <select id="frutas" name="fruta_favorita">
                <option value="manzana">1</option>
                <option value="platano">2</option>
            </select>
            </div>
    
            <input type="submit" value="Enviar">
        </form>
        </div>

        <div id="formulario5" class="form-container" style = "display: none" >    
        <form action="procesar_formulario.php" method="post">
            <h2>cancelacion de materias</h2>

            <div class = "form_group">
            <label for="paises">año</label><br>
            <select id="paises" name="pais_seleccionado">
                <option value="colombia">2023</option>
                <option value="mexico">2024</option>
                <option value="argentina">2025</option>
            </select>
            </div>

            <div class = "form_group">
            <label for="frutas">semestre</label><br>
            <select id="frutas" name="fruta_favorita">
                <option value="manzana">1</option>
                <option value="platano">2</option>
            </select>
            </div>
    
            <input type="submit" value="Enviar">
        </form>
         </div>

         <div id="formulario6" name ="notas" class="form-container" style = "display: none" >    
        <form method="post" action="estudiante\semestre_notas.php">
            <h2>notas por semestre</h2>

            <div class = "form_group">
            <label for="encabezado_año">año</label><br>
            <select id="año" name="anio_seleccionado">
                <option value="2023">2023</option>
                <option value="2024">2024</option>
                <option value="2025">2025</option>
            </select>
            </div>

            <div class = "form_group">
            <label for="encabezado_semestre">semestre</label><br>
            <select id="semestre" name="semestre_seleccionado">
                <option value="1">1</option>
                <option value="2">2</option>
            </select>
            </div>
    
            <input type="submit" value="Enviar">
        </form>
        </div>

        <div id="formulario7" class="form-container" style = "display: none" >    
        <form action="procesar_formulario.php" method="post">
            <h2>cerrar sesion</h2>

            <div class = "form_group">
            <label for="paises">año</label><br>
            <select id="paises" name="pais_seleccionado">
                <option value="colombia">2023</option>
                <option value="mexico">2024</option>
                <option value="argentina">2025</option>
            </select>
            </div>
        
            <div class = "form_group">
            <label for="frutas">semestre</label><br>
            <select id="frutas" name="fruta_favorita">
                <option value="manzana">1</option>
                <option value="platano">2</option>
            </select>
            </div>
    
            <input type="submit" value="Enviar">
        </form>
        </div>
    </div>
    <script src="ingrese.js"></script>

   
</body>

</html>