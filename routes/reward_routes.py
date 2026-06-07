from fastapi import APIRouter
from data.storage import rewards

router = APIRouter()


def add_reward(username: str, points: int = 50):

    # Check if user already exists
    for user in rewards:

        if user["username"] == username:

            user["points"] += points

            return user

    # New user
    new_user = {
        "username": username,
        "points": points
    }

    rewards.append(new_user)

    return new_user


@router.get("/leaderboard")
def leaderboard():

    sorted_rewards = sorted(
        rewards,
        key=lambda x: x["points"],
        reverse=True
    )

    return sorted_rewards