from flask import Flask, request, jsonify

app = Flask(__name__)

# In-memory storage (temporary)
frozen_location = {}

@app.route('/location', methods=['POST'])
def receive_location():
    global frozen_location

    data = request.get_json()

    # Extract coordinates
    latitude = data.get("latitude")
    longitude = data.get("longitude")

    # Validate input
    if latitude is None or longitude is None:
        return jsonify({
            "status": "error",
            "message": "Latitude and Longitude required"
        }), 400

    # Freeze (store only once or overwrite as needed)
    frozen_location = {
        "latitude": latitude,
        "longitude": longitude
    }

    print("📍 Frozen Location Received:")
    print(f"Latitude: {latitude}")
    print(f"Longitude: {longitude}")

    return jsonify({
        "status": "success",
        "message": "Location frozen successfully",
        "data": frozen_location
    }), 200


# Optional: endpoint to view last frozen location
@app.route('/location', methods=['GET'])
def get_location():
    if not frozen_location:
        return jsonify({
            "status": "empty",
            "message": "No location stored yet"
        }), 404

    return jsonify({
        "status": "success",
        "data": frozen_location
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)