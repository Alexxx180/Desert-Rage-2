extends RefCounted

class_name JumpTarget

var _available: bool = false
var available: bool:
	get: return _available
	set(value): _available = value

func decide(ledge: Callable) -> bool:
	if available:
		ledge.call(self)
	return available
