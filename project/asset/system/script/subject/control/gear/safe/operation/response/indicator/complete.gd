extends RefCounted

class_name CompleteResponses

signal data_received(code, status, data)

enum { NOT_IN_A_TRANSACTION_BLOCK, IN_A_TRANSACTION_BLOCK, IN_A_FAILED_TRANSACTION_BLOCK } ## 1+ queries transaction state.

var unrecognized: UnrecognizedResponses = UnrecognizedResponses.new()

func command(object: Dictionary) -> void: # .. usually a completed SQL command identifier.
	object.responses.result.command_tag = object.responses.slice_word(5).get_string_from_ascii()
	object.connection.data.append(object.responses.result)
	object.responses.result = PostgreSQLQueryResult.new() # Setup object for next request

func _establish_connection(object: Dictionary) -> void:
	object.connection.succeed()
	object.credit.safe_reset() # Secure database password and username once log in.
	object.connection.establish()

func _retrieve_data(object: Dictionary, status: int, data: Array) -> void:
	object.connection.state.busy = false
	data_received.emit(object.connection.status.code, status, data)

func ready_for_query(object: Dictionary) -> Array: # Sent whenever backend ready for a new query cycle.
	var status: int
	var message: int = object.responses.get_current()
	var type: String = char(message)
	match type: # Get current backend transaction status indicator.
		'I': status = NOT_IN_A_TRANSACTION_BLOCK # If idle (if not in a transaction block).
		'T': status = IN_A_TRANSACTION_BLOCK # If in a transaction block.
		'E': status = IN_A_FAILED_TRANSACTION_BLOCK # If failed block (queries rejected until end).
		_: unrecognized.status(type, object)
	
	var data: Array = Transfer.renew(object.connection.result.data, [])
	object.responses.resize()
	if object.connection.in_progress(): _establish_connection(object)
	elif object.connection.client.connected(): _retrieve_data(object, status, data)
	return data

func parsing(_object) -> void: pass
func bind(_object) -> void: pass
func close(_object) -> void: pass
func parse(type: String, object: Dictionary) -> bool:
	match type:
		'C': command(object)
		'Z': object.result = ready_for_query(object)
		'1': parsing(object)
		'2': bind(object)
		'3': close(object)
		_: return false
	return true
