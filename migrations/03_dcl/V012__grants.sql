-- message is append-only by grant (INV-ADV-004): INSERT and SELECT, nothing else.
GRANT USAGE ON SCHEMA advisor TO advisor_reader, advisor_writer;
GRANT SELECT ON ALL TABLES IN SCHEMA advisor TO advisor_reader;
GRANT SELECT, INSERT         ON advisor.conversation, advisor.message, advisor.inbox TO advisor_writer;
GRANT SELECT, INSERT, UPDATE ON advisor.plan, advisor.outbox,
                                advisor.catalog_subject_view, advisor.catalog_section_view, advisor.student_view TO advisor_writer;
GRANT SELECT, INSERT, UPDATE, DELETE ON advisor.llm_cache TO advisor_writer;
GRANT SELECT, INSERT, DELETE ON advisor.idempotency_key TO advisor_writer;
