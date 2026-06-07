from services.db_service import get_nearest

lat = 12.9716
lon = 77.5946

print(
    get_nearest(
        "hospitals",
        lat,
        lon
    )
)