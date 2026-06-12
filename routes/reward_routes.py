from fastapi import APIRouter
from pydantic import BaseModel

from data.storage import rewards

router = APIRouter()


class RewardRequest(BaseModel):
    reporter_name: str
    points: int


@router.post("/rewardUser")
def reward_user(data: RewardRequest):

    rewards[data.reporter_name] = (
        rewards.get(
            data.reporter_name,
            0
        )
        + data.points
    )

    return {
        "success": True,
        "reporter_name":
            data.reporter_name,
        "total_points":
            rewards[data.reporter_name]
    }