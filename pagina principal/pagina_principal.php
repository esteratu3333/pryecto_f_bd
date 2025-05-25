<!DOCTYPE html>
<html>

<head>
    <title>LOGIN</title>
    <link rel="stylesheet" href="pagina_principal.css">
</head>

<body>

    <div class="nav_principal" id="nav_principal">

        <div class="nav_titulo" id="nav_titulo">
            <img src="../imagenes/logo.jpeg" alt="logo" class="logo-nav">
            <h2>UNIVERSIDAD NUEVA Y DIFERENTE</h2>
        </div>

        <button class="botonmovil" id="botonmovil">☰</button>

        <ul class="nav_link" id="nav_link">
            <li><a href="../login.php">login administrador</a> </li>
            <li><a href="../login.php">login profesor</a> </li>
            <li><a href="../login.php">login estudiante</a> </li>
        </ul>
        

    </div>

    <article>
        <table>
            
            <thead>
                <tr>
                    <th>Estudiantes</th>
                    
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><a href="https://login.microsoftonline.com/" target="_blank">Correo institucional</a></td>
                    
                </tr>
                
            </tbody>
        </table>
        
        <img id="img-fondo" src="../imagenes/fondo.jpeg" alt="">

        

    </article>
    
<script>
    
    const botonm = document.getElementById('botonmovil');
    const navlink = document.getElementById('nav_link');

    botonm.addEventListener('click', () => {
     navlink.classList.toggle('active');
    });

  </script>
</body>

</html>