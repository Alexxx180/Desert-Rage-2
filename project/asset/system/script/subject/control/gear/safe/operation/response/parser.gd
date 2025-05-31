extends RefCounted

class_name ResponseParser

const DEFAULT: Array = []
enum { AUTH = 0, COMPLETE = 2, COPY = 3, META = 4, FIELD = 5 }

var _stop: bool
var _object: Dictionary
var object: Dictionary:
	set(value):
		_object = value
		for type in [types[COPY], types[AUTH].base, types[AUTH].sasl]:
			type.backend = value
		for type in [types[META], types[FIELD].specific.no]:
			type.responses = value.responses

var types: Array = [AuthResponse.new(), CompleteResponses.new(), NoticeResponses.new(),
	CopyTypeResponses.new(), MetaResponses.new(), FieldDescriptionResponses.new(), MessageIndicators.new()]

func set_stop() -> void: _stop = true
func _init() -> void:
	for response in [types[FIELD].data]:
		response.stop.connect(set_stop)

func available() -> bool: return types[META].available(_object.connection.client)
func recognized_type(type: String) -> bool:
	var i: int = types.size()
	var recognized: bool = false
	while not recognized and i > 0:
		i -= 1
		recognized = recognized or types[i].parse(type, _object)
	return recognized

func parse(fragmented_answer: PackedByteArray):
	_stop = false
	_object.result = []
	types[META].responses.add_answer(fragmented_answer)
	while not _stop and _object.result == DEFAULT and available():
		var message: int = types[META].responses.get_first()
		var type: String = char(message)
		if not recognized_type(type):
			types[COMPLETE].unrecognized.response(type, _object)
		_object.responses.next_fragment()
	return _object.result
