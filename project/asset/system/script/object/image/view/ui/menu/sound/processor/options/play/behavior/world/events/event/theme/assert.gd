extends BehaviorLevelProgress

class_name BehaviorActionEvent

var event: int = 0
var key: String = "event"

func add_rampage(mark: Tick) -> void:
	set_progress(mark.blackboard)

func tick(mark: Tick) -> int:
	print("EVENT: ", get_parent().name)
	if mark.blackboard.compare(key, event):
		return OK
	return FAILED
