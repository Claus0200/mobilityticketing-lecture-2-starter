# MobilityTicketing: Lecture 2 starter

This repository is the student starter for the second databases lecture. It carries forward the small relational MobilityTicketing slice and adds an intentionally permissive ticketing schema.

The task is to turn business rules into database-enforced invariants and prove the result with successful and rejected writes. The reference migration is not included.

## Start the database

Requirements:

- Docker Desktop with Compose

Start PostgreSQL:

```bash
docker compose up -d
```

The database is available at `localhost:5432` with database `mobility`, user `mobility`, and password `mobility`.

Check the starter tables:

```bash
docker compose exec -T postgres psql -U mobility -d mobility -c '\dt'
```

The initialization scripts run only when PostgreSQL starts with an empty data directory. To replay them:

```bash
docker compose down -v
docker compose up -d
```

Apply a student migration from the host with:

```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/011_ticketing_integrity.sql
```

## Included files

- `compose.yaml`: PostgreSQL starter infrastructure.
- `database/postgres/init/`: baseline schema, representative seed data, and the weak ticketing schema.
- `database/postgres/migrations/011_ticketing_integrity.sql.example`: partial migration skeleton.
- `database/postgres/experiments/constraints_should_fail.sql`: invalid writes for testing.
- `docs/lab.md`: lab instructions and evidence guidance.
- `docs/integrity-map-template.md`: integrity-map and state-transition template.
