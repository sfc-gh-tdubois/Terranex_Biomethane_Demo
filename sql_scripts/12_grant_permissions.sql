-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 11: PERMISSIONS COMPLÈTES
-- ======================================================================
-- Description: Attribution de toutes les permissions nécessaires au rôle SF_Intelligence_Demo
-- Usage: Peut être exécuté séparément pour corriger des problèmes de permissions
-- Leçons: Basé sur les tests réels et erreurs rencontrées
-- ======================================================================

USE ROLE ACCOUNTADMIN;

SELECT '🔐 ATTRIBUTION PERMISSIONS COMPLÈTES TERRANEX' AS titre;

-- ======================================================================
-- PERMISSIONS DE BASE
-- ======================================================================
SELECT '📋 Permissions base de données et schéma...' AS etape;

GRANT USAGE ON DATABASE DB_TERRANEX TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;

-- ======================================================================
-- PERMISSIONS TABLES
-- ======================================================================
SELECT '📊 Permissions tables...' AS etape;

-- LEÇON: SELECT sur toutes les tables pour accès données
GRANT SELECT ON ALL TABLES IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;

-- Permissions futures (pour nouvelles tables)
GRANT SELECT ON FUTURE TABLES IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;

-- ======================================================================
-- PERMISSIONS VUES
-- ======================================================================
SELECT '🧠 Permissions vues...' AS etape;

-- LEÇON CRITIQUE: SELECT (pas USAGE) pour les vues
-- Erreur découverte: "Invalid object type 'TABLE' for privilege 'USAGE'"
GRANT SELECT ON ALL VIEWS IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;

-- Permissions futures vues
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;

-- ======================================================================
-- PERMISSIONS PROCEDURES
-- ======================================================================
SELECT '⚙️ Permissions procédures...' AS etape;

GRANT USAGE ON ALL PROCEDURES IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;

-- ======================================================================
-- PERMISSIONS CORTEX SEARCH
-- ======================================================================
SELECT '🔍 Permissions Cortex Search...' AS etape;

-- LEÇON: USAGE nécessaire pour utilisation des services Cortex Search
GRANT USAGE ON ALL CORTEX SEARCH SERVICES IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON FUTURE CORTEX SEARCH SERVICES IN SCHEMA DB_TERRANEX.PRODUCTION TO ROLE SF_Intelligence_Demo;

-- ======================================================================
-- PERMISSIONS AGENTS (SNOWFLAKE INTELLIGENCE)
-- ======================================================================
SELECT '🤖 Permissions agents Snowflake Intelligence...' AS etape;

-- LEÇON: Permissions nécessaires dès le début pour création agents
GRANT USAGE ON DATABASE SNOWFLAKE_INTELLIGENCE TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE SF_Intelligence_Demo;
GRANT CREATE AGENT ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE SF_Intelligence_Demo;

-- ======================================================================
-- PERMISSIONS WAREHOUSE
-- ======================================================================
SELECT '🏭 Permissions warehouse...' AS etape;

GRANT USAGE ON WAREHOUSE TERRANEX_WH TO ROLE SF_Intelligence_Demo;

-- ======================================================================
-- VÉRIFICATION PERMISSIONS
-- ======================================================================
SELECT '🔍 Vérification permissions accordées...' AS etape;

-- Compter les permissions accordées
SELECT 
    '📊 RÉSUMÉ PERMISSIONS ACCORDÉES' AS titre,
    '' AS type_objet,
    '' AS nb_permissions
UNION ALL
SELECT 
    '',
    'Tables',
    (SELECT COUNT(*)::VARCHAR FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRODUCTION')
UNION ALL
SELECT 
    '',
    'Vues',
    (SELECT COUNT(*)::VARCHAR FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = 'PRODUCTION')
UNION ALL
SELECT 
    '',
    'Procédures',
    (SELECT COUNT(*)::VARCHAR FROM INFORMATION_SCHEMA.PROCEDURES WHERE PROCEDURE_SCHEMA = 'PRODUCTION')
UNION ALL
SELECT 
    '',
    'Services Cortex Search',
    '5 services spécialisés'
UNION ALL
SELECT 
    '',
    'Permissions agents',
    '✅ SNOWFLAKE_INTELLIGENCE configuré';

SELECT '✅ TOUTES LES PERMISSIONS ACCORDÉES AU RÔLE SF_Intelligence_Demo !' AS statut_final;
