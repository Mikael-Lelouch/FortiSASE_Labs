#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"

log() {
  echo -e "[INIT] $*"
}

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python3 est requis" >&2
  exit 1
fi

if [[ ! -d "$VENV_DIR" ]]; then
  log "Création de l'environnement virtuel"
  python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

log "Mise à jour pip et installation des dépendances"
pip install --upgrade pip
pip install ansible==8.4.0 ansible-lint fortinet-fortios==2.1.6

log "Installation des collections Fortinet"
ansible-galaxy collection install fortinet.fortios fortinet.fortisase community.general

log "Vérification de la connectivité SSH/HTTPS"
ansible -i "$ROOT_DIR/ansible/inventory.ini" all -m ping || {
  log "Certaines cibles ne répondent pas au ping Ansible"
}

log "Initialisation terminée"
