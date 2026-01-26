extends BehaviorAction

@onready var category: String = get_parent().name

func _gets(mark: Tick, key: String) -> Variant:
	return mark.blackboard.g("show")[category][name]

func tick(mark: Tick) -> int:
	if _gets(mark, "show"): _gets(mark, "ref").show()
	return OK
