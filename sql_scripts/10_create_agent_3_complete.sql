-- ======================================================================
-- TERRANEX BIOMÉTHANE - ÉTAPE 12: AGENT 3 - EXPERT COMPLET
-- ======================================================================
-- Description: Agent IA expert complet Terranex avec ML + Cortex Search
-- Capacités: Données + Documents + Prédictions ML + Questions de base
-- Propriétaire: Role SF_Intelligence_Demo
-- ======================================================================

USE ROLE SF_Intelligence_Demo;
USE DATABASE DB_TERRANEX;
USE SCHEMA PRODUCTION;

-- ======================================================================
-- CONFIGURATION AGENT 3 - EXPERT COMPLET TERRANEX
-- ======================================================================

SELECT 'AGENT 3 - TERRANEX_EXPERT_COMPLET' AS agent_name,
       'Expert complet: Données + Documents + ML' AS description,
       'Vue analytique + 5 services Cortex Search + Stored Procedure ML' AS capabilities,
       'TERRANEX_WH' AS warehouse;

-- ======================================================================
-- QUESTIONS DE BASE POUR L'AGENT 3
-- ======================================================================

-- SÉCURISÉ: Pas de remplacement automatique
CREATE TABLE TERRANEX_QUESTIONS_BASE (
    ID INT AUTOINCREMENT PRIMARY KEY,
    CATEGORIE VARCHAR(50),
    QUESTION TEXT,
    TYPE_REPONSE VARCHAR(50),
    EXEMPLE_REPONSE TEXT,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Questions sur la production
INSERT INTO TERRANEX_QUESTIONS_BASE (CATEGORIE, QUESTION, TYPE_REPONSE, EXEMPLE_REPONSE) VALUES
('PRODUCTION', 'Quelle est la production totale de biométhane cette année ?', 'DONNEES', 'Utilise la vue TERRANEX_BIOMETHANE_ANALYTICS_VIEW pour calculer SUM(energie_mwh) WHERE annee = 2024'),
('PRODUCTION', 'Quels sont les 5 sites les plus performants ?', 'DONNEES', 'Utilise la vue pour GROUP BY nom_site et ORDER BY SUM(energie_mwh) DESC LIMIT 5'),
('PRODUCTION', 'Comment évolue la production par mois ?', 'DONNEES', 'Utilise la vue pour GROUP BY mois et calculer les totaux mensuels'),
('PRODUCTION', 'Quel est l''impact des jours fériés sur la production ?', 'DONNEES', 'Compare la production moyenne WHERE est_ferie = TRUE vs FALSE'),
('PRODUCTION', 'Quelle technologie est la plus efficace ?', 'DONNEES', 'GROUP BY technologie et calcule la production moyenne par MWh de capacité');

-- Questions sur la réglementation
INSERT INTO TERRANEX_QUESTIONS_BASE (CATEGORIE, QUESTION, TYPE_REPONSE, EXEMPLE_REPONSE) VALUES
('REGLEMENTATION', 'Quelles sont les spécifications CRE pour la qualité du biométhane ?', 'DOCUMENTS', 'Utilise SEARCH_REGLEMENTATION_TERRANEX avec "spécifications qualité CRE"'),
('REGLEMENTATION', 'Que dit la réglementation sur les seuils H2S ?', 'DOCUMENTS', 'Recherche dans SEARCH_REGLEMENTATION_TERRANEX "H2S seuils limites"'),
('REGLEMENTATION', 'Quelles sont les sanctions en cas de non-conformité ?', 'DOCUMENTS', 'Utilise SEARCH_REGLEMENTATION_TERRANEX "sanctions non-conformité"'),
('REGLEMENTATION', 'Quelles sont les obligations de reporting à la CRE ?', 'DOCUMENTS', 'Recherche "reporting CRE obligations" dans la réglementation');

-- Questions sur les procédures
INSERT INTO TERRANEX_QUESTIONS_BASE (CATEGORIE, QUESTION, TYPE_REPONSE, EXEMPLE_REPONSE) VALUES
('PROCEDURES', 'Comment faire la maintenance préventive d''un site ?', 'DOCUMENTS', 'Utilise SEARCH_PROCEDURES_TERRANEX "maintenance préventive"'),
('PROCEDURES', 'Que faire en cas de dérive qualité H2S ?', 'DOCUMENTS', 'Recherche dans SEARCH_PROCEDURES_TERRANEX "H2S dérive qualité"'),
('PROCEDURES', 'Quelle est la procédure d''exploitation quotidienne ?', 'DOCUMENTS', 'Utilise SEARCH_PROCEDURES_TERRANEX "exploitation quotidienne"'),
('PROCEDURES', 'Comment gérer un arrêt de poste d''injection ?', 'DOCUMENTS', 'Recherche "arrêt poste injection" dans les procédures');

-- Questions techniques
INSERT INTO TERRANEX_QUESTIONS_BASE (CATEGORIE, QUESTION, TYPE_REPONSE, EXEMPLE_REPONSE) VALUES
('TECHNIQUE', 'Quelles sont les spécifications techniques de la méthanisation liquide ?', 'DOCUMENTS', 'Utilise SEARCH_TECHNIQUES_TERRANEX "méthanisation liquide spécifications"'),
('TECHNIQUE', 'Comment raccorder un site au réseau gaz ?', 'DOCUMENTS', 'Recherche dans SEARCH_TECHNIQUES_TERRANEX "raccordement réseau"'),
('TECHNIQUE', 'Quels sont les paramètres optimaux de production ?', 'DOCUMENTS', 'Utilise SEARCH_TECHNIQUES_TERRANEX "paramètres optimaux"'),
('TECHNIQUE', 'Quels équipements sont requis pour l''injection ?', 'DOCUMENTS', 'Recherche "équipements injection" dans la documentation technique');

-- Questions contractuelles
INSERT INTO TERRANEX_QUESTIONS_BASE (CATEGORIE, QUESTION, TYPE_REPONSE, EXEMPLE_REPONSE) VALUES
('CONTRATS', 'Quels sont les termes du contrat Normandie ?', 'DOCUMENTS', 'Utilise SEARCH_CONTRATS_TERRANEX "Normandie contrat termes"'),
('CONTRATS', 'Quelles sont les pénalités en cas de retard ?', 'DOCUMENTS', 'Recherche dans SEARCH_CONTRATS_TERRANEX "pénalités retard"'),
('CONTRATS', 'Quelle est la durée standard des contrats ?', 'DOCUMENTS', 'Utilise SEARCH_CONTRATS_TERRANEX "durée contrat"'),
('CONTRATS', 'Quels sont les bonus qualité prévus ?', 'DOCUMENTS', 'Recherche "bonus qualité" dans les contrats');

-- Questions prédictives
INSERT INTO TERRANEX_QUESTIONS_BASE (CATEGORIE, QUESTION, TYPE_REPONSE, EXEMPLE_REPONSE) VALUES
('PREDICTION', 'Quelle sera la production du site 5 en janvier ?', 'ML', 'Utilise PREDICT_TERRANEX_PRODUCTION(5, 1)'),
('PREDICTION', 'Prédis la production du site 10 en été ?', 'ML', 'Utilise PREDICT_TERRANEX_PRODUCTION(10, 7) pour juillet'),
('PREDICTION', 'Quel site aura la meilleure production en hiver ?', 'ML', 'Teste plusieurs sites avec PREDICT_TERRANEX_PRODUCTION(site_id, 12)'),
('PREDICTION', 'Comment l''hiver affecte-t-il la production ?', 'ML', 'Compare les prédictions pour différents mois d''hiver');

-- Questions mixtes (données + documents + ML)
INSERT INTO TERRANEX_QUESTIONS_BASE (CATEGORIE, QUESTION, TYPE_REPONSE, EXEMPLE_REPONSE) VALUES
('MIXTE', 'Analyse complète du site Normandie : historique, contrat et prévisions', 'DONNEES+DOCUMENTS+ML', 'Combine vue analytique + SEARCH_CONTRATS_TERRANEX + PREDICT_TERRANEX_PRODUCTION'),
('MIXTE', 'Quel site respecte le mieux la réglementation CRE ?', 'DONNEES+DOCUMENTS', 'Analyse qualité via vue + vérification spécifications CRE'),
('MIXTE', 'Optimisation production : recommandations basées sur données et procédures', 'DONNEES+DOCUMENTS', 'Analyse performance + recherche procédures optimisation'),
('MIXTE', 'Rapport complet technologie méthanisation : performance + documentation', 'DONNEES+DOCUMENTS', 'Statistiques par technologie + documentation technique');

SELECT '❓ ' || COUNT(*) || ' questions de base créées pour l''agent 3' AS status
FROM TERRANEX_QUESTIONS_BASE;

-- ======================================================================
-- INSTRUCTIONS COMPLÈTES POUR L'AGENT 3
-- ======================================================================

SELECT '
AGENT 3: TERRANEX EXPERT COMPLET

DISPLAY NAME: "Terranex - Expert Complet Biométhane"

INSTRUCTIONS:
Tu es l''expert ultime Terranex combinant TOUTES les capacités:

🎯 TES DONNÉES:
- Vue analytique: TERRANEX_BIOMETHANE_ANALYTICS_VIEW (10K injections, 50 sites)
- Données historiques complètes: production, qualité, performance

🔍 TES OUTILS CORTEX SEARCH:
1. SEARCH_ALL_TERRANEX_DOCS - Recherche globale
2. SEARCH_REGLEMENTATION_TERRANEX - Réglementation CRE
3. SEARCH_PROCEDURES_TERRANEX - Procédures internes
4. SEARCH_TECHNIQUES_TERRANEX - Documentation technique
5. SEARCH_CONTRATS_TERRANEX - Contrats production

🤖 TON MODÈLE ML:
- Stored Procedure: PREDICT_TERRANEX_PRODUCTION(site_id, mois)
- Prédictions basées sur 8 features: capacité, technologie, saison, qualité
- Modèle RandomForest Python avec 8500 échantillons d''entraînement

📋 TES QUESTIONS DE BASE (' || (SELECT COUNT(*) FROM TERRANEX_QUESTIONS_BASE) || ' exemples):

PRODUCTION:
- "Quelle est la production totale cette année ?"
- "Quels sont les 5 sites les plus performants ?"
- "Comment évolue la production par mois ?"

RÉGLEMENTATION:
- "Quelles sont les spécifications CRE pour le H2S ?"
- "Que dit la réglementation sur les seuils qualité ?"

PROCÉDURES:
- "Comment faire la maintenance d''un site ?"
- "Que faire en cas de dérive qualité ?"

TECHNIQUE:
- "Spécifications de la méthanisation liquide ?"
- "Comment raccorder un site au réseau ?"

CONTRATS:
- "Termes du contrat Normandie ?"
- "Pénalités en cas de retard ?"

PRÉDICTIONS:
- "Production prévue du site 5 en janvier ?"
- "Quel site sera le plus performant en hiver ?"

ANALYSES MIXTES:
- "Analyse complète site Normandie ?"
- "Optimisation production recommandations ?"

🎯 TON APPROCHE:
1. Identifie le type de question (données/documents/ML/mixte)
2. Utilise les bons outils selon le besoin
3. Combine les sources pour des analyses complètes
4. Fournis des recommandations actionnables
5. Cite tes sources et méthodes

TON STYLE:
- Expert technique complet
- Analyses multi-sources
- Recommandations concrètes
- Visualisation des KPIs
- Communication claire et structurée
' AS instructions_agent_3;

SELECT '🤖 Configuration Agent 3 EXPERT COMPLET préparée !' AS status;
SELECT '✅ ÉTAPE 12 TERMINÉE - Agent 3 avec ' || COUNT(*) || ' questions de base !' AS status
FROM TERRANEX_QUESTIONS_BASE;
