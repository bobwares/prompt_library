# App: Client Profile Module
# Package: db
# File: Dockerfile
# Version: 0.0.1
# Author: Bobwares
# Date: 2025-06-10T00:00:00Z
# Description: Build PostgreSQL 16 image with initialization scripts.

FROM postgres:16-alpine

ENV POSTGRES_USER=${POSTGRES_USER} \
    POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    POSTGRES_DB=${POSTGRES_DB}

COPY migrations/ /docker-entrypoint-initdb.d/migrations/
COPY scripts/ /docker-entrypoint-initdb.d/scripts/
