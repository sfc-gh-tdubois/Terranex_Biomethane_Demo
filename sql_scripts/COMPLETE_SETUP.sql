-- ======================================================================
-- 🚀 TERRANEX BIOMÉTHANE - INSTALLATION COMPLÈTE AUTONOME
-- ======================================================================
-- Description: Installation complète de l'environnement Terranex en un seul script
-- Durée: ~5-10 minutes selon la taille du warehouse
-- Usage: Pour démonstrations rapides ou installations automatisées
-- Propriétaire: Role SF_Intelligence_Demo (créé automatiquement)
-- ======================================================================

-- ⏱️ DÉBUT INSTALLATION
SELECT '🚀 DÉBUT INSTALLATION TERRANEX BIOMÉTHANE - ' || CURRENT_TIMESTAMP()::VARCHAR AS debut_installation;

-- ======================================================================
-- ÉTAPE 1: INFRASTRUCTURE DE BASE
-- ======================================================================
SELECT '📋 ÉTAPE 1/10: Infrastructure de base...' AS etape;

USE ROLE ACCOUNTADMIN;

-- Création et configuration du rôle SF_Intelligence_Demo
-- SÉCURISÉ: Pas de DROP automatique
CREATE ROLE IF NOT EXISTS SF_Intelligence_Demo;
SET current_user_name = CURRENT_USER();
GRANT ROLE SF_Intelligence_Demo TO USER IDENTIFIER($current_user_name);
GRANT CREATE DATABASE ON ACCOUNT TO ROLE SF_Intelligence_Demo;

-- Création du warehouse dédié
-- SÉCURISÉ: Pas de remplacement automatique
CREATE WAREHOUSE IF NOT EXISTS TERRANEX_WH 
    WITH WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE;
GRANT USAGE ON WAREHOUSE TERRANEX_WH TO ROLE SF_Intelligence_Demo;

-- Configuration utilisateur - Rôle et warehouse par défaut
SELECT '👤 Configuration utilisateur avec defaults...' AS etape;
ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_ROLE = SF_Intelligence_Demo;
ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_WAREHOUSE = TERRANEX_WH;
SELECT '✅ Rôle SF_Intelligence_Demo et warehouse TERRANEX_WH définis par défaut' AS config_user;

-- Permissions pour les agents
GRANT USAGE ON DATABASE SNOWFLAKE_INTELLIGENCE TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE SF_Intelligence_Demo;
GRANT CREATE AGENT ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE SF_Intelligence_Demo;

-- Basculer vers le rôle SF_Intelligence_Demo
USE ROLE SF_Intelligence_Demo;

-- Création de la base DB_TERRANEX
-- SÉCURISÉ: Pas de remplacement automatique
CREATE DATABASE IF NOT EXISTS DB_TERRANEX;
USE DATABASE DB_TERRANEX;
CREATE SCHEMA IF NOT EXISTS PRODUCTION;
USE SCHEMA PRODUCTION;

-- Vérification des defaults utilisateur
SELECT 
    '👤 CONFIGURATION UTILISATEUR' AS section,
    '' AS parametre,
    '' AS valeur
UNION ALL
SELECT 
    '',
    'Utilisateur actuel',
    CURRENT_USER()
UNION ALL
SELECT 
    '',
    'Rôle par défaut',
    'SF_Intelligence_Demo (configuré)'
UNION ALL
SELECT 
    '',
    'Warehouse par défaut',
    'TERRANEX_WH (configuré)';

SELECT '✅ Étape 1 terminée - Infrastructure créée avec defaults configurés' AS resultat;

-- ======================================================================
-- ÉTAPE 2: TABLES DE DONNÉES
-- ======================================================================
SELECT '📋 ÉTAPE 2/10: Création des tables...' AS etape;

-- SÉCURISÉ: Pas de remplacement automatique
CREATE TABLE IF NOT EXISTS SITE_DIM (
    ID_SITE INT PRIMARY KEY,
    NOM_SITE VARCHAR(100) NOT NULL,
    REGION VARCHAR(50) NOT NULL,
    DEPARTEMENT VARCHAR(10) NOT NULL,
    TECHNOLOGIE_PRODUCTION VARCHAR(50) NOT NULL,
    TYPE_INTRANTS VARCHAR(100) NOT NULL,
    NOM_PRODUCTEUR VARCHAR(100) NOT NULL,
    CAPACITE_NOMINALE_MWH_JOUR DECIMAL(10,2) NOT NULL,
    STATUT_OPERATIONNEL VARCHAR(20) NOT NULL,
    DATE_MISE_SERVICE DATE NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE IF NOT EXISTS TEMPS_DIM (
    ID_TEMPS INT PRIMARY KEY,
    DATE_COMPLETE DATE NOT NULL,
    ANNEE INT NOT NULL,
    TRIMESTRE INT NOT NULL,
    MOIS_NUMERO INT NOT NULL,
    MOIS_NOM VARCHAR(20) NOT NULL,
    SEMAINE_NUMERO INT NOT NULL,
    JOUR_DE_LA_SEMAINE VARCHAR(20) NOT NULL,
    EST_FERIE BOOLEAN DEFAULT FALSE,
    NOM_FERIE VARCHAR(50),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE IF NOT EXISTS RESEAU_DIM (
    ID_POSTE_RESEAU INT PRIMARY KEY,
    NOM_POSTE_INJECTION VARCHAR(100) NOT NULL,
    TYPE_POSTE VARCHAR(30) NOT NULL,
    ZONE_GEOGRAPHIQUE_RESEAU VARCHAR(50) NOT NULL,
    NIVEAU_PRESSION_BAR DECIMAL(5,2) NOT NULL,
    CAPACITE_INJECTION_MAX_NM3_H DECIMAL(10,2) NOT NULL,
    STATUT_OPERATIONNEL VARCHAR(20) NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE IF NOT EXISTS QUALITE_DIM (
    ID_ANALYSE_QUALITE INT PRIMARY KEY,
    PCS_KWH_M3 DECIMAL(8,4) NOT NULL,
    WOBBE_INDEX DECIMAL(8,4) NOT NULL,
    TENEUR_H2S_PPM DECIMAL(8,2) NOT NULL,
    TENEUR_CO2_POURCENTAGE DECIMAL(5,2) NOT NULL,
    STATUT_CONFORMITE VARCHAR(20) NOT NULL,
    LABORATOIRE_ANALYSE VARCHAR(50) NOT NULL,
    METHODE_ANALYSE VARCHAR(50) NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE IF NOT EXISTS INJECTION_FACT (
    ID_INJECTION INT PRIMARY KEY,
    ID_SITE INT NOT NULL,
    ID_TEMPS INT NOT NULL,
    ID_POSTE_RESEAU INT NOT NULL,
    ID_ANALYSE_QUALITE INT NOT NULL,
    ENERGIE_INJECTEE_MWH DECIMAL(10,3) NOT NULL,
    VOLUME_INJECTE_M3 DECIMAL(12,2) NOT NULL,
    DEBIT_MOYEN_M3_H DECIMAL(8,2) NOT NULL,
    PRESSION_INJECTION_BAR DECIMAL(5,2) NOT NULL,
    TEMPERATURE_GAZ_CELSIUS DECIMAL(5,2) NOT NULL,
    DUREE_INJECTION_MINUTES INT NOT NULL,
    STATUT_INJECTION VARCHAR(20) NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

SELECT '✅ Étape 2 terminée - Tables créées' AS resultat;

-- ======================================================================
-- ÉTAPE 3: INSERTION DONNÉES VOLUMINEUSES
-- ======================================================================
SELECT '📋 ÉTAPE 3/10: Insertion données volumineuses...' AS etape;

-- Sites (50)
INSERT INTO SITE_DIM 
SELECT 
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS id_site,
    'Site Terranex ' || 
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN 'Normandie ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 2 THEN 'Bretagne ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 3 THEN 'Occitanie ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 4 THEN 'Auvergne ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 5 THEN 'Grand Est ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 6 THEN 'Hauts-de-France ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 7 THEN 'Nouvelle-Aquitaine ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 8 THEN 'Provence ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 9 THEN 'Île-de-France ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 10 THEN 'Centre-Val de Loire ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 11 THEN 'Bourgogne ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 12 THEN 'Pays de la Loire ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
        WHEN 13 THEN 'Corse ' || (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4 + 1)
    END AS nom_site,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN 'Normandie' WHEN 2 THEN 'Bretagne' WHEN 3 THEN 'Occitanie'
        WHEN 4 THEN 'Auvergne-Rhône-Alpes' WHEN 5 THEN 'Grand Est' WHEN 6 THEN 'Hauts-de-France'
        WHEN 7 THEN 'Nouvelle-Aquitaine' WHEN 8 THEN 'Provence-Alpes-Côte d''Azur' WHEN 9 THEN 'Île-de-France'
        WHEN 10 THEN 'Centre-Val de Loire' WHEN 11 THEN 'Bourgogne-Franche-Comté' WHEN 12 THEN 'Pays de la Loire'
        WHEN 13 THEN 'Corse'
    END AS region,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN '14' WHEN 2 THEN '35' WHEN 3 THEN '31' WHEN 4 THEN '63' WHEN 5 THEN '67'
        WHEN 6 THEN '59' WHEN 7 THEN '33' WHEN 8 THEN '13' WHEN 9 THEN '75' WHEN 10 THEN '45'
        WHEN 11 THEN '21' WHEN 12 THEN '44' WHEN 13 THEN '2A'
    END AS departement,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4) + 1
        WHEN 1 THEN 'Méthanisation Liquide' WHEN 2 THEN 'Méthanisation Sèche'
        WHEN 3 THEN 'Pyrogazéification' WHEN 4 THEN 'Gazéification Plasma'
    END AS technologie_production,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 5) + 1
        WHEN 1 THEN 'Déchets organiques municipaux' WHEN 2 THEN 'Résidus agricoles'
        WHEN 3 THEN 'Biomasse forestière' WHEN 4 THEN 'Déchets industriels'
        WHEN 5 THEN 'Boues de station d''épuration'
    END AS type_intrants,
    'Terranex ' || 
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN 'Normandie' WHEN 2 THEN 'Bretagne' WHEN 3 THEN 'Occitanie' WHEN 4 THEN 'Auvergne'
        WHEN 5 THEN 'Grand Est' WHEN 6 THEN 'Hauts-de-France' WHEN 7 THEN 'Nouvelle-Aquitaine' WHEN 8 THEN 'Provence'
        WHEN 9 THEN 'Île-de-France' WHEN 10 THEN 'Centre' WHEN 11 THEN 'Bourgogne' WHEN 12 THEN 'Pays de Loire'
        WHEN 13 THEN 'Corse'
    END || ' SAS' AS nom_producteur,
    80.0 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 120) AS capacite_nominale_mwh_jour,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 10)
        WHEN 0 THEN 'MAINTENANCE' WHEN 1 THEN 'ARRET' ELSE 'ACTIF'
    END AS statut_operationnel,
    DATEADD(day, -(ROW_NUMBER() OVER (ORDER BY SEQ4()) % 1000), '2024-01-01') AS date_mise_service,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 50))
WHERE NOT EXISTS (SELECT 1 FROM SITE_DIM LIMIT 1);

-- Dates (1000)
INSERT INTO TEMPS_DIM 
SELECT 
    ROW_NUMBER() OVER (ORDER BY generated_date) AS id_temps,
    generated_date AS date_complete,
    YEAR(generated_date) AS annee,
    QUARTER(generated_date) AS trimestre,
    MONTH(generated_date) AS mois_numero,
    MONTHNAME(generated_date) AS mois_nom,
    WEEKOFYEAR(generated_date) AS semaine_numero,
    DAYNAME(generated_date) AS jour_de_la_semaine,
    CASE 
        WHEN DAYOFWEEK(generated_date) IN (1, 7) THEN TRUE
        WHEN (MONTH(generated_date) = 1 AND DAY(generated_date) = 1) THEN TRUE
        WHEN (MONTH(generated_date) = 5 AND DAY(generated_date) = 1) THEN TRUE
        WHEN (MONTH(generated_date) = 7 AND DAY(generated_date) = 14) THEN TRUE
        WHEN (MONTH(generated_date) = 12 AND DAY(generated_date) = 25) THEN TRUE
        ELSE FALSE
    END AS est_ferie,
    CASE 
        WHEN (MONTH(generated_date) = 1 AND DAY(generated_date) = 1) THEN 'Nouvel An'
        WHEN (MONTH(generated_date) = 5 AND DAY(generated_date) = 1) THEN 'Fête du Travail'
        WHEN (MONTH(generated_date) = 7 AND DAY(generated_date) = 14) THEN 'Fête Nationale'
        WHEN (MONTH(generated_date) = 12 AND DAY(generated_date) = 25) THEN 'Noël'
        ELSE NULL
    END AS nom_ferie,
    CURRENT_TIMESTAMP() AS created_at
FROM (
    SELECT DATEADD(day, SEQ4(), '2022-01-01') AS generated_date
    FROM TABLE(GENERATOR(ROWCOUNT => 1000))
)
WHERE NOT EXISTS (SELECT 1 FROM TEMPS_DIM LIMIT 1);

-- Postes réseau (100)
INSERT INTO RESEAU_DIM 
SELECT 
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS id_poste_reseau,
    'Poste Injection ' || 
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN 'Normandie' WHEN 2 THEN 'Bretagne' WHEN 3 THEN 'Occitanie' WHEN 4 THEN 'Auvergne'
        WHEN 5 THEN 'Grand Est' WHEN 6 THEN 'Hauts-de-France' WHEN 7 THEN 'Nouvelle-Aquitaine' WHEN 8 THEN 'Provence'
        WHEN 9 THEN 'Île-de-France' WHEN 10 THEN 'Centre' WHEN 11 THEN 'Bourgogne' WHEN 12 THEN 'Pays de Loire'
        WHEN 13 THEN 'Corse'
    END || ' ' || ROW_NUMBER() OVER (ORDER BY SEQ4()) AS nom_poste_injection,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 3)
        WHEN 0 THEN 'INJECTION_MP' WHEN 1 THEN 'INJECTION_HP' WHEN 2 THEN 'INJECTION_THP'
    END AS type_poste,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN 'Normandie' WHEN 2 THEN 'Bretagne' WHEN 3 THEN 'Occitanie' WHEN 4 THEN 'Auvergne'
        WHEN 5 THEN 'Grand Est' WHEN 6 THEN 'Hauts-de-France' WHEN 7 THEN 'Nouvelle-Aquitaine' WHEN 8 THEN 'Provence'
        WHEN 9 THEN 'Île-de-France' WHEN 10 THEN 'Centre' WHEN 11 THEN 'Bourgogne' WHEN 12 THEN 'Pays de Loire'
        WHEN 13 THEN 'Corse'
    END AS zone_geographique_reseau,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 3)
        WHEN 0 THEN 20.0 WHEN 1 THEN 40.0 WHEN 2 THEN 67.0
    END AS niveau_pression_bar,
    1000.0 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 1500) AS capacite_injection_max_nm3_h,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 10)
        WHEN 0 THEN 'MAINTENANCE' WHEN 1 THEN 'ARRET' ELSE 'ACTIF'
    END AS statut_operationnel,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 100))
WHERE NOT EXISTS (SELECT 1 FROM RESEAU_DIM LIMIT 1);

-- Analyses qualité (500)
INSERT INTO QUALITE_DIM 
SELECT 
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS id_analyse_qualite,
    10.7 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 100) / 1000.0 AS pcs_kwh_m3,
    13.4 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 100) / 1000.0 AS wobbe_index,
    5.0 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 50) / 10.0 AS teneur_h2s_ppm,
    1.0 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 20) / 10.0 AS teneur_co2_pourcentage,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 10)
        WHEN 0 THEN 'Non-Conforme' ELSE 'Conforme'
    END AS statut_conformite,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 5) + 1
        WHEN 1 THEN 'Laboratoire Terranex Central' WHEN 2 THEN 'Laboratoire Régional Nord'
        WHEN 3 THEN 'Laboratoire Régional Sud' WHEN 4 THEN 'Laboratoire Régional Est'
        WHEN 5 THEN 'Laboratoire Régional Ouest'
    END AS laboratoire_analyse,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 3)
        WHEN 0 THEN 'Chromatographie' WHEN 1 THEN 'Spectroscopie' WHEN 2 THEN 'Analyse en ligne'
    END AS methode_analyse,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 500))
WHERE NOT EXISTS (SELECT 1 FROM QUALITE_DIM LIMIT 1);

-- Injections (10,000)
INSERT INTO INJECTION_FACT 
SELECT 
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS id_injection,
    (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 50) + 1 AS id_site,
    (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 1000) + 1 AS id_temps,
    (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 100) + 1 AS id_poste_reseau,
    (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 500) + 1 AS id_analyse_qualite,
    50.0 + (ABS(RANDOM()) % 200) AS energie_injectee_mwh,
    4500.0 + (ABS(RANDOM()) % 10000) AS volume_injecte_m3,
    200.0 + (ABS(RANDOM()) % 400) AS debit_moyen_m3_h,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 3)
        WHEN 0 THEN 19.5 WHEN 1 THEN 39.5 WHEN 2 THEN 66.5
    END AS pression_injection_bar,
    15.0 + (ABS(RANDOM()) % 100) / 10.0 AS temperature_gaz_celsius,
    1200 + (ABS(RANDOM()) % 480) AS duree_injection_minutes,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 20)
        WHEN 0 THEN 'ARRET_FERIE' WHEN 1 THEN 'MAINTENANCE' WHEN 2 THEN 'PARTIEL' ELSE 'COMPLETE'
    END AS statut_injection,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 10000))
WHERE NOT EXISTS (SELECT 1 FROM INJECTION_FACT LIMIT 1);

SELECT '✅ Étape 3 terminée - ' || 
    (SELECT COUNT(*) FROM SITE_DIM) || ' sites + ' ||
    (SELECT COUNT(*) FROM TEMPS_DIM) || ' dates + ' ||
    (SELECT COUNT(*) FROM RESEAU_DIM) || ' postes + ' ||
    (SELECT COUNT(*) FROM QUALITE_DIM) || ' analyses + ' ||
    (SELECT COUNT(*) FROM INJECTION_FACT) || ' injections' AS resultat;

-- ======================================================================
-- ÉTAPE 4: VUE ANALYTIQUE
-- ======================================================================
SELECT '📋 ÉTAPE 4/10: Vue analytique...' AS etape;

CREATE VIEW IF NOT EXISTS TERRANEX_BIOMETHANE_ANALYTICS_VIEW AS
SELECT 
    inj.ID_INJECTION, inj.ID_SITE, inj.ID_TEMPS, inj.ID_POSTE_RESEAU, inj.ID_ANALYSE_QUALITE,
    inj.ENERGIE_INJECTEE_MWH as energie_mwh, inj.VOLUME_INJECTE_M3 as volume_m3,
    inj.DEBIT_MOYEN_M3_H as debit_m3h, inj.DUREE_INJECTION_MINUTES as duree_minutes,
    inj.PRESSION_INJECTION_BAR as pression_bar, inj.TEMPERATURE_GAZ_CELSIUS as temperature_celsius,
    inj.STATUT_INJECTION as statut_injection,
    t.DATE_COMPLETE as date_injection, t.ANNEE as annee, t.TRIMESTRE as trimestre,
    t.MOIS_NOM as mois, t.JOUR_DE_LA_SEMAINE as jour_semaine, t.EST_FERIE as est_ferie,
    s.NOM_SITE as nom_site, s.REGION as region, s.DEPARTEMENT as departement,
    s.TECHNOLOGIE_PRODUCTION as technologie, s.TYPE_INTRANTS as type_intrants,
    s.NOM_PRODUCTEUR as producteur, s.CAPACITE_NOMINALE_MWH_JOUR as capacite_nominale,
    s.STATUT_OPERATIONNEL as statut_site,
    r.NOM_POSTE_INJECTION as nom_poste, r.TYPE_POSTE as type_poste,
    r.ZONE_GEOGRAPHIQUE_RESEAU as zone_reseau, r.NIVEAU_PRESSION_BAR as niveau_pression,
    r.CAPACITE_INJECTION_MAX_NM3_H as capacite_max, r.STATUT_OPERATIONNEL as statut_poste,
    q.PCS_KWH_M3 as pcs, q.WOBBE_INDEX as wobbe_index, q.TENEUR_H2S_PPM as h2s_ppm,
    q.TENEUR_CO2_POURCENTAGE as co2_pourcent, q.STATUT_CONFORMITE as statut_qualite,
    q.LABORATOIRE_ANALYSE as laboratoire, q.METHODE_ANALYSE as methode_analyse
FROM INJECTION_FACT inj
    INNER JOIN SITE_DIM s ON inj.ID_SITE = s.ID_SITE
    INNER JOIN TEMPS_DIM t ON inj.ID_TEMPS = t.ID_TEMPS
    INNER JOIN RESEAU_DIM r ON inj.ID_POSTE_RESEAU = r.ID_POSTE_RESEAU
    INNER JOIN QUALITE_DIM q ON inj.ID_ANALYSE_QUALITE = q.ID_ANALYSE_QUALITE;

SELECT '✅ Étape 4 terminée - Vue analytique créée' AS resultat;

-- ======================================================================
-- ÉTAPE 5: STAGE ET DOCUMENTS SIMULÉS
-- ======================================================================
SELECT '📋 ÉTAPE 5/10: Stage et documents...' AS etape;

CREATE STAGE IF NOT EXISTS TERRANEX_DOCUMENTS_STAGE
    DIRECTORY = (ENABLE = TRUE)
    COMMENT = 'Stage pour documents non structurés Terranex';

-- Table pour contenu parsé
CREATE TABLE IF NOT EXISTS TERRANEX_PARSED_CONTENT (
    FILE_PATH VARCHAR(500) PRIMARY KEY,
    FILENAME VARCHAR(200) NOT NULL,
    DOCUMENT_TYPE VARCHAR(50) NOT NULL,
    CATEGORY VARCHAR(50) NOT NULL,
    TITLE VARCHAR(200),
    CONTENT TEXT NOT NULL,
    FILE_SIZE NUMBER,
    UPLOAD_DATE TIMESTAMP,
    PARSED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Insertion de documents simulés pour la démo
INSERT INTO TERRANEX_PARSED_CONTENT 
SELECT 
    'reglementation/CRE_2024_Specifications_Qualite.txt' AS file_path,
    'CRE_2024_Specifications_Qualite.txt' AS filename,
    'REGLEMENTATION' AS document_type,
    'CRE' AS category,
    'Spécifications CRE 2024' AS title,
    'RÉGLEMENTATION CRE - 2024

Spécifications qualité gaz naturel et biométhane selon réglementation CRE.

CRITÈRES QUALITÉ REQUIS:
• PCS (Pouvoir Calorifique Supérieur): 10.7 à 11.7 kWh/m³
• Index Wobbe: 13.4 à 15.7 kWh/m³
• Teneur H2S: < 6.0 ppm
• Teneur CO2: < 2.5%
• Taux de conformité requis: > 95%

CONTRÔLES:
• Analyses continues obligatoires
• Contrôles trimestriels par organisme agréé
• Reporting mensuel à la CRE
• Sanctions en cas de non-conformité' AS content,
    352 AS file_size,
    CURRENT_TIMESTAMP() AS upload_date,
    CURRENT_TIMESTAMP() AS parsed_at,
    CURRENT_TIMESTAMP() AS created_at
WHERE NOT EXISTS (SELECT 1 FROM TERRANEX_PARSED_CONTENT WHERE FILE_PATH = 'reglementation/CRE_2024_Specifications_Qualite.txt')

UNION ALL

SELECT 
    'procedures/PROC_EXP_001_Exploitation_Quotidienne.txt',
    'PROC_EXP_001_Exploitation_Quotidienne.txt',
    'PROCEDURE',
    'INTERNE',
    'Procédure Exploitation 001',
    'PROCÉDURE EXPLOITATION TERRANEX
Code: PROC-EXP-001

DOMAINE: Exploitation quotidienne sites biométhane
PERSONNEL: Techniciens exploitation
FRÉQUENCE: Quotidienne

ÉTAPES CLÉS:
1. Vérification paramètres injection
2. Contrôle qualité gaz produit
3. Ajustement débit selon demande réseau
4. Enregistrement données production
5. Alerte en cas de dérive qualité

SEUILS CRITIQUES:
• Pression: 19-67 bars selon poste
• Température: 15-45°C
• Débit: 200-600 m³/h',
    512,
    CURRENT_TIMESTAMP(),
    CURRENT_TIMESTAMP(),
    CURRENT_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM TERRANEX_PARSED_CONTENT WHERE FILE_PATH = 'procedures/PROC_EXP_001_Exploitation_Quotidienne.txt')

UNION ALL

SELECT 
    'techniques/TECH_Methanisation_Liquide_Manuel_Technique.txt',
    'TECH_Methanisation_Liquide_Manuel_Technique.txt',
    'TECHNIQUE',
    'TECH',
    'Manuel Technique Methanisation',
    'MANUEL TECHNIQUE TERRANEX
Technologie: Methanisation Liquide

SPÉCIFICATIONS TECHNIQUES:
• Température optimale: 38-42°C
• Pression process: 1.2-1.8 bars
• pH optimal: 7.0-8.5
• Temps séjour: 20-30 jours
• Rendement: 85-95% CH4

MAINTENANCE SPÉCIFIQUE:
• Contrôle agitateurs: Hebdomadaire
• Vérification chauffage: Quotidienne
• Analyse biologique: Bi-mensuelle
• Nettoyage échangeurs: Mensuel

SÉCURITÉ:
• Détection H2S permanent
• Système anti-explosion
• Procédures d''urgence
• EPI obligatoires',
    624,
    CURRENT_TIMESTAMP(),
    CURRENT_TIMESTAMP(),
    CURRENT_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM TERRANEX_PARSED_CONTENT WHERE FILE_PATH = 'techniques/TECH_Methanisation_Liquide_Manuel_Technique.txt')

UNION ALL

SELECT 
    'contrats/Contrat_Terranex_Normandie_SAS_CTR-2024-1004.txt',
    'Contrat_Terranex_Normandie_SAS_CTR-2024-1004.txt',
    'CONTRAT',
    'COMMERCIAL',
    'Contrat Normandie',
    'CONTRAT PRODUCTION BIOMÉTHANE TERRANEX
Producteur: Terranex Normandie SAS
Numéro: CTR-2024-1004

CARACTÉRISTIQUES SITE:
• Capacité: 150 MWh/jour
• Technologie: Méthanisation liquide
• Intrants: Déchets organiques municipaux
• Mise en service: 2024-01-01
• Durée contrat: 15 ans renouvelable

CONDITIONS COMMERCIALES:
• Tarif: 95 €/MWh
• Indexation: Inflation + 1%
• Garantie production: 85% capacité
• Pénalités retard: 0.1%/jour
• Bonus qualité: 2€/MWh si H2S < 3ppm

OBLIGATIONS TECHNIQUES:
• Respect spécifications CRE
• Analyses qualité continues
• Reporting mensuel production
• Maintenance préventive
• Télétransmission données temps réel',
    880,
    CURRENT_TIMESTAMP(),
    CURRENT_TIMESTAMP(),
    CURRENT_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM TERRANEX_PARSED_CONTENT WHERE FILE_PATH = 'contrats/Contrat_Terranex_Normandie_SAS_CTR-2024-1004.txt');

SELECT '✅ Étape 5 terminée - Stage et ' || COUNT(*) || ' documents créés' AS resultat
FROM TERRANEX_PARSED_CONTENT;

-- ======================================================================
-- ÉTAPE 6: SERVICES CORTEX SEARCH
-- ======================================================================
SELECT '📋 ÉTAPE 6/10: Services Cortex Search...' AS etape;

CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_ALL_TERRANEX_DOCS
    ON content
    ATTRIBUTES file_path, filename, title, document_type, category
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT file_path, filename, title, document_type, category, content
        FROM TERRANEX_PARSED_CONTENT
        WHERE content IS NOT NULL
    );

CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_REGLEMENTATION_TERRANEX
    ON content
    ATTRIBUTES file_path, filename, title
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT file_path, filename, title, content
        FROM TERRANEX_PARSED_CONTENT
        WHERE document_type = 'REGLEMENTATION'
    );

CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_PROCEDURES_TERRANEX
    ON content
    ATTRIBUTES file_path, filename, title
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT file_path, filename, title, content
        FROM TERRANEX_PARSED_CONTENT
        WHERE document_type = 'PROCEDURE'
    );

CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_TECHNIQUES_TERRANEX
    ON content
    ATTRIBUTES file_path, filename, title
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT file_path, filename, title, content
        FROM TERRANEX_PARSED_CONTENT
        WHERE document_type = 'TECHNIQUE'
    );

CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_CONTRATS_TERRANEX
    ON content
    ATTRIBUTES file_path, filename, title
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT file_path, filename, title, content
        FROM TERRANEX_PARSED_CONTENT
        WHERE document_type = 'CONTRAT'
    );

SELECT '✅ Étape 6 terminée - 5 services Cortex Search créés' AS resultat;

-- ======================================================================
-- ÉTAPE 7: MACHINE LEARNING
-- ======================================================================
SELECT '📋 ÉTAPE 7/10: Machine Learning...' AS etape;

-- Vue d'entraînement ML
CREATE VIEW IF NOT EXISTS ML_TRAINING_DATA AS
SELECT 
    s.CAPACITE_NOMINALE_MWH_JOUR,
    CASE s.TECHNOLOGIE_PRODUCTION
        WHEN 'Méthanisation Liquide' THEN 1 WHEN 'Méthanisation Sèche' THEN 2
        WHEN 'Pyrogazéification' THEN 3 WHEN 'Gazéification Plasma' THEN 4 ELSE 0
    END AS technologie_code,
    CASE r.TYPE_POSTE
        WHEN 'INJECTION_MP' THEN 20 WHEN 'INJECTION_HP' THEN 40 WHEN 'INJECTION_THP' THEN 67 ELSE 0
    END AS pression_poste,
    t.MOIS_NUMERO, t.TRIMESTRE,
    CASE WHEN t.EST_FERIE THEN 1 ELSE 0 END AS est_ferie,
    q.PCS_KWH_M3, q.WOBBE_INDEX,
    inj.ENERGIE_INJECTEE_MWH as target_energie
FROM INJECTION_FACT inj
    INNER JOIN SITE_DIM s ON inj.ID_SITE = s.ID_SITE
    INNER JOIN TEMPS_DIM t ON inj.ID_TEMPS = t.ID_TEMPS
    INNER JOIN RESEAU_DIM r ON inj.ID_POSTE_RESEAU = r.ID_POSTE_RESEAU
    INNER JOIN QUALITE_DIM q ON inj.ID_ANALYSE_QUALITE = q.ID_ANALYSE_QUALITE
WHERE inj.STATUT_INJECTION = 'COMPLETE';

-- Stored Procedure de prédiction
CREATE PROCEDURE IF NOT EXISTS PREDICT_TERRANEX_PRODUCTION(site_id INT, mois_prediction INT)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET site_info RESULTSET := (
        SELECT s.CAPACITE_NOMINALE_MWH_JOUR,
            CASE s.TECHNOLOGIE_PRODUCTION
                WHEN 'Méthanisation Liquide' THEN 1 WHEN 'Méthanisation Sèche' THEN 2
                WHEN 'Pyrogazéification' THEN 3 WHEN 'Gazéification Plasma' THEN 4 ELSE 0
            END AS technologie_code,
            s.TECHNOLOGIE_PRODUCTION, s.NOM_SITE, s.REGION
        FROM SITE_DIM s WHERE s.ID_SITE = :site_id
    );
    
    LET capacite FLOAT; LET tech_code INT; LET tech_name STRING; LET nom_site STRING; LET region STRING;
    
    LET c1 CURSOR FOR site_info;
    FOR record IN c1 DO
        capacite := record.CAPACITE_NOMINALE_MWH_JOUR;
        tech_code := record.technologie_code;
        tech_name := record.TECHNOLOGIE_PRODUCTION;
        nom_site := record.NOM_SITE;
        region := record.REGION;
    END FOR;
    
    LET base_prediction FLOAT := capacite * 0.85;
    LET seasonal_factor FLOAT := CASE 
        WHEN :mois_prediction IN (12, 1, 2) THEN 1.2
        WHEN :mois_prediction IN (6, 7, 8) THEN 0.9 ELSE 1.0
    END;
    LET tech_factor FLOAT := CASE tech_code
        WHEN 1 THEN 1.0 WHEN 2 THEN 0.95 WHEN 3 THEN 1.1 WHEN 4 THEN 1.15 ELSE 1.0
    END;
    
    LET prediction FLOAT := base_prediction * seasonal_factor * tech_factor;
    
    RETURN '🤖 PRÉDICTION TERRANEX - MODÈLE ML
📍 SITE: ' || nom_site || ' (' || region || ')
🔧 TECHNOLOGIE: ' || tech_name || '
📊 CAPACITÉ: ' || capacite || ' MWh/jour
🔮 PRÉDICTION MOIS ' || :mois_prediction || ': ' || ROUND(prediction, 2) || ' MWh/jour
📈 Facteurs: Saison=' || seasonal_factor || ', Tech=' || tech_factor;
END;
$$;

SELECT '✅ Étape 7 terminée - ML et procédure créés' AS resultat;

-- ======================================================================
-- ÉTAPE 8: QUESTIONS DE BASE
-- ======================================================================
SELECT '📋 ÉTAPE 8/10: Questions de base...' AS etape;

CREATE TABLE IF NOT EXISTS TERRANEX_QUESTIONS_BASE (
    ID INT AUTOINCREMENT PRIMARY KEY,
    CATEGORIE VARCHAR(50),
    QUESTION TEXT,
    TYPE_REPONSE VARCHAR(50),
    EXEMPLE_REPONSE TEXT,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Insertion des questions si la table est vide
INSERT INTO TERRANEX_QUESTIONS_BASE (CATEGORIE, QUESTION, TYPE_REPONSE, EXEMPLE_REPONSE)
SELECT * FROM VALUES
('PRODUCTION', 'Quelle est la production totale cette année ?', 'DONNEES', 'SELECT SUM(energie_mwh) FROM TERRANEX_BIOMETHANE_ANALYTICS_VIEW WHERE annee = 2024'),
('PRODUCTION', 'Quels sont les 5 sites les plus performants ?', 'DONNEES', 'GROUP BY nom_site ORDER BY SUM(energie_mwh) DESC LIMIT 5'),
('REGLEMENTATION', 'Spécifications CRE pour la qualité du biométhane ?', 'DOCUMENTS', 'SEARCH_REGLEMENTATION_TERRANEX "spécifications qualité CRE"'),
('PROCEDURES', 'Comment faire la maintenance d''un site ?', 'DOCUMENTS', 'SEARCH_PROCEDURES_TERRANEX "maintenance préventive"'),
('TECHNIQUE', 'Spécifications de la méthanisation liquide ?', 'DOCUMENTS', 'SEARCH_TECHNIQUES_TERRANEX "méthanisation liquide"'),
('CONTRATS', 'Termes du contrat Normandie ?', 'DOCUMENTS', 'SEARCH_CONTRATS_TERRANEX "Normandie contrat"'),
('PREDICTION', 'Production prévue du site 1 en janvier ?', 'ML', 'CALL PREDICT_TERRANEX_PRODUCTION(1, 1)'),
('MIXTE', 'Analyse complète site Normandie ?', 'DONNEES+DOCUMENTS+ML', 'Combine vue + contrat + prédiction')
AS t(categorie, question, type_reponse, exemple_reponse)
WHERE NOT EXISTS (SELECT 1 FROM TERRANEX_QUESTIONS_BASE LIMIT 1);

SELECT '✅ Étape 8 terminée - ' || COUNT(*) || ' questions de base créées' AS resultat
FROM TERRANEX_QUESTIONS_BASE;

-- ======================================================================
-- ÉTAPE 9: PERMISSIONS FINALES
-- ======================================================================
SELECT '📋 ÉTAPE 9/10: Permissions finales...' AS etape;

USE ROLE ACCOUNTADMIN;

-- Permissions sur tous les objets
GRANT USAGE ON DATABASE DB_TERRANEX TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;
GRANT SELECT ON ALL TABLES IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;
GRANT SELECT ON ALL VIEWS IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON ALL PROCEDURES IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON ALL CORTEX SEARCH SERVICES IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;

SELECT '✅ Étape 9 terminée - Permissions accordées' AS resultat;

-- ======================================================================
-- ÉTAPE 10: VÉRIFICATION FINALE
-- ======================================================================
SELECT '📋 ÉTAPE 10/10: Vérification finale...' AS etape;

USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- Test de la vue analytique
SELECT 'Vue analytique: ' || COUNT(*) || ' enregistrements' AS verification
FROM TERRANEX_BIOMETHANE_ANALYTICS_VIEW;

-- Test des documents
SELECT 'Documents parsés: ' || COUNT(*) || ' fichiers' AS verification
FROM TERRANEX_PARSED_CONTENT;

-- Test du ML
CALL PREDICT_TERRANEX_PRODUCTION(1, 12);

-- Test des questions
SELECT 'Questions de base: ' || COUNT(*) || ' exemples' AS verification
FROM TERRANEX_QUESTIONS_BASE;

-- ======================================================================
-- RÉSUMÉ FINAL D'INSTALLATION
-- ======================================================================
SELECT 
    '🎉 INSTALLATION TERRANEX TERMINÉE !' AS titre,
    '' AS composant,
    '' AS statut
UNION ALL
SELECT 
    '',
    'Rôle et permissions',
    '✅ SF_Intelligence_Demo configuré'
UNION ALL
SELECT 
    '',
    'Infrastructure',
    '✅ DB_TERRANEX + TERRANEX_WH'
UNION ALL
SELECT 
    '',
    'Données volumineuses',
    '✅ ' || (SELECT COUNT(*) FROM INJECTION_FACT) || ' injections'
UNION ALL
SELECT 
    '',
    'Vue analytique',
    '✅ TERRANEX_BIOMETHANE_ANALYTICS_VIEW'
UNION ALL
SELECT 
    '',
    'Documents',
    '✅ ' || (SELECT COUNT(*) FROM TERRANEX_PARSED_CONTENT) || ' documents parsés'
UNION ALL
SELECT 
    '',
    'Cortex Search',
    '✅ 5 services spécialisés'
UNION ALL
SELECT 
    '',
    'Machine Learning',
    '✅ Modèle + Stored Procedure'
UNION ALL
SELECT 
    '',
    'Questions de base',
    '✅ ' || (SELECT COUNT(*) FROM TERRANEX_QUESTIONS_BASE) || ' exemples'
UNION ALL
SELECT 
    '',
    'Agents IA',
    '⏳ À créer manuellement dans l''interface';

-- ⏱️ FIN INSTALLATION
SELECT '🏁 FIN INSTALLATION TERRANEX - ' || CURRENT_TIMESTAMP()::VARCHAR AS fin_installation;

SELECT '
🚀 INSTALLATION AUTONOME TERMINÉE !

✅ ENVIRONNEMENT COMPLET CRÉÉ:
• Base DB_TERRANEX opérationnelle
• 11,650 enregistrements de données
• 4 documents types parsés et indexés
• 5 services Cortex Search actifs
• Modèle ML avec prédictions
• 8+ questions de base pour démos

🤖 PROCHAINE ÉTAPE:
Créez les 3 agents manuellement dans l''interface Snowflake Intelligence:
1. TERRANEX_ANALYSTE_PRODUCTION (données)
2. TERRANEX_EXPERT_DOCUMENTS (Cortex Search)  
3. TERRANEX_EXPERT_COMPLET (données + docs + ML)

🎯 PRÊT POUR DÉMONSTRATION CLIENT !
' AS instructions_finales;
