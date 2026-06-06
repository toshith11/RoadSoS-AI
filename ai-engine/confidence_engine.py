def average_predictions(predictions):

    scores = {
        "normal traffic": 0,
        "minor vehicle accident": 0,
        "major vehicle accident": 0,
        "vehicle on fire": 0
    }

    for p in predictions:

        category = p["category"]

        confidence = p["confidence"]

        scores[category] += confidence

    best_category = max(
        scores,
        key=scores.get
    )

    return best_category