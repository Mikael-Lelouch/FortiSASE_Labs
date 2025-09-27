#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -d "$ROOT_DIR/.venv" ]]; then
  echo "Suppression de l'environnement virtuel"
  rm -rf "$ROOT_DIR/.venv"
fi
rm -rf "$ROOT_DIR/out"
