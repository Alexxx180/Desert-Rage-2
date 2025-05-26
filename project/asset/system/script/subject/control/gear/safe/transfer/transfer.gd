extends RefCounted

class_name Transfer

static func safe() -> Dictionary: return {} ## Secure dictionary as empty if backend disconnected - updates once connection is established.

static func renew(data, default) -> Variant:
	var next: Variant = data
	data = default
	return next

static func reverse(data: PackedByteArray) -> PackedByteArray:
	data.reverse()
	return data

static func define(state: bool, task: Callable) -> bool:
	if state: task.call()
	return state
