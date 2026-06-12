import sqlite3

DB_PATH = "database/emergency.db"


def save_incident(incident):

    conn = sqlite3.connect(DB_PATH)

    cursor = conn.cursor()

    cursor.execute("""
INSERT INTO incidents (

    incident_id,
    timestamp,
    reporter_name,

    latitude,
    longitude,

    victims,

    severity,
    status,

    description,
    required_services

)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
""", (

    incident["incident_id"],
    incident["timestamp"],
    incident["reporter_name"],

    incident["latitude"],
    incident["longitude"],

    incident["victims"],

    incident["severity"],
    incident["status"],

    incident["description"],

    ",".join(
        incident["recommended_services"]
    )

))

    conn.commit()

    conn.close()

def get_all_incidents():

    conn = sqlite3.connect(DB_PATH)

    conn.row_factory = sqlite3.Row

    cursor = conn.cursor()

    cursor.execute("""
    SELECT *
    FROM incidents
    ORDER BY timestamp DESC
    """)

    rows = cursor.fetchall()

    conn.close()

    return [dict(row) for row in rows]