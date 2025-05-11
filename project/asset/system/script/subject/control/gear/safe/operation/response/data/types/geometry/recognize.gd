extends RefCounted

class_name PostgresGeometryRecognize

signal stop()

var regex: Dictionary = {
	"POINT": "^\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\)",
	"BOX": "^\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\),\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\)",
	"LSEG": "^\\[\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\),\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\)\\]",
	"LINE": "^\\{(-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\}",
	"CIRCLE": "^<\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\),(\\d+(\\.\\d+)?)>"
}

func _end(object: Dictionary, type: String, error: String) -> void:
	object.note.end_response(object.responses, error, type)
	stop.emit()

func regex_search(object: Dictionary, type: String, converter: Callable) -> void:
	var result: RegExMatch = regex.search(object.data.get_string_from_ascii())
	if result:
		object.row.append(converter.call(result))
		# object.row.append(vector(result, 1, 2)) ??
	else: _end(object.responses, type, "invalid_value")

func _geometry(row, data, response, type: String, converter: Callable) -> void:
	var regex = RegEx.new()
	if regex.compile(regex[type], true) == OK:
		regex_search(object, type, converter)
	else: _end(object.responses, type, "regex_failed")

func _float(result, no: int): return result.strings[no].to_float()
func vector(r, x: int, y: int) -> Vector2: return Vector2(_float(r, x), _float(r, y))

func point(object: Dictionary) -> void: _geometry(object, "POINT", func(r): vector(r, 1, 2))

func box(object: Dictionary) -> void:
	_geometry(object, "BOX", func(r): Rect2(vector(r, 3, 4), vector(r, 1, 2))

func lseg(object: Dictionary) -> void: # Returns PackedVector2Array
	_geometry(object, "LSEG",
		func(r): PackedVector2Array([vector(r, 1, 2), vector(r, 3, 4)]))

func path(object: Dictionary) -> void: row.append(object, PackedVector2Array())

func line(object: Dictionary, type: String = "LINE") -> void:
	return _geometry(object, type, func(r): Vector3(
		_float(r, 1), _float(r, 2), _float(r, 3)))

func circle(object: Dictionary) -> void: return add_line(object, "CIRCLE")

func _todo(type: String) -> void: print("TODO '%s' type implementation" % type)
func tsvector(_row: Array, _value_data, _response) -> void: _todo("TSVECTOR")
func tsquery(_row: Array, _value_data, _response) -> void: _todo("TSQUERY")
