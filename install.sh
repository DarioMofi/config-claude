#!/usr/bin/env bash
# Instala este perfil de Claude Code en ~/.claude en el dispositivo actual.
# Seguro de re-ejecutar: no duplica el bloque de CLAUDE.md ni borra contenido
# que el usuario ya tenga fuera de los marcadores config-claude.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
BEGIN_MARK="<!-- BEGIN config-claude -->"
END_MARK="<!-- END config-claude -->"

mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents" "$CLAUDE_DIR/commands"

echo "Copiando skills..."
cp -r "$SCRIPT_DIR/skills/." "$CLAUDE_DIR/skills/"

echo "Copiando agentes..."
cp -r "$SCRIPT_DIR/agents/." "$CLAUDE_DIR/agents/"

echo "Copiando comandos..."
cp -r "$SCRIPT_DIR/commands/." "$CLAUDE_DIR/commands/"

echo "Actualizando CLAUDE.md..."
TARGET="$CLAUDE_DIR/CLAUDE.md"
SOURCE="$SCRIPT_DIR/CLAUDE.md"
touch "$TARGET"

TMP="$(mktemp)"
awk -v begin="$BEGIN_MARK" -v end="$END_MARK" '
  $0 == begin {skip=1; next}
  $0 == end {skip=0; next}
  !skip {print}
' "$TARGET" > "$TMP"
mv "$TMP" "$TARGET"

{
  echo ""
  echo "$BEGIN_MARK"
  cat "$SOURCE"
  echo "$END_MARK"
} >> "$TARGET"

echo ""
echo "Listo. Configuración instalada en $CLAUDE_DIR"
echo ""
echo "Opcional -- instala estos plugins oficiales dentro de una sesión de Claude Code:"
echo "  /plugin marketplace add anthropics/skills"
echo "  /plugin install document-skills@anthropic-agent-skills"
echo ""
echo "  /plugin marketplace add obra/superpowers"
echo "  /plugin install superpowers@claude-plugins-official"
