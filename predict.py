import joblib
import numpy as np

# -----------------------------
# Load trained model + encoders
# -----------------------------
model = joblib.load("models/resource_model.pkl")
severity_encoder = joblib.load("models/severity_encoder.pkl")
resource_encoder = joblib.load("models/resource_encoder.pkl")


# -----------------------------
# Prediction function
# -----------------------------
def predict_resource(severity):

    try:
        # Encode input severity
        encoded_input = severity_encoder.transform([severity])[0]

        # Model expects 2D array
        prediction = model.predict([[encoded_input]])

        # Convert back to readable label
        result = resource_encoder.inverse_transform(prediction)

        return result[0]

    except Exception as e:
        return f"Error in prediction: {str(e)}"


# -----------------------------
# Manual test (run this file directly)
# -----------------------------
if __name__ == "__main__":

    test_cases = ["LOW", "MEDIUM", "HIGH", "CRITICAL"]

    for case in test_cases:
        print(f"{case} → {predict_resource(case)}")