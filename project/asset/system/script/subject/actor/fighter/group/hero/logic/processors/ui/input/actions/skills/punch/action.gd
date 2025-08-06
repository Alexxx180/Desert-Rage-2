extends BehaviorAction 

@onready var caption: String = get_parent().name

func tick(mark: Tick) -> int:
	var action: Dictionary = mark.blackboard.get_value(caption)
	action.pressed = Input.is_action_pressed(name)
	action.toggled = Input.is_action_just_pressed(name)
	if action.toggled or action.pressed:
		return OK
	return FAILED
