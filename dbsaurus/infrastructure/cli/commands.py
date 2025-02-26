import os
import click
from dotenv import load_dotenv, find_dotenv
from dbsaurus.domain.value_objects.database_credentials import DatabaseCredentials
from dbsaurus.application.usecases.analyze_database import AnalyzeDatabaseUseCase
from dbsaurus.infrastructure.adapters.mysql_adapter import MySQLAdapter
from dbsaurus.infrastructure.adapters.console_presenter import ConsolePresenter

def load_env_credentials() -> DatabaseCredentials:
    """Load database credentials from environment variables."""
    env_path = find_dotenv()
    if not env_path:
        click.echo("Warning: No .env file found")
    else:
        click.echo(f"Loading .env from: {env_path}")
    
    # Cargar variables de entorno
    load_dotenv(env_path)
    
    # Actualizado para usar MYSQL_ en lugar de DB_
    host = os.getenv('MYSQL_HOST', 'localhost')
    user = os.getenv('MYSQL_USER')
    password = os.getenv('MYSQL_PASSWORD')
    database = os.getenv('MYSQL_DATABASE')  # Cambiado de DB_NAME a MYSQL_NAME
    
    return DatabaseCredentials(
        host=host,
        user=user,
        password=password,
        database=database
    )

@click.group()
def cli():
    """DBsaurus - Database Analysis Tool"""
    pass

@cli.command()
@click.option('--host', help='Database host (overrides .env)')
@click.option('--user', help='Database user (overrides .env)')
@click.option('--password', help='Database password (overrides .env)')
@click.option('--database', help='Database name (overrides .env)')
def analyze(host: str, user: str, password: str, database: str):
    """Analyze database structure and queries"""
    # Load credentials from .env
    env_credentials = load_env_credentials()
    
    # Override with CLI arguments if provided
    credentials = DatabaseCredentials(
        host=host or env_credentials.host,
        user=user or env_credentials.user,
        password=password or env_credentials.password,
        database=database or env_credentials.database
    )
    
    # Validate that required credentials are present
    missing_credentials = []
    if not credentials.user:
        missing_credentials.append("user")
    if not credentials.password:
        missing_credentials.append("password")
    if not credentials.database:
        missing_credentials.append("database")
    
    if missing_credentials:
        raise click.UsageError(
            f"Missing required database credentials: {', '.join(missing_credentials)}. "
            "Please provide them via .env file or command line arguments."
        )
    
    database_adapter = MySQLAdapter()
    presenter = ConsolePresenter()
    
    use_case = AnalyzeDatabaseUseCase(
        database=database_adapter,
        presenter=presenter
    )
    
    use_case.execute(credentials) 