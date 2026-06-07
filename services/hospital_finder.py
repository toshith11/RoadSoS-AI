import requests
from geopy.distance import geodesic
from services.db_service import get_nearest

OVERPASS_URL = "https://overpass-api.de/api/interpreter"


def find_nearest_hospital(lat, lon):

    query = f"""
    [out:json];
    node["amenity"="hospital"](around:5000,{lat},{lon});
    out body;
    """
    print("Searching hospital from OpenStreetMap...")
    try:
        response = requests.post(
            OVERPASS_URL,
            data=query,
            timeout=30
        )

        data = response.json()

        hospitals = []

        for item in data.get("elements", []):

            name = item.get("tags", {}).get(
                "name",
                "Unknown Hospital"
            )

            h_lat = item.get("lat")
            h_lon = item.get("lon")

            distance = geodesic(
                (lat, lon),
                (h_lat, h_lon)
            ).km

            hospitals.append({
                "name": name,
                "lat": h_lat,
                "lon": h_lon,
                "distance_km": round(distance, 2)
            })

        if hospitals:

            hospitals.sort(
                key=lambda x: x["distance_km"]
            )

            return hospitals[0]

    except Exception as e:
        print("Hospital API Error:", e)

    print("Using database fallback...")
    return get_nearest("hospitals", lat, lon)