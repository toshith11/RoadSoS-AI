def recommend_services(severity, detected_objects, description):

    description = description.lower()

    services = []

    # Critical situations
    if severity == "Critical":

        services.append("Ambulance")

        services.append("Nearest Trauma Center")

    # Moderate accidents
    elif severity == "Moderate":

        services.append("Nearby Hospital")

    # Police conditions
    police_keywords = [
        "collision",
        "hit and run",
        "crash",
        "truck"
    ]

    for word in police_keywords:

        if word in description:
            services.append("Police")

    if "truck" in detected_objects:
        services.append("Police")

    # Fire rescue
    fire_keywords = [
        "fire",
        "explosion",
        "smoke"
    ]

    for word in fire_keywords:

        if word in description:
            services.append("Fire Rescue")

    return list(set(services))