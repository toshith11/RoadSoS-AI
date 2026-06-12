from fastapi import APIRouter
import sqlite3

router = APIRouter()

DB_PATH = "database/emergency.db"


@router.get("/incidentHistory")
def incident_history():

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

    history = []

    for row in rows:

        history.append({

            "incident_id":
                row["incident_id"],

            "timestamp":
                row["timestamp"],

            "severity":
                row["severity"],

            "status":
                row["status"],

            "required_services":
                row["required_services"].split(",")
                if row["required_services"]
                else [],

            "description":
                row["description"]
        })

    return history