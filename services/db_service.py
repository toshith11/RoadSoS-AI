import sqlite3
from geopy.distance import geodesic
DB_PATH = "database/emergency.db"


# --------------------------------
# Create Database Tables
# --------------------------------
def init_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS hospitals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        lat REAL,
        lon REAL
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS police (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        lat REAL,
        lon REAL
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS firestations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        lat REAL,
        lon REAL
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS trauma (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        lat REAL,
        lon REAL
    )
    """)

    conn.commit()
    conn.close()

    print("Database tables created successfully!")


# --------------------------------
# Insert Sample Emergency Locations
# --------------------------------
def seed_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Hospitals
    cursor.executemany(
        """
        INSERT INTO hospitals (name, lat, lon)
        VALUES (?, ?, ?)
        """,
        [
            ("City Hospital", 12.9700, 77.5900),
            ("General Hospital", 12.9800, 77.6000)
        ]
    )

    # Police Stations
    cursor.executemany(
        """
        INSERT INTO police (name, lat, lon)
        VALUES (?, ?, ?)
        """,
        [
            ("Central Police Station", 12.9710, 77.5930),
            ("East Police Station", 12.9750, 77.5980)
        ]
    )

    # Fire Stations
    cursor.executemany(
        """
        INSERT INTO firestations (name, lat, lon)
        VALUES (?, ?, ?)
        """,
        [
            ("Fire Station A", 12.9720, 77.5950),
            ("Fire Station B", 12.9780, 77.6020)
        ]
    )

    # Trauma Centers
    cursor.executemany(
        """
        INSERT INTO trauma (name, lat, lon)
        VALUES (?, ?, ?)
        """,
        [
            ("Trauma Center A", 12.9730, 77.5960),
            ("Emergency Trauma Unit", 12.9790, 77.6030)
        ]
    )

    conn.commit()
    conn.close()

    print("Sample emergency locations inserted!")

    # --------------------------------
# Find Nearest Location
# --------------------------------
def get_nearest(table_name, user_lat, user_lon):

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute(
        f"SELECT name, lat, lon FROM {table_name}"
    )

    rows = cursor.fetchall()

    conn.close()

    if not rows:
        return None

    nearest = None
    min_distance = float("inf")

    for name, lat, lon in rows:

        distance = geodesic(
            (user_lat, user_lon),
            (lat, lon)
        ).km

        if distance < min_distance:

            min_distance = distance

            nearest = {
                "name": name,
                "lat": lat,
                "lon": lon,
                "distance_km": round(distance, 2)
            }

    return nearest