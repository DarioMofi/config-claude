# config-claude

Configuración personal de [Claude Code](https://claude.com/claude-code) para un perfil de **desarrollador full-stack con nociones de urbanismo y análisis territorial** (contexto mexicano).

Este repo es la "imagen" reproducible de esa configuración: clónalo en cualquier dispositivo y un solo script la instala en tu `~/.claude`, incluidos los plugins.

## Qué incluye

| Archivo | Qué hace |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | Perfil global: principios de trabajo + contexto de dominio (normativa urbana mexicana + herramientas GIS) |
| [`skills/normativa-urb/`](skills/normativa-urb/SKILL.md) | Propio. Se activa en tareas de uso de suelo, dictámenes territoriales, programas de desarrollo urbano |
| [`skills/gis-exp/`](skills/gis-exp/SKILL.md) | Propio. Se activa en tareas con datos geoespaciales (QGIS, PostGIS, SQL espacial, Shapefile/GeoJSON/raster) |
| [`skills/backend-dev/`](skills/backend-dev/SKILL.md) | Propio. Diseño de APIs, migraciones y seguridad de backend. Para Postgres/Supabase remite a los skills oficiales de Supabase |
| [`skills/data-analysis-py/`](skills/data-analysis-py/SKILL.md) | Propio. Análisis/limpieza/agregación de datos tabulares con pandas |
| [`skills/actualizar-contexto/`](skills/actualizar-contexto/SKILL.md) | Propio. Actualiza el `CLAUDE.md` de un proyecto al cerrar un cambio estructural, para que la siguiente conversación arranque con el contexto correcto |
| [`agents/territorial-analyst.md`](agents/territorial-analyst.md) | Propio. Subagente de investigación (solo lectura) para research normativo + geoespacial |
| [`agents/gis-data-analyst.md`](agents/gis-data-analyst.md) | Propio. Subagente de solo lectura para inspeccionar y validar datos geoespaciales reales |
| [`agents/code-reviewer.md`](agents/code-reviewer.md) | Propio. Segunda opinión de revisión de código, aislada del contexto de quien escribió el cambio. Incluye la lista de riesgos de seguridad/rendimiento/pruebas/docs |
| [`commands/architecture-review.md`](commands/architecture-review.md) | Propio. Comando manual (`/architecture-review`) — auditoría de arquitectura a nivel sistema |
| [`commands/docu.md`](commands/docu.md) | Propio. Comando manual (`/docu`) — documenta los cambios de la sesión en un changelog, sin comitear |
| [`settings.json`](settings.json) | Claves que el instalador fusiona en `~/.claude/settings.json`: confirmación obligatoria para el MCP de Supabase y telemetría de Vercel apagada |
| [`plugins.json`](plugins.json) | Marketplaces y plugins que el instalador agrega |
| [`retirados.txt`](retirados.txt) | Lo que versiones anteriores instalaban y ya no; el instalador lo borra de `~/.claude` |

### Skills vendorizados de terceros

Copiados dentro de este repo porque se modificaron localmente (acotados para que no se encimen entre sí). Licencia explícita que lo permite:

| Origen | Licencia | Skills incluidos |
|---|---|---|
| [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | MIT | `banner-design`, `brand`, `design`, `design-system`, `slides`, `ui-styling`, `ui-ux-pro-max` |
| [anthropics/skills](https://github.com/anthropics/skills) — carpeta `frontend-design` | Apache 2.0 (`LICENSE.txt` incluido junto al skill) | `frontend-design` |

Cambios locales sobre upstream: `design` no trae las referencias de slides (viven en `slides`/`design-system`); `ui-styling` no trae la capa "Canvas" (la filosofía visual vive en `frontend-design`); `ui-ux-pro-max` aclara en su descripción que no es un sistema de tokens.

**Para actualizarlos** sin perder esos cambios: merge de 3 vías — la versión vendorizada original como base, la de este repo como "local" y la de upstream como "upstream". Así entran las correcciones de arriba y se conservan los recortes. Última sincronización: 2026-10-16.

## Plugins (se instalan solos con el instalador)

Se instalan desde su fuente oficial y se actualizan por su cuenta; no se copian aquí.

| Plugin | Marketplace | Para qué |
|---|---|---|
| `mattpocock-skills` | `claude-plugins-official` | Skills de ingeniería de [mattpocock/skills](https://github.com/mattpocock/skills): TDD, code review, diagnóstico de bugs, specs y tickets, grilling, etc. Antes estaban vendorizados; como plugin se actualizan solos. Se invocan con prefijo, p. ej. `mattpocock-skills:tdd` |
| `supabase` | `claude-plugins-official` | Skills oficiales `supabase` y `supabase-postgres-best-practices` (índices, RLS, pooling, locks) **y** el MCP de Supabase |
| `vercel` | `claude-plugins-official` | Skills, comandos (`/deploy`, `/env`, `/status`) y MCP de Vercel |
| `context7` | `claude-plugins-official` | Documentación actualizada de librerías (Supabase, React, Leaflet…) en vez de depender de lo que el modelo memorizó |
| `insecure-defaults` | `trailofbits` ([trailofbits/skills](https://github.com/trailofbits/skills)) | Detecta credenciales en código, secretos con valor de respaldo y configuraciones inseguras por defecto |
| `supply-chain-risk-auditor` | `trailofbits` | Audita el riesgo de dependencias npm/PyPI |

### Con cuidado

- **MCP de Supabase**: puede ejecutar SQL, aplicar migraciones y desplegar funciones en tus proyectos. `settings.json` agrega la regla `ask` `mcp__*supabase*`, así que **toda** herramienta de Supabase pide confirmación, incluso en modo auto. Úsalo contra un proyecto de desarrollo; con un proyecto en producción (usuarios reales), lee cada SQL antes de aprobarlo.
- **Vercel**: su MCP puede desplegar y cambiar variables de entorno. Sus hooks inyectan contexto al iniciar sesión en proyectos de Vercel y en carpetas vacías — en carpetas vacías le indica a Claude ejecutar sin planear, lo que contradice el principio 1 de `CLAUDE.md`; si estorba, desactívalo con `/plugin`. La telemetría (anónima) queda apagada con `VERCEL_PLUGIN_TELEMETRY=off`.

### Descartado deliberadamente

- **[affaan-m/ECC](https://github.com/affaan-m/ECC)** — hooks de un autor no verificado y una superficie enorme (278+ skills, 67 agentes) difícil de auditar.
- **[JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)** — reescribe `CLAUDE.md` para comprimir tokens; chocaría con el contexto de urbanismo/GIS.
- **[safishamsi/graphify](https://github.com/safishamsi/graphify)** — herramienta de mapeo de código con hooks de git por proyecto, no configuración global.
- **`security-guidance`** (oficial) — hooks en cada mensaje y revisión con LLM al terminar cada turno: costo de tokens constante.
- **`modern-python`** (Trail of Bits) — instala atajos en el PATH que interceptan `pip`/`python` para empujar a `uv`; intrusivo para scripts sueltos.

## Instalación

**Windows (PowerShell):**
```powershell
git clone https://github.com/DarioMofi/config-claude.git
cd config-claude
./install.ps1
```

**Mac / Linux / Git Bash:**
```bash
git clone https://github.com/DarioMofi/config-claude.git
cd config-claude
chmod +x install.sh
./install.sh
```

El instalador es **idempotente**: puedes correrlo varias veces sin duplicar contenido.

- `CLAUDE.md`: agrega este perfil entre marcadores (`<!-- BEGIN config-claude -->` / `<!-- END config-claude -->`) sin tocar el resto de tu archivo.
- `settings.json`: solo agrega claves; las listas de permisos se unen sin duplicar y no quita nada tuyo.
- Plugins: usa el CLI `claude` (en Windows también encuentra el que trae la app de escritorio). Si no lo encuentra, imprime los comandos `/plugin` para correrlos dentro de una sesión. `install.sh` necesita `python3` para fusionar JSON.

## Cambio de cuenta

La configuración vive en `~/.claude`, que pertenece al **usuario del sistema operativo**, no a la cuenta de Claude: al cambiar de cuenta en el mismo equipo no se pierde nada de lo que instala este repo. Lo que sí depende de la cuenta:

- **Skills subidas a claude.ai** (`gis-exp` y `normativa-urb` están ahí y aparecen en Claude Code como `anthropic-skills:gis-exp` / `anthropic-skills:normativa-urb`). Las versiones de este repo son idénticas y son la fuente de verdad. Para tenerlas también en claude.ai con la cuenta nueva, comprime cada carpeta y súbela en la sección de Skills de la configuración de claude.ai:
  ```powershell
  Compress-Archive -Path skills\gis-exp -DestinationPath gis-exp.zip
  Compress-Archive -Path skills\normativa-urb -DestinationPath normativa-urb.zip
  ```
- Conectores de claude.ai y el inicio de sesión de cada plugin con MCP (Supabase y Vercel piden autorización OAuth la primera vez).

## Personalizar

- Las convenciones de stack específicas (framework, lenguaje) van en el `CLAUDE.md` de cada proyecto, no aquí.
- **Editar o agregar un skill**: hazlo aquí en el repo (no en `~/.claude`, el instalador reemplaza esa copia), corre el instalador y haz `git commit` + `git push`. En otro dispositivo: `git pull` y volver a correr el instalador.
- **Quitar un skill, agente o comando**: bórralo del repo y agrega su ruta a `retirados.txt` para que el instalador lo quite también de `~/.claude`.
- **Agregar un plugin**: añádelo a `plugins.json` (y su marketplace si no es el oficial).

## Alcance de la instalación

Todo queda en `~/.claude` (configuración de **usuario**, no de proyecto): aplica en cualquier carpeta que abras en este dispositivo. No se sincroniza solo — para otro dispositivo, clona el repo y corre el instalador ahí también.
