-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 7: SERVICES CORTEX SEARCH
-- ======================================================================
-- Description: Création des services Cortex Search pour documents Terranex
-- Services: Global + spécialisés par type de document
-- Propriétaire: Role SF_Intelligence_Demo
-- ======================================================================

USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- ======================================================================
-- SERVICE CORTEX SEARCH GLOBAL - TOUS DOCUMENTS
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS pour éviter conflits services existants
CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_ALL_TERRANEX_DOCS
    ON content
    ATTRIBUTES file_path, filename, title, document_type, category
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT
            file_path,
            filename,
            title,
            document_type,
            category,
            content
        FROM TERRANEX_PARSED_CONTENT
        WHERE content IS NOT NULL
    );

SELECT '🔍 Service SEARCH_ALL_TERRANEX_DOCS créé !' AS status;

-- ======================================================================
-- SERVICE CORTEX SEARCH - RÉGLEMENTATION CRE
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_REGLEMENTATION_TERRANEX
    ON content
    ATTRIBUTES file_path, filename, title
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT
            file_path,
            filename,
            title,
            content
        FROM TERRANEX_PARSED_CONTENT
        WHERE document_type = 'REGLEMENTATION'
    );

SELECT '📜 Service SEARCH_REGLEMENTATION_TERRANEX créé !' AS status;

-- ======================================================================
-- SERVICE CORTEX SEARCH - PROCÉDURES INTERNES
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_PROCEDURES_TERRANEX
    ON content
    ATTRIBUTES file_path, filename, title
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT
            file_path,
            filename,
            title,
            content
        FROM TERRANEX_PARSED_CONTENT
        WHERE document_type = 'PROCEDURE'
    );

SELECT '📋 Service SEARCH_PROCEDURES_TERRANEX créé !' AS status;

-- ======================================================================
-- SERVICE CORTEX SEARCH - DOCUMENTS TECHNIQUES
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_TECHNIQUES_TERRANEX
    ON content
    ATTRIBUTES file_path, filename, title
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT
            file_path,
            filename,
            title,
            content
        FROM TERRANEX_PARSED_CONTENT
        WHERE document_type = 'TECHNIQUE'
    );

SELECT '🔧 Service SEARCH_TECHNIQUES_TERRANEX créé !' AS status;

-- ======================================================================
-- SERVICE CORTEX SEARCH - CONTRATS
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
CREATE CORTEX SEARCH SERVICE IF NOT EXISTS SEARCH_CONTRATS_TERRANEX
    ON content
    ATTRIBUTES file_path, filename, title
    WAREHOUSE = TERRANEX_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT
            file_path,
            filename,
            title,
            content
        FROM TERRANEX_PARSED_CONTENT
        WHERE document_type = 'CONTRAT'
    );

SELECT '📄 Service SEARCH_CONTRATS_TERRANEX créé !' AS status;

-- ======================================================================
-- VÉRIFICATION DES SERVICES CORTEX SEARCH
-- ======================================================================
SHOW CORTEX SEARCH SERVICES LIKE '%TERRANEX%';

SELECT 
    '🎯 RÉSUMÉ SERVICES CORTEX SEARCH TERRANEX' AS titre,
    '' AS service,
    '' AS documents
UNION ALL
SELECT 
    '',
    'SEARCH_ALL_TERRANEX_DOCS',
    'Tous les documents (4 types)'
UNION ALL
SELECT 
    '',
    'SEARCH_REGLEMENTATION_TERRANEX',
    'Réglementation CRE uniquement'
UNION ALL
SELECT 
    '',
    'SEARCH_PROCEDURES_TERRANEX',
    'Procédures internes uniquement'
UNION ALL
SELECT 
    '',
    'SEARCH_TECHNIQUES_TERRANEX',
    'Documents techniques uniquement'
UNION ALL
SELECT 
    '',
    'SEARCH_CONTRATS_TERRANEX',
    'Contrats production uniquement';

SELECT '✅ ÉTAPE 7 TERMINÉE - 5 services Cortex Search prêts pour l''agent 2 !' AS status;
