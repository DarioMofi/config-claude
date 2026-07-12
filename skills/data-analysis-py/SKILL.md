---
name: data-analysis-py
description: Análisis y manipulación de datos tabulares en Python (pandas, numpy) — limpieza, agregación, rendimiento y buenas prácticas. Úsalo cuando la tarea involucre explorar, transformar, limpiar o agregar datos en un DataFrame, fuera del contexto de servir una API (para eso, `backend-dev`) o de datos geoespaciales (para eso, `gis-exp`).
---

# Análisis de datos en Python (pandas/numpy)

## Cuándo usar este skill

Actívalo cuando la tarea pida:
- Explorar, limpiar o transformar datos tabulares (CSV, Excel, Parquet, resultado de una consulta SQL) con pandas.
- Agregar, agrupar o resumir datos (reportes, métricas, resúmenes estadísticos).
- Optimizar el rendimiento o el uso de memoria de un pipeline de datos en pandas.

No lo actives para datos geoespaciales (geometrías, CRS) — eso es `gis-exp`, aunque `geopandas` extienda pandas. No lo actives para diseñar el endpoint que sirve estos datos — eso es `backend-dev`.

## Vectoriza, no iteres

El error de rendimiento más común y más fácil de introducir sin darse cuenta:

```python
# MAL — iterrows() es de los métodos más lentos de pandas, evítalo casi siempre
for idx, row in df.iterrows():
    df.loc[idx, "total"] = row["precio"] * row["cantidad"]

# BIEN — operación vectorizada, órdenes de magnitud más rápida
df["total"] = df["precio"] * df["cantidad"]
```

`.apply()` con una función de fila (`axis=1`) es mejor que `iterrows()` pero sigue siendo un loop disfrazado — si la operación se puede expresar como aritmética/comparación vectorizada o con `.map()`/`np.where()`, prefiere eso.

## Evita el `SettingWithCopyWarning`

Si pandas advierte esto, no lo ignores — significa que no está claro si estás editando el DataFrame original o una copia temporal, y el resultado puede ser silenciosamente distinto de lo esperado.

```python
# Riesgoso — df_filtrado puede ser una vista o una copia, pandas no garantiza cuál
df_filtrado = df[df["categoria"] == "A"]
df_filtrado["nueva_columna"] = 1  # SettingWithCopyWarning

# Correcto — declara explícitamente que quieres una copia independiente
df_filtrado = df[df["categoria"] == "A"].copy()
df_filtrado["nueva_columna"] = 1
```

## Combinar datos (`merge`/`join`/`concat`)

- `pd.merge(izq, der, on="clave", how="left")` — para combinar por una columna clave, como un `JOIN` de SQL. Especifica siempre `how` explícitamente (`left`/`inner`/`outer`) — el default (`inner`) descarta filas sin match silenciosamente.
- `pd.concat([df1, df2])` — para apilar DataFrames con las mismas columnas (equivalente a `UNION`), no para combinar por clave.
- Después de cualquier `merge`, verifica el número de filas resultante contra lo esperado — un merge con claves duplicadas en cualquiera de los dos lados produce un producto cartesiano parcial sin avisar.

## Agregación (`groupby`)

```python
# Resumen por grupo — patrón más común
df.groupby("municipio").agg(
    total_predios=("id", "count"),
    area_promedio=("area_m2", "mean"),
)

# Múltiples agregaciones + reset_index para volver a un DataFrame plano
resumen = df.groupby("categoria")["monto"].sum().reset_index()
```

Usa `pivot_table` cuando necesites reestructurar de "largo" a "ancho" (una fila por grupo, una columna por categoría) — no lo reconstruyas a mano con múltiples `groupby`.

## Datos faltantes

No hay una respuesta única — decide explícitamente, no dejes el default de pandas sin pensarlo:
- `dropna()` — solo si las filas incompletas de verdad no aportan (y documenta cuántas filas se descartan).
- `fillna(valor)` — cuando hay un valor por defecto razonable (ej. 0 para conteos).
- Imputación (media/mediana/moda) — solo para análisis estadístico donde perder filas sesga la muestra; nunca en datos que alimentan una decisión operativa sin dejarlo explícito.
- **Nunca combines silenciosamente `NaN` con texto** (`"El valor es " + df["campo"]` truena o produce `"El valor es nan"`) — castea o limpia primero.

## Memoria y datasets grandes

- **Tipos de dato correctos**: una columna de texto con pocos valores únicos repetidos (categorías, estados, municipios) debe ser `category`, no `object` — reduce memoria drásticamente y acelera `groupby`.
- **Downcasting numérico**: `pd.to_numeric(col, downcast="integer")` cuando el rango de valores no necesita el tipo por defecto (int64/float64).
- **CSV grandes que no caben en memoria**: `pd.read_csv(..., chunksize=100_000)` y procesa por lotes, en vez de cargar todo y luego filtrar.
- **Evita copias innecesarias**: encadenar `.copy()` "por si acaso" en cada paso de un pipeline largo duplica memoria sin necesidad — solo cópialo cuando vayas a mutar y necesitas independencia del original (ver `SettingWithCopyWarning` arriba).

## Validación antes de confiar en un resultado

1. `df.shape` antes y después de cada `merge`/`filter`/`dropna` — un cambio inesperado en el número de filas es la señal más barata de que algo salió mal.
2. `df.dtypes` — confirma que las columnas numéricas no llegaron como texto (típico al leer CSV con separadores de miles o símbolos de moneda).
3. `df.duplicated().sum()` — verifica duplicados antes de agregar, no después.

## Dónde termina este skill

- **Visualización** (gráficas, dashboards) — usa el skill `dataviz`, no reinventes aquí las convenciones de charting.
- **Datos geoespaciales** (geometrías, CRS, shapefiles) — usa `gis-exp`; `geopandas` es un superset de pandas, así que todo lo de aquí aplica, pero las operaciones espaciales viven allá.
- **Si el resultado de este análisis va a alimentar un endpoint o base de datos en producción** — la optimización de la consulta/esquema de origen es de `backend-dev`; este skill cubre el procesamiento en memoria, no el diseño de la fuente de datos.
