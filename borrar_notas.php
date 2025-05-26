<?php
require 'conexion_postgresql.php';
session_start();

// Recopilar los datos de la materia, año y semestre para la consulta inicial
$id_materia = $_POST['id_materia'] ?? null;
$anio = $_POST['anio'] ?? null;
$semestre = $_POST['semestre'] ?? null;

// Validar que los parámetros POST estén presentes para la carga INICIAL de la tabla
if (!$id_materia || !$anio || !$semestre) {
    echo '<p>Por favor, seleccione una materia, año y semestre para gestionar las notas.</p>';
    exit();
}

// --- Lógica para MANEJAR EL ENVÍO DEL FORMULARIO DE ELIMINACIÓN ---
// ESTE BLOQUE DEBE ESTAR AL PRINCIPIO DEL ARCHIVO, ANTES DE CUALQUIER SALIDA HTML.
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['notas_a_borrar'])) {
    $notas_a_borrar = $_POST['notas_a_borrar'] ?? [];

    $form_id_materia = $_POST['id_materia'] ?? null;
    $form_anio = $_POST['anio'] ?? null;
    $form_semestre = $_POST['semestre'] ?? null;

    if ($form_id_materia && $form_anio && $form_semestre && !empty($notas_a_borrar)) {
        pg_query($conexion, "BEGIN"); // Iniciar transacción
        $transaction_successful = true;

        try {
            $delete_query = "DELETE FROM notas_semestre2 WHERE id = $1";
            pg_prepare($conexion, "delete_note", $delete_query);

            foreach ($notas_a_borrar as $key) {
                $id_del = intval($key);

                if ($id_del > 0) {
                    $result = pg_execute($conexion, "delete_note", array($id_del));

                    if ($result === false) {
                        $transaction_successful = false;
                        // En un escenario simple, podrías no lanzar una excepción y simplemente romper el bucle.
                        // Para este ejemplo, si queremos salir rápido en error, mantenemos la excepción.
                        throw new Exception("Error al eliminar nota con ID: " . htmlspecialchars($id_del));
                    }
                }
            }

            if ($transaction_successful) {
                pg_query($conexion, "COMMIT"); // Confirmar transacción

                // === AQUÍ VA LA REDIRECCIÓN SIMPLE ===
                // Cambia 'tu_pagina_de_destino.php' por la URL a la que quieres ir
                // Asegúrate de que no haya NINGÚN echo, print, o HTML antes de esta línea
                header('Location: ingrese_profesor.php');
                exit(); // IMPORTANTE: Siempre llama a exit() después de header()
            } else {
                pg_query($conexion, "ROLLBACK"); // Revertir transacción
                // Si llegamos aquí sin una excepción, algo salió mal
                // Podrías redirigir a una página de error o mostrar un mensaje básico aquí
                // Para el ejemplo simple, si hay un error, el script continuará o se detendrá en el catch.
            }

        } catch (Exception $e) {
            pg_query($conexion, "ROLLBACK"); // Revertir transacción en caso de error
            // Si hay un error, podrías redirigir a una página de error genérica
            // header('Location: pagina_de_error_generico.php');
            // exit();
            // O simplemente mostrar un mensaje simple y dejar que el script continúe mostrando la página actual
            echo '<p style="color: red;">Ocurrió un error en la base de datos.</p>';
        }
    } else {
        // No se seleccionaron notas o datos POST incompletos
        // Podrías redirigir a una página de error básica o simplemente mostrar un mensaje
        // header('Location: pagina_de_error_generico.php');
        // exit();
        echo '<p style="color: red;">No se seleccionaron notas para eliminar o datos incompletos.</p>';
    }
}
// --- FIN de la lógica de MANEJO DEL FORMULARIO DE ELIMINACIÓN ---

// A partir de aquí, el código maneja la visualización de la tabla.
// Esto se mostrará si la redirección no ocurrió.

// Recopilar los datos de la materia, año y semestre para la consulta inicial o después de redirección
$id_materia = $_POST['id_materia'] ?? $_GET['id_materia'] ?? null;
$anio = $_POST['anio'] ?? $_GET['anio'] ?? null;
$semestre = $_POST['semestre'] ?? $_GET['semestre'] ?? null;

// Validar que los parámetros estén presentes para la carga de la tabla
if (!$id_materia || !$anio || !$semestre) {
    echo '<p>Por favor, seleccione una materia, año y semestre para gestionar las notas.</p>';
    exit();
}

// Resto de tu código PHP y HTML para mostrar la tabla...
// ... (Toda la parte de consulta y generación de HTML) ...

// --- Lógica para OBTENER Y MOSTRAR LAS NOTAS EXISTENTES ---
$query_select = "SELECT * from notas_por_materias($1, $2, $3) AS record(
    cedula INT,
    nombre VARCHAR(100),
    id_materia INT,
    actividad VARCHAR(200),
    nota DECIMAL,
    porcentaje DECIMAL,
    nota_por_materia INT,
    id INT
);";

pg_prepare($conexion, "registro_nota_profesor_select", $query_select);
$resultado = pg_execute($conexion, "registro_nota_profesor_select", array($id_materia, $anio, $semestre));

$estudiante_agrupado = [];

while ($row = pg_fetch_assoc($resultado)) {
    $cedula_actual = $row['cedula'];

    if (!isset($estudiante_agrupado[$cedula_actual])) {
        $estudiante_agrupado[$cedula_actual] = [
            'cedulaestudiante' => $row['cedula'],
            'nombreestudiante' => $row['nombre'],
            'codigomateria' => $row['id_materia'],
            'evaluaciones' => [],
            'porcentaje_acumulado' => 0
        ];
    }

    $estudiante_agrupado[$cedula_actual]['evaluaciones'][] = [
        'actividad' => $row['actividad'],
        'nota' => $row['nota'],
        'porcentaje' => $row['porcentaje'],
        'nota_por_materia' => $row['nota_por_materia'],
        'id' => $row['id']
    ];
    $estudiante_agrupado[$cedula_actual]['porcentaje_acumulado'] += (float)$row['porcentaje'];
}

pg_free_result($resultado);

// Aquí comienza la salida HTML
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Notas</title>
    <style>
        /* Tus estilos CSS aquí */
        table { width:100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 8px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #e0e0e0; }
        .success-message { color: green; font-weight: bold; text-align: center; margin-bottom: 10px;}
        .error-message { color: red; font-weight: bold; text-align: center; margin-bottom: 10px;}
    </style>
</head>
<body>

<?php
// Si el script no redirigió (por ejemplo, si hubo un error y no se redirigió, o si la página se cargó normalmente)
// Este es un buen lugar para mostrar mensajes de error simples si decidiste no redirigir en caso de error.
// Por ahora, como el ejemplo es simple, no hay un GET 'mensaje' o 'error' desde la redirección.
?>

<?php
echo '<form action="' . htmlspecialchars($_SERVER['PHP_SELF']) . '" method="POST">';

if (count($estudiante_agrupado) > 0){
    echo '<div style="text-align: center; font-weight: bold; margin-bottom: 15px;">Periodo: ' . htmlspecialchars($anio) .'-'. htmlspecialchars($semestre) . '</div>';

    echo '<table border="1" style="width:100%; border-collapse: collapse; margin-top: 20px;">';
    echo '<thead><tr>';
    echo '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Cédula</th>';
    echo '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Nombre</th>';
    echo '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Código Materia</th>';
    echo '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Seguimiento</th>';
    echo '</tr></thead>';
    echo '<tbody>';

    foreach ($estudiante_agrupado as $cedula => $data_cedula){
        echo '<tr>';
        echo '<td style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_cedula["cedulaestudiante"]) . '</td>';
        echo '<td style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_cedula["nombreestudiante"]) . '</td>';
        echo '<td style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_cedula["codigomateria"]) . '</td>';

        echo '<td style="padding: 0; border: 0; vertical-align: top;">';

        echo '<table border="1" style="width:100%; border-collapse: collapse; font-size: 0.9em;">';
        echo '<thead><tr>';
        echo '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Eval. No.</th>';
        echo '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Actividad</th>';
        echo '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Nota</th>';
        echo '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Porcentaje</th>';
        echo '<th style="padding: 5px; background-color: #f9f9f9; text-align: center;">Eliminar</th>';
        echo '</tr></thead>';
        echo '<tbody>';

        foreach ($data_cedula['evaluaciones'] as $evaluacion) {
            echo '<tr>';
            echo '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['nota_por_materia']) . '</td>';
            echo '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['actividad']) . '</td>';
            echo '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['nota']) . '</td>';
            echo '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['porcentaje']) . '%</td>';
            echo '<td style="padding: 5px; border: 1px solid #eee; text-align: center;">';
            $checkbox_value = htmlspecialchars($evaluacion['id']);
            echo '<input type="checkbox" name="notas_a_borrar[]" value="' . $checkbox_value . '">';
            echo '</td>';
            echo '</tr>';
        }
        echo '</tbody></table>';
        echo '</td>';
        echo '</tr>';
    }

    echo '</tbody>';
    echo '<tfoot>';
    echo '<tr>';
    echo '<td colspan="4" style="padding: 8px; background-color: #f2f2f2; font-weight: bold; text-align: center;">';
    echo '<input type="hidden" name="id_materia" value="' . htmlspecialchars($id_materia) . '">';
    echo '<input type="hidden" name="anio" value="' . htmlspecialchars($anio) . '">';
    echo '<input type="hidden" name="semestre" value="' . htmlspecialchars($semestre) . '">';
    echo '<input type="submit" style="padding: 10px 20px; font-size: 1em; background-color: #dc3545; color: white; border: none; cursor: pointer;" value="Eliminar Notas Seleccionadas">';
    echo '</td>';
    echo '</tr>';
    echo '</tfoot>';
    echo '</table>';

} else {
    echo '<p>No se encontraron estudiantes o notas para la materia, año y semestre especificados.</p>';
}

echo '</form>';


if (isset($conexion) && pg_connection_status($conexion) === PGSQL_CONNECTION_OK) {
    pg_close($conexion);
}
?>
</body>
</html>
