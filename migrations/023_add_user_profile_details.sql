-- Write your migrate up statements here

ALTER TABLE users
	ADD COLUMN pronouns TEXT,
	ADD COLUMN about_me TEXT,
	ADD COLUMN avatar_data JSONB,
	ADD COLUMN team_contact TEXT,
	ADD COLUMN emergency_contact TEXT;

---- create above / drop below ----

ALTER TABLE users
	DROP COLUMN pronouns,
	DROP COLUMN about_me,
	DROP COLUMN avatar_data,
	DROP COLUMN team_contact,
	DROP COLUMN emergency_contact;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
