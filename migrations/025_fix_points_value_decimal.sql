-- Write your migrate up statements here

ALTER TABLE items
	ALTER COLUMN points_value TYPE NUMERIC;

---- create above / drop below ----

ALTER TABLE items
	ALTER COLUMN points_value TYPE INTEGER;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
