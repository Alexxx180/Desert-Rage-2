extends BehaviorAction

@onready var category: String = get_parent().name

func tick(mark: Tick) -> int:
	var show: Dictionary = mark.blackboard.get_value("show")
	var hint: Dictionary = show[category][name]
	if (hint.suits): hint.ref.show()
	return OK
