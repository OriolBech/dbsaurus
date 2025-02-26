from abc import ABC, abstractmethod
from typing import List
from dbsaurus.domain.entities.table import Table
from dbsaurus.domain.entities.query import Query
from dbsaurus.domain.value_objects.database_credentials import DatabaseCredentials

class DatabasePort(ABC):
    @abstractmethod
    def connect(self, credentials: DatabaseCredentials) -> None:
        pass

    @abstractmethod
    def get_tables(self) -> List[Table]:
        pass

    @abstractmethod
    def get_slow_queries(self) -> List[Query]:
        pass

    @abstractmethod
    def close(self) -> None:
        pass 