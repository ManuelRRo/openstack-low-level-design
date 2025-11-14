#!/usr/bin/env bash
set -euo pipefail

# ================================
# Superset Light (Docker + SQLite)
# ================================
# - Un solo contenedor: apache/superset:latest
# - Metadata en SQLite (por defecto)
# - Crea conexión SQLite para datasets y habilita "Allow file uploads"

# --------- Variables ajustables ----------
PORT="${PORT:-18088}"                 # Puerto host -> contenedor:8088
VOL_NAME="${VOL_NAME:-superset_home}" # Volumen persistente
CTN_NAME="${CTN_NAME:-superset_quick}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PWD="${ADMIN_PWD:-admin}"
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@example.com}"
SQLITE_DIR_IN_VOL="datasets"          # Carpeta dentro del volumen para tus bases SQLite
SQLITE_FILE="local.db"                # Nombre de la base de datos para tus datasets
DB_DISPLAY_NAME="Local SQLite"        # Nombre visible en Superset
IMAGE="${IMAGE:-apache/superset:latest}"

# --------- Helpers ----------
log() { echo -e "\033[1;32m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
die() { echo -e "\033[1;31m[ERROR]\033[0m $*"; exit 1; }

# --------- Prechequeos ----------
command -v docker >/dev/null 2>&1 || die "Docker no está instalado o no está en PATH."

# Generar SECRET_KEY fuerte
if command -v openssl >/dev/null 2>&1; then
  SECRET_KEY="$(openssl rand -base64 64)"
else
  # fallback con python
  if command -v python3 >/dev/null 2>&1; then
    SECRET_KEY="$(python3 - <<'PY'
import secrets, base64
print(base64.b64encode(secrets.token_bytes(64)).decode())
PY
)"
  else
    die "No hay openssl ni python3 para generar SECRET_KEY. Instala uno de los dos."
  fi
fi

# --------- Limpieza previa opcional ----------
if docker ps -a --format '{{.Names}}' | grep -q "^${CTN_NAME}\$"; then
  warn "Existe contenedor ${CTN_NAME}, lo voy a eliminar."
  docker rm -f "${CTN_NAME}" >/dev/null
fi

# Crear volumen si no existe
if ! docker volume ls --format '{{.Name}}' | grep -q "^${VOL_NAME}\$"; then
  log "Creando volumen ${VOL_NAME}"
  docker volume create "${VOL_NAME}" >/dev/null
fi

# Sembrar configuración y carpeta de datasets dentro del volumen (contenedor efímero)
log "Escribiendo superset_config.py y creando carpeta de datasets en el volumen…"
docker run --rm -v "${VOL_NAME}":/data alpine:3.20 sh -c "
  set -e
  echo 'PREVENT_UNSAFE_DB_CONNECTIONS = False' > /data/superset_config.py
  mkdir -p /data/${SQLITE_DIR_IN_VOL}
  touch /data/${SQLITE_DIR_IN_VOL}/${SQLITE_FILE}
  chown -R 1000:1000 /data
  ls -lah /data
"

#Linea agregada

# Levantar Superset (modo producción, apuntando al config del volumen)
log "Levantando contenedor ${CTN_NAME} (${IMAGE}) en puerto ${PORT}…"
docker run -d --name "${CTN_NAME}" \
  -p "${PORT}:8088" \
  -e SUPERSET_ENV=production \
  -e SUPERSET_SECRET_KEY="${SECRET_KEY}" \
  -e SUPERSET_CONFIG_PATH=/app/superset_home/superset_config.py \
  -v "${VOL_NAME}":/app/superset_home \
  "${IMAGE}" >/dev/null

# Espera breve para que el contenedor arranque
sleep 5

# Inicialización de Superset (metadata en SQLite por defecto)
log "Inicializando base de datos de Superset…"
docker exec "${CTN_NAME}" superset db upgrade >/dev/null

log "Creando usuario administrador (${ADMIN_USER})…"
docker exec "${CTN_NAME}" superset fab create-admin \
  --username "${ADMIN_USER}" \
  --firstname Admin \
  --lastname User \
  --email "${ADMIN_EMAIL}" \
  --password "${ADMIN_PWD}" >/dev/null

log "Ejecutando 'superset init'…"
docker exec "${CTN_NAME}" superset init >/dev/null

# Crear conexión a SQLite para datasets y habilitar "Allow file uploads"
SQLALCHEMY_URI="sqlite:////app/superset_home/${SQLITE_DIR_IN_VOL}/${SQLITE_FILE}"

log "Creando conexión de base de datos para datasets (${DB_DISPLAY_NAME})…"
docker exec -i "${CTN_NAME}" superset shell <<PY
from superset import db
from superset.models.core import Database

name = "${DB_DISPLAY_NAME}"
uri = "${SQLALCHEMY_URI}"

database = db.session.query(Database).filter_by(database_name=name).one_or_none()
if database is None:
    database = Database(database_name=name, sqlalchemy_uri=uri)
database.sqlalchemy_uri = uri
database.allow_file_upload = True
database.expose_in_sqllab = True
db.session.add(database)
db.session.commit()
print("OK -> Database:", name, "URI:", uri, "allow_file_upload:", database.allow_file_upload)
PY

log "Comprobando salud del backend…"
if command -v curl >/dev/null 2>&1; then
  sleep 2
  if curl -fsS "http://localhost:${PORT}/health" >/dev/null; then
    log "Superset responde en /health ✅"
  else
    warn "No obtuve 200 en /health (puede estar aún iniciando)."
  fi
fi

cat <<MSG

==========================================================
 Superset desplegado (ligero) con SQLite listo para usar 🚀
----------------------------------------------------------
URL:        http://localhost:${PORT}
Usuario:    ${ADMIN_USER}
Contraseña: ${ADMIN_PWD}

Conexión de datasets creada:
  Nombre:   ${DB_DISPLAY_NAME}
  URI:      ${SQLALCHEMY_URI}
  *Allow file uploads to database* = ON

Para subir datos:
  UI -> Data -> Upload a CSV/Excel
  Selecciona la base "${DB_DISPLAY_NAME}" y crea tu tabla.

Logs rápidos:
  docker logs --tail 100 ${CTN_NAME}

Detener/Eliminar:
  docker stop ${CTN_NAME}
  docker rm ${CTN_NAME}

==========================================================
MSG
