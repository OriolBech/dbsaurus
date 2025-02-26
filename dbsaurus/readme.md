# DBsaurus

DBsaurus is a command-line tool designed for analyzing database structures and queries. It uses environment variables for configuration and allows overriding these settings via command-line arguments.

## Features

- Load database credentials from a `.env` file.
- Override credentials using command-line options.
- Analyze database structure and queries.
- Present analysis results in the console.

## Prerequisites

- Python 3.7 or higher
- `pip` for managing Python packages
- A `.env` file with the necessary database credentials

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/dbsaurus.git
    cd dbsaurus
    ```

2. Install the required Python packages:

    ```bash
    pip install -r requirements.txt
    ```

3. Create a `.env` file in the root directory with the following variables:

    ```plaintext
    MYSQL_HOST=your_host
    MYSQL_USER=your_user
    MYSQL_PASSWORD=your_password
    MYSQL_DATABASE=your_database
    ```

## Usage

To use DBsaurus, you can run the following command:

python -m infrastructure.cli.commands analyze

### Command-Line Options

- `--host`: Database host (overrides `.env`)
- `--user`: Database user (overrides `.env`)
- `--password`: Database password (overrides `.env`)
- `--database`: Database name (overrides `.env`)

Example:

```bash
python -m infrastructure.cli.commands analyze --host localhost --user root --password secret --database mydb
```


## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


