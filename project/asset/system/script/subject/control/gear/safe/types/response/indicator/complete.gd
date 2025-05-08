extends RefCounted

var unrecognized: UnrecognizedResponses = UnrecognizedResponses.new()

func command_complete() -> void: # Command tag usually a completed SQL command identifier.
	var command_tag = responses.slice(5, responses.length + 1).get_string_from_ascii()
	
	query_result.command_tag = command_tag
	datas_command_sql.append(query_result)
	query_result = PostgreSQLQueryResult.new() # Setup object for next request

func _establish_connection() -> void:
	_connection.succeed()
	credit.safe_reset() # Secure database password and username once log in.
	connection_established.emit()

func _retrieve_data() -> void:
	_connection.state.busy = false
	data_received.emit(_connection.status.error, status, data_returned)

func ready_for_query() -> Array: # Sent whenever backend ready for a new query cycle.
	var status: TransactionStatus
	match char(responses.get_current()): # Get current backend transaction status indicator.
		'I': status = TransactionStatus.NOT_IN_A_TRANSACTION_BLOCK # If idle (if not in a transaction block).
		'T': status = TransactionStatus.IN_A_TRANSACTION_BLOCK # If in a transaction block.
		'E': status = TransactionStatus.IN_A_FAILED_TRANSACTION_BLOCK # If failed block (queries rejected until end).
		_: unrecognized.status()
	
	var data_returned: Array = datas_command_sql
	datas_command_sql = []
	responses.resize(0)
	
	if _connection.in_progress(): _establish_connection()
	elif _connection.connected(): _retrieve_data()

	return data_returned

func parse() -> void: pass
func bind() -> void: pass
func close() -> void: pass
