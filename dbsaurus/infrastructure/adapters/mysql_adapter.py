from typing import List
import mysql.connector
from dbsaurus.domain.entities.table import Table, Column
from dbsaurus.domain.entities.query import Query
from dbsaurus.domain.value_objects.database_credentials import DatabaseCredentials
from dbsaurus.application.ports.database_port import DatabasePort

class MySQLAdapter(DatabasePort):
    def __init__(self):
        self.connection = None
        self.cursor = None

    def connect(self, credentials: DatabaseCredentials) -> None:
        self.connection = mysql.connector.connect(
            host=credentials.host,
            user=credentials.user,
            password=credentials.password,
            database=credentials.database
        )
        self.cursor = self.connection.cursor(dictionary=True)

    def get_tables(self) -> List[Table]:
        self.cursor.execute("SHOW TABLES")
        tables = []
        
        # Consumir todos los resultados de SHOW TABLES
        table_rows = self.cursor.fetchall()
        
        for table_data in table_rows:
            table_name = list(table_data.values())[0]
            self.cursor.execute(f"DESCRIBE {table_name}")
            
            # Consumir todos los resultados de DESCRIBE
            columns = []
            column_rows = self.cursor.fetchall()
            
            for col in column_rows:
                columns.append(Column(
                    name=col['Field'],
                    data_type=col['Type'],
                    is_nullable=col['Null'] == 'YES',
                    is_primary=col['Key'] == 'PRI',
                    default_value=col['Default']
                ))
            
            tables.append(Table(name=table_name, columns=columns))
        
        return tables

    def get_slow_queries(self) -> List[Query]:
        try:
            self.cursor.execute("SHOW VARIABLES LIKE 'slow_query_log'")
            result = self.cursor.fetchall()  # Consumir todos los resultados
            
            if not result or result[0]['Value'] == 'OFF':
                return []

            self.cursor.execute("""
                SELECT sql_text, query_time, start_time 
                FROM mysql.slow_log 
                ORDER BY start_time DESC 
                LIMIT 10
            """)
            
            # Consumir todos los resultados
            rows = self.cursor.fetchall()
            
            return [
                Query(
                    sql_text=row['sql_text'],
                    execution_time=float(row['query_time']),
                    timestamp=row['start_time']
                )
                for row in rows
            ]
        except mysql.connector.Error:
            return []

    def close(self) -> None:
        if self.cursor:
            # Asegurarse de que no hay resultados sin leer antes de cerrar
            while self.cursor.nextset():
                pass
            self.cursor.close()
        if self.connection:
            self.connection.close() 