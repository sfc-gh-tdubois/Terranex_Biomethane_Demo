#!/usr/bin/env python3
"""
Script minimal pour créer un modèle ML Terranex
"""

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, r2_score
import snowflake.snowpark as sp
from snowflake.ml.registry import Registry

def main():
    print("🚀 Création du modèle ML Terranex...")
    
    try:
        # Session Snowpark
        session = sp.Session.builder.app_name("TerranexML").create()
        session.use_role("SF_Intelligence_Demo")
        session.use_database("SF_AI_DEMO")
        session.use_schema("DEMO_SCHEMA")
        print("✅ Session créée")
        
        # Données synthétiques simples pour le modèle
        print("📊 Création de données synthétiques...")
        np.random.seed(42)
        
        # Créer des données synthétiques réalistes
        n_samples = 1000
        data = {
            'mois': np.random.randint(1, 13, n_samples),
            'jour_annee': np.random.randint(1, 366, n_samples),
            'region_code': np.random.randint(1, 14, n_samples),  # 13 régions
            'technologie_code': np.random.randint(1, 6, n_samples),  # 5 technologies
            'capacite': np.random.uniform(50, 500, n_samples)
        }
        
        # Target avec saisonnalité
        seasonal_factor = np.sin(2 * np.pi * data['mois'] / 12) * 0.2 + 1
        data['energie_totale'] = (
            data['capacite'] * seasonal_factor * 
            np.random.uniform(0.8, 1.2, n_samples) * 100
        )
        
        df = pd.DataFrame(data)
        print(f"📊 Données créées: {len(df)} lignes")
        
        # Préparer X et y
        X = df[['mois', 'jour_annee', 'region_code', 'technologie_code', 'capacite']]
        y = df['energie_totale']
        
        # Train/test split
        from sklearn.model_selection import train_test_split
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
        
        # Créer le modèle
        print("🔄 Entraînement du modèle...")
        model = RandomForestRegressor(n_estimators=50, max_depth=10, random_state=42)
        model.fit(X_train, y_train)
        
        # Évaluer
        y_pred = model.predict(X_test)
        mae = mean_absolute_error(y_test, y_pred)
        r2 = r2_score(y_test, y_pred)
        
        print(f"📈 MAE: {mae:.2f}, R²: {r2:.3f}")
        
        # Enregistrer dans le Model Registry
        print("🔄 Enregistrement dans le Model Registry...")
        registry = Registry(session=session, database_name="SF_AI_DEMO", schema_name="DEMO_SCHEMA")
        
        # Créer des données d'exemple pour la signature
        sample_input = X_train.head(1)
        
        model_version = registry.log_model(
            model=model,
            model_name="TERRANEX_BIOMETHANE_PREDICTOR",
            version_name="v1_0",
            comment="Modèle RandomForest de prédiction de production biométhane Terranex",
            metrics={'mae': mae, 'r2_score': r2, 'samples': len(X_train)},
            sample_input_data=sample_input
        )
        
        print(f"✅ SUCCÈS ! Modèle enregistré: {model_version.fully_qualified_model_name}")
        print("🎯 Le modèle est maintenant visible dans Snowsight Model Registry !")
        print("📍 Allez dans: Data > Databases > SF_AI_DEMO > DEMO_SCHEMA > Models")
        
    except Exception as e:
        print(f"❌ Erreur: {e}")

if __name__ == "__main__":
    main()
