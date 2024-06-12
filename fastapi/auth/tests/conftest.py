import pytest
import pytest_asyncio
from httpx import AsyncClient
from app.main import app
from .fakes import setup_fake_db

@pytest_asyncio.fixture(scope="function")
async def _async_client():
    setup_fake_db()
    async with AsyncClient(
        app=app,
        base_url=f"http://",
    ) as client:
        yield client
