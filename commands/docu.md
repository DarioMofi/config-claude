---
description: Documenta los cambios principales realizados en la sesión actual en un registro versionado (CHANGELOG.md u otra convención que el repo ya use). No comitea — solo documenta.
argument-hint: "[alcance opcional, ej. 'solo la parte de backend']"
---

Genera un registro de lo que se hizo en esta sesión de trabajo, para tener control de los cambios sin depender de la memoria de la conversación.

## Proceso

1. **Alcance** — si `$ARGUMENTS` especifica algo, acótate a eso. Si no, cubre todo lo tocado en la sesión actual.
2. **Verifica contra el estado real, no contra tu memoria**: corre `git status` y `git diff` (contra el último commit, o contra `HEAD` si aún no hay commit de esta sesión) para confirmar qué archivos se tocaron de verdad.
3. **Reconstruye el "por qué" desde la conversación** — el diff dice qué cambió; el motivo (qué se pidió, qué se decidió y por qué, qué alternativas se descartaron) solo vive en el contexto de la sesión. Sin esto, el registro es un changelog vacío tipo "modified file.ts" que no sirve para nada seis meses después.
4. **Busca la convención existente del repo antes de inventar una**: un `CHANGELOG.md` en la raíz, o una carpeta `docs/`/`changelog/`. Si existe, sigue su formato. Si no existe ninguna, pregunta si quieres crear un `CHANGELOG.md` simple — no lo crees en silencio la primera vez que se usa este comando en un repo nuevo.
5. **Escribe una entrada fechada** (usa la fecha real del sistema, no la inventes), agrupada por tema — no un log plano archivo-por-archivo. Por cada grupo: qué cambió, por qué, y cualquier decisión relevante tomada en el camino.
6. **No comitees.** Este comando solo documenta — el commit sigue siendo una acción explícita separada que el usuario pide aparte, igual que siempre.
