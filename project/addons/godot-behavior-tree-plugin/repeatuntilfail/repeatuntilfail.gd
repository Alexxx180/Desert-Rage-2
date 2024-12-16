@tool
extends "res://addon/godot-behavior-tree-plugin/base/decorator.gd"

"""
	Decorator Node. Repeats the same node until we either
	get a FAILED response. This node ignores running and
	success responses, choosing to retick the node instead
"""
func tick(_mark: Tick) -> int:
	for child in get_children(): # 0..1 children
		while not child._execute(tick) == FAILED: pass
		return OK

	return OK
