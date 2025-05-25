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
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['notas_a_borrar'])) {
    $notas_a_borrar = $_POST['notas_a_borrar'] ?? [];

    $form_id_materia = $_POST['id_materia'] ?? null;
    $form_anio = $_POST['anio'] ?? null;
    $form_semestre = $_POST['semestre'] ?? null;

    if ($form_id_materia && $form_anio && $form_semestre && !empty($notas_a_borrar)) {
        pg_query($conexion, "BEGIN"); // Iniciar transacción
        $transaction_successful = true;
        $notas_eliminadas_count = 0;

        try {
            // Preparar la sentencia de eliminación
            // Usamos cedula, id_materia, anio, semestre y nota_por_materia para identificar la nota de forma única.
            $delete_query = "DELETE FROM notas_semestre2 WHERE cedula = $1 AND id_materia = $2 AND anio = $3 AND semestre = $4 AND nota_por_materia = $5";
            pg_prepare($conexion, "delete_note", $delete_query);

            foreach ($notas_a_borrar as $key) {
                // $key contendrá un string como "cedula|actividad|nota_por_materia"
                list($cedula_del, $nota_por_materia_del) = explode('|', $key);

                if (is_numeric($cedula_del) && is_numeric($nota_por_materia_del)) {
                    $result = pg_execute($conexion, "delete_note", array(
                        $cedula_del,
                        $form_id_materia,
                        $form_anio,
                        $form_semestre,
                        (int)$nota_por_materia_del
                    ));

                    if ($result === false) {
                        $transaction_successful = false;
                        throw new Exception("Error al eliminar nota para cédula: " . htmlspecialchars($cedula_del) . " (Evaluación No. " . htmlspecialchars($nota_por_materia_del) . ") - " . pg_last_error($conexion));
                    }
                    $notas_eliminadas_count++;
                }
            }

            if ($transaction_successful) {
                pg_query($conexion, "COMMIT"); // Confirmar transacción
                echo '<p style="color: green;">¡' . $notas_eliminadas_count . ' notas eliminadas exitosamente!</p>';
                // Redirigir para refrescar la tabla sin los parámetros POST del formulario de eliminación
                header("Location: " . htmlspecialchars($_SERVER['PHP_SELF']) . "?id_materia=" . urlencode($form_id_materia) . "&anio=" . urlencode($form_anio) . "&semestre=" . urlencode($form_semestre));
                exit();
            } else {
                pg_query($conexion, "ROLLBACK"); // Revertir transacción
                echo '<p style="color: red;">No se pudieron eliminar todas las notas. Se revirtieron los cambios.</p>';
            }

        } catch (Exception $e) {
            pg_query($conexion, "ROLLBACK"); // Revertir transacción en caso de error
            echo '<p style="color: red;">Error al eliminar las notas: ' . $e->getMessage() . '</p>';
        }
    } else {
        echo '<p style="color: red;">Error: No se seleccionaron notas para eliminar o datos incompletos.</p>';
    }
}
// --- FIN de la lógica de MANEJO DEL FORMULARIO DE ELIMINACIÓN ---


// --- Lógica para OBTENER Y MOSTRAR LAS NOTAS EXISTENTES ---
// Asegúrate de que tu función 'notas_por_materias' o la consulta SELECT devuelva 'nota_por_materia'
$query_select = "SELECT * from notas_por_materias($1, $2, $3)as record(cedula int, nombre varchar(100), id_materia int, actividad varchar(200), nota decimal, porcentaje decimal, nota_por_materia int);";

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
        'nota_por_materia' => $row['nota_por_materia'] // Campo crucial para identificar la nota a borrar
    ];
    $estudiante_agrupado[$cedula_actual]['porcentaje_acumulado'] += (float)$row['porcentaje'];
}

pg_free_result($resultado);

$resultado_output = '';
$resultado_output .= '<form action="' . htmlspecialchars($_SERVER['PHP_SELF']) . '" method="POST">';

if (count($estudiante_agrupado) > 0){
    $resultado_output .= '<div style="text-align: center; font-weight: bold; margin-bottom: 15px;">Periodo: ' . htmlspecialchars($anio) .'-'. htmlspecialchars($semestre) . '</div>';

    $resultado_output .= '<table border="1" style="width:100%; border-collapse: collapse; margin-top: 20px;">';
    $resultado_output .= '<thead><tr>';
    $resultado_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Cédula</th>';
    $resultado_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Nombre</th>';
    $resultado_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Código Materia</th>';
    $resultado_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Seguimiento</th>';
    $resultado_output .= '</tr></thead>';
    $resultado_output .= '<tbody>';

    foreach ($estudiante_agrupado as $cedula => $data_cedula){
        $resultado_output .= '<tr>';
        $resultado_output .= '<td style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_cedula["cedulaestudiante"]) . '</td>';
        $resultado_output .= '<td style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_cedula["nombreestudiante"]) . '</td>';
        $resultado_output .= '<td style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_cedula["codigomateria"]) . '</td>';
        
        $resultado_output .= '<td style="padding: 0; border: 0; vertical-align: top;">';

        $resultado_output .= '<table border="1" style="width:100%; border-collapse: collapse; font-size: 0.9em;">';
        $resultado_output .= '<thead><tr>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Eval. No.</th>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Actividad</th>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Nota</th>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Porcentaje</th>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: center;">Eliminar</th>'; // Columna para el checkbox de eliminar
        $resultado_output .= '</tr></thead>';
        $resultado_output .= '<tbody>';

        // Mostrar notas existentes con un checkbox para eliminar
        foreach ($data_cedula['evaluaciones'] as $evaluacion) {
            $resultado_output .= '<tr>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['nota_por_materia']) . '</td>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['actividad']) . '</td>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['nota']) . '</td>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['porcentaje']) . '%</td>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee; text-align: center;">';
            // Valor del checkbox: cedula|nota_por_materia para identificar la nota única
            $checkbox_value = htmlspecialchars($cedula) . '|' . htmlspecialchars($evaluacion['nota_por_materia']);
            $resultado_output .= '<input type="checkbox" name="notas_a_borrar[]" value="' . $checkbox_value . '">';
            $resultado_output .= '</td>';
            $resultado_output .= '</tr>';
        }
        $resultado_output .= '</tbody></table>';
        $resultado_output .= '</td>';
        $resultado_output .= '</tr>';
    }
    
    $resultado_output .= '</tbody>';
    $resultado_output .= '<tfoot>';
    $resultado_output .= '<tr>';
    $resultado_output .= '<td colspan="4" style="padding: 8px; background-color: #f2f2f2; font-weight: bold; text-align: center;">';
    $resultado_output .= '<input type="hidden" name="id_materia" value="' . htmlspecialchars($id_materia) . '">';
    $resultado_output .= '<input type="hidden" name="anio" value="' . htmlspecialchars($anio) . '">';
    $resultado_output .= '<input type="hidden" name="semestre" value="' . htmlspecialchars($semestre) . '">';
    $resultado_output .= '<input type="submit" style="padding: 10px 20px; font-size: 1em; background-color: #dc3545; color: white; border: none; cursor: pointer;" value="Eliminar Notas Seleccionadas">';
    $resultado_output .= '</td>';
    $resultado_output .= '</tr>';
    $resultado_output .= '</tfoot>';
    $resultado_output .= '</table>'; 

} else {
    $resultado_output .= '<p>No se encontraron estudiantes o notas para la materia, año y semestre especificados.</p>';
}

$resultado_output .= '</form>';


echo $resultado_output;

if (isset($conexion) && pg_connection_status($conexion) === PGSQL_CONNECTION_OK) {
    pg_close($conexion);
}

?>