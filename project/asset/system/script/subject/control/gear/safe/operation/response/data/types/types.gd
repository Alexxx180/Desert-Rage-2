extends RefCounted

class_name PostgresDataTypes

var stop: bool = false # var row: Array # var value_data: Variant # var responses: BackendResponses
var object: Dictionary

var number: PostgresNumberTypes = PostgresNumberTypes.new()
var text: PosgresStringTypes = PosgresStringTypes.new()
var bytes: PosgresBytesTypes = PosgresBytesTypes.new()
var geometry: PosgresGeometryTypes = PosgresGeometryTypes.new()

func set_stop() -> void: stop = true

func _init() -> void:
	for type in [number, text, geometry]:
		type.stop.connect(set_stop)

func simple(object: Dictionary) -> bool:
	return number.resolve(object) or text.resolve(object)

func complex(object: Dictionary) -> bool:
	return bytes.resolve(object) or geometry.resolve(object)

func resolve(i: int) -> void:
	object.type_id = object.responses.result.get_type_object_id(i)
	if simple(object) or complex(object):
		return
	row.append(object.value) # PackedByteArray
