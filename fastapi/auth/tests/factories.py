from passlib.context import CryptContext
from src.main import UserInDB

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_fake_user(username: str, password: str):
    hashed_password = pwd_context.hash(password)
    return UserInDB(
        username=username,
        email=f"{username}@example.com",
        full_name="Fake User",
        hashed_password=hashed_password,
        disabled=False
    )

