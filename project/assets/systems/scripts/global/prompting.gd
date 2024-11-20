extends Node

class_name Prompters

static func toggle(act: String) -> bool:
	return Input.is_action_just_pressed(act)

static func release(act: String) -> bool:
	return Input.is_action_just_released(act)

static func moved() -> bool:
	for act in ["left", "right", "forward", "backward"]:
		if Input.is_action_pressed(act):
			return true
	return false
