#!/usr/bin/env python3
"""
Script simplifié pour créer un modèle ML Terranex dans le Model Registry
"""

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.preprocessing import LabelEncoder
import snowflake.snowpark as sp
from snowflake.ml.registry import Registry

def main():
    print("🚀 Création du modèle ML Terranex...")
    
    try:
        # Créer une session Snowpark simple
        session = sp.Session.builder.app_name("TerranexML").create()
        
        # Configurer l'environnement
        session.use_role("SF_Intelligence_Demo")
        session.use_database("SF_AI_DEMO")
        session.use_schema("DEMO_SCHEMA")
        
        print("✅ Session Snowpark créée")
        
        # Récupérer des données agrégées simples
        query = """
        SELECT 
            EXTRACT(MONTH FROM t.date_complete) as mois,
            EXTRACT(DAYOFYEAR FROM t.date_complete) as jour_annee,
            s.region,
            s.technologie_production,
            AVG(s.capacite_nominale_mwh_jour) as capacite_moyenne,
            SUM(i.energie_injectee_mwh) as energie_totale
        FROM INJECTION_FACT i
        JOIN TEMPS_DIM t ON i.id_temps = t.id_temps
        JOIN SITE_DIM s ON i.id_site = s.id_site
        WHERE t.date_complete >= '2020-01-01' 
          AND t.date_complete < '2025-09-01'
        GROUP BY 
            EXTRACT(MONTH FROM t.date_complete),
            EXTRACT(DAYOFYEAR FROM t.date_complete),
            s.region,
            s.technologie_production
        LIMIT 1000
        """
        
        # Récupérer les données
        print("📊 Récupération des données...")
        df = session.sql(query).to_pandas()
        print(f"📊 Données récupérées: {len(df)} lignes")
        
        if len(df) == 0:
            print("❌ Aucune donnée récupérée")
            return
        
        # Préparer les features
        print("🔧 Préparation des features...")
        le_region = LabelEncoder()
        le_techno = LabelEncoder()
        
        df['region_encoded'] = le_region.fit_transform(df['region'])
        df['technologie_encoded'] = le_techno.fit_transform(df['technologie_production'])
        
        # Features simples
        features = ['mois', 'jour_annee', 'region_encoded', 'technologie_encoded', 'capacite_moyenne']
        X = df[features].fillna(0)
        y = df['energie_totale'].fillna(0)
        
        # Diviser en train/test
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        
        print(f"📊 Train: {len(X_train)} lignes, Test: {len(X_test)} lignes")
        
        # Créer et entraîner le modèle
        print("🔄 Entraînement du modèle RandomForest...")
        model = RandomForestRegressor(
            n_estimators=50,
            max_depth=10,
            random_state=42,
            n_jobs=1
        )
        
        model.fit(X_train, y_train)
        
        # Évaluer le modèle
        y_pred = model.predict(X_test)
        
        metrics = {
            'mae': float(mean_absolute_error(y_test, y_pred)),
            'rmse': float(np.sqrt(mean_squared_error(y_test, y_pred))),
            'r2_score': float(r2_score(y_test, y_pred)),
            'training_samples': int(len(X_train)),
            'test_samples': int(len(X_test))
        }
        
        print(f"📈 Performance:")
        print(f"  MAE: {metrics['mae']:.2f} MWh")
        print(f"  RMSE: {metrics['rmse']:.2f} MWh")
        print(f"  R²: {metrics['r2_score']:.3f}")
        
        # Enregistrer dans le Model Registry
        print("🔄 Enregistrement dans le Model Registry...")
        registry = Registry(
            session=session, 
            database_name="SF_AI_DEMO", 
            schema_name="DEMO_SCHEMA"
        )
        
        model_version = registry.log_model(
            model=model,
            model_name="TERRANEX_BIOMETHANE_PREDICTOR",
            version_name="v1_0",
            comment="Modèle RandomForest de prédiction Terranex",
            metrics=metrics
        )
        
        print(f"✅ Modèle enregistré: {model_version.fully_qualified_model_name}")
        print(f"📋 Version: {model_version.version_name}")
        print("🎯 Le modèle est maintenant visible dans Snowsight Model Registry !")
        
    except Exception as e:
        print(f"❌ Erreur: {e}")
        print("💡 Vérifiez votre connexion Snowflake")

if __name__ == "__main__":
    main()






