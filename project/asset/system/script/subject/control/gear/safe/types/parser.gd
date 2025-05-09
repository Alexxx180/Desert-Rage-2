extends RefCounted

class_name ResponseParser

const DEFAULT: Array = []

var connection: ConnectionMetadata

var notice: NoticeResponses
var copy: CopyTypeResponses
var field: FieldDescriptionReponses
var meta: MetaResponses
var indicator: MessageIndicators
var auth: AuthResponse

func available() -> bool:
	return meta.enough() and connection.connected() and meta.fragment_check()

func parse(fragmented_answer: PackedByteArray):
	var result: Array = DEFAULT
	meta.add_answer(fragmented_answer)
	while result == DEFAULT and available():
		var message: int = meta.responses.get_first()
		var type: String = str(message) # char
		match type:
			'A': indicator.notification()
			'C': complete.command()
			'D': data.row_response()
			'E': notice.error()
			'G': copy.response("In")
			'H': copy.response("Out")
			'N': notice.response()
			'I': indicator.empty_query()
			'K': auth.base.cancel()
			'R': auth.response()
			'S': indicator.status_report()
			'T': field.row()
			'V': indicator.function_call()
			'W': copy.response("Both")
			'Z': result = complete.ready_for_query()
			'c': copy.done()
			'd': copy.data()
			'n': meta.no_data()
			's': meta.ready_suspended()
			't': field.parameter()
			'v': meta.negotiate_version()
			'1': complete.parse()
			'2': complete.bind()
			'3': complete.close()
			_: complete.unrecognized.response(type)
		responses.next_fragment()
	return result
