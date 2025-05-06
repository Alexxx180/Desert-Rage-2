extends RefCounted

class_name PostgreSQLClientResponseParser

#var buffer ARE responses
#var response_buffer
var message_length: int
var _status: ConnectionMetadata
var note: PostgreClientNotify

var responses: BackendResponses

var query_result: PostgreSQLQueryResult = PostgreSQLQueryResult.new()
var datas_command_sql: Array = []

func get_utf8(data: Array, i: int) -> String:
	return data[i].get_string_from_utf8()

func _match_response(data, value, field, keys: Dictionary, feedback: Dictionary) -> void:
	if feedback.has(field):
		feedback[field].call()
	elif keys.has(field):
		data[keys[field]] = value
	# More field types might be added in future - unrecognized should be silently ignored.

func _get_match_fields() -> Dictionary:
	return {
		'V': "severity_no_localized", 'C': "SQLSTATE_code",
		'D': "detail", 'H': "hint", 'P': "position",
		'p': "internal_position", 'q': "internal_query",
		'W': "where", 's': "schema_name", 't': "table_name",
		'c': "column_name", 'd': "constraint_name", 'n': "constraint_name",
		'F': "file", 'L': "line", 'R': "routine"
	}

# Message identifiers below
func notification_response() -> void: # Get the process ID of the notifying backend process.
	var process_id = responses.reverse(5, 9, 0)
	process_id = buffer.get_32()
	
	var situation_report := responses.split_byte(5, 1, 0) # We get the following parameters.
	
	# Get the name of the channel that the notify has been raised on and "payload".
	var name_of_channel: String = get_utf8(situation_report, 0)
	var payload: String = get_utf8(situation_report, 1)
	
	prints(process_id, name_of_channel, payload)# The result.

func command_complete() -> void: # Command-completed response. Command tag is usually a word identifying completed SQL command.
	var command_tag = responses.slice(5, message_length + 1).get_string_from_ascii()
	
	query_result.command_tag = command_tag
	datas_command_sql.append(query_result)
	
	query_result = PostgreSQLQueryResult.new() # Setup object for next request

func _get_field(champ: String) -> Dictionary:
	var code = champ[0] # Identifies field type; if \0 - its the message terminator - no string follows.
	return { "type": code, "value": champ.trim_prefix(code) }

func _iterate_fields(set_feedback: Callable) -> void:
	var notice_object: Dictionary = {}
	for champ_data in responses.split_byte(5, 0): # For each field there is the following:
		var field: Dictionary = _get_field(champ_data.get_string_from_ascii())
		var keys: Dictionary = _get_match_fields()
		var feedback: Dictionary = set_feedback.call(keys, field)
		_match_response(notice_object, field.value, field.type, keys, feedback)

func notice_response() -> void: # Message body consists of one or more identified fields, followed by a \0 as a terminator. Fields appear in any order.
	iterate_fields(func(keys, _field):
		keys['S'] = "severity"
		keys['M'] = "message"
		return Defaults.DICT
	)
	
	var last_datas_command_sql = datas_command_sql.back()
	if last_datas_command_sql:
		last_datas_command_sql.notice = notice_object

func error_response() -> void: # Error body consists of one or more identified fields, followed by a \0 as a terminator. Fields can appear in any order.
	iterate_fields(func(keys, field):
		keys['S'] = "severity"
		keys['M'] = "message"
		return {
			'S': func():
				if field.value == "FATAL":
					_status.reset()
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

# Get the format codes to be used for each column.
# Each must presently be zero (text) or one (binary). All must be zero if the overall copy format is textual.
func format_column_codes(buffer, response, columns) -> void:
	for index in columns:
		var format_code = _reverse_response(buffer, response.slice(10, 13), 2 * index + 3)
		format_code = buffer.get_16()
		print(format_code) # The result.

func copy_type_response(type: String) -> void:# The message "CopyResponse" identifies the message as a Start Copy response. This message will be followed by copy data.
	responses.buffer = StreamPeerBuffer.new()
	var overall_copy_format_code = responses.reverse(5, 7, 0)
	overall_copy_format_code = responses.buffer.get_8() # Get overall copy format code. 0 indicates the overall COPY format is text (rows separated by newlines, columns separated by separator characters, etc). 1 indicates the overall copy format is binary (similar to DataRow format). See COPY for more information.	
	var number_of_columns = responses.reverse(7, 10, 1)
	number_of_columns = responses.buffer.get_16() # Get the number of columns in the data to be copied.
	format_column_codes(buffer, response_buffer, number_of_columns)
	
	note.warn(" Copy" + type + "Response, no support.")

func copy_data() -> void:# Identifies the message as COPY data. Get data that forms part of a COPY data stream. Messages sent from the backend will always correspond to single data rows.
	print(responses.slice(5, message_length + 1))

func copy_done() -> void: print("CopyDone")
# Identifies the message as a COPY-complete indicator.

func cancel_response() -> void: # Cancellation key data. The frontend must save these values if it wishes to be able to issue CancelRequest messages later.
	# Get the process ID of this backend.
	var process_backend_id_buffer = responses.reverse(5, 9, 4)
	process_backend_id_buffer = buffer.get_u32()
	
	# Get the secret key of this backend.
	var process_backend_secret_key_buffer = responses.reverse(9, responses.length + 1, 0)
	process_backend_secret_key = buffer.get_u32() # The result.

func status_report() -> void:
	### ParameterStatus ### Identifies the message as a run-time parameter status report.
	var situation_report_data := responses.split_byte(5, 1)
	# Get the name and the value of the run-time parameter being reported.
	var key: String = situation_report_data[0].get_string_from_utf8()
	var value: String = situation_report_data[1].get_string_from_utf8()
	
	_status.parameter[key] = value # The result

func row_description_response() -> void: # Get the number of fields in a row (can be zero).
	var number_of_fields_in_a_row := responses.reverse(5, 7), 4)
	query_result.number_of_fields_in_a_row = buffer.get_u16()
	
	# Then, for each field...
	var cursor := 7
	for _index in query_result.number_of_fields_in_a_row:
		# Get the field name.
		var field_name := ""
		
		for octet in response_buffer.slice(cursor, message_length + 1):
			field_name += char(octet)
			
			# If we get to the end of the chain, we get out of the loop.
			if not octet:
				break
		
		cursor += len(field_name)
		
		buffer = StreamPeerBuffer.new()
		var fields: Dictionary = {}
		# Get the object ID of the table. If the field can be identified as a column of a specific table, the object ID of the table; otherwise zero.
		var table_object_id = responses.reverse(cursor, cursor + 5, 0)
		fields.table_object_id = buffer.get_u32()
		
		# Get the attribute number of the column. If the field can be identified as a column of a specific table, the attribute number of the column; otherwise zero.
		var column_index = responses.reverse(cursor + 5, cursor + 7, 4)
		fields.column_index = buffer.get_u16()
		
		# Get the object ID of the field's data type.
		var type_object_id = responses.reverse(cursor + 7, cursor + 11, 6)
		fields.type_object_id = buffer.get_u32()
		
		# Get the data type size (see pg_type.typlen). Note that negative values denote variable-width types.
		var data_type_size = responses.reverse(cursor + 11, cursor + 13, 10)
		fields.data_type_size = buffer.get_u16()
		
		# Get the type modifier (see pg_attribute.atttypmod). The meaning of the modifier is type-specific.
		var type_modifier = responses.reverse(cursor + 13, cursor + 17, 12)
		fields.type_modifier = buffer.get_u32()
		
		# Get the format code being used for the field. Currently will be zero (text) or one (binary). In a RowDescription returned from the statement variant of Describe, the format code is not yet known and will always be zero.
		var format_code = responses.reverse(cursor + 17, cursor + 19, 16)
		fields.format_code = buffer.get_u16()
		
		cursor += 19
		query_result.row_description.append(fields)# The result.

func ready_for_query(): # Identifies the message type. ReadyForQuery is sent whenever the backend is ready for a new query cycle. Get current backend transaction status indicator.
	var transaction_status: TransactionStatus
	
	match char(response_buffer[message_length]):
		'I': transaction_status = TransactionStatus.NOT_IN_A_TRANSACTION_BLOCK # If idle (if not in a transaction block).
		'T': transaction_status = TransactionStatus.IN_A_TRANSACTION_BLOCK # If in a transaction block.
		'E': transaction_status = TransactionStatus.IN_A_FAILED_TRANSACTION_BLOCK # If failed transaction block (queries rejected until block end).
		_:
			# We close the connection with the backend if current backend transaction status indicator is not recognized.
			close(false)
			response_buffer.resize(0)
	
	var data_returned := datas_command_sql
	
	datas_command_sql = []
	response_buffer.resize(0)
	
	if status == Status.CONNECTING:
		status = Status.CONNECTED
		
		# Secure database password and username once log in.
		password_global = ""
		user_global = ""
		
		connection_established.emit()
	elif status == Status.CONNECTED:
		busy = false
		
		data_received.emit(error_object, transaction_status, data_returned)
	
	return data_returned

func parameter_description_response() -> void:# Identifies the message as a parameter description. Get the number of parameters used by the statement (can be zero).
	var number_of_parameters = responses.reverse(5, 7, 4)
	number_of_parameters = buffer.get_16()
	# Then, for each parameter, there is the following:
	var data_types = []
	var cursor := 7
	for index in number_of_parameters:
		# Get the object ID of the parameter data type.
		var object_id = responses.reverse(cursor, cursor + 5), cursor + index - 1)
		data_types.append(buffer.get_32())
		cursor += 5
	
	print(data_types)# The result.

func negotiate_version_response() -> void:# Identifies the message as a protocol version negotiation message.
	# Get newest minor protocol version supported by the server for the major protocol version requested by the client.
	var minor_protocol_version = responses.reverse(5, 9, 4)
	minor_protocol_version = buffer.get_u32()
	# Get the number of protocol options not recognized by the server.
	var number_of_options = responses.reverse(9, 14, 8)
	number_of_options = buffer.get_u32()
	# Then, for each protocol option not recognized by the server...
	var _cursor := 0
	for _index in number_of_options: pass # Get the option name.
	
	prints(minor_protocol_version)# The result.

func no_data() -> void: pass # As no-data indicator.
func ready_for_query_suspended() -> void: pass # Portal-suspended indicator. Appears only if an Execute message's row-count limit was reached.
func empty_query_response() -> void: pass # Identifies the message as a response to an empty query string. (This substitutes for CommandComplete.)
func parse_complete() -> void: pass # Identifies the message as a Parse-complete indicator.# Identifies the message as a Parse-complete indicator.
func bind_complete() -> void: pass # Identifies the message as a Bind-complete indicator.
func close_complete() -> void: pass # Identifies the message as a Close-complete indicator.

func function_call_response() -> void:# Identifies the message as a function call result.
	print("FunctionCallResponse no implemented.")

func unrecognized_response() -> void: # Close the backend connection if message type unrecognized.
	status = Status.ERROR
	types.add._end_response(response_buffer, " The type of message sent by the backend is not recognized: " + message_type)

func get_response_length() -> bool:
	responses.buffer := StreamPeerBuffer.new()
	var data_length = _get_reverse_response(buffer, response_buffer, 1, 5)
	message_length = buffer.get_u32()
	return responses.size() < message_length + 1

func client_connected() -> bool:
	return client.get_status() == StreamPeerTCP.STATUS_CONNECTED

func response_parser(fragmented_answer: PackedByteArray):
	#response_buffer += fragmented_answer
	responses.responses += fragmented_answer
	while responses.size() > 4 and client_connected() and get_response_length(): # If the size of the buffer is not equal to the length of the message, the request is not processed immediately. The server may send a fragmented response. We must therefore wait to receive the full response.
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
			'K': cancel_response()
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
			_: unrecognized_response()
		responses.next_fragment()
