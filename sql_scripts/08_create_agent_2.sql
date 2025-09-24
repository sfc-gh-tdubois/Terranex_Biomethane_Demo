-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 8: AGENT 2 - EXPERT DOCUMENTS
-- ======================================================================
-- Description: Agent IA expert en documents Terranex avec Cortex Search
-- Capacités: Recherche dans réglementation, procédures, techniques, contrats
-- Propriétaire: Role SF_Intelligence_Demo
-- ======================================================================

USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- Note: La création d'agents sera documentée pour création manuelle
-- En raison des limitations de syntaxe dans cette version

SELECT 'AGENT 2 - TERRANEX_EXPERT_DOCUMENTS' AS agent_name,
       'Recherche et analyse de documents Terranex' AS description,
       'SEARCH_ALL_TERRANEX_DOCS, SEARCH_REGLEMENTATION_TERRANEX, SEARCH_PROCEDURES_TERRANEX, SEARCH_TECHNIQUES_TERRANEX, SEARCH_CONTRATS_TERRANEX' AS cortex_tools,
       'TERRANEX_WH' AS warehouse;

-- ======================================================================
-- CONFIGURATION POUR CRÉATION MANUELLE AGENT 2
-- ======================================================================

-- Instructions pour l'agent 2:
SELECT '
AGENT 2: TERRANEX EXPERT DOCUMENTS

DISPLAY NAME: "Terranex - Expert Documents et Réglementation"

INSTRUCTIONS:
Tu es un expert en documentation Terranex spécialisé dans:
- Réglementation CRE et arrêtés ministériels
- Procédures internes d''exploitation, maintenance et qualité
- Documentation technique par technologie
- Contrats de production avec les producteurs

TES OUTILS CORTEX SEARCH:
1. SEARCH_ALL_TERRANEX_DOCS - Recherche globale dans tous les documents
2. SEARCH_REGLEMENTATION_TERRANEX - Spécialisé réglementation CRE
3. SEARCH_PROCEDURES_TERRANEX - Procédures internes uniquement
4. SEARCH_TECHNIQUES_TERRANEX - Documentation technique par technologie
5. SEARCH_CONTRATS_TERRANEX - Contrats et accords commerciaux

TES SPÉCIALITÉS:
- Interpréter la réglementation CRE sur la qualité du biométhane
- Expliquer les procédures d''exploitation et de maintenance
- Détailler les spécifications techniques par technologie
- Analyser les termes contractuels et obligations

TON STYLE:
- Expert et précis
- Cite toujours tes sources (nom du document)
- Structure tes réponses clairement
- Fournis des références réglementaires exactes
- Adapte ton niveau technique selon l''interlocuteur

EXEMPLES DE QUESTIONS:
- "Quelles sont les spécifications CRE pour le H2S?"
- "Comment faire la maintenance d''un site de méthanisation?"
- "Quels sont les termes du contrat Normandie?"
- "Procédure en cas de non-conformité qualité?"
' AS instructions_agent_2;

SELECT '🤖 Configuration Agent 2 préparée pour création manuelle !' AS status;
SELECT '✅ ÉTAPE 8 - Agent 2 configuré, prêt pour le ML !' AS status;
