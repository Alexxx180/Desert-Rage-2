CREATE PROCEDURE append_settings(id UUID, experience JSON, controls JSON)
LANGUAGE SQL
BEGIN ATOMIC
 INSERT INTO settings (id, experience, controls) VALUES (id, experience, controls);
END;

CREATE PROCEDURE update_settings(id UUID, experience JSON, controls JSON)
LANGUAGE SQL
BEGIN ATOMIC
 UPDATE settings SET experience = experience, controls = controls WHERE id = id;
END;

CREATE PROCEDURE delete_settings(id UUID)
LANGUAGE SQL
BEGIN ATOMIC
 DELETE FROM settings WHERE id = id;
END;


CREATE PROCEDURE append_stats(id UUID, rampage JSON, walkthrough JSON, metadata JSON)
LANGUAGE SQL
BEGIN ATOMIC
 INSERT INTO stats (id, rampage, walkthrough, metadata) VALUES (id, rampage, walkthrough, metadata);
END;

CREATE PROCEDURE update_stats(id UUID, rampage JSON, walkthrough JSON, metadata JSON)
LANGUAGE SQL
BEGIN ATOMIC
 UPDATE stats SET rampage = rampage, walkthrough = walkthrough, metadata = metadata WHERE id = id;
END;

CREATE PROCEDURE delete_stats(id UUID)
LANGUAGE SQL
BEGIN ATOMIC
 DELETE FROM stats WHERE id = id;
END;


CREATE PROCEDURE append_information(id UUID, books JSON, pages JSON, bestiary JSON, skills JSON)
LANGUAGE SQL
BEGIN ATOMIC
 INSERT INTO information (id, books, pages, bestiary, skills) VALUES (id, books, pages, bestiary, skills);
END;

CREATE PROCEDURE update_information(id UUID, books JSON, pages JSON, bestiary JSON, skills JSON)
LANGUAGE SQL
BEGIN ATOMIC
 UPDATE information SET books = books, pages = pages, bestiary = bestiary, skills = skills WHERE id = id;
END;

CREATE PROCEDURE delete_information(id UUID)
LANGUAGE SQL
BEGIN ATOMIC
 DELETE FROM information WHERE id = id;
END;


CREATE PROCEDURE append_team(id UUID, location UUID, last_seen TIMESTAMP, info UUID)
LANGUAGE SQL
BEGIN ATOMIC
 INSERT INTO team (id, location, last_seen, info) VALUES (id, location, last_seen, info);
END;

CREATE PROCEDURE update_team(id UUID, location UUID, last_seen TIMESTAMP, info UUID)
LANGUAGE SQL
BEGIN ATOMIC
 UPDATE team SET location = location, last_seen = last_seen, info = info WHERE id = id;
END;

CREATE PROCEDURE delete_team(id UUID)
LANGUAGE SQL
BEGIN ATOMIC
 DELETE FROM team WHERE id = id;
END;


CREATE PROCEDURE append_hero(id UUID, name INTEGER, status JSON, inventory JSON, team UUID)
LANGUAGE SQL
BEGIN ATOMIC
 INSERT INTO hero (id, name, status, inventory, team) VALUES (id, name, status, inventory, team);
END;

CREATE PROCEDURE update_hero(id UUID, name INTEGER, status JSON, inventory JSON, team UUID)
LANGUAGE SQL
BEGIN ATOMIC
 UPDATE hero SET name = name, status = status, inventory = inventory, team = team WHERE id = id;
END;

CREATE PROCEDURE delete_hero(id UUID)
LANGUAGE SQL
BEGIN ATOMIC
 DELETE FROM hero WHERE id = id;
END;


CREATE PROCEDURE append_location(id UUID, name VARCHAR(20), level JSON, map JSON, team UUID)
LANGUAGE SQL
BEGIN ATOMIC
 INSERT INTO location (id, name, level, map, team) VALUES (id, name, level, map, team);
END;

CREATE PROCEDURE update_location(id UUID, name VARCHAR(20), level JSON, map JSON, team UUID)
LANGUAGE SQL
BEGIN ATOMIC
 UPDATE location SET name = name, level = level, map = map, team = team WHERE id = id;
END;

CREATE PROCEDURE delete_location(id UUID)
LANGUAGE SQL
BEGIN ATOMIC
 DELETE FROM location WHERE id = id;
END;
