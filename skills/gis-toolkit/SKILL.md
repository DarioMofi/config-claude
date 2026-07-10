---
name: gis-toolkit
description: Patrones y buenas prácticas para trabajar con datos geoespaciales (QGIS, PostGIS, Shapefile/GeoJSON, geoprocesamiento). Úsalo cuando la tarea involucre cargar, transformar, analizar o visualizar datos geográficos.
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
- **PostGIS** — extensión espacial de PostgreSQL para datos en producción; preferible sobre procesar shapefiles sueltos cuando el dataset crece o se consulta repetidamente.
- **GDAL/OGR** (`ogr2ogr`) — conversión de formatos y reproyección desde línea de comandos.
- **Python**: `geopandas` (manipulación tipo pandas para geometrías), `shapely` (operaciones geométricas), `pyproj` (reproyección).

## Reglas prácticas

1. **Verifica siempre el sistema de coordenadas (CRS) antes de operar.** Mezclar datos en distintos CRS produce resultados silenciosamente incorrectos (distancias/áreas mal calculadas), no un error visible.
   - México central: UTM zona 14N → `EPSG:32614`.
   - Noroeste de México: zona 11N/12N (`EPSG:32611`/`32612`); sureste: zona 15N/16N (`EPSG:32615`/`32616`) — confirma la zona real según la ubicación de los datos, no la asumas.
   - Para datos web/lat-long sin proyectar: `EPSG:4326` (WGS84).
2. **No reproyectes "a ojo".** Usa `pyproj`/`ogr2ogr`/la herramienta de reproyección de QGIS — nunca transformes coordenadas manualmente.
3. **Valida geometrías antes de operaciones espaciales** (`is_valid` en shapely/geopandas) — geometrías inválidas rompen buffers y joins de forma poco obvia.
4. **Para datasets grandes o consultas repetidas, usa PostGIS con índice espacial (`GIST`)** en vez de shapefiles sueltos cargados en memoria cada vez.
5. **Al entregar resultados a alguien más, exporta a un formato estándar** (GeoJSON o Shapefile) con el CRS documentado explícitamente — no asumas que quien lo reciba sabe en qué proyección viene.

## Operaciones comunes (geopandas)

- Cargar: `gpd.read_file("archivo.shp")` / `gpd.read_file("archivo.geojson")`
- Reproyectar: `gdf.to_crs(epsg=32614)`
- Buffer: `gdf.geometry.buffer(distancia_en_unidades_del_crs)`
- Join espacial: `gpd.sjoin(gdf_izq, gdf_der, how="inner", predicate="intersects")`
- Guardar: `gdf.to_file("salida.geojson", driver="GeoJSON")`
