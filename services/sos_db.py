import sqlite3


DB_PATH = "database/emergency.db"


def save_sos_request(data):

    conn = sqlite3.connect(DB_PATH)

    cursor = conn.cursor()

    cursor.execute("""
    INSERT INTO sos_requests (

        phone,
        service,

        latitude,
        longitude,

        assigned_service,

        eta,

        timestamp

    )
    VALUES (?, ?, ?, ?, ?, ?, ?)
    """, (

        data["phone"],
        data["service"],

        data["latitude"],
        data["longitude"],

        data["assigned_service"],

        data["eta"],

        data["timestamp"]
    ))

    conn.commit()

    conn.close()