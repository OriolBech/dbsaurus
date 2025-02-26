from dataclasses import dataclass
from datetime import datetime

@dataclass
class Query:
    sql_text: str
    execution_time: float
    timestamp: datetime 