import os
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
import joblib

# create folder automatically
os.makedirs("model", exist_ok=True)

data = [

# ---------------- LOW ----------------
("small scratch on bike no damage", "LOW"),
("minor dent on car bumper", "LOW"),
("vehicle slightly scratched in parking", "LOW"),
("light scratch nothing serious", "LOW"),
("bike fell small damage no injury", "LOW"),
("tiny dent on door", "LOW"),
("scrape on side mirror broken", "LOW"),
("very minor accident no harm", "LOW"),
("scratch while reversing car", "LOW"),
("paint damage only no crash", "LOW"),

# ---------------- MEDIUM ----------------
("car hit wall bumper damaged", "MEDIUM"),
("vehicle collision moderate damage", "MEDIUM"),
("bike hit car no injury but damage", "MEDIUM"),
("two vehicles scratched badly", "MEDIUM"),
("traffic accident vehicle damaged heavily", "MEDIUM"),
("car crashed into divider damage reported", "MEDIUM"),
("rear end collision cars damaged", "MEDIUM"),
("bike accident vehicle broken parts", "MEDIUM"),
("moderate crash no serious injury", "MEDIUM"),
("accident on road vehicles damaged", "MEDIUM"),

# ---------------- HIGH ----------------
("bike accident person injured bleeding", "HIGH"),
("car crash driver injured hospital needed", "HIGH"),
("vehicle collision passenger hurt", "HIGH"),
("highway accident serious injury reported", "HIGH"),
("two wheeler accident fracture suspected", "HIGH"),
("driver unconscious after crash", "HIGH"),
("severe accident people injured", "HIGH"),
("bike hit truck rider injured badly", "HIGH"),
("road accident serious wounds", "HIGH"),
("multiple injuries in vehicle crash", "HIGH"),

# ---------------- CRITICAL ----------------
("truck crash people unconscious emergency", "CRITICAL"),
("fire accident explosion multiple injured", "CRITICAL"),
("major highway collision fatal injuries", "CRITICAL"),
("car overturned people trapped inside", "CRITICAL"),
("severe crash multiple casualties", "CRITICAL"),
("accident victim not breathing emergency", "CRITICAL"),
("bus crash several people critically injured", "CRITICAL"),
("vehicle explosion emergency rescue needed", "CRITICAL"),
("fatal accident on highway multiple deaths", "CRITICAL"),
("driver unconscious bleeding heavily emergency", "CRITICAL"),

# ---------------- MIXED REAL-WORLD NOISE ----------------
("bike acident peple injrd bleedinng", "HIGH"),
("car crashh big damagee no injry", "MEDIUM"),
("accidnt vehcle hit walll", "MEDIUM"),
("truckkk crashhh emergencyyy peoplee hurt", "CRITICAL"),
("small scratchh on vehical", "LOW"),
("road accdnt severee injryyy", "HIGH"),
]

df = pd.DataFrame(data, columns=["text", "label"])

X = df["text"]
y = df["label"]

model = Pipeline([
    ("tfidf", TfidfVectorizer()),
    ("clf", LogisticRegression())
])

model.fit(X, y)

joblib.dump(model, "model/road_sos_model.pkl")

print("✅ Model trained successfully!")