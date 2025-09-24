-- ======================================================================
-- TERRANEX BIOMÉTHANE - VÉRIFICATION ENVIRONNEMENT
-- ======================================================================
-- Description: Vérification complète de l'environnement Terranex
-- Usage: Exécuter AVANT installation pour vérifier les prérequis
--        Exécuter APRÈS installation pour valider le déploiement
-- ======================================================================

USE ROLE ACCOUNTADMIN;

-- ======================================================================
-- VÉRIFICATION DES PRÉREQUIS
-- ======================================================================
SELECT '🔍 VÉRIFICATION PRÉREQUIS TERRANEX' AS titre;

-- Vérification Snowflake Intelligence
SELECT 
    '🧠 Snowflake Intelligence' AS composant,
    CASE 
        WHEN EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.DATABASES WHERE DATABASE_NAME = 'SNOWFLAKE_INTELLIGENCE')
        THEN '✅ DISPONIBLE'
        ELSE '❌ NON DISPONIBLE - Contactez votre administrateur'
    END AS statut;

-- Vérification des permissions utilisateur actuel
SELECT 
    '👤 Utilisateur actuel' AS composant,
    CURRENT_USER() AS utilisateur,
    CURRENT_ROLE() AS role_actuel;

-- ======================================================================
-- VÉRIFICATION ENVIRONNEMENT TERRANEX (si déjà installé)
-- ======================================================================

-- Vérification du rôle
SELECT 
    '👤 Rôle SF_Intelligence_Demo' AS composant,
    CASE 
        WHEN EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.APPLICABLE_ROLES WHERE ROLE_NAME = 'SF_INTELLIGENCE_DEMO')
        THEN '✅ EXISTE'
        ELSE '❌ ABSENT'
    END AS statut;

-- Vérification du warehouse
SELECT 
    '🏭 Warehouse TERRANEX_WH' AS composant,
    CASE 
        WHEN EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.WAREHOUSES WHERE WAREHOUSE_NAME = 'TERRANEX_WH')
        THEN '✅ EXISTE'
        ELSE '❌ ABSENT'
    END AS statut;

-- Vérification de la base de données
SELECT 
    '🗄️ Database DB_TERRANEX' AS composant,
    CASE 
        WHEN EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.DATABASES WHERE DATABASE_NAME = 'DB_TERRANEX')
        THEN '✅ EXISTE'
        ELSE '❌ ABSENT'
    END AS statut;

-- ======================================================================
-- VÉRIFICATION DÉTAILLÉE (si environnement existe)
-- ======================================================================

-- Basculer vers l'environnement Terranex si il existe
USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- Vérification des tables
SELECT 
    '📊 TABLES TERRANEX' AS section,
    '' AS table_name,
    '' AS nb_records
UNION ALL
SELECT 
    '',
    'SITE_DIM',
    COALESCE((SELECT COUNT(*)::VARCHAR FROM SITE_DIM), 'N/A')
UNION ALL
SELECT 
    '',
    'TEMPS_DIM',
    COALESCE((SELECT COUNT(*)::VARCHAR FROM TEMPS_DIM), 'N/A')
UNION ALL
SELECT 
    '',
    'RESEAU_DIM',
    COALESCE((SELECT COUNT(*)::VARCHAR FROM RESEAU_DIM), 'N/A')
UNION ALL
SELECT 
    '',
    'QUALITE_DIM',
    COALESCE((SELECT COUNT(*)::VARCHAR FROM QUALITE_DIM), 'N/A')
UNION ALL
SELECT 
    '',
    'INJECTION_FACT',
    COALESCE((SELECT COUNT(*)::VARCHAR FROM INJECTION_FACT), 'N/A')
UNION ALL
SELECT 
    '',
    'TERRANEX_PARSED_CONTENT',
    COALESCE((SELECT COUNT(*)::VARCHAR FROM TERRANEX_PARSED_CONTENT), 'N/A');

-- Vérification des vues
SELECT 
    '🧠 VUES ANALYTIQUES' AS section,
    '' AS vue_name,
    '' AS statut
UNION ALL
SELECT 
    '',
    'TERRANEX_BIOMETHANE_ANALYTICS_VIEW',
    CASE 
        WHEN EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'TERRANEX_BIOMETHANE_ANALYTICS_VIEW')
        THEN '✅ EXISTE'
        ELSE '❌ ABSENT'
    END
UNION ALL
SELECT 
    '',
    'ML_TRAINING_DATA',
    CASE 
        WHEN EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'ML_TRAINING_DATA')
        THEN '✅ EXISTE'
        ELSE '❌ ABSENT'
    END;

-- Vérification des services Cortex Search
SHOW CORTEX SEARCH SERVICES LIKE '%TERRANEX%';

-- Vérification des procédures
SELECT 
    '⚙️ STORED PROCEDURES' AS section,
    '' AS procedure_name,
    '' AS statut
UNION ALL
SELECT 
    '',
    'PREDICT_TERRANEX_PRODUCTION',
    CASE 
        WHEN EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.PROCEDURES WHERE PROCEDURE_NAME = 'PREDICT_TERRANEX_PRODUCTION')
        THEN '✅ EXISTE'
        ELSE '❌ ABSENT'
    END;

-- ======================================================================
-- RÉSUMÉ FINAL
-- ======================================================================
SELECT 
    '🎯 RÉSUMÉ VÉRIFICATION TERRANEX' AS titre,
    '' AS composant,
    '' AS recommandation
UNION ALL
SELECT 
    '',
    'Infrastructure de base',
    'Vérifiez rôle + warehouse + database ci-dessus'
UNION ALL
SELECT 
    '',
    'Données volumineuses',
    'Attendu: 50+1K+100+500+10K = 11,650 enregistrements'
UNION ALL
SELECT 
    '',
    'Documents parsés',
    'Attendu: 4 documents minimum'
UNION ALL
SELECT 
    '',
    'Services Cortex Search',
    'Attendu: 5 services actifs'
UNION ALL
SELECT 
    '',
    'ML et procédures',
    'Attendu: 1 vue ML + 1 stored procedure'
UNION ALL
SELECT 
    '',
    'Agents IA',
    'À vérifier manuellement dans Snowflake Intelligence'
UNION ALL
SELECT 
    '',
    'Si problèmes détectés',
    'Exécutez 99_RESET_ENVIRONMENT.sql puis réinstallez';
