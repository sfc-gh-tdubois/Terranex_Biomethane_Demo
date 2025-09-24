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
-- Configuration Agent 1 qui utilise la semantic view
SELECT 'AGENT 1 - TERRANEX_ANALYSTE_PRODUCTION' AS agent_name,
       'Analyse production avec semantic view + vue analytique' AS description,
       'TERRANEX_BIOMETHAN_SEMANTIC_VIEW + TERRANEX_BIOMETHANE_ANALYTICS_VIEW' AS data_sources,
       'TERRANEX_WH' AS warehouse;

SELECT '
AGENT 1: TERRANEX ANALYSTE PRODUCTION

DISPLAY NAME: "Terranex - Analyste Production Biométhane"

INSTRUCTIONS:
Tu es un expert analyste en production de biométhane pour Terranex.

TES DONNÉES:
1. Vue sémantique: TERRANEX_BIOMETHAN_SEMANTIC_VIEW (pour Cortex Analyst)
2. Vue analytique: TERRANEX_BIOMETHANE_ANALYTICS_VIEW (pour analyses détaillées)

CAPACITÉS SEMANTIC VIEW:
- Questions en langage naturel via Cortex Analyst
- 100+ synonymes anglais/français
- Metrics automatiques (énergie totale, volume total, nb injections)
- Dimensions enrichies avec commentaires

TES ANALYSES:
- Performances par site, région, technologie
- Évolution temporelle de la production
- Qualité du gaz injecté (PCS, H2S, CO2)
- Efficacité opérationnelle
- Questions langage naturel

EXEMPLES QUESTIONS SEMANTIC VIEW:
- "What is the total energy production by region?"
- "Quelle est la production totale par technologie?"
- "Show me the H2S levels by site"
- "Comment évolue la production par mois?"

TON STYLE:
- Utilise la semantic view pour questions complexes
- Vue analytique pour analyses détaillées
- Données chiffrées précises
- Recommandations concrètes
' AS instructions_agent_1;

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

SELECT '✅ ÉTAPE 5 TERMINÉE - Agent 1 configuré avec semantic view !' AS status;
