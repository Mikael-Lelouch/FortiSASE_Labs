# Topologie du laboratoire

```
                                      +---------------------+
                                      |  FortiAnalyzer      |
                                      |  (Optionnel)        |
                                      +----------+----------+
                                                 |
                                                 |
                        Internet/MPLS ---------- + -------------------------+
                                                 |                           |
                           +---------------------+---------------------+     |
                           |         POP FortiSASE / ZTNA Gateway      |     |
                           |  (inspection, CASB, SWG, ZTNA, RBI)       |     |
                           +----------+----------------------+----------+     |
                                      |                      |                |
                                      |                      |                |
                                VPN SSL Clients         IPsec overlay        |
                                      |                      |                |
                 +--------------------+              +-----+-------+          |
                 |                                       |               +----+----+
                 |                                   +---+---+           | Hub FG |
         +-------+------+                            | Edge  |           | (HQ)   |
         | Teleworker 1 |                            | CPE   |           +----+---+
         +--------------+                            +---+---+                |
                                                           |                 LAN
                                                           |                  |
                                                  +--------+--------+   +----+----+
                                                  | Branch FortiGate|   | IAM/AD  |
                                                  | (Branch-1)      |   | Server  |
                                                  +--------+--------+   +---------+
                                                           |
                                                     LAN / WiFi

                                                  +--------+--------+
                                                  | Branch FortiGate|
                                                  | (Branch-2)      |
                                                  +--------+--------+
                                                           |
                                                     LAN / OT Zone
```

## Description des segments

| Segment                | Adresse IP / VLAN            | Description                                                   |
|------------------------|------------------------------|---------------------------------------------------------------|
| Gestion Hub            | 10.10.10.0/24                | Interfaces de gestion FortiGate Hub                          |
| Gestion Branch-1       | 10.10.11.0/24                | Accès admin Branch-1                                         |
| Gestion Branch-2       | 10.10.12.0/24                | Accès admin Branch-2                                         |
| Overlay SD-WAN         | 172.16.0.0/24                | Tunnel IPsec/SSL entre branches et hub                      |
| LAN Hub                | 192.168.0.0/24               | LAN interne hub                                              |
| LAN Branch-1           | 192.168.10.0/24              | LAN utilisateur branch-1                                    |
| LAN Branch-2           | 192.168.20.0/24              | LAN utilisateur/OT branch-2                                 |
| POP FortiSASE          | 100.64.0.0/24                | Interfaces logiques SASE                                    |
| VPN SSL Clients        | 192.168.200.0/24             | Pool d'adresses clients nomades                             |
| IAM/AD                 | 192.168.100.0/24             | Services d'identité et authentification                     |

## Fichier de topologie

Le fichier `topology/topology.yaml` contient la définition machine-par-machine des interfaces, réseaux et dépendances. Il peut être importé dans EVE-NG ou utilisé pour générer automatiquement des diagrammes via des outils comme NetBox ou draw.io (en le convertissant avec `netbox-importer`).
