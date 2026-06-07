from services.hospital_finder import find_nearest_hospital
from services.police_finder import find_nearest_police
from services.firestation_finder import find_nearest_firestation


def get_recommendations(
    severity,
    latitude,
    longitude
):

    result = {
        "recommended_services": []
    }

    if severity == "Low":

        result["recommended_services"] = [
            "Citizen Assistance"
        ]

    elif severity == "Medium":

        result["recommended_services"] = [
            "Hospital"
        ]

        result["nearest_hospital"] = (
            find_nearest_hospital(
                latitude,
                longitude
            )
        )

    elif severity == "High":

        result["recommended_services"] = [
            "Hospital",
            "Police"
        ]

        result["nearest_hospital"] = (
            find_nearest_hospital(
                latitude,
                longitude
            )
        )

        result["nearest_police_station"] = (
            find_nearest_police(
                latitude,
                longitude
            )
        )

    elif severity == "Critical":

        result["recommended_services"] = [
            "Hospital",
            "Police",
            "Fire Station"
        ]

        result["nearest_hospital"] = (
            find_nearest_hospital(
                latitude,
                longitude
            )
        )

        result["nearest_police_station"] = (
            find_nearest_police(
                latitude,
                longitude
            )
        )

        result["nearest_fire_station"] = (
            find_nearest_firestation(
                latitude,
                longitude
            )
        )

    return result