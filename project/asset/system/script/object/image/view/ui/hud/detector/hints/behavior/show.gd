extends BehaviorAction

@onready var category: String = get_parent().name

func tick(mark: Tick) -> int:
	if (mark.blackboard.get_value("show")[category][name]):
		mark.blackboard.get_value("ref")[category][name].show()
	return OK
