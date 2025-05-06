CREATE TABLE settings (
	id UUID CONSTRAINT settings_pid PRIMARY KEY,
	experience JSON, controls JSON);

CREATE TABLE stats (
	id UUID CONSTRAINT stats_pid PRIMARY KEY,
	rampage JSON, walkthrough JSON, metadata JSON);

CREATE TABLE information (
	id UUID CONSTRAINT information_pid PRIMARY KEY,
	books JSON, pages JSON, bestiary JSON, skills JSON);

CREATE TABLE team (
	id UUID CONSTRAINT team_pid PRIMARY KEY,
	location UUID, last_seen TIMESTAMP,
	info UUID CONSTRAINT info_id REFERENCES information (id));

CREATE TABLE hero (
	id UUID CONSTRAINT hero_pid PRIMARY KEY,
	name INTEGER, status JSON, inventory JSON,
	team UUID CONSTRAINT team_id REFERENCES team (id));

CREATE TABLE location (
	id UUID CONSTRAINT info_id PRIMARY KEY,
	name VARCHAR(20), level JSON, map JSON,
	team UUID CONSTRAINT team_id REFERENCES team (id));

CREATE TABLE player (
	id UUID CONSTRAINT player_id PRIMARY KEY,
	name VARCHAR(20), created TIMESTAMP,
	info UUID CONSTRAINT info_id REFERENCES information (id),
	team UUID CONSTRAINT team_id REFERENCES team (id),
	stats UUID CONSTRAINT stats_id REFERENCES stats (id));


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


CREATE FUNCTION fix_settings() RETURNS trigger AS $fix_settings$
BEGIN
 IF NEW.experience IS NULL THEN NEW.experience := '{}'; END IF;
 IF NEW.controls IS NULL THEN NEW.controls := '{}'; END IF;
 RETURN NEW;
END;
$fix_settings$ LANGUAGE plpgsql;

CREATE TRIGGER check_settings BEFORE INSERT OR UPDATE ON settings
FOR EACH ROW EXECUTE PROCEDURE fix_settings();


CREATE FUNCTION fix_stats() RETURNS trigger AS $fix_stats$
BEGIN
 IF NEW.rampage IS NULL THEN NEW.rampage := '{}'; END IF;
 IF NEW.walkthrough IS NULL THEN NEW.walkthrough := '{}'; END IF;
 IF NEW.metadata IS NULL THEN NEW.metadata := '{}'; END IF;
 RETURN NEW;
END;
$fix_stats$ LANGUAGE plpgsql;

CREATE TRIGGER check_stats BEFORE INSERT OR UPDATE ON stats
FOR EACH ROW EXECUTE PROCEDURE fix_stats();


CREATE FUNCTION fix_information() RETURNS trigger AS $fix_information$
BEGIN
 IF NEW.books IS NULL THEN NEW.books := '{}'; END IF;
 IF NEW.pages IS NULL THEN NEW.pages := '{}'; END IF;
 IF NEW.bestiary IS NULL THEN NEW.bestiary := '{}'; END IF;
 IF NEW.skills IS NULL THEN NEW.skills := '{}'; END IF;
 RETURN NEW;
END;
$fix_information$ LANGUAGE plpgsql;

CREATE TRIGGER check_information BEFORE INSERT OR UPDATE ON information
FOR EACH ROW EXECUTE PROCEDURE fix_information();


CREATE FUNCTION fix_team() RETURNS trigger AS $fix_team$
BEGIN
 IF NEW.last_seen IS NULL THEN NEW.last_seen := NOW()::timestamp; END IF;
 RETURN NEW;
END;
$fix_team$ LANGUAGE plpgsql;

CREATE TRIGGER check_team BEFORE INSERT OR UPDATE ON team
FOR EACH ROW EXECUTE PROCEDURE fix_team();


CREATE FUNCTION fix_hero() RETURNS trigger AS $fix_hero$
BEGIN
 IF NEW.status IS NULL THEN NEW.status := '{}'; END IF;
 IF NEW.inventory IS NULL THEN NEW.inventory := '{}'; END IF;
 RETURN NEW;
END;
$fix_hero$ LANGUAGE plpgsql;

CREATE TRIGGER check_hero BEFORE INSERT OR UPDATE ON hero
FOR EACH ROW EXECUTE PROCEDURE fix_hero();


CREATE FUNCTION fix_location() RETURNS trigger AS $fix_location$
BEGIN
 IF NEW.name IS NULL THEN NEW.name := 'UNKNOWN'; END IF;
 IF NEW.level IS NULL THEN NEW.level := '{}'; END IF;
 IF NEW.map IS NULL THEN NEW.map := '{}'; END IF;
 RETURN NEW;
END;
$fix_location$ LANGUAGE plpgsql;

CREATE TRIGGER check_location BEFORE INSERT OR UPDATE ON location
FOR EACH ROW EXECUTE PROCEDURE fix_location();
