# Stacks

A collection of Docker Compose stacks, shell scripts, and utilities for quickly deploying and managing containerized infrastructure services.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
- Bash shell
- An external Docker bridge network named `proxy` (see [Network Setup](#network-setup))

## Network Setup

Most stacks communicate over a shared external Docker network called `proxy`. Create it before deploying any stack:

```bash
# Using the included script
bash scripts/docker_proxy_network.sh

# Or manually
docker network create --driver bridge proxy
```

## Directory Structure

```
stacks/
├── docker-database/        # Database backup & restore scripts
├── monitoring/             # Prometheus + Grafana + Loki stack
├── nginx/                  # Nginx Proxy Manager stack
├── portainer/              # Portainer CE stack
├── redis/                  # Redis Stack
├── scripts/                # Utility & Kafka management scripts
├── clone_files.sh          # Clone specific files from a remote repo
└── README.md
```

## Stacks

### Monitoring

**Services:** Prometheus · Grafana · Loki

Provides a full observability stack with metrics collection, log aggregation, and dashboards.

| Service    | Image                        | Port  | Description                 |
| ---------- | ---------------------------- | ----- | --------------------------- |
| Prometheus | `prom/prometheus:latest`     | 9090  | Metrics collection & alerts |
| Grafana    | `grafana/grafana-oss:latest` | 3000  | Dashboards & visualization  |
| Loki       | `grafana/loki`               | 3100  | Log aggregation             |

```bash
docker compose -f monitoring/docker-compose.yaml up -d
```

> **Configuration:** Prometheus scrape targets are defined via file-based service discovery in `monitoring/service.json`. The scrape config is in `monitoring/prometheus.yml`.

---

### Nginx Proxy Manager

**Services:** Nginx Proxy Manager

A reverse proxy with a web UI for managing SSL certificates and proxy hosts.

| Service             | Image                                       | Ports          | Description                       |
| ------------------- | ------------------------------------------- | -------------- | --------------------------------- |
| Nginx Proxy Manager | `docker.io/jc21/nginx-proxy-manager:latest` | 80, 81¹, 443   | Reverse proxy with admin panel    |

¹ Port 81 (admin UI) — disable in production.

```bash
docker compose -f nginx/docker-compose.yaml up -d
```

---

### Portainer

**Services:** Portainer CE

A lightweight container management UI with access to the Docker socket.

| Service   | Image                            | Port  | Description               |
| --------- | -------------------------------- | ----- | ------------------------- |
| Portainer | `portainer/portainer-ce:latest`  | 9000¹ | Container management UI   |

¹ Port 9000 (web UI) — disable in production.

```bash
docker compose -f portainer/docker-compose.yaml up -d
```

---

### Redis

**Services:** Redis Stack

Redis with built-in modules (RedisJSON, RediSearch, etc.) and the RedisInsight GUI.

| Service     | Image                       | Ports       | Description                          |
| ----------- | --------------------------- | ----------- | ------------------------------------ |
| Redis Stack | `redis/redis-stack:latest`  | 6379, 8001  | Redis server + RedisInsight GUI      |

**Environment variables** (set in `redis/.env`):

| Variable         | Description         |
| ---------------- | ------------------- |
| `REDIS_PASSWORD`  | Redis auth password |

```bash
docker compose -f redis/docker-compose.yaml up -d
```

## Scripts

### Utility Scripts (`scripts/`)

| Script                        | Description                                                            |
| ----------------------------- | ---------------------------------------------------------------------- |
| `logging.sh`                  | Shared logging functions (`loginf`, `logerr`, `war`, `logsuccess`)     |
| `docker_container_status.sh`  | Helper functions to check if a container exists or is running          |
| `docker_proxy_network.sh`     | Creates the external `proxy` bridge network if it doesn't exist        |

### Kafka Scripts (`scripts/`)

| Script                                  | Description                                                                                     |
| --------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `create_kafka_development_container.sh` | Spin up a single-node KRaft Kafka container for development                                     |
| `manage_kafka_topics.sh`                | Library of topic management functions (create, delete, increase partitions, wait for readiness)  |
| `manage_kafka_config_file_topics.sh`    | Batch-manage Kafka topics from a config file (create / increase / delete)                       |

**Create a Kafka dev container:**

```bash
cd scripts
bash create_kafka_development_container.sh <container_name> <network_name>
```

**Manage topics from a config file:**

```bash
cd scripts
bash manage_kafka_config_file_topics.sh <container_name> <config_file> <action> [replication_factor|new_partitions]
# Actions: create, increase, delete
```

### Database Backup & Restore (`docker-database/`)

Scripts for backing up and restoring Dockerized MongoDB and PostgreSQL databases.

> **Note:** Backups are stored in `~/workspace/backups`. Create this directory before running backup scripts. Do not rename backup files or folders after creation.

#### MongoDB

```bash
# Backup
bash docker-database/docker-mongodb-backup.sh

# Restore
bash docker-database/docker-mongodb-restore.sh
```

Before running, edit the script variables:

| Variable         | Description                    |
| ---------------- | ------------------------------ |
| `MONGODB_URL`    | MongoDB connection string      |
| `CONTAINER_NAME` | Docker container name          |
| `DB_NAME`        | Database name (restore only)   |

#### PostgreSQL

```bash
# Backup
bash docker-database/docker-postgres-backup.sh

# Restore
bash docker-database/docker-postgres-restore.sh
```

Before running, edit the script variables:

| Variable         | Description                    |
| ---------------- | ------------------------------ |
| `DB_USER`        | PostgreSQL username            |
| `DB_NAME`        | Database name                  |
| `DB_PASS`        | Password (backup only)         |
| `CONTAINER_NAME` | Docker container name          |

### Clone Files (`clone_files.sh`)

Shallow-clones a Git repository and copies specified files to a destination directory. Configure the variables at the top of the script:

| Variable        | Description                                |
| --------------- | ------------------------------------------ |
| `REPO_URL`      | Repository URL to clone                    |
| `DEST_DIR`      | Local directory to copy files into         |
| `FILES_TO_COPY` | Array of file paths to extract from repo   |

```bash
bash clone_files.sh
```

## Environment Files

Environment files (`*.env`, `*.envrc`) are git-ignored. Each stack that requires environment variables includes a reference to the expected variables in this README or in comments within the compose file. Copy and configure your own `.env` files as needed.

