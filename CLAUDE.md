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

En todo repo git, `Estado.md` en la raíz es la libreta de estado compartida entre agentes (Claude y Antigravity), entre ramas y entre equipos.

- **Repo propio** (el remoto `origin` pertenece a la cuenta de GitHub `DarioMofi`, o el repo no tiene remoto): `Estado.md` se versiona en git. No lo agregues a `.gitignore` (si ya está ahí, quítalo). Si no existe, créalo con el formato de abajo y agrega la línea `Estado.md merge=union` a `.gitattributes`, para que git una los bloques de distintas ramas sin marcar conflicto.
- **Repo ajeno** (cualquier otro dueño): `Estado.md` se usa igual, pero no entra al repo. Agrégalo a `.git/info/exclude` (se ignora solo en este equipo, sin modificar archivos del repo) y no toques `.gitattributes` ni `.gitignore`. En un repo ajeno no viaja entre equipos.

Hay un bloque por rama con trabajo activo; solo escribes en el de la rama actual (`git branch --show-current`; en un worktree es la rama de esa carpeta). "Objetivo General" y "Worktrees" solo se editan en la rama principal (`main` o `master`; aquí se le dice `main`).

1. **Al iniciar la sesión, y otra vez antes de editarlo:** lee `Estado.md` y ubica el bloque de la rama actual. Si no existe, créalo al final de "Trabajo en curso".
2. **Al terminar tu tarea:** actualiza solo el bloque de la rama actual, con tu nombre de agente (Claude o Antigravity). Si se comitea, `Estado.md` va en el mismo commit que el trabajo.
3. **Al hacer merge:** revisa que la unión no haya dejado líneas duplicadas. En `main`, borra el bloque de la rama integrada si ya no tiene trabajo pendiente, y el de cualquier rama que ya no exista; conserva los de ramas que siguen activas.
4. **Cambio de equipo:** si el usuario dice que va a cambiar de computadora, ofrece commit y push de cada rama con cambios pendientes, incluido `Estado.md`.
5. **Límites:** máximo 50 líneas. Cada bloque guarda solo su estado más reciente; el historial vive en Git.

La sección "Worktrees" se mantiene según la regla "Git worktree".

Formato (no cambies los encabezados):

```markdown
# Estado del Proyecto & Sesión

## Objetivo General
- Objetivo del proyecto o de la etapa actual (solo se edita en main).

## Worktrees
- Ninguno (o: `rama` → `../carpeta` — equipos: NOMBRE1, NOMBRE2)

## Trabajo en curso

### Rama: nombre-de-rama
- **Objetivo**: Qué se busca en esta rama.
- **Agente**: Claude / Antigravity
- **Cambio**: Resumen técnico de 1-2 líneas sobre lo implementado.
- **Commit / Archivos**: Archivos tocados o `hash` de commits previos.
- **Bloqueos**: Ninguno (o dependencia, ej. "espera el endpoint /predios de la rama backend").
- **Próximo paso**: Instrucción puntual para el siguiente turno o agente.
```

## Git worktree (trabajo en paralelo)

Cuando dos agentes vayan a trabajar a la vez en ramas distintas del mismo repo, cada rama va en su propia carpeta hermana `../<repo>-<rama>` (si la rama lleva `/`, cámbiala por `-`). Nunca cambies de rama dentro de una carpeta de worktree: una carpeta, una rama. El registro vive en la sección "Worktrees" de `Estado.md` en `main` y se edita desde la carpeta principal. El nombre de este equipo es el valor de `$env:COMPUTERNAME` (Windows) o `hostname`.

- **Crear** (desde la carpeta principal): `git worktree add ../<repo>-<rama> <rama>`; si la rama es nueva, `git worktree add -b <rama> ../<repo>-<rama>` y propón `git push -u origin <rama>` para que exista en el otro equipo. Copia el `.env`, instala dependencias y usa otro puerto de desarrollo. Agrega la línea al registro (o este equipo a la línea), comitea en `main` y propón push.
- **Revisar** al iniciar la sesión y después de cada `git pull` en `main` (si un hook ya hizo la revisión, usa su resultado). Compara el registro con `git worktree list` y avisa al usuario:
  - Rama registrada sin este equipo: en otro equipo se trabaja en paralelo. Ofrece crearla aquí (`git fetch` y `git worktree add`) y, si acepta, agrega este equipo a la línea.
  - Carpeta local que no está en el registro, o en la que no figura este equipo: ofrece registrarla.
  - Rama registrada que ya no existe (ni local ni en `origin`): ofrece cerrar su carpeta aquí y quitar la línea.
  - Este equipo figura pero la carpeta ya no existe: ofrece `git worktree prune` y corregir el registro.
- **Merge:** se hace en la carpeta principal. El worktree sigue existiendo y se puede seguir trabajando en él.
- **Cerrar** (con confirmación): `git worktree remove ../<repo>-<rama>` y quita este equipo de la línea; si no queda ninguno, borra la rama (local y en `origin`) y la línea.

## Aislamiento de reglas

Cada herramienta opera solo con su propia configuración. No leas, cargues ni inspecciones `GEMINI.md`, `AGENTS.md`, `.agents/` ni `~/.gemini/` (son de Antigravity) salvo que el usuario lo pida explícitamente, para no gastar tokens ni mezclar reglas entre agentes. El único artefacto compartido es `Estado.md`.

Excepción automática: si un proyecto tiene `AGENTS.md` pero no `CLAUDE.md`, Claude Code carga `AGENTS.md` por su cuenta al iniciar. En ese caso propón crear el `CLAUDE.md` del proyecto (skill `actualizar-contexto`) para que deje de cargarse.

El contexto durable del proyecto va en su `CLAUDE.md` (skill `actualizar-contexto`), no en `Estado.md`.
