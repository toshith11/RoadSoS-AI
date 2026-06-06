def calculate_severity(category):

    if category == "vehicle on fire":
        return "Critical"

    elif category == "major vehicle accident":
        return "High"

    elif category == "minor vehicle accident":
        return "Medium"

    else:
        return "Low"