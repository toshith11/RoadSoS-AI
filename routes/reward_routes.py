from fastapi import APIRouter
from pydantic import BaseModel
from data.storage import rewards

router = APIRouter()

class Reward(BaseModel):
    username: str
    points: int

@router.post("/rewardUser")
def reward_user(reward: Reward):

    rewards.append(reward.dict())

    return {
        "message": "Reward Added Successfully",
        "data": reward
    }

@router.get("/leaderboard")
def leaderboard():

    return rewards