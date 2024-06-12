import pytest
from app.main import create_access_token

@pytest.mark.asyncio
async def test_login(_async_client):
    response = await _async_client.post("/token", data={"username": "testuser", "password": "testpassword"})
    assert response.status_code == 200
    token_data = response.json()
    assert "access_token" in token_data
    assert token_data["token_type"] == "bearer"

@pytest.mark.asyncio
async def test_login_invalid(_async_client):
    response = await _async_client.post("/token", data={"username": "testuser", "password": "wrongpassword"})
    assert response.status_code == 401

@pytest.mark.asyncio
async def test_get_current_user(_async_client):
    token = create_access_token({"sub": "testuser"})
    headers = {"Authorization": f"Bearer {token}"}
    response = await _async_client.get("/users/me/", headers=headers)
    assert response.status_code == 200
    user_data = response.json()
    assert user_data["username"] == "testuser"

@pytest.mark.asyncio
async def test_get_current_user_unauthorized(_async_client):
    response = await _async_client.get("/users/me/")
    assert response.status_code == 401

