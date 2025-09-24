-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 3: VUE SÉMANTIQUE (AVANT AGENT 1)
-- ======================================================================
-- Description: Création de la vue sémantique Terranex pour Cortex Analyst
-- Ordre: APRÈS vue analytique, AVANT agent 1
-- Propriétaire: Role SF_Intelligence_Demo
-- ======================================================================

USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- ======================================================================
-- VUE SÉMANTIQUE TERRANEX BIOMÉTHANE
-- ======================================================================
CREATE OR REPLACE SEMANTIC VIEW DB_TERRANEX.PRODUCTION.TERRANEX_BIOMETHAN_SEMANTIC_VIEW
    tables (
        INJECTION_FACT primary key (ID_INJECTION),
        QUALITE_DIM primary key (ID_ANALYSE_QUALITE),
        RESEAU_DIM primary key (ID_POSTE_RESEAU),
        SITE_DIM primary key (ID_SITE),
        TEMPS_DIM primary key (ID_TEMPS)
    )
    relationships (
        INJECTIONS_TO_SITES as INJECTION_FACT(ID_SITE) references SITE_DIM(ID_SITE),
        INJECTION_TO_TEMPS as INJECTION_FACT(ID_TEMPS) references TEMPS_DIM(ID_TEMPS),
        INJECTION_TO_RESEAU as INJECTION_FACT(ID_POSTE_RESEAU) references RESEAU_DIM(ID_POSTE_RESEAU),
        INJECTION_TO_ANALYSE as INJECTION_FACT(ID_ANALYSE_QUALITE) references QUALITE_DIM(ID_ANALYSE_QUALITE)
    )
    facts (
        INJECTION_FACT.DEBIT_MOYEN_M3_H as DEBIT_MOYEN_M3_H 
            with synonyms=('average_flow_rate','mean_flow_rate','flow_rate_average','debit_moyen','flow_rate') 
            comment='Débit moyen en mètres cubes par heure.',
        INJECTION_FACT.DUREE_INJECTION_MINUTES as DUREE_INJECTION_MINUTES 
            with synonyms=('injection_duration','injection_time','minutes_injected','duree_injection','injection_length') 
            comment='Durée de l''injection en minutes.',
        INJECTION_FACT.ENERGIE_INJECTEE_MWH as ENERGIE_INJECTEE_MWH 
            with synonyms=('injected_energy','energy_input','mwh_injected','energie_injectee','energy_injected','production_energy') 
            comment='Énergie injectée en mégawatt-heures.',
        INJECTION_FACT.PRESSION_INJECTION_BAR as PRESSION_INJECTION_BAR 
            with synonyms=('injection_pressure','bar_injection','pressure_bar','pression_injection','pressure_measurement') 
            comment='Pression du processus d''injection mesurée en bars.',
        INJECTION_FACT.TEMPERATURE_GAZ_CELSIUS as TEMPERATURE_GAZ_CELSIUS 
            with synonyms=('gas_temperature','celsius_reading','temperature_celsius','temperature_gaz','gas_temp') 
            comment='Température du gaz en Celsius au moment de l''injection.',
        INJECTION_FACT.VOLUME_INJECTE_M3 as VOLUME_INJECTE_M3 
            with synonyms=('injected_volume','volume_injected','cubic_meters_injected','volume_injecte','injection_volume') 
            comment='Volume de l''injection en mètres cubes.',
        QUALITE_DIM.PCS_KWH_M3 as PCS_KWH_M3 
            with synonyms=('heating_value','calorific_value','pcs','power_calorific','energy_content') 
            comment='Pouvoir Calorifique Supérieur en kWh par mètre cube.',
        QUALITE_DIM.TENEUR_CO2_POURCENTAGE as TENEUR_CO2_POURCENTAGE 
            with synonyms=('co2_content','carbon_dioxide','co2_percentage','teneur_co2','co2_level') 
            comment='Teneur en CO2 en pourcentage.',
        QUALITE_DIM.TENEUR_H2S_PPM as TENEUR_H2S_PPM 
            with synonyms=('h2s_content','hydrogen_sulfide','h2s_ppm','teneur_h2s','sulfur_content') 
            comment='Teneur en H2S en parties par million.',
        QUALITE_DIM.WOBBE_INDEX as WOBBE_INDEX 
            with synonyms=('wobbe','combustion_index','wobbe_number','indice_wobbe','combustibility') 
            comment='Index Wobbe pour la combustibilité du gaz.',
        RESEAU_DIM.CAPACITE_INJECTION_MAX_NM3_H as CAPACITE_INJECTION_MAX_NM3_H 
            with synonyms=('max_injection_capacity','maximum_flow','capacite_max','max_capacity','injection_capacity') 
            comment='Capacité maximale d''injection en Nm³/h.',
        RESEAU_DIM.NIVEAU_PRESSION_BAR as NIVEAU_PRESSION_BAR 
            with synonyms=('pressure_level','network_pressure','pression_reseau','grid_pressure','system_pressure') 
            comment='Niveau de pression du réseau en bars.',
        SITE_DIM.CAPACITE_NOMINALE_MWH_JOUR as CAPACITE_NOMINALE_MWH_JOUR 
            with synonyms=('nominal_capacity','site_capacity','capacite_nominale','daily_capacity','production_capacity') 
            comment='Capacité nominale du site en MWh par jour.',
        TEMPS_DIM.ANNEE as ANNEE 
            with synonyms=('year','yearly','annual','annee','year_value') 
            comment='Année de l''injection.',
        TEMPS_DIM.SEMAINE_NUMERO as SEMAINE_NUMERO 
            with synonyms=('week_number','week','semaine','week_of_year','weekly') 
            comment='Numéro de la semaine dans l''année.'
    )
    dimensions (
        INJECTION_FACT.STATUT_INJECTION as STATUT_INJECTION 
            with synonyms=('injection_status','status','statut','operation_status') 
            comment='Statut de l''injection (COMPLETE, PARTIEL, ARRET, etc.).',
        QUALITE_DIM.LABORATOIRE_ANALYSE as LABORATOIRE_ANALYSE 
            with synonyms=('laboratory','lab','laboratoire','analysis_lab') 
            comment='Laboratoire ayant effectué l''analyse.',
        QUALITE_DIM.METHODE_ANALYSE as METHODE_ANALYSE 
            with synonyms=('analysis_method','method','methode','test_method') 
            comment='Méthode d''analyse utilisée.',
        QUALITE_DIM.STATUT_CONFORMITE as STATUT_CONFORMITE 
            with synonyms=('compliance_status','conformity','conformite','quality_status') 
            comment='Statut de conformité de l''analyse (Conforme/Non-Conforme).',
        RESEAU_DIM.NOM_POSTE_INJECTION as NOM_POSTE_INJECTION 
            with synonyms=('injection_post_name','network_post_name','poste_nom') 
            comment='Nom du poste d''injection.',
        RESEAU_DIM.TYPE_POSTE as TYPE_POSTE 
            with synonyms=('post_type','injection_type','poste_type','network_type') 
            comment='Type de poste (INJECTION_MP, INJECTION_HP, INJECTION_THP).',
        RESEAU_DIM.ZONE_GEOGRAPHIQUE_RESEAU as ZONE_GEOGRAPHIQUE_RESEAU 
            with synonyms=('geographic_zone','network_zone','zone_reseau','geographic_area') 
            comment='Zone géographique du réseau.',
        SITE_DIM.DEPARTEMENT as DEPARTEMENT 
            with synonyms=('department','dept','departement_code','administrative_division') 
            comment='Département français du site.',
        SITE_DIM.NOM_PRODUCTEUR as NOM_PRODUCTEUR 
            with synonyms=('producer_name','company_name','producteur','operator_name') 
            comment='Nom du producteur exploitant le site.',
        SITE_DIM.NOM_SITE as NOM_SITE 
            with synonyms=('site_name','facility_name','location_name','site_nom') 
            comment='Nom du site de production.',
        SITE_DIM.REGION as REGION 
            with synonyms=('region','regional_area','zone_region','geographic_region') 
            comment='Région française du site.',
        SITE_DIM.TECHNOLOGIE_PRODUCTION as TECHNOLOGIE_PRODUCTION 
            with synonyms=('production_technology','technology','tech','technologie','production_method') 
            comment='Technologie de production utilisée.',
        SITE_DIM.TYPE_INTRANTS as TYPE_INTRANTS 
            with synonyms=('feedstock_type','input_type','intrants','raw_material','substrate_type') 
            comment='Type d''intrants utilisés pour la production.',
        TEMPS_DIM.DATE_COMPLETE as DATE_COMPLETE 
            with synonyms=('full_date','complete_date','date_complete','injection_date') 
            comment='Date complète de l''injection.',
        TEMPS_DIM.EST_FERIE as EST_FERIE 
            with synonyms=('is_holiday','holiday','ferie','public_holiday','bank_holiday') 
            comment='Indicateur si le jour est férié.',
        TEMPS_DIM.JOUR_DE_LA_SEMAINE as JOUR_DE_LA_SEMAINE 
            with synonyms=('day_of_week','weekday','jour_semaine','day_name') 
            comment='Jour de la semaine.',
        TEMPS_DIM.MOIS_NOM as MOIS_NOM 
            with synonyms=('month_name','month','mois','month_label') 
            comment='Nom du mois.',
        TEMPS_DIM.TRIMESTRE as TRIMESTRE 
            with synonyms=('quarter','quarterly','trimestre_numero','quarter_number') 
            comment='Trimestre de l''année.'
    )
    metrics (
        INJECTION_FACT.ENERGIE_TOTALE as SUM(ENERGIE_INJECTEE_MWH) 
            with synonyms=('total_energy','overall_energy','energy_total','production_totale','cumulative_energy') 
            comment='Énergie totale injectée dans le système.',
        INJECTION_FACT.VOLUME_TOTAL as SUM(VOLUME_INJECTE_M3) 
            with synonyms=('total_volume','overall_volume','volume_total','cumulative_volume') 
            comment='Volume total injecté en mètres cubes.',
        INJECTION_FACT.NB_INJECTIONS as COUNT(ID_INJECTION) 
            with synonyms=('injection_count','number_injections','count_injections','total_injections') 
            comment='Nombre total d''injections.'
    )
    comment='Vue sémantique complète pour l''analyse de la production de biométhane Terranex - Optimisée pour Cortex Analyst';

SELECT '✅ Étape 3 terminée - Vue sémantique Cortex Analyst créée' AS resultat;

-- ======================================================================
-- TEST DE LA VUE SÉMANTIQUE
-- ======================================================================
SELECT '🔍 Test de la vue sémantique...' AS etape;

-- Vérification avec SHOW (les semantic views ne sont pas dans INFORMATION_SCHEMA.VIEWS)
SHOW SEMANTIC VIEWS LIKE 'TERRANEX_BIOMETHAN_SEMANTIC_VIEW';

-- Note: Les semantic views sont utilisées par Cortex Analyst, pas pour SELECT direct
SELECT '✅ Vue sémantique créée - Utilisable par Cortex Analyst pour questions langage naturel' AS note_usage;

SELECT 
    '🎯 RÉSUMÉ VUE SÉMANTIQUE TERRANEX' AS titre,
    '' AS composant,
    '' AS details
UNION ALL
SELECT 
    '',
    'Tables liées',
    '5 tables (INJECTION_FACT + 4 dimensions)'
UNION ALL
SELECT 
    '',
    'Relationships',
    '4 relations FK définies'
UNION ALL
SELECT 
    '',
    'Facts',
    '15 faits avec synonymes et commentaires'
UNION ALL
SELECT 
    '',
    'Dimensions',
    '17 dimensions avec synonymes'
UNION ALL
SELECT 
    '',
    'Metrics',
    '3 métriques (énergie, volume, count)'
UNION ALL
SELECT 
    '',
    'Cortex Analyst',
    '✅ Prête pour questions langage naturel'
UNION ALL
SELECT 
    '',
    'Synonymes',
    '100+ synonymes anglais/français'
UNION ALL
SELECT 
    '',
    'Usage',
    'Prête pour Agent 1 et Cortex Analyst';

SELECT '✅ ÉTAPE 3 TERMINÉE - Vue sémantique prête pour l''agent 1 !' AS status;
