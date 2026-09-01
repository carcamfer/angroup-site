#!/usr/bin/env bash
# Despliega el sitio a Cloudflare Pages.
# Solo se publica lo que git tiene versionado (los .pdf y .pptx pesados
# estan en .gitignore y no forman parte del sitio).
set -euo pipefail

cd "$(dirname "$0")"

PROJECT="${PROJECT:-angroup}"
OUT="dist"

rm -rf "$OUT"
mkdir -p "$OUT"

git ls-files -z \
  | grep -zv -E '^(README\.md|\.gitignore|package(-lock)?\.json|deploy\.sh)$' \
  | while IFS= read -r -d '' f; do
      mkdir -p "$OUT/$(dirname "$f")"
      cp "$f" "$OUT/$f"
    done

echo "Archivos a publicar: $(find "$OUT" -type f | wc -l)  ($(du -sh "$OUT" | cut -f1))"

npx wrangler pages deploy "$OUT" --project-name="$PROJECT" --branch=main
