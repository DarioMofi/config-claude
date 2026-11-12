# Estado del Proyecto & Sesión

## Objetivo General
- Configuración personal de Claude Code versionada (se instala con install.ps1 / install.sh), coordinada con Antigravity mediante Estado.md.

## Worktrees
- Ninguno

## Trabajo en curso

### Rama: master
- **Objetivo**: Reglas compartidas de Estado.md y git worktree, más hooks de inicio y cierre.
- **Agente**: Claude
- **Cambio**: Reglas de Estado.md (repo propio vs ajeno) y worktree en CLAUDE.md; hooks SessionStart/Stop en hooks/ y settings.json; instalador copia hooks y no duplica entradas.
- **Commit / Archivos**: CLAUDE.md, README.md, install.ps1, install.sh, settings.json, hooks/, Estado.md, .gitattributes (comiteado y subido).
- **Bloqueos**: Ninguno.
- **Próximo paso**: Pegar las secciones compartidas (Estado.md y Git worktree) en la configuración de Antigravity; con la cuenta nueva de Claude, subir gis-exp y normativa-urb a claude.ai.
