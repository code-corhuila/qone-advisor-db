-- By now every table of the domain is gone; only flyway_schema_history remains, so CASCADE
-- removes the migration history as well.
DROP SCHEMA IF EXISTS advisor CASCADE;
