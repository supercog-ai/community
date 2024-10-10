#/bin/sh
pg_dump -O -x --create -s -T alembic_version -h localhost -d monster_dashboard > ./postgres-init/monster_dashboard.sql
pg_dump -O -x -t alembic_version -h localhost -d monster_dashboard >> ./postgres-init/monster_dashboard.sql

pg_dump -O -x --create -s -T alembic_version -h localhost -d monster_engine > ./postgres-init/monster_engine.sql
pg_dump -O -x -t alembic_version -h localhost -d monster_engine >> ./postgres-init/monster_engine.sql

pg_dump -O -x --create -s -h localhost -d monster_credentials > ./postgres-init/monster_credentials.sql
