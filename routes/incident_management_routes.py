from fastapi import APIRouter
import sqlite3

router = APIRouter()

DB_PATH = "database/emergency.db"


@router.put("/acceptIncident/{incident_id}")
def accept_incident(incident_id: str):

    conn = sqlite3.connect(DB_PATH)

    cursor = conn.cursor()

    cursor.execute(
        """
        UPDATE incidents
        SET status='Accepted'
        WHERE incident_id=?
        """,
        (incident_id,)
    )

    conn.commit()

    if cursor.rowcount == 0:

        conn.close()

        return {
            "message": "Incident Not Found"
        }

    conn.close()

    return {
        "message": "Incident Accepted"
    }


@router.put("/resolveIncident/{incident_id}")
def resolve_incident(incident_id: str):

    conn = sqlite3.connect(DB_PATH)

    cursor = conn.cursor()

    cursor.execute(
        """
        UPDATE incidents
        SET status='Resolved'
        WHERE incident_id=?
        """,
        (incident_id,)
    )

    conn.commit()

    if cursor.rowcount == 0:

        conn.close()

        return {
            "message": "Incident Not Found"
        }

    conn.close()

    return {
        "message": "Incident Resolved"
    }