#!/bin/bash

echo "$PACT_BROKER_DATABASE_HOST:5432:$PACT_BROKER_DATABASE_NAME:$PACT_BROKER_DATABASE_USERNAME:$PACT_BROKER_DATABASE_PASSWORD" > ~/.pgpass
chmod 0600 ~/.pgpass

pg_restore -d pact -h postgres -U pact -w -c pgdump
psql -d pact -h postgres -U pact -w -f update_test_results.sql
