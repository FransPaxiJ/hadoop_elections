# Proyecto Hadoop: Elecciones Presidenciales Perú 2021 (ONPE)

Proyecto local con **HDFS + MapReduce (Hadoop Streaming)** usando datos reales de ONPE:

- Archivo: `data/raw_votes/presidencial-resultados-partidos.csv`
- Fuente: [Datos Abiertos - ONPE](https://www.datosabiertos.gob.pe/dataset/resultados-por-mesa-de-las-elecciones-presidenciales-2021-primera-vuelta-oficina-nacional-de)
- Contexto: Primera vuelta presidencial 2021, resultados agregados por distrito y partido/candidato.

## Entregables cubiertos

- Diagrama de diseño del sistema (en notebook y README)
- Prototipo local con Docker + Hadoop
- README de ejecución
- Presentación corta de tradeoffs (`slides_tradeoffs.md`)
- Resultado final en consola + archivos en `output/`

## Estructura

```text
hadoop_elections_real/
├── docker-compose.yml
├── hadoop.env
├── proyecto_hadoop_votos.ipynb
├── mapreduce/
│   ├── mapper_candidate.sh
│   ├── mapper_city_candidate.sh
│   └── reducer_count.sh
├── data/raw_votes/
│   ├── presidencial-resultados-partidos.csv
│   └── onpe_normalized_votes.csv         # se genera desde el notebook
├── output/
│   ├── candidate_totals.csv
│   ├── department_candidate_totals.csv
│   └── winner_summary.txt
└── slides_tradeoffs.md
```

## Cómo ejecutar

### 1) Ir al proyecto

```bash
cd hadoop_elections_real
```

### 2) Abrir el notebook

```bash
jupyter notebook proyecto_hadoop_votos.ipynb
```

### 3) Ejecutar celdas en orden

El notebook hace lo siguiente:

1. Levanta el clúster local Hadoop (Docker)
2. Normaliza columnas clave del CSV ONPE (`departamento,candidato,total_votos`)
3. Carga el archivo normalizado a HDFS
4. Ejecuta dos jobs MapReduce:
   - votos totales por candidato
   - votos por departamento y candidato
5. Exporta resultados en `output/` y muestra el ganador en consola

## Salidas finales

- `output/candidate_totals.csv`
- `output/department_candidate_totals.csv`
- `output/winner_summary.txt`

Ejemplo de formato esperado:

```text
candidate,total_votes,percentage
JOSE PEDRO CASTILLO TERRONES,2714152,19.06
KEIKO SOFIA FUJIMORI HIGUCHI,1907896,13.4
...
```

## Comandos útiles

Verificar entrada en HDFS:

```bash
docker exec hadoop-elections-namenode hdfs dfs -ls /elections/input
```

Ver salida de candidato en HDFS:

```bash
docker exec hadoop-elections-namenode hdfs dfs -cat /elections/output/candidate_totals/part-*
```

Apagar clúster:

```bash
docker compose down
```

## Troubleshooting

- Si HDFS no responde al inicio, espera 1-2 minutos y revisa `docker compose logs namenode`.
- El CSV ONPE tiene campos con comas entre comillas; por eso el notebook normaliza primero el archivo antes de MapReduce.
- En Mac Apple Silicon, las imágenes `linux/amd64` pueden tardar más por emulación.
- Si falla el job, confirma contenedores activos: `docker ps | rg hadoop-elections`.
