import requests
from geopy.distance import geodesic
from services.db_service import get_nearest

OVERPASS_URL = "https://overpass.kumi.systems/api/interpreter"


def find_nearest_police(lat, lon):

    query = f"""
    [out:json];
    node["amenity"="police"](around:5000,{lat},{lon});
    out body;
    """

    try:
        response = requests.post(
            OVERPASS_URL,
            data=query,
            timeout=10
        )

        data = response.json()

        police_stations = []

        for item in data.get("elements", []):

            name = item.get("tags", {}).get(
                "name",
                "Unknown Police Station"
            )

            p_lat = item.get("lat")
            p_lon = item.get("lon")

            distance = geodesic(
                (lat, lon),
                (p_lat, p_lon)
            ).km

            police_stations.append({
                "name": name,
                "lat": p_lat,
                "lon": p_lon,
                "distance_km": round(distance, 2)
            })

        if police_stations:

            police_stations.sort(
                key=lambda x: x["distance_km"]
            )

            return police_stations[0]

    except Exception as e:
        print("Police API Error:", e)

    print("Using database fallback...")
    return get_nearest("police", lat, lon)