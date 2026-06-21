#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTENT_FILE="${ROOT_DIR}/content/cv.md"
TEMPLATE_FILE="${ROOT_DIR}/templates/cv-template.html"
CSS_FILE="${ROOT_DIR}/styles/print.css"
OUTPUT_DIR="${ROOT_DIR}/output"
HTML_OUTPUT="${OUTPUT_DIR}/cv.html"
PDF_OUTPUT="${OUTPUT_DIR}/cv.pdf"
CSS_OUTPUT="${OUTPUT_DIR}/print.css"

for cmd in pandoc weasyprint; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Erreur : « ${cmd} » est requis mais introuvable." >&2
    exit 1
  fi
done

mkdir -p "${OUTPUT_DIR}"
cp "${CSS_FILE}" "${CSS_OUTPUT}"

echo "→ Génération HTML avec Pandoc…"
pandoc "${CONTENT_FILE}" \
  --from markdown \
  --to html5 \
  --standalone \
  --section-divs \
  --template="${TEMPLATE_FILE}" \
  --css="print.css" \
  --metadata pagetitle="CV" \
  -o "${HTML_OUTPUT}"

echo "→ Génération PDF avec WeasyPrint…"
weasyprint \
  --base-url="${OUTPUT_DIR}/" \
  "${HTML_OUTPUT}" \
  "${PDF_OUTPUT}"

echo "✓ Build terminé : ${PDF_OUTPUT}"
