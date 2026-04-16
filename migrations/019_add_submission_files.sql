-- Write your migrate up statements here

CREATE TABLE item_submissions (
	id BIGSERIAL PRIMARY KEY,
	item_id BIGINT REFERENCES items NOT NULL UNIQUE,
	submitter_id BIGINT REFERENCES users NOT NULL,
	submitted_digitally BOOL NOT NULL DEFAULT FALSE,
	instructions TEXT,

	CONSTRAINT physical_requires_instructions CHECK (NOT (instructions IS NULL AND submitted_digitally = FALSE)),

	{{ template "shared/timestamps.sql" }}
);

-- Use 1 as the default submitter ID. Not idea since there's no system user but it's fine.
INSERT INTO item_submissions (submitter_id, item_id, submitted_digitally, instructions, created_at, updated_at) SELECT 1, id, digital_submission, submission_summary, created_at, updated_at FROM items WHERE submission_summary IS NOT NULL;

ALTER TABLE items
	DROP COLUMN submission_summary;

CREATE TABLE item_files (
	id BIGSERIAL PRIMARY KEY,
	item_id BIGINT REFERENCES items,
	item_submission_id BIGINT REFERENCES item_submissions,
	file_data JSONB,

	CONSTRAINT not_detached CHECK ((item_id IS NULL) <> (item_submission_id IS NULL)),

	{{ template "shared/timestamps.sql" }}
);

---- create above / drop below ----

DROP TABLE item_files;

ALTER TABLE items
	ADD COLUMN submission_summary TEXT;

UPDATE items SET submission_summary = item_submissions.instructions FROM item_submissions WHERE items.id = item_submissions.item_id;

DROP TABLE item_submissions;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
