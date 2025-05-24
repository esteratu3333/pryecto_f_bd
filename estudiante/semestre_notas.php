<?php

// 1. Inclusión de la conexión a la base de datos y inicio de sesión
// Asegúrate de que la ruta a 'conexion_postgresql.php' sea correcta.
// Se asume que 'conexion_postgresql.php' establece la variable $conexion.
require '../conexion_postgresql.php';
session_start(); // Inicia la sesión para acceder a $_SESSION

// 2. Obtención de datos de entrada (Cédula, Año, Semestre)
// Se obtienen de la sesión y del POST, como se ha discutido.
$cedula_estudiante = $_SESSION['cedula'] ?? null;

$anio = $_POST['anio_seleccionado'] ?? null;
$semestre = $_POST['semestre_seleccionado'] ?? null;

// Validación básica de los datos de entrada
if ($cedula_estudiante === null || $anio === null || $semestre === null) {
    // Si faltan datos, se muestra un mensaje de error y se termina la ejecución.
    echo "<p style='color: red;'>Error: Faltan datos para mostrar las notas (Cédula, Año o Semestre no proporcionados).</p>";
    // Es importante cerrar la conexión a la DB si se abre antes del exit.
    if (isset($conexion) && pg_connection_status($conexion) === PGSQL_CONNECTION_OK) {
        pg_close($conexion);
    }
    exit();
}

// 3. Consulta SQL para obtener todos los datos de notas y materias
// Esta es la consulta única que une 'notas_semestre2' y 'materias'
// para obtener todos los campos necesarios. Basada en el diagrama de la base de datos image_c163e8.png.
$sql_query_all_data = "select * from notas_materias_semestre($1, $2, $3) as record(id_materia int, nombre_materia varchar(100), creditos int, actividad varchar(200), nota decimal, porcentaje decimal)
";

// Prepara la consulta para evitar inyección SQL y mejorar rendimiento.
$stmt = pg_prepare($conexion, "get_student_grades", $sql_query_all_data);

// Manejo de errores en la preparación de la consulta
if ($stmt === false) {
    echo "<p style='color: red;'>Error al preparar la consulta: " . pg_last_error($conexion) . "</p>";
    pg_close($conexion);
    exit();
}

// Ejecuta la consulta con los parámetros
$result = pg_execute($conexion, "get_student_grades", [$cedula_estudiante, $anio, $semestre]);

// Manejo de errores en la ejecución de la consulta
if ($result === false) {
    echo "<p style='color: red;'>Error al ejecutar la consulta: " . pg_last_error($conexion) . "</p>";
    pg_close($conexion);
    exit();
}

// 4. Procesamiento de resultados: Agrupar datos por materia en PHP
$materias_agrupadas = []; // Array para almacenar la estructura de datos agrupada

// Itera sobre cada fila del resultado de la consulta
while ($row = pg_fetch_assoc($result)) {
    $id_materia_actual = $row['id_materia']; // Obtiene el ID de la materia de la fila actual

    // Si la materia no ha sido agregada aún a nuestro array de agrupamiento, la inicializamos.
    if (!isset($materias_agrupadas[$id_materia_actual])) {
        $materias_agrupadas[$id_materia_actual] = [
            'codigo_materia' => $row['id_materia'],
            'nombre_materia' => $row['nombre_materia'],
            'creditos' => $row['creditos'],
            'grupo' => 'N/A', // Asume 'N/A' si no tienes un campo 'grupo' en la DB.
                               // Si lo tienes en 'notas_semestre2' o 'materias', agrégalo a la SELECT.
            'evaluaciones' => [], // Este array guardará todas las evaluaciones para esta materia.
            'total_porcentaje_evaluado' => 0, // Acumulador del porcentaje total de las evaluaciones de esta materia.
            'nota_definitiva_calculada' => 0  // Acumulador de la nota definitiva ponderada de esta materia.
        ];
    }

    // Agrega la evaluación actual al array de evaluaciones de la materia correspondiente
    $materias_agrupadas[$id_materia_actual]['evaluaciones'][] = [
        'descripcion_evaluacion' => 'EVALUACIÓN PREGRADO (' . htmlspecialchars($row['actividad']) . ')',
        'nota_obtenida' => $row['nota'],
        'porcentaje_evaluacion' => $row['porcentaje']
    ];

    // Acumula el porcentaje y la nota ponderada para la materia.
    $materias_agrupadas[$id_materia_actual]['total_porcentaje_evaluado'] += $row['porcentaje'];
    // Calcula la contribución de esta evaluación a la nota final de la materia.
    $materias_agrupadas[$id_materia_actual]['nota_definitiva_calculada'] += ($row['nota'] * ($row['porcentaje'] / 100));
}

// Libera la memoria asociada al resultado de la consulta
pg_free_result($result);

// 5. Generación del HTML de la tabla anidada
$html_output = ''; // Variable para construir todo el HTML

// Variables para los totales generales del semestre (para el pie de tabla)
$suma_creditos_total = 0;
$suma_puntos_total_para_promedio_general = 0;

// Si se encontraron materias para el estudiante en el periodo seleccionado
if (count($materias_agrupadas) > 0) {
    $html_output .= '<div style="text-align: center; font-weight: bold; margin-bottom: 15px;">Periodo: ' . htmlspecialchars($anio) .'-'. htmlspecialchars($semestre) . '</div>';

    // Inicio de la tabla principal
    $html_output .= '<table border="1" style="width:100%; border-collapse: collapse; margin-top: 20px;">';
    $html_output .= '<thead><tr>';
    $html_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Materia</th>';
    $html_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Créditos</th>';
    $html_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Grupo</th>';
    $html_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Porcentaje Evaluado</th>';
    $html_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Nota Definitiva - 100%</th>';
    $html_output .= '<th style="padding: 8px; background-color: #e0e0e0; text-align: left;">Seguimiento</th>';
    $html_output .= '</tr></thead>';
    $html_output .= '<tbody>';

    // Bucle principal: Itera sobre cada MATERIA AGRUPADA (cada fila de la tabla principal)
    foreach ($materias_agrupadas as $id_materia => $data_materia) {
        $num_evaluaciones = count($data_materia['evaluaciones']);
        
        // El rowspan es el número de evaluaciones o 1 si no hay evaluaciones (para que la fila no se colapse).
        $rowspan_value = $num_evaluaciones > 0 ? $num_evaluaciones : 1;

        $html_output .= '<tr>'; // Abre la fila principal de la materia

        // Columnas principales de la materia con el atributo rowspan
        // vertical-align: top asegura que el contenido se alinee arriba en la celda
        $html_output .= '<td rowspan="" style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_materia["codigo_materia"]) . ' - ' . htmlspecialchars($data_materia["nombre_materia"]) . '</td>';
        $html_output .= '<td rowspan="" style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_materia["creditos"]) . '</td>';
        $html_output .= '<td rowspan="" style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . htmlspecialchars($data_materia["grupo"]) . '</td>';
        $html_output .= '<td rowspan="" style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . number_format($data_materia["total_porcentaje_evaluado"], 1) . '%</td>';
        $html_output .= '<td rowspan="" style="padding: 8px; border: 1px solid #ddd; vertical-align: top;">' . number_format($data_materia["nota_definitiva_calculada"], 2) . '</td>';
        
        // Celda para la columna "Seguimiento" que contendrá la tabla interna.
        // Importante: ¡Esta celda NO debe tener rowspan!
        // padding: 0 y border: 0 para que la tabla interna se ajuste perfectamente.
        $html_output .= '<td style="padding: 0; border: 0; vertical-align: top;">';

        // Lógica para construir la tabla interna de "Seguimiento"
        if ($num_evaluaciones > 0) {
            $html_output .= '<table border="1" style="width:100%; border-collapse: collapse; font-size: 0.9em;">'; // Inicio de la tabla interna
            $html_output .= '<thead><tr>';
            $html_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Evaluación</th>';
            $html_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Nota</th>';
            $html_output .= '<th style="padding: 5px; background-color: #f9f9f9; text-align: left;">Porcentaje</th>';
            $html_output .= '</tr></thead>';
            $html_output .= '<tbody>';

            // Bucle anidado: Itera sobre las EVALUACIONES de la materia actual
            foreach ($data_materia['evaluaciones'] as $evaluacion) {
                
                $html_output .= '<tr>';
                $html_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion["descripcion_evaluacion"]) . '</td>';
                $html_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion["nota_obtenida"]) . '</td>';
                $html_output .= '<td style="padding: 5px; border: 1px solid #eee;">' . htmlspecialchars($evaluacion["porcentaje_evaluacion"]) . '</td>';
                $html_output .= '</tr>';
            }
            $html_output .= '</tbody></table>'; // Cierre de la tabla interna
        } else {
            // Mensaje si no hay evaluaciones para esta materia
            $html_output .= '<p style="font-size: 0.8em; color: #888; padding: 8px;">No hay evaluaciones registradas para esta materia.</p>';
        }
        
        $html_output .= '</td>'; // Cierra la celda de "Seguimiento"
        $html_output .= '</tr>'; // Cierra la fila principal de la materia

        // Sumar para los totales generales del semestre (para el tfoot)
        $suma_creditos_total += $data_materia['creditos'];
        $suma_puntos_total_para_promedio_general += ($data_materia['nota_definitiva_calculada'] * $data_materia['creditos']);
    }

    $html_output .= '</tbody>';
    $html_output .= '<tfoot>'; // Inicio del pie de tabla
    $html_output .= '<tr>';
    $html_output .= '<td colspan="1" style="padding: 8px; background-color: #f2f2f2; font-weight: bold; text-align: right;">Total Créditos del Semestre:</td>';
    $html_output .= '<td style="padding: 8px; background-color: #f2f2f2; font-weight: bold;">' . htmlspecialchars($suma_creditos_total) . '</td>';
    $html_output .= '<td colspan="3" style="padding: 8px; background-color: #f2f2f2; font-weight: bold; text-align: right;">Promedio General del Semestre:</td>';
    $html_output .= '<td style="padding: 8px; background-color: #f2f2f2; font-weight: bold;">';
    if ($suma_creditos_total > 0) {
        $promedio_general = $suma_puntos_total_para_promedio_general / $suma_creditos_total;
        $html_output .= number_format($promedio_general, 2);
    } else {
        $html_output .= '0.00';
    }
    $html_output .= '</td>';
    $html_output .= '</tr>';
    $html_output .= '</tfoot>';
    $html_output .= '</table>'; // Cierre de la tabla principal
} else {
    // Mensaje si no se encontraron notas para el estudiante en el periodo
    $html_output .= "<p>No se encontraron notas para el estudiante con cédula " . htmlspecialchars($cedula_estudiante) . " en el Año: " . htmlspecialchars($anio) . " y Semestre: " . htmlspecialchars($semestre) . ".</p>";
}

// 6. Cierre de la conexión a la base de datos
if (isset($conexion) && pg_connection_status($conexion) === PGSQL_CONNECTION_OK) {
    pg_close($conexion);
}

// 7. Envío del HTML generado al cliente (navegador o petición AJAX)
echo $html_output;

?>








