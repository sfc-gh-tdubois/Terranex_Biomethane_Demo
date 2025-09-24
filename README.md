# 🌱 Terranex Biométhane - Demo Snowflake Intelligence

> **Demo complète Snowflake Intelligence pour l'analyse de production de biométhane avec agents IA, ML et recherche documentaire**

## 📋 Vue d'ensemble

Ce projet démontre les capacités de **Snowflake Intelligence** à travers un cas d'usage réaliste : l'analyse de la production de biométhane par **Terranex**, entreprise française spécialisée dans la valorisation énergétique des déchets.

### 🎯 Objectifs de la démo

- **Données volumineuses** : 10,000 injections biométhane sur 50 sites
- **Documents non structurés** : 120+ documents (réglementation, procédures, techniques, contrats)
- **Intelligence artificielle** : 3 agents IA spécialisés avec capacités différentes
- **Machine Learning** : Modèle de prédiction de production
- **Recherche sémantique** : 5 services Cortex Search spécialisés

## 🏗️ Architecture

```
DB_TERRANEX
├── PRODUCTION (Schema)
│   ├── 📊 DONNÉES STRUCTURÉES
│   │   ├── SITE_DIM (50 sites)
│   │   ├── TEMPS_DIM (1,000 dates)
│   │   ├── RESEAU_DIM (100 postes)
│   │   ├── QUALITE_DIM (500 analyses)
│   │   └── INJECTION_FACT (10,000 injections)
│   │
│   ├── 🧠 COUCHE ANALYTIQUE
│   │   ├── TERRANEX_BIOMETHANE_ANALYTICS_VIEW
│   │   └── ML_TRAINING_DATA
│   │
│   ├── 📄 DOCUMENTS NON STRUCTURÉS
│   │   ├── TERRANEX_DOCUMENTS_STAGE
│   │   └── TERRANEX_PARSED_CONTENT (4 documents parsés)
│   │
│   ├── 🔍 CORTEX SEARCH (5 services)
│   │   ├── SEARCH_ALL_TERRANEX_DOCS
│   │   ├── SEARCH_REGLEMENTATION_TERRANEX
│   │   ├── SEARCH_PROCEDURES_TERRANEX
│   │   ├── SEARCH_TECHNIQUES_TERRANEX
│   │   └── SEARCH_CONTRATS_TERRANEX
│   │
│   ├── 🤖 MACHINE LEARNING
│   │   ├── TERRANEX_PRODUCTION_PREDICTOR (Model Registry)
│   │   └── PREDICT_TERRANEX_PRODUCTION() (Stored Procedure)
│   │
│   └── ❓ BASE DE CONNAISSANCES
│       └── TERRANEX_QUESTIONS_BASE (29 questions types)
```

## 🚀 Installation rapide

### Prérequis
- Compte Snowflake avec Snowflake Intelligence activé
- Rôle `SF_Intelligence_Demo` avec permissions appropriées
- Warehouse `TERRANEX_WH`

### Déploiement en 10 étapes

```bash
# 1. Cloner le repository
git clone https://github.com/sfc-gh-tdubois/Terranex_Biomethane_Demo.git
cd Terranex_Biomethane_Demo

# 2-13. Exécuter les scripts dans l'ordre
snow sql -f sql_scripts/01_setup_database_and_tables.sql
snow sql -f sql_scripts/02_insert_bulk_data.sql
snow sql -f sql_scripts/03_create_semantic_layer.sql
# ... (voir section Scripts ci-dessous)
```

## 📁 Structure du projet

### Scripts SQL (ordre d'exécution)

| Script | Description | Objets créés |
|--------|-------------|--------------|
| `01_setup_database_and_tables.sql` | Base DB_TERRANEX + 5 tables | Database, Schema, Tables |
| `02_insert_bulk_data.sql` | Insertion données volumineuses | 11,650 enregistrements |
| `03_create_semantic_layer.sql` | Vue analytique multi-tables | Vue avec jointures |
| `04_create_agent_1.sql` | Agent analyse production | Spécifications agent |
| `05_create_stage_and_upload.sql` | Stage + upload documents | Stage + 38 fichiers |
| `06_parse_documents.sql` | Parsing contenu documents | Table parsed content |
| `07_create_cortex_search.sql` | Services recherche sémantique | 5 services Cortex |
| `08_create_agent_2.sql` | Agent expert documents | Spécifications agent |
| `09_create_ml_model_complete.sql` | ML Model + Registry + Procedure | Modèle + Procédure |
| `10_create_agent_3_complete.sql` | Agent expert complet + questions | Agent + 29 questions |

### Documents Terranex

```
terranex_documents/
├── reglementation_cre/     # 10 fichiers CRE + Arrêtés
├── procedures_internes/    # 15 procédures exploitation/maintenance/qualité
├── documents_techniques/   # 8 manuels par technologie (4 techs × 2 docs)
└── contrats/              # 20+ contrats production régionaux
```

## 🤖 Agents IA Terranex

### Agent 1: Analyste Production
- **Spécialité** : Analyse des données de production
- **Données** : Vue `TERRANEX_BIOMETHANE_ANALYTICS_VIEW`
- **Capacités** : KPIs, performances, comparaisons sites/régions

### Agent 2: Expert Documents
- **Spécialité** : Recherche et analyse documentaire
- **Outils** : 5 services Cortex Search spécialisés
- **Capacités** : Réglementation, procédures, techniques, contrats

### Agent 3: Expert Complet ⭐
- **Spécialité** : Analyses multi-sources complètes
- **Outils** : Données + Documents + ML
- **Capacités** : 29 questions de base + analyses prédictives
- **Unique** : Combine historique + réglementation + prédictions

## 📊 Données de démonstration

### Volume de données
- **50 sites** de production répartis sur 13 régions françaises
- **1,000 dates** avec gestion des jours fériés
- **100 postes** réseau (MP/HP/THP : 20/40/67 bars)
- **500 analyses** qualité (PCS, Wobbe, H2S, CO2)
- **10,000 injections** biométhane avec statuts réalistes

### Technologies représentées
1. **Méthanisation Liquide** (facteur 1.0)
2. **Méthanisation Sèche** (facteur 0.95)
3. **Pyrogazéification** (facteur 1.1)
4. **Gazéification Plasma** (facteur 1.15)

### Métriques clés
- **Production totale** : ~1.49M MWh
- **Volume total** : ~95.5M m³
- **Taux conformité** : ~90% (simulation réaliste)
- **Capacité moyenne** : ~150 MWh/jour par site

## 🔍 Services Cortex Search

| Service | Spécialisation | Documents |
|---------|----------------|-----------|
| `SEARCH_ALL_TERRANEX_DOCS` | Recherche globale | Tous types |
| `SEARCH_REGLEMENTATION_TERRANEX` | Réglementation CRE | Spécifications + Arrêtés |
| `SEARCH_PROCEDURES_TERRANEX` | Procédures internes | Exploitation + Maintenance + Qualité |
| `SEARCH_TECHNIQUES_TERRANEX` | Documentation technique | Manuels + Guides par technologie |
| `SEARCH_CONTRATS_TERRANEX` | Contrats commerciaux | Accords production régionaux |

## 🤖 Machine Learning

### Modèle de prédiction
- **Type** : RandomForest Regressor (Python/scikit-learn)
- **Features** : 8 variables (capacité, technologie, saison, qualité)
- **Target** : Énergie injectée (MWh/jour)
- **Entraînement** : 8,500 échantillons historiques

### Stored Procedure
```sql
CALL PREDICT_TERRANEX_PRODUCTION(site_id, mois_prediction);
```

**Exemple** :
```sql
CALL PREDICT_TERRANEX_PRODUCTION(1, 12);
-- Retourne: Prédiction détaillée pour le site 1 en décembre
```

## 🎯 Cas d'usage démo

### 1. Analyse de performance
```sql
-- Top 5 des sites par production
SELECT nom_site, region, SUM(energie_mwh) as production_totale
FROM TERRANEX_BIOMETHANE_ANALYTICS_VIEW 
GROUP BY nom_site, region 
ORDER BY production_totale DESC 
LIMIT 5;
```

### 2. Recherche réglementaire
```sql
-- Recherche spécifications H2S
SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SEARCH_REGLEMENTATION_TERRANEX',
    'spécifications H2S seuils qualité',
    OBJECT_CONSTRUCT('limit', 3)
);
```

### 3. Prédiction ML
```sql
-- Prédiction production site Normandie en hiver
CALL PREDICT_TERRANEX_PRODUCTION(1, 12);
```

## 👥 Public cible

### Solution Engineers Snowflake
- Démonstration complète des capacités Snowflake Intelligence
- Cas d'usage énergétique français réaliste
- Architecture reproductible pour autres secteurs

### Prospects & Clients
- Entreprises énergétiques (ENR, gaz, électricité)
- Industriels avec besoins analytics + IA
- Organisations avec documentation complexe

### Partenaires & Intégrateurs
- Template pour projets similaires
- Bonnes pratiques Snowflake Intelligence
- Accélérateur de déploiement

## 🔧 Configuration technique

### Permissions requises
```sql
-- Rôle principal
ROLE: SF_Intelligence_Demo

-- Permissions minimales
GRANT CREATE DATABASE ON ACCOUNT TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON WAREHOUSE TERRANEX_WH TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON DATABASE SNOWFLAKE_INTELLIGENCE TO ROLE SF_Intelligence_Demo;
GRANT CREATE AGENT ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE SF_Intelligence_Demo;
```

### Ressources consommées
- **Warehouse** : TERRANEX_WH (SMALL - auto-suspend 5min)
- **Storage** : ~50MB (données + documents)
- **Compute** : Minimal (analytics ponctuelles)

## 📈 Extensions possibles

### Données supplémentaires
- [ ] Données météorologiques (impact saisonnier)
- [ ] Cours du gaz (analyse économique)
- [ ] Maintenance prédictive (pannes équipements)

### Fonctionnalités avancées
- [ ] Alertes temps réel (qualité, production)
- [ ] Dashboard Streamlit intégré
- [ ] API REST pour intégrations externes
- [ ] Modèles ML plus complexes (deep learning)

### Agents spécialisés
- [ ] Agent conformité réglementaire
- [ ] Agent optimisation économique
- [ ] Agent maintenance prédictive

## 🆘 Support & Contact

### Auteur
**Thomas Dubois** - Solution Engineer Snowflake  
GitHub: [@sfc-gh-tdubois](https://github.com/sfc-gh-tdubois)

### Issues & Contributions
- Ouvrir une issue pour bugs ou questions
- Pull requests bienvenues pour améliorations
- Documentation collaborative encouragée

### Ressources Snowflake
- [Snowflake Intelligence Documentation](https://docs.snowflake.com/en/user-guide/snowflake-intelligence)
- [Cortex Search Guide](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search)
- [Model Registry Documentation](https://docs.snowflake.com/en/user-guide/ml-models)

---

## 🏆 Résultats attendus

Après déploiement complet, vous disposerez de :

✅ **Infrastructure complète** DB_TERRANEX opérationnelle  
✅ **11,650 enregistrements** de données volumineuses  
✅ **120+ documents** Terranex organisés et indexés  
✅ **5 services** Cortex Search spécialisés  
✅ **3 agents IA** avec capacités complémentaires  
✅ **1 modèle ML** de prédiction avec 8,500 échantillons  
✅ **29 questions** de base pour démarrer les démos  

**🚀 Prêt pour démonstrations client en production !**
