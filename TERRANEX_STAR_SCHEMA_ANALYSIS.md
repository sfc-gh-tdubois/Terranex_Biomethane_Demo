# 🌟 Modèle en Étoile Terranex - Analyse Complète
## Schéma de Données pour la Production de Biométhane

---

## 🎯 **Vue d'Ensemble du Modèle**

Le modèle en étoile créé pour **Terranex** (ex-GRT Gaz) est spécialement conçu pour l'analyse de la production et de l'injection de biométhane sur le réseau de transport français. Il suit les meilleures pratiques du dimensional modeling avec une table de faits centrale entourée de 4 dimensions métier.

### **📊 Structure Générale**
```
                    TEMPS_DIM (2,093)
                         |
                         |
SITE_DIM (24) ---- INJECTION_FACT (44,453) ---- RESEAU_DIM (26)
                         |
                         |
                    QUALITE_DIM (20)
```

---

## 🏗️ **Table de Faits Centrale : INJECTION_FACT**

### **📈 Volume de Données**
- **44,453 injections** enregistrées
- **Période** : 1er janvier 2020 → 23 septembre 2025
- **Granularité** : Quotidienne par site
- **Couverture** : 21 sites actifs × 2,093 jours

### **🔑 Clés et Relations**
```sql
INJECTION_FACT
├── id_injection (PK) : BIGINT - Identifiant unique
├── id_site (FK) → SITE_DIM
├── id_temps (FK) → TEMPS_DIM  
├── id_poste_reseau (FK) → RESEAU_DIM
└── id_analyse_qualite (FK) → QUALITE_DIM (optionnel)
```

### **📊 Métriques Business**
- **volume_injecte_m3** : Volume brut en mètres cubes
- **energie_injectee_mwh** : KPI principal - Énergie en MWh
- **debit_moyen_m3_h** : Débit horaire moyen
- **pression_injection_bar** : Pression d'injection
- **temperature_gaz_celsius** : Température du gaz
- **statut_injection** : NORMAL/REDUIT/ARRETE

### **💰 Métriques Globales**
- **156.45 millions m³** de biométhane injecté
- **604 GWh** d'énergie totale (0.604 TWh)
- **Croissance** : +42% (2021), +13% (2022), +10% (2023), +5% (2024)

---

## 🏭 **Dimension 1 : SITE_DIM (Sites de Production)**

### **📋 Caractéristiques**
- **24 sites** de production répartis sur **9 régions**
- **22 producteurs** différents (dont Terranex R&D)
- **487.3 MWh/jour** de capacité totale active

### **🔧 Attributs Métier**
```sql
SITE_DIM
├── id_site (PK) : Identifiant unique du site
├── nom_site : Nom du site de méthanisation
├── id_producteur : Identifiant du producteur
├── nom_producteur : Entreprise exploitante
├── technologie_production : Type de procédé
├── type_intrants : Matières premières utilisées
├── capacite_nominale_mwh_jour : Capacité théorique
├── date_mise_en_service : Date de démarrage
├── coordonnees_gps : Géolocalisation
├── region, departement, code_postal : Localisation
└── statut_operationnel : ACTIF/MAINTENANCE/ARRETE
```

### **🌍 Répartition Géographique**
| **Région** | **Sites** | **Capacité (MWh/j)** |
|------------|-----------|---------------------|
| Hauts-de-France | 3 | 75.5 |
| Auvergne-Rhône-Alpes | 3 | 67.0 |
| Occitanie | 2 | 61.5 |
| Normandie | 2 | 54.9 |
| Grand Est | 3 | 50.2 |

### **🔬 Technologies Représentées**
| **Technologie** | **Sites** | **Capacité (MWh/j)** |
|-----------------|-----------|---------------------|
| Méthanisation voie liquide | 8 | 182.3 |
| Méthanisation infiniment mélangé | 4 | 116.1 |
| Méthanisation voie sèche | 5 | 104.2 |
| Pyrogazéification | 2 | 63.9 |
| Technologies pilotes | 2 | 20.8 |

---

## ⏰ **Dimension 2 : TEMPS_DIM (Calendrier Français)**

### **📅 Couverture Temporelle**
- **2,093 jours** : 1er janvier 2020 → 23 septembre 2025
- **6 années** complètes/partielles
- **63 jours fériés français** identifiés

### **🗓️ Attributs Calendaires**
```sql
TEMPS_DIM
├── id_temps (PK) : Format YYYYMMDD (ex: 20250923)
├── date_complete : Date complète
├── annee : Année (2020-2025)
├── trimestre : T1, T2, T3, T4
├── mois_nom : Janvier, Février... (français)
├── semaine_numero : Numéro de semaine (1-53)
├── jour_de_la_semaine : Lundi, Mardi... (français)
├── est_ferie : Booléen - Jour férié français
└── nom_ferie : Nom du jour férié
```

### **🇫🇷 Jours Fériés Français Intégrés**
#### **Fixes :**
- Jour de l'An, Fête du Travail, Victoire 1945
- Fête Nationale, Assomption, Toussaint
- Armistice 1918, Noël

#### **Mobiles (basés sur Pâques) :**
- Lundi de Pâques, Ascension, Lundi de Pentecôte

### **📊 Distribution**
- **~365 jours/an** avec années bissextiles
- **~11 jours fériés/an** (moyenne française)
- **Trimestres équilibrés** : 90-92 jours chacun

---

## 🌐 **Dimension 3 : RESEAU_DIM (Réseau de Transport)**

### **🔌 Infrastructure Terranex**
- **26 postes d'injection** sur **11 zones géographiques**
- **249,600 Nm³/h** de capacité totale active
- **12 équipes d'exploitation** spécialisées

### **⚡ Attributs Réseau**
```sql
RESEAU_DIM
├── id_poste_reseau (PK) : Identifiant unique du poste
├── nom_poste_injection : Nom/code du poste Terranex
├── niveau_pression_bar : 40 bar (MP) ou 67 bar (HP)
├── responsable_exploitation_reseau : Équipe en charge
├── zone_geographique_reseau : Découpage Terranex
├── type_poste : Classification technique
├── capacite_injection_max_nm3_h : Capacité maximale
├── date_mise_en_service : Date de mise en service
├── statut_operationnel : ACTIF/MAINTENANCE/ARRETE
└── coordonnees_gps : Géolocalisation
```

### **🔧 Types de Postes par Pression**
| **Pression** | **Type** | **Postes** | **Capacité (Nm³/h)** |
|--------------|----------|------------|---------------------|
| 67 bar | Injection HP | 10 | 114,200 |
| 67 bar | Injection THT | 2 | 47,000 |
| 67 bar | Injection Test | 1 | 3,200 |
| 40 bar | Injection MP | 9 | 80,200 |
| 40 bar | Injection Expérimentale | 1 | 5,000 |

### **🌍 Zones Géographiques (Top 5)**
| **Zone** | **Postes** | **Capacité (Nm³/h)** |
|----------|------------|---------------------|
| Zone Sud-Est | 3 | 38,700 |
| Zone Nord | 3 | 35,500 |
| Zone Ile-de-France | 1 | 25,000 |
| Zone Sud | 2 | 24,900 |
| Zone Rhône-Alpes | 2 | 23,700 |

---

## 🧪 **Dimension 4 : QUALITE_DIM (Analyses Chromatographiques)**

### **📊 Contrôle Qualité**
- **20 analyses** de janvier à juillet 2025
- **5 laboratoires Terranex** répartis géographiquement
- **3 méthodes** chromatographiques (GC-MS, GC-FID, GC-TCD)

### **🔬 Attributs Qualité**
```sql
QUALITE_DIM
├── id_analyse_qualite (PK) : Format YYYYMMDD+séq
├── timestamp_analyse : Date/heure précise
├── pcs_kwh_m3 : Pouvoir Calorifique Supérieur
├── wobbe_index : Indice d'interchangeabilité
├── teneur_h2s_ppm : Sulfure d'hydrogène (toxique)
├── teneur_co2_pourcentage : Dioxyde de carbone
├── statut_conformite : Conforme/Non-conforme/Dérogation
├── laboratoire_analyse : Labo Terranex responsable
├── methode_analyse : Technique chromatographique
├── operateur_analyse : Technicien responsable
└── commentaires : Observations détaillées
```

### **✅ Conformité Réglementaire**
| **Statut** | **Analyses** | **%** | **PCS Moyen** | **H2S Moyen** |
|------------|--------------|-------|---------------|---------------|
| Conforme | 16 | 80% | 10.881 kWh/m³ | 2.26 ppm |
| Dérogation | 2 | 10% | 10.685 kWh/m³ | 2.70 ppm |
| Non-conforme | 2 | 10% | 10.720 kWh/m³ | 10.70 ppm |

### **🏭 Performance par Laboratoire**
- **Labo Terranex Nord** : 4 analyses, 0 non-conformité
- **Labo Terranex Est** : 4 analyses, 0 non-conformité  
- **Labo Terranex Sud** : 4 analyses, 0 non-conformité
- **Labo Terranex Ouest** : 5 analyses, 2 non-conformités ⚠️
- **Labo Terranex Centre** : 3 analyses, 0 non-conformité

---

## 🎯 **Relations et Cardinalités du Modèle**

### **🔗 Relations Principales**
```sql
INJECTION_FACT (44,453 records)
    ├── 1:N → SITE_DIM (24 sites)
    ├── 1:N → TEMPS_DIM (2,093 jours)  
    ├── 1:N → RESEAU_DIM (26 postes)
    └── 1:N → QUALITE_DIM (20 analyses) [optionnel]
```

### **📈 Cardinalités Moyennes**
- **Injections par site** : 1,852 (44,453 ÷ 24)
- **Injections par jour** : 21.2 (44,453 ÷ 2,093)
- **Injections par poste** : 1,709 (44,453 ÷ 26)
- **Analyses qualité** : 1% des injections (20 ÷ 44,453)

---

## 📊 **Métriques Business et KPIs**

### **🎯 KPIs Principaux**
1. **Énergie Injectée (MWh)** - KPI #1 pour Terranex
2. **Volume Injecté (m³)** - Métrique opérationnelle
3. **Taux d'Utilisation** - Efficacité des sites
4. **Conformité Qualité** - Respect réglementaire
5. **Disponibilité Réseau** - Performance infrastructure

### **📈 Évolution Historique (2020-2025)**
| **Année** | **Énergie (GWh)** | **Croissance** | **Sites Actifs** |
|-----------|-------------------|----------------|------------------|
| 2020 | 66.15 | - | 18 |
| 2021 | 94.00 | +42.1% | 20 |
| 2022 | 106.19 | +13.0% | 21 |
| 2023 | 117.31 | +10.5% | 21 |
| 2024 | 123.40 | +5.2% | 21 |
| 2025* | 96.55 | -21.8%* | 21 |

*\*2025 = 9 mois seulement*

### **🌍 Performance par Région (2024)**
| **Région** | **Énergie (GWh)** | **Sites** | **Part de Marché** |
|------------|-------------------|-----------|-------------------|
| Hauts-de-France | 19.09 | 3 | 15.5% |
| Auvergne-Rhône-Alpes | 16.98 | 3 | 13.8% |
| Occitanie | 15.56 | 2 | 12.6% |
| Normandie | 13.91 | 2 | 11.3% |
| Grand Est | 12.73 | 3 | 10.3% |

---

## 🔍 **Variations et Patterns Intégrés**

### **📅 Saisonnalité**
- **Hiver (T1)** : +10% (demande chauffage)
- **Printemps (T2)** : -10% (demande modérée)
- **Été (T3)** : -20% (demande faible)
- **Automne (T4)** : Normal (baseline)

### **📆 Cycles Hebdomadaires**
- **Lundi-Vendredi** : Production normale (100%)
- **Weekend** : Production réduite (-15%)
- **Jours fériés français** : Production minimale (-25%)

### **⚙️ Montée en Puissance**
- **0-3 mois** après mise en service : 60% capacité
- **3-6 mois** après mise en service : 80% capacité
- **6+ mois** après mise en service : 100% capacité

### **🎲 Variabilité Opérationnelle**
- **Facteur d'utilisation** : 70-85% de la capacité nominale
- **Variation quotidienne** : ±10% aléatoire
- **Disponibilité** : 95% Normal, 3% Réduit, 2% Arrêté

---

## 💡 **Cas d'Usage et Analyses Possibles**

### **📊 Analyses Opérationnelles**
```sql
-- Performance par site et trimestre
SELECT 
    s.nom_site, t.trimestre, t.annee,
    SUM(f.energie_injectee_mwh) as energie_mwh,
    AVG(f.debit_moyen_m3_h) as debit_moyen
FROM injection_fact f
JOIN site_dim s ON f.id_site = s.id_site
JOIN temps_dim t ON f.id_temps = t.id_temps
GROUP BY s.nom_site, t.trimestre, t.annee;
```

### **🌍 Analyses Géographiques**
```sql
-- Cartographie de la production par région
SELECT 
    s.region, r.zone_geographique_reseau,
    SUM(f.volume_injecte_m3) as volume_total,
    COUNT(DISTINCT f.id_site) as nb_sites
FROM injection_fact f
JOIN site_dim s ON f.id_site = s.id_site
JOIN reseau_dim r ON f.id_poste_reseau = r.id_poste_reseau
GROUP BY s.region, r.zone_geographique_reseau;
```

### **📈 Analyses Temporelles**
```sql
-- Tendances mensuelles avec saisonnalité
SELECT 
    t.annee, t.mois_nom,
    SUM(f.energie_injectee_mwh) as energie_mwh,
    AVG(f.temperature_gaz_celsius) as temp_moyenne
FROM injection_fact f
JOIN temps_dim t ON f.id_temps = t.id_temps
WHERE t.est_ferie = FALSE
GROUP BY t.annee, t.mois_nom;
```

### **🔬 Analyses Qualité**
```sql
-- Corrélation qualité vs production
SELECT 
    q.statut_conformite,
    AVG(f.energie_injectee_mwh) as energie_moyenne,
    AVG(q.pcs_kwh_m3) as pcs_moyen,
    COUNT(*) as nb_analyses
FROM injection_fact f
JOIN qualite_dim q ON f.id_analyse_qualite = q.id_analyse_qualite
GROUP BY q.statut_conformite;
```

### **⚙️ Analyses Infrastructure**
```sql
-- Utilisation des postes réseau par pression
SELECT 
    r.niveau_pression_bar, r.type_poste,
    COUNT(f.id_injection) as nb_injections,
    SUM(f.volume_injecte_m3) as volume_total,
    AVG(f.pression_injection_bar) as pression_moyenne
FROM injection_fact f
JOIN reseau_dim r ON f.id_poste_reseau = r.id_poste_reseau
GROUP BY r.niveau_pression_bar, r.type_poste;
```

---

## 🚀 **Avantages du Modèle en Étoile**

### **⚡ Performance**
- **Jointures simples** : 1 table de faits ↔ N dimensions
- **Requêtes rapides** : Structure optimisée pour l'analytique
- **Agrégations efficaces** : Pré-calculées par dimension
- **Indexation optimale** : Clés étrangères bien définies

### **📊 Simplicité d'Usage**
- **Compréhension intuitive** : Logique métier claire
- **Maintenance facile** : Structure stable dans le temps
- **Extensibilité** : Ajout de dimensions sans impact
- **Gouvernance** : Contrôle centralisé des données

### **🔍 Richesse Analytique**
- **Drill-down/Roll-up** : Navigation dans les hiérarchies
- **Slice & Dice** : Analyses multidimensionnelles
- **Time-series** : Analyses temporelles avancées
- **Géospatial** : Analyses géographiques avec GPS

---

## 🎯 **Utilisation avec Snowflake Intelligence**

### **🤖 Agent IA Potentiel**
Le modèle est prêt pour un agent Snowflake Intelligence spécialisé Terranex qui pourrait répondre à :

**Questions Business :**
- *"Quelle est notre production de biométhane ce trimestre ?"*
- *"Quel site a la meilleure performance énergétique ?"*
- *"Comment évolue notre taux d'utilisation par région ?"*

**Questions Techniques :**
- *"Quels postes réseau ont des problèmes de pression ?"*
- *"Y a-t-il des corrélations entre qualité et production ?"*
- *"Quel est l'impact des jours fériés sur nos injections ?"*

**Questions Réglementaires :**
- *"Combien d'analyses non-conformes ce mois ?"*
- *"Quels sites ont des problèmes de H2S récurrents ?"*
- *"Rapport de conformité par laboratoire ?"*

### **📊 Vues Sémantiques Suggérées**
```sql
CREATE SEMANTIC VIEW NATRAN_BIOMETHAN_VIEW
    tables (
        SITES as SITE_DIM,
        TEMPS as TEMPS_DIM,
        RESEAU as RESEAU_DIM,
        QUALITE as QUALITE_DIM,
        INJECTIONS as INJECTION_FACT
    )
    facts (
        INJECTIONS.volume_injecte_m3 as volume,
        INJECTIONS.energie_injectee_mwh as energie,
        INJECTIONS.debit_moyen_m3_h as debit
    )
    dimensions (
        SITES.nom_site as site,
        SITES.region as region,
        TEMPS.date_complete as date,
        RESEAU.nom_poste_injection as poste,
        QUALITE.statut_conformite as conformite
    );
```

---

## 📋 **Synthèse du Modèle**

### **🎯 Points Forts**
✅ **Modèle métier complet** : Couvre tous les aspects Terranex  
✅ **Volume de données massif** : 44,453 injections sur 5+ années  
✅ **Réalisme des données** : Variations saisonnières, montée en puissance  
✅ **Conformité française** : Jours fériés, régions, réglementation  
✅ **Extensibilité** : Prêt pour nouvelles dimensions/métriques  
✅ **Performance** : Optimisé pour l'analytique Snowflake  

### **🔧 Prêt pour Production**
- **Gouvernance** : Rôle SF_Intelligence_Demo propriétaire
- **Sécurité** : Contrôle d'accès granulaire
- **Monitoring** : Métriques de qualité intégrées
- **Évolutivité** : Architecture cloud-native

### **🚀 Next Steps**
1. **Vue sémantique** pour Cortex Analyst
2. **Agent Snowflake Intelligence** spécialisé biométhane
3. **Dashboards** temps réel avec Snowsight
4. **Alertes** qualité et performance automatisées

---

**🌟 Le modèle en étoile Terranex est maintenant opérationnel pour des analyses avancées de production biométhane !**
