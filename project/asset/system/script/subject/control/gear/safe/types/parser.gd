extends RefCounted

class_name PostgreSQLClientResponseParser

const DEFAULT: Array = []

var _connection: ConnectionMetadata

var responses: BackendResponses
var notice: NoticeResponses
var copy: CopyTypeResponses
var field: FieldDescriptionReponses
var meta: MetaResponses
var indicator: MessageIndicators
var auth: AuthResponse

func available() -> bool:
	return responses.size() > 4 and _connection.connected() and meta.length()

func parse(fragmented_answer: PackedByteArray):
	var result: Array = DEFAULT
	responses.responses += fragmented_answer
	while result == DEFAULT and available():
		var message: int = responses.get_first()
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
