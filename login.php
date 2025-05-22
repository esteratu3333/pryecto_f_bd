<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login de Usuarios</title>
    <link Rel = StyleSheet href="login.css" type="text/css">
</head>
<body>
    <div class="container">
        <div class="text-center caja-login" style="background-color: #aaa;">
            <p class = "formulario_login_fuente_cabecera">universidad nueva y diferente</p>
            <div class = formulario_login>
                <form method="POST" action="./verificar_login.php">

                    <div class="formulario_login_cabecera">
                        <p class ="formulario_login_cabecera">Iniciar sesion</p>
                    </div>

                    <div class = "login_gmail">
                        <p class ="frase_gmail">Escribir gmail </p>
                        <input class="gmail" type="text" name="user" placeholder = "Gmail">
                        <br><br>
                    </div>

                    <div class = "login_contraseña">
                        <p class ="frase_contraseña">Escribir contraseña </p>
                        <input class="contraseña" type="password" name="pass" placeholder = "Contraseña" ><br><br>
                    </div>

                    <div class = "login_boton">
                        <button class="boton" type="submit" class = "boton-estilo"> Ingresar</button>
                    </div>

                </form>
            </div>
        </div>
    </div>
</body>
</html>