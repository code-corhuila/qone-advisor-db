-- conversation: one chat of one user. user_id is the token's sub and NOT a foreign key (identity);
-- every tool call is scoped to it server-side (INV-ADV-002). user_role chooses the tool set.
CREATE TABLE advisor.conversation (
    id         uuid        NOT NULL DEFAULT gen_random_uuid(),
    user_id    uuid        NOT NULL,
    user_role  text        NOT NULL,
    model      text        NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_conversation        PRIMARY KEY (id),
    CONSTRAINT chk_conversation_role  CHECK (user_role IN ('STUDENT', 'PROFESSOR', 'ADMIN')),
    CONSTRAINT chk_conversation_model CHECK (length(model) BETWEEN 1 AND 80)
);
