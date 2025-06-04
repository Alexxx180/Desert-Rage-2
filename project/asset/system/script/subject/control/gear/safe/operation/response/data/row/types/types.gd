extends RefCounted

class_name PostgresDataTypes

var stop: bool = false # var row: Array # var value_data: Variant # var responses: BackendResponses
var backend: Dictionary

var number: PostgresNumberTypes = PostgresNumberTypes.new()
var text: PostgresStringTypes = PostgresStringTypes.new()
var bytes: PostgresBytesTypes = PostgresBytesTypes.new()
var geometry: PostgresGeometryTypes = PostgresGeometryTypes.new()

func set_stop() -> void: stop = true

func _init() -> void:
	for type in [number.recognize, text.recognize, geometry.recognize]:
		type.stop.connect(set_stop)

func simple(object: Dictionary) -> bool:
	return number.resolve(object) or text.resolve(object)

func complex(object: Dictionary) -> bool:
	return bytes.resolve(object) or geometry.resolve(object)

func resolve(i: int) -> void:
	backend.tgpe_id = backend.responses.buffer.result.get_type_object_id(i)
	if simple(backend) or complex(backend): return
	backend.row.append(backend.value) # PackedByteArray
