# 🏷️ Classification Sémantique - Modèle Terranex Biométhane
## Classification des Colonnes par Type Sémantique Snowflake

---

## 📋 **Légende des Types Sémantiques**

- **🏷️ DIMENSIONS** : Attributs descriptifs pour filtrer et grouper
- **⏰ TIME DIMENSIONS** : Attributs temporels spéciaux avec hiérarchies
- **📊 FACTS** : Valeurs numériques mesurables et agrégables
- **🔍 NAMED FILTERS** : Filtres prédéfinis pour simplifier les requêtes
- **📈 METRICS** : Calculs prédéfinis (agrégations, ratios, KPIs)

---

## 🏭 **TABLE 1 : SITE_DIM (Sites de Production)**

### **🏷️ DIMENSIONS (11 colonnes)**
- **nom_site** : Nom du site de méthanisation
- **id_producteur** : Identifiant du producteur
- **nom_producteur** : Nom de l'entreprise exploitante
- **technologie_production** : Type de procédé (méthanisation, pyrogazéification, etc.)
- **type_intrants** : Matières premières utilisées
- **region** : Région administrative française
- **departement** : Département français
- **code_postal** : Code postal du site
- **statut_operationnel** : ACTIF/MAINTENANCE/ARRETE
- **coordonnees_gps** : Géolocalisation (latitude,longitude)
- **date_mise_en_service** : Date de démarrage (peut être time dimension aussi)

### **📊 FACTS (1 colonne)**
- **capacite_nominale_mwh_jour** : Capacité théorique en MWh/jour

### **🔍 NAMED FILTERS (3 filtres suggérés)**
- **sites_actifs** : `WHERE statut_operationnel = 'ACTIF'`
- **sites_haute_capacite** : `WHERE capacite_nominale_mwh_jour > 25`
- **sites_recent** : `WHERE date_mise_en_service >= '2020-01-01'`

### **📈 METRICS (4 métriques)**
- **nombre_sites** : `COUNT(DISTINCT id_site)`
- **capacite_totale** : `SUM(capacite_nominale_mwh_jour)`
- **capacite_moyenne** : `AVG(capacite_nominale_mwh_jour)`
- **nombre_producteurs** : `COUNT(DISTINCT id_producteur)`

---

## ⏰ **TABLE 2 : TEMPS_DIM (Calendrier Français)**

### **⏰ TIME DIMENSIONS (8 colonnes)**
- **date_complete** : Date complète (dimension temporelle principale)
- **annee** : Année (hiérarchie niveau 1)
- **trimestre** : Trimestre T1-T4 (hiérarchie niveau 2)
- **mois_nom** : Nom du mois français (hiérarchie niveau 3)
- **semaine_numero** : Numéro de semaine dans l'année
- **jour_de_la_semaine** : Jour en français (Lundi-Dimanche)
- **est_ferie** : Indicateur booléen jour férié
- **nom_ferie** : Nom du jour férié français

### **🔍 NAMED FILTERS (5 filtres suggérés)**
- **jours_ouvres** : `WHERE est_ferie = FALSE AND jour_de_la_semaine NOT IN ('Samedi', 'Dimanche')`
- **weekend** : `WHERE jour_de_la_semaine IN ('Samedi', 'Dimanche')`
- **jours_feries** : `WHERE est_ferie = TRUE`
- **periode_hiver** : `WHERE trimestre = 'T1'`
- **periode_ete** : `WHERE trimestre = 'T3'`

### **📈 METRICS (4 métriques)**
- **nombre_jours** : `COUNT(DISTINCT id_temps)`
- **nombre_jours_feries** : `COUNT(CASE WHEN est_ferie = TRUE THEN 1 END)`
- **nombre_semaines** : `COUNT(DISTINCT semaine_numero)`
- **nombre_mois** : `COUNT(DISTINCT mois_nom)`

---

## 🌐 **TABLE 3 : RESEAU_DIM (Infrastructure Transport)**

### **🏷️ DIMENSIONS (9 colonnes)**
- **nom_poste_injection** : Nom/code du poste Terranex
- **responsable_exploitation_reseau** : Équipe en charge
- **zone_geographique_reseau** : Découpage interne Terranex
- **type_poste** : Classification technique (HP, MP, THT, Test)
- **statut_operationnel** : ACTIF/MAINTENANCE/ARRETE
- **coordonnees_gps** : Géolocalisation du poste
- **date_mise_en_service** : Date de mise en service

### **📊 FACTS (2 colonnes)**
- **niveau_pression_bar** : Pression en bars (40=MP, 67=HP)
- **capacite_injection_max_nm3_h** : Capacité maximale en Nm³/h

### **🔍 NAMED FILTERS (4 filtres suggérés)**
- **postes_haute_pression** : `WHERE niveau_pression_bar >= 67`
- **postes_moyenne_pression** : `WHERE niveau_pression_bar = 40`
- **postes_haute_capacite** : `WHERE capacite_injection_max_nm3_h > 15000`
- **postes_pilotes** : `WHERE zone_geographique_reseau = 'Zone Pilote'`

### **📈 METRICS (5 métriques)**
- **nombre_postes** : `COUNT(DISTINCT id_poste_reseau)`
- **capacite_totale_reseau** : `SUM(capacite_injection_max_nm3_h)`
- **capacite_moyenne_postes** : `AVG(capacite_injection_max_nm3_h)`
- **nombre_zones** : `COUNT(DISTINCT zone_geographique_reseau)`
- **nombre_equipes** : `COUNT(DISTINCT responsable_exploitation_reseau)`

---

## 🧪 **TABLE 4 : QUALITE_DIM (Analyses Chromatographiques)**

### **⏰ TIME DIMENSIONS (1 colonne)**
- **timestamp_analyse** : Date/heure précise de l'analyse

### **🏷️ DIMENSIONS (6 colonnes)**
- **statut_conformite** : Conforme/Non-conforme/Dérogation
- **laboratoire_analyse** : Laboratoire Terranex responsable
- **methode_analyse** : Technique chromatographique (GC-MS, GC-FID, GC-TCD)
- **operateur_analyse** : Technicien responsable
- **commentaires** : Observations détaillées
- **temperature_analyse_celsius** : Conditions d'analyse

### **📊 FACTS (6 colonnes)**
- **pcs_kwh_m3** : Pouvoir Calorifique Supérieur
- **wobbe_index** : Indice d'interchangeabilité
- **teneur_h2s_ppm** : Sulfure d'hydrogène (toxique)
- **teneur_co2_pourcentage** : Dioxyde de carbone
- **pression_analyse_bar** : Pression lors de l'analyse

### **🔍 NAMED FILTERS (4 filtres suggérés)**
- **analyses_conformes** : `WHERE statut_conformite = 'Conforme'`
- **analyses_problematiques** : `WHERE statut_conformite != 'Conforme'`
- **h2s_eleve** : `WHERE teneur_h2s_ppm > 5.0`
- **pcs_optimal** : `WHERE pcs_kwh_m3 >= 10.8`

### **📈 METRICS (8 métriques)**
- **nombre_analyses** : `COUNT(DISTINCT id_analyse_qualite)`
- **taux_conformite** : `(COUNT(CASE WHEN statut_conformite = 'Conforme' THEN 1 END) * 100.0 / COUNT(*))`
- **pcs_moyen** : `AVG(pcs_kwh_m3)`
- **wobbe_moyen** : `AVG(wobbe_index)`
- **h2s_moyen** : `AVG(teneur_h2s_ppm)`
- **co2_moyen** : `AVG(teneur_co2_pourcentage)`
- **nombre_non_conformes** : `COUNT(CASE WHEN statut_conformite = 'Non-conforme' THEN 1 END)`
- **nombre_derogations** : `COUNT(CASE WHEN statut_conformite = 'Conforme avec dérogation' THEN 1 END)`

---

## 📊 **TABLE 5 : INJECTION_FACT (Table de Faits Centrale)**

### **🏷️ DIMENSIONS (4 colonnes - clés étrangères)**
- **id_site** : Référence vers SITE_DIM
- **id_temps** : Référence vers TEMPS_DIM
- **id_poste_reseau** : Référence vers RESEAU_DIM
- **id_analyse_qualite** : Référence vers QUALITE_DIM (optionnel)

### **🏷️ DIMENSIONS (2 colonnes - attributs)**
- **statut_injection** : NORMAL/REDUIT/ARRETE
- **duree_injection_minutes** : Durée de l'injection

### **📊 FACTS (6 colonnes)**
- **volume_injecte_m3** : Volume en mètres cubes ⭐ **FACT PRINCIPAL**
- **energie_injectee_mwh** : Énergie en MWh ⭐ **KPI PRINCIPAL TERRANEX**
- **debit_moyen_m3_h** : Débit horaire moyen
- **pression_injection_bar** : Pression d'injection
- **temperature_gaz_celsius** : Température du gaz
- **1** (compteur implicite) : Pour compter les injections

### **🔍 NAMED FILTERS (6 filtres suggérés)**
- **injections_normales** : `WHERE statut_injection = 'NORMAL'`
- **injections_reduites** : `WHERE statut_injection = 'REDUIT'`
- **injections_arretees** : `WHERE statut_injection = 'ARRETE'`
- **haute_production** : `WHERE energie_injectee_mwh > 20`
- **avec_analyse_qualite** : `WHERE id_analyse_qualite IS NOT NULL`
- **periode_recente** : `WHERE id_temps >= 20240101`

### **📈 METRICS (15+ métriques)**

#### **Métriques Énergétiques (KPI Principal)**
- **energie_totale** : `SUM(energie_injectee_mwh)`
- **energie_moyenne** : `AVG(energie_injectee_mwh)`
- **energie_maximale** : `MAX(energie_injectee_mwh)`
- **energie_minimale** : `MIN(energie_injectee_mwh)`

#### **Métriques Volumétriques**
- **volume_total** : `SUM(volume_injecte_m3)`
- **volume_moyen** : `AVG(volume_injecte_m3)`
- **debit_total** : `SUM(debit_moyen_m3_h)`
- **debit_moyen** : `AVG(debit_moyen_m3_h)`

#### **Métriques Opérationnelles**
- **nombre_injections** : `COUNT(*)`
- **taux_disponibilite** : `(COUNT(CASE WHEN statut_injection = 'NORMAL' THEN 1 END) * 100.0 / COUNT(*))`
- **nombre_arrets** : `COUNT(CASE WHEN statut_injection = 'ARRETE' THEN 1 END)`
- **nombre_reductions** : `COUNT(CASE WHEN statut_injection = 'REDUIT' THEN 1 END)`

#### **Métriques Techniques**
- **temperature_moyenne** : `AVG(temperature_gaz_celsius)`
- **pression_moyenne** : `AVG(pression_injection_bar)`
- **duree_moyenne** : `AVG(duree_injection_minutes)`

---

## 🎯 **Synthèse par Type Sémantique**

### **📊 FACTS (15 colonnes)**
| **Table** | **Facts** | **Usage Principal** |
|-----------|-----------|-------------------|
| INJECTION_FACT | 6 | Métriques opérationnelles |
| SITE_DIM | 1 | Capacité de production |
| RESEAU_DIM | 2 | Capacité réseau et pression |
| QUALITE_DIM | 6 | Paramètres physicochimiques |

### **🏷️ DIMENSIONS (32 colonnes)**
| **Table** | **Dimensions** | **Usage Principal** |
|-----------|----------------|-------------------|
| SITE_DIM | 11 | Caractéristiques sites |
| RESEAU_DIM | 9 | Infrastructure réseau |
| QUALITE_DIM | 6 | Métadonnées analyses |
| INJECTION_FACT | 6 | Références et statuts |

### **⏰ TIME DIMENSIONS (9 colonnes)**
| **Table** | **Time Dimensions** | **Hiérarchie** |
|-----------|-------------------|----------------|
| TEMPS_DIM | 8 | Date → Année → Trimestre → Mois |
| QUALITE_DIM | 1 | Timestamp précis analyses |

### **🔍 NAMED FILTERS (22 filtres)**
| **Catégorie** | **Filtres** | **Exemples** |
|---------------|-------------|--------------|
| Opérationnels | 8 | Sites actifs, Injections normales |
| Temporels | 5 | Jours ouvrés, Weekend, Fériés |
| Techniques | 5 | Haute pression, Haute capacité |
| Qualité | 4 | Conformes, H2S élevé, PCS optimal |

### **📈 METRICS (36+ métriques)**
| **Catégorie** | **Métriques** | **KPI Principal** |
|---------------|---------------|------------------|
| Énergétiques | 4 | ⭐ energie_totale (MWh) |
| Volumétriques | 4 | volume_total (m³) |
| Opérationnelles | 8 | taux_disponibilite (%) |
| Capacités | 6 | capacite_totale (MWh/j) |
| Qualité | 8 | taux_conformite (%) |
| Infrastructure | 6 | nombre_postes, zones |

---

## 🎯 **Recommandations d'Usage**

### **🏷️ Pour les DIMENSIONS**
- **Grouper par** : region, technologie, statut_operationnel
- **Filtrer sur** : nom_site, nom_producteur, zone_reseau
- **Drill-down** : region → departement → site

### **⏰ Pour les TIME DIMENSIONS**
- **Hiérarchie principale** : annee → trimestre → mois → date
- **Analyses temporelles** : Tendances, saisonnalité, cycles
- **Filtres temporels** : Périodes, jours fériés, weekend

### **📊 Pour les FACTS**
- **Agrégations** : SUM, AVG, MIN, MAX
- **KPI principal** : energie_injectee_mwh
- **Ratios** : volume/capacite, energie/temps

### **🔍 Pour les NAMED FILTERS**
- **Simplification** : Requêtes business courantes
- **Performance** : Filtres pré-optimisés
- **Gouvernance** : Logique business centralisée

### **📈 Pour les METRICS**
- **KPIs prêts** : Calculs business pré-définis
- **Benchmarking** : Comparaisons automatiques
- **Alerting** : Seuils et déviations

---

## 🚀 **Exemple d'Utilisation dans la Vue Sémantique**

```sql
-- Structure optimale pour Cortex Analyst
CREATE SEMANTIC VIEW NATRAN_VIEW
    tables (...)
    facts (
        -- FACTS principaux
        INJECTIONS.ENERGIE_INJECTEE_MWH as energie,
        INJECTIONS.VOLUME_INJECTE_M3 as volume,
        SITES.CAPACITE_NOMINALE_MWH_JOUR as capacite
    )
    dimensions (
        -- DIMENSIONS business
        SITES.REGION as region,
        SITES.TECHNOLOGIE_PRODUCTION as technologie,
        RESEAU.ZONE_GEOGRAPHIQUE_RESEAU as zone_reseau,
        QUALITE.STATUT_CONFORMITE as conformite
    )
    time_dimensions (
        -- TIME DIMENSIONS avec hiérarchies
        TEMPS.DATE_COMPLETE as date,
        TEMPS.ANNEE as annee,
        TEMPS.TRIMESTRE as trimestre,
        TEMPS.MOIS_NOM as mois
    )
    metrics (
        -- METRICS calculées
        SUM(energie) as energie_totale,
        AVG(energie) as energie_moyenne,
        COUNT(*) as nombre_injections
    )
    named_filters (
        -- NAMED FILTERS prédéfinis
        sites_actifs: "statut_operationnel = 'ACTIF'",
        jours_ouvres: "est_ferie = FALSE AND jour_semaine NOT IN ('Samedi','Dimanche')"
    );
```

Cette classification optimise la vue sémantique pour des **analyses en langage naturel très performantes** avec Cortex Analyst ! 🎯
