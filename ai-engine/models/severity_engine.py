def calculate_severity(predictions):

    if "vehicle on fire" in predictions:
        return "Critical"

    if "major vehicle accident" in predictions:
        return "High"

    if "minor vehicle accident" in predictions:
        return "Medium"

    return "Low"