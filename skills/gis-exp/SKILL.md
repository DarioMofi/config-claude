---
name: gis-exp
description: Patrones, SQL y buenas prácticas para trabajar con datos geoespaciales (QGIS, PostGIS, Shapefile/GeoJSON, raster, geoprocesamiento). Úsalo cuando la tarea involucre cargar, transformar, analizar o visualizar datos geográficos.
---

# Herramientas y patrones GIS

## Cuándo usar este skill

Actívalo cuando la tarea pida:
- Cargar o convertir datos entre Shapefile, GeoJSON, KML, CSV con coordenadas.
- Reproyectar datos entre sistemas de coordenadas.
- Hacer geoprocesamiento: buffers, uniones espaciales (spatial join), intersecciones, disolver polígonos.
- Modelar o consultar datos espaciales en una base de datos (PostGIS).
- Preparar capas para visualización (QGIS, Leaflet, Mapbox).

## Stack de referencia

- **QGIS** — análisis y visualización de escritorio; usar para inspección visual rápida y validación antes de automatizar.
- **PostGIS** — extensión espacial de PostgreSQL para datos en producción; preferible sobre procesar shapefiles sueltos cuando el dataset crece o se consulta repetidamente. Ver sección de SQL abajo — es la herramienta por defecto para proyectos SIG serios, no un extra opcional.
- **GDAL/OGR** (`ogr2ogr`) — conversión de formatos y reproyección desde línea de comandos.
- **Python**: `geopandas` (manipulación tipo pandas para geometrías), `shapely` (operaciones geométricas), `pyproj` (reproyección).

## Reglas prácticas

1. **Verifica siempre el sistema de coordenadas (CRS) antes de operar.** Mezclar datos en distintos CRS produce resultados silenciosamente incorrectos (distancias/áreas mal calculadas), no un error visible.
   - México central: UTM zona 14N → `EPSG:32614`.
   - Noroeste de México: zona 11N/12N (`EPSG:32611`/`32612`); sureste: zona 15N/16N (`EPSG:32615`/`32616`) — confirma la zona real según la ubicación de los datos, no la asumas.
   - Para datos web/lat-long sin proyectar: `EPSG:4326` (WGS84).
2. **Nunca calcules área o distancia en `EPSG:4326`.** Son grados, no metros — el resultado es numéricamente "válido" pero territorialmente falso, y no truena, así que el error pasa desapercibido.

   ```python
   # MAL — área en grados², no significa nada como superficie real
   gdf_4326.geometry.area

   # BIEN — reproyecta a la UTM correcta antes de medir
   gdf_utm = gdf_4326.to_crs(epsg=32614)
   gdf_utm.geometry.area  # ahora sí, m²
   ```
3. **No reproyectes "a ojo".** Usa `pyproj`/`ogr2ogr`/la herramienta de reproyección de QGIS — nunca transformes coordenadas manualmente.
4. **Valida geometrías antes de operaciones espaciales** (`is_valid` en shapely/geopandas) — geometrías inválidas rompen buffers y joins de forma poco obvia.
5. **Para datasets grandes o consultas repetidas, usa PostGIS con índice espacial (`GIST`)** en vez de shapefiles sueltos cargados en memoria cada vez.
6. **Al entregar resultados a alguien más, exporta a un formato estándar** (GeoJSON o Shapefile) con el CRS documentado explícitamente — no asumas que quien lo reciba sabe en qué proyección viene.

## PostGIS: SQL esencial

Para proyectos SIG en producción, el SQL espacial es la herramienta por defecto — no un plan B de geopandas.

```sql
-- Índice espacial (indispensable en cualquier tabla con geometría consultada seguido)
CREATE INDEX idx_predios_geom ON predios USING GIST (geom);

-- Reproyectar dentro de una consulta
SELECT ST_Transform(geom, 32614) FROM predios;

-- Cruce predio ↔ zonificación (equivalente SQL del spatial join de geopandas)
SELECT p.id, z.clave_zonificacion
FROM predios p
JOIN zonificacion z ON ST_Intersects(p.geom, z.geom);

-- ¿Un punto cae dentro de un polígono? (ej. predio dentro de zona de riesgo)
SELECT * FROM zonas_riesgo z
WHERE ST_Within(ST_SetSRID(ST_MakePoint(:lon, :lat), 4326), z.geom);

-- Área real (reproyectando primero — misma regla que en geopandas)
SELECT ST_Area(ST_Transform(geom, 32614)) AS area_m2 FROM predios;

-- Reparar geometría inválida antes de operar
UPDATE predios SET geom = ST_MakeValid(geom) WHERE NOT ST_IsValid(geom);
```

## Operaciones comunes (geopandas)

`geopandas` es un superset de pandas — para limpieza, agregación o rendimiento del DataFrame que no dependa de la geometría, aplican las mismas prácticas del skill `data-analysis-py` (vectorización, tipos de dato, `merge` explícito, etc.). Aquí solo lo específico de la columna de geometría.

- Cargar: `gpd.read_file("archivo.shp")` / `gpd.read_file("archivo.geojson")`
- Reproyectar: `gdf.to_crs(epsg=32614)`
- Buffer: `gdf.geometry.buffer(distancia_en_unidades_del_crs)`
- Join espacial: `gpd.sjoin(gdf_izq, gdf_der, how="inner", predicate="intersects")`
- Guardar: `gdf.to_file("salida.geojson", driver="GeoJSON")`

## Raster (uso ocasional)

Los datos raster (Atlas de Riesgo, uso de suelo/vegetación INEGI, modelos de elevación) pesan mucho más que vectorial — trátalos como segundo plano: úsalos cuando el vector no alcance, no por defecto.

- **`rasterio`** — lectura/escritura básica, reproyección de rasters.
- **`rasterstats`** (`zonal_stats`) — estadística zonal: ej. "% del predio dentro de la zona de inundación" cruzando un polígono vectorial contra un raster de riesgo.
- Antes de procesar un raster grande, confirma resolución y extensión — no lo cargues completo en memoria si solo necesitas una ventana (`rasterio.windows`).

## Fuentes de datos oficiales (México)

| Fuente | Qué ofrece |
|---|---|
| **INEGI** | Marco Geoestadístico Nacional (límites), Uso de Suelo y Vegetación (vector y raster) |
| **CONABIO** | Capas de biodiversidad, Áreas Naturales Protegidas |
| **CONAGUA** | Atlas Nacional de Riesgos, capas hidrológicas, zonas federales de cuerpos de agua |
| **Geoportal estatal/municipal** | Zonificación digital del PMDU/PDU — disponibilidad y formato varían por entidad; confírmalo por WebSearch, no asumas cobertura nacional uniforme |

## Checklist de integridad antes de entregar un dataset

1. **CRS documentado explícitamente** — nunca entregues un archivo sin decir en qué proyección viene.
2. **Geometrías válidas** (`is_valid`/`ST_IsValid`) — sin auto-intersecciones.
3. **Sin traslapes involuntarios** entre polígonos vecinos de una misma capa (común en capas de zonificación mal digitalizadas).
4. **Atributos completos** — sin nulos inesperados en campos clave (clave de zonificación, ID de predio).
5. **Archivos completos, no solo el `.shp`**: un Shapefile son mínimo 3 archivos obligatorios (`.shp`, `.shx`, `.dbf`) más el `.prj` para el CRS — verifica que estén los 4 antes de compartir; un `.shp` suelto sin `.prj` no lleva CRS y rompe silenciosamente en quien lo reciba.
6. **Conteo de features razonable** contra la fuente original — un `sjoin` o filtro mal hecho puede duplicar o perder registros sin lanzar error.

## Conexión con `normativa-urb`

Este skill resuelve el **"sí/no toca" espacial** (¿el predio cae dentro de esta zona/polígono de riesgo/ANP?); `normativa-urb` interpreta **qué significa eso normativamente** (qué uso permite esa clave de zonificación, qué ley aplica). Flujo típico: cruza el predio contra la capa de zonificación aquí (spatial join / `ST_Intersects`), y entrega la clave resultante a `normativa-urb` para la lectura normativa. Para inspección aislada de datos geoespaciales reales, usa el agente `gis-data-analyst`.
