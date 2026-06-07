import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.ensemble import RandomForestClassifier
import joblib
import os

# -----------------------------
# 1. Load dataset
# -----------------------------
df = pd.read_csv("data/emergency_dataset.csv")

print("Dataset loaded:")
print(df.head())

# -----------------------------
# 2. Encode severity (input)
# -----------------------------
severity_encoder = LabelEncoder()
df["severity_encoded"] = severity_encoder.fit_transform(df["severity"])

# -----------------------------
# 3. Encode resource (output)
# -----------------------------
resource_encoder = LabelEncoder()
df["resource_encoded"] = resource_encoder.fit_transform(df["resource"])

# -----------------------------
# 4. Model training
# -----------------------------
X = df["severity_encoded"].values.reshape(-1, 1)
y = df["resource_encoded"]

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X, y)

print("\nModel training completed!")

# -----------------------------
# 5. Create models folder
# -----------------------------
os.makedirs("models", exist_ok=True)

# -----------------------------
# 6. Save everything
# -----------------------------
joblib.dump(model, "models/resource_model.pkl")
joblib.dump(severity_encoder, "models/severity_encoder.pkl")
joblib.dump(resource_encoder, "models/resource_encoder.pkl")

print("Models saved successfully in /models folder")