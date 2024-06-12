from src.main import fake_users_db
from .factories import create_fake_user

def setup_fake_db():
    fake_users_db.clear()
    user = create_fake_user("testuser", "testpassword")
    fake_users_db[user.username] = user.dict()

