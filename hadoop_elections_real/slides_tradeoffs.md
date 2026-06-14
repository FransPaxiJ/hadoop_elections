# Presentación corta: Tradeoffs de Hadoop con datos ONPE

---

## Problema y dataset

- Caso real: resultados presidenciales Perú 2021 (primera vuelta)
- Fuente: ONPE en datos abiertos
- Archivo base: `presidencial-resultados-partidos.csv`
- Granularidad: distrito x candidato/partido

**Objetivo del proyecto:**

- Contar votos totales por candidato
- Contar votos por departamento y candidato
- Generar reporte final con ganador y porcentajes

---

## Diseño de solución

- HDFS para almacenamiento distribuido de entrada y salida
- MapReduce Streaming para agregaciones por clave
- Reducer de suma para consolidar `total_votos`
- Exportación de resultados a CSV + salida de consola

Flujo: ONPE CSV -> normalización -> HDFS -> map -> shuffle/sort -> reduce -> reporte final

---

## Mapper y Reducer en este caso

- Mapper nacional: emite `(candidato, total_votos)`
- Mapper por región: emite `(departamento|candidato, total_votos)`
- Shuffle/Sort: agrupa todas las filas de la misma clave
- Reducer: suma votos por clave

**Nota importante:** el dataset ONPE es agregado; no se cuenta `1` por fila.

---

## Tradeoffs de la tecnología

**Ventajas**

- Escala horizontal para volúmenes grandes
- Tolerancia a fallos en procesamiento batch
- Patrón claro para agregaciones masivas

**Desventajas**

- Mayor complejidad operativa que un script local
- Más latencia y overhead para datasets pequeños
- Debugging más costoso que pandas puro

---

## ¿Cuándo Hadoop vs Python?

Hadoop conviene cuando:

- Los datos son muy grandes para una sola máquina
- Se necesita procesamiento distribuido y robusto
- El pipeline debe escalar en clúster

Python/pandas conviene cuando:

- El dataset cabe en memoria local
- Se busca rapidez de desarrollo y simplicidad

---

## Resultado final del proyecto

Entregables generados:

- `output/candidate_totals.csv`
- `output/department_candidate_totals.csv`
- `output/winner_summary.txt`

Salida final visible en notebook/console:

- Ganador nacional
- Total de votos agregados
- Top candidatos con porcentaje

---

## Conclusión

Este proyecto muestra que Hadoop sigue siendo útil para enseñar arquitectura distribuida, incluso cuando el caso de estudio puede correrse localmente: el valor está en el diseño escalable y en separar almacenamiento distribuido (HDFS) de cómputo distribuido (MapReduce).
