from typing import List
from rich.console import Console
from rich.table import Table as RichTable
from dbsaurus.domain.entities.table import Table
from dbsaurus.domain.entities.query import Query
from dbsaurus.application.ports.presenter_port import PresenterPort

class ConsolePresenter(PresenterPort):
    def __init__(self):
        self.console = Console()

    def present_tables(self, tables: List[Table]) -> None:
        table = RichTable(show_header=True, header_style="bold magenta")
        table.add_column("Table Name")
        table.add_column("Columns")
        table.add_column("Primary Key")

        for table_info in tables:
            table.add_row(
                table_info.name,
                str(len(table_info.columns)),
                table_info.primary_key or 'None'
            )

        self.console.print("\n[bold green]Database Tables:[/bold green]")
        self.console.print(table)

    def present_queries(self, queries: List[Query]) -> None:
        if not queries:
            self.console.print("[yellow]No slow queries found or slow query log is disabled[/yellow]")
            return

        query_table = RichTable(show_header=True, header_style="bold magenta")
        query_table.add_column("Query")
        query_table.add_column("Execution Time")
        query_table.add_column("Timestamp")

        for query in queries:
            query_table.add_row(
                query.sql_text[:100] + '...',
                f"{query.execution_time:.2f}s",
                query.timestamp.strftime("%Y-%m-%d %H:%M:%S")
            )

        self.console.print("\n[bold green]Slow Queries:[/bold green]")
        self.console.print(query_table)

    def present_error(self, error: Exception) -> None:
        self.console.print(f"[red]Error: {str(error)}[/red]")