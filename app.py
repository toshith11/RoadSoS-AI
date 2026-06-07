from flask import Flask, request, jsonify

from predict import predict_resource

from services.hospital_finder import find_nearest_hospital
from services.police_finder import find_nearest_police
from services.firestation_finder import find_nearest_firestation
from services.trauma_finder import find_nearest_trauma_center

app = Flask(__name__)


# --------------------------------
# Home Route
# --------------------------------
@app.route("/")
def home():
    return "🚀 RoadSOS API Running Successfully"


# --------------------------------
# Recommendation Route
# --------------------------------
@app.route("/recommend", methods=["POST"])
def recommend():

    data = request.json

    severity = data.get("severity")
    lat = data.get("latitude")
    lon = data.get("longitude")

    # Validation
    if severity is None or lat is None or lon is None:
        return jsonify({
            "error": "Missing severity or location data"
        }), 400

    # -----------------------------
    # ML Prediction
    # -----------------------------
    recommended_resource = predict_resource(severity)

    result = {
        "severity": severity,
        "recommended_resource": recommended_resource
    }

    # -----------------------------
    # Location Services
    # -----------------------------
    if "Hospital" in recommended_resource:
        result["hospital"] = find_nearest_hospital(lat, lon)

    if "Police" in recommended_resource:
        result["police"] = find_nearest_police(lat, lon)

    if "Fire" in recommended_resource:
        result["fire_station"] = find_nearest_firestation(lat, lon)

    if "Trauma" in recommended_resource:
        result["trauma_center"] = find_nearest_trauma_center(lat, lon)

    return jsonify(result)


# --------------------------------
# Run Flask Server
# --------------------------------
if __name__ == "__main__":
    app.run(debug=True)