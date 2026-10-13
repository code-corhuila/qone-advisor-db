CREATE INDEX ix_conversation_user_created ON advisor.conversation (user_id, created_at DESC);      -- AD-03
CREATE INDEX ix_message_conversation_created ON advisor.message (conversation_id, created_at DESC); -- AD-04
CREATE INDEX ix_plan_conversation ON advisor.plan (conversation_id, created_at);
CREATE INDEX ix_plan_proposed_expires ON advisor.plan (expires_at) WHERE status = 'PROPOSED';       -- expiry job
CREATE UNIQUE INDEX ux_plan_confirmation ON advisor.plan (confirmation_id) WHERE confirmation_id IS NOT NULL;
CREATE UNIQUE INDEX ux_plan_saga ON advisor.plan (saga_id) WHERE saga_id IS NOT NULL;                -- saga outcome
CREATE INDEX ix_llm_cache_created_at ON advisor.llm_cache (created_at);                              -- 7-day prune
CREATE UNIQUE INDEX ux_catalog_subject_view_code ON advisor.catalog_subject_view (code);
CREATE INDEX ix_outbox_unpublished ON advisor.outbox (occurred_at) WHERE published_at IS NULL;
CREATE INDEX ix_idempotency_key_created_at ON advisor.idempotency_key (created_at);
