FROM ubuntu:22.04

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    mysql-client \
    postgresql-client \
    awscli \
    tar \
    && apt-get clean

# Crear directorio para backups
RUN mkdir -p /backups
WORKDIR /app

# Copiar scripts
COPY scripts/ /app/scripts/

# Dar permisos de ejecución
RUN chmod +x /app/scripts/*.sh

# Variables de entorno por defecto
ENV BACKUP_DIR="/backups"

# Ejecutar por defecto un script (puede ser overrideado en `docker run`)
CMD ["/bin/bash"]