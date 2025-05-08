extends RefCounted

class_name UnrecognizedResponses # Close the backend connection if ...

func response(type: String) -> void: 
	_connection.fail() # ... message type unrecognized.
	note.end_response(responses, "unrecognized", type)

func status() -> void: # ... current transaction indicator unrecognized
	note.ask_for_closure(false)
	responses.resize(0)
