extends RefCounted

class_name PostgreSQLClientResponseParser

var credit: EncryptionCredentials
var message_length: int
var _connection: ConnectionMetadata
var note: PostgreClientNotify

var responses: BackendResponses

var query_result: PostgreSQLQueryResult = PostgreSQLQueryResult.new()
var datas_command_sql: Array = []

func _match_response(data, value, field, keys: Dictionary, feedback: Dictionary) -> void:
	if feedback.has(field):
		feedback[field].call()
	elif keys.has(field):
		data[keys[field]] = value
	# Unrecognized types (e.g. not implemented) should be silently ignored.

func _get_match_fields() -> Dictionary:
	return {
		'V': "severity_no_localized", 'C': "SQLSTATE_code",
		'D': "detail", 'H': "hint", 'P': "position",
		'p': "internal_position", 'q': "internal_query",
		'W': "where", 's': "schema_name", 't': "table_name",
		'c': "column_name", 'd': "constraint_name", 'n': "constraint_name",
		'F': "file", 'L': "line", 'R': "routine"
	}

func notification_response() -> void: # Message identifiers below
	var report: Array = responses.split_byte(0, 5, 1) # Get the
	var process_id: int = responses.reverse(0, 5, 9).get_32() # .. of notifying backend process.
	var channel: Dictionary = { # ... notified name and "payload".
		"name": report[0].get_string_from_utf8()
		"payload": report[1].get_string_from_utf8()
	}
	prints(process_id, channel.name, channel.payload)

func command_complete() -> void: # Command tag usually a completed SQL command identifier.
	var command_tag = responses.slice(5, responses.length + 1).get_string_from_ascii()
	
	query_result.command_tag = command_tag
	datas_command_sql.append(query_result)
	query_result = PostgreSQLQueryResult.new() # Setup object for next request

func _get_field(champ: String) -> Dictionary:
	var code = champ[0] # Identifies field type; if \0 message terminator else no string follows.
	return { "type": code, "value": champ.trim_prefix(code) }

func _iterate_fields(set_feedback: Callable) -> void:
	var notice_object: Dictionary = {}
	for champ_data in responses.split_byte(5, 0): # For each field there is the following:
		var field: Dictionary = _get_field(champ_data.get_string_from_ascii())
		var keys: Dictionary = _get_match_fields()
		var feedback: Dictionary = set_feedback.call(keys, field)
		_match_response(notice_object, field.value, field.type, keys, feedback)

# Consists of 1+ fields in any order, followed by \0 terminator.
func notice_response() -> void:
	iterate_fields(func(keys, _field):
		keys['S'] = "severity"
		keys['M'] = "message"
		return Defaults.DICT
	)
	var last = datas_command_sql.back()
	if last: last.notice = notice_object

func error_response() -> void: 
	iterate_fields(func(keys, field):
		keys['S'] = "severity"
		keys['M'] = "message"
		return {
			'S': func():
				if field.value == "FATAL":
					_connection.reset()
					status = Status.DISCONNECTED
					status_ssl = 0
					connection_closed.emit() # true
				error_object["severity"] = field.value
			'M': func():
				error_object["message"] = field.value
				note.fail(" " + field.value)
		}
	)
	
	if error_object["severity"] == "FATAL":
		status = Status.ERROR # Check unnessary
		authentication_error.emit(error_object.duplicate()) # if status != Status.CONNECTED

# Get format codes to use for each column. Must be 0 (text) / 1 (binary).
func format_column_codes(columns) -> void:
	var columns: int = responses.reverse(1, 7, 10).get_16()# Get columns number in the data to be copied.
	for index in columns:
		var seek: int = 2 * index + 3
		var code: int = responses.reverse(seek, 10, 13).get_16()
		print(code) # The format code result.

func _get_overall_copy_format_code() -> int: # 0 - text (separation: rows - [\r]\n, columns - \t, etc). 1 - binary (as DataRow).
	return responses.reverse(0, 5, 7).get_8() # See COPY for more information.

func copy_type_response(type: String) -> void: # Identifies message as a Start Copy response. Will be followed by copy data.
	responses.buffer = StreamPeerBuffer.new()
	_get_overall_copy_format_code()
	format_column_codes() 
	note.warn("no_support", " Copy" + type + "Response")

func copy_data() -> void: print(responses.slice(5, responses.length + 1)) # Get COPY stream forming data part. Backend messages sent will always correspond to single data rows.
func copy_done() -> void: print("CopyDone") # Identifies the message as a COPY-complete indicator.

func status_report() -> void:# Identifies the message as a run-time parameter status report.
	var report := responses.split_byte(5, 1) # Get name and value of the run-time parameter being reported.
	var key: String = report[0].get_string_from_utf8()
	var value: String = report[1].get_string_from_utf8()
	_connection.parameter[key] = value # The result

func _find_field_name_length(octets: PackedByteArray) -> int:
	var field: String = ""
	var i: int = 0
	while i < octets.size():
		field += char(octets[i])
		i += 1
	return len(field)

func row_description_response() -> void: 
	query_result.number_of_fields_in_a_row = responses.reverse(4, 5, 7).get_u16()
	responses.cursor = 7
	# Get the number of fields in a row (can be zero). Then for each field...
	for _index in query_result.number_of_fields_in_a_row:
		responses.cursor += _find_field_name_length(responses.slice(1))
		responses.buffer = StreamPeerBuffer.new()
		var fields: Dictionary = { # Get the
			"table_object_id": responses.reverse(0, 5).get_u32(), # table object ID ...
			"column_index": responses.reverse(4, 2).get_u16(), # column attribute number ...
			# ... if field can be identified as specific table column: otherwise zero
			"type_object_id": responses.reverse(6, 4).get_u32(), # field's data type object ID
			"data_type_size": responses.reverse(10, 2).get_u16(), # data type size
			"type_modifier": responses.reverse(12, 4).get_u32(), # type modifier. The meaning is type-specific.
			"format_code": responses.reverse(16, 2).get_u16() # field used format code. 0 (text, default) / 1 (binary).
		} # Note that negative values denote variable-width types. See also pg_type.typlen, pg_attribute.atttypmod
		query_result.row_description.append(fields)# The result.

func unrecognized_status() -> void: # Close the backend connection if current transaction indicator unrecognized
	note.ask_for_closure(false)
	responses.resize(0)

func ready_for_query(): # Sent whenever backend ready for a new query cycle.
	var transaction_status: TransactionStatus
	match char(responses.get_current()): # Get current backend transaction status indicator.
		'I': transaction_status = TransactionStatus.NOT_IN_A_TRANSACTION_BLOCK # If idle (if not in a transaction block).
		'T': transaction_status = TransactionStatus.IN_A_TRANSACTION_BLOCK # If in a transaction block.
		'E': transaction_status = TransactionStatus.IN_A_FAILED_TRANSACTION_BLOCK # If failed block (queries rejected until end).
		_: unrecognized_status()
	
	var data_returned: Array = datas_command_sql
	
	datas_command_sql = []
	response_buffer.resize(0)
	
	if status == Status.CONNECTING:
		status = Status.CONNECTED
		credit.safe_reset()# Secure database password and username once log in.
		connection_established.emit()
	elif status == Status.CONNECTED:
		_connection.busy = false
		data_received.emit(error_object, transaction_status, data_returned)
	return data_returned

func parameter_description_response() -> void: 
	var number_of_parameters = responses.reverse(4, 5, 7).get_16() # used by the statement (can be 0).
	var data_types = []
	responses.cursor = 7
	for index in number_of_parameters:
		var seek: int = responses.cursor + index - 1
		data_types.append(responses.reverse(seek, 5).get_32())# Get object ID of the parameter data type.
		cursor += 5
	
	print(data_types)# The result.

func get_the_option_name(number: int) -> void:
	for _index in number: pass # For each protocol option not recognized by the server...

func negotiate_version_response() -> void:# Protocol version negotiation message:
	var minor: int = responses.reverse(4, 5, 9).get_u32()# newest minor ver. supported by the server for client major ver. request
	var options: int = responses.reverse(8, 9, 14).get_u32()# protocol options number unrecognized by the server.
	get_the_option_name(options)
	prints(minor)# The result.

# Message indicators
func no_data() -> void: pass
func ready_for_query_suspended() -> void: pass # Portal-suspended. Appears only if an Execute row-count limit was reached.
func empty_query_response() -> void: pass # Empty query string response. (Substitutes for CommandComplete.)
func parse_complete() -> void: pass
func bind_complete() -> void: pass
func close_complete() -> void: pass

func function_call_response() -> void:# Identifies the message as a function call result.
	print("no_implementation", "FunctionCallResponse")

func unrecognized_response(type: String) -> void: 
	status = Status.ERROR # Close the backend connection if message type unrecognized.
	note.end_response(responses, "unrecognized", type)

func get_response_length() -> bool:# Wait to receive full response.
	responses.buffer := StreamPeerBuffer.new()
	var data_length = response.reverse(0, 1, 5).get_u32()
	responses.length = buffer
	return responses.size() < message_length + 1 # Fragmentary check

func client_connected() -> bool:
	return client.get_status() == StreamPeerTCP.STATUS_CONNECTED

func response_parser(fragmented_answer: PackedByteArray):
	responses.responses += fragmented_answer
	while responses.size() > 4 and client_connected() and get_response_length():
		var message_type = char(response_buffer[0])
		match message_type:
			'A': notification_response()
			'C': command_complete()
			'D': data.row_response()
			'E': error_response()
			'G': copy_type_response("In")
			'H': copy_type_response("Out")
			'N': notice_response()
			'I': empty_query_response()
			'K': credit.cancel(responses)
			'R': auth._response()
			'S': status_report()
			'T': row_description_response()
			'V': function_call_response()
			'W': copy_type_response("Both")
			'Z': return ready_for_query()
			'c': copy_done()
			'd': copy_data()
			'n': no_data()
			's': ready_for_query_suspended()
			't': parameter_description_response()
			'v': negotiate_version_response()
			'1': parse_complete()
			'2': bind_complete()
			'3': close_complete()
			_: unrecognized_response(message_type)
		responses.next_fragment()
