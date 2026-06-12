from fastapi import APIRouter
import sqlite3
import json

router = APIRouter()

DB_PATH = "database/emergency.db"


@router.get("/latestIncident")
def latest_incident():

    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row

    cursor = conn.cursor()

    cursor.execute("""
        SELECT *
        FROM incidents
        ORDER BY timestamp DESC
        LIMIT 1
    """)

    row = cursor.fetchone()

    conn.close()

    if row is None:
        return {
            "message": "No incidents found"
        }

    return {
        "incident_id": row["incident_id"],
        "timestamp": row["timestamp"],
        "severity": row["severity"],
        "status": row["status"],
        "description": row["description"],
        "required_services":
            json.loads(row["required_services"])
            if row["required_services"]
            else []
    }