extends RefCounted

class_name ResponseParser

const DEFAULT: Array = []

var _stop: bool
var _object: Dictionary
var object: Dictionary:
	get: return _object
	set(value):
		_object = value
		for type in [copy, auth.base, auth.sasl]:
			type.backend = value
		for type in [meta, field]:
			type.responses = value.responses

var notice: NoticeResponses = NoticeResponses.new()
var copy: CopyTypeResponses = CopyTypeResponses.new()
var field: FieldDescriptionResponses = FieldDescriptionResponses.new()
var meta: MetaResponses = MetaResponses.new()
var indicator: MessageIndicators = MessageIndicators.new()
var auth: AuthResponse = AuthResponse.new()
var complete: CompleteResponses = CompleteResponses.new()

func set_stop() -> void: _stop = true

func _init() -> void:
	for response in [field.data]:
		response.stop.connect(set_stop)

func available() -> bool:
	return meta.enough() and object.connection.connected() and meta.fragment_check()

func parse(fragmented_answer: PackedByteArray):
	_stop = false
	var result: Array = DEFAULT
	meta.add_answer(fragmented_answer)
	while not _stop and result == DEFAULT and available():
		var message: int = meta.responses.get_first()
		var type: String = str(message) # char
		match type:
			'A': indicator.notify(object)
			'C': complete.command(object)
			'D': field.data.row_response(object)
			'E': notice.error(object)
			'G': copy.response("In")
			'H': copy.response("Out")
			'N': notice.response(object)
			'I': indicator.empty_query(object)
			'K': auth.base.cancel()
			'R': auth.response()
			'S': indicator.status_report(object)
			'T': field.row()
			'V': indicator.function_call(object)
			'W': copy.response("Both")
			'Z': result = complete.ready_for_query(object)
			'c': copy.done()
			'd': copy.data()
			'n': indicator.no_data(object)
			's': indicator.ready_suspended(object)
			't': field.parameter()
			'v': meta.negotiate_version()
			'1': complete.parse(object)
			'2': complete.bind(object)
			'3': complete.close(object)
			_: complete.unrecognized.response(object, type)
		object.responses.next_fragment()
	return result
