-- Roles carry permissions and have no password (Annex A rule 10): NOLOGIN.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'advisor_reader') THEN
        CREATE ROLE advisor_reader NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'advisor_writer') THEN
        CREATE ROLE advisor_writer NOLOGIN;
    END IF;
END
$$;
