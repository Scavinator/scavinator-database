-- Write your migrate up statements here

ALTER TABLE team_auths
	ADD COLUMN create_account BOOLEAN NOT NULL DEFAULT FALSE,
	ADD COLUMN ui_password BOOLEAN NOT NULL DEFAULT FALSE;

---- create above / drop below ----

ALTER TABLE team_auths
	DROP COLUMN create_account,
	DROP COLUMN ui_password;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
