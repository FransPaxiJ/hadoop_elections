# Proyecto Hadoop: Conteo de Votos Electorales

Simulación local de elecciones en varias ciudades usando **HDFS** y **MapReduce** (Hadoop Streaming).

## Requisitos

- Docker y Docker Compose
- Python 3.9+ (para Jupyter y generación de datos)
- Jupyter Notebook o JupyterLab

## Estructura

```text
hadoop_elections/
├── docker-compose.yml          # Mini clúster Hadoop (HDFS + YARN)
├── hadoop.env                  # Configuración del clúster
├── proyecto_hadoop_votos.ipynb # Notebook principal (ejecutar de aquí)
├── mapreduce/
│   ├── mapper_candidate.sh     # Mapper: votos por candidato
│   ├── mapper_city_candidate.sh# Mapper: votos por ciudad y candidato
│   └── reducer_count.sh        # Reducer: suma genérica
├── data/raw_votes/             # CSVs ficticios generados
├── output/                     # Resultados finales exportados
├── slides_tradeoffs.md         # Presentación corta de tradeoffs
└── README.md
```

## Cómo ejecutar

### 1. Entrar al directorio del proyecto

```bash
cd hadoop_elections
```

### 2. Abrir el notebook

```bash
jupyter notebook proyecto_hadoop_votos.ipynb
```

Ejecuta las celdas en orden. El notebook:

1. Arranca Hadoop con Docker Compose
2. Genera datos ficticios de Lima, Arequipa y Cusco
3. Carga los CSV en HDFS
4. Ejecuta dos jobs MapReduce
5. Exporta el resultado final con ganador y porcentajes

### 3. (Opcional) Arrancar Hadoop manualmente

```bash
docker compose up -d
```

Verifica HDFS:

```bash
docker exec hadoop-elections-namenode hdfs dfs -ls /
```

UI del NameNode: http://localhost:9870  
UI de YARN: http://localhost:8088

## Resultado esperado

Archivo `output/candidate_totals.csv`:

```text
candidate,total_votes,percentage
Ana Torres,15234,52.4
Carlos Ruiz,13841,47.6
```

Otros archivos:

- `output/city_candidate_totals.csv` — desglose por ciudad
- `output/winner_summary.txt` — resumen legible con ganador

## Comandos útiles

Listar entrada en HDFS:

```bash
docker exec hadoop-elections-namenode hdfs dfs -ls /elections/input
```

Ver salida del job por candidato:

```bash
docker exec hadoop-elections-namenode hdfs dfs -cat /elections/output/candidate_totals/part-*
```

Detener el clúster:

```bash
docker compose down
```

## Solución de problemas

| Problema | Solución |
| --- | --- |
| `HDFS no respondió` | Espera 1–2 minutos tras `docker compose up` y revisa `docker compose logs namenode` |
| Job MapReduce falla | Confirma que resourcemanager y nodemanager están activos: `docker ps` |
| Permisos en HDFS | `dfs.permissions.enabled=false` ya está en `hadoop.env` |
| Mac con Apple Silicon | Las imágenes usan `linux/amd64`; Docker los emula (puede tardar más) |
| Job falla con `python3 not found` | Usa los scripts `.sh` en `mapreduce/` (no `.py`) |
| Puerto 9870/8088 ocupado | Cambia los puertos en `docker-compose.yml` |

## Preguntas de discusión

Ver sección final del notebook o `slides_tradeoffs.md`.
