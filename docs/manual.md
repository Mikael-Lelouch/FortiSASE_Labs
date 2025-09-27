# Manuel d'utilisation du laboratoire FortiSASE

Ce manuel décrit les étapes nécessaires pour préparer l'environnement, déployer la topologie FortiSASE de ce dépôt et valider les principaux services de sécurité.

## 1. Prérequis logiciels et matériels

| Composant | Version / Détails recommandés | Remarques |
|-----------|-------------------------------|-----------|
| Système d'exploitation | Linux (Ubuntu 22.04 LTS recommandé) ou macOS 13+ | Doit disposer d'un accès Internet pour télécharger les dépendances et les collections Ansible. |
| Python | 3.9 ou supérieur | Vérifiez avec `python3 --version`. |
| Pipx | 1.2+ | Utilisé pour isoler l'installation d'Ansible. |
| Ansible | 2.14 ou supérieur | Installé via `pipx install ansible-core` ou les paquets de la distribution. |
| Collections Ansible Fortinet | `fortinet.fortios`, `fortinet.fortisase` | Installées automatiquement par `scripts/init_lab.sh` ou manuellement avec `ansible-galaxy collection install fortinet.fortios fortinet.fortisase`. |
| Outils système | OpenSSH client, Git, unzip | Nécessaires pour la connexion aux équipements et la gestion du dépôt. |
| Hyperviseur / Lab virtuel | EVE-NG, GNS3, KVM ou équivalent | Doit héberger les VM FortiGate, FortiSASE POP et FortiAuthenticator. |
| Images Fortinet | FortiGate, FortiSASE Cloud, FortiAuthenticator | Nécessitent des licences valides. |
| Ressources matérielles | 16 Go RAM, 4 vCPU, 60 Go disque (minimum) | Ajuster selon le nombre de VM et les images utilisées. |
| Connectivité réseau | Accès IP vers toutes les interfaces de management | S'assurer que la machine d'orchestration peut joindre les IP de l'inventaire Ansible. |

### Fichiers et accès requis

- Clé SSH privée accessible à l'utilisateur Ansible pour les hôtes IAM (`~/.ssh/id_rsa` par défaut).
- Identifiants administrateur FortiGate et FortiSASE configurés conformément à `ansible/inventory.ini`.
- Accès REST API activé sur les FortiGate/FortiSASE (HTTPS) avec certificats acceptés.

## 2. Préparation de l'environnement

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/votre-compte/FortiSASE_Labs.git
   cd FortiSASE_Labs
   ```
2. **Installer les dépendances système**
   ```bash
   sudo apt update && sudo apt install -y python3 python3-venv pipx git openssh-client unzip
   pipx ensurepath
   ```
3. **Installer Ansible et les collections Fortinet**
   ```bash
   pipx install ansible-core
   pipx inject ansible-core ansible
   ansible-galaxy collection install fortinet.fortios fortinet.fortisase
   ```
4. **Configurer les variables d'environnement (optionnel)**
   - Exporter `ANSIBLE_CONFIG` si vous utilisez un fichier de configuration spécifique.
   - Définir `HTTP_PROXY`/`HTTPS_PROXY` si nécessaire pour l'accès Internet.

## 3. Déploiement automatisé

1. **Initialiser l'environnement**
   ```bash
   ./scripts/init_lab.sh
   ```
   Ce script vérifie les dépendances Python, installe les collections manquantes et contrôle la connectivité ICMP vers les hôtes de l'inventaire.

2. **Appliquer la configuration initiale**
   ```bash
   ansible-playbook -i ansible/inventory.ini ansible/playbooks/init.yml
   ```
   Configure les interfaces, le DHCP et prépare les équipements pour les services avancés.

3. **Appliquer la configuration SASE complète**
   ```bash
   ansible-playbook -i ansible/inventory.ini ansible/playbooks/configure.yml
   ```
   Déploie le SD-WAN, les VPN, les politiques de sécurité et l'intégration IAM.

4. **Vérifier l'état**
   ```bash
   ansible -i ansible/inventory.ini all -m fortios_monitor_fact -a 'selector=system_status' --tree output/
   ```
   Inspectez les résultats dans `output/` pour confirmer la santé des équipements.

## 4. Validation fonctionnelle

- **Branches** : Vérifiez que les interfaces WAN sont `up` et que les tunnels IPsec sont établis via `diagnose vpn tunnel list`.
- **POP SASE** : Confirmez la présence des politiques d'accès et des profils CASB dans l'interface FortiSASE.
- **IAM** : Authentifiez un utilisateur LDAP contre le FortiGate pour valider l'intégration RADIUS/LDAP.

## 5. Maintenance et nettoyage

- **Nettoyage** :
  ```bash
  ./scripts/cleanup.sh
  ```
  Réinitialise les configurations temporaires et supprime les fichiers générés.

- **Mises à jour** :
  ```bash
  git pull
  ansible-galaxy collection install fortinet.fortios fortinet.fortisase --upgrade
  ```

- **Sauvegarde** : Exportez les configurations FortiGate/FortiSASE après validation pour conserver un état stable du lab.

## 6. Dépannage

| Problème | Symptôme | Solution |
|----------|----------|----------|
| Erreur de connexion SSH | `UNREACHABLE!` dans Ansible | Vérifier les IP dans `ansible/inventory.ini` et la connectivité réseau. |
| Modules Fortinet manquants | `module not found` | Relancer `./scripts/init_lab.sh` ou installer manuellement les collections. |
| Certificat HTTPS non valide | Erreur TLS lors des tâches FortiGate | Ajouter l'option `validate_certs: false` dans les tâches ou importer le certificat. |
| Utilisateur IAM absent | Erreur LDAP | Rejouer `ansible/playbooks/init.yml` pour provisionner les comptes. |

Pour des scénarios avancés (ZTNA, inspection TLS, CASB), adaptez les modèles de configuration dans `templates/` et les variables dans `ansible/group_vars/`.
