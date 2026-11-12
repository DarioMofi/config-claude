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

En todo proyecto con git, `Estado.md` en la raíz es la libreta de estado compartida entre agentes (Claude y Antigravity), entre ramas y entre equipos. Se versiona en git: no lo agregues a `.gitignore` (si ya está ahí, quítalo). Si no existe, créalo con el formato de abajo y agrega la línea `Estado.md merge=union` a `.gitattributes`, para que git una los bloques de distintas ramas sin marcar conflicto.

Hay un bloque por rama con trabajo activo; tú solo escribes en el de la rama actual (`git branch --show-current`; en un worktree es la rama de esa carpeta).

1. **Al inicio de cada turno:** lee `Estado.md` y ubica el bloque de la rama actual. Si no existe, créalo al final de "Trabajo en curso".
2. **Al terminar tu tarea:** actualiza solo el bloque de la rama actual, con Agente: Claude. No edites bloques de otras ramas; "Objetivo General" solo se edita en `main`. Si se comitea, `Estado.md` va en el mismo commit que el trabajo.
3. **Al hacer merge:** revisa que la unión no haya dejado líneas duplicadas. En `main`, borra el bloque de la rama integrada si ya no tiene trabajo pendiente, y el de cualquier rama que ya no exista; conserva los de ramas que siguen activas.
4. **Cambio de equipo:** si el usuario dice que va a cambiar de computadora, ofrece commit y push de cada rama con cambios pendientes, incluido `Estado.md`.
5. **Límites:** máximo 50 líneas. Cada bloque guarda solo su estado más reciente; el historial vive en Git.

El contexto durable del proyecto va en su `CLAUDE.md` (skill `actualizar-contexto`), no en `Estado.md`.

Formato (el mismo que usa Antigravity; no cambies los encabezados):

```markdown
# Estado del Proyecto & Sesión

## Objetivo General
- Objetivo del proyecto o de la etapa actual (solo se edita en main).

## Trabajo en curso

### Rama: nombre-de-rama
- **Objetivo**: Qué se busca en esta rama.
- **Agente**: Claude / Antigravity
- **Cambio**: Resumen técnico de 1-2 líneas sobre lo implementado.
- **Commit / Archivos**: Archivos tocados o `hash` de commits previos.
- **Bloqueos**: Ninguno (o dependencia, ej. "espera el endpoint /predios de la rama backend").
- **Próximo paso**: Instrucción puntual para el siguiente turno o agente.
```

## Aislamiento de reglas

Cada herramienta opera solo con su propia configuración. No leas, cargues ni inspecciones `GEMINI.md`, `AGENTS.md`, `.agents/` ni `~/.gemini/` (son de Antigravity) salvo que el usuario lo pida explícitamente, para no gastar tokens ni mezclar reglas entre agentes. El único artefacto compartido es `Estado.md`.

Excepción automática: si un proyecto tiene `AGENTS.md` pero no `CLAUDE.md`, Claude Code carga `AGENTS.md` por su cuenta al iniciar. En ese caso propón crear el `CLAUDE.md` del proyecto (skill `actualizar-contexto`) para que deje de cargarse.
