-- Back to one global key: when two owners used the same key, the oldest row keeps it (the key
-- only guards replays; the conversations and replies stay).
DELETE FROM advisor.idempotency_key k
 USING advisor.idempotency_key older
 WHERE k.key = older.key
   AND (k.created_at, k.owner_id) > (older.created_at, older.owner_id);

ALTER TABLE advisor.idempotency_key
    DROP CONSTRAINT IF EXISTS chk_idempotency_key_request_hash,
    DROP CONSTRAINT IF EXISTS pk_idempotency_key,
    ADD CONSTRAINT pk_idempotency_key PRIMARY KEY (key),
    DROP COLUMN IF EXISTS request_hash,
    DROP COLUMN IF EXISTS owner_id;
