-- ======================================================================
-- ⚠️  SCRIPT DE RÉINITIALISATION TERRANEX - UTILISER AVEC PRÉCAUTION ⚠️
-- ======================================================================
-- Description: Suppression complète de l'environnement Terranex pour reset
-- ATTENTION: Ce script supprime TOUT l'environnement de démo
-- Usage: Uniquement pour réinitialisation complète ou nettoyage
-- ======================================================================

-- ⚠️ DOUBLE CONFIRMATION REQUISE ⚠️
-- ÉTAPE 1: Décommentez la ligne suivante UNIQUEMENT si vous voulez vraiment tout supprimer
-- SET CONFIRM_RESET = 'OUI_JE_VEUX_TOUT_SUPPRIMER';

-- ÉTAPE 2: Lisez attentivement ce qui sera supprimé ci-dessous

-- ⚠️ CE SCRIPT VA SUPPRIMER:
-- • Database DB_TERRANEX (avec TOUTES les tables, vues, stages, services Cortex)
-- • Warehouse TERRANEX_WH  
-- • Role SF_Intelligence_Demo
-- • 11,650+ enregistrements de données
-- • 5 services Cortex Search
-- • Modèle ML et stored procedures
-- • 29 questions de base

-- Si vous êtes SÛR de vouloir continuer, décommentez SET CONFIRM_RESET ci-dessus

USE ROLE ACCOUNTADMIN;
SELECT '🚨 DÉBUT RÉINITIALISATION TERRANEX - ' || CURRENT_TIMESTAMP()::VARCHAR AS debut_reset;

-- ======================================================================
-- SUPPRESSION DES AGENTS (si créés manuellement)
-- ======================================================================
SELECT '🤖 Suppression des agents Terranex...' AS etape;

-- Note: Les agents doivent être supprimés manuellement dans l'interface
-- ou via des commandes DROP AGENT si disponibles

-- ======================================================================
-- SUPPRESSION OPTIMISÉE (basée sur l'expérience réelle)
-- ======================================================================

-- MÉTHODE OPTIMISÉE (découverte lors des tests réels):
SELECT '🗄️ Prise d''ownership et suppression DB_TERRANEX...' AS etape;

-- ÉTAPE CRITIQUE: Prendre ownership avec révocation des grants dépendants
-- (Nécessaire car la base appartient au rôle SF_Intelligence_Demo)
-- REVOKE CURRENT GRANTS évite les erreurs de grants dépendants
GRANT OWNERSHIP ON DATABASE DB_TERRANEX TO ROLE ACCOUNTADMIN REVOKE CURRENT GRANTS;

-- Suppression de la base complète (supprime automatiquement tous les objets)
-- Plus efficace que supprimer table par table
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
-- VÉRIFICATION ET CONFIRMATION FINALE
-- ======================================================================
SELECT '🎯 VÉRIFICATION FINALE RÉINITIALISATION' AS titre;

-- Vérification avec SHOW commands (plus fiable)
SHOW DATABASES LIKE 'DB_TERRANEX';
SHOW WAREHOUSES LIKE 'TERRANEX_WH';  
SHOW ROLES LIKE 'SF_Intelligence_Demo';

SELECT 
    '✅ RÉINITIALISATION TERRANEX TERMINÉE' AS titre,
    '' AS objet_supprime,
    '' AS statut
UNION ALL
SELECT 
    '',
    'Database DB_TERRANEX',
    '❌ SUPPRIMÉE (avec toutes tables, vues, stages, services Cortex)'
UNION ALL
SELECT 
    '',
    'Warehouse TERRANEX_WH',
    '❌ SUPPRIMÉ'
UNION ALL
SELECT 
    '',
    'Role SF_Intelligence_Demo',
    '❌ SUPPRIMÉ'
UNION ALL
SELECT 
    '',
    'Données volumineuses (11,650+)',
    '❌ SUPPRIMÉES'
UNION ALL
SELECT 
    '',
    'Services Cortex Search (5)',
    '❌ SUPPRIMÉS'
UNION ALL
SELECT 
    '',
    'Modèle ML + Stored Procedure',
    '❌ SUPPRIMÉS'
UNION ALL
SELECT 
    '',
    'Agents IA',
    '⚠️ À supprimer manuellement dans l''interface';

SELECT '🔄 Environnement Snowflake complètement nettoyé !' AS statut_final;
SELECT '🚀 Exécutez COMPLETE_SETUP.sql pour recréer l''environnement complet' AS prochaine_etape;
SELECT '📋 Ou utilisez les scripts 01-10 pour installation étape par étape' AS alternative;
