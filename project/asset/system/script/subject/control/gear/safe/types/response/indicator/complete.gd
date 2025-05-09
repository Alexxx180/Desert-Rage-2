extends RefCounted

class_name CompleteResponse

enum { NOT_IN_A_TRANSACTION_BLOCK, IN_A_TRANSACTION_BLOCK, IN_A_FAILED_TRANSACTION_BLOCK } ## 1+ queries transaction state.

var unrecognized: UnrecognizedResponses = UnrecognizedResponses.new()
var responses: BackendResponses
var connection: ConnectionMetadata
var credit: EncryptionCredentials

func command_complete() -> void: # .. usually a completed SQL command identifier.
	query_result.command_tag = responses.slice_word(5).get_string_from_ascii()
	connection.data.append(query_result)
	query_result = PostgreSQLQueryResult.new() # Setup object for next request

func _establish_connection() -> void:
	connection.succeed()
	credit.safe_reset() # Secure database password and username once log in.
	connection_established.emit()

func _retrieve_data(status: int, data: Array) -> void:
	connection.state.busy = false
	data_received.emit(connection.status.code, status, data)

func ready_for_query() -> Array: # Sent whenever backend ready for a new query cycle.
	var status: int
	var message: int = responses.get_current()
	var type: String = str(message)
	match type: # Get current backend transaction status indicator.
		'I': status = NOT_IN_A_TRANSACTION_BLOCK # If idle (if not in a transaction block).
		'T': status = IN_A_TRANSACTION_BLOCK # If in a transaction block.
		'E': status = IN_A_FAILED_TRANSACTION_BLOCK # If failed block (queries rejected until end).
		_: unrecognized.status()
	
	var data: Array = connection.renew_data()
	responses.resize()
	if connection.in_progress(): _establish_connection()
	elif connection.connected(): _retrieve_data(status, data)
	return data

func parse() -> void: pass
func bind() -> void: pass
func close() -> void: pass
