extends RefCounted

class_name PostgresNumberTypes

enum { BOOLEAN = 16, SMALLINT = 21, INTEGER = 23, BIGINT = 20, REAL = 700, DOUBLE_PRECISION = 701 } # Boolean # Integer # Floating point value

var add: PostgresNumberRecognize = PostgresNumberRecognize.new()

func resolve(object: Dictionary) -> void:
	match object.type_id:
		BOOLEAN: add.boolean(object)
		SMALLINT: add.integer(object)
		INTEGER: add.integer(object)
		BIGINT: add.integer(object)
		"DECIMAL": add.floating(object)
		"NUMERIC": add.floating(object)
		REAL: add.floating(object)
		DOUBLE_PRECISION: add.floating(object)
		"SMALLSERIAL": add.integer(object)
		"SERIAL": add.integer(object)
		"BIGSERIAL": add.integer(object)
		_: return false
	return true
