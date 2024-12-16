@tool
extends "res://addon/godot-behavior-tree-plugin/base/decorator.gd"

"""
	Decorator Node - Repeats the same node until we get
	an OK response this node ignores running and failed
	responses, choosing to retick the node instead
"""
func tick(mark: Tick) -> int:
	for child in get_children(): # 0..1 children
		while not child._execute(mark) == OK: pass
		return OK
	
	return OK
