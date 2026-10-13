-- Read models fed by catalog, enrollment and billing events (06-data/models.md, D-11). A
-- projection is rebuilt from the event stream, never edited by hand. catalog_subject_view is the
-- pensum the degree-audit tool reads (HU-ADV-002, scenario 1); same shape as enrollment's.
CREATE TABLE advisor.catalog_subject_view (
    subject_id    uuid        NOT NULL,
    code          text        NOT NULL,
    name          text        NOT NULL,
    credits       integer     NOT NULL,
    semester      integer     NOT NULL,
    prerequisites text[]      NOT NULL DEFAULT '{}',
    updated_at    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_catalog_subject_view PRIMARY KEY (subject_id)
);

CREATE TABLE advisor.catalog_section_view (
    section_id      uuid        NOT NULL,
    subject_code    text        NOT NULL,
    subject_name    text        NOT NULL,
    term            text        NOT NULL,
    group_number    integer     NOT NULL,
    professor_name  text        NOT NULL,
    slots           jsonb       NOT NULL,
    seats_available integer     NOT NULL,
    updated_at      timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_catalog_section_view PRIMARY KEY (section_id)
);

CREATE TABLE advisor.student_view (
    student_id         uuid        NOT NULL,
    passed_codes       text[]      NOT NULL DEFAULT '{}',
    confirmed_sections jsonb       NOT NULL DEFAULT '[]',
    tuition_status     text        NULL,
    updated_at         timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_student_view           PRIMARY KEY (student_id),
    CONSTRAINT chk_student_view_tuition  CHECK (tuition_status IS NULL OR tuition_status IN ('ISSUED', 'PAID')),
    CONSTRAINT chk_student_view_sections CHECK (jsonb_typeof(confirmed_sections) = 'array')
);
