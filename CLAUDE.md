# Perfil: Full-Stack Dev + Análisis Territorial (México)

## Principios de trabajo

1. **Piensa antes de codificar.** Articula tus suposiciones en voz alta. Si algo es ambiguo (requisito, alcance, criterio de éxito), pregunta antes de escribir código en vez de adivinar.
2. **Simplicidad primero.** Escribe solo el código que la tarea pide. Nada de abstracciones, flags o manejo de casos especulativos "por si acaso".
3. **Cambios quirúrgicos.** Edita lo mínimo necesario para cumplir la tarea. No aproveches para refactorizar, renombrar o "mejorar" código adyacente que nadie pidió tocar.
4. **Ejecución orientada a objetivos.** Antes de dar algo por terminado, define cómo se verifica (correr el código, un test, revisar el resultado real) y hazlo — no asumas que compiló/parece bien.

## Perfil

Desarrollador full-stack con nociones de urbanismo y análisis territorial. El trabajo combina dos mundos:
- Desarrollo de software (frontend, backend, bases de datos, APIs).
- Planeación urbana y análisis territorial en contexto mexicano (normativa de uso de suelo, ordenamiento ecológico, datos geoespaciales).

Cuando una tarea toca ambos mundos (ej. una app que visualiza datos territoriales, un dashboard con capas GIS, un análisis de uso de suelo respaldado por datos), aplica ambas lentes: la técnica y la normativa/territorial.

Las convenciones específicas de stack (framework, lenguaje, estilo de código) se definen en el `CLAUDE.md` de cada proyecto — este perfil es contexto global, no lo reemplaza.

## Dominio: urbanismo y análisis territorial (México)

**Marco normativo de referencia:**
- Ley General de Asentamientos Humanos, Ordenamiento Territorial y Desarrollo Urbano (LGAHOTDU).
- Programas Municipales y Estatales de Desarrollo Urbano (PMDU / PDU).
- Usos de suelo y compatibilidad urbanística.
- Programas de Ordenamiento Ecológico Local y Regional (POEL / POER).
- Atlas de Riesgo municipal/estatal.

Las leyes y programas de desarrollo urbano cambian por administración (municipal, estatal, federal) — cuando la tarea dependa de vigencia normativa, dilo explícitamente y sugiere verificar la fuente oficial más reciente en vez de asumir que la normativa citada sigue vigente.

**Herramientas GIS de referencia:**
- QGIS para análisis y visualización de datos espaciales.
- PostGIS como extensión espacial de PostgreSQL para datos en producción.
- Formatos: Shapefile (.shp) y GeoJSON como intercambio común.
- Proyecciones: UTM zona 14N (EPSG:32614) es común para México central; verifica la zona UTM correcta según la ubicación real de los datos.

Para el detalle operativo de cada dominio, ver los skills `normativa-urb` y `gis-exp`.
