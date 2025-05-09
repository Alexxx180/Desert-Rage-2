extends RefCounted

class_name PostgresStringTypes

enum { TEXT = 25, CHARACTER = 1042, CHARACTER_VARYING = 1043, JSON_ = 114, JSONB = 3802, XML = 142 } # VARying, CHARacter # Schemas: JSON, XML

var add: PostgresStringRecognize = PostgresStringRecognize.new()

func resolve(object: Dictionary) -> bool:
	match object.type_id:
		TEXT: add.string(object)
		CHARACTER: add.string(object)
		CHARACTER_VARYING: add.string(object)
		XML: add.xml(object)
		JSON_: add.json(object)
		JSONB: add.binary_json(object)
		"TIMESTAMP": add.timestamp(object)
		"INTERVAL": add.interval(object)
		_: return false
	return true

