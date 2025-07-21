ALTER TABLE items
	ADD COLUMN submission_summary TEXT;

GRANT UPDATE (status, submission_summary) ON items TO {{ .integration_role }};

---- create above / drop below ----

ALTER TABLE items
	DROP COLUMN submission_summary;

REVOKE UPDATE (status) ON items FROM {{ .integration_role }};
