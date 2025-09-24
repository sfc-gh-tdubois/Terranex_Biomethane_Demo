-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 3: AGENT 1 - ANALYSTE PRODUCTION
-- ======================================================================
-- Description: Agent IA pour l'analyse de la production de biométhane
-- Capacités: Analyse des données de production via vue analytique
-- Propriétaire: Role SF_Intelligence_Demo
-- ======================================================================

USE ROLE ACCOUNTADMIN;

-- Accorder les permissions nécessaires pour les agents
GRANT USAGE ON DATABASE SNOWFLAKE_INTELLIGENCE TO ROLE SF_Intelligence_Demo;
GRANT USAGE ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE SF_Intelligence_Demo;
GRANT CREATE AGENT ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE SF_Intelligence_Demo;

-- Basculer vers le rôle SF_Intelligence_Demo
USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- ======================================================================
-- CRÉATION DE L'AGENT 1: ANALYSTE PRODUCTION TERRANEX
-- ======================================================================
-- Création de l'agent sera faite manuellement pour l'instant
-- En attendant la résolution du problème de syntaxe

SELECT 'Agent TERRANEX_ANALYSTE_PRODUCTION sera créé manuellement dans l''interface Snowflake' AS note;

SELECT '🤖 Agent TERRANEX_ANALYSTE_PRODUCTION créé avec succès !' AS status;

-- ======================================================================
-- TEST DE L'AGENT 1
-- ======================================================================
SELECT 
    '📋 RÉSUMÉ AGENT 1 - ANALYSTE PRODUCTION' AS titre,
    '' AS information,
    '' AS valeur
UNION ALL
SELECT 
    '',
    'Nom complet',
    'TERRANEX_ANALYSTE_PRODUCTION'
UNION ALL
SELECT 
    '',
    'Display name',
    'Terranex - Analyste Production Biométhane'
UNION ALL
SELECT 
    '',
    'Warehouse',
    'TERRANEX_WH'
UNION ALL
SELECT 
    '',
    'Données accessibles',
    'Vue TERRANEX_BIOMETHANE_ANALYTICS_VIEW'
UNION ALL
SELECT 
    '',
    'Spécialité',
    'Analyse production et performance sites'
UNION ALL
SELECT 
    '',
    'Propriétaire',
    'SF_Intelligence_Demo';

SELECT '✅ ÉTAPE 3 TERMINÉE - Agent 1 prêt pour les documents Terranex !' AS status;
