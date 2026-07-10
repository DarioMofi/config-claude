# config-claude

Configuración personal de [Claude Code](https://claude.com/claude-code) para un perfil de **desarrollador full-stack con nociones de urbanismo y análisis territorial** (contexto mexicano).

Este repo es la "imagen" reproducible de esa configuración: clónalo en cualquier dispositivo y un solo script la instala en tu `~/.claude`.

## Qué incluye

| Archivo | Qué hace |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | Perfil global: principios de trabajo + contexto de dominio (normativa urbana mexicana + herramientas GIS) |
| [`skills/analisis-territorial-mx/`](skills/analisis-territorial-mx/SKILL.md) | Se activa en tareas de uso de suelo, dictámenes territoriales, programas de desarrollo urbano |
| [`skills/gis-toolkit/`](skills/gis-toolkit/SKILL.md) | Se activa en tareas con datos geoespaciales (QGIS, PostGIS, Shapefile/GeoJSON) |
| [`agents/territorial-analyst.md`](agents/territorial-analyst.md) | Subagente de investigación (solo lectura) para research normativo + geoespacial |

No incluye hooks ni scripts que se ejecuten automáticamente durante una sesión — solo `CLAUDE.md`, skills y un agente, todo en markdown.

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

**[affaan-m/ECC](https://github.com/affaan-m/ECC)** no se incluye ni se recomienda: trae hooks (scripts que se ejecutan automáticamente) de un autor no verificado, junto con una superficie muy grande (278+ skills, 67 agentes, dashboard GUI) difícil de auditar por completo. Si en el futuro quieres algo puntual de ahí, revisa el script específico antes de copiarlo — no lo instales completo.

## Personalizar

- Las convenciones de stack específicas (framework, lenguaje) van en el `CLAUDE.md` de cada proyecto, no aquí — este perfil es contexto global.
- Para agregar un skill nuevo, crea `skills/<nombre>/SKILL.md` con frontmatter `name` + `description`, y vuelve a correr el instalador.
