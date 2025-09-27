# Vue d'ensemble du laboratoire FortiSASE

Ce laboratoire reproduit un déploiement SASE typique comprenant :

- Un siège (Hub) FortiGate assurant l'agrégation SD-WAN et les services UTM avancés.
- Deux sites distants (Branch-1 et Branch-2) connectés via IPsec/SSL vers le hub avec basculement dynamique SD-WAN.
- Une passerelle SASE cloud (FortiSASE POP) pour la sécurisation des utilisateurs nomades et l'accès Internet.
- Un contrôleur d'authentification (FortiAuthenticator) pour la gestion des identités.
- Un orchestrateur (cette machine) qui pilote la configuration via Ansible.

Les cas d'usage couverts :

1. **Accès sécurisé des sites distants** : Les branches utilisent SD-WAN avec application d'inspection NGFW, filtrage web et prévention des intrusions via le hub.
2. **Accès utilisateur nomade** : Les clients VPN SSL se connectent au POP SASE, profitent du ZTNA et du contrôle applicatif.
3. **Inspection du trafic Internet** : Redirection du trafic via le POP SASE avec politiques fondées sur l'identité et la posture.
4. **Surveillance & reporting** : Collecte des logs vers FortiAnalyzer (optionnel) et supervision via FortiManager.

## Flux opérationnels

1. **Initialisation** : `scripts/init_lab.sh` installe les dépendances Python/Ansible, prépare les collections Fortinet Ansible et vérifie la connectivité aux équipements.
2. **Provisioning** : `ansible/playbooks/init.yml` pousse la configuration de base (interfaces, VLAN, routes) sur tous les nœuds.
3. **Configuration avancée** : `ansible/playbooks/configure.yml` applique les politiques de sécurité, SD-WAN, VPN, ZTNA et intégrations IAM.
4. **Validation** : Des tests Ansible et des scripts `verify_*.yml` (à créer selon besoins) permettent de valider la posture.

## Personnalisation

- Ajoutez ou supprimez des branches en dupliquant les fichiers de variables dans `ansible/group_vars/`.
- Mettez à jour les modèles de configuration dans `templates/` pour refléter vos exigences spécifiques (par exemple, plages IP, politiques).
- Intégrez des outils supplémentaires (FortiAnalyzer, FortiManager) en complétant l'inventaire et les playbooks.

## Ressources complémentaires

- [Fortinet Ansible Galaxy Collection](https://galaxy.ansible.com/fortinet) pour la documentation des modules.
- [Guides FortiSASE](https://docs.fortinet.com/product/fortisase) pour les meilleures pratiques de déploiement.
- [ZTNA Design Guide](https://www.fortinet.com/resources) pour l'architecture Zero Trust.
