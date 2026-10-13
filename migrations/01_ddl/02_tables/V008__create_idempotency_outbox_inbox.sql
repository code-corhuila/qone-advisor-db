-- The shared shapes of 06-data: idempotent creation (5.3.8), events published (5.3.11) and the
-- ids of events already consumed (idempotent consumer). A reply key points at the assistant
-- message; the plan of that reply shares its conversation and creation instant.
CREATE TABLE advisor.idempotency_key (
    key           text        NOT NULL,
    resource_type text        NOT NULL,
    resource_id   uuid        NOT NULL,
    created_at    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_idempotency_key           PRIMARY KEY (key),
    CONSTRAINT chk_idempotency_key_length   CHECK (length(key) BETWEEN 8 AND 128),
    CONSTRAINT chk_idempotency_key_resource CHECK (resource_type IN ('conversation', 'reply'))
);

CREATE TABLE advisor.outbox (
    id             uuid        NOT NULL DEFAULT gen_random_uuid(),
    aggregate_type text        NOT NULL,
    aggregate_id   uuid        NOT NULL,
    event_type     text        NOT NULL,
    payload        jsonb       NOT NULL,
    occurred_at    timestamptz NOT NULL DEFAULT now(),
    published_at   timestamptz NULL,
    CONSTRAINT pk_outbox             PRIMARY KEY (id),
    CONSTRAINT chk_outbox_event_type CHECK (event_type IN ('PlanProposed', 'PlanConfirmed', 'PlanDismissed'))
);

CREATE TABLE advisor.inbox (
    event_id    uuid        NOT NULL,
    consumed_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_inbox PRIMARY KEY (event_id)
);
