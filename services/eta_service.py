from geopy.distance import geodesic

def calculate_eta(
    user_lat,
    user_lon,
    service_lat,
    service_lon
):

    distance_km = geodesic(
        (user_lat, user_lon),
        (service_lat, service_lon)
    ).km

    # Assume average emergency vehicle speed
    avg_speed_kmph = 40

    eta_minutes = (
        distance_km / avg_speed_kmph
    ) * 60

    if eta_minutes < 1:
        eta_minutes = 1

    return round(eta_minutes)