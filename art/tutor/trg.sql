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
