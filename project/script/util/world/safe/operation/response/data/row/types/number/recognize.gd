class_name NumberPostgres extends RefCounted

signal stop()

const BOOLEAN_CHAR: int = 0

func to_float(result, no: int): return result.strings[no].to_float()

func force_stop(object: Dictionary) -> void:
	object.note.force_close("invalid_value", object.value)
	stop.emit()

func boolean(object: Dictionary) -> void:
	match str(object.value[BOOLEAN_CHAR]):
		't': object.row.append(true)
		'f': object.row.append(false)
		_: force_stop(object)

func integer(object: Dictionary) -> void:
	object.row.append(TextPostgres.ascii(object).to_int())

func floating(object: Dictionary) -> void:
	object.row.append(TextPostgres.ascii(object).to_float())
