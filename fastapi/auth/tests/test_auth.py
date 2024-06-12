import pytest
from httpx import AsyncClient
from src.main import create_access_token

def test_login(client):
    response = client.post("/token", data={"username": "testuser", "password": "testpassword"})
    assert response.status_code == 200
    token_data = response.json()
    assert "access_token" in token_data
    assert token_data["token_type"] == "bearer"

def test_login_invalid(client):
    response = client.post("/token", data={"username": "testuser", "password": "wrongpassword"})
    assert response.status_code == 401

def test_get_current_user(client):
    token = create_access_token({"sub": "testuser"})
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/users/me/", headers=headers)
    assert response.status_code == 200
    user_data = response.json()
    assert user_data["username"] == "testuser"

def test_get_current_user_unauthorized(client):
    response = client.get("/users/me/")
    assert response.status_code == 401
