-- Write your migrate up statements here

CREATE TABLE team_auths (
	id BIGSERIAL PRIMARY KEY,

	team_id bigint REFERENCES teams,
	creator_id bigint REFERENCES users NOT NULL,
	created_for_url text,
	key text UNIQUE NOT NULL,

	{{ template "shared/timestamps.sql" }}
);

---- create above / drop below ----

DROP TABLE team_auths;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
