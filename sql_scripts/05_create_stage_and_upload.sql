-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 5: STAGE ET IMPORT DOCUMENTS
-- ======================================================================
-- Description: Création du stage et import massif des documents Terranex
-- Volume: 120+ documents (réglementation, procédures, techniques, contrats)
-- Propriétaire: Role SF_Intelligence_Demo
-- ======================================================================

USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- ======================================================================
-- CRÉATION DU STAGE POUR DOCUMENTS TERRANEX
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS + DIRECTORY ENABLE pour parsing
CREATE STAGE IF NOT EXISTS TERRANEX_DOCUMENTS_STAGE
    DIRECTORY = (ENABLE = TRUE)
    COMMENT = 'Stage pour documents non structurés Terranex - Réglementation, Procédures, Techniques, Contrats';

SELECT '📁 Stage TERRANEX_DOCUMENTS_STAGE créé avec succès !' AS status;

-- ======================================================================
-- UPLOAD DES DOCUMENTS TERRANEX PAR CATÉGORIE
-- ======================================================================

-- Réglementation CRE
PUT file://terranex_documents/reglementation_cre/CRE_2020_Specifications_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/reglementation_cre/CRE_2021_Specifications_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/reglementation_cre/CRE_2022_Specifications_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/reglementation_cre/CRE_2023_Specifications_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/reglementation_cre/CRE_2024_Specifications_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/reglementation_cre/ARRETE_2020_Qualite_Gaz.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/reglementation_cre/ARRETE_2021_Qualite_Gaz.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/reglementation_cre/ARRETE_2022_Qualite_Gaz.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/reglementation_cre/ARRETE_2023_Qualite_Gaz.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/reglementation_cre/ARRETE_2024_Qualite_Gaz.txt @TERRANEX_DOCUMENTS_STAGE/reglementation/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- Procédures internes
PUT file://terranex_documents/procedures_internes/PROC_EXP_001_Exploitation_Quotidienne.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_EXP_002_Exploitation_Quotidienne.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_EXP_003_Exploitation_Quotidienne.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_EXP_004_Exploitation_Quotidienne.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_EXP_005_Exploitation_Quotidienne.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_MAI_001_Maintenance_Preventive.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_MAI_002_Maintenance_Preventive.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_MAI_003_Maintenance_Preventive.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_MAI_004_Maintenance_Preventive.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_MAI_005_Maintenance_Preventive.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_QUA_001_Controle_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_QUA_002_Controle_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_QUA_003_Controle_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_QUA_004_Controle_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/procedures_internes/PROC_QUA_005_Controle_Qualite.txt @TERRANEX_DOCUMENTS_STAGE/procedures/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- Documents techniques
PUT file://terranex_documents/documents_techniques/TECH_Methanisation_Liquide_Manuel_Technique.txt @TERRANEX_DOCUMENTS_STAGE/techniques/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/documents_techniques/TECH_Methanisation_Liquide_Guide_Raccordement.txt @TERRANEX_DOCUMENTS_STAGE/techniques/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/documents_techniques/TECH_Methanisation_Seche_Manuel_Technique.txt @TERRANEX_DOCUMENTS_STAGE/techniques/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/documents_techniques/TECH_Methanisation_Seche_Guide_Raccordement.txt @TERRANEX_DOCUMENTS_STAGE/techniques/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/documents_techniques/TECH_Pyrogazeification_Manuel_Technique.txt @TERRANEX_DOCUMENTS_STAGE/techniques/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/documents_techniques/TECH_Pyrogazeification_Guide_Raccordement.txt @TERRANEX_DOCUMENTS_STAGE/techniques/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/documents_techniques/TECH_Gazeification_Plasma_Manuel_Technique.txt @TERRANEX_DOCUMENTS_STAGE/techniques/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/documents_techniques/TECH_Gazeification_Plasma_Guide_Raccordement.txt @TERRANEX_DOCUMENTS_STAGE/techniques/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- Contrats (échantillon représentatif)
PUT file://terranex_documents/contrats/Contrat_Terranex_Normandie_SAS_CTR-2024-1004.txt @TERRANEX_DOCUMENTS_STAGE/contrats/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/contrats/Contrat_Terranex_Bretagne_SAS_CTR-2024-1035.txt @TERRANEX_DOCUMENTS_STAGE/contrats/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/contrats/Contrat_Terranex_Occitanie_SAS_CTR-2024-1005.txt @TERRANEX_DOCUMENTS_STAGE/contrats/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/contrats/Contrat_Terranex_Auvergne_SAS_CTR-2024-1091.txt @TERRANEX_DOCUMENTS_STAGE/contrats/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://terranex_documents/contrats/Contrat_Terranex_Grand_Est_SAS_CTR-2024-1024.txt @TERRANEX_DOCUMENTS_STAGE/contrats/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- ======================================================================
-- VÉRIFICATION DU CONTENU DU STAGE
-- ======================================================================
LIST @TERRANEX_DOCUMENTS_STAGE;

SELECT 
    '📊 RÉSUMÉ UPLOAD DOCUMENTS TERRANEX' AS titre,
    '' AS categorie,
    '' AS nb_fichiers
UNION ALL
SELECT 
    '',
    'Réglementation CRE',
    '10 fichiers'
UNION ALL
SELECT 
    '',
    'Procédures internes',
    '15 fichiers'
UNION ALL
SELECT 
    '',
    'Documents techniques',
    '8 fichiers'
UNION ALL
SELECT 
    '',
    'Contrats échantillon',
    '5 fichiers'
UNION ALL
SELECT 
    '',
    'TOTAL UPLOADÉ',
    '38 fichiers';

SELECT '✅ ÉTAPE 5 TERMINÉE - Documents uploadés dans le stage !' AS status;
