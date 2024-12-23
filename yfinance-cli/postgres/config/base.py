import os
from pathlib import Path


class PostgreSQL:
    def __init__(self):
        self.host = os.environ.get("POSTGRES_HOST")
        self.database = os.environ.get("POSTGRES_DATABASE")
        self.user = os.environ.get("POSTGRES_USER")
        self.password = os.environ.get("POSTGRES_PASSWORD")


class Config:
    BASE_DIR = Path(__file__).parents[1]
    ENV_FILE_PATH = BASE_DIR / ".env-example"

    def __init__(
        self,
        postgresql: PostgreSQL,
    ):
        self.postgresql = postgresql

    @classmethod
    def create(cls):
        cls._load_env_file()
        return cls(
            postgresql=PostgreSQL(),
        )

    @staticmethod
    def _load_env_file():
        file_path = Config.ENV_FILE_PATH
        try:
            with file_path.open() as file:
                for line in filter(Config._line_comment, file):
                    Config._set_env_var(line)
        except FileNotFoundError:
            print(f"Error: The file {file_path} was not found.")
        except PermissionError:
            print(f"Error: Permission denied when trying to open {file_path}.")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

    @staticmethod
    def _line_comment(line):
        return line.strip() and not line.startswith("#")

    @staticmethod
    def _set_env_var(line):
        try:
            key, value = line.split("=", 1)
            os.environ[key.strip()] = value.strip()
        except ValueError:
            print(f"Skipping invalid line: {line}")
