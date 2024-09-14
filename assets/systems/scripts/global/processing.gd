extends Node

class_name Processors

const will: ProcessMode = Node.PROCESS_MODE_INHERIT
const wont: ProcessMode = Node.PROCESS_MODE_DISABLED

static func switch(processor: Node) -> void:
	turn(processor, processor.process_mode == wont)

static func turn(processor: Node, condition: bool) -> void:
	processor.process_mode = will if condition else wont

static func toggle(act: String) -> bool:
	return Input.is_action_just_pressed(act)

static func release(act: String) -> bool:
	return Input.is_action_just_released(act)

static func hold(act: String) -> bool:
	return Input.is_action_pressed(act)
