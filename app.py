from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)

model = joblib.load("model/road_sos_model.pkl")

@app.route('/analyze', methods=['POST'])
def analyze():
    data = request.get_json()
    description = data.get("description")

    prediction = model.predict([description])[0]

    return jsonify({
        "input": description,
        "severity": prediction
    })

if __name__ == "__main__":
    app.run(debug=True, port=5000)