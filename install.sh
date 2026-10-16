#!/usr/bin/env bash
# Instala este perfil de Claude Code en ~/.claude en el dispositivo actual.
# Seguro de re-ejecutar: no duplica el bloque de CLAUDE.md, no borra contenido
# que el usuario tenga fuera de los marcadores config-claude, y en settings.json
# solo agrega claves (no quita las que ya tengas).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
BEGIN_MARK="<!-- BEGIN config-claude -->"
END_MARK="<!-- END config-claude -->"

mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents" "$CLAUDE_DIR/commands"

echo "Quitando lo que este repo ya no instala..."
while IFS= read -r rel || [ -n "$rel" ]; do
  rel="$(echo "$rel" | tr -d '\r' | xargs)"
  case "$rel" in ""|\#*) continue ;; esac
  if [ -e "$CLAUDE_DIR/$rel" ]; then
    rm -rf "${CLAUDE_DIR:?}/$rel"
    echo "  - $rel"
  fi
done < "$SCRIPT_DIR/retirados.txt"

echo "Copiando skills..."
# Cada skill se reemplaza completa para no dejar archivos que el repo ya quitó.
for skill in "$SCRIPT_DIR"/skills/*/; do
  name="$(basename "$skill")"
  rm -rf "${CLAUDE_DIR:?}/skills/$name"
  cp -r "$skill" "$CLAUDE_DIR/skills/$name"
done

echo "Copiando agentes y comandos..."
cp -r "$SCRIPT_DIR/agents/." "$CLAUDE_DIR/agents/"
cp -r "$SCRIPT_DIR/commands/." "$CLAUDE_DIR/commands/"

echo "Actualizando CLAUDE.md..."
TARGET="$CLAUDE_DIR/CLAUDE.md"
touch "$TARGET"
USER_PART="$(awk -v begin="$BEGIN_MARK" -v end="$END_MARK" '
  { sub(/^\xef\xbb\xbf/, "") }
  $0 == begin {skip=1; next}
  $0 == end {skip=0; next}
  !skip {print}
' "$TARGET" | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' | sed '/./,$!d')"
{
  if [ -n "$USER_PART" ]; then
    printf '%s\n\n' "$USER_PART"
  fi
  echo "$BEGIN_MARK"
  cat "$SCRIPT_DIR/CLAUDE.md"
  echo "$END_MARK"
} > "$TARGET.tmp"
mv "$TARGET.tmp" "$TARGET"

if ! command -v python3 >/dev/null 2>&1; then
  echo "Aviso: sin python3 no puedo fusionar settings.json ni leer plugins.json."
  echo "Copia a mano las claves de $SCRIPT_DIR/settings.json en $CLAUDE_DIR/settings.json"
  echo "e instala los plugins listados en $SCRIPT_DIR/plugins.json con /plugin install."
  exit 0
fi

echo "Fusionando settings.json..."
python3 - "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json" <<'EOF'
import json, os, sys
repo = json.load(open(sys.argv[1], encoding="utf-8-sig"))
path = sys.argv[2]
user = json.load(open(path, encoding="utf-8-sig")) if os.path.exists(path) else {}
for key, value in repo.items():
    if key not in user or not isinstance(value, dict):
        user[key] = value
        continue
    # Objetos (permissions, env): se agregan subclaves; las listas se unen sin duplicar.
    for sub, subvalue in value.items():
        if isinstance(subvalue, list):
            current = user[key].get(sub, [])
            user[key][sub] = current + [x for x in subvalue if x not in current]
        else:
            user[key][sub] = subvalue
with open(path, "w", encoding="utf-8") as f:
    json.dump(user, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF

echo "Instalando plugins..."
read_plugins() {
  python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print('\n'.join(m['$1'] for m in d['marketplaces']) if '$1'!='plugins' else '\n'.join(d['plugins']))" "$SCRIPT_DIR/plugins.json"
}
if command -v claude >/dev/null 2>&1; then
  KNOWN="$(claude plugin marketplace list || true)"
  paste <(read_plugins name) <(read_plugins source) | while IFS=$'\t' read -r name source; do
    grep -q "$name" <<<"$KNOWN" || claude plugin marketplace add "$source" || echo "Aviso: no se pudo agregar $source"
  done
  read_plugins plugins | while read -r p; do
    claude plugin install "$p" --scope user || echo "Aviso: no se pudo instalar $p"
  done
else
  echo "  No encontré el CLI de claude. Instala los plugins dentro de una sesión:"
  read_plugins source | sed 's|^|    /plugin marketplace add |'
  read_plugins plugins | sed 's|^|    /plugin install |'
fi

echo ""
echo "Listo. Configuración instalada en $CLAUDE_DIR"
echo "Abre una sesión nueva de Claude Code para que cargue los cambios."
