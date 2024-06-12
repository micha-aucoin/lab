import pytest
from src.main import create_access_token

def test_read_own_items(client):
    token = create_access_token({"sub": "testuser"})
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/users/me/items/", headers=headers)
    assert response.status_code == 200
    items = response.json()
    assert len(items) == 1
    assert items[0]["owner"] == "testuser"
