extends RefCounted

class_name MessageIndicators

enum { KEY = 0, VALUE = 1 }

func no_data(_object) -> void: pass
func ready_suspended(_object) -> void: pass # Portal-suspended. Appears only if an Execute row-count limit was reached.
func empty_query(_object) -> void: pass # Empty query string response. Substitutes for CommandComplete.

func function_call(object: Dictionary) -> void: # Identifies the message as a function call result.
	object.connection.note.warn("no_implementation", "FunctionCallResponse")

func _get_result(responses: BackendResponses, field: String) -> Dictionary:
	var report: Array = responses.split_byte(5, 1)
	return {
		"name": report[KEY].get_string_from_utf8(),
		field: report[VALUE].get_string_from_utf8()
	}

func status_report(object: Dictionary) -> void: # Identifies the message as a run-time parameter status report.
	var param: Dictionary = _get_result(object.responses, "value") # Get name and value of the run-time parameter being reported.
	object.connection.status.param[param.name] = param.value # The result

func notify(object: Dictionary) -> void: # Message identifiers below
	var process_id: int = object.responses.reverse(0, 5, 9).get_32() # Get the ID of notifying backend process.
	var channel: Dictionary = _get_result(object.responses, "payload") # notified
	prints(process_id, channel.name, channel.payload)
