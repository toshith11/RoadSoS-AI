def get_final_category(predictions):

    scores = {}

    for result in predictions:

        category = result["category"]
        confidence = result["confidence"]

        if category not in scores:
            scores[category] = 0

        scores[category] += confidence

    final_category = max(
        scores,
        key=scores.get
    )

    return final_category