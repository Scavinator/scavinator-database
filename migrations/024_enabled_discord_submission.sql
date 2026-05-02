-- Write your migrate up statements here

ALTER TABLE item_submissions
	ALTER COLUMN submitter_id DROP NOT NULL,
	ADD COLUMN submitter_discord_id TEXT,
	ADD CONSTRAINT submitter_exists CHECK (NOT (submitter_id IS NULL AND submitter_discord_id IS NULL));

ALTER TABLE items
	DROP COLUMN status;

DROP TYPE item_status;

---- create above / drop below ----

CREATE TYPE item_status AS ENUM ('box');

ALTER TABLE items
	ADD COLUMN status item_status;

ALTER TABLE item_submissions
	DROP CONSTRAINT submitter_exists,
	DROP COLUMN submitter_discord_id,
	ALTER COLUMN submitter_id SET NOT NULL;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
