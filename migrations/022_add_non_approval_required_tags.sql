-- Write your migrate up statements here

ALTER TABLE team_tags
	ADD COLUMN requires_approval BOOLEAN NOT NULL DEFAULT FALSE,
	ALTER COLUMN enabled SET DEFAULT TRUE;

---- create above / drop below ----

ALTER TABLE team_tags
	DROP COLUMN requires_approval,
	ALTER COLUMN enabled SET DEFAULT FALSE;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
