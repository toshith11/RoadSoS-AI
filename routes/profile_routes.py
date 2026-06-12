from fastapi import APIRouter
import sqlite3

router = APIRouter()

DB_PATH = "database/emergency.db"


@router.get("/citizenProfile")
def citizen_profile(reporter_name: str):

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Total Reports
    cursor.execute(
        """
        SELECT COUNT(*)
        FROM incidents
        WHERE reporter_name = ?
        """,
        (reporter_name,)
    )

    reports = cursor.fetchone()[0]

    # Verified Reports
    cursor.execute(
        """
        SELECT COUNT(*)
        FROM incidents
        WHERE reporter_name = ?
        AND status = 'Resolved'
        """,
        (reporter_name,)
    )

    verified_reports = cursor.fetchone()[0]

    conn.close()

    # Points Logic
    points = reports * 50

    # Level Logic
    if points >= 500:
        level = "Road Safety Champion"

    elif points >= 200:
        level = "Community Reporter"

    else:
        level = "Citizen Reporter"

    # Badge Logic
    badges = []

    if reports >= 1:
        badges.append("First Reporter")

    if verified_reports >= 1:
        badges.append("Verified Reporter")

    if points >= 100:
        badges.append("First Responder")

    return {
        "success": True,
        "name": reporter_name,
        "points": points,
        "level": level,
        "reports": reports,
        "verifiedReports": verified_reports,
        "badges": badges
    }