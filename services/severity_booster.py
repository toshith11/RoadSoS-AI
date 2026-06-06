def boost_severity(
    severity,
    description
):

    text = description.lower()

    if (
        "fire" in text
        or "burning" in text
        or "explosion" in text
    ):
        return "Critical"

    if (
        "trapped" in text
        or "multiple injured" in text
        or "unconscious" in text
    ):
        return "High"

    return severity