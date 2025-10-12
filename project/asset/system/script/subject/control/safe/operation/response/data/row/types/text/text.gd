extends RefCounted

class_name PostgresStringTypes

enum { TEXT = 25, CHARACTER = 1042, CHARACTER_VARYING = 1043, JSON_ = 114, JSONB = 3802, XML = 142 } # VARying, CHARacter # Schemas: JSON, XML

var recognize: TextPostgres = TextPostgres.new()

func resolve(object: Dictionary) -> bool:
	match object.type_id:
		TEXT: recognize.string(object)
		CHARACTER: recognize.string(object)
		CHARACTER_VARYING: recognize.string(object)
		XML: recognize.xml(object)
		JSON_: recognize.json(object)
		JSONB: recognize.binary_json(object)
		_: return false
	return true
