<?php
require 'conexion_postgresql.php';
session_start();

// Recopilar los datos de la materia, año y semestre para la consulta inicial
$id_materia = $_POST['id_materia'] ?? null;
$anio = $_POST['anio'] ?? null;
$semestre = $_POST['semestre'] ?? null;

// Validar que los parámetros POST estén presentes para la carga INICIAL de la tabla
if (!$id_materia || !$anio || !$semestre) {
    echo '<p>Por favor, seleccione una materia, año y semestre para ver las notas.</p>';
    exit();
}

// --- Lógica para MANEJAR EL ENVÍO DEL FORMULARIO DE INSERCIÓN ---
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['estudiantes'])) {
    $insert_cedulas = $_POST['estudiantes'] ?? [];
    $insert_actividades = $_POST['nueva_actividad'] ?? [];
    $insert_notas = $_POST['nueva_nota'] ?? [];
    $insert_porcentajes = $_POST['nuevo_porcentaje'] ?? [];

    $form_id_materia = $_POST['id_materia'] ?? null;
    $form_anio = $_POST['anio'] ?? null;
    $form_semestre = $_POST['semestre'] ?? null;

    if ($form_id_materia && $form_anio && $form_semestre) {
        pg_query($conexion, "BEGIN");
        $transaction_successful = true;
        $notas_insertadas_count = 0;

        try {
            // --- Paso adicional: Preparar consulta para contar notas existentes ---
            $count_query = "SELECT * from contador_notas_por_materia($1, $2, $3, $4) as record(contador bigint)";
            pg_prepare($conexion, "count_notes", $count_query);

            // Preparar la sentencia de inserción ahora con la nueva columna
            $insert_query = "INSERT INTO notas_semestre2 (cedula, id_materia, anio, semestre, actividad, nota, porcentaje, nota_por_materia)
                             VALUES ($1, $2, $3, $4, $5, $6, $7, $8)"; // Ahora son 8 parámetros
            
            pg_prepare($conexion, "insert_new_note", $insert_query);

            foreach ($insert_cedulas as $cedula) {
                if (isset($insert_actividades[$cedula]) && !empty(trim($insert_actividades[$cedula]))) {
                    $actividad = trim($insert_actividades[$cedula]);
                    $nota = $insert_notas[$cedula];
                    $porcentaje = $insert_porcentajes[$cedula];

                    if (!empty($actividad) && is_numeric($nota) && is_numeric($porcentaje)) {
                        // --- Calcular el número de evaluación (nota_por_materia) ---
                        $count_result = pg_execute($conexion, "count_notes", array($cedula, $form_id_materia, $form_anio, $form_semestre));
                        if ($count_result === false) {
                            throw new Exception("Error al contar notas existentes para cédula: " . htmlspecialchars($cedula) . " - " . pg_last_error($conexion));
                        }
                        $row_count = pg_fetch_row($count_result);
                        pg_free_result($count_result); // Liberar el resultado de la cuenta

                        $next_note_number = (int)$row_count[0] + 1; // El número de la siguiente nota

                        // Ejecutar la sentencia preparada con el nuevo parámetro
                        $result = pg_execute($conexion, "insert_new_note", array(
                            $cedula,
                            $form_id_materia,
                            $form_anio,
                            $form_semestre,
                            $actividad,
                            (float)$nota,
                            (float)$porcentaje,
                            $next_note_number // ¡Aquí va el nuevo valor!
                        ));

                        if ($result === false) {
                            $transaction_successful = false;
                            throw new Exception("Error al insertar nota para cédula: " . htmlspecialchars($cedula) . " - " . pg_last_error($conexion));
                        }
                        $notas_insertadas_count++;
                    }
                }
            }

            if ($transaction_successful) {
                pg_query($conexion, "COMMIT");
                echo '<p style="color: green;">¡' . $notas_insertadas_count . ' nuevas notas insertadas exitosamente!</p>';
                header("Location: ingrese_profesor.php?id_materia=" . urlencode($form_id_materia) . "&anio=" . urlencode($form_anio) . "&semestre=" . urlencode($form_semestre));
                exit();
            } else {
                pg_query($conexion, "ROLLBACK");
                echo '<p style="color: red;">No se pudieron insertar todas las notas. Se revirtieron los cambios.</p>';
            }

        } catch (Exception $e) {
            pg_query($conexion, "ROLLBACK");
            echo '<p style="color: red;">Error al guardar las notas: ' . $e->getMessage() . '</p>';
        }
    } else {
        echo '<p style="color: red;">Error: Datos de materia, año o semestre no recibidos correctamente al procesar el formulario.</p>';
    }
}
// --- FIN de la lógica de MANEJO DEL FORMULARIO ---


// --- Lógica para OBTENER Y MOSTRAR LAS NOTAS EXISTENTES ---
// OJO: Si quieres mostrar la columna 'nota_por_materia' también aquí, añádela a la consulta SELECT
$query_select = "SELECT * from notas_por_materias($1, $2, $3) AS record(
    cedula INT,
    nombre VARCHAR(100), -- Asegúrate que el tipo de nombre coincida con tu tabla 'estudiante'
    id_materia INT,
    actividad VARCHAR(200), -- Asegúrate que el tipo de actividad coincida con tu tabla 'notas_semestre2'
    nota DECIMAL,
    porcentaje DECIMAL,
    nota_por_materia INT,
    id INT -- ¡Asegúrate que el tipo de ID coincida!
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
        'nota_por_materia' => $row['nota_por_materia'] // Incluir el nuevo campo si lo necesitas para mostrar
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
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Eval. No.</th>'; // Nueva columna para el número de evaluación
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Actividad</th>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Nota</th>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Porcentaje</th>';
        $resultado_output .= '</tr></thead>';
        $resultado_output .= '<tbody>';

        // Mostrar notas existentes (no editables)
        foreach ($data_cedula['evaluaciones'] as $evaluacion) {
            $resultado_output .= '<tr>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['nota_por_materia']) . '</td>'; // Mostrar el número
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['actividad']) . '</td>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['nota']) . '</td>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['porcentaje']) . '%</td>';
            $resultado_output .= '</tr>';
        }

        // Fila para ingresar la NUEVA nota
        $porcentaje_restante = 100 - $data_cedula['porcentaje_acumulado'];
        $deshabilitar_nuevas_notas = ($porcentaje_restante <= 0);
        $disabled_attr = $deshabilitar_nuevas_notas ? 'disabled' : '';
        $mensaje_porcentaje = '';
        if ($deshabilitar_nuevas_notas) {
            $mensaje_porcentaje = '<span style="color: red; font-size: 0.8em; margin-left: 5px;">(Porcentaje de notas completo)</span>';
        }

        $resultado_output .= '<tr>';
        $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">(Nueva)</td>'; // Indicador para la nueva nota
        $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">';
        $resultado_output .= '<input type="text" name="nueva_actividad['.htmlspecialchars($cedula).']" placeholder="Nueva Evaluación" ' . $disabled_attr . '>';
        $resultado_output .= '</td>';
        $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">';
        $resultado_output .= '<input type="number" step="0.01" name="nueva_nota['.htmlspecialchars($cedula).']" placeholder="Nota" ' . $disabled_attr . ' min="0" max="5" >';
        $resultado_output .= '</td>';
        $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">';
        $resultado_output .= '<input type="number" step="0.01" name="nuevo_porcentaje['.htmlspecialchars($cedula).']" placeholder="Porcentaje" ' . $disabled_attr . ' min="0" max="' . max(0, $porcentaje_restante) . '">';
        $resultado_output .= $mensaje_porcentaje;
        $resultado_output .= '</td>';
        $resultado_output .= '</tr>';

        $resultado_output .= '<input type="hidden" name="estudiantes[]" value="'.htmlspecialchars($cedula).'">';

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
    $resultado_output .= '<input type="submit" style="padding: 10px 20px; font-size: 1em;" value="Guardar Notas">';
    $resultado_output .= '</td>';
    $resultado_output .= '</tr>';
    $resultado_output .= '</tfoot>';
    $resultado_output .= '</table>'; 

} else {
    $resultado_output .= '<p>No se encontraron estudiantes para la materia, año y semestre especificados.</p>';
}

$resultado_output .= '</form>';


echo $resultado_output;

if (isset($conexion) && pg_connection_status($conexion) === PGSQL_CONNECTION_OK) {
    pg_close($conexion);
}


?>