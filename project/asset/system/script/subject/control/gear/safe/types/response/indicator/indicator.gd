extends RefCounted

class_name MessageIndicators

func no_data() -> void: pass
func ready_suspended() -> void: pass # Portal-suspended. Appears only if an Execute row-count limit was reached.
func empty_query() -> void: pass # Empty query string response. Substitutes for CommandComplete.


func function_call() -> void:# Identifies the message as a function call result.
	note.warn("no_implementation", "FunctionCallResponse")


func status_report() -> void:# Identifies the message as a run-time parameter status report.
	var report := responses.split_byte(5, 1) # Get name and value of the run-time parameter being reported.
	var key: String = report[0].get_string_from_utf8()
	var value: String = report[1].get_string_from_utf8()
	_connection.parameter[key] = value # The result

func notification() -> void: # Message identifiers below
	var report: Array = responses.split_byte(0, 5, 1) # Get the
	var process_id: int = responses.reverse(0, 5, 9).get_32() # .. of notifying backend process.
	var channel: Dictionary = { # ... notified name and "payload".
		"name": report[0].get_string_from_utf8()
		"payload": report[1].get_string_from_utf8()
	}
	prints(process_id, channel.name, channel.payload)
