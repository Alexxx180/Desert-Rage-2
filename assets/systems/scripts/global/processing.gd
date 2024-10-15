extends Node

class_name Processors

const will: ProcessMode = Node.PROCESS_MODE_INHERIT
const wont: ProcessMode = Node.PROCESS_MODE_DISABLED

static func _reset(holder: Node, mode: ProcessMode) -> void:
	holder.process_mode = mode

static func disable(holder: Node) -> void: _reset(holder, wont)
static func enable(holder: Node) -> void: _reset(holder, will)

static func switch(holder: Node) -> void:
	turn(holder, holder.process_mode == wont)

static func turn(holder: Node, condition: bool) -> void:
	_reset(holder, will if condition else wont)

static func switch_both(previous: Node, next: Node) -> void:
	turn(previous, false)
	turn(next, true)

static func lazy(holder: Node, act: Callable, variant) -> void:
	enable(holder)
	turn(holder, act.call(variant))
