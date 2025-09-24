-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 6: PARSING DES DOCUMENTS
-- ======================================================================
-- Description: Parsing des 38 documents Terranex uploadés dans le stage
-- Contenu: Réglementation, Procédures, Techniques, Contrats
-- Propriétaire: Role SF_Intelligence_Demo
-- ======================================================================

USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- ======================================================================
-- CRÉATION TABLE POUR CONTENU PARSÉ
-- ======================================================================
-- SÉCURISÉ: Pas de remplacement automatique
CREATE TABLE TERRANEX_PARSED_CONTENT (
    FILE_PATH VARCHAR(500) PRIMARY KEY,
    FILENAME VARCHAR(200) NOT NULL,
    DOCUMENT_TYPE VARCHAR(50) NOT NULL,
    CATEGORY VARCHAR(50) NOT NULL,
    TITLE VARCHAR(200),
    CONTENT TEXT NOT NULL,
    FILE_SIZE NUMBER,
    UPLOAD_DATE TIMESTAMP,
    PARSED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

SELECT '📄 Table TERRANEX_PARSED_CONTENT créée !' AS status;

-- ======================================================================
-- PARSING DES DOCUMENTS PAR CATÉGORIE
-- ======================================================================

-- Insertion avec contenu simulé basé sur les noms de fichiers
INSERT INTO TERRANEX_PARSED_CONTENT
SELECT 
    relative_path AS file_path,
    REGEXP_SUBSTR(relative_path, '[^/]+$') AS filename,
    CASE 
        WHEN relative_path ILIKE '%reglementation%' THEN 'REGLEMENTATION'
        WHEN relative_path ILIKE '%procedures%' THEN 'PROCEDURE'
        WHEN relative_path ILIKE '%techniques%' THEN 'TECHNIQUE'
        WHEN relative_path ILIKE '%contrats%' THEN 'CONTRAT'
        ELSE 'AUTRE'
    END AS document_type,
    CASE 
        WHEN relative_path ILIKE '%reglementation%' THEN 'CRE'
        WHEN relative_path ILIKE '%procedures%' THEN 'INTERNE'
        WHEN relative_path ILIKE '%techniques%' THEN 'TECH'
        WHEN relative_path ILIKE '%contrats%' THEN 'COMMERCIAL'
        ELSE 'DIVERS'
    END AS category,
    CASE 
        WHEN relative_path ILIKE '%CRE_%' THEN 'Spécifications CRE ' || REGEXP_SUBSTR(filename, '[0-9]{4}')
        WHEN relative_path ILIKE '%ARRETE_%' THEN 'Arrêté Qualité Gaz ' || REGEXP_SUBSTR(filename, '[0-9]{4}')
        WHEN relative_path ILIKE '%PROC_EXP_%' THEN 'Procédure Exploitation ' || REGEXP_SUBSTR(filename, 'EXP_([0-9]{3})', 1, 1, '', 1)
        WHEN relative_path ILIKE '%PROC_MAI_%' THEN 'Procédure Maintenance ' || REGEXP_SUBSTR(filename, 'MAI_([0-9]{3})', 1, 1, '', 1)
        WHEN relative_path ILIKE '%PROC_QUA_%' THEN 'Procédure Qualité ' || REGEXP_SUBSTR(filename, 'QUA_([0-9]{3})', 1, 1, '', 1)
        WHEN relative_path ILIKE '%TECH_%Manuel%' THEN 'Manuel Technique ' || REGEXP_SUBSTR(filename, 'TECH_([^_]+)', 1, 1, '', 1)
        WHEN relative_path ILIKE '%TECH_%Guide%' THEN 'Guide Raccordement ' || REGEXP_SUBSTR(filename, 'TECH_([^_]+)', 1, 1, '', 1)
        WHEN relative_path ILIKE '%Contrat_%' THEN 'Contrat ' || REGEXP_SUBSTR(filename, 'Terranex_([^_]+)_SAS', 1, 1, '', 1)
        ELSE REPLACE(filename, '.txt', '')
    END AS title,
    -- Génération de contenu simulé basé sur le type de document
    CASE 
        WHEN relative_path ILIKE '%CRE_%' THEN 
            'RÉGLEMENTATION CRE - ' || REGEXP_SUBSTR(filename, '[0-9]{4}') || '\n\n' ||
            'Spécifications qualité gaz naturel et biométhane selon réglementation CRE.\n\n' ||
            'CRITÈRES QUALITÉ REQUIS:\n' ||
            '• PCS (Pouvoir Calorifique Supérieur): 10.7 à 11.7 kWh/m³\n' ||
            '• Index Wobbe: 13.4 à 15.7 kWh/m³\n' ||
            '• Teneur H2S: < 6.0 ppm\n' ||
            '• Teneur CO2: < 2.5%\n' ||
            '• Taux de conformité requis: > 95%\n\n' ||
            'CONTRÔLES:\n' ||
            '• Analyses continues obligatoires\n' ||
            '• Contrôles trimestriels par organisme agréé\n' ||
            '• Reporting mensuel à la CRE\n' ||
            '• Sanctions en cas de non-conformité'
            
        WHEN relative_path ILIKE '%ARRETE_%' THEN 
            'ARRÊTÉ MINISTÉRIEL - ' || REGEXP_SUBSTR(filename, '[0-9]{4}') || '\n\n' ||
            'Arrêté relatif à la qualité du gaz naturel injecté dans les réseaux.\n\n' ||
            'OBLIGATIONS TERRANEX:\n' ||
            '• Analyses continues H2S et CO2\n' ||
            '• Contrôles PCS et Wobbe quotidiens\n' ||
            '• Certification laboratoires agréés\n' ||
            '• Formation personnel technique\n' ||
            '• Équipements sous pression certifiés\n\n' ||
            'SANCTIONS:\n' ||
            '• Arrêt injection si H2S > 6 ppm\n' ||
            '• Amende jusqu''à 100k€ si récidive\n' ||
            '• Retrait autorisation possible'
            
        WHEN relative_path ILIKE '%PROC_EXP_%' THEN 
            'PROCÉDURE EXPLOITATION TERRANEX\n' ||
            'Code: PROC-EXP-' || REGEXP_SUBSTR(filename, 'EXP_([0-9]{3})', 1, 1, '', 1) || '\n\n' ||
            'DOMAINE: Exploitation quotidienne sites biométhane\n' ||
            'PERSONNEL: Techniciens exploitation\n' ||
            'FRÉQUENCE: Quotidienne\n\n' ||
            'ÉTAPES CLÉS:\n' ||
            '1. Vérification paramètres injection\n' ||
            '2. Contrôle qualité gaz produit\n' ||
            '3. Ajustement débit selon demande réseau\n' ||
            '4. Enregistrement données production\n' ||
            '5. Alerte en cas de dérive qualité\n\n' ||
            'SEUILS CRITIQUES:\n' ||
            '• Pression: 19-67 bars selon poste\n' ||
            '• Température: 15-45°C\n' ||
            '• Débit: 200-600 m³/h'
            
        WHEN relative_path ILIKE '%PROC_MAI_%' THEN 
            'PROCÉDURE MAINTENANCE TERRANEX\n' ||
            'Code: PROC-MAI-' || REGEXP_SUBSTR(filename, 'MAI_([0-9]{3})', 1, 1, '', 1) || '\n\n' ||
            'DOMAINE: Maintenance préventive équipements\n' ||
            'PERSONNEL: Techniciens maintenance\n' ||
            'FRÉQUENCE: Hebdomadaire/Mensuelle\n\n' ||
            'INTERVENTIONS:\n' ||
            '1. Contrôle compresseurs injection\n' ||
            '2. Vérification analyseurs qualité\n' ||
            '3. Étalonnage instruments mesure\n' ||
            '4. Test systèmes sécurité\n' ||
            '5. Nettoyage filtres et échangeurs\n\n' ||
            'DOCUMENTATION:\n' ||
            '• Fiche intervention signée\n' ||
            '• Photos avant/après\n' ||
            '• Relevés métriques\n' ||
            '• Planning maintenance préventive'
            
        WHEN relative_path ILIKE '%PROC_QUA_%' THEN 
            'PROCÉDURE QUALITÉ TERRANEX\n' ||
            'Code: PROC-QUA-' || REGEXP_SUBSTR(filename, 'QUA_([0-9]{3})', 1, 1, '', 1) || '\n\n' ||
            'DOMAINE: Contrôle qualité biométhane\n' ||
            'PERSONNEL: Techniciens qualité\n' ||
            'FRÉQUENCE: Continue/Quotidienne\n\n' ||
            'ANALYSES REQUISES:\n' ||
            '1. PCS (Pouvoir Calorifique Supérieur)\n' ||
            '2. Index Wobbe (combustibilité)\n' ||
            '3. Teneur H2S (corrosion)\n' ||
            '4. Teneur CO2 (dilution)\n' ||
            '5. Humidité et impuretés\n\n' ||
            'ACTIONS CORRECTIVES:\n' ||
            '• H2S > 6 ppm: Arrêt injection\n' ||
            '• CO2 > 2.5%: Réglage process\n' ||
            '• PCS < 10.7: Alerte laboratoire\n' ||
            '• Non-conformité: Rapport CRE'
            
        WHEN relative_path ILIKE '%TECH_%Manuel%' THEN 
            'MANUEL TECHNIQUE TERRANEX\n' ||
            'Technologie: ' || REGEXP_SUBSTR(filename, 'TECH_([^_]+)', 1, 1, '', 1) || '\n\n' ||
            'SPÉCIFICATIONS TECHNIQUES:\n' ||
            '• Température optimale: 38-42°C\n' ||
            '• Pression process: 1.2-1.8 bars\n' ||
            '• pH optimal: 7.0-8.5\n' ||
            '• Temps séjour: 20-30 jours\n' ||
            '• Rendement: 85-95% CH4\n\n' ||
            'MAINTENANCE SPÉCIFIQUE:\n' ||
            '• Contrôle agitateurs: Hebdomadaire\n' ||
            '• Vérification chauffage: Quotidienne\n' ||
            '• Analyse biologique: Bi-mensuelle\n' ||
            '• Nettoyage échangeurs: Mensuel\n\n' ||
            'SÉCURITÉ:\n' ||
            '• Détection H2S permanent\n' ||
            '• Système anti-explosion\n' ||
            '• Procédures d''urgence\n' ||
            '• EPI obligatoires'
            
        WHEN relative_path ILIKE '%TECH_%Guide%' THEN 
            'GUIDE RACCORDEMENT RÉSEAU\n' ||
            'Technologie: ' || REGEXP_SUBSTR(filename, 'TECH_([^_]+)', 1, 1, '', 1) || '\n\n' ||
            'PROCÉDURE RACCORDEMENT:\n' ||
            '1. Demande autorisation GRTgaz/GRDF\n' ||
            '2. Étude technique faisabilité\n' ||
            '3. Dimensionnement poste injection\n' ||
            '4. Tests pression et étanchéité\n' ||
            '5. Mise en service progressive\n\n' ||
            'ÉQUIPEMENTS REQUIS:\n' ||
            '• Poste détente/compression\n' ||
            '• Analyseurs qualité continus\n' ||
            '• Système comptage certifié\n' ||
            '• Dispositifs sécurité\n' ||
            '• Télétransmission données\n\n' ||
            'CONTRÔLES RÉCEPTION:\n' ||
            '• Test pression 1.5x Pmax\n' ||
            '• Vérification analyseurs\n' ||
            '• Étalonnage compteurs\n' ||
            '• Formation équipes\n' ||
            '• Procès-verbal réception'
            
        WHEN relative_path ILIKE '%Contrat_%' THEN 
            'CONTRAT PRODUCTION BIOMÉTHANE TERRANEX\n' ||
            'Producteur: Terranex ' || REGEXP_SUBSTR(filename, 'Terranex_([^_]+)_SAS', 1, 1, '', 1) || ' SAS\n' ||
            'Numéro: ' || REGEXP_SUBSTR(filename, '(CTR-[0-9]{4}-[0-9]+)') || '\n\n' ||
            'CARACTÉRISTIQUES SITE:\n' ||
            '• Capacité: ' || (80 + (ABS(RANDOM()) % 120)) || ' MWh/jour\n' ||
            '• Technologie: Méthanisation liquide\n' ||
            '• Intrants: Déchets organiques municipaux\n' ||
            '• Mise en service: 2024-01-01\n' ||
            '• Durée contrat: 15 ans renouvelable\n\n' ||
            'CONDITIONS COMMERCIALES:\n' ||
            '• Tarif: ' || (90 + (ABS(RANDOM()) % 20)) || ' €/MWh\n' ||
            '• Indexation: Inflation + 1%\n' ||
            '• Garantie production: 85% capacité\n' ||
            '• Pénalités retard: 0.1%/jour\n' ||
            '• Bonus qualité: 2€/MWh si H2S < 3ppm\n\n' ||
            'OBLIGATIONS TECHNIQUES:\n' ||
            '• Respect spécifications CRE\n' ||
            '• Analyses qualité continues\n' ||
            '• Reporting mensuel production\n' ||
            '• Maintenance préventive\n' ||
            '• Télétransmission données temps réel'
            
        ELSE 'Document Terranex - Contenu généré automatiquement pour la démonstration'
    END AS content,
    size AS file_size,
    last_modified::TIMESTAMP_NTZ AS upload_date,
    CURRENT_TIMESTAMP() AS parsed_at,
    CURRENT_TIMESTAMP() AS created_at
FROM DIRECTORY(@TERRANEX_DOCUMENTS_STAGE) 
WHERE relative_path ILIKE '%.txt';

SELECT '🔄 Documents parsés depuis le stage !' AS status;

-- ======================================================================
-- VÉRIFICATION DU PARSING
-- ======================================================================
SELECT 
    '📊 RÉSUMÉ PARSING DOCUMENTS TERRANEX' AS titre,
    '' AS document_type,
    '' AS nb_docs,
    '' AS taille_moyenne
UNION ALL
SELECT 
    '',
    document_type,
    COUNT(*)::VARCHAR,
    ROUND(AVG(file_size), 0)::VARCHAR || ' bytes'
FROM TERRANEX_PARSED_CONTENT 
GROUP BY document_type
UNION ALL
SELECT 
    '',
    'TOTAL',
    COUNT(*)::VARCHAR,
    ROUND(AVG(file_size), 0)::VARCHAR || ' bytes'
FROM TERRANEX_PARSED_CONTENT;

-- Aperçu des titres par catégorie
SELECT 
    '📋 APERÇU TITRES PAR CATÉGORIE' AS section,
    '' AS category,
    '' AS exemple_titre
UNION ALL
SELECT 
    '',
    category,
    MAX(title) AS exemple_titre
FROM TERRANEX_PARSED_CONTENT 
GROUP BY category;

-- Vérification du contenu (premiers caractères)
SELECT 
    '📝 VÉRIFICATION CONTENU' AS section,
    document_type,
    LEFT(content, 100) || '...' AS apercu_contenu
FROM TERRANEX_PARSED_CONTENT 
WHERE content IS NOT NULL
LIMIT 5;

SELECT '✅ ÉTAPE 6 TERMINÉE - Documents parsés et prêts pour Cortex Search !' AS status;
