extends BehaviorAction

var rampage: int = 4
var has_boss: bool = false
var caption: String

func _set_context(mark: Tick) -> void:
	var context: Array = mark.blackboard.get_value("context")
	context.push_back(caption)

func tick(mark: Tick) -> int:
	if not has_boss: return FAILED
	
	var value: int = mark.blackboard.get_value("rampage")
	if value == rampage:
		_set_context(mark)
		mark.blackboard.set_value("rampage", value + 1)
		return OK
	return FAILED
