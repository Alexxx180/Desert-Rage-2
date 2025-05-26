extends RefCounted

class_name ConnectionParameters

var state: Dictionary = { "busy": false, "next_etape": false }
var result: Dictionary = { "data": [], "param": {}, "error": {} }

func reset_error() -> void:
	result.error = Transfer.safe()

func reset() -> void: ## Backend runtime parameters. Information about server state.
	result.param = Transfer.safe()
	reset_error()

func set_etape() -> void:
	state.next_etape = true

func not_busy() -> void:
	state.busy = false
	state.next_etape = false
