extends RefCounted

class_name UnrecognizedResponses # Close the backend connection if ...

var connection: ConnectionMetadata
var responses: BackendResponses

func response(type: String) -> void: 
	connection.fail() # ... message type unrecognized.
	connection.note.end_response(responses, "unrecognized", type)

func status() -> void: # ... current transaction indicator unrecognized
	connection.note.ask_for_closure(false)
	responses.resize()
