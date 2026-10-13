-- Foreign keys inside the domain, after every table exists (Annex A rule 2).
ALTER TABLE advisor.message
    ADD CONSTRAINT fk_message_conversation FOREIGN KEY (conversation_id) REFERENCES advisor.conversation (id) ON DELETE RESTRICT;
ALTER TABLE advisor.plan
    ADD CONSTRAINT fk_plan_conversation FOREIGN KEY (conversation_id) REFERENCES advisor.conversation (id) ON DELETE RESTRICT;
