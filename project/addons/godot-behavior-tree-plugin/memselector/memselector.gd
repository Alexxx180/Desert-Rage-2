extends "res://addon/godot-behavior-tree-plugin/base/bt_base.gd"

"""
	Composite Node - ticks children until one returns OK,
	ERR_BUSY or ERROR. Fails ONLY if all children fail
	(return FAILED). Unlike ordinary Selector, this one
	picks up where it left off if it wasn't closed last time.
"""
func set_child(mark: Tick, i: int) -> void:
	mark.blackboard.set_value("runningChild", i, mark.tree, self)

func open(mark: Tick) -> void:
	set_child(mark, 0)

func tick(mark: Tick) -> int:
	var count: int = get_child_count()
	var i: int = mark.blackboard.get_value("runningChild", mark.tree, self) - 1

	if count == 0: return OK

	var result: int = FAILED

	while result == FAILED and i < count:
		i+= 1
		var child: Variant = get_child(i)
		result = child._execute(tick)

	if result == ERR_BUSY: set_child(mark, i)

	return result
