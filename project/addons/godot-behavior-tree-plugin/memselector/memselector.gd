extends BehaviorTreeBase

class_name BehaviorMemSelector

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
	var result: int = FAILED
	var count: int = get_child_count()
	var i: int = mark.blackboard.get_value("runningChild", mark.tree, self) - 1

	while i < count and result == FAILED:
		i+= 1
		result = get_child(i)._execute(tick)

	if result == ERR_BUSY: set_child(mark, i)

	return OK if count == 0 else result
