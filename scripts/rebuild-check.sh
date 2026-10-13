#!/usr/bin/env sh
# The rebuild check of Annex A and 06-data/migration-strategy.md, against a fresh instance:
# migrate from zero; migrate again applies nothing; every U in reverse leaves no schema and no
# roles; migrate again; validate; the seeds applied twice keep the same rows.
set -eu
cd "$(dirname "$0")/.."
export ADVISOR_DB_NAME="${ADVISOR_DB_NAME:-advisor}"
export ADVISOR_DB_USER="${ADVISOR_DB_USER:-advisor}"
export ADVISOR_DB_PASSWORD="${ADVISOR_DB_PASSWORD:-rebuild-check}"
PROJECT="advisor-db-check"
DC="docker compose -p $PROJECT -f deploy/compose.yml"
docker network inspect platform >/dev/null 2>&1 || docker network create platform >/dev/null
cleanup() { $DC --profile tooling down -v --remove-orphans >/dev/null 2>&1 || true; }
trap cleanup EXIT
cleanup

fail() { echo "FAIL: $1" >&2; exit 1; }
migrate() { $DC --profile tooling run --rm advisor-db-migrate "$@"; }
psql_db() { $DC exec -T advisor-db psql -v ON_ERROR_STOP=1 -U "$ADVISOR_DB_USER" -d "$ADVISOR_DB_NAME" "$@"; }

echo "== 1. migrate from an empty database"
$DC up -d advisor-db --wait
migrate migrate | tee /tmp/migrate-1.log
grep -q "Successfully applied" /tmp/migrate-1.log || fail "the first migrate applied nothing"

echo "== 2. migrate again applies nothing"
migrate migrate | tee /tmp/migrate-2.log
grep -q "No migration necessary" /tmp/migrate-2.log || fail "the second migrate applied something"

echo "== 3. every U script, from the highest version to the lowest"
for v in $(find migrations -path migrations/undo -prune -o -name 'V*__*.sql' -print | sed -E 's#.*/V([0-9]+)__.*#\1#' | sort -r); do
  u=$(find migrations/undo -name "U${v}__*.sql" | head -n1)
  [ -n "$u" ] || fail "V${v} has no U${v} script in migrations/undo"
  if [ "$v" = "002" ]; then
    domain_tables=$(psql_db -tA -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'advisor' AND table_name <> 'flyway_schema_history'")
    [ "$domain_tables" = "0" ] || fail "$domain_tables table(s) of the domain survived the undo scripts"
  fi
  echo "-- $u"
  psql_db < "$u" >/dev/null
done
left=$(psql_db -tA -c "SELECT count(*) FROM information_schema.schemata WHERE schema_name = 'advisor'")
[ "$left" = "0" ] || fail "schema advisor still exists after the undo scripts"
roles=$(psql_db -tA -c "SELECT count(*) FROM pg_roles WHERE rolname IN ('advisor_reader','advisor_writer')")
[ "$roles" = "0" ] || fail "the advisor roles still exist after the undo scripts"

echo "== 4. migrate again (the history went with the schema)"
migrate migrate | tee /tmp/migrate-3.log
grep -q "Successfully applied" /tmp/migrate-3.log || fail "the rebuild after the undo applied nothing"

echo "== 5. validate"
migrate validate

echo "== 6. the seeds are idempotent"
for f in migrations/02_dml/V*.sql; do [ -f "$f" ] || continue; psql_db < "$f" >/dev/null; psql_db < "$f" >/dev/null; done
counts=$(psql_db -tA -c "SELECT (SELECT count(*) FROM advisor.catalog_subject_view) || '/' || (SELECT count(*) FROM advisor.catalog_section_view) || '/' || (SELECT count(*) FROM advisor.student_view) || '/' || (SELECT count(*) FROM advisor.student_view WHERE tuition_status = 'ISSUED')")
[ "$counts" = "14/11/5/1" ] || fail "expected 14 subjects, 11 sections, 5 students, 1 unpaid; found $counts"
public_tables=$(psql_db -tA -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public'")
[ "$public_tables" = "0" ] || fail "a table lives in public"

echo "OK: qone-advisor-db rebuilds from zero, applies nothing twice, undoes completely, rebuilds, validates and seeds idempotently"
