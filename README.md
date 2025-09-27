# FortiSASE Labs

Ce dépôt fournit un laboratoire FortiSASE entièrement automatisé pour tester des scénarios Secure Access Service Edge (SASE) avec une topologie complète, des scripts d'initialisation et des configurations reproductibles. Le laboratoire s'appuie sur Ansible pour orchestrer les équipements virtuels et sur des scripts Bash pour préparer l'environnement, déployer la topologie et appliquer les configurations réseau et sécurité.

## Contenu

- `docs/` – Documentation fonctionnelle et technique du laboratoire.
- `topology/` – Description formelle de la topologie et des liens.
- `templates/` – Modèles de configuration pour les différents rôles (hub, branche, accès distant, sécurité cloud).
- `ansible/` – Inventaire, variables et playbooks pour automatiser l'initialisation et la configuration.
- `scripts/` – Scripts shell pour préparer l'environnement, lancer Ansible et nettoyer le lab.

## Prérequis

1. Linux/macOS avec Bash, Python 3.9+, Ansible 2.14+, OpenSSH et `pipx`.
2. Accès aux images virtuelles FortiGate/FortiSASE ou appliances équivalentes via un hyperviseur (EVE-NG, GNS3, KVM) et connectivité aux interfaces de gestion.
3. Fichiers de licence valides pour les images Fortinet utilisées.
4. Accès réseau entre la machine d'orchestration et tous les équipements de lab.

## Démarrage rapide

1. **Préparer l'environnement**
   ```bash
   ./scripts/init_lab.sh
   ```
2. **Appliquer la configuration de base**
   ```bash
   ./scripts/configure_hub.sh
   ./scripts/configure_branch.sh
   ./scripts/configure_sase.sh
   ```
3. **Vérifier l'état**
   ```bash
   ansible -i ansible/inventory.ini all -m ping
   ```
4. **Nettoyer** (optionnel)
   ```bash
   ./scripts/cleanup.sh
   ```

Consultez `docs/overview.md` et `docs/topology.md` pour la description détaillée du scénario, de la topologie et des flux de trafic.
