# Presentación: Tradeoffs de Hadoop (HDFS + MapReduce)

---

## Slide 1 — Problema

Elecciones locales en varias ciudades. Cada ciudad envía un CSV con miles de votos durante el día.

**Objetivo:** contar votos por candidato, por ciudad y determinar el ganador.

**Volumen de este prototipo:** ~29,000 votos (3 ciudades). En producción podrían ser millones.

---

## Slide 2 — Por qué HDFS + MapReduce

| Necesidad | Cómo ayuda Hadoop |
| --- | --- |
| Muchos archivos de entrada | HDFS almacena y distribuye bloques |
| Cómputo paralelo | Varios mappers leen bloques en paralelo |
| Agregación masiva | Reducers suman por clave después del shuffle |
| Tolerancia a fallos | Réplicas en HDFS y reintentos de tareas |

---

## Slide 3 — Tradeoffs

**Ventajas**

- Escala horizontal: más nodos = más capacidad
- Modelo simple: map → shuffle → reduce
- Bueno para batch de gran volumen

**Desventajas**

- Latencia alta (no es streaming en tiempo real)
- Infraestructura pesada (NameNode, DataNode, YARN…)
- Curva de aprendizaje y operación
- Para datasets pequeños, un script Python es más rápido y simple

---

## Slide 4 — Mapper vs Reducer

| Fase | Responsabilidad en este proyecto |
| --- | --- |
| **Mapper** | Lee cada línea CSV y emite `(candidato, 1)` o `(ciudad\|candidato, 1)` |
| **Shuffle/Sort** | Agrupa todas las emisiones con la misma clave |
| **Reducer** | Suma los `1` y produce el total por clave |

---

## Slide 5 — ¿Hadoop o Python simple?

| Escenario | Mejor opción |
| --- | --- |
| Un CSV de 50 MB en un laptop | Script Python / pandas |
| Miles de archivos, TB de datos | Hadoop / Spark |
| Necesitas tolerancia a fallos en cluster | Hadoop |
| Prototipo de clase con datos ficticios | Hadoop local en Docker (educativo) o Python |

**Regla práctica:** si cabe en memoria de una máquina y no necesitas cluster, empieza simple. Si el volumen o el paralelismo obligan a distribuir, Hadoop (o Spark) gana.

---

## Slide 6 — Resultado de este proyecto

```text
Ganador: Ana Torres
Total de votos: 29075

Ana Torres: 15234 votos (52.4%)
Carlos Ruiz: 13841 votos (47.6%)
```

Archivos generados: `candidate_totals.csv`, `city_candidate_totals.csv`, `winner_summary.txt`

---
