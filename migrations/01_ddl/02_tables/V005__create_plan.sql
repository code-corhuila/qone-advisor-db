-- plan: what the agent proposes and the student confirms (INV-ADV-001, INV-ADV-003). Only
-- PROPOSED and EXECUTING are non-terminal; a plan carries a confirmation id exactly when it was
-- confirmed, and that id travels into the saga (INV-ENR-005). summary is frozen at proposal time.
CREATE TABLE advisor.plan (
    id              uuid        NOT NULL DEFAULT gen_random_uuid(),
    conversation_id uuid        NOT NULL,
    student_id      uuid        NOT NULL,
    section_id      uuid        NOT NULL,
    summary         jsonb       NOT NULL,
    status          text        NOT NULL,
    confirmation_id uuid        NULL,
    saga_id         uuid        NULL,
    expires_at      timestamptz NOT NULL,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_plan               PRIMARY KEY (id),
    CONSTRAINT chk_plan_status       CHECK (status IN ('PROPOSED', 'EXECUTING', 'EXECUTED', 'FAILED', 'DISMISSED', 'EXPIRED')),
    CONSTRAINT chk_plan_confirmation CHECK ((status IN ('EXECUTING', 'EXECUTED', 'FAILED')) = (confirmation_id IS NOT NULL)),
    CONSTRAINT chk_plan_expiry       CHECK (expires_at > created_at),
    CONSTRAINT chk_plan_summary      CHECK (jsonb_typeof(summary) = 'object')
);

COMMENT ON COLUMN advisor.plan.section_id IS 'Id in catalog.section; no foreign key across domains.';
