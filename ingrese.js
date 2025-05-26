document.addEventListener('DOMContentLoaded', function() {
    const botonm = document.getElementById('botonmovil');
    const navlink = document.getElementById('nav_link');

    botonm.addEventListener('click', () => {
     navlink.classList.toggle('active');
    });
    // Selecciona todos los botones
    const botones = document.querySelectorAll('button'); 
    // Selecciona todos los contenedores de formulario que tienen la clase 'form-container'
    const formularios = document.querySelectorAll('.form-container'); 

    // Itera sobre cada botón para añadirle un 'event listener'
    botones.forEach(button => {
        button.addEventListener('click', function() {
            // PRIMER PASO: Ocultar TODOS los formularios
            formularios.forEach(form => {
                form.style.display = 'none'; 
                
                // Establece el estilo 'display' a 'none' para ocultarlos
            });

             const buttonId = this.id; // Ej: "id_boton1"
            
            // Extrae el número del ID del botón (ej: "1" de "id_boton1")
            const formNumber = buttonId.replace('id_boton', ''); 
            
            // Construye el ID del formulario objetivo (ej: "formulario1")
            const targetFormId = `formulario${formNumber}`;     
            
            // Encuentra el formulario específico por su ID
            const formularioAMostrar = document.getElementById(targetFormId);

            // Muestra el formulario si existe
            if (formularioAMostrar) {
                formularioAMostrar.style.display = 'block'; 
            }
        });
    });
});