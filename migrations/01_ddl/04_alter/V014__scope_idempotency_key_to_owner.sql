-- An Idempotency-Key belongs to the person who sent it (code-corhuila/qone-docs#55): the same key
-- from two people names two requests, so the key is unique per owner, not globally, and a replay
-- never answers someone else's conversation or reply. request_hash is the SHA-256 (hex) of the
-- canonical request: the same owner and key with a different request is refused by the API.
-- Keys written before this version get the owner of their resource and no hash.
ALTER TABLE advisor.idempotency_key
    ADD COLUMN owner_id     uuid NULL,
    ADD COLUMN request_hash text NULL;

UPDATE advisor.idempotency_key k
   SET owner_id = c.user_id
  FROM advisor.conversation c
 WHERE k.resource_type = 'conversation' AND c.id = k.resource_id;

UPDATE advisor.idempotency_key k
   SET owner_id = c.user_id
  FROM advisor.message m
  JOIN advisor.conversation c ON c.id = m.conversation_id
 WHERE k.resource_type = 'reply' AND m.id = k.resource_id;

DELETE FROM advisor.idempotency_key WHERE owner_id IS NULL;  -- a key whose resource no longer exists

ALTER TABLE advisor.idempotency_key
    ALTER COLUMN owner_id SET NOT NULL,
    DROP CONSTRAINT pk_idempotency_key,
    ADD CONSTRAINT pk_idempotency_key PRIMARY KEY (owner_id, key),
    ADD CONSTRAINT chk_idempotency_key_request_hash CHECK (request_hash IS NULL OR request_hash ~ '^[0-9a-f]{64}$');
