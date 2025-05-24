<?php
require 'conexion_postgresql.php';
session_start();

$id_materia = $_POST['id_materia'] ?? null; // Usar null coalescing operator para evitar errores si no están definidos
$anio = $_POST['anio'] ?? null;
$semestre = $_POST['semestre'] ?? null;

// Validar que los parámetros POST estén presentes
if (!$id_materia || !$anio || !$semestre) {
    echo '<p>Por favor, proporcione los datos de la materia, año y semestre.</p>';
    exit();
}

$query = "SELECT estudiante.cedula, nombre, id_materia, actividad, nota, porcentaje from notas_semestre2, estudiante WHERE id_materia = $1 and anio = $2 and semestre = $3 and estudiante.cedula = notas_semestre2.cedula order by estudiante.cedula, actividad"; // Ordenar por actividad para coherencia
pg_prepare($conexion, "registro_nota_profesor", $query);
$resultado = pg_execute($conexion, "registro_nota_profesor", array($id_materia, $anio, $semestre));

$estudiante_agrupado = [];

while ($row = pg_fetch_assoc($resultado)) {
    $cedula_actual = $row['cedula'];

    if (!isset($estudiante_agrupado[$cedula_actual])) {
        $estudiante_agrupado[$cedula_actual] = [
            'cedulaestudiante' => $row['cedula'],
            'nombreestudiante' => $row['nombre'],
            'codigomateria' => $row['id_materia'],
            'evaluaciones' => [],
            'porcentaje_acumulado' => 0 // Nuevo campo para el porcentaje acumulado
        ];
    }

    $estudiante_agrupado[$cedula_actual]['evaluaciones'][] = [
        'actividad' => $row['actividad'],
        'nota' => $row['nota'],
        'porcentaje' => $row['porcentaje']
    ];
    // Sumar el porcentaje a la cuenta acumulada
    $estudiante_agrupado[$cedula_actual]['porcentaje_acumulado'] += (float)$row['porcentaje'];
}

pg_free_result($resultado);

$resultado_output = '';
$resultado_output .= '<form action="guardar_notas.php" method="POST">'; // Asume un archivo guardar_notas.php para procesar el formulario

if (count($estudiante_agrupado) > 0){
    $resultado_output .= '<div style="text-align: center; font-weight: bold; margin-bottom: 15px;">Periodo: ' . htmlspecialchars($anio) .'-'. htmlspecialchars($semestre) . '</div>';

    // Inicio de la tabla principal
    $resultado_output .= '<table border="1" style="width:100%; border-collapse: collapse; margin-top: 20px;">';
    $resultado_output .= '<thead><tr>';
    $resultado_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Cédula</th>';
    $resultado_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Nombre</th>';
    $resultado_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Código Materia</th>';
    $resultado_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Seguimiento</th>';
    $resultado_output .= '</tr></thead>';
    $resultado_output .= '<tbody>';

    foreach ($estudiante_agrupado as $cedula => $data_cedula){
        // El rowspan debe incluir las evaluaciones existentes más la fila para la nueva nota (si es posible)
        $num_evaluaciones_existentes = count($data_cedula['evaluaciones']);
        $rowspan_value = $num_evaluaciones_existentes + 1; // +1 para la fila de nueva nota/mensaje

        $resultado_output .= '<tr>'; // Abre la fila principal del estudiante

        // Columnas principales del estudiante con el atributo rowspan
        $resultado_output .= '<td  style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_cedula["cedulaestudiante"]) . '</td>';
        $resultado_output .= '<td  style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_cedula["nombreestudiante"]) . '</td>';
        $resultado_output .= '<td  style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_cedula["codigomateria"]) . '</td>';
        
        // Celda para la columna "Seguimiento" que contendrá la tabla interna de evaluación.
        // Importante: Esta celda es la única que NO tiene rowspan, ya que su contenido (la tabla interna)
        // se expande verticalmente si es necesario.
        $resultado_output .= '<td style="padding: 0; border: 0; vertical-align: top;">';

        // Tabla interna para evaluaciones
        $resultado_output .= '<table border="1" style="width:100%; border-collapse: collapse; font-size: 0.9em;">';
        $resultado_output .= '<thead><tr>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Evaluación</th>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Nota</th>';
        $resultado_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Porcentaje</th>';
        $resultado_output .= '</tr></thead>';
        $resultado_output .= '<tbody>';

        // Mostrar notas existentes (no editables)
        foreach ($data_cedula['evaluaciones'] as $evaluacion) {
            $resultado_output .= '<tr>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['actividad']) . '</td>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['nota']) . '</td>';
            $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion['porcentaje']) . '%</td>';
            $resultado_output .= '</tr>';
        }

        // Fila para ingresar la NUEVA nota
        $deshabilitar_nuevas_notas = ($data_cedula['porcentaje_acumulado'] >= 100);
        $disabled_attr = $deshabilitar_nuevas_notas ? 'disabled' : '';
        $mensaje_porcentaje = '';
        if ($deshabilitar_nuevas_notas) {
            $mensaje_porcentaje = '<span style="color: red; font-size: 0.8em; margin-left: 5px;">(Porcentaje ya en 100% o más)</span>';
        }

        $resultado_output .= '<tr>';
        $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">';
        $resultado_output .= '<input type="text" name="nueva_actividad['.htmlspecialchars($cedula).']" placeholder="Nueva Evaluación" ' . $disabled_attr . '>';
        $resultado_output .= '</td>';
        $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">';
        $resultado_output .= '<input type="number" step="0.01" name="nueva_nota['.htmlspecialchars($cedula).']" placeholder="Nota" ' . $disabled_attr . '>';
        $resultado_output .= '</td>';
        $resultado_output .= '<td style="padding: 5px; border: 1px solid #eee;">';
        $resultado_output .= '<input type="number" step="0.01" name="nuevo_porcentaje['.htmlspecialchars($cedula).']" placeholder="Porcentaje" ' . $disabled_attr . ' min="0" max="' . (100 - $data_cedula['porcentaje_acumulado']) . '">';
        $resultado_output .= $mensaje_porcentaje;
        $resultado_output .= '</td>';
        $resultado_output .= '</tr>';

        // Campo oculto para pasar la cédula del estudiante en el formulario
        $resultado_output .= '<input type="hidden" name="estudiantes[]" value="'.htmlspecialchars($cedula).'">';

        $resultado_output .= '</tbody></table>';
        $resultado_output .= '</td>'; // Cierra la celda de "Seguimiento"
        $resultado_output .= '</tr>'; // Cierra la fila principal del estudiante
    }
    
    $resultado_output .= '</tbody>';
    $resultado_output .= '<tfoot>'; // Inicio del pie de tabla
    $resultado_output .= '<tr>';
    // El colspan debe ser el número total de columnas de la tabla principal (4)
    $resultado_output .= '<td colspan="4" style="padding: 8px; background-color: #f2f2f2; font-weight: bold; text-align: center;">';
    // Se agregan los campos ocultos para pasar los datos de la materia al script de procesamiento
    $resultado_output .= '<input type="hidden" name="id_materia" value="' . htmlspecialchars($id_materia) . '">';
    $resultado_output .= '<input type="hidden" name="anio" value="' . htmlspecialchars($anio) . '">';
    $resultado_output .= '<input type="hidden" name="semestre" value="' . htmlspecialchars($semestre) . '">';
    $resultado_output .= '<input type="submit" style="padding: 10px 20px; font-size: 1em;" value="Enviar">';
    $resultado_output .= '</td>';
    $resultado_output .= '</tr>';
    $resultado_output .= '</tfoot>';
    $resultado_output .= '</table>'; 

} else {
    $resultado_output .= '<p>No se encontraron estudiantes para la materia, año y semestre especificados.</p>';
}

$resultado_output .= '</form>';

if (isset($conexion) && pg_connection_status($conexion) === PGSQL_CONNECTION_OK) {
    pg_close($conexion);
}

// Envío del HTML generado al cliente (navegador o petición AJAX)
echo $resultado_output;
?>