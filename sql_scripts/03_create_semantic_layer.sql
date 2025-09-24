-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 2: COUCHE SÉMANTIQUE
-- ======================================================================
-- Description: Création de la vue sémantique pour analyse intelligente des données
-- Tables: INJECTION_FACT + 4 dimensions
-- Propriétaire: Role SF_Intelligence_Demo
-- ======================================================================

USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- ======================================================================
-- VUE ANALYTIQUE TERRANEX BIOMÉTHANE (Alternative à la vue sémantique)
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
-- LEÇON: IF NOT EXISTS pour réutilisabilité
CREATE VIEW IF NOT EXISTS TERRANEX_BIOMETHANE_ANALYTICS_VIEW AS
SELECT 
    -- Clés primaires
    inj.ID_INJECTION,
    inj.ID_SITE,
    inj.ID_TEMPS,
    inj.ID_POSTE_RESEAU,
    inj.ID_ANALYSE_QUALITE,
    
    -- Faits de production
    inj.ENERGIE_INJECTEE_MWH as energie_mwh,
    inj.VOLUME_INJECTE_M3 as volume_m3,
    inj.DEBIT_MOYEN_M3_H as debit_m3h,
    inj.DUREE_INJECTION_MINUTES as duree_minutes,
    inj.PRESSION_INJECTION_BAR as pression_bar,
    inj.TEMPERATURE_GAZ_CELSIUS as temperature_celsius,
    inj.STATUT_INJECTION as statut_injection,
    
    -- Dimensions temporelles
    t.DATE_COMPLETE as date_injection,
    t.ANNEE as annee,
    t.TRIMESTRE as trimestre,
    t.MOIS_NOM as mois,
    t.JOUR_DE_LA_SEMAINE as jour_semaine,
    t.EST_FERIE as est_ferie,
    
    -- Dimensions sites
    s.NOM_SITE as nom_site,
    s.REGION as region,
    s.DEPARTEMENT as departement,
    s.TECHNOLOGIE_PRODUCTION as technologie,
    s.TYPE_INTRANTS as type_intrants,
    s.NOM_PRODUCTEUR as producteur,
    s.CAPACITE_NOMINALE_MWH_JOUR as capacite_nominale,
    s.STATUT_OPERATIONNEL as statut_site,
    
    -- Dimensions réseau
    r.NOM_POSTE_INJECTION as nom_poste,
    r.TYPE_POSTE as type_poste,
    r.ZONE_GEOGRAPHIQUE_RESEAU as zone_reseau,
    r.NIVEAU_PRESSION_BAR as niveau_pression,
    r.CAPACITE_INJECTION_MAX_NM3_H as capacite_max,
    r.STATUT_OPERATIONNEL as statut_poste,
    
    -- Dimensions qualité
    q.PCS_KWH_M3 as pcs,
    q.WOBBE_INDEX as wobbe_index,
    q.TENEUR_H2S_PPM as h2s_ppm,
    q.TENEUR_CO2_POURCENTAGE as co2_pourcent,
    q.STATUT_CONFORMITE as statut_qualite,
    q.LABORATOIRE_ANALYSE as laboratoire,
    q.METHODE_ANALYSE as methode_analyse

FROM INJECTION_FACT inj
    INNER JOIN SITE_DIM s ON inj.ID_SITE = s.ID_SITE
    INNER JOIN TEMPS_DIM t ON inj.ID_TEMPS = t.ID_TEMPS
    INNER JOIN RESEAU_DIM r ON inj.ID_POSTE_RESEAU = r.ID_POSTE_RESEAU
    INNER JOIN QUALITE_DIM q ON inj.ID_ANALYSE_QUALITE = q.ID_ANALYSE_QUALITE;

SELECT '🧠 Vue analytique TERRANEX_BIOMETHANE_ANALYTICS_VIEW créée avec succès !' AS status;

-- ======================================================================
-- TEST DE LA VUE ANALYTIQUE
-- ======================================================================
SELECT 
    '📊 APERÇU DES DONNÉES VIA VUE ANALYTIQUE' AS titre,
    '' AS metrique,
    '' AS valeur
UNION ALL
SELECT 
    '',
    'Production totale (MWh)',
    ROUND(SUM(energie_mwh), 2)::VARCHAR
FROM TERRANEX_BIOMETHANE_ANALYTICS_VIEW
UNION ALL
SELECT 
    '',
    'Volume total injecté (m³)',
    ROUND(SUM(volume_m3), 0)::VARCHAR
FROM TERRANEX_BIOMETHANE_ANALYTICS_VIEW
UNION ALL
SELECT 
    '',
    'Nombre d''injections',
    COUNT(*)::VARCHAR
FROM TERRANEX_BIOMETHANE_ANALYTICS_VIEW
UNION ALL
SELECT 
    '',
    'Sites actifs',
    COUNT(DISTINCT ID_SITE)::VARCHAR
FROM TERRANEX_BIOMETHANE_ANALYTICS_VIEW
UNION ALL
SELECT 
    '',
    'Technologies utilisées',
    COUNT(DISTINCT technologie)::VARCHAR
FROM TERRANEX_BIOMETHANE_ANALYTICS_VIEW;

SELECT '✅ ÉTAPE 2 TERMINÉE - Couche sémantique prête pour l''agent 1 !' AS status;
