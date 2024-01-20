# Multi-Database Docker Project

This project sets up three different databases (PostgreSQL, MySQL, and SQL Server) in Docker. PostgreSQL is the main database and uses extensions and foreign data wrappers (FDWs) to connect to the other servers.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Docker
- Docker Compose

### Installation

1. Clone the repository

```bash
git clone https://github.com/TedMwai/your-repo.git

```

2. Change into the directory

```bash
cd your-repo
```

3. Pull the images and start the containers

```bash
docker-compose up -d
```

4. Build the PostgreSQL database from the Dockerfile

```bash
docker build -t postgres_fdw .
```

5. Connect to the PostgreSQL database

```bash
docker exec -it postgres_fdw psql -U postgres
```

6. Create the foreign server and user mapping

```sql
CREATE EXTENSION mysql_fdw;
CREATE EXTENSION tds_fdw;


CREATE SERVER mysql_server FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host 'YOUR_IP_ADDRESS', port '3306');
CREATE SERVER mssql_svr
	FOREIGN DATA WRAPPER tds_fdw
	OPTIONS (servername 'YOUR_IP_ADDRESS', port '1433', database 'YOUR_DATABASE_NAME');


CREATE USER MAPPING FOR postgres SERVER mysql_server OPTIONS (username 'YOUR_USERNAME', password 'YOUR_PASSWORD');
CREATE USER MAPPING FOR postgres
	SERVER mssql_svr
	OPTIONS (username 'sa', password 'YOUR_PASSWORD');
```

7. Import the tables from the foreign servers

```sql
IMPORT FOREIGN SCHEMA YOUR_SCHEMA FROM SERVER mysql_server INTO public;
IMPORT FOREIGN SCHEMA YOUR_SCHEMA FROM SERVER mssql_svr INTO public;
```

8. Test the connection

```sql
SELECT * FROM YOUR_TABLE;
```

## Built With

- [Docker](https://www.docker.com/) - Containerization
- [PostgreSQL](https://www.postgresql.org/) - The main database
- [MySQL](https://www.mysql.com/) - The MySQL database
- [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-2019) - The SQL Server database
- [MySQL FDW](https://www.enterprisedb.com/docs/mysql_data_adapter/latest/) - Foreign Data Wrapper for MySQL
- [TDS FDW](https://github.com/tds-fdw) - Foreign Data Wrapper for SQL Server


