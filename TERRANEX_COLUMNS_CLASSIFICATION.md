# 📋 Classification des Colonnes - Modèle Terranex Biométhane
## Liste Détaillée par Table et Type Sémantique

---

## 🏭 **TABLE 1 : SITE_DIM**

### **🏷️ DIMENSIONS (11 colonnes)**
- `id_site` - Identifiant unique du site
- `nom_site` - Nom du site de méthanisation
- `id_producteur` - Identifiant du producteur
- `nom_producteur` - Nom de l'entreprise exploitante
- `technologie_production` - Type de procédé (méthanisation, pyrogazéification)
- `type_intrants` - Matières premières utilisées
- `region` - Région administrative française
- `departement` - Département français
- `code_postal` - Code postal du site
- `statut_operationnel` - ACTIF/MAINTENANCE/ARRETE
- `coordonnees_gps` - Géolocalisation (latitude,longitude)

### **⏰ TIME DIMENSIONS (1 colonne)**
- `date_mise_en_service` - Date de démarrage du site

### **📊 FACTS (1 colonne)**
- `capacite_nominale_mwh_jour` - Capacité théorique en MWh/jour

### **🔍 NAMED FILTERS (3 filtres)**
- `sites_actifs` : `statut_operationnel = 'ACTIF'`
- `sites_haute_capacite` : `capacite_nominale_mwh_jour > 25`
- `sites_recent` : `date_mise_en_service >= '2020-01-01'`

### **📈 METRICS (4 métriques)**
- `nombre_sites` : `COUNT(DISTINCT id_site)`
- `capacite_totale` : `SUM(capacite_nominale_mwh_jour)`
- `capacite_moyenne` : `AVG(capacite_nominale_mwh_jour)`
- `nombre_producteurs` : `COUNT(DISTINCT id_producteur)`

---

## ⏰ **TABLE 2 : TEMPS_DIM**

### **⏰ TIME DIMENSIONS (8 colonnes)**
- `id_temps` - Clé primaire temporelle (YYYYMMDD)
- `date_complete` - Date complète (dimension temporelle principale)
- `annee` - Année (hiérarchie niveau 1)
- `trimestre` - Trimestre T1-T4 (hiérarchie niveau 2)
- `mois_nom` - Nom du mois français (hiérarchie niveau 3)
- `semaine_numero` - Numéro de semaine dans l'année
- `jour_de_la_semaine` - Jour en français (Lundi-Dimanche)
- `est_ferie` - Indicateur booléen jour férié français

### **🏷️ DIMENSIONS (1 colonne)**
- `nom_ferie` - Nom du jour férié français

### **🔍 NAMED FILTERS (5 filtres)**
- `jours_ouvres` : `est_ferie = FALSE AND jour_de_la_semaine NOT IN ('Samedi', 'Dimanche')`
- `weekend` : `jour_de_la_semaine IN ('Samedi', 'Dimanche')`
- `jours_feries` : `est_ferie = TRUE`
- `periode_hiver` : `trimestre = 'T1'`
- `periode_ete` : `trimestre = 'T3'`

### **📈 METRICS (4 métriques)**
- `nombre_jours` : `COUNT(DISTINCT id_temps)`
- `nombre_jours_feries` : `COUNT(CASE WHEN est_ferie = TRUE THEN 1 END)`
- `nombre_semaines` : `COUNT(DISTINCT semaine_numero)`
- `nombre_mois` : `COUNT(DISTINCT mois_nom)`

---

## 🌐 **TABLE 3 : RESEAU_DIM**

### **🏷️ DIMENSIONS (9 colonnes)**
- `id_poste_reseau` - Identifiant unique du poste
- `nom_poste_injection` - Nom/code du poste Terranex
- `responsable_exploitation_reseau` - Équipe en charge
- `zone_geographique_reseau` - Découpage interne Terranex
- `type_poste` - Classification technique (HP, MP, THT, Test)
- `statut_operationnel` - ACTIF/MAINTENANCE/ARRETE
- `coordonnees_gps` - Géolocalisation du poste

### **⏰ TIME DIMENSIONS (1 colonne)**
- `date_mise_en_service` - Date de mise en service du poste

### **📊 FACTS (2 colonnes)**
- `niveau_pression_bar` - Pression en bars (40=MP, 67=HP)
- `capacite_injection_max_nm3_h` - Capacité maximale en Nm³/h

### **🔍 NAMED FILTERS (4 filtres)**
- `postes_haute_pression` : `niveau_pression_bar >= 67`
- `postes_moyenne_pression` : `niveau_pression_bar = 40`
- `postes_haute_capacite` : `capacite_injection_max_nm3_h > 15000`
- `postes_pilotes` : `zone_geographique_reseau = 'Zone Pilote'`

### **📈 METRICS (5 métriques)**
- `nombre_postes` : `COUNT(DISTINCT id_poste_reseau)`
- `capacite_totale_reseau` : `SUM(capacite_injection_max_nm3_h)`
- `capacite_moyenne_postes` : `AVG(capacite_injection_max_nm3_h)`
- `nombre_zones` : `COUNT(DISTINCT zone_geographique_reseau)`
- `nombre_equipes` : `COUNT(DISTINCT responsable_exploitation_reseau)`

---

## 🧪 **TABLE 4 : QUALITE_DIM**

### **🏷️ DIMENSIONS (6 colonnes)**
- `id_analyse_qualite` - Identifiant unique de l'analyse
- `statut_conformite` - Conforme/Non-conforme/Dérogation
- `laboratoire_analyse` - Laboratoire Terranex responsable
- `methode_analyse` - Technique chromatographique (GC-MS, GC-FID, GC-TCD)
- `operateur_analyse` - Technicien responsable
- `commentaires` - Observations détaillées

### **⏰ TIME DIMENSIONS (1 colonne)**
- `timestamp_analyse` - Date/heure précise de l'analyse

### **📊 FACTS (6 colonnes)**
- `pcs_kwh_m3` - Pouvoir Calorifique Supérieur en kWh/m³
- `wobbe_index` - Indice d'interchangeabilité des gaz
- `teneur_h2s_ppm` - Sulfure d'hydrogène en ppm (toxique)
- `teneur_co2_pourcentage` - Dioxyde de carbone en %
- `temperature_analyse_celsius` - Température lors de l'analyse
- `pression_analyse_bar` - Pression lors de l'analyse

### **🔍 NAMED FILTERS (4 filtres)**
- `analyses_conformes` : `statut_conformite = 'Conforme'`
- `analyses_problematiques` : `statut_conformite != 'Conforme'`
- `h2s_eleve` : `teneur_h2s_ppm > 5.0`
- `pcs_optimal` : `pcs_kwh_m3 >= 10.8`

### **📈 METRICS (8 métriques)**
- `nombre_analyses` : `COUNT(DISTINCT id_analyse_qualite)`
- `taux_conformite` : `(COUNT(CASE WHEN statut_conformite = 'Conforme' THEN 1 END) * 100.0 / COUNT(*))`
- `pcs_moyen` : `AVG(pcs_kwh_m3)`
- `wobbe_moyen` : `AVG(wobbe_index)`
- `h2s_moyen` : `AVG(teneur_h2s_ppm)`
- `co2_moyen` : `AVG(teneur_co2_pourcentage)`
- `nombre_non_conformes` : `COUNT(CASE WHEN statut_conformite = 'Non-conforme' THEN 1 END)`
- `nombre_derogations` : `COUNT(CASE WHEN statut_conformite = 'Conforme avec dérogation' THEN 1 END)`

---

## 📊 **TABLE 5 : INJECTION_FACT (Table de Faits Centrale)**

### **🏷️ DIMENSIONS (6 colonnes)**
- `id_injection` - Identifiant unique de l'injection
- `id_site` - Référence vers SITE_DIM
- `id_temps` - Référence vers TEMPS_DIM
- `id_poste_reseau` - Référence vers RESEAU_DIM
- `id_analyse_qualite` - Référence vers QUALITE_DIM (optionnel)
- `statut_injection` - NORMAL/REDUIT/ARRETE

### **📊 FACTS (6 colonnes)**
- `volume_injecte_m3` - Volume en mètres cubes ⭐ **FACT PRINCIPAL**
- `energie_injectee_mwh` - Énergie en MWh ⭐ **KPI PRINCIPAL TERRANEX**
- `debit_moyen_m3_h` - Débit horaire moyen
- `pression_injection_bar` - Pression d'injection
- `temperature_gaz_celsius` - Température du gaz
- `duree_injection_minutes` - Durée de l'injection

### **🔍 NAMED FILTERS (6 filtres)**
- `injections_normales` : `statut_injection = 'NORMAL'`
- `injections_reduites` : `statut_injection = 'REDUIT'`
- `injections_arretees` : `statut_injection = 'ARRETE'`
- `haute_production` : `energie_injectee_mwh > 20`
- `avec_analyse_qualite` : `id_analyse_qualite IS NOT NULL`
- `periode_recente` : `id_temps >= 20240101`

### **📈 METRICS (15 métriques)**

#### **Énergétiques (KPI Principal)**
- `energie_totale` : `SUM(energie_injectee_mwh)`
- `energie_moyenne` : `AVG(energie_injectee_mwh)`
- `energie_maximale` : `MAX(energie_injectee_mwh)`
- `energie_minimale` : `MIN(energie_injectee_mwh)`

#### **Volumétriques**
- `volume_total` : `SUM(volume_injecte_m3)`
- `volume_moyen` : `AVG(volume_injecte_m3)`
- `debit_total` : `SUM(debit_moyen_m3_h)`
- `debit_moyen` : `AVG(debit_moyen_m3_h)`

#### **Opérationnelles**
- `nombre_injections` : `COUNT(*)`
- `taux_disponibilite` : `(COUNT(CASE WHEN statut_injection = 'NORMAL' THEN 1 END) * 100.0 / COUNT(*))`
- `nombre_arrets` : `COUNT(CASE WHEN statut_injection = 'ARRETE' THEN 1 END)`
- `nombre_reductions` : `COUNT(CASE WHEN statut_injection = 'REDUIT' THEN 1 END)`

#### **Techniques**
- `temperature_moyenne` : `AVG(temperature_gaz_celsius)`
- `pression_moyenne` : `AVG(pression_injection_bar)`
- `duree_moyenne` : `AVG(duree_injection_minutes)`

---

## 📊 **SYNTHÈSE GLOBALE**

### **📈 RÉPARTITION PAR TYPE**
| **Type** | **Total** | **Distribution** |
|----------|-----------|------------------|
| **DIMENSIONS** | 32 | Sites(11) + Réseau(9) + Qualité(6) + Injection(6) |
| **TIME DIMENSIONS** | 10 | Temps(8) + Sites(1) + Réseau(1) |
| **FACTS** | 15 | Injection(6) + Qualité(6) + Réseau(2) + Sites(1) |
| **NAMED FILTERS** | 22 | 3-6 par table selon complexité |
| **METRICS** | 36 | Injection(15) + Qualité(8) + Réseau(5) + Sites(4) + Temps(4) |

### **⭐ COLONNES CLÉS PAR PRIORITÉ**

#### **🎯 KPIs Principaux (FACTS)**
1. `energie_injectee_mwh` - **KPI #1 Terranex**
2. `volume_injecte_m3` - Métrique opérationnelle
3. `capacite_nominale_mwh_jour` - Potentiel théorique
4. `pcs_kwh_m3` - Qualité énergétique

#### **🏷️ Dimensions Business Critiques**
1. `region` - Analyses géographiques
2. `technologie_production` - Comparaisons techniques
3. `statut_conformite` - Conformité réglementaire
4. `zone_geographique_reseau` - Infrastructure
5. `statut_injection` - État opérationnel

#### **⏰ Hiérarchies Temporelles**
1. `date_complete` → `annee` → `trimestre` → `mois_nom`
2. `semaine_numero` → `jour_de_la_semaine`
3. `est_ferie` → `nom_ferie`
4. `timestamp_analyse` (précision horaire)

---

## 🎯 **USAGE RECOMMANDÉ DANS VUE SÉMANTIQUE**

### **Tables Configuration**
```sql
tables (
    INJECTIONS as INJECTION_FACT primary key (ID_INJECTION),
    SITES as SITE_DIM primary key (ID_SITE),
    CALENDRIER as TEMPS_DIM primary key (ID_TEMPS),
    RESEAU as RESEAU_DIM primary key (ID_POSTE_RESEAU),
    QUALITE as QUALITE_DIM primary key (ID_ANALYSE_QUALITE)
)
```

### **Facts Configuration**
```sql
facts (
    -- KPI Principal Terranex
    INJECTIONS.ENERGIE_INJECTEE_MWH as energie,
    INJECTIONS.VOLUME_INJECTE_M3 as volume,
    INJECTIONS.DEBIT_MOYEN_M3_H as debit,
    
    -- Capacités
    SITES.CAPACITE_NOMINALE_MWH_JOUR as capacite_site,
    RESEAU.CAPACITE_INJECTION_MAX_NM3_H as capacite_reseau,
    
    -- Qualité
    QUALITE.PCS_KWH_M3 as pcs,
    QUALITE.WOBBE_INDEX as wobbe,
    QUALITE.TENEUR_H2S_PPM as h2s,
    QUALITE.TENEUR_CO2_POURCENTAGE as co2
)
```

### **Dimensions Configuration**
```sql
dimensions (
    -- Géographiques
    SITES.REGION as region,
    SITES.DEPARTEMENT as departement,
    RESEAU.ZONE_GEOGRAPHIQUE_RESEAU as zone_reseau,
    
    -- Techniques
    SITES.TECHNOLOGIE_PRODUCTION as technologie,
    SITES.TYPE_INTRANTS as intrants,
    RESEAU.TYPE_POSTE as type_poste,
    RESEAU.NIVEAU_PRESSION_BAR as pression_reseau,
    
    -- Opérationnelles
    SITES.STATUT_OPERATIONNEL as statut_site,
    RESEAU.STATUT_OPERATIONNEL as statut_poste,
    INJECTIONS.STATUT_INJECTION as statut_injection,
    QUALITE.STATUT_CONFORMITE as conformite,
    
    -- Organisationnelles
    SITES.NOM_PRODUCTEUR as producteur,
    RESEAU.RESPONSABLE_EXPLOITATION_RESEAU as equipe_reseau,
    QUALITE.LABORATOIRE_ANALYSE as laboratoire
)
```

### **Time Dimensions Configuration**
```sql
time_dimensions (
    -- Hiérarchie principale
    CALENDRIER.DATE_COMPLETE as date,
    CALENDRIER.ANNEE as annee,
    CALENDRIER.TRIMESTRE as trimestre,
    CALENDRIER.MOIS_NOM as mois,
    
    -- Cycles hebdomadaires
    CALENDRIER.SEMAINE_NUMERO as semaine,
    CALENDRIER.JOUR_DE_LA_SEMAINE as jour_semaine,
    
    -- Événements spéciaux
    CALENDRIER.EST_FERIE as est_ferie,
    CALENDRIER.NOM_FERIE as nom_ferie,
    
    -- Analyses qualité
    QUALITE.TIMESTAMP_ANALYSE as timestamp_qualite
)
```

---

## 📋 **LISTE COMPLÈTE ALPHABÉTIQUE**

### **A-C**
- `annee` - ⏰ TIME DIMENSION
- `capacite_injection_max_nm3_h` - 📊 FACT
- `capacite_nominale_mwh_jour` - 📊 FACT
- `code_postal` - 🏷️ DIMENSION
- `commentaires` - 🏷️ DIMENSION
- `coordonnees_gps` (SITE_DIM) - 🏷️ DIMENSION
- `coordonnees_gps` (RESEAU_DIM) - 🏷️ DIMENSION

### **D-I**
- `date_complete` - ⏰ TIME DIMENSION
- `date_mise_en_service` (SITE_DIM) - ⏰ TIME DIMENSION
- `date_mise_en_service` (RESEAU_DIM) - ⏰ TIME DIMENSION
- `debit_moyen_m3_h` - 📊 FACT
- `departement` - 🏷️ DIMENSION
- `duree_injection_minutes` - 📊 FACT
- `energie_injectee_mwh` - 📊 FACT ⭐ **KPI PRINCIPAL**
- `est_ferie` - ⏰ TIME DIMENSION
- `id_analyse_qualite` (QUALITE_DIM) - 🏷️ DIMENSION
- `id_analyse_qualite` (INJECTION_FACT) - 🏷️ DIMENSION
- `id_injection` - 🏷️ DIMENSION
- `id_poste_reseau` (RESEAU_DIM) - 🏷️ DIMENSION
- `id_poste_reseau` (INJECTION_FACT) - 🏷️ DIMENSION
- `id_producteur` - 🏷️ DIMENSION
- `id_site` (SITE_DIM) - 🏷️ DIMENSION
- `id_site` (INJECTION_FACT) - 🏷️ DIMENSION
- `id_temps` (TEMPS_DIM) - ⏰ TIME DIMENSION
- `id_temps` (INJECTION_FACT) - 🏷️ DIMENSION

### **J-N**
- `jour_de_la_semaine` - ⏰ TIME DIMENSION
- `laboratoire_analyse` - 🏷️ DIMENSION
- `methode_analyse` - 🏷️ DIMENSION
- `mois_nom` - ⏰ TIME DIMENSION
- `niveau_pression_bar` - 📊 FACT
- `nom_ferie` - 🏷️ DIMENSION
- `nom_poste_injection` - 🏷️ DIMENSION
- `nom_producteur` - 🏷️ DIMENSION
- `nom_site` - 🏷️ DIMENSION

### **O-S**
- `operateur_analyse` - 🏷️ DIMENSION
- `pcs_kwh_m3` - 📊 FACT
- `pression_analyse_bar` - 📊 FACT
- `pression_injection_bar` - 📊 FACT
- `region` - 🏷️ DIMENSION
- `responsable_exploitation_reseau` - 🏷️ DIMENSION
- `semaine_numero` - ⏰ TIME DIMENSION
- `statut_conformite` - 🏷️ DIMENSION
- `statut_injection` - 🏷️ DIMENSION
- `statut_operationnel` (SITE_DIM) - 🏷️ DIMENSION
- `statut_operationnel` (RESEAU_DIM) - 🏷️ DIMENSION

### **T-Z**
- `technologie_production` - 🏷️ DIMENSION
- `temperature_analyse_celsius` - 📊 FACT
- `temperature_gaz_celsius` - 📊 FACT
- `teneur_co2_pourcentage` - 📊 FACT
- `teneur_h2s_ppm` - 📊 FACT
- `timestamp_analyse` - ⏰ TIME DIMENSION
- `trimestre` - ⏰ TIME DIMENSION
- `type_intrants` - 🏷️ DIMENSION
- `type_poste` - 🏷️ DIMENSION
- `volume_injecte_m3` - 📊 FACT
- `wobbe_index` - 📊 FACT
- `zone_geographique_reseau` - 🏷️ DIMENSION

---

## 🎯 **RECOMMANDATIONS D'IMPLÉMENTATION**

### **🏷️ DIMENSIONS - Usage Principal**
- **Filtrage** : `WHERE region = 'Hauts-de-France'`
- **Groupement** : `GROUP BY technologie_production`
- **Drill-down** : `region → departement → nom_site`

### **⏰ TIME DIMENSIONS - Hiérarchies**
- **Principale** : `date → annee → trimestre → mois`
- **Hebdomadaire** : `semaine → jour_semaine`
- **Événementielle** : `est_ferie → nom_ferie`

### **📊 FACTS - Agrégations**
- **Additives** : `SUM(energie_injectee_mwh)`, `SUM(volume_injecte_m3)`
- **Moyennes** : `AVG(debit_moyen_m3_h)`, `AVG(pcs_kwh_m3)`
- **Extremums** : `MAX(energie_injectee_mwh)`, `MIN(teneur_h2s_ppm)`

### **🔍 NAMED FILTERS - Simplification**
- **Business** : Filtres métier courants
- **Performance** : Requêtes pré-optimisées
- **Gouvernance** : Logique centralisée

### **📈 METRICS - KPIs Prêts**
- **Opérationnels** : Taux disponibilité, utilisation
- **Qualité** : Taux conformité, moyennes techniques
- **Capacité** : Totaux, moyennes, comparaisons

Cette classification permet une **vue sémantique optimale** pour Cortex Analyst et des analyses conversationnelles très riches ! 🚀
