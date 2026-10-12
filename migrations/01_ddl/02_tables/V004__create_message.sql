-- message: append-only by grant (INV-ADV-004): the writer gets INSERT and SELECT only.
CREATE TABLE advisor.message (
    id              uuid        NOT NULL DEFAULT gen_random_uuid(),
    conversation_id uuid        NOT NULL,
    role            text        NOT NULL,
    content         text        NOT NULL,
    created_at      timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_message          PRIMARY KEY (id),
    CONSTRAINT chk_message_role    CHECK (role IN ('USER', 'ASSISTANT')),
    CONSTRAINT chk_message_content CHECK (length(content) BETWEEN 1 AND 8000)
);
