#!/usr/bin/env python3
"""
Création d'un vrai modèle ML Python pour Terranex
Modèle de prédiction de production de biométhane avec scikit-learn
"""

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.preprocessing import LabelEncoder
import snowflake.snowpark as sp
from snowflake.ml.registry import Registry
import warnings
warnings.filterwarnings('ignore')

def create_snowpark_session():
    """Créer une session Snowpark avec les paramètres de connexion"""
    try:
        # Utiliser la connexion par défaut de Snow CLI (méthode alternative)
        import subprocess
        import json
        
        # Obtenir les paramètres de connexion depuis Snow CLI
        result = subprocess.run(['snow', 'connection', 'list', '--format', 'json'], 
                              capture_output=True, text=True)
        
        if result.returncode != 0:
            print("❌ Impossible d'obtenir les paramètres de connexion Snow CLI")
            print("💡 Utilisez 'snow connection test' pour vérifier votre configuration")
            return None
        
        # Créer la session avec les paramètres par défaut
        session = sp.Session.builder.app_name("TerranexML").create()
        
        # Configurer la base de données et le schéma
        session.use_role("SF_Intelligence_Demo")
        session.use_database("SF_AI_DEMO")
        session.use_schema("DEMO_SCHEMA")
        
        print("✅ Session Snowpark créée avec succès")
        return session
    except Exception as e:
        print(f"❌ Erreur de connexion: {e}")
        print("💡 Vérifiez votre configuration Snow CLI avec 'snow connection test'")
        return None

def prepare_training_data(session):
    """Préparer les données d'entraînement depuis Snowflake"""
    
    # Requête pour récupérer les données d'entraînement
    query = """
    SELECT 
        t.date_complete,
        EXTRACT(MONTH FROM t.date_complete) as mois,
        EXTRACT(DAYOFYEAR FROM t.date_complete) as jour_annee,
        EXTRACT(DAYOFWEEK FROM t.date_complete) as jour_semaine,
        CASE WHEN t.est_ferie THEN 1 ELSE 0 END as est_ferie,
        s.region,
        s.technologie_production,
        s.capacite_nominale_mwh_jour,
        r.niveau_pression_bar,
        COUNT(i.id_injection) as nb_injections,
        SUM(i.energie_injectee_mwh) as energie_totale,
        AVG(i.energie_injectee_mwh) as energie_moyenne,
        SUM(i.volume_injecte_m3) as volume_total
    FROM INJECTION_FACT i
    JOIN TEMPS_DIM t ON i.id_temps = t.id_temps
    JOIN SITE_DIM s ON i.id_site = s.id_site
    JOIN RESEAU_DIM r ON i.id_poste_reseau = r.id_poste_reseau
    WHERE t.date_complete >= '2020-01-01' 
      AND t.date_complete < '2025-09-01'
    GROUP BY 1,2,3,4,5,6,7,8,9
    ORDER BY t.date_complete
    """
    
    # Récupérer les données
    df = session.sql(query).to_pandas()
    print(f"📊 Données récupérées: {len(df)} lignes")
    
    return df

def create_and_train_model(df):
    """Créer et entraîner le modèle RandomForest"""
    
    # Encoder les variables catégorielles
    le_region = LabelEncoder()
    le_techno = LabelEncoder()
    
    df['region_encoded'] = le_region.fit_transform(df['region'])
    df['technologie_encoded'] = le_techno.fit_transform(df['technologie_production'])
    
    # Créer des features saisonnières
    df['saison_sin'] = np.sin(2 * np.pi * df['mois'] / 12)
    df['saison_cos'] = np.cos(2 * np.pi * df['mois'] / 12)
    
    # Sélectionner les features
    features = [
        'mois', 'jour_annee', 'jour_semaine', 'est_ferie',
        'region_encoded', 'technologie_encoded', 'capacite_nominale_mwh_jour',
        'niveau_pression_bar', 'nb_injections', 'saison_sin', 'saison_cos'
    ]
    
    X = df[features].fillna(0)
    y = df['energie_totale'].fillna(0)
    
    # Diviser en train/test
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, shuffle=False
    )
    
    # Créer et entraîner le modèle
    model = RandomForestRegressor(
        n_estimators=100,
        max_depth=15,
        min_samples_split=5,
        min_samples_leaf=2,
        random_state=42,
        n_jobs=-1
    )
    
    print("🔄 Entraînement du modèle...")
    model.fit(X_train, y_train)
    
    # Évaluer le modèle
    y_pred = model.predict(X_test)
    
    metrics = {
        'mae': float(mean_absolute_error(y_test, y_pred)),
        'rmse': float(np.sqrt(mean_squared_error(y_test, y_pred))),
        'r2_score': float(r2_score(y_test, y_pred)),
        'training_samples': int(len(X_train)),
        'test_samples': int(len(X_test)),
        'features_count': len(features)
    }
    
    print(f"📈 Performance du modèle:")
    print(f"  MAE: {metrics['mae']:.2f} MWh")
    print(f"  RMSE: {metrics['rmse']:.2f} MWh")
    print(f"  R²: {metrics['r2_score']:.3f}")
    
    return model, metrics, le_region, le_techno

def register_model_in_snowflake(session, model, metrics):
    """Enregistrer le modèle dans le Snowflake Model Registry"""
    
    try:
        # Ouvrir le registry
        registry = Registry(
            session=session, 
            database_name="SF_AI_DEMO", 
            schema_name="DEMO_SCHEMA"
        )
        
        print("🔄 Enregistrement du modèle dans le Snowflake Model Registry...")
        
        # Enregistrer le modèle
        model_version = registry.log_model(
            model=model,
            model_name="TERRANEX_BIOMETHANE_PREDICTOR",
            version_name="v1_0",
            comment="Modèle RandomForest de prédiction de production de biométhane Terranex - Entraîné sur données 2020-2025",
            metrics=metrics,
            conda_dependencies=["scikit-learn==1.3.0", "pandas", "numpy"]
        )
        
        print(f"✅ Modèle enregistré: {model_version.fully_qualified_model_name}")
        print(f"📋 Version: {model_version.version_name}")
        print(f"🎯 Le modèle est maintenant visible dans Snowsight Model Registry !")
        
        return model_version
        
    except Exception as e:
        print(f"❌ Erreur lors de l'enregistrement: {e}")
        return None

def main():
    """Fonction principale"""
    print("🚀 Création du modèle ML Terranex...")
    
    # Créer la session
    session = create_snowpark_session()
    if not session:
        return
    
    try:
        # Préparer les données
        print("📊 Récupération des données d'entraînement...")
        df = prepare_training_data(session)
        
        if len(df) == 0:
            print("❌ Aucune donnée récupérée")
            return
        
        # Créer et entraîner le modèle
        model, metrics, le_region, le_techno = create_and_train_model(df)
        
        # Enregistrer dans le registry
        model_version = register_model_in_snowflake(session, model, metrics)
        
        if model_version:
            print("\n🎉 SUCCÈS COMPLET !")
            print(f"📍 Modèle visible dans Snowsight à l'adresse :")
            print(f"   Data > Databases > SF_AI_DEMO > DEMO_SCHEMA > Models")
            print(f"📊 Métriques enregistrées: MAE={metrics['mae']:.1f}, R²={metrics['r2_score']:.3f}")
        
    except Exception as e:
        print(f"❌ Erreur générale: {e}")
    
    finally:
        if session:
            session.close()

if __name__ == "__main__":
    main()
