extends BehaviorAction

signal action()
signal kick()

var actions: Dictionary = { "action": action, "run": kick }

func tick(_mark: Tick) -> int:
	for key in actions:
		if Input.is_action_just_pressed(key):
			actions[key].emit()
	return OK
