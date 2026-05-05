-- Write your migrate up statements here

-- https://stackoverflow.com/q/63840721
CREATE FUNCTION notify_item_update() RETURNS TRIGGER AS $$
    DECLARE
    row RECORD;
    output TEXT;
    
    BEGIN
    -- Checking the Operation Type
    IF (TG_OP = 'DELETE') THEN
      row = OLD;
    ELSE
      row = NEW;
    END IF;

    PERFORM pg_notify('item_updates', row.id::text);

    RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER item_update_notify
  AFTER INSERT OR UPDATE
  ON items
  FOR EACH ROW
  EXECUTE PROCEDURE notify_item_update();

CREATE FUNCTION notify_item_submission_update() RETURNS TRIGGER AS $$
    DECLARE
    row RECORD;
    output TEXT;
    
    BEGIN
    -- Checking the Operation Type
    IF (TG_OP = 'DELETE') THEN
      row = OLD;
    ELSE
      row = NEW;
    END IF;

    PERFORM pg_notify('item_updates', row.item_id::text);

    RETURN NULL;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER item_submission_update_notify
  AFTER INSERT OR UPDATE OR DELETE
  ON item_submissions
  FOR EACH ROW
  EXECUTE PROCEDURE notify_item_submission_update();

---- create above / drop below ----

DROP TRIGGER item_update_notify ON items;
DROP TRIGGER item_submission_update_notify ON item_submissions;
DROP FUNCTION notify_item_update;
DROP FUNCTION notify_item_submission_update;

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.
