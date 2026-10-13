-- llm_cache: provider answers by SHA-256 of model and prompt; pruned by qone-worker after 7 days.
CREATE TABLE advisor.llm_cache (
    key        text        NOT NULL,
    response   jsonb       NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_llm_cache      PRIMARY KEY (key),
    CONSTRAINT chk_llm_cache_key CHECK (key ~ '^[0-9a-f]{64}$')
);
