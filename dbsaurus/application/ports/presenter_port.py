from abc import ABC, abstractmethod
from typing import List
from dbsaurus.domain.entities.table import Table
from dbsaurus.domain.entities.query import Query

class PresenterPort(ABC):
    @abstractmethod
    def present_tables(self, tables: List[Table]) -> None:
        pass

    @abstractmethod
    def present_queries(self, queries: List[Query]) -> None:
        pass

    @abstractmethod
    def present_error(self, error: Exception) -> None:
        pass 