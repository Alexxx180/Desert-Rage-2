extends RefCounted

class_name ResponseParser

const DEFAULT: Array = []
enum { AUTH = 0, COMPLETE = 2, COPY = 3, META = 4, FIELD = 5 }

var _stop: bool
var object: Dictionary:
	set(value):
		for type in [types[META], types[COPY], types[AUTH].base, types[AUTH].sasl]:
			type.backend = value
		for type in [types[FIELD].specific.no]:
			type.responses = value.responses

var types: Array = [AuthResponse.new(), CompleteResponses.new(), NoticeResponses.new(),
	CopyTypeResponses.new(), MetaResponses.new(), FieldDescriptionResponses.new(), MessageIndicators.new()]

func set_stop() -> void: _stop = true
func _init() -> void:
	var sasl: EncryptionSASL = types[AUTH].sasl
	for response in [types[FIELD].data, sasl.start, sasl.end]:
		response.stop.connect(set_stop)

func available() -> bool:
	return types[META].available()

func recognized_type(type: String, meta: Dictionary) -> bool:
	var i: int = types.size()
	var recognized: bool = false
	while not recognized and i > 0:
		i -= 1
		recognized = recognized or types[i].parse(type, meta)
	return recognized

func parse(answer: PackedByteArray):
	_stop = false
	var meta: Dictionary = { "result": [], "backend": types[META].backend }
	var responses: BackendResponses = meta.backend.responses
	responses.fragments.add_answer(answer)
	while not _stop and meta.result == DEFAULT and available():
		var type: String = char(responses.fragments.first)
		if not recognized_type(type, meta):
			types[COMPLETE].unrecognized.response(type, meta)
		responses.next_fragment()
	return meta.result
