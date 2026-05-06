-- Write your migrate up statements here

ALTER TABLE team_scav_hunts
	ADD COLUMN digital_submission_link TEXT;

---- create above / drop below ----

ALTER TABLE team_scav_hunts
	DROP COLUMN digital_submission_link;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
