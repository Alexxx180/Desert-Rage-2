extends "res://addon/godot-behavior-tree-plugin/base/bt_base.gd"

"""
	Composite Node. Ticks children until one
	returns OK or ERR_BUSY. Fails ONLY if all
	children fail (return FAILED)
"""
func tick(mark: Tick) -> int:
	var result: int = OK

	for child in get_children():
		result = child._execute(mark)

		if not result == FAILED: break

	return result
