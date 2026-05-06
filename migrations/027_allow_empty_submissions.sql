-- Write your migrate up statements here

ALTER TABLE item_submissions
	DROP CONSTRAINT physical_requires_instructions;

---- create above / drop below ----

ALTER TABLE item_submissions
	ADD CONSTRAINT physical_requires_instructions CHECK ((NOT ((instructions IS NULL) AND (submitted_digitally = false))));

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
