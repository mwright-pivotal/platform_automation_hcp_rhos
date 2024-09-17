#FROM bitnami/postgresql:latest
FROM bitnami/postgresql:16.4.0-debian-12-r5

USER root

RUN apt update;apt install -y postgresql-common build-essential git && rm -rf /var/lib/apt/lists/*
#RUN /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y
#RUN apt install -y postgresql-15-pgvector

WORKDIR /tmp
RUN git clone https://github.com/pgvector/pgvector.git

WORKDIR /tmp/pgvector
RUN make clean
RUN make OPTFLAGS=""
RUN make install

USER 1001
