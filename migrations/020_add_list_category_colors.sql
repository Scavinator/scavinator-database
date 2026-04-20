-- Write your migrate up statements here

ALTER TABLE list_categories
	ADD COLUMN color TEXT;

---- create above / drop below ----

ALTER TABLE list_categories
	DROP COLUMN color TEXT;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
