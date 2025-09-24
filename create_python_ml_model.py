#!/usr/bin/env python3
"""
Script pour créer un vrai modèle ML Python dans le Snowflake Model Registry
Utilise snowflake-ml-python pour un modèle qui apparaîtra dans Snowsight
"""

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error
import snowflake.snowpark as sp
from snowflake.ml.registry import Registry
from snowflake.ml.model import Model
import os

# Configuration de connexion Snowflake
def create_snowpark_session():
    """Créer une session Snowpark"""
    connection_parameters = {
        "account": os.getenv("SNOWFLAKE_ACCOUNT"),
        "user": os.getenv("SNOWFLAKE_USER"),
        "password": os.getenv("SNOWFLAKE_PASSWORD"),
        "role": "SF_Intelligence_Demo",
        "warehouse": "SNOW_INTELLIGENCE_DEMO_WH",
        "database": "SF_AI_DEMO",
        "schema": "DEMO_SCHEMA"
    }
    return sp.Session.builder.configs(connection_parameters).create()

def create_biomethane_ml_model():
    """Créer et enregistrer le modèle ML de prédiction biométhane"""
    
    # Créer la session Snowpark
    session = create_snowpark_session()
    
    # Récupérer les données d'entraînement depuis Snowflake
    training_data = session.sql("""
        SELECT 
            EXTRACT(MONTH FROM t.date_complete) as mois,
            EXTRACT(DAYOFYEAR FROM t.date_complete) as jour_annee,
            CASE WHEN t.est_ferie THEN 1 ELSE 0 END as est_ferie,
            CASE s.region 
                WHEN 'Hauts-de-France' THEN 1
                WHEN 'Auvergne-Rhône-Alpes' THEN 2
                WHEN 'Occitanie' THEN 3
                ELSE 0 
            END as region_encoded,
            s.capacite_nominale_mwh_jour,
            AVG(i.energie_injectee_mwh) as target_energie
        FROM INJECTION_FACT i
        JOIN TEMPS_DIM t ON i.id_temps = t.id_temps
        JOIN SITE_DIM s ON i.id_site = s.id_site
        WHERE t.date_complete >= '2020-01-01' 
          AND t.date_complete < '2025-09-01'
        GROUP BY 1,2,3,4,5
        ORDER BY t.date_complete
    """).to_pandas()
    
    print(f"Données récupérées: {len(training_data)} lignes")
    
    # Préparer les features et target
    features = ['mois', 'jour_annee', 'est_ferie', 'region_encoded', 'capacite_nominale_mwh_jour']
    X = training_data[features]
    y = training_data['target_energie']
    
    # Diviser en train/test
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Créer et entraîner le modèle
    model = RandomForestRegressor(
        n_estimators=100,
        max_depth=10,
        random_state=42,
        n_jobs=-1
    )
    
    model.fit(X_train, y_train)
    
    # Évaluer le modèle
    y_pred = model.predict(X_test)
    mae = mean_absolute_error(y_test, y_pred)
    mse = mean_squared_error(y_test, y_pred)
    rmse = np.sqrt(mse)
    
    print(f"Performance du modèle:")
    print(f"  MAE: {mae:.2f}")
    print(f"  RMSE: {rmse:.2f}")
    
    # Ouvrir le registry
    registry = Registry(session=session, database_name="SF_AI_DEMO", schema_name="DEMO_SCHEMA")
    
    # Enregistrer le modèle dans le registry
    model_version = registry.log_model(
        model=model,
        model_name="TERRANEX_BIOMETHANE_PREDICTOR",
        version_name="v1_0",
        comment="Modèle de prédiction de production de biométhane Terranex avec Random Forest",
        metrics={
            "mae": mae,
            "rmse": rmse,
            "mse": mse,
            "training_samples": len(X_train),
            "test_samples": len(X_test)
        },
        conda_dependencies=["scikit-learn", "pandas", "numpy"]
    )
    
    print(f"Modèle enregistré: {model_version.fully_qualified_model_name}")
    print(f"Version: {model_version.version_name}")
    
    return model_version

if __name__ == "__main__":
    try:
        mv = create_biomethane_ml_model()
        print("✅ Modèle ML Terranex créé avec succès dans le Model Registry !")
    except Exception as e:
        print(f"❌ Erreur: {e}")
        print("💡 Vérifiez vos variables d'environnement Snowflake")






