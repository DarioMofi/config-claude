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

## Contexto compartido (Estado.md)

En todo proyecto, `Estado.md` en la raíz es la libreta de estado compartida entre agentes (Claude y Antigravity). Si no existe, créalo con el formato de abajo e incluye inmediatamente `Estado.md` en `.gitignore` para mantenerlo como contexto local no versionado.

1. **Al inicio de cada turno:** lee `Estado.md` para situar el objetivo actual, la última acción realizada y los bloqueos. Antigravity pudo haberlo cambiado desde tu último turno.
2. **Al terminar tu tarea:** actualiza solo el estado inmediato:
   - Última acción realizada (Agente: Claude).
   - Archivos modificados o hash del commit.
   - Próximo paso pendiente para el siguiente agente.
3. **Límites:** máximo 50 líneas. Sobrescribe o elimina tareas resueltas; el historial vive en Git.

Cada herramienta lee solo sus propios archivos de reglas: no leas `GEMINI.md`, `AGENTS.md` ni `.agents/` (son de Antigravity). Lo único compartido es `Estado.md`. El contexto durable del proyecto va en su `CLAUDE.md` (skill `actualizar-contexto`), no en `Estado.md`.

Formato (el mismo que usa Antigravity; no cambies los encabezados):

```markdown
# Estado del Proyecto & Sesión

## Objetivo Inmediato
- [ ] Descripción breve del objetivo en curso.

## Última Acción Realizada
- **Agente**: Claude / Antigravity
- **Cambio**: Resumen técnico de 1-2 líneas sobre lo implementado.
- **Commit / Archivos**: `hash` o lista de archivos tocados.

## Bloqueos / Notas
- Ninguno (o dependencias pendientes).

## Próximo Paso
- Instrucción puntual para el siguiente turno o agente.
```
