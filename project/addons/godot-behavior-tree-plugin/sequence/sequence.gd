extends "res://addon/godot-behavior-tree-plugin/base/bt_base.gd"

"""
	Composite Node - ticks children until one
	returns FAILED or ERR_BUSY. Succeeds ONLY
	if all children succeed (return OK)
"""
func tick(mark: Tick) -> int:
	var result := OK

	for child in get_children():
		result = child._execute(mark)

		if not result == OK: break

	return result
