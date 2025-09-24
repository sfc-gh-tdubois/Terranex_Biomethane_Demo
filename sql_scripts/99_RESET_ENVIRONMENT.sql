-- ======================================================================
-- ⚠️  SCRIPT DE RÉINITIALISATION TERRANEX - UTILISER AVEC PRÉCAUTION ⚠️
-- ======================================================================
-- Description: Suppression complète de l'environnement Terranex pour reset
-- ATTENTION: Ce script supprime TOUT l'environnement de démo
-- Usage: Uniquement pour réinitialisation complète ou nettoyage
-- ======================================================================

-- ⚠️ CONFIRMATION REQUISE ⚠️
-- Décommentez la ligne suivante UNIQUEMENT si vous voulez vraiment tout supprimer
-- SET CONFIRM_RESET = 'OUI_JE_VEUX_TOUT_SUPPRIMER';

-- Vérification de sécurité
SELECT CASE 
    WHEN $CONFIRM_RESET = 'OUI_JE_VEUX_TOUT_SUPPRIMER' THEN 
        '🚨 RÉINITIALISATION CONFIRMÉE - SUPPRESSION EN COURS...'
    ELSE 
        '🛑 RÉINITIALISATION ANNULÉE - Décommentez SET CONFIRM_RESET pour continuer'
END AS statut_securite;

-- Arrêt si confirmation non fournie
-- (Le script s'arrêtera ici si CONFIRM_RESET n'est pas défini)

USE ROLE ACCOUNTADMIN;

-- ======================================================================
-- SUPPRESSION DES AGENTS (si créés manuellement)
-- ======================================================================
SELECT '🤖 Suppression des agents Terranex...' AS etape;

-- Note: Les agents doivent être supprimés manuellement dans l'interface
-- ou via des commandes DROP AGENT si disponibles

-- ======================================================================
-- SUPPRESSION DES SERVICES CORTEX SEARCH
-- ======================================================================
SELECT '🔍 Suppression des services Cortex Search...' AS etape;

USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

DROP CORTEX SEARCH SERVICE IF EXISTS SEARCH_ALL_TERRANEX_DOCS;
DROP CORTEX SEARCH SERVICE IF EXISTS SEARCH_REGLEMENTATION_TERRANEX;
DROP CORTEX SEARCH SERVICE IF EXISTS SEARCH_PROCEDURES_TERRANEX;
DROP CORTEX SEARCH SERVICE IF EXISTS SEARCH_TECHNIQUES_TERRANEX;
DROP CORTEX SEARCH SERVICE IF EXISTS SEARCH_CONTRATS_TERRANEX;

-- ======================================================================
-- SUPPRESSION DES OBJETS DE DONNÉES
-- ======================================================================
SELECT '📊 Suppression des tables et vues...' AS etape;

-- Suppression des vues et procédures
DROP PROCEDURE IF EXISTS PREDICT_TERRANEX_PRODUCTION(INT, INT);
DROP VIEW IF EXISTS ML_TRAINING_DATA;
DROP VIEW IF EXISTS TERRANEX_BIOMETHANE_ANALYTICS_VIEW;

-- Suppression des tables de contenu
DROP TABLE IF EXISTS TERRANEX_QUESTIONS_BASE;
DROP TABLE IF EXISTS TERRANEX_PARSED_CONTENT;

-- Suppression des tables principales (ordre important pour les FK)
DROP TABLE IF EXISTS INJECTION_FACT;
DROP TABLE IF EXISTS QUALITE_DIM;
DROP TABLE IF EXISTS RESEAU_DIM;
DROP TABLE IF EXISTS TEMPS_DIM;
DROP TABLE IF EXISTS SITE_DIM;

-- Suppression du stage
DROP STAGE IF EXISTS TERRANEX_DOCUMENTS_STAGE;

-- ======================================================================
-- SUPPRESSION DE LA BASE DE DONNÉES
-- ======================================================================
SELECT '🗄️ Suppression de la base DB_TERRANEX...' AS etape;

USE ROLE ACCOUNTADMIN;
DROP DATABASE IF EXISTS DB_TERRANEX;

-- ======================================================================
-- SUPPRESSION DU WAREHOUSE
-- ======================================================================
SELECT '🏭 Suppression du warehouse TERRANEX_WH...' AS etape;

DROP WAREHOUSE IF EXISTS TERRANEX_WH;

-- ======================================================================
-- SUPPRESSION DU RÔLE
-- ======================================================================
SELECT '👤 Suppression du rôle SF_Intelligence_Demo...' AS etape;

-- Révocation du rôle de l'utilisateur actuel
SET current_user_name = CURRENT_USER();
REVOKE ROLE SF_Intelligence_Demo FROM USER IDENTIFIER($current_user_name);

-- Suppression du rôle
DROP ROLE IF EXISTS SF_Intelligence_Demo;

-- ======================================================================
-- CONFIRMATION FINALE
-- ======================================================================
SELECT 
    '🎯 RÉINITIALISATION TERRANEX TERMINÉE' AS titre,
    '' AS objet_supprime,
    '' AS statut
UNION ALL
SELECT 
    '',
    'Rôle SF_Intelligence_Demo',
    '❌ SUPPRIMÉ'
UNION ALL
SELECT 
    '',
    'Warehouse TERRANEX_WH',
    '❌ SUPPRIMÉ'
UNION ALL
SELECT 
    '',
    'Database DB_TERRANEX',
    '❌ SUPPRIMÉE'
UNION ALL
SELECT 
    '',
    'Tables (5)',
    '❌ SUPPRIMÉES'
UNION ALL
SELECT 
    '',
    'Vues (2)',
    '❌ SUPPRIMÉES'
UNION ALL
SELECT 
    '',
    'Stage documents',
    '❌ SUPPRIMÉ'
UNION ALL
SELECT 
    '',
    'Services Cortex Search (5)',
    '❌ SUPPRIMÉS'
UNION ALL
SELECT 
    '',
    'Stored Procedure ML',
    '❌ SUPPRIMÉE'
UNION ALL
SELECT 
    '',
    'Agents IA (à supprimer manuellement)',
    '⚠️ MANUEL';

SELECT '🔄 Environnement prêt pour une nouvelle installation complète !' AS statut_final;
SELECT '📋 Exécutez maintenant les scripts 01 à 10 pour recréer l''environnement' AS prochaine_etape;
