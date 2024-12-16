@tool
extends "res://addon/godot-behavior-tree-plugin/base/decorator.gd"

""" Decorator Node. Always returns OK if not running or errored """

func tick(mark: Tick) -> int:
	for child in get_children(): # 0..1 children
		var result = child._execute(mark)

		if result == ERR_BUSY: return result

	return OK
