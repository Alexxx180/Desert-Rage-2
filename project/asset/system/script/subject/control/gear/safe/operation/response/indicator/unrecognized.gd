extends RefCounted

class_name UnrecognizedResponses # Close the backend connection if ...

func response(type: String, object: Dictionary) -> void: 
	object.connection.fail() # ... message type unrecognized.
	object.connection.note.end_response("unrecognized", type)

func status(_type: String, object: Dictionary) -> void: # ... current transaction indicator unrecognized
	object.connection.note.ask_for_closure(false)
	object.responses.resize()
