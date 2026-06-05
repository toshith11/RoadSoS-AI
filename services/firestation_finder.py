import requests
from geopy.distance import geodesic
from services.db_service import get_nearest

OVERPASS_URL = "https://overpass.kumi.systems/api/interpreter"


def find_nearest_firestation(lat, lon):

    query = f"""
    [out:json];
    node["amenity"="fire_station"](around:5000,{lat},{lon});
    out body;
    """

    try:
        response = requests.post(
            OVERPASS_URL,
            data=query,
            timeout=10
        )

        data = response.json()

        firestations = []

        for item in data.get("elements", []):

            name = item.get("tags", {}).get(
                "name",
                "Unknown Fire Station"
            )

            f_lat = item.get("lat")
            f_lon = item.get("lon")

            distance = geodesic(
                (lat, lon),
                (f_lat, f_lon)
            ).km

            firestations.append({
                "name": name,
                "lat": f_lat,
                "lon": f_lon,
                "distance_km": round(distance, 2)
            })

        if firestations:

            firestations.sort(
                key=lambda x: x["distance_km"]
            )

            return firestations[0]

    except Exception as e:
        print("Fire Station API Error:", e)

    print("Using database fallback...")
    return get_nearest("firestations", lat, lon)