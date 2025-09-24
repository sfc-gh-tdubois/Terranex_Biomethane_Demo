-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 1: SETUP DATABASE ET TABLES
-- ======================================================================
-- Description: Création de la base DB_TERRANEX avec 4 dimensions + 1 fact table
-- Propriétaire: Role SF_Intelligence_Demo
-- Volume: 50 sites, 1000 dates, 100 postes, 500 analyses, 10K injections
-- ======================================================================

USE ROLE ACCOUNTADMIN;

-- Création et configuration du rôle SF_Intelligence_Demo
-- SÉCURISÉ: Pas de DROP automatique
-- LEÇON: IF NOT EXISTS recommandé pour éviter erreurs si rôle existe
CREATE ROLE IF NOT EXISTS SF_Intelligence_Demo;
SET current_user_name = CURRENT_USER();
GRANT ROLE SF_Intelligence_Demo TO USER IDENTIFIER($current_user_name);
GRANT CREATE DATABASE ON ACCOUNT TO ROLE SF_Intelligence_Demo;

-- Création du warehouse dédié
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS + AUTO_SUSPEND pour réutilisabilité
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

-- Basculer vers le rôle SF_Intelligence_Demo
USE ROLE SF_Intelligence_Demo;

-- Création de la base DB_TERRANEX
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS pour éviter erreurs si base existe
CREATE DATABASE IF NOT EXISTS DB_TERRANEX;
USE DATABASE DB_TERRANEX;
CREATE SCHEMA IF NOT EXISTS PRODUCTION;
USE SCHEMA PRODUCTION;

SELECT '🏗️  Base DB_TERRANEX créée avec succès !' AS status;

-- ======================================================================
-- DIMENSION 1: SITES DE PRODUCTION
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS pour éviter conflits lors de ré-exécutions
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

-- ======================================================================
-- DIMENSION 2: DIMENSION TEMPORELLE
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS pour éviter conflits lors de ré-exécutions
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

-- ======================================================================
-- DIMENSION 3: POSTES RÉSEAU
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS pour éviter conflits lors de ré-exécutions
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

-- ======================================================================
-- DIMENSION 4: ANALYSES QUALITÉ
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS pour éviter conflits lors de ré-exécutions
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

-- ======================================================================
-- TABLE DE FAITS: INJECTIONS BIOMÉTHANE
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS pour éviter conflits lors de ré-exécutions
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
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    
    -- Contraintes de clés étrangères
    FOREIGN KEY (ID_SITE) REFERENCES SITE_DIM(ID_SITE),
    FOREIGN KEY (ID_TEMPS) REFERENCES TEMPS_DIM(ID_TEMPS),
    FOREIGN KEY (ID_POSTE_RESEAU) REFERENCES RESEAU_DIM(ID_POSTE_RESEAU),
    FOREIGN KEY (ID_ANALYSE_QUALITE) REFERENCES QUALITE_DIM(ID_ANALYSE_QUALITE)
);

SELECT '📊 Tables créées - Prêt pour l''insertion des données volumineuses...' AS status;
