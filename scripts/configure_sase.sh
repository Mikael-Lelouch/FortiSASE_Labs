#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/.venv/bin/activate"
ansible-playbook -i "$ROOT_DIR/ansible/inventory.ini" "$ROOT_DIR/ansible/playbooks/init.yml" --limit sase
ansible-playbook -i "$ROOT_DIR/ansible/inventory.ini" "$ROOT_DIR/ansible/playbooks/configure.yml" --limit sase
template_output="$ROOT_DIR/out/fortisase-config.yaml"
mkdir -p "$(dirname "$template_output")"
ansible localhost -c local -i localhost, -m template \
  -e "@${ROOT_DIR}/ansible/group_vars/sase.yml" \
  -a "src=${ROOT_DIR}/templates/sase-config.txt dest=${template_output}"
echo "Configuration SASE générée: $template_output"
