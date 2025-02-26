from dataclasses import dataclass
from typing import List
from dbsaurus.domain.entities.table import Table
from dbsaurus.domain.value_objects.database_credentials import DatabaseCredentials
from dbsaurus.application.ports.database_port import DatabasePort
from dbsaurus.application.ports.presenter_port import PresenterPort

@dataclass
class AnalyzeDatabaseUseCase:
    database: DatabasePort
    presenter: PresenterPort

    def execute(self, credentials: DatabaseCredentials) -> None:
        try:
            self.database.connect(credentials)
            tables = self.database.get_tables()
            self.presenter.present_tables(tables)
            
            queries = self.database.get_slow_queries()
            self.presenter.present_queries(queries)
            
        except Exception as e:
            self.presenter.present_error(e)
        finally:
            self.database.close() 