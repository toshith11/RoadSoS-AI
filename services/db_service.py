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
# Insert Emergency Locations
# --------------------------------
def seed_db():

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Clear old data
    cursor.execute("DELETE FROM hospitals")
    cursor.execute("DELETE FROM police")
    cursor.execute("DELETE FROM firestations")
    cursor.execute("DELETE FROM trauma")

    # --------------------------------
    # Hospitals
    # --------------------------------
    cursor.executemany(
        """
        INSERT INTO hospitals (name, lat, lon)
        VALUES (?, ?, ?)
        """,
        [
           
    # Bengaluru
    ("Sakra World Hospital", 12.9279, 77.6846),
    ("Manipal Hospital", 12.9595, 77.6498),
    ("Narayana Health City", 12.8173, 77.6845),
    ("Aster CMI Hospital", 13.0456, 77.5926),
    ("St John's Medical College Hospital", 12.9352, 77.6203),

    # Chennai / IIT Madras Area
    ("Apollo Hospitals Greams Road", 13.0634, 80.2518),
    ("Fortis Malar Hospital", 13.0103, 80.2577),
    ("MIOT International", 13.0215, 80.1852),
    ("Sri Ramachandra Medical Centre", 13.0386, 80.1410),
    ("Kauvery Hospital Alwarpet", 13.0336, 80.2543),
    ("Government Rajiv Gandhi Hospital", 13.0810, 80.2752)

        ]
    )

    # --------------------------------
    # Police Stations
    # --------------------------------
    cursor.executemany(
        """
        INSERT INTO police (name, lat, lon)
        VALUES (?, ?, ?)
        """,
        [
            # Bengaluru
    ("Bellandur Police Station", 12.9258, 77.6762),
    ("Marathahalli Police Station", 12.9565, 77.7010),
    ("Whitefield Police Station", 12.9698, 77.7499),
    ("HSR Layout Police Station", 12.9121, 77.6388),

    # Chennai / IIT Madras Area
    ("Adyar Police Station", 13.0067, 80.2574),
    ("Thiruvanmiyur Police Station", 12.9827, 80.2597),
    ("Kotturpuram Police Station", 13.0185, 80.2416),
    ("Velachery Police Station", 12.9815, 80.2209),
    ("Guindy Police Station", 13.0064, 80.2206)
        ]
    )

    # --------------------------------
    # Fire Stations
    # --------------------------------
    cursor.executemany(
        """
        INSERT INTO firestations (name, lat, lon)
        VALUES (?, ?, ?)
        """,
        [
            # Bengaluru
    ("Bellandur Fire Station", 12.9280, 77.6760),
    ("Whitefield Fire Station", 12.9750, 77.7480),
    ("Electronic City Fire Station", 12.8460, 77.6650),

    # Chennai / IIT Madras Area
    ("Adyar Fire Station", 13.0065, 80.2570),
    ("Guindy Fire Station", 13.0080, 80.2200),
    ("Velachery Fire Station", 12.9790, 80.2210),
    ("Taramani Fire Station", 12.9858, 80.2420)
        ]
    )

    # --------------------------------
    # Trauma Centers
    # --------------------------------
    cursor.executemany(
        """
        INSERT INTO trauma (name, lat, lon)
        VALUES (?, ?, ?)
        """,
        [
            # Bengaluru
    ("Sakra Trauma Center", 12.9279, 77.6846),
    ("Manipal Emergency Trauma", 12.9595, 77.6498),
    ("Narayana Trauma Unit", 12.8173, 77.6845),

    # Chennai / IIT Madras Area
    ("Apollo Emergency Trauma Center", 13.0634, 80.2518),
    ("Fortis Malar Trauma Unit", 13.0103, 80.2577),
    ("MIOT Emergency Trauma Center", 13.0215, 80.1852),
    ("Sri Ramachandra Trauma Centre", 13.0386, 80.1410)
        ]
    )

    conn.commit()
    conn.close()

    print("Emergency locations inserted successfully!")


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