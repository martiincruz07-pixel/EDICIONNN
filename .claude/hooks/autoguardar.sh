#!/usr/bin/env bash
# Guarda y sube a GitHub todos los cambios al final de cada respuesta de Claude.
cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}" || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Si no cambió nada, no hay nada que guardar.
[ -z "$(git status --porcelain)" ] && exit 0

git add -A
git commit -q -m "Autoguardado $(date '+%Y-%m-%d %H:%M')

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>" || exit 0

rama=$(git branch --show-current)
for espera in 0 2 4 8 16; do
  sleep "$espera"
  git push -q -u origin "$rama" 2>/dev/null && exit 0
done
echo '{"systemMessage": "Autoguardado: el commit quedó hecho pero no se pudo subir a GitHub."}'
