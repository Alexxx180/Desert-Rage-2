class_name PostgresNumberTypes extends RefCounted

enum { BOOLEAN = 16, SMALLINT = 21, INTEGER = 23, BIGINT = 20, REAL = 700, DOUBLE_PRECISION = 701 } # Boolean # Integer # Floating point value

var recognize: NumberPostgres = NumberPostgres.new()

func resolve(object: Dictionary) -> bool:
	match object.type_id:
		BOOLEAN: recognize.boolean(object)
		SMALLINT: recognize.integer(object)
		INTEGER: recognize.integer(object)
		BIGINT: recognize.integer(object)
		"DECIMAL": recognize.floating(object)
		"NUMERIC": recognize.floating(object)
		REAL: recognize.floating(object)
		DOUBLE_PRECISION: recognize.floating(object)
		"SMALLSERIAL": recognize.integer(object)
		"SERIAL": recognize.integer(object)
		"BIGSERIAL": recognize.integer(object)
		_: return false
	return true
