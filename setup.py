from setuptools import setup, find_packages

setup(
    name="dbsaurus",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        "click>=8.0.0",
        "mysql-connector-python>=8.0.0",
        "rich>=10.0.0",
        "python-dotenv>=1.0.0",
    ],
    entry_points={
        'console_scripts': [
            'dbsaurus=dbsaurus.main:cli',
        ],
    },
) 