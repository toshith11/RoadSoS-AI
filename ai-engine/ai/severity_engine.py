def predict_severity(description, detected_objects):

    description = description.lower()

    severity_score = 0

    # Critical keywords
    critical_keywords = [
        "unconscious",
        "bleeding",
        "blood",
        "severe",
        "critical",
        "dead",
        "fire",
        "trapped",
        "heavily injured",
        "serious injury"
    ]

    # Moderate keywords
    moderate_keywords = [
        "injured",
        "collision",
        "crash",
        "accident",
        "bike skid",
        "fracture"
    ]

    # Vehicle/object scoring
    if "truck" in detected_objects:
        severity_score += 3

    if "bus" in detected_objects:
        severity_score += 3

    if "motorcycle" in detected_objects:
        severity_score += 2

    if "car" in detected_objects:
        severity_score += 1

    if "person" in detected_objects:
        severity_score += 2

    # Critical keyword scoring
    for word in critical_keywords:

        if word in description:
            severity_score += 4

    # Moderate keyword scoring
    for word in moderate_keywords:

        if word in description:
            severity_score += 2

    # Final severity classification
    if severity_score >= 8:
        severity = "Critical"

    elif severity_score >= 4:
        severity = "Moderate"

    else:
        severity = "Minor"

    return severity