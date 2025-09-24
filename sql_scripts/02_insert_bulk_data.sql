-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 1B: INSERTION DONNÉES VOLUMINEUSES
-- ======================================================================
-- Description: Insertion de gros volumes de données dans toutes les dimensions
-- Volume total: 50 sites + 1000 dates + 100 postes + 500 analyses + 10K injections
-- ======================================================================

USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- ======================================================================
-- INSERTION SITES DE PRODUCTION (50 sites)
-- ======================================================================
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
        WHEN 1 THEN 'Normandie'
        WHEN 2 THEN 'Bretagne'
        WHEN 3 THEN 'Occitanie'
        WHEN 4 THEN 'Auvergne-Rhône-Alpes'
        WHEN 5 THEN 'Grand Est'
        WHEN 6 THEN 'Hauts-de-France'
        WHEN 7 THEN 'Nouvelle-Aquitaine'
        WHEN 8 THEN 'Provence-Alpes-Côte d''Azur'
        WHEN 9 THEN 'Île-de-France'
        WHEN 10 THEN 'Centre-Val de Loire'
        WHEN 11 THEN 'Bourgogne-Franche-Comté'
        WHEN 12 THEN 'Pays de la Loire'
        WHEN 13 THEN 'Corse'
    END AS region,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN '14'
        WHEN 2 THEN '35'
        WHEN 3 THEN '31'
        WHEN 4 THEN '63'
        WHEN 5 THEN '67'
        WHEN 6 THEN '59'
        WHEN 7 THEN '33'
        WHEN 8 THEN '13'
        WHEN 9 THEN '75'
        WHEN 10 THEN '45'
        WHEN 11 THEN '21'
        WHEN 12 THEN '44'
        WHEN 13 THEN '2A'
    END AS departement,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 4) + 1
        WHEN 1 THEN 'Méthanisation Liquide'
        WHEN 2 THEN 'Méthanisation Sèche'
        WHEN 3 THEN 'Pyrogazéification'
        WHEN 4 THEN 'Gazéification Plasma'
    END AS technologie_production,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 5) + 1
        WHEN 1 THEN 'Déchets organiques municipaux'
        WHEN 2 THEN 'Résidus agricoles'
        WHEN 3 THEN 'Biomasse forestière'
        WHEN 4 THEN 'Déchets industriels'
        WHEN 5 THEN 'Boues de station d''épuration'
    END AS type_intrants,
    'Terranex ' || 
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN 'Normandie'
        WHEN 2 THEN 'Bretagne'
        WHEN 3 THEN 'Occitanie'
        WHEN 4 THEN 'Auvergne'
        WHEN 5 THEN 'Grand Est'
        WHEN 6 THEN 'Hauts-de-France'
        WHEN 7 THEN 'Nouvelle-Aquitaine'
        WHEN 8 THEN 'Provence'
        WHEN 9 THEN 'Île-de-France'
        WHEN 10 THEN 'Centre'
        WHEN 11 THEN 'Bourgogne'
        WHEN 12 THEN 'Pays de Loire'
        WHEN 13 THEN 'Corse'
    END || ' SAS' AS nom_producteur,
    80.0 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 120) AS capacite_nominale_mwh_jour,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 10)
        WHEN 0 THEN 'MAINTENANCE'
        WHEN 1 THEN 'ARRET'
        ELSE 'ACTIF'
    END AS statut_operationnel,
    DATEADD(day, -(ROW_NUMBER() OVER (ORDER BY SEQ4()) % 1000), '2024-01-01') AS date_mise_service,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 50));

-- ======================================================================
-- INSERTION DIMENSION TEMPORELLE (1000 dates)
-- ======================================================================
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
);

-- ======================================================================
-- INSERTION POSTES RÉSEAU (100 postes)
-- ======================================================================
INSERT INTO RESEAU_DIM 
SELECT 
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS id_poste_reseau,
    'Poste Injection ' || 
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN 'Normandie'
        WHEN 2 THEN 'Bretagne'
        WHEN 3 THEN 'Occitanie'
        WHEN 4 THEN 'Auvergne'
        WHEN 5 THEN 'Grand Est'
        WHEN 6 THEN 'Hauts-de-France'
        WHEN 7 THEN 'Nouvelle-Aquitaine'
        WHEN 8 THEN 'Provence'
        WHEN 9 THEN 'Île-de-France'
        WHEN 10 THEN 'Centre'
        WHEN 11 THEN 'Bourgogne'
        WHEN 12 THEN 'Pays de Loire'
        WHEN 13 THEN 'Corse'
    END || ' ' || ROW_NUMBER() OVER (ORDER BY SEQ4()) AS nom_poste_injection,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 3)
        WHEN 0 THEN 'INJECTION_MP'
        WHEN 1 THEN 'INJECTION_HP'
        WHEN 2 THEN 'INJECTION_THP'
    END AS type_poste,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 13) + 1
        WHEN 1 THEN 'Normandie'
        WHEN 2 THEN 'Bretagne'
        WHEN 3 THEN 'Occitanie'
        WHEN 4 THEN 'Auvergne'
        WHEN 5 THEN 'Grand Est'
        WHEN 6 THEN 'Hauts-de-France'
        WHEN 7 THEN 'Nouvelle-Aquitaine'
        WHEN 8 THEN 'Provence'
        WHEN 9 THEN 'Île-de-France'
        WHEN 10 THEN 'Centre'
        WHEN 11 THEN 'Bourgogne'
        WHEN 12 THEN 'Pays de Loire'
        WHEN 13 THEN 'Corse'
    END AS zone_geographique_reseau,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 3)
        WHEN 0 THEN 20.0
        WHEN 1 THEN 40.0
        WHEN 2 THEN 67.0
    END AS niveau_pression_bar,
    1000.0 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 1500) AS capacite_injection_max_nm3_h,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 10)
        WHEN 0 THEN 'MAINTENANCE'
        WHEN 1 THEN 'ARRET'
        ELSE 'ACTIF'
    END AS statut_operationnel,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 100));

-- ======================================================================
-- INSERTION ANALYSES QUALITÉ (500 analyses)
-- ======================================================================
INSERT INTO QUALITE_DIM 
SELECT 
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS id_analyse_qualite,
    10.7 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 100) / 1000.0 AS pcs_kwh_m3,
    13.4 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 100) / 1000.0 AS wobbe_index,
    5.0 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 50) / 10.0 AS teneur_h2s_ppm,
    1.0 + (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 20) / 10.0 AS teneur_co2_pourcentage,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 10)
        WHEN 0 THEN 'Non-Conforme'
        ELSE 'Conforme'
    END AS statut_conformite,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 5) + 1
        WHEN 1 THEN 'Laboratoire Terranex Central'
        WHEN 2 THEN 'Laboratoire Régional Nord'
        WHEN 3 THEN 'Laboratoire Régional Sud'
        WHEN 4 THEN 'Laboratoire Régional Est'
        WHEN 5 THEN 'Laboratoire Régional Ouest'
    END AS laboratoire_analyse,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 3)
        WHEN 0 THEN 'Chromatographie'
        WHEN 1 THEN 'Spectroscopie'
        WHEN 2 THEN 'Analyse en ligne'
    END AS methode_analyse,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 500));

-- ======================================================================
-- INSERTION TABLE DE FAITS - INJECTIONS (10,000 enregistrements)
-- ======================================================================
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
        WHEN 0 THEN 19.5
        WHEN 1 THEN 39.5
        WHEN 2 THEN 66.5
    END AS pression_injection_bar,
    15.0 + (ABS(RANDOM()) % 100) / 10.0 AS temperature_gaz_celsius,
    1200 + (ABS(RANDOM()) % 480) AS duree_injection_minutes,
    CASE (ROW_NUMBER() OVER (ORDER BY SEQ4()) % 20)
        WHEN 0 THEN 'ARRET_FERIE'
        WHEN 1 THEN 'MAINTENANCE'
        WHEN 2 THEN 'PARTIEL'
        ELSE 'COMPLETE'
    END AS statut_injection,
    CURRENT_TIMESTAMP() AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 10000));

-- ======================================================================
-- VÉRIFICATION DES DONNÉES INSÉRÉES
-- ======================================================================
SELECT 
    '🎯 DONNÉES TERRANEX INSÉRÉES AVEC SUCCÈS' AS titre,
    '' AS table_name,
    '' AS count
UNION ALL
SELECT 
    '',
    'Sites de production',
    (SELECT COUNT(*)::VARCHAR FROM SITE_DIM)
UNION ALL
SELECT 
    '',
    'Dates temporelles', 
    (SELECT COUNT(*)::VARCHAR FROM TEMPS_DIM)
UNION ALL
SELECT 
    '',
    'Postes réseau',
    (SELECT COUNT(*)::VARCHAR FROM RESEAU_DIM)
UNION ALL
SELECT 
    '',
    'Analyses qualité',
    (SELECT COUNT(*)::VARCHAR FROM QUALITE_DIM)
UNION ALL
SELECT 
    '',
    'Injections biométhane',
    (SELECT COUNT(*)::VARCHAR FROM INJECTION_FACT)
ORDER BY table_name;

SELECT '✅ ÉTAPE 1 TERMINÉE - Données volumineuses prêtes pour la couche sémantique !' AS status;
