CREATE TABLE users (
	id BIGSERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	email_address TEXT NOT NULL UNIQUE,
	password_digest TEXT NOT NULL,
	admin BOOLEAN DEFAULT false NOT NULL,

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE teams (
	id BIGSERIAL PRIMARY KEY,
	affiliation TEXT NOT NULL,
	prefix TEXT NOT NULL UNIQUE,
	virtual BOOLEAN NOT NULL,
	uchicago BOOLEAN NOT NULL,

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE team_users (
	id BIGSERIAL PRIMARY KEY,
	captain BOOLEAN NOT NULL DEFAULT false,
	approved BOOLEAN NOT NULL,
	invited BOOLEAN NOT NULL,
	team_id BIGINT REFERENCES teams,
	user_id BIGINT REFERENCES users,

	CONSTRAINT team_users_unique UNIQUE (team_id, user_id),

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE scav_hunts (
	id BIGSERIAL PRIMARY KEY,
	start TIMESTAMP,
	"end" TIMESTAMP,
	name TEXT NOT NULL,

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE team_scav_hunts (
	id BIGSERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	slug TEXT NOT NULL,
	scav_hunt_id BIGINT REFERENCES scav_hunts NOT NULL,
	team_id BIGINT REFERENCES teams NOT NULL,

	discord_guild_id TEXT,
	discord_items_channel_id TEXT UNIQUE,
	discord_pages_channel_id TEXT UNIQUE,
	discord_items_message_id TEXT UNIQUE,
	discord_pages_message_id TEXT UNIQUE,

	CONSTRAINT team_scav_hunt_unique_per_scav_per_team UNIQUE (scav_hunt_id, team_id),
	CONSTRAINT team_scav_hunt_slug_unique_per_team UNIQUE (team_id, slug),

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE team_roles (
	id BIGSERIAL PRIMARY KEY,
	team_id BIGINT REFERENCES teams NOT NULL,
	name TEXT NOT NULL,
	enabled BOOLEAN NOT NULL DEFAULT false,

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE team_tags (
	id BIGSERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	enabled BOOLEAN NOT NULL DEFAULT false,
	color TEXT,
	team_id BIGINT REFERENCES teams NOT NULL,
	team_role_id BIGINT REFERENCES team_roles,

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE team_role_members (
	id BIGSERIAL PRIMARY KEY,
	user_id BIGINT REFERENCES users NOT NULL,
	team_scav_hunt_id BIGINT REFERENCES team_scav_hunts NOT NULL,
	team_role_id BIGINT REFERENCES team_roles NOT NULL,

	CONSTRAINT team_role_members_unique UNIQUE (user_id, team_scav_hunt_id, team_role_id),

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE items (
	id BIGSERIAL PRIMARY KEY,
	team_scav_hunt_id BIGINT REFERENCES team_scav_hunts NOT NULL,
	number INTEGER,
	page_number INTEGER,
	content TEXT,
	discord_thread_id TEXT UNIQUE,

	CONSTRAINT team_scav_hunt_item_number_unique UNIQUE (team_scav_hunt_id, number),

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE pages (
	id BIGSERIAL PRIMARY KEY,
	team_scav_hunt_id BIGINT REFERENCES team_scav_hunts NOT NULL,
	page_number INTEGER,
	discord_thread_id TEXT UNIQUE,
	discord_message_id TEXT UNIQUE,

	CONSTRAINT team_scav_hunt_pages_unique UNIQUE (team_scav_hunt_id, page_number),

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE item_tags (
	id BIGSERIAL PRIMARY KEY,
	item_id BIGINT REFERENCES items NOT NULL,
	team_tag_id BIGINT REFERENCES team_tags NOT NULL,
	accepted BOOLEAN,

	CONSTRAINT item_tags_unique UNIQUE (item_id, team_tag_id),

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE page_captains (
	id BIGSERIAL PRIMARY KEY,
	team_scav_hunt_id BIGINT REFERENCES team_scav_hunts NOT NULL,
	user_id BIGINT REFERENCES users NOT NULL,
	page_number INTEGER NOT NULL,

	-- Corrected -- In the base migration this was only on (user_id, team_scav_hunt_id)
	CONSTRAINT team_scav_hunt_pages_page_captains_unique UNIQUE (page_number, user_id, team_scav_hunt_id),

	{{ template "shared/timestamps.sql" }}
);

CREATE TABLE item_users (
	id BIGSERIAL PRIMARY KEY,
	user_id BIGINT REFERENCES users NOT NULL,
	item_id BIGINT REFERENCES items NOT NULL,

	CONSTRAINT item_users_unique UNIQUE (user_id, item_id),

	{{ template "shared/timestamps.sql" }}
);

---- create above / drop below ----

DROP TABLE item_users;
DROP TABLE page_captains;
DROP TABLE item_tags;
DROP TABLE pages;
DROP TABLE items;
DROP TABLE team_role_members;
DROP TABLE team_tags;
DROP TABLE team_roles;
DROP TABLE team_scav_hunts;
DROP TABLE scav_hunts;
DROP TABLE team_users;
DROP TABLE teams;
DROP TABLE users;
