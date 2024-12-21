extends BehaviorTreeBase

class_name BehaviorMemSequence

"""
	Compsite Node - ticks children until one returns FAILED,
	ERR_BUSY or ERROR. Succeeds ONLY if all children succeed
	(return OK). Unlike ordinary sequence, this one picks up
	where it left off if it wasn't closed last time.
"""
func set_child(mark: Tick, i: int) -> void:
	mark.blackboard.set_value("runningChild", i, mark.tree, self)

func open(mark: Tick) -> void: set_child(mark, 0)

func tick(mark: Tick) -> int:
	var result: int = OK
	var count: int = get_child_count()
	var i: int = mark.blackboard.get_value("runningChild", mark.tree, self) - 1

	while i < count and result == OK:
		i += 1
		result = get_child(i)._execute(mark)

	if result == ERR_BUSY: set_child(mark, i)

	return result
