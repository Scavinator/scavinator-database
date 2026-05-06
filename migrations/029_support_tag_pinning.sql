-- Write your migrate up statements here

ALTER TABLE team_tags
	ADD COLUMN pinned INTEGER;

---- create above / drop below ----

ALTER TABLE team_tags
	DROP COLUMN pinned;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
