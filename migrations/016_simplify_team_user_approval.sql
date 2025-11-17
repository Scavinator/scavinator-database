-- Write your migrate up statements here

ALTER TABLE team_users
	DROP COLUMN invited,
	ALTER COLUMN approved DROP NOT NULL;

---- create above / drop below ----

ALTER TABLE team_users
	ADD COLUMN invited boolean NOT NULL DEFAULT false,
	ALTER COLUMN approved SET NOT NULL;

ALTER TABLE team_users
	ALTER COLUMN invited DROP DEFAULT;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
