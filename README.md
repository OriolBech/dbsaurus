# DBsaurus 🦕

DBsaurus is a powerful command-line tool for analyzing database structures and queries, providing insights into your database performance and schema design. It offers flexible configuration through environment variables with command-line override capabilities.

## Features 🚀

- **Database Analysis**
  - Schema structure visualization
  - Query performance analysis
  - Index usage statistics
  - Table relationship mapping
  
- **Configuration Flexibility**
  - Environment variable support via `.env`
  - Command-line argument overrides
  - Multiple database type support

- **Developer Experience**
  - Interactive console output
  - Detailed performance metrics
  - Export capabilities for reports

## Prerequisites 📋

- Python 3.8 or higher
- `pip` for package management
- Access to a supported database (MySQL, PostgreSQL)
- `.env` file with database credentials

## Installation 💻

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/dbsaurus.git
    cd dbsaurus
    pip install -r requirements.txt
    ```

2. Create a `.env` file in your project root:

    ```plaintext
    MYSQL_HOST=your_host
    MYSQL_USER=your_user
    MYSQL_PASSWORD=your_password
    MYSQL_DATABASE=your_database
    ```

## Usage 🔧

### Basic Usage

Run a database analysis:

```bash
dbsaurus analyze
```

### Command Options

```bash
dbsaurus analyze [OPTIONS]
```

#### Connection Options
- `--host`: Database host address
- `--user`: Database username
- `--password`: Database password
- `--database`: Database name
- `--port`: Database port (default: 3306)

#### Analysis Options
- `--depth`: Analysis depth level (1-3)
- `--format`: Output format (text, json, html)
- `--output`: Save results to file

### Examples

Basic analysis:
```bash
python3 -m dbsaurus analyze
```

Detailed analysis with custom output:
```bash
python3 -m dbsaurus analyze
```

## Configuration 🔑

### Environment Variables

Create a `.env` file with these variables:

```plaintext
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=secret
MYSQL_DATABASE=mydb
MYSQL_PORT=3306
```

### Configuration Precedence

1. Command-line arguments (highest priority)
2. Environment variables
3. Default values (lowest priority)

## Output Examples 📊

```plaintext
Database Analysis Report
----------------------
Tables: 24
Indexes: 47
Foreign Keys: 18
...
```

## Troubleshooting 🔍

Common issues and solutions:

1. **Connection Failed**
   - Verify credentials in `.env`
   - Check database server status
   - Confirm network connectivity

2. **Permission Denied**
   - Verify user privileges
   - Check database access rights

## Contributing 🤝

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

Please read our [Contributing Guidelines](CONTRIBUTING.md) for details.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support 💬

- Create an issue on GitHub
- Join our Discord community
- Check our [Documentation](https://dbsaurus.readthedocs.io)

## Roadmap 🗺️

- [ ] Support for additional databases
- [ ] Advanced query optimization suggestions
- [ ] Real-time monitoring features
- [ ] Integration with popular ORMs

## Acknowledgments 👏

- Database community contributors
- Open source projects that inspired us
- Our amazing contributors

## 🎡 Author
Developed by Oriol Bech – feel free to reach out! 🚀

