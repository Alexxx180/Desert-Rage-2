extends RefCounted

class_name PostgresNumberRecognize

signal stop()

const BOOLEAN_CHAR: int = 0

func to_float(result, no: int): return result.strings[no].to_float()

func force_stop(object: Dictionary) -> void:
	object.note.force_close("invalid_value", object.value)
	stop.emit()

func _boolean(object: Dictionary) -> bool:
	match str(object.value[BOOLEAN_CHAR]):
		't': row.append(true)
		'f': row.append(false)
		_: force_stop(object)

func integer(object: Dictionary) -> void:
	object.row.append(object.value.get_string_from_ascii().to_int())

func floating(object: Dictionary) -> void:
	object.row.append(object.value.get_string_from_ascii().to_float())

