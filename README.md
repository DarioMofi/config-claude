# config-claude

Configuración personal de [Claude Code](https://claude.com/claude-code) para un perfil de **desarrollador full-stack con nociones de urbanismo y análisis territorial** (contexto mexicano).

Este repo es la "imagen" reproducible de esa configuración: clónalo en cualquier dispositivo y un solo script la instala en tu `~/.claude`.

## Qué incluye

| Archivo | Qué hace |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | Perfil global: principios de trabajo + contexto de dominio (normativa urbana mexicana + herramientas GIS) |
| [`skills/analisis-territorial-mx/`](skills/analisis-territorial-mx/SKILL.md) | Propio. Se activa en tareas de uso de suelo, dictámenes territoriales, programas de desarrollo urbano |
| [`skills/gis-toolkit/`](skills/gis-toolkit/SKILL.md) | Propio. Se activa en tareas con datos geoespaciales (QGIS, PostGIS, Shapefile/GeoJSON) |
| [`agents/territorial-analyst.md`](agents/territorial-analyst.md) | Propio. Subagente de investigación (solo lectura) para research normativo + geoespacial |

No incluye hooks ni scripts que se ejecuten automáticamente durante una sesión — solo `CLAUDE.md`, skills y un agente, todo en markdown.

### Skills vendorizados de terceros

Estos sí están copiados dentro de este repo (a diferencia de los plugins de la sección siguiente), porque tienen licencia explícita que lo permite. Cada uno conserva su contenido tal cual la fuente:

| Origen | Licencia | Skills incluidos |
|---|---|---|
| [mattpocock/skills](https://github.com/mattpocock/skills) | MIT | `code-review`, `codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grill-with-docs`, `implement`, `improve-codebase-architecture`, `prototype`, `research`, `resolving-merge-conflicts`, `tdd`, `to-spec`, `to-tickets`, `triage`, `wayfinder`, `grill-me`, `grilling`, `handoff`, `teach`, `writing-great-skills` |
| [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | MIT | `banner-design`, `brand`, `design`, `design-system`, `slides`, `ui-styling`, `ui-ux-pro-max` (paletas, tipografía y motor de búsqueda BM25 en Python, todo local) |
| [anthropics/skills](https://github.com/anthropics/skills) — carpeta `frontend-design` | Apache 2.0 (`LICENSE.txt` incluido junto al skill) | `frontend-design` |

Se excluyeron deliberadamente de mattpocock/skills: `ask-matt` (persona específica del autor) y `setup-matt-pocock-skills` (instalador atado a su flujo de issue-tracking, no aplica aquí).

## Instalación

**Windows (PowerShell):**
```powershell
git clone https://github.com/<tu-usuario>/config-claude.git
cd config-claude
./install.ps1
```

**Mac / Linux / Git Bash:**
```bash
git clone https://github.com/<tu-usuario>/config-claude.git
cd config-claude
chmod +x install.sh
./install.sh
```

El instalador es **idempotente**: puedes correrlo varias veces (o en varios dispositivos) sin duplicar contenido. Si ya tienes un `~/.claude/CLAUDE.md` con otro contenido, el instalador agrega este perfil entre marcadores (`<!-- BEGIN config-claude -->` / `<!-- END config-claude -->`) sin tocar el resto de tu archivo.

## Plugins externos recomendados (opcionales)

Estos no están vendorizados en este repo — se instalan directamente desde su fuente oficial dentro de una sesión de Claude Code, para no depender de una copia desactualizada ni de licencias de terceros:

- **[anthropics/skills](https://github.com/anthropics/skills)** — skills oficiales de Anthropic para trabajar con documentos (PDF, DOCX, PPTX, XLSX).
  ```
  /plugin marketplace add anthropics/skills
  /plugin install document-skills@anthropic-agent-skills
  ```
- **[obra/superpowers](https://github.com/obra/superpowers)** — metodología de desarrollo (brainstorming → plan → TDD → revisión). Su hook de `SessionStart` fue revisado: solo lee un archivo local, sin red ni escritura de archivos.
  ```
  /plugin marketplace add obra/superpowers
  /plugin install superpowers@claude-plugins-official
  ```

### Descartado deliberadamente

- **[affaan-m/ECC](https://github.com/affaan-m/ECC)** — trae hooks (scripts que se ejecutan automáticamente) de un autor no verificado, junto con una superficie muy grande (278+ skills, 67 agentes, dashboard GUI) difícil de auditar por completo. Si en el futuro quieres algo puntual de ahí, revisa el script específico antes de copiarlo — no lo instales completo.
- **[JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)** — reescribe `CLAUDE.md` de forma permanente para comprimir tokens (`/caveman-compress`) y modifica configuración de múltiples agentes al instalarse. Entra en conflicto directo con el perfil detallado que arma este repo: podría comprimir o borrar el contexto de urbanismo/GIS para ahorrar tokens.
- **[safishamsi/graphify](https://github.com/safishamsi/graphify)** — no es un perfil/skill sino una herramienta de mapeo de código con hooks de git (`post-commit`, `post-checkout`) por proyecto. Útil como herramienta puntual en un repo de código grande, pero no pertenece a esta configuración global.

## Personalizar

- Las convenciones de stack específicas (framework, lenguaje) van en el `CLAUDE.md` de cada proyecto, no aquí — este perfil es contexto global.
- Para agregar un skill nuevo, crea `skills/<nombre>/SKILL.md` con frontmatter `name` + `description`, y vuelve a correr el instalador.
- **Editar un skill existente**: modifícalo aquí en el repo (no directamente en `~/.claude`, el instalador sobrescribe esa copia), corre el instalador para aplicar el cambio localmente, y haz `git commit` + `git push` para compartirlo — en otro dispositivo basta un `git pull` y volver a correr el instalador.

## Alcance de la instalación

Al correr el instalador, el contenido queda en `~/.claude` (configuración de **usuario**, no de proyecto): aplica en cualquier carpeta que abras en este dispositivo, sin importar la ruta. No se sincroniza solo — para otro dispositivo, hay que clonar el repo y correr el instalador ahí también.
