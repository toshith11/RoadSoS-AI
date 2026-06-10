def detect_victims(description: str):

    description = description.lower()

    if "three" in description or "3" in description:
        return 3

    elif "two" in description or "2" in description:
        return 2

    elif (
        "injured" in description or
        "person" in description or
        "victim" in description
    ):
        return 1

    return 0