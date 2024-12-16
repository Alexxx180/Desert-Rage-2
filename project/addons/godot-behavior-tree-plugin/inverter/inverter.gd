@tool
extends "res://addon/godot-behavior-tree-plugin/base/decorator.gd"

"""
	Decorator Node. Inverter does not change running
	responses. Returns OK on FAILED, FAILED on OK.
"""
func tick(_mark: Tick) -> int:
	for child in get_children(): # 0..1 children
		var result: int = child._execute(tick)
		match result:
			OK: return FAILED
			FAILED: return OK
			_: return result

	return OK
