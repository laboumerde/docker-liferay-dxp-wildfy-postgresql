FROM ubuntu:16.04
MAINTAINER Julien Boumard (99% based on Ivan K. work)

ADD assets /assets
RUN /assets/conf/setup.sh

##### Install PostgreSQL

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN /etc/init.d/postgresql start  &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';"  &&\
    psql --command "create user lportal password 'lportal';" &&\
    createdb -O lportal lportal &&\
    psql --command "GRANT ALL PRIVILEGES ON DATABASE lportal TO lportal;"  &&\
    psql --command "set role lportal;"  &&\
    psql --command "ALTER ROLE lportal WITH LOGIN"

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.5/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.5/main/postgresql.conf

##### END Install PostgreSQL

USER root

EXPOSE 22
EXPOSE 5432
EXPOSE 8080
EXPOSE 8787
EXPOSE 1234

# supervisor installation &&
# create directory for child images to store configuration in
RUN apt-get -y install supervisor && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d

# Default Startup using supervisor
CMD ["supervisord", "-c", "/assets/conf/supervisor.conf"]
