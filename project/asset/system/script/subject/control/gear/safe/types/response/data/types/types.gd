extends RefCounted

class_name PostgresDataTypes

var _stop: bool = false # var row: Array # var value_data: Variant # var responses: BackendResponses
var object: Dictionary = {}

var number: PostgresNumberTypes = PostgresNumberTypes.new()
var text: PosgresStringTypes = PosgresStringTypes.new()
var bytes: PosgresBytesTypes = PosgresBytesTypes.new()
var geometry: PosgresGeometryTypes = PosgresGeometryTypes.new()

func set_stop() -> void: _stop = true

func simple(object: Dictionary) -> bool:
	return number.resolve(object) or text.resolve(object)

func complex(object: Dictionary) -> bool:
	return bytes.resolve(object) or geometry.resolve(object)

func resolve(i: int) -> bool:
	object.type_id = object.responses.result.get_type_object_id(i)
	if simple(object) or complex(object): return _stop
	row.append(object.value) # PackedByteArray
	return _stop
