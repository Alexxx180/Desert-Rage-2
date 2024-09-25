extends Node

class_name Prompters

static func toggle(act: String) -> bool:
	return Input.is_action_just_pressed(act)

static func release(act: String) -> bool:
	return Input.is_action_just_released(act)
