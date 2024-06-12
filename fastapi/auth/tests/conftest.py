import pytest
from fastapi.testclient import TestClient
from src.main import app
from .fakes import setup_fake_db

@pytest.fixture(scope="module")
def client():
    setup_fake_db()
    return TestClient(app)

