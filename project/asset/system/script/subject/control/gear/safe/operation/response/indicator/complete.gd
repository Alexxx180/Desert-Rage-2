extends RefCounted

class_name CompleteResponse

enum { NOT_IN_A_TRANSACTION_BLOCK, IN_A_TRANSACTION_BLOCK, IN_A_FAILED_TRANSACTION_BLOCK } ## 1+ queries transaction state.

var unrecognized: UnrecognizedResponses = UnrecognizedResponses.new()

func command_complete(object: Dictionary) -> void: # .. usually a completed SQL command identifier.
	object.responses.result.command_tag = responses.slice_word(5).get_string_from_ascii()
	object.connection.data.append(responses.result)
	object.responses.result = PostgreSQLQueryResult.new() # Setup object for next request

func _establish_connection(object: Dictionary) -> void:
	object.connection.succeed()
	object.credit.safe_reset() # Secure database password and username once log in.
	object.connection.establish()

func _retrieve_data(object: Dictionary, status: int, data: Array) -> void:
	object.connection.state.busy = false
	data_received.emit(connection.status.code, status, data)

func ready_for_query(object: Dictionary) -> Array: # Sent whenever backend ready for a new query cycle.
	var status: int
	var message: int = object.responses.get_current()
	var type: String = str(message)
	match type: # Get current backend transaction status indicator.
		'I': status = NOT_IN_A_TRANSACTION_BLOCK # If idle (if not in a transaction block).
		'T': status = IN_A_TRANSACTION_BLOCK # If in a transaction block.
		'E': status = IN_A_FAILED_TRANSACTION_BLOCK # If failed block (queries rejected until end).
		_: unrecognized.status()
	
	var data: Array = object.connection.renew_data()
	object.responses.resize()
	if object.connection.in_progress(): _establish_connection(object)
	elif object.connection.connected(): _retrieve_data(object, status, data)
	return data

func parse(_object) -> void: pass
func bind(_object) -> void: pass
func close(_object) -> void: pass
