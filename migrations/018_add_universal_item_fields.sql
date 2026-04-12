-- Write your migrate up statements here

ALTER TABLE items
	ADD COLUMN points_text TEXT,
	ADD COLUMN points_value INT,
	ADD COLUMN digital_submission BOOL,
	ADD COLUMN special_formatting BOOL;

UPDATE items SET digital_submission = FALSE, special_formatting = FALSE;

ALTER TABLE items
	ALTER COLUMN digital_submission SET NOT NULL,
	ALTER COLUMN special_formatting SET NOT NULL;

CREATE TABLE item_events (
	id BIGSERIAL PRIMARY KEY,
	item_id BIGINT REFERENCES items NOT NULL,
	date timestamp NOT NULL,

	{{ template "shared/timestamps.sql" }}
)

---- create above / drop below ----

ALTER TABLE items
	DROP COLUMN points_text,
	DROP COLUMN points_value,
	DROP COLUMN digital_submission,
	DROP COLUMN special_formatting;

DROP TABLE item_events;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
