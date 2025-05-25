<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login de Usuarios</title>
    <link rel="stylesheet" href="login.css">
</head>
<body>

    <div class="login_container">
       
        <h2 >INICIAR SESION</h2>
            
        <form method="POST" action="./verificar_login.php">

            <div class = "form_group">

                <label >correo electronico </label>
                 <input class="gmail" type="text" name="user" placeholder = "Gmail">
                
            </div>

            <div class = "form_group">
                <label >contraseña </label>
                <input class="contraseña" type="password" name="pass" placeholder = "Contraseña" ><br><br>
            </div>

                    
            <button class="boton" type="submit" class = "boton-estilo"> INGRESAR</button>

        </form>
    </div>
</body>
</html>