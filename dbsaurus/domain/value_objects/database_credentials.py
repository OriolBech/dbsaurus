from dataclasses import dataclass

@dataclass(frozen=True)
class DatabaseCredentials:
    host: str
    user: str
    password: str
    database: str 