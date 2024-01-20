# start from a postgres image
FROM postgres:16-alpine

# define postgres environment variables
ENV POSTGRES_USER=POSTGRES_USER
ENV POSTGRES_PASSWORD=POSTGRES_PASSWORD
ENV POSTGRES_DB=POSTGRES_DB

# define fdw environment variables
ENV MYSQL_FDW_VERSION=REL-2_5_3
ENV TDS_FDW_VERSION=2.0.3

# install build tools
RUN apk add --update --no-cache gcc make cmake libc-dev clang postgresql-dev mariadb-dev freetds-dev musl-dev

# install mysql fdw
RUN wget -c https://github.com/EnterpriseDB/mysql_fdw/archive/${MYSQL_FDW_VERSION}.tar.gz -O - | tar -xz -C /usr/local/lib/

# install tds fdw
RUN wget -c https://github.com/tds-fdw/tds_fdw/archive/v${TDS_FDW_VERSION}.tar.gz -O - | tar -xz -C /usr/local/lib/

# patch mysql fdw
RUN sed -i 's/ | RTLD_DEEPBIND//' /usr/local/lib/mysql_fdw-${MYSQL_FDW_VERSION}/mysql_fdw.c

# make and install mysql fdw
RUN cd /usr/local/lib/mysql_fdw-${MYSQL_FDW_VERSION} && make USE_PGXS=1 && make USE_PGXS=1 install

# make and install tds fdw
RUN cd /usr/local/lib/tds_fdw-${TDS_FDW_VERSION} && make USE_PGXS=1 && make USE_PGXS=1 install

# persist data in a volume
VOLUME ["./data/postgres:/var/lib/postgresql/data"]

# expose postgres port
EXPOSE 5432