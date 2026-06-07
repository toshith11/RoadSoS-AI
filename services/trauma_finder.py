import requests
from geopy.distance import geodesic
from services.db_service import get_nearest

OVERPASS_URL = OVERPASS_URL = "https://overpass-api.de/api/interpreter"



def find_nearest_trauma_center(lat, lon):

    query = f"""
    [out:json];
    (
      node["amenity"="hospital"](around:5000,{lat},{lon});
      node["healthcare"="centre"](around:5000,{lat},{lon});
      node["amenity"="clinic"](around:5000,{lat},{lon});
    );
    out body;
    """

    try:
        response = requests.post(
            OVERPASS_URL,
            data=query,
            timeout=10
        )

        data = response.json()

        centers = []

        for item in data.get("elements", []):

            name = item.get("tags", {}).get(
                "name",
                "Trauma Center"
            )

            t_lat = item.get("lat")
            t_lon = item.get("lon")

            distance = geodesic(
                (lat, lon),
                (t_lat, t_lon)
            ).km

            centers.append({
                "name": name,
                "lat": t_lat,
                "lon": t_lon,
                "distance_km": round(distance, 2)
            })

        if centers:

            centers.sort(
                key=lambda x: x["distance_km"]
            )

            return centers[0]

    except Exception as e:
        print("Trauma API Error:", e)

    print("Using database fallback...")
    return get_nearest("trauma", lat, lon)